# Swift for ARMv7 CI (Continous Integration)

Swift is able to be built for armv7 fairly easily starting with Swift 5.10, but patches are still required. I created a guide on how to build it using the buildbot profile I created here:

 - [Cross Compiling Swift 5.10.1 for Linux ARMv7](https://medium.com/@jesselzamora/cross-compiling-swift-5-10-1-for-linux-armv7-b15986c0f1bf)

I've been working on getting these patches and buildbot profile into Swift officially, but it is unknown if these will be accepted at all in the near future.

Until then my goal is to use this unofficial CI to build Swift 5.10 and beyond for armv7, and provide build artifacts that are easily downloadable by anyone who needs it. The idea to start will be to target various Ubuntu and Debian versions for armhf (armv7), which seem to be used commonly on the Raspberry Pi, which is what these builds will target. 

These builds _only_ target armv7- if you need aarch64 builds for the Raspberry Pi, look no further than getting the official distributions for aarch64 from [swift.org](https://www.swift.org/download/) or use the packages from the [community-driven deb repository](https://www.swift-arm.com/installSwift).

## Scope of Builds

Since it is currently not possible to build the entire Swift toolchain for armv7 due to various build errors and roadblocks in the compilation without more significant patching, only cross compilation toolchains are built as part of this CI project. It's possible that in the future more could be added as fixes are found and created, but for now only the following libraries are built:

- stdlib
- libdispatch
- foundation
- xctest

Using the files generated from the CI runs or release files, cross-compilation SDKs can be assembled.

## Using Built Libraries

The libraries built as part of the CI are relatively simple to deploy to the target, be it a Raspberry Pi or another armv7 device that runs any of the supported distributions. To deploy and install Swift to the target, first download the install *.tar.gz file either from a workflow run or from the release page. Then, deploy it to the target using scp:

```bash
scp <swift-tag>-<distribution>-armv7-install.tar.gz user@192.168.0.123:~
```

SSH into the target and extract the file into the filesystem:

```bash
sudo tar -xf <swift-tag>-<distribution>-armv7-install.tar.gz -C /
```

Then, you should be able to run any Swift binary that was cross compiled using the generated SDK.

## Cross Compilation SDKs

This CI will generate old-style SDKs that use a `destination.json` style of file, like this:

```json
{
    "version":1,
    "sdk":"/path/to/swift-5.10.1-RELEASE-debian-bookworm-armv7/sysroot",
    "toolchain-bin-dir":"/usr/bin",
    "target":"armv7-unknown-linux-gnueabihf",
    "dynamic-library-extension":"so",
    "extra-cc-flags":[
       "-fPIC"
    ],
    "extra-swiftc-flags":[
       "-target", "armv7-unknown-linux-gnueabihf",
       "-use-ld=lld",
       "-Xlinker", "-rpath", "-Xlinker", "/usr/lib/swift/linux",
       "-Xlinker", "-rpath", "-Xlinker", "/usr/lib/swift/linux/armv7",
       "-resource-dir", "/path/to/swift-5.10.1-RELEASE-debian-bookworm-armv7/usr/lib/swift",
       "-sdk", "/path/to/swift-5.10.1-RELEASE-debian-bookworm-armv7/sysroot",
       "-Xcc", "--gcc-toolchain=/path/to/swift-5.10.1-RELEASE-debian-bookworm-armv7/sysroot/usr"
    ],
    "extra-cpp-flags":[
    ]
}
```

These SDKs work but they have a few main limitations:

 - You must use the exact version of Swift that the SDK is built with to cross compile from the host. Any mismatch in versions will result in compilation failures.
 - The SDKs must be installed to a static location, and all the paths in `destination.json` must point to this static location for it to work.
 - Adding/installing more libraries into the SDK sysroot is more inflexible. It should be able to be done using a chroot and qemu, but is still complex to achieve and more difficult to replicate.

The [swift-sdk-generator](https://github.com/swiftlang/swift-sdk-generator) project creates new-style SDKs that should solve these issues, but it is currently only compatible with macOS and is not suited to generate SDKs for unofficial Swift builds at the moment. In the future this should be updated to support more options, but for now it cannot be used without additional patching.

Regardless of this, the SDKs are very usable. In order to use one of the built SDKs, download an SDK *.tar.gz either from a workflow run or the releases page, then install it like this:

```bash
sudo tar -xf <swift-tag>-<distribution>-armv7-sdk.tar.gz -C /opt
```

Then, you can cross compile any SwiftPM app using the `--destination` param:

```bash
swift build --destination /opt/<swift-tag>-<distribution>-armv7/<distribution>.json
```
