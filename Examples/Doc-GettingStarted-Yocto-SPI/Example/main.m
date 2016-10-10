#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_spiport.h"


static void usage(void)
{
    NSLog(@"usage: demo <serial_number> <value>");
    NSLog(@"       demo <logical_name>  <value>");
    NSLog(@"       demo any <value> (use any discovered device)");
    exit(1);
}


int main(int argc, const char * argv[])
{
    NSError *error;

    if (argc < 3) {
        usage();
    }

    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];

        if ([target isEqualToString:@"any"]) {
            YSpiPort *spiPort = [YSpiPort FirstSpiPort];
            if (spiPort==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
            target = [[spiPort module] serialNumber];
        }

        YSpiPort *spiPort = [YSpiPort FindSpiPort:
                             [target stringByAppendingString:@".spiPort"]];

        int value = (int) atol(argv[2]);

        if ([spiPort isOnline]) {
            [spiPort set_spiMode:@"250000,2,msb"];
            [spiPort set_ssPolarity:Y_SSPOLARITY_ACTIVE_LOW];
            [spiPort set_protocol:@"Frame:5ms"];
            [spiPort reset];
            NSLog(@"****************************");
            NSLog(@"* make sure voltage levels *");
            NSLog(@"* are properly configured  *");
            NSLog(@"****************************");

            [spiPort writeHex:@"0c01"]; // Exit from shutdown state
            [spiPort writeHex:@"09ff"]; // Enable BCD for all digits
            [spiPort writeHex:@"0b07"]; // Enable digits 0-7 (=8 in total)
            [spiPort writeHex:@"0a0a"]; // Set medium brightness
            for(int i = 1; i <= 8; i++) {
                NSNumber *position = [NSNumber numberWithLong:i];
                NSNumber *digit = [NSNumber numberWithInt:value % 10];
                [spiPort writeArray: [NSMutableArray arrayWithObjects:position, digit, nil]];
                value = value / 10;
            }
        } else {
            NSLog(@"Module not connected (check identification and USB cable)\n");
        }
        [YAPI FreeAPI];
    }
    return 0;
}
