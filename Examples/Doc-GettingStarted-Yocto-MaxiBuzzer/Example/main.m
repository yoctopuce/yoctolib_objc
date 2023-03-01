/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that show how to use a  Yocto-MaxiBuzzer
 *
 *  You can find more information on our web site:
 *   Yocto-MaxiBuzzer documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-maxibuzzer/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_buzzer.h"
#import "yocto_anbutton.h"
#import "yocto_colorled.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>");
  NSLog(@"       demo <logical_name>");
  NSLog(@"       demo any (use any discovered device)");
  exit(1);
}

int main(int argc, const char * argv[])
{
  if (argc < 2) {
    usage();
  }

  @autoreleasepool {
    NSError *error;
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    NSString *target = [NSString stringWithUTF8String:argv[1]];
    YBuzzer  *buz;
    YColorLed *led;
    YAnButton *button1, *button2;

    if ([target isEqualToString:@"any"]) {
      buz =  [YBuzzer FirstBuzzer];
      if (buz == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    } else {
      buz = [YBuzzer FindBuzzer:target];
    }
    if (![buz isOnline]) {
      NSLog(@"Module not connected (check identification and USB cable)");
    }

    int frequency = 1000;
    int volume;
    int color;
    NSString *serial = [[buz module] serialNumber];
    led       = [YColorLed FindColorLed:[serial stringByAppendingString:@".colorLed"]];
    button1   = [YAnButton FindAnButton:[serial stringByAppendingString:@".anButton1"]];
    button2   = [YAnButton FindAnButton:[serial stringByAppendingString:@".anButton2"]];

    NSLog(@"press a test button or hit Ctrl-C");
    while ([buz isOnline]) {
      int b1 = [button1 isPressed];
      int b2 = [button2 isPressed];
      if (b1 || b2 ) {
        if (b1) {
          volume = 60;
          frequency = 1500;
          color = 0xff0000;
        } else {
          volume = 30;
          color = 0x00ff00;
          frequency = 750;
        }
        [led resetBlinkSeq];
        [led addRgbMoveToBlinkSeq:color :100];
        [led addRgbMoveToBlinkSeq:0 :100];
        [led startBlinkSeq];
        [buz set_volume:volume];
        for (int i = 0; i < 5; i++) {
          // this can be done using sequence as well
          [buz set_frequency:frequency];
          [buz freqMove:2 * frequency :250];
          [YAPI Sleep:250  :&error];
        }
        [buz set_frequency:0];
        [led stopBlinkSeq];
        [led set_rgbColor:0];
      }
    }
    [YAPI FreeAPI];
  }
  return 0;
}
