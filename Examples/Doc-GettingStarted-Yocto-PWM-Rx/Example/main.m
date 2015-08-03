#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_pwmInput.h"


static void usage(void)
{
    NSLog(@"usage: demo <serial_number>");
    NSLog(@"       demo <logical_name>");
    NSLog(@"       demo any (use any discovered device)");
    exit(1);
}


int main(int argc, const char * argv[])
{
    NSError *error;

    if (argc < 2) {
        usage();
    }

    @autoreleasepool{
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];

        if ([target isEqualToString:@"any"]) {
            YPwmInput *pwminput = [YPwmInput FirstPwmInput];
            if (pwminput==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
            target = [[pwminput module] serialNumber];
        }

        YPwmInput *pwmInput1 = [YPwmInput FindPwmInput:
            [target stringByAppendingString:@".pwmInput1"]];
        YPwmInput *pwmInput2 = [YPwmInput FindPwmInput:
            [target stringByAppendingString:@".pwmInput2"]];

        while  ([pwmInput1 isOnline]) {
            NSLog(@"PWM1 : %f Hz %f %% %ld pulses",
                [pwmInput1 get_frequency], [pwmInput1 get_dutyCycle],
                [pwmInput1 get_pulseCounter]);
            NSLog(@"PWM2 : %f Hz %f %% %ld pulses",
                [pwmInput2 get_frequency], [pwmInput2 get_dutyCycle],
                [pwmInput2 get_pulseCounter]);
            NSLog(@"  (press Ctrl-C to exit)");
            [YAPI Sleep:1000 :&error];
        }
        NSLog(@"Module disconnected");
        [YAPI FreeAPI];
    }
    return 0;
}
