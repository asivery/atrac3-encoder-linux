# PSP ATRAC3(/3plus) Encoder for Linux

This application is meant to modify an ATRAC3 encoder (psp_at3tool.exe), and derive a native Linux ELF from it.
To run this, you need to:

- **Supply your own psp_at3tool.exe**
- Install an i386 version of libc6\*
- Run the 'convert.sh' bash script - a `psp_at3tool.exe.elf` file will be generated

\*To do this on Ubuntu, execute the following commands:
```
# dpkg --add-architecture i386
# apt update
# apt install libc6:i386 libc6-dev:i386
```

