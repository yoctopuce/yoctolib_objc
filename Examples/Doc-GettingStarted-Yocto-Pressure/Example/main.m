/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that show how to use a  Yocto-Pressure
 *
 *  You can find more information on our web site:
 *   Yocto-Pressure documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-pressure/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_pressure.h"

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
    YPressure *psensor;
    if ([target isEqualToString:@"any"]) {
      psensor = [YPressure FirstPressure];
      if (psensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      psensor = [YPressure FindPressure:[target stringByAppendingString:@".pressure"]];
    }

    while(1) {
      if(![psensor isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }

      NSLog(@"Current pressure: %f C\n", [psensor get_currentValue]);
      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
