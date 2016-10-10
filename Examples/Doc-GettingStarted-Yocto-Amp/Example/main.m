#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_current.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number> ");
    NSLog(@"       demo <logical_name>");
    NSLog(@"       demo any                 (use any discovered device)");
    exit(1);
}

int main(int argc, const char * argv[])
{
    NSError     *error;
    YCurrent    *sensor;
    YCurrent    *sensorAC;
    YCurrent    *sensorDC;
    YModule     *m;

    if (argc < 2) {
        usage();
    }

    @autoreleasepool {
        NSString *target = [NSString stringWithUTF8String:argv[1]];

        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@",[error localizedDescription]);
            return 1;
        }

        if ([target isEqualToString:@"any"]) {
            // retreive any current sensor (can be AC or DC)
            sensor = [YCurrent FirstCurrent];
            if (sensor==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            sensor = [YCurrent FindCurrent:[target stringByAppendingString:@".current1"]];
        }

        // we need to retreive both DC and AC current from the device.
        if ([sensor isOnline])  {
            m = [sensor module];
            sensorDC = [YCurrent FindCurrent:[m.serialNumber stringByAppendingString:@".current1"]];
            sensorAC = [YCurrent FindCurrent:[m.serialNumber stringByAppendingString:@".current2"]];
        } else {
            NSLog(@"No module connected (check USB cable)");
            return 1;
        }
        while(1) {
            if (![m isOnline]) {
                NSLog(@"No module connected (check identification and USB cable)");
                return 1;
            }
            NSLog(@"Current   DC : %f mA",[sensorDC currentValue]);
            NSLog(@"          AC : %f mA",[sensorAC currentValue]);
            NSLog(@"  (press Ctrl-C to exit)");
            [YAPI Sleep:1000:NULL];
        }
        [YAPI FreeAPI];
    }
    return 0;
}
