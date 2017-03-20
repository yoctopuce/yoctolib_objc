#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_rangefinder.h"
#import "yocto_lightsensor.h"
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
    NSString *target = [NSString stringWithUTF8String:argv[1]];
    YRangeFinder *rf;
    YLightSensor *ir;
    YTemperature *tmp;
    if ([target isEqualToString:@"any"]) {
      rf = [YRangeFinder FirstRangeFinder];
      if (rf == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      rf = [YRangeFinder FindRangeFinder:[target stringByAppendingString:@".rangeFinder1"]];
    }

    if (![rf isOnline]) {
      NSLog(@"Module not connected (check identification and USB cable)");
    }

    NSString *serial = [[rf module] serialNumber];
    ir = [YLightSensor FindLightSensor:
          [serial stringByAppendingString:@".lightSensor1"]];
    tmp = [YTemperature FindTemperature:
           [serial stringByAppendingString:@".temperature1"]];

    while(1) {
      if(![rf isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }
      NSLog(@"Distance    : %f\n", [rf get_currentValue]);
      NSLog(@"Ambiant IR  : %f\n", [ir get_currentValue]);
      NSLog(@"Temperature : %f\n", [tmp get_currentValue]);
      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
