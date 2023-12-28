#!/bin/bash

mkdir -p Headers/CoreFoundation

if [[ "$1" == "-f" ]]; then
    FORCE=true
else
    FORCE=false
fi
for header in "${PWD}"/*.subproj/*.h; do
    echo "Processing $header"
    if [[ -r Headers/CoreFoundation/"${header##*.subproj/}" ]]; then
        if $FORCE; then
            rm Headers/CoreFoundation/"${header##*.subproj/}"
        else
            echo "Already exists"
            continue
        fi
    fi
    # cp Headers/CoreFoundation/"${header##*.subproj/}" "$header"
    # rm Headers/CoreFoundation/"${header##*.subproj/}"
    ln -s "../..${header##"${PWD}"}" "${PWD}"/Headers/CoreFoundation/"${header##*.subproj}"
done
