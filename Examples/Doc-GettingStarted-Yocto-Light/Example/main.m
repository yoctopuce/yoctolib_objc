#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_lightsensor.h"

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
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];
        YLightSensor *sensor;
        if ([target isEqualToString:@"any"]) {
            sensor = [YLightSensor FirstLightSensor];
            if (sensor==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            sensor = [YLightSensor FindLightSensor:[target stringByAppendingString:@".lightSensor"]];
        }
        while(1) {
            if(![sensor isOnline]) {
                NSLog(@"Module not connected (check identification and USB cable)\n");
                break;
            }

            NSLog(@"Current ambient light: %f lx\n", [sensor get_currentValue]);
            NSLog(@"  (press Ctrl-C to exit)\n");
            [YAPI Sleep:1000:NULL];
        }
        [YAPI FreeAPI];
    }
    return 0;
}
