#import <Foundation/Foundation.h>
#import "yocto_api.h"


NSMutableArray *KnownHubs;

// called each time a new device (networked or not) is detected
static void arrivalCallback(YModule *dev)
{
  bool isAHub = false;
  // iterate on all functions on the module and find the ports
  int fctCount =  [dev functionCount];
  for (int i = 0; i < fctCount; i++) {
    // retreive the hardware name of the ith function
    NSString *fctHwdName = [dev functionId:i];
    if ([fctHwdName length] > 7 && [[fctHwdName substringToIndex:7] isEqualToString:@"hubPort"]) {
      // the device contains a  hubPortx function, so it's a hub
      if (!isAHub) {
        NSLog(@"hub found : %@", [dev get_friendlyName]);
        isAHub = true;
      }
      // The port logical name is always the serial#
      // of the connected device
      NSString *deviceid = [dev functionName:i];
      NSLog(@"  %@ : %@", fctHwdName, deviceid);
    }
  }
}
int main (int argc, const char * argv[])
{
  NSError    *error;
  @autoreleasepool {
    NSLog(@"Waiting for hubs to signal themselves...");

    // Setup the API to use local USB devices])
    if ([YAPI RegisterHub:@"net" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }
    // each time a new device is connected/discovered
    // arrivalCallback will be called.
    [YAPI RegisterDeviceArrivalCallback:arrivalCallback];

    // wait for 30 seconds, doing nothing.
    for (int i = 0; i < 30; i++) {
      [YAPI UpdateDeviceList:NULL]; // traps plug/unplug events
      [YAPI Sleep:1000: NULL];   // traps others events
    }
  }
  return 0;
}

