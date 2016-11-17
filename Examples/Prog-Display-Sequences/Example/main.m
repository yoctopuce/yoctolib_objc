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

#define COUNT 8


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

    [disp resetAll];
    // retreive the display size
    int w = [disp get_displayWidth];
    int h = [disp get_displayHeight];
    //reteive the first layer
    l0 = [disp get_displayLayer:0];

    int coord[(COUNT * 2) + 1];

    // precompute the "leds" position
    int ledwidth = (w / COUNT);
    for (int i = 0; i < COUNT; i++) {
      coord[i] = i * ledwidth;
      coord[2 * COUNT - i - 2] = coord[i];
    }

    int framesCount = 2 * COUNT - 2;

    // start recording
    [disp newSequence];

    // build one loop for recording
    for (int i = 0; i < framesCount ; i++) {
      [l0 selectColorPen:0];
      [l0 drawBar:coord[(i + framesCount - 1) % framesCount] :h - 1 :coord[(i + framesCount - 1) % framesCount] + ledwidth :h - 4];
      [l0 selectColorPen:0xffffff];
      [l0 drawBar:coord[i] :h - 1 :coord[i] + ledwidth :h - 4];
      [disp pauseSequence:100];  // records a 50ms pause.
    }
    // self-call : causes an endless looop
    [disp playSequence:@"K2000.seq"];
    // stop recording and save to device filesystem
    [disp saveSequence:@"K2000.seq"];

    // play the sequence
    [disp playSequence:@"K2000.seq"];

    NSLog(@"This animation is running in background.");
    [YAPI FreeAPI];
  }

  return 0;
}
