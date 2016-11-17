#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_voltage.h"

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
  YVoltage    *sensor;
  YVoltage    *sensorAC;
  YVoltage    *sensorDC;
  YModule     *m;

  if (argc < 2) {
    usage();
  }

  @autoreleasepool {
    NSString *target = [NSString stringWithUTF8String:argv[1]];

    // Setup the API to use local USB devices
    if ([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    if ([target isEqualToString:@"any"]) {
      // retreive any voltage sensor (can be AC or DC)
      sensor = [YVoltage FirstVoltage];
      if (sensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      sensor = [YVoltage FindVoltage:[target stringByAppendingString:@".voltage1"]];
    }

    // we need to retreive both DC and AC voltage from the device.
    if ([sensor isOnline])  {
      m = [sensor module];
      sensorDC = [YVoltage FindVoltage:[m.serialNumber stringByAppendingString:@".voltage1"]];
      sensorAC = [YVoltage FindVoltage:[m.serialNumber stringByAppendingString:@".voltage2"]];
    } else {
      NSLog(@"No module connected (check USB cable)");
      return 1;
    }
    while(1) {
      if (![m isOnline]) {
        NSLog(@"No module connected (check identification and USB cable)");
        return 1;
      }
      NSLog(@"Voltage,  DC : %f v", [sensorDC currentValue]);
      NSLog(@"          AC : %f v", [sensorAC currentValue]);
      NSLog(@"  (press Ctrl-C to exit)");
      [YAPI Sleep:1000:NULL];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
