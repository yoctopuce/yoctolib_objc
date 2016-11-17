#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_humidity.h"
#import "yocto_temperature.h"
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

    NSString *target = [NSString stringWithUTF8String:argv[1]];
    YHumidity    *hsensor;
    YTemperature *tsensor;
    YPressure    *psensor;

    if([target isEqualToString:@"any"]) {
      hsensor = [YHumidity FirstHumidity];
      tsensor = [YTemperature FirstTemperature];
      psensor = [YPressure FirstPressure];
      if (hsensor == NULL || tsensor == NULL || psensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      hsensor = [YHumidity FindHumidity:[target stringByAppendingString:@".humidity"]];
      tsensor = [YTemperature FindTemperature:[target stringByAppendingString:@".temperature"]];
      psensor = [YPressure FindPressure:[target stringByAppendingString:@".pressure"]];
    }
    while(1) {
      if(![hsensor isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }
      NSLog(@"Current humidity:    %f %%RH\n", [hsensor get_currentValue]);
      NSLog(@"Current temperature: %f C\n",    [tsensor get_currentValue]);
      NSLog(@"Current pressure:    %f hPa\n",  [psensor get_currentValue]);

      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }

  return 0;
}
