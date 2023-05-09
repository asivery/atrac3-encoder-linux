#!/bin/bash

FILE="psp_at3tool.exe"
VALID_SHA="823199113c59ffcd3fc3e1855dbb88a9cd44d29e82e7a7cfc42e8c92f2a61341"

shasum=$(sha256sum $FILE | awk '{print($1);}')

if [ $shasum != $VALID_SHA ]
then
    echo "SHA sum mismatch! You have the wrong encoder"
    echo "$shasum != $VALID_SHA"
    exit 1
fi

function getsize(){
    echo $((16#$(objdump -h $FILE | grep -F $1 | head -1 | awk '{print($3)}')))
}

function getoffset(){
    echo $((16#$(objdump -h $FILE | grep -F $1 | head -1 | awk '{print($6)}')))
}

dd if=$FILE bs=1 skip=$(getoffset .text) count=$(getsize .text) | hexdump -v -e '"BYTE(0x" 1/1 "%02X" ")\n"' > text.ld
dd if=$FILE bs=1 skip=$(getoffset .data) count=$(getsize .data) | hexdump -v -e '"BYTE(0x" 1/1 "%02X" ")\n"' > data.ld
dd if=$FILE bs=1 skip=$(getoffset .rdata) count=$(getsize .rdata) | hexdump -v -e '"BYTE(0x" 1/1 "%02X" ")\n"' > rdata.ld
for x in `seq 1 1 31870`
do
    echo 'BYTE(0x00)' >> data.ld
done

patch -p1 < sections.diff

nasm -f elf32 loader.S -o simple_loader.o
ld -o $FILE.elf -m elf_i386 -lc -lm -dynamic-linker /lib/ld-linux.so.2 -T linker.ld simple_loader.o -L/usr/lib/gcc/x86_64-linux-gnu/11/32 -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../i386-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../../lib32 -L/lib/i386-linux-gnu -L/lib/../lib32 -L/usr/lib/i386-linux-gnu -L/usr/lib/../lib32 -L/usr/lib/gcc/x86_64-linux-gnu/11 -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../i386-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/11/../../.. -L/lib/i386-linux-gnu -L/usr/lib/i386-linux-gnu

