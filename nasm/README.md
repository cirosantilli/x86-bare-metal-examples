# NASM

While NASM is a bit more convenient than GAS to write a boot sector, I think it is just not worth it.

When writing an OS in C, we are going to use GCC, which already uses GAS. So it's better to reduce the number of assemblers to one and stick to GAS only.

Right now, this directory is not very DRY since NASM is secondary to me, so it contains mostly some copy / paste examples.
