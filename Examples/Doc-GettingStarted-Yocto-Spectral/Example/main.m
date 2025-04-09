/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that shows how to use a  Yocto-Spectral
 *
 *  You can find more information on our web site:
 *   Yocto-Spectral documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-spectral/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_colorsensor.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {
    NSError *error;
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    YColorSensor *colorSensor;
    if (argc > 1) {
      NSString     *target = [NSString stringWithUTF8String:argv[1]];
      colorSensor = [YColorSensor FindColorSensor:target];
    } else {
      colorSensor = [YColorSensor FirstColorSensor];
      if (colorSensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    }
    [colorSensor set_workingMode:0];
    [colorSensor set_estimationModel:0];
    NSLog(@"Near color : %@", [colorSensor get_nearSimpleColor]);
    NSLog(@"Color HEX : %x", [colorSensor get_estimatedRGB]);
    
    [YAPI FreeAPI];
  }
  return 0;
}
