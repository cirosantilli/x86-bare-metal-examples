/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-hello-world */

#include "common.h"
BEGIN
    DBG
   mov $0x00, %ah// Initialize COM port
   mov $0xe3, %al// Initialization value
   mov $0x00, %dx// Port number
   int $0x14
   mov $0x68, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x65, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x6c, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x6c, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x6f, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x20, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x77, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x6f, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x72, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x6c, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x64, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14
   mov $0x21, %al//Character to send 'a'
   mov $0x01, %ah//Send value 
   int $0x14

