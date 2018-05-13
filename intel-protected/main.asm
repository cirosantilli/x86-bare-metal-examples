NAME main_module
data SEGMENT RW
    dw 1000 dup(?)
DATA ENDS
stack stackseg 800
CODE SEGMENT ER use32 PUBLIC
main_start:
    nop
    nop
    nop
CODE ENDS
END main_start, ds:data, ss:stack
