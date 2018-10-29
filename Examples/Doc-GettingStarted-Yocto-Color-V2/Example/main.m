/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-Color-V2
 *
 *  You can find more information on our web site:
 *   Yocto-Color-V2 documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-color-v2/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_colorledcluster.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>  [ color | rgb ]");
  NSLog(@"       demo <logical_name> [ color | rgb ]");
  NSLog(@"       demo any  [ color | rgb ]                (use any discovered device)");
  NSLog(@"Eg.");
  NSLog(@"   demo any FF1493 ");
  NSLog(@"   demo YRGBLED1-123456 red");
  exit(1);
}

int main(int argc, const char * argv[])
{
  YColorLedCluster *ledCluster;
  NSError * error;

  if(argc < 3) {
    usage();
  }

  @autoreleasepool {
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    NSString *target    = [NSString stringWithUTF8String:argv[1]];
    NSString *color_str = [NSString stringWithUTF8String:argv[2]];
    if ([target isEqualToString:@"any"]) {
      ledCluster = [YColorLedCluster FirstColorLedCluster];
      if (ledCluster == NULL) {
        NSLog(@"No Yocto-Color connected (check USB cable)");
        return 1;
      }
      target = [[ledCluster module] serialNumber];
    }

    ledCluster =  [YColorLedCluster FindColorLedCluster:[target stringByAppendingString:
                   @".colorLedCluster"]];
    unsigned color;
    if ([color_str isEqualToString:@"red"])
      color = 0xFF0000;
    else if ([color_str isEqualToString:@"green"])
      color = 0x00FF00;
    else if ([color_str isEqualToString:@"blue"])
      color = 0x0000FF;
    else
      color = (int)strtoul([color_str UTF8String], NULL, 16);

    if ([ledCluster isOnline]) {
      int nb_leds = 2;
      //configure led cluster
      [ledCluster set_activeLedCount:nb_leds];
      [ledCluster set_ledType:Y_LEDTYPE_RGB];

      // immediate transition for first half of leds
      [ledCluster set_rgbColor:0 :nb_leds / 2 :color];
      // immediate transition for second half of leds
      [ledCluster rgb_move:nb_leds / 2 :nb_leds / 2 :color :2000];

    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }

  return 0;
}
