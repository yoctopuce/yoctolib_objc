#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_serialport.h"


static int upgradeSerialList(NSMutableArray *allserials)
{
     NSError *error;

    for (NSString * serial in allserials) {
        YModule *module = [YModule FindModule:serial];
        NSString *product = [module get_productName];
        NSString *current = [module get_firmwareRelease];

        // check if a new firmare is available on yoctopuce.com
        NSString *newfirm = [module checkFirmware:@"www.yoctopuce.com" :TRUE];
        if ([newfirm isEqualToString:@""]) {
            NSLog(@"%@ %@ (rev=%@) is up to date", product, serial, current);
        } else {
            NSLog(@"%@ %@ (rev=%@) need be updated with firmare : ", product, serial, current);
            NSLog(@"    %@", newfirm);
            // execute the firmware upgrade
            YFirmwareUpdate *update = [module updateFirmware:newfirm];
            int status = [update startUpdate];
            do {
                int newstatus = [update get_progress];
                if (newstatus != status)
                    NSLog(@"%d%% %@", status, [update get_progressMessage]);
                [YAPI Sleep:500 :&error];
                status = newstatus;
            } while (status < 100 && status >= 0);
            if (status < 0){
                NSLog(@"    %d%% Firmware Update failed: %@",status, [update get_progressMessage]);
                exit(1);
            } else{
                if ([module isOnline]){
                    NSLog(@"    %d%% Firmware Updated Successfully!",status);
                } else {
                    NSLog(@"    %d%% Firmware Update failed: module %@ is not online",status, serial);
                    exit(1);
                }
            }
        }
    }
    return 0;
}

int main(int argc, const char * argv[])
{
    int i;
    NSError *error;

    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        for (i = 1; i < argc; i++) {
            NSString *hub_url = [NSString stringWithUTF8String:argv[i]];
            NSLog(@"Update module connected to hub %@", hub_url);
            if([YAPI RegisterHub:hub_url :&error] != YAPI_SUCCESS) {
                NSLog(@"RegisterHub error: %@", [error localizedDescription]);
                return 1;
            }
        }
        //first step construct the list of all hub /shield and devices connected
        NSMutableArray *hubs = [NSMutableArray array];
        NSMutableArray *shield = [NSMutableArray array];
        NSMutableArray *devices = [NSMutableArray array];
        YModule *module = [YModule FirstModule];
        while (module){
            NSString *product = [module get_productName];
            NSString *serial  = [module get_serialNumber];
            NSData * settings = [module get_allSettings];
            [module set_allSettings:settings];
            if ([product isEqualToString:@"YoctoHub-Shield"] ) {
                [shield addObject:serial];
            } else if ([product hasPrefix:@"YoctoHub-"]) {
                [hubs addObject:serial];
            } else if (![product isEqualToString:@"VirtualHub"]){
                [devices addObject:serial];
            }
            module = [module nextModule];
        }
        // first upgrades all Hubs...
        upgradeSerialList(hubs);
        // ... then all shield..
        upgradeSerialList(shield);
        // ... and finaly all devices
        upgradeSerialList(devices);
        NSLog(@"All devices are now up to date");
        [YAPI FreeAPI];
    }
    return 0;
}
