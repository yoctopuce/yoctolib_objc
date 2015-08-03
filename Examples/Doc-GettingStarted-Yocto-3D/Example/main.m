#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_tilt.h"
#import "yocto_compass.h"
#import "yocto_gyro.h"
#import "yocto_accelerometer.h"



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
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        
        NSString *target = [NSString stringWithUTF8String:argv[1]];
        YTilt *anytilt,*tilt1, *tilt2;
        YCompass *compass;
        YAccelerometer *accelerometer;
        YGyro *gyro;             

        if([target isEqualToString:@"any"]){
            anytilt = [YTilt FirstTilt];
            if (anytilt==NULL) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
        } else {
            anytilt = [YTilt FindTilt:[target stringByAppendingString:@".tilt1"]];
            if(![anytilt isOnline]) {
                NSLog(@"Module not connected (check identification and USB cable)");
                return 1;
            }
        }
        NSString *serial = [[anytilt get_module] get_serialNumber];
        // retrieve all sensors on the device matching the serial 
        tilt1 = [YTilt FindTilt:[serial stringByAppendingString:@".tilt1"]];
        tilt2 = [YTilt FindTilt:[serial stringByAppendingString:@".tilt2"]];
        compass = [YCompass FindCompass:[serial stringByAppendingString:@".compass"]];
        accelerometer = [YAccelerometer FindAccelerometer:[serial stringByAppendingString:@".accelerometer"]];
        gyro = [YGyro FindGyro:[serial stringByAppendingString:@".gyro"]];
        int count = 0;
  
        while(1) {
            if(![tilt1 isOnline]) {
                NSLog(@"device disconnected");
                break;
            }
            if ((count % 10) == 0) 
                NSLog(@"tilt1\ntilt2\ncompass\tacc\tgyro");
            NSLog(@"%f\n%f\n%f\t%f\t%f",
                [tilt1 get_currentValue],
                [tilt2 get_currentValue],
                [compass get_currentValue],
                [accelerometer get_currentValue],
                [gyro get_currentValue]);
            count++;       

            [YAPI Sleep:250:NULL];
        }
        [YAPI FreeAPI];
    }
    
    return 0;
}
