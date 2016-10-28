#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_serialport.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSError *error;
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

        [serialPort set_serialMode:@"9600,8N1"];
        [serialPort set_protocol:@"Line"];
        [serialPort reset];

        NSLog(@"****************************");
        NSLog(@"* make sure voltage levels *");
        NSLog(@"* are properly configured  *");
        NSLog(@"****************************");

        NSString *line;
        do {
            char input[256] = {0};
            [YAPI Sleep:500 :&error];
            do {
                line = [serialPort readLine];
                if(![line isEqualToString:@""]) {
                    NSLog(@"Received: %@",line);
                }
            } while(![line isEqualToString:@""]);

            NSLog(@"Type line to send, or Ctrl-C to exit: ");
            fgets(input,sizeof(input), stdin);
            line = [NSString stringWithUTF8String:input];
            [serialPort writeLine:line];
        } while(![line isEqualToString:@"\n"]);

        [YAPI FreeAPI];
    }
    return 0;
}
