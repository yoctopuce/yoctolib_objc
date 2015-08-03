#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_genericsensor.h"

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
    YGenericSensor    *sensor,*sensor1,*sensor2;
    
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
            // retreive any generic sensor 
            sensor = [YGenericSensor FirstGenericSensor];
            if (sensor==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            } 
                 
        } else {
            sensor = [YGenericSensor FindGenericSensor:target];
        }
    
        // we need to retreive both DC and AC current from the device.
        if (![sensor isOnline])  {            
            NSLog(@"No module connected (check USB cable)");
            return 1;
        }
        YModule          *m = [sensor module];
        sensor1 = [YGenericSensor FindGenericSensor:[m.serialNumber stringByAppendingString:@".genericSensor1"]];
        sensor2 = [YGenericSensor FindGenericSensor:[m.serialNumber stringByAppendingString:@".genericSensor2"]];

        while([m isOnline]) {
            NSLog(@"Channel 1 : %f %@",[sensor1 currentValue],[sensor1 get_unit]);
            NSLog(@"Channel 2 : %f %@",[sensor2 currentValue],[sensor2 get_unit]);
            NSLog(@"  (press Ctrl-C to exit)");
            [YAPI Sleep:1000:NULL];
        }
        NSLog(@"Module not connected (check identification and USB cable)");
    }
    return 0;
}