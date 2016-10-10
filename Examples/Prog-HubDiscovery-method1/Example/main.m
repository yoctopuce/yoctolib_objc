#import <Foundation/Foundation.h>
#import "yocto_api.h"


NSMutableArray *KnownHubs;

static void HubDiscovered(NSString *serial, NSString *url)
{
    NSError    *error;

    // The call-back can be called several times for the same hub
    // (the discovery technique is based on a periodic broadcast)
    // So we use a dictionnary to avoid duplicates
    if ([KnownHubs containsObject:serial])
        return;

    NSLog(@"hub found: %@ (%@)", serial, url);
    [YAPI RegisterHub:url :&error];

    //  find the hub module
    YModule *hub = [YModule FindModule:serial];

    // iterate on all functions on the module and find the ports
    int fctCount =  [hub functionCount];
    for (int i = 0; i < fctCount; i++) {
        // retreive the hardware name of the ith function
        NSString *fctHwdName = [hub functionId:i];
        if ([fctHwdName length] > 7 && [[fctHwdName substringToIndex:7] isEqualToString:@"hubPort"]) {
            // The port logical name is always the serial#
            // of the connected device
            NSString *deviceid = [hub functionName:i];
            NSLog(@"  %@ : %@", fctHwdName, deviceid);
        }
    }
    // add the hub to the dictionnary so we won't have to
    // process is again.
    [KnownHubs addObject:serial];

    // disconnect from the hub
    [YAPI UnregisterHub:url];
}


int main (int argc, const char * argv[])
{
    @autoreleasepool {
        KnownHubs = [[NSMutableArray alloc] init];
        NSLog(@"Waiting for hubs to signal themselves...");
        [YAPI RegisterHubDiscoveryCallback:HubDiscovered];

        // wait for 30 seconds, doing nothing.
        for (int i = 0; i < 30; i++) {
            [YAPI UpdateDeviceList:NULL]; // traps plug/unplug events
            [YAPI Sleep:1000: NULL];   // traps others events
        }
    }
    return 0;
}

