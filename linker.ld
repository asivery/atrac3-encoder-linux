start = 0x00600000;
ENTRY(start)
OUTPUT_FORMAT("elf32-i386")
SECTIONS {
    .text 0x00401000 :
    {
        INCLUDE "text.ld";
    }
    .rdata 0x00451000 :
    {
        INCLUDE "rdata.ld";
    }
    .data 0x004bd000 :
    {
        INCLUDE "data.ld";
    }
    .bstext 0x00600000 :
    {
        *(.bstext*)
    }
    .redir 0x00610000 :
    {
        *(.redir*)
    }
    .extensions 0x00620000 :
    {
        *(.extensions*)
    }
}
