C_FLAGS="-I/usr/local/include -I/usr/NextSpace/include -Wno-switch -Wno-enum-conversion"
cmake .. \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_C_FLAGS="${C_FLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="-L/usr/local/lib -L/usr/NextSpace/lib -luuid" \
        -DBUILD_SHARED_LIBS=YES \
        -DCMAKE_INSTALL_PREFIX=/usr/NextSpace \
        -DCMAKE_INSTALL_LIBDIR=/usr/NextSpace/lib \
        -DCMAKE_LIBRARY_PATH=/usr/NextSpace/lib \
        \
        -DCMAKE_SKIP_RPATH=ON \
        -DCMAKE_BUILD_TYPE=Debug \
        -Ddispatch_DIR=/Users/me/Developer/nextspace.FreeBSD/swift-corelibs-libdispatch/.build/cmake/modules
