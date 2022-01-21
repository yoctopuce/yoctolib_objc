/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-milliVolt-Rx
 *
 *  You can find more information on our web site:
 *   Yocto-milliVolt-Rx documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-millivolt-rx/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_genericsensor.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number> ");
  NSLog(@"       demo <logical_name>");
  NSLog(@"       demo any                 (use any discovered device)");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError     *error;
  YGenericSensor    *sensor, *sensor1;

  if (argc < 2) {
    usage();
  }

  @autoreleasepool {
    NSString *target = [NSString stringWithUTF8String:argv[1]];

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    if ([target isEqualToString:@"any"]) {
      // retreive any generic sensor
      sensor = [YGenericSensor FirstGenericSensor];
      if (sensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }

    } else {
      sensor = [YGenericSensor FindGenericSensor:target];
    }

    // we need to retreive both DC and AC current from the device.
    if (![sensor isOnline])  {
      NSLog(@"No module connected (check USB cable)");
      return 1;
    }
    YModule *m = [sensor module];
    sensor1 = [YGenericSensor FindGenericSensor:[m.serialNumber stringByAppendingString:
               @".genericSensor1"]];

    while([m isOnline]) {
      NSLog(@"Value: %f %@", [sensor1 currentValue], [sensor1 get_unit]);
      NSLog(@"  (press Ctrl-C to exit)");
      [YAPI Sleep:1000:NULL];
    }
    NSLog(@"Module not connected (check identification and USB cable)");
    [YAPI FreeAPI];
  }
  return 0;
}