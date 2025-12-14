/*********************************************************************
 *
 *  $Id: main.m 32622 2018-10-10 13:11:04Z seb $
 *
 *  An example that show how to use a  Yocto-MiniDisplay
 *
 *  You can find more information on our web site:
 *   Yocto-MiniDisplay documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-minidisplay/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_display.h"

static void usage(void)
{
  NSLog(@"usage: demo <serial_number> ");
  NSLog(@"       demo <logical_name>");
  NSLog(@"       demo any                 (use any discovered device)");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError *error;
  YDisplay *disp;
  YDisplayLayer *l0, *l1;
  int h, w, y, x, vx, vy;
  @autoreleasepool {

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      usage();
      return 1;
    }
    if(argc < 2) {
      disp = [YDisplay FirstDisplay];
      if(disp == nil) {
        NSLog(@"No module connected (check USB cable)");
        usage();
        return 1;
      }
    } else {
      NSString *target = [NSString stringWithUTF8String:argv[1]];

      disp = [YDisplay FindDisplay:target];
      if(![disp isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)");
        usage();
        return 1;
      }
    }
    // clear screen (and all layers)
    [disp resetAll];
    // retreive the display size
    w = [disp get_displayWidth];
    h = [disp get_displayHeight];

    // reteive the first layer
    l0 = [disp get_displayLayer:0];

    // display a text in the middle of the screen
    [l0 drawText:w / 2 :h / 2 :Y_ALIGN_CENTER  :@"Hello world!"];

    // visualize each corner
    [l0 moveTo:0 :5];
    [l0 lineTo:0 :0];
    [l0 lineTo:5 :0];
    [l0 moveTo:0 :h - 6];
    [l0 lineTo:0 :h - 1];
    [l0 lineTo:5 :h - 1];
    [l0 moveTo:w - 1 :h - 6];
    [l0 lineTo:w - 1 :h - 1];
    [l0 lineTo:w - 6 :h - 1];
    [l0 moveTo:w - 1 :5];
    [l0 lineTo:w - 1  :0];
    [l0 lineTo:w - 6 :0];

    // draw a circle in the top left corner of layer 1
    l1 = [disp get_displayLayer:1];
    [l1 clear];
    [l1 drawCircle:h / 8 :h / 8 :h / 8];

    // and animate the layer
    NSLog(@"Use Ctrl-C to stop");
    x = 0;
    y = 0;
    vx = 1;
    vy = 1;
    while ([disp isOnline]) {
      x += vx;
      y += vy;
      if ((x < 0) || (x > w - (h / 4))) vx = -vx;
      if ((y < 0) || (y > h - (h / 4))) vy = -vy;
      [l1 setLayerPosition:x :y :0];
      [YAPI Sleep:5 :&error];
    }
    [YAPI FreeAPI];
  }

  return 0;
}
