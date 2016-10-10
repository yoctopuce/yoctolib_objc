#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_carbondioxide.h"


static void usage(void)
{
    NSLog(@"usage: demo <serial_number> ");
    NSLog(@"       demo <logical_name>");
    NSLog(@"       demo any                 (use any discovered device)");
    exit(1);
}

int main(int argc, const char * argv[])
{
    NSError *error;

    if (argc < 2) {
        usage();
    }

    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb":&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString     *target = [NSString stringWithUTF8String:argv[1]];
        YCarbonDioxide *co2sensor;
        if ([target isEqualToString:@"any"]) {
            co2sensor = [YCarbonDioxide FirstCarbonDioxide];
            if (co2sensor==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            co2sensor = [YCarbonDioxide FindCarbonDioxide:[target stringByAppendingString:@".carbonDioxide"]];
        }

        while(1) {
            if(![co2sensor isOnline]) {
                NSLog(@"Module not connected (check identification and USB cable)\n");
                break;
            }

            NSLog(@"CO2: %f ppm\n", [co2sensor currentValue]);
            NSLog(@"  (press Ctrl-C to exit)\n");
            [YAPI Sleep:1000:NULL];
        }
        [YAPI FreeAPI];
    }
    return 0;
}
