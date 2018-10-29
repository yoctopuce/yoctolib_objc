/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  Doc-Inventory example
 *
 *  You can find more information on our web site:
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"

int main (int argc, const char * argv[])
{
  NSError *error;

  @autoreleasepool {
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@\n", [error localizedDescription]);
      return 1;
    }

    NSLog(@"Device list:\n");

    YModule *module = [YModule FirstModule];
    while (module != nil) {
      NSLog(@"%@ %@", module.serialNumber, module.productName);
      module = [module nextModule];
    }
    [YAPI FreeAPI];
  }
  return 0;
}
