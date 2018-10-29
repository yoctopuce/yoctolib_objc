/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-Watt
 *
 *  You can find more information on our web site:
 *   Yocto-Watt documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-watt/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_power.h"

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
    YPower *psensor;
    if ([target isEqualToString:@"any"]) {
      psensor = [YPower FirstPower];
      if (psensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      psensor = [YPower FindPower:[target stringByAppendingString:@".power"]];
    }

    while(1) {
      if(![psensor isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }

      NSLog(@"Current Power: %f W\n", [psensor get_currentValue]);
      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
