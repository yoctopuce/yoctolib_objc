/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-Servo
 *
 *  You can find more information on our web site:
 *   Yocto-Servo documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-servo/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_servo.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>  [ -1000 | ... | 1000 ]");
  NSLog(@"       demo <logical_name> [ -1000 | ... | 1000 ]");
  NSLog(@"       demo any  [ -1000 | ... | 1000 ]                (use any discovered device)");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError *error;

  if (argc < 3) {
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
      YServo *servo = [YServo FirstServo];
      if (servo == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[servo module] serialNumber];
    }
    YServo   *servo1 =  [YServo FindServo:[target stringByAppendingString:@".servo1"]];
    YServo   *servo5 =  [YServo FindServo:[target stringByAppendingString:@".servo5"]];

    int pos = (int) atol(argv[2]);

    if ([servo1 isOnline]) {
      [servo1 set_position:pos];  // immediate switch
      [servo5 move:pos:3000];     // smooth transition
    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }
  return 0;
}
