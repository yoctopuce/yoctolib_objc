#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_serialport.h"


int main(int argc, const char * argv[])
{
    NSError *error;
    char cmd[50] = {0};

    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }

        YSerialPort *serialPort;
        if (argc > 1) {
            NSString     *target = [NSString stringWithUTF8String:argv[1]];
            serialPort = [YSerialPort FindSerialPort:target];
        } else {
            serialPort = [YSerialPort FirstSerialPort];
            if (serialPort == NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        }


        int slave, reg, val;
        do {
            NSLog(@"Please enter the MODBUS slave address (1...255)");
            NSLog(@"Slave: ");
            fgets(cmd,sizeof(cmd), stdin);
            slave = atoi(cmd);
        } while(slave < 1 || slave > 255);
        do {
            NSLog(@"Please select a Coil No (>=1), Input Bit No (>=10001+),");
            NSLog(@"       Register No (>=30001) or Input Register No (>=40001)");
            NSLog(@"No: ");
            fgets(cmd,sizeof(cmd), stdin);
            reg = atoi(cmd);
        } while(reg < 1 || reg >= 50000 || (reg % 10000) == 0);
        while(true) {
            if(reg >= 40001) {
                val = (int)[[[serialPort modbusReadInputRegisters:slave :reg - 40001 :1] objectAtIndex:0] integerValue];
            } else if(reg >= 30001) {
                val = (int)[[[serialPort modbusReadRegisters:slave :reg - 30001 :1] objectAtIndex:0] integerValue];
            } else if(reg >= 10001) {
                val = (int)[[[serialPort modbusReadInputBits:slave :reg - 10001 :1] objectAtIndex:0] integerValue];
            } else {
                val = (int)[[[serialPort modbusReadBits:slave :reg - 1 :1] objectAtIndex:0] integerValue];
            }
            NSLog(@"Current value: %d" ,val );
            NSLog(@"Press R to read again, Q to quit");
            if((reg % 30000) < 10000) {
                NSLog(@" or enter a new value");
            }
            NSLog(@": ");
            fgets(cmd,sizeof(cmd), stdin);
            if(cmd[0] == 'q' || cmd[0] == 'Q') break;
            if (cmd[0] != 'r' && cmd[0] != 'R' && (reg % 30000) < 10000) {
                val = atoi(cmd);
                if(reg >= 30001) {
                    [serialPort modbusWriteRegister:slave :reg - 30001 :val];
                } else {
                    [serialPort modbusWriteBit:slave :reg - 1 :val];
                }
            }
        }
        [YAPI FreeAPI];
    }
    return 0;
}
