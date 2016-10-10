#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_motor.h"
#import "yocto_current.h"
#import "yocto_voltage.h"
#import "yocto_temperature.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number> power");
    NSLog(@"       demo <logical_name>  power");
    NSLog(@"       demo any power       (use any discovered device)");
    NSLog(@"       power is a integer between -100 and 100%%");
    NSLog(@"Example:");
    NSLog(@"       demo any 75");
    exit(1);
}


int main(int argc, const char * argv[])
{
    NSError *error;
    YMotor  *motor;

    if (argc < 3) {
        usage();
    }

    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target = [NSString stringWithUTF8String:argv[1]];
        int power  = atoi(argv[2]);

        if ([target isEqualToString:@"any"]) {
            // find the serial# of the first available motor
            motor = [YMotor FirstMotor];
            if (motor == nil) {
                NSLog(@"No module connected (check USB cable)");
                return 1;
            }
            target = [[motor get_module] get_serialNumber];
        }

        // retreive motor, current, voltage and temperature features from the device
        YMotor *motor = [YMotor FindMotor:[target stringByAppendingString:@".motor"]];
        YCurrent *current = [YCurrent FindCurrent:[target stringByAppendingString:@".current"]];
        YVoltage *voltage = [YVoltage FindVoltage:[target stringByAppendingString:@".voltage"]];
        YTemperature *temperature = [YTemperature
                                     FindTemperature:[target stringByAppendingString:@".temperature"]];

        // we need to retreive both DC and AC current from the device.
        if ([motor isOnline])  {
            // if motor is in error state, reset it.
            if ([motor get_motorStatus] >= Y_MOTORSTATUS_LOVOLT) {
                [motor resetStatus];
            }
            [motor drivingForceMove:power :2000];  // ramp up to power in 2 seconds
            while (1) {
                // display motor status
                NSLog(@"Status=%@  Voltage=%fV  Current=%f  Temp=%f",
                      [motor get_advertisedValue], [voltage get_currentValue],
                      [current get_currentValue] /1000, [temperature get_currentValue]);
                [YAPI Sleep:1000 :NULL]; // wait for one second
            }
        } else {
            NSLog(@"No module connected (check USB cable)");
            return 1;
        }
        [YAPI FreeAPI];
    }
    return 0;
}
