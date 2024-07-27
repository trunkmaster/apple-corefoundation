# TODO

* [ ] Rebase on newer CoreFoundation
  * We're currently based on [swift-5.3-RELEASE](https://github.com/apple/swift-corelibs-foundation/tree/swift-5.3-RELEASE), based on the [Catalina source code](https://github.com/apple/swift-corelibs-foundation/pull/2787), with [release notes here](https://github.com/apple/swift-corelibs-foundation/pull/2782) (CoreFoundation versions 1665.15~1677.104)
  * We could update to [swift-5.9.2-RELEASE](https://github.com/apple/swift-corelibs-foundation/tree/swift-5.9.2-RELEASE), based on the [Monterey source code](https://github.com/apple/swift-corelibs-foundation/pull/3058). (CoreFoundation versions 1854~)
  * We could update to Ventura, with code in [this PR](https://github.com/apple/swift-corelibs-foundation/pull/4633) and buildfixes in [this PR](https://github.com/apple/swift-corelibs-foundation/pull/4648) (CoreFoundations version 1946.10~)
    * Ventura hasn't been merged in more than a year.
  * Any of these rebases would be major changes and may require restarting the project.
* [ ] Bring back CFXML classes, which were removed in [Catalina](https://github.com/apple/swift-corelibs-foundation/pull/2782)
* [x] Implement CFFileDescriptor
  * We're using <https://github.com/PureDarwin/CoreFoundation/blob/master/CoreFoundation/Stream.subproj/CFFileDescriptor.c>
  * [ ] Contact authors to confirm licensing
* [ ] Implement CFNotificationCenter
  * We're using <https://github.com/PureDarwin/CoreFoundation/blob/master/CoreFoundation/AppServices.subproj/CFNotificationCenter.c>
  * [ ] Contact authors to confirm licensing
* [ ] Look at <https://github.com/PureDarwin/CoreFoundation> to make sure we finished implementing bridging.
* [x] Set `kCFCoreFoundationVersionNumber` to 1690
  * [ ] Write a test case for this
* [ ] Write a test suite
* [ ] Get the CoreBase tests to pass