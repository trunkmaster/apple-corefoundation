# CoreFoundation for Linux

This repository contains a basic port of CoreFoundation to Linux, with bridging support enabled.

The bridging is to GNUstep-base.

## Dependencies

* A GNUstep which uses libobjc2 and libdispatch
  * [libobjc2 (GNUstep Next-Generation Objective-C 2.0 Runtime)](https://github.com/gnustep/libobjc2)
  * [GNUstep Makefiles Library](https://github.com/gnustep/tools-make)
  * [GNUstep-base (Foundation Kit)](https://github.com/gnustep/libs-base)
* [libdispatch (Grand Central Dispatch)](https://github.com/apple/swift-corelibs-libdispatch)
* `libxml2` (this is also an optional dependency of GNUstep-base, please install it before building Base)
* `libicu` (this is also an optional dependency of GNUstep-base, please install it before building Base)

### Debian

```bash
# TODO - run the GNUstep installation script

sudo apt install libxml2 libxml2-dev libicu-dev
```

### Dependencies for test suite

We also need XCTest.

* [tools-xctest](https://github.com/gnustep/tools-xctest)

```bash
git clone https://github.com/gnustep/tools-xctest
cd tools-xctest
make
sudo -E make install
```

## Building

```bash
make clean
make
sudo -E make install
```

## Running tests

```bash
make
cd Tests/Local/Bridging
make
make check
```

## Maintenance

```bash
rename "s/\.c/\.m/" *.c
```

### Adding a new header

```bash
ln -s ../../$header_location Headers/CoreFoundation/$header_name
```