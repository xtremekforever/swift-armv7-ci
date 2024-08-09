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

Using the files generated from the CI runs or release files, SDKs can be assembled.
