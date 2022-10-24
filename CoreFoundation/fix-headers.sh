for header in ${PWD}/*.subproj/*.h; do
    rm $header
    cp Headers/CoreFoundation/${header##*.subproj/} $header
    rm Headers/CoreFoundation/${header##*.subproj/}
    ln -s $header ${PWD}/Headers/CoreFoundation/${header##*.subproj}
done