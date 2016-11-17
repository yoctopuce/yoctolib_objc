#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_relay.h"


static void usage(const char* execname)
{
  NSLog(@"usage:");
  NSLog(@" %s serial_number> <channel>  [ ON | OFF ]", execname);
  NSLog(@" %s <logical_name> <channel>[ ON | OFF ]", execname);
  NSLog(@" %s any <channel> [ ON | OFF ]  (use any discovered device)", execname);
  NSLog(@"Example");
  NSLog(@" %s any 2 ON", execname);
  exit(1);
}

int main(int argc, const char * argv[])
{
  NSError *error;

  if (argc < 3) usage(argv[0]);

  @autoreleasepool {

    YRelay   *relay;
    NSString *target = [NSString stringWithUTF8String:argv[1]];
    NSString *channel = [NSString stringWithUTF8String:argv[2]];
    NSString *state = [NSString stringWithUTF8String:argv[3]];

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    if ([target isEqualToString:@"any"]) {
      relay = [YRelay FirstRelay];
      if (relay == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
      target = [[relay module] serialNumber];
    }

    NSLog(@"Using %@", target);
    relay =  [YRelay FindRelay:[NSString stringWithFormat:@"%@.relay%@", target, channel]];

    if ([relay isOnline]) {
      if ([state isEqualToString:@"ON"])
        [relay set_state:Y_STATE_B];
      else
        [relay set_state:Y_STATE_A];
    } else {
      NSLog(@"Module not connected (check identification and USB cable)\n");
    }
    [YAPI FreeAPI];
  }
  return 0;
}
