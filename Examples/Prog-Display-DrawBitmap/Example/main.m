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
  YDisplayLayer *l0;
  int h, w;
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
    int bytesPerLines = w / 8;
    NSMutableData* nsdata = [NSMutableData dataWithLength:h * bytesPerLines];
    unsigned char *data = [nsdata mutableBytes];
    int max_iteration = 50;
    int iteration;
    double xtemp;
    double centerX = 0;
    double centerY = 0;
    double targetX = 0.834555980181972;
    double targetY = 0.204552998862566;
    double x, y, x0, y0;
    double zoom = 1;
    double distance = 1;

    while (true) {
      for (int i = 0; i < [nsdata length]; i++)
        data[i] = 0;
      distance = distance * 0.95;
      centerX = targetX * (1 - distance);
      centerY = targetY * (1 - distance);
      max_iteration = (int)floor(0.5 + max_iteration  + sqrt(zoom) );
      if (max_iteration > 1500) max_iteration = 1500;
      for (int j = 0; j < h; j++)
        for (int i = 0; i < w; i++) {
          x0 = (((i - w / 2.0) / (w / 8)) / zoom) - centerX;
          y0 = (((j - h / 2.0) / (w / 8)) / zoom) - centerY;
          x = 0;
          y = 0;
          iteration = 0;
          while ((x * x + y * y < 4) && (iteration < max_iteration)) {
            xtemp = x * x - y * y + x0;
            y = 2 * x * y + y0;
            x = xtemp;
            iteration += 1;
          }
          if (iteration >= max_iteration)
            data[j * bytesPerLines + (i >> 3)] |= (128 >> (i % 8));
        }
      [l0 drawBitmap:0  :0 :w :nsdata :0];
      zoom = zoom / 0.95;
    }
  }

  return 0;
}
