ASM386 STARTUP.ASM
ASM386 MAIN.ASM
BLD386 STARTUP.OBJ, MAIN.OBJ buildfile(EPROM.BLD) bootstrap(STARTUP) Bootload
# BLD386 performs several operations in this example:
# It allocates physical memory location to segments and tables.
# It generates tables using the build file and the input files.
# It links object files and resolves references.
# It generates a boot-loadable file to be programmed into the EPROM.
