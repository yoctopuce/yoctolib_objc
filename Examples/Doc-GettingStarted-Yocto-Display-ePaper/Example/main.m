/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  An example that shows how to use a  Yocto-Display-ePaper
 *
 *  You can find more information on our web site:
 *   Yocto-Display-ePaper documentation:
 *      https://www.yoctopuce.com/EN/products/yocto-display-epaper/doc.html
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "yocto_api.h"
#import "yocto_display.h"

int colors[4] = { 0xFFFFFF,0x000000, 0xFF0000, 0xFFFF00 };

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
    YDisplayLayer *l0;
    
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
        
        // Makes sure the Panel type is set
        NSString* paneltype = [disp get_displayPanel];
        if([paneltype isEqual: @"NOT_SET"]) {
            NSLog(@"Use the virtual to Configure the panel first");
            return 1;
        }

        // clear screen (and all layers)
        [disp resetAll];
            
        // retreive the display size
        int w = [disp get_displayWidth];
        int h = [disp get_displayHeight];
        int middleX = w/2;
        int middleY = h/2;
        NSLog(@"Using device %@ (panel: %@ %dx%d pixels)",
              [disp get_serialNumber], paneltype, w, h);

        // retrieve the first layer
        l0 = [disp get_displayLayer:0];

        // if no fast refresh available, don't even try to run animations
        bool animation = ([paneltype rangeOfString:@"KS"].location != NSNotFound);
        int interations = 0;
        do {
            // prevent refreshing for 2 sec
            [disp postponeRefresh: 2000];
            [l0 clear];
            
            // draw a few circle
            for(int i = 0; i < 15; i++) {
                int cx = arc4random_uniform(w);
                int cy = arc4random_uniform(h);
                int r  = arc4random_uniform(h/20)+(h/20);
                [l0 selectFillColor: colors[arc4random_uniform(3)]];
                [l0 drawDisc: cx :cy :r];
                [l0 drawCircle: cx :cy :r];
            }
            
            // draw a rectangle with panel type in it
            [l0 selectFillColor: 0xffffff];
            [l0 drawBar: middleX-75 :middleY-10 :middleX+75 :middleY+12];
            [l0 drawRect: middleX-75 :middleY-10 :middleX+75 :middleY+12];
            [l0 drawText: middleX :middleY :Y_ALIGN_CENTER :paneltype];
            // forces a full refresh only the 1rst time
            if(++interations == 1) {
                [disp regenerateDisplay];
            }
            [disp triggerRefresh]; // display is allowed to refresh  again
            [YAPI Sleep:1000 :&error];
        } while(animation);
  }

  return 0;
}
