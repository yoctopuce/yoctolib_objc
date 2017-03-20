#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_gps.h"

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
    NSString     *target = [NSString stringWithUTF8String:argv[1]];
    YGps *gps;
    if ([target isEqualToString:@"any"]) {
      gps = [YGps FirstGps];
      if (gps == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      gps = [YGps FindGps:[target stringByAppendingString:@".gps"]];
    }

    while(1) {
      if(![gps isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }
      if([gps get_isFixed] != Y_ISFIXED_TRUE) {
        NSLog(@"fixing");
      } else {
        NSLog(@"%@ %@ \n", [gps get_latitude], [gps get_longitude]);
      }

      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
