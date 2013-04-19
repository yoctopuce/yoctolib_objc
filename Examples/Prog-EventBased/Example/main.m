#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_temperature.h"
#import "yocto_anbutton.h"
#import "yocto_lightsensor.h"


static void CustomLog(NSString * log)
{
    NSLog(@"LOG:%@",log);
}

static void anButtonChangeCallBack(YAnButton *fct, NSString* value)
{
    NSLog(@"Position change    :%@ = %@",fct,value);
}

static void temperatureChangeCallBack(YTemperature *fct, NSString* value)
{
    NSLog(@"Temperature change :%@ = %@ °C",fct,value);
}

static void lightSensorChangeCallBack(YLightSensor *fct, NSString* value)
{
    NSLog(@"Light change       :%@ = %@ lx",fct,value);
}


static void deviceArrival(YModule *m)
{
    NSLog(@"Device arrival          : %@",m);
    int fctcount = [m functionCount];
    NSString *fctName, *fctFullName;
    
    for (int i = 0; i < fctcount; i++) {
        fctName = [m functionId:i];
        fctFullName = [NSString stringWithFormat:@"%@.%@", m.serialNumber ,fctName];
        
        // register call back for anbuttons
        if ([fctName hasPrefix:@"anButton"]) { 
            YAnButton *bt = [YAnButton FindAnButton:fctFullName];
            //fixme: registerValueCallback should call callback with first value?
            [bt registerValueCallback:anButtonChangeCallBack];
            NSLog(@"Callback registered for : %@", fctFullName);
        }
        
        // register call back for temperature sensors
        if ([fctName hasPrefix:@"temperature"]) { 
            YTemperature *t = [YTemperature FindTemperature:fctFullName];
            [t registerValueCallback:temperatureChangeCallBack];
            NSLog(@"Callback registered for : %@", fctFullName);
        }
        
        // register call back for light sensors
        if ([fctName hasPrefix:@"lightSensor"]) { 
            YLightSensor *l = [YLightSensor FindLightSensor:fctFullName];
            [l registerValueCallback:lightSensorChangeCallBack];
            NSLog(@"Callback registered for : %@", fctFullName);
        }
        // and so on for other sensor type.....
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
      
        [YAPI RegisterLogFunction:customLog];
        [YAPI RegisterDeviceArrivalCallback:deviceArrival];
        [YAPI RegisterDeviceRemovalCallback:deviceRemoval];
        [YAPI DisableExceptions];
    
        // Setup the API to use local USB devices
        if(yRegisterHub(@"usb", &error) != YAPI_SUCCESS) {
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

