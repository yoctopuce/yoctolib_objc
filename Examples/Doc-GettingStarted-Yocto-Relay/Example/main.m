#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_relay.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number>  [ A | B ]");
    NSLog(@"       demo <logical_name> [ A | B ]");
    NSLog(@"       demo any [ A | B ]                (use any discovered device)");
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
        NSString *state  = [NSString stringWithUTF8String:argv[2]];
        YRelay   *relay;

        if ([target isEqualToString:@"any"]) {
            relay =  [YRelay FirstRelay];
            if (relay==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            relay =  [YRelay FindRelay:[target stringByAppendingString:@".relay1"]];
        }
        if ([relay isOnline]) {
            if ([state isEqualToString:@"A"])
                [relay set_state:Y_STATE_A];
            else
                [relay set_state:Y_STATE_B];
        } else {
            NSLog(@"Module not connected (check identification and USB cable)\n");
        }
        [YAPI FreeAPI];
    }
    return 0;
}
