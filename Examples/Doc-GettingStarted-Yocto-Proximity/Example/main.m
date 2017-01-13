#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_proximity.h"
#import "yocto_lightsensor.h"

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
    YProximity *proximity;
    YLightSensor *ambiant, *ir;
    if ([target isEqualToString:@"any"]) {
      proximity = [YProximity FirstProximity];
      if (proximity == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      proximity = [YProximity FindProximity:[target stringByAppendingString:@".proximity1"]];
    }






    if (![proximity isOnline]) {
      NSLog(@"Module not connected (check identification and USB cable)");
    }

    NSString *serial = [[proximity module] serialNumber];
    ambiant = [YLightSensor FindLightSensor:
               [serial stringByAppendingString:@".lightSensor1"]];
    ir = [YLightSensor FindLightSensor:
          [serial stringByAppendingString:@".lightSensor2"]];




    while(1) {
      if(![proximity isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)\n");
        break;
      }
      NSLog(@" Proximity: %f Ambient: %f IR: %f\n",
            [proximity get_currentValue], [ambiant get_currentValue],
            [ir get_currentValue]);
      NSLog(@"  (press Ctrl-C to exit)\n");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
