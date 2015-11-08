target remote localhost:1234
set architecture i8086
# These would be possible. But they break the UI too much...
#layout asm
#layout regs

define hook-stop
    info registers
    printf "\n"
    x/16i $pc - 8
    printf "\n"
end

break *0x7c00
continue

# Magic address. Add a:
# mov %ax, 0x1234
# to your program to break there.
awatch *0x9000
commands
silent
printf "0x9000 awatch access debug break\n"
end
