/* https://github.com/cirosantilli/x86-bare-metal-examples#apm */

#include "common.h"

BEGIN

movb $0x53,%ah        #this is an APM command
movb $0x0,%al         #installation check command
xorw %bx,%bx          #device id (0 = APM BIOS)
int $0x15             #call the BIOS function through interrupt 15h
jc APM_error          #if the carry flag is set there was an error
                      #the function was successful
                      #AX = APM version number
                          #AH = Major revision number (in BCD format)
                          #AL = Minor revision number (also BCD format)
                      #BX = ASCII characters "P" (in BH) and "M" (in BL)
                      #CX = APM flags (see the official documentation for more details)

#disconnect from any APM interface
movb $0x53,%ah           #this is an APM command
movb $0x4,%al            #interface disconnect command
xorw %bx,%bx             #device id (0 = APM BIOS)
int $0x15                #call the BIOS function through interrupt 15h
jc .disconnect_error            #if the carry flag is set see what the fuss is about. 
jmp .no_error

.disconnect_error:        #the error code is in ah.
cmpb $0x3,%ah            #if the error code is anything but 03h there was an error.
jne APM_error            #the error code 03h means that no interface was connected in the first place.

.no_error:
                         #the function was successful
                         #Nothing is returned.

#connect to an APM interface
movb $0x53,%ah           #this is an APM command
movb $0x01,%al           #see above description
xorw %bx,%bx             #device id (0 = APM BIOS)
int $0x15                #call the BIOS function through interrupt 15h
jc APM_error             #if the carry flag is set there was an error
                         #the function was successful
                         #The return values are different for each interface.
                         #The Real Mode Interface returns nothing.
                         #See the official documentation for the 
                         #return values for the protected mode interfaces.

#Enable power management for all devices
movb $0x53,%ah          #this is an APM command
movb $0x8,%al           #Change the state of power management...
movw $0x001,%bx         #...on all devices to...
movw $0x001,%cx         #...power management on.
int $0x15               #call the BIOS function through interrupt 15h
jc APM_error            #if the carry flag is set there was an error

#Set the power state for all devices
movb $0x53,%ah          #this is an APM command
movb $0x07,%al          #Set the power state...
movw $0x0001,%bx        #...on all devices to...
movw $0x0003,%cx        #see above
int $0x15               #call the BIOS function through interrupt 15h
jc APM_error            #if the carry flag is set there was an error

APM_error:
hlt
