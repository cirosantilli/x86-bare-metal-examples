# NASM

If you're into that sort of thing:

    sudo apt-get install nasm
    make run

While NASM is a bit more convenient than GAS to write a boot sector, I think it is just not worth it.

When writing an OS in C, we are going to use GCC, which already uses GAS. So it's better to reduce the number of assemblers to one and stick to GAS only.
