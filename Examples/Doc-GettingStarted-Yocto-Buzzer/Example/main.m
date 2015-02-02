#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_buzzer.h"
#import "yocto_anbutton.h"
#import "yocto_led.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number>");
    NSLog(@"       demo <logical_name>");
    NSLog(@"       demo any (use any discovered device)");
    exit(1);
}


int main(int argc, const char * argv[])
{
    if (argc < 2) {
        usage();
    }

    @autoreleasepool {
        NSError *error;
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];
        YBuzzer  *buz;
        YLed    *led1, *led2 ,*led;
        YAnButton *button1, *button2;

        if ([target isEqualToString:@"any"]) {
            buz =  [YBuzzer FirstBuzzer];
            if (buz == NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        }else{
            buz = [YBuzzer FindBuzzer:target];
        }
        if (![buz isOnline]) {
            NSLog(@"Module not connected (check identification and USB cable)");
        }

        int frequency = 1000;
        NSString *serial = [[buz module] serialNumber];
        led1      = [YLed FindLed:[serial stringByAppendingString:@".led1"]];
        led2      = [YLed FindLed:[serial stringByAppendingString:@".led2"]];
        button1   = [YAnButton FindAnButton:[serial stringByAppendingString:@".anButton1"]];
        button2   = [YAnButton FindAnButton:[serial stringByAppendingString:@".anButton2"]];

        NSLog(@"press a test button or hit Ctrl-C");
        while (1) {
            int b1 = [button1 isPressed];
            int b2 = [button2 isPressed];
            if (b1 || b2 ) {
                if (b1) {
                    led = led1;
                    frequency = 1500;
                } else {
                    led = led2;
                    frequency = 500;
                }
                [led set_power:Y_POWER_ON];
                [led set_luminosity:100];
                [led set_blinking:Y_BLINKING_PANIC];
                for (int i = 0; i < 5; i++) {
                    // this can be done using sequence as well
                   [buz set_frequency:frequency];
                   [buz freqMove:2 * frequency :250];
                   [YAPI Sleep:250  :&error];
                }
                [buz set_frequency:0];
                [led set_power:Y_POWER_OFF];
            }
        }
    }
    return 0;
}
