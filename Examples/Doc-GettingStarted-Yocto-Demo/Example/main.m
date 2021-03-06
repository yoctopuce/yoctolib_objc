/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-Demo
 *
 *  You can find more information on our web site:
 *   Yocto-Demo documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-demo/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_led.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>  [ on | off ]");
  NSLog(@"       demo <logical_name> [ on | off ]");
  NSLog(@"       demo any [ on | off ]                (use any discovered device)");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError *error;
  if(argc < 3) {
    usage();
  }

  @autoreleasepool {
    NSString *target = [NSString stringWithUTF8String:argv[1]];
    NSString *on_off = [NSString stringWithUTF8String:argv[2]];
    YLed     *led;

    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    if([target isEqualToString:@"any"]) {
      led =  [YLed FirstLed];
    } else {
      led =  [YLed FindLed:[target stringByAppendingString:@".led"]];
    }
    if ([led isOnline]) {
      if ([on_off isEqualToString:@"on"])
        [led set_power:Y_POWER_ON];
      else
        [led set_power:Y_POWER_OFF];
    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }
  return 0;
}
