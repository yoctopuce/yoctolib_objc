#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_pwmoutput.h"


static void usage(void)
{
    NSLog(@"usage: demo <serial_number>  <frequency> <dutyCycle>");
    NSLog(@"       demo <logical_name> <frequency> <dutyCycle>");
    NSLog(@"       demo any <frequency> <dutyCycle> (use any discovered device)");
    NSLog(@"       <frequency>: integer between 1Hz and 1000000Hz");
    NSLog(@"       <dutyCycle>: floating point number between 0.0 and 100.0");
    exit(1);
}


int main(int argc, const char * argv[])
{
    NSError *error;

    if (argc < 4) {
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
            YPwmOutput *pwmoutput = [YPwmOutput FirstPwmOutput];
            if (pwmoutput==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
            target = [[pwmoutput module] serialNumber];
        }

        YPwmOutput *pwmoutput1 = [YPwmOutput FindPwmOutput:
                                  [target stringByAppendingString:@".pwmOutput1"]];
        YPwmOutput *pwmoutput2 = [YPwmOutput FindPwmOutput:
                                  [target stringByAppendingString:@".pwmOutput2"]];

        int frequency = (int) atol(argv[2]);
        int dutyCycle =  atof(argv[3]);

        if ([pwmoutput1 isOnline]) {
            // output 1 : immediate change
            [pwmoutput1 set_frequency:frequency];
            [pwmoutput1 set_enabled:Y_ENABLED_TRUE];
            [pwmoutput1 set_dutyCycle:dutyCycle];
            // output 2 : smooth change
            [pwmoutput2 set_frequency:frequency];
            [pwmoutput2 set_enabled:Y_ENABLED_TRUE];
            [pwmoutput2 dutyCycleMove:dutyCycle :3000];
        } else {
            NSLog(@"Module not connected (check identification and USB cable)\n");
        }
        [YAPI FreeAPI];
    }
    return 0;
}
