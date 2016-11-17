#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_anbutton.h"

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

  if (argc < 2) {
    usage();
  }

  @autoreleasepool {
    NSString *target = [NSString stringWithUTF8String:argv[1]];
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }


    if ([target isEqualToString:@"any"]) {
      YAnButton *anbutton = [YAnButton FirstAnButton];
      if (anbutton == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[anbutton module] serialNumber];
    }
    YAnButton *input1 = [YAnButton FindAnButton:[target stringByAppendingString:@".anButton1"]];
    YAnButton *input5 = [YAnButton FindAnButton:[target stringByAppendingString:@".anButton5"]];

    while(1) {
      if(![input1 isOnline]) {
        NSLog(@"Module not connected (check identification and USB cable)");
        break;
      }

      if([input1 get_isPressed]) {
        NSLog(@"Button1: pressed    ");
      } else {
        NSLog(@"Button1: not pressed");
      }
      NSLog(@" - analog value: %d", [input1 get_calibratedValue]);
      if([input5 get_isPressed])
        NSLog(@"Button5: pressed    ");
      else
        NSLog(@"Button5: not pressed");
      NSLog(@" - analog value: %d", [input5 get_calibratedValue]);

      NSLog(@"(press both buttons simultaneously to exit)");

      if([input1 get_isPressed] == Y_ISPRESSED_TRUE &&
          [input5 get_isPressed] == Y_ISPRESSED_TRUE)
        break;
      [YAPI Sleep:1000:NULL];
    };
    [YAPI FreeAPI];
  }
  NSLog(@"bye bye");

  return 0;
}
