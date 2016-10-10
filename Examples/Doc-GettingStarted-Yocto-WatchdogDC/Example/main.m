#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_watchdog.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number>  [ on | off | reset]");
    NSLog(@"       demo <logical_name> [ on | off | reset]");
    NSLog(@"       demo any [ on | off | reset]                (use any discovered device)");
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
        if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];
        NSString *state  = [NSString stringWithUTF8String:argv[2]];
        YWatchdog   *watchdog;

        if ([target isEqualToString:@"any"]) {
            watchdog =  [YWatchdog FirstWatchdog];
            if (watchdog==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            watchdog =  [YWatchdog FindWatchdog:[target stringByAppendingString:@".watchdog1"]];
        }
        if ([watchdog isOnline]) {
            if ([state isEqualToString:@"on"])
                [watchdog set_running:Y_RUNNING_ON];
            if ([state isEqualToString:@"off"])
                [watchdog set_running:Y_RUNNING_OFF];
            if ([state isEqualToString:@"reset"])
                [watchdog resetWatchdog];
        } else {
            NSLog(@"Module not connected (check identification and USB cable)\n");
        }
        [YAPI FreeAPI];
    }
    return 0;
}
