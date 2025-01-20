/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Doc-GettingStarted-Yocto-Spectral-C example
 *
 *  You can find more information on our web site:
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_spectralsensor.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {
    NSError *error;
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    YSpectralSensor *spectralSensor;
    if (argc > 1) {
      NSString     *target = [NSString stringWithUTF8String:argv[1]];
      spectralSensor = [YSpectralSensor FindSpectralSensor:target];
    } else {
      spectralSensor = [YSpectralSensor FirstSpectralSensor];
      if (spectralSensor == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    }
    [spectralSensor set_gain:6];
    [spectralSensor set_integrationTime:150];
    [spectralSensor set_ledCurrent:6];
    NSLog(@"Near color : %@", [spectralSensor get_nearSimpleColor]);
    NSLog(@"Color HEX : %x", [spectralSensor get_estimatedRGB]);
    
    [YAPI FreeAPI];
  }
  return 0;
}
