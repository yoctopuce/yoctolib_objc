#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_temperature.h"
#import "yocto_anbutton.h"
#import "yocto_lightsensor.h"


static void anButtonValueChangeCallBack(YAnButton* fct, NSString* value)
{
    int value_f = [fct get_calibratedValue];
    [fct clearCache];
    int value_g = [fct get_calibratedValue];
     NSLog(@"%@: %@=%d (%d)", [fct get_hardwareId], value, value_g, value_f);
}

static void sensorValueChangeCallBack(YSensor* fct, NSString* value)
{
    NSLog(@"%@ : %@ %@ (new value)", [fct get_hardwareId], value, [fct get_unit]);
}

static void sensorTimedReportCallBack(YSensor* fct, YMeasure* measure)
{
    NSLog(@"%@ : %.3f %@ (timed report)", [fct get_hardwareId], [measure get_averageValue], [fct get_unit]);
}

static void deviceArrival(YModule *m)
{
    NSString *fctName, *serial, *hardwareId;
    serial = [m get_serialNumber];
    NSLog(@"Device arrival          : %@",serial);
    
    // First solution: look for a specific type of function (eg. anButton)
    int fctcount = [m functionCount];
    for (int i = 0; i < fctcount; i++) {
        fctName = [m functionId:i];
        hardwareId = [NSString stringWithFormat:@"%@.%@", serial ,fctName];
        
        if ([fctName hasPrefix:@"anButton"]) {
            NSLog(@"- %@", hardwareId);
            YAnButton *bt = [YAnButton FindAnButton:hardwareId];
            [bt registerValueCallback:anButtonValueChangeCallBack];
        }
    }
    
    // Alternate solution: register any kind of sensor on the device
    YSensor *sensor = [YSensor FirstSensor];
    while(sensor) {
        if([[[sensor get_module]  get_serialNumber] isEqualToString:serial]) {
            hardwareId = [sensor get_hardwareId];
            NSLog(@"- %@", hardwareId);
            [sensor registerValueCallback:sensorValueChangeCallBack];
            [sensor registerTimedReportCallback:sensorTimedReportCallBack];
        }
        sensor = [sensor nextSensor];
    }
}

static void deviceRemoval(YModule *m)
{
    NSLog(@"Device removal          : %@",m.serialNumber);
}


static void customLog(NSString *val)
{
    NSLog(@"%@",val);
}


int main (int argc, const char * argv[])
{
    NSError    *error;
    @autoreleasepool {
        [YAPI SetDefaultCacheValidity: 5000];
        [YAPI RegisterLogFunction:customLog];
        [YAPI RegisterDeviceArrivalCallback:deviceArrival];
        [YAPI RegisterDeviceRemovalCallback:deviceRemoval];
        [YAPI DisableExceptions];
    
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }

        NSLog(@"Hit Ctrl-C to Stop ");
        
        while (true) {
            [YAPI UpdateDeviceList:NULL]; // traps plug/unplug events
            [YAPI Sleep:500: NULL];   // traps others events
        } 
    }
    return 0;
}

