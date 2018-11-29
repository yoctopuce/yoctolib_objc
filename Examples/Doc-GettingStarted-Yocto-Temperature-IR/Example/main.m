/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that show how to use a  Yocto-Temperature-IR
 *
 *  You can find more information on our web site:
 *   Yocto-Temperature-IR documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-temperature-ir/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_temperature.h"

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
    YTemperature *tsensor, *tsensor2;
    if ([target isEqualToString:@"any"]) {
      tsensor = [YTemperature FirstTemperature];
      if (tsensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[tsensor get_module] get_serialNumber];
    }
    tsensor = [YTemperature FindTemperature:[target stringByAppendingString:
               @".temperature1"]];
    tsensor2 = [YTemperature FindTemperature:[target stringByAppendingString:
               @".temperature2"]];

    while(1) {
      if(![tsensor isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }

      NSLog(@"Ambiant temperature  : %f C\n", [tsensor get_currentValue]);
      NSLog(@"Infrared temperature : %f C\n", [tsensor2 get_currentValue]);
      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
