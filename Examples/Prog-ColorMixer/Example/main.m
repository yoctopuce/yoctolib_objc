#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_anbutton.h"
#import "yocto_colorled.h"

// current Color
unsigned            _color;
// vector that contain all registered leds
NSMutableArray  *_leds;


// internal method that will update the color on all registered leds
static void refreshColor(NSString *component, unsigned char value)
{
    unsigned i;
    if ([component isEqualToString:@"RED"]) {
        _color = (_color & 0xffff) | ( (unsigned)value << 16);
    } else if ([component isEqualToString:@"GREEN"]) {
        _color = (_color & 0xff00ff) | ( (unsigned)value << 8);
    } else if ([component isEqualToString:@"BLUE"]) {
        _color = (_color & 0xffff00) |  value ;
    }
    for (i=0 ; i < [_leds count] ; i++) {
        [[_leds objectAtIndex:i] set_rgbColor:_color];
    }
}

static void valueCallback(YAnButton* button, NSString* calibratedValue)
{
    // calculate the red component by scaling the calibratedValue
    // from 0..1000 to 0..255
    unsigned char colorcomponent  =  ( [calibratedValue intValue] *255/1000 ) & 0xff;
    // update the color
    refreshColor((NSString*)[button get_userData] , colorcomponent);
}


int main (int argc, const char * argv[])
{
    NSError *error;
    int     i;

    if(argc <2) {
        NSLog(@"usage: demo [usb | ip_address]");
        return 1;
    }

    @autoreleasepool {
        [YAPI DisableExceptions];
        for (i=1; i< argc ; i++) {
            NSString *arg = [NSString stringWithUTF8String:argv[i]];

            // Setup the API to use local USB devices
            if( [YAPI RegisterHub:arg :&error] != YAPI_SUCCESS) {
                NSLog(@"Unable to get acces to devices on %@",arg);
                NSLog(@"error: %@", [error localizedDescription]);
                return 1;
            }
        }


        // get our pointer on our 3 knob
        // we use will reference the 3 knob by the logical name
        // that we have configured using the VirtualHub
        YAnButton* knobRed  = [YAnButton FindAnButton:@"Red"];
        [knobRed set_userData:@"RED"];
        [knobRed registerValueCallback:valueCallback];
        YAnButton* knobGreen = [YAnButton FindAnButton:@"Green"];
        [knobGreen set_userData:@"GREEN"];
        [knobGreen registerValueCallback:valueCallback];
        YAnButton* knobBlue  = [YAnButton FindAnButton:@"Blue"];
        [knobBlue set_userData:@"BLUE"];
        [knobBlue registerValueCallback:valueCallback];

        // display a warning if we miss a knob
        if ( ! [knobRed isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobRed);
        if ( ! [knobGreen isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobGreen);
        if ( ! [knobBlue isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobBlue);

        // register all led that is connected to our "network"
        _leds = [[NSMutableArray alloc] init];
        YColorLed* led = [YColorLed FirstColorLed];
        while(led) {
            [_leds addObject:led];
            NSLog(@"Use led %@",[led get_friendlyName]);
            led = [led nextColorLed];
        }

        // never hanling loop that will..
        while(1) {
            // ... handle all event durring 5000ms without using lots of CPU ...
            [YAPI Sleep:5000 :NULL];
            // ... and check for device plug/unplug
            [YAPI UpdateDeviceList:NULL];
        }
    }
    return 0;
}



