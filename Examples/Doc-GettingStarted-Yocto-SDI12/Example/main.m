/*********************************************************************
 *
 *  $Id: main.m 59884 2024-03-14 13:28:06Z mvuilleu $
 *
 *  Doc-GettingStarted-Yocto-SDI12 example
 *
 *  You can find more information on our web site:
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_sdi12port.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {
    NSError *error;
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    YSdi12Port *sdi12port;
    if (argc > 1) {
      NSString     *target = [NSString stringWithUTF8String:argv[1]];
      sdi12port = [YSdi12Port FindSdi12Port:target];
    } else {
      sdi12port = [YSdi12Port FirstSdi12Port];
      if (sdi12port == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    }
    [sdi12port reset];
    YSdi12SensorInfo *singleSensor = [sdi12port discoverSingleSensor];
    NSLog(@"Sensor address : %@", [singleSensor get_sensorAddress]);
    NSLog(@"Sensor SDI-12 compatibility : %@", [singleSensor get_sensorProtocol]);
    NSLog(@"Sensor company name : %@", [singleSensor get_sensorVendor]);
    NSLog(@"Sensor model number : %@", [singleSensor get_sensorModel]);
    NSLog(@"Sensor version : %@", [singleSensor get_sensorVersion]);
    NSLog(@"Sensor serial number : %@", [singleSensor get_sensorSerial]);
    NSMutableArray* valSensor = [sdi12port  readSensor:[singleSensor get_sensorAddress] :
                                 @"M" :5000];
    for (int i = 0 ; i < [valSensor count]; i++) {
      if ([singleSensor get_measureCount] > 1) {
        NSLog(@"%@ %f%@ (%@) \n", [singleSensor get_measureSymbol :i], [[valSensor objectAtIndex:
              i] doubleValue],
              [singleSensor get_measureUnit :i], [singleSensor get_measureDescription :i]);
      } else {
        NSLog(@"%f", [[valSensor objectAtIndex:i] doubleValue]);
      }
    }
    [YAPI FreeAPI];
  }
  return 0;
}
