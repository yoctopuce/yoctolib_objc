#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_currentloopoutput.h"

static void usage(void)
{
  NSLog(@"Wrong command line arguments");
  NSLog(@"usage: demo <serial_number> <value>");
  NSLog(@"       demo <logical_name> <value>");
  NSLog(@"       demo any <value> (use any discovered device)");
  NSLog(@"Eg.");
  NSLog(@"   demo any 12");
  NSLog(@"   demo TX420MA1-123456 20");
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError     *error;
  YCurrentLoopOutput    *loop;

  if (argc < 3) {
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
      // retreive any generic sensor
      loop = [YCurrentLoopOutput FirstCurrentLoopOutput];
      if (loop == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }

    } else {
      loop = [YCurrentLoopOutput FindCurrentLoopOutput:[target stringByAppendingString:@".currentLoopOutput"]];
    }

    double value = atof(argv[2]);
    // we need to retreive both DC and AC current from the device.
    if ([loop isOnline])  {
      [loop set_current:value];
      Y_LOOPPOWER_enum loopPower = [loop get_loopPower];
      if (loopPower == Y_LOOPPOWER_NOPWR) {
        NSLog(@"Current loop not powered");
        return 1;
      }
      if (loopPower == Y_LOOPPOWER_LOWPWR) {
        NSLog(@"Insufficient voltage on current loop");
        return 1;
      }
      NSLog(@"current loop set to %f mA", value);
    } else {
      NSLog(@"Module not connected (check identification and USB cable)");
    }
    [YAPI FreeAPI];
  }
  return 0;
}