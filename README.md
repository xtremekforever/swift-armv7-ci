# Swift for ARMv7 CI (Continous Integration)

Swift is able to be built for armv7 fairly easily starting with Swift 5.10, but patches are still required. I created a guide on how to build it using the buildbot profile I created here:

 - [Cross Compiling Swift 5.10.1 for Linux ARMv7](https://medium.com/@jesselzamora/cross-compiling-swift-5-10-1-for-linux-armv7-b15986c0f1bf)

I've been working on getting these patches and buildbot profile into Swift 6.0 (possibly) or if not into a future release, but it is unknown if these will be accepted at all in the near future.

Until then my goal is to use this unofficial CI to build Swift 5.10 and beyond for armv7, and provide build artifacts that are easily downloadable by anyone who needs it. The idea to start will be to target various Ubuntu and Debian versions for armhf (armv7), which seem to be used commonly on the Raspberry Pi, which is what these builds will target. 

These builds _only_ target armv7- if you need aarch64 builds for the Raspberry Pi, look no further than getting the official distributions for aarch64 from [swift.org](https://www.swift.org/download/) or use the packages from the [community-driven deb repository](https://www.swift-arm.com/installSwift).

## Scope of Builds

Since it is currently not possible to build the entire Swift toolchain for armv7 due to various build errors and roadblocks in the compilation without more significant patching, only cross compilation toolchains are built as part of this CI project. It's possible that in the future more could be added as fixes are found and created, but for now only the following libraries are built:

- Swift stdlib
- libdispatch
- foundation
- xctest

Using the files generated from the CI runs or release files, cross-compilation SDKs can be assembled.

## Building an SDK

Although the [swift-sdk-generator](https://github.com/swiftlang/swift-sdk-generator) project can be used to generate cross-compilation toolchains, it is currently only compatible with macOS hosts. There is ongoing work to get it working for Linux hosts properly, but until then the cross-compilation SDKs can be generated manually and use the `destination.json` style of files.

First, start by extracting the Swift build and sysroot for the given distribution and placing them into a directory. For example, for `swift-5.10.1-RELEASE-debian-bookworm-armv7`, structure the directories as follows:

```
swift-5.10.1-RELEASE-debian-bookworm-armv7
├── sysroot
│   ├── lib -> usr/lib
│   └── usr
└── usr
    ├── bin
    ├── lib
    └── share
```

Then, create a destination.json file with the following contents:

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

Replace the `/path/to/` paths with the actual path where the SDK will be installed. Ideally this could be at `/opt` for example.
