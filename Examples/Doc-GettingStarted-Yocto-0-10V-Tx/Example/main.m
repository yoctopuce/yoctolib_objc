/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-0-10V-Tx
 *
 *  You can find more information on our web site:
 *   Yocto-0-10V-Tx documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-0-10v-tx/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_voltageoutput.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number> <voltage>");
  NSLog(@"       demo <logical_name>  <voltage>");
  NSLog(@"       demo any <voltage>  (use any discovered device)");
  NSLog(@"       <voltage>: floating point number between 0.0 and 10.000");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError *error;

  if (argc < 4) {
    usage();
  }

  @autoreleasepool {
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    NSString *target = [NSString stringWithUTF8String:argv[1]];

    if ([target isEqualToString:@"any"]) {
      YVoltageOutput *pwmoutput = [YVoltageOutput FirstVoltageOutput];
      if (pwmoutput == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[pwmoutput module] serialNumber];
    }

    YVoltageOutput *vout1 = [YVoltageOutput FindVoltageOutput:
                             [target stringByAppendingString:@".voltageOutput1"]];
    YVoltageOutput *vout2 = [YVoltageOutput FindVoltageOutput:
                             [target stringByAppendingString:@".voltageOutput2"]];

    int voltage =  atof(argv[2]);

    if ([vout1 isOnline]) {
      // output 1 : immediate change
      [vout1 set_currentVoltage:voltage];
      // output 2 : smooth change
      [vout2 voltageMove:voltage :3000];
    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }
  return 0;
}
