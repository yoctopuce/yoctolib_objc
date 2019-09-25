/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that show how to use a  Yocto-I2C
 *
 *  You can find more information on our web site:
 *   Yocto-I2C documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-i2c/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_i2cport.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>");
  NSLog(@"       demo <logical_name>");
  NSLog(@"       demo any            (use any discovered device)");
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

    if ([target isEqualToString:@"any"]) {
      YI2cPort *i2cPort = [YI2cPort FirstI2cPort];
      if (i2cPort == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[i2cPort module] serialNumber];
    }

    YI2cPort *i2cPort = [YI2cPort FindI2cPort:
                         [target stringByAppendingString:@".i2cPort"]];

    if ([i2cPort isOnline]) {
      [i2cPort set_i2cMode:@"400kbps"];
      [i2cPort set_i2cVoltageLevel:Y_I2CVOLTAGELEVEL_3V3];
      [i2cPort reset];
      NSLog(@"****************************");
      NSLog(@"* make sure voltage levels *");
      NSLog(@"* are properly configured  *");
      NSLog(@"****************************");

      NSMutableArray *toSend = [NSMutableArray arrayWithCapacity:1];
      [toSend addObject:[NSNumber numberWithUnsignedChar:0x05]];
      NSMutableArray *received = [i2cPort i2cSendAndReceiveArray:0x1f :toSend :2];
      short int tempReg = ([[received objectAtIndex:0] unsignedCharValue] << 8) + [[received objectAtIndex:1] unsignedCharValue];
      if (tempReg & 0x1000) {
        tempReg |= 0xf000;    // perform sign extension
      } else {
        tempReg &= 0x0fff;    // clear status bits
      }
      NSLog(@"Current temperature: %f 'C\n", tempReg / 16.0);
    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }
  return 0;
}
