#import <Foundation/Foundation.h>
#import "main.h"
#import "yocto_api.h"
#import "yocto_hubport.h"






@implementation YoctoShield

-(id)           initWithSerial:(NSString*)serial
{
  if(!(self = [super init]))
    return nil;
  _serial    = serial;
  _subDevices = [[NSMutableArray alloc]init];
  return self;
}

-(NSString*)    getSerial
{
  return _serial;
}

-(bool)         addSubDevice:(NSString*) serial
{
  for (int i = 1; i <= 4; i++) {
    YHubPort* p = [YHubPort FindHubPort:[NSString stringWithFormat:@"%@.hubPort%d", _serial, i]];
    if ([p get_logicalName] == serial) {
      [_subDevices addObject:serial];
      return true;
    }

  }
  return false;
}

-(void)         removeSubDevice:(NSString*) serial
{
  [_subDevices removeObject:serial];
}
-(void)         describe
{
  NSLog(@"  %@", _serial);
  for (NSString * subdevice in _subDevices) {
    NSLog(@"    %@" , subdevice);
  }
}
@end


@implementation RootDevice

-(id)           initWithSerial:(NSString*)serial :(NSString*)url
{
  if(!(self = [super init]))
    return nil;
  _serial    = serial;
  _url    = url;
  _shields = [[NSMutableArray alloc]init];
  _subDevices = [[NSMutableArray alloc]init];
  return self;
}

-(NSString*)    getSerial
{
  return _serial;
}

-(void)         addSubDevice:(NSString*) serial
{
  if ([[serial substringToIndex:7] isEqual:@"YHUBSHL"]) {
    [_shields addObject:[[YoctoShield alloc] initWithSerial:serial]];
  } else {
    // Device to plug look if the device is plugged on a shield
    for (YoctoShield *  shield in _shields) {
      if ([shield addSubDevice:serial]) {
        return;
      }
    }
    [_subDevices addObject:serial];
  }
}

-(void)         removeSubDevice:(NSString*) serial
{
  [_subDevices removeObject:serial];
  for (YoctoShield * shield in _shields) {
    if ([[shield getSerial] isEqual:serial]) {
      [_shields removeObject:shield];
      return;
    } else {
      [shield removeSubDevice:serial];
    }
  }
}
-(void)         describe
{
  NSLog(@"%@ (%@)", _serial, _url);
  for (NSString * serial in _subDevices) {
    NSLog(@"  %@", serial);
  }
  for (YoctoShield *  shield in _shields) {
    [shield describe];
  }
}


@end





NSMutableArray* __rootDevices;

static RootDevice* getYoctoHub(NSString* serial)
{
  for (RootDevice * rootdev in __rootDevices) {
    if ([[rootdev getSerial] isEqual:serial]) {
      return rootdev;
    }
  }
  return NULL;
}

static RootDevice* addRootDevice(NSString* serial, NSString* url)
{
  for (RootDevice * rootdev in __rootDevices) {
    if ([[rootdev getSerial] isEqual:serial]) {
      return rootdev;
    }
  }
  RootDevice *rootDevice = [[RootDevice alloc] initWithSerial:serial :url];
  [__rootDevices addObject:rootDevice];
  return rootDevice;

}

static void showNetwork()
{
  NSLog(@"**** device inventory *****");
  for (RootDevice * rootdev in __rootDevices) {
    [rootdev describe];
  }
}


static void deviceArrival(YModule *module)
{
  NSString* serial = [module get_serialNumber];
  NSString* parentHub = [module get_parentHub];
  if ([parentHub  isEqual:@""]) {
    // root device (
    NSString* url = [module get_url];
    addRootDevice(serial, url);
  } else {
    RootDevice *hub = getYoctoHub(parentHub);
    if (hub != NULL) {
      [hub addSubDevice:serial];
    }
  }
}

static void deviceRemoval(YModule* module)
{
  NSString* serial = [module get_serialNumber];
  for (RootDevice * rootdev in __rootDevices) {
    [rootdev removeSubDevice:serial];
    if ([[rootdev getSerial] isEqual:serial]) {
      [__rootDevices removeObject:rootdev];
      return;
    }
  }
}


int main (int argc, const char * argv[])
{
  NSError    *error;
  @autoreleasepool {
    __rootDevices = [[NSMutableArray alloc]init];

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"net" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    [YAPI RegisterDeviceArrivalCallback:deviceArrival];
    [YAPI RegisterDeviceRemovalCallback:deviceRemoval];


    NSLog(@"Waiting for hubs to signal themselves...");

    while (true) {
      [YAPI UpdateDeviceList:NULL]; // traps plug/unplug events
      [YAPI Sleep:500: NULL];   // traps others events
      showNetwork();
    }
  }
  return 0;
}

