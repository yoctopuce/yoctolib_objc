/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that show how to use a  Yocto-MaxiKnob
 *
 *  You can find more information on our web site:
 *   Yocto-MaxiKnob documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-maxiknob/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_buzzer.h"
#import "yocto_anbutton.h"
#import "yocto_colorledcluster.h"
#import "yocto_quadraturedecoder.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number>");
  NSLog(@"       demo <logical_name>");
  NSLog(@"       demo any (use any discovered device)");
  exit(1);
}

static int notefreq(int note)
{
  return (int) (220.0 * exp(note * log(2) / 12));
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
    YColorLedCluster *leds;
    YAnButton *button1;
    YQuadratureDecoder *qd;

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

    NSString *serial = [[buz module] serialNumber];
    leds       = [YColorLedCluster FindColorLedCluster:[serial stringByAppendingString:
                  @".colorLedCluster"]];
    button1   = [YAnButton FindAnButton:[serial stringByAppendingString:@".anButton1"]];
    qd = [YQuadratureDecoder FindQuadratureDecoder:[serial stringByAppendingString:
          @".quadratureDecoder1"]];

    if (![button1 isOnline] || ![qd isOnline]) {
      NSLog(@"Make sure the Yocto-MaxiKnob is configured with at least one AnButton and One Quadrature decoder.");
      return 1;
    }

    NSLog(@"press a test button, or turn the encoder or hit Ctrl-C");
    int lastPos = (int) [qd get_currentValue];
    [buz set_volume:75];
    while ([button1 isOnline]) {
      if ([button1 isPressed] && (lastPos != 0)) {
        lastPos = 0;
        [qd set_currentValue:0];
        [buz playNotes:@"'E32 C8"];
        [leds set_rgbColor:0 :1 :0x000000];
      } else {
        int p = (int)[qd get_currentValue];
        if (lastPos != p) {
          lastPos = p;
          [buz pulse:notefreq(p) :500];
          [leds set_hslColor:0 :1 :(0x00FF7f | (p % 255) << 16)];
        }
      }
    }
    [YAPI FreeAPI];
  }
  return 0;
}
