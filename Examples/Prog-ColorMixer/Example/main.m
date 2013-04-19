#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_anbutton.h"
#import "yocto_colorled.h"

@interface  ColorMixer : NSObject
{
    // current Color
    unsigned            _color;
    // vector that contain all registered leds
    NSMutableArray  *_leds;
}    

// register a YoctoLed
-(void) addLED:(YColorLed*)led;
-(void) changeRed:(unsigned char) red;
-(void) changeGreen:(unsigned char) green;
-(void) changeBlue:(unsigned char) blue;
-(void) redCallback:(YAnButton*) button :(NSString*) calibratedValue;
-(void) greenCallback:(YAnButton*) button :(NSString*) calibratedValue;
-(void) blueCallback:(YAnButton*) button :(NSString*) calibratedValue;
-(void) assignRedButton:(YAnButton*) button;
-(void) assignGreenButton:(YAnButton*) button;
-(void) assignBlueButton:(YAnButton*)button;
@end

@implementation ColorMixer

-(id) init
{
    if(!(self = [super init]))
        return nil;
    _color = 0;
    _leds  = [[NSMutableArray alloc] init];
    return self;
}

// internal method that will update the color on all registered leds
-(void) refreshColor
{
    unsigned i;     
    for (i=0 ; i < [_leds count] ; i++) {
        [[_leds objectAtIndex:i] set_rgbColor:_color];
    }
}


// register a YoctoLed
-(void) addLED:(YColorLed*)led
{  [_leds addObject:led];}

// update only red component 
-(void) changeRed:(unsigned char) red
{
    _color = (_color & 0xffff) | ( (unsigned)red << 16);
    [self refreshColor ];
}
    
// update only geen component 
-(void) changeGreen:(unsigned char) green
{
    _color = (_color & 0xff00ff) | ( (unsigned)green << 8);
    [self refreshColor ];
}
    
    // update only blue component     
-(void) changeBlue:(unsigned char) blue
{
    _color = (_color & 0xffff00) |  blue ;
    [self refreshColor ];
}
    
-(void) redCallback:(YAnButton*) button :(NSString*) calibratedValue
{
    // calculate the red component by scaling the calibratedValue 
    // from 0..1000 to 0..255
    unsigned char red  =  ( [calibratedValue intValue] *255/1000 ) & 0xff;
    // update the color
    [self changeRed:red];
}
    
-(void) greenCallback:(YAnButton*) button :(NSString*) calibratedValue
{
    // calculate the red component by scaling the calibratedValue 
    // from 0..1000 to 0..255
    unsigned char green  =  ( [calibratedValue intValue] *255/1000 ) & 0xff;
    // update the color
    [self changeGreen:green];
}
    
-(void) blueCallback:(YAnButton*) button :(NSString*) calibratedValue
{
    // calculate the red component by scaling the calibratedValue 
    // from 0..1000 to 0..255
    unsigned char blue  =  ( [calibratedValue intValue] *255/1000 ) & 0xff;
    // update the color
    [self changeBlue:blue];
}
    
-(void) assignRedButton:(YAnButton*)button
{
    // we store a pointer to the current instance of ColorMixer into
    // the userData Field
    [button set_userData:self];
    // and we register our static method to change red color as callback
    [button setObjectCallback:self withSelector:@selector(redCallback::)];   
}
    
-(void) assignGreenButton:(YAnButton*)button
{
    // we store a pointer to the current instance of ColorMixer into
    // the userData Field
    [button set_userData:self];
    // and we register our static method to change green color as callback
    [button setObjectCallback:self withSelector:@selector(greenCallback::)];   
}

-(void) assignBlueButton:(YAnButton*) button
{
    // we store a pointer to the current instance of ColorMixer into
    // the userData Field
    [button set_userData:self];
    // and we register our static method to change blue color as callback
    [button setObjectCallback:self withSelector:@selector(blueCallback::)];   
}


@end

int main (int argc, const char * argv[])
{
    NSError *error;
    int     i;

    if(argc <2){
        NSLog(@"usage: demo [usb | ip_address]");
        return 1;
    }

    @autoreleasepool {
        yDisableExceptions();
        for (i=1; i< argc ;i++) {
            NSString *arg = [NSString stringWithUTF8String:argv[i]];

            // Setup the API to use local USB devices
            if(yRegisterHub(arg, &error) != YAPI_SUCCESS) {
                NSLog(@"Unable to get acces to devices on %@",arg);
                NSLog(@"error: %@", [error localizedDescription]);
                return 1;
            }
        }
        
        // create our ColorMixer Object
        ColorMixer *mixer = [[ColorMixer alloc] init];
        
        // get our pointer on our 3 knob 
        // we use will reference the 3 knob by the logical name 
        // that we have configured using the VirtualHub
        YAnButton* knobRed  = yFindAnButton(@"Red");
        YAnButton* knobGreen = yFindAnButton(@"Green");
        YAnButton* knobBlue  = yFindAnButton(@"Blue");
        
        // register these 3 knob to the mixer
        [mixer assignRedButton: knobRed ];
        [mixer assignGreenButton: knobGreen];
        [mixer assignBlueButton: knobBlue];
        
        // display a warning if we miss a knob
        if ( ! [knobRed isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobRed);
        if ( ! [knobGreen isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobGreen);
        if ( ! [knobBlue isOnline] )
            NSLog(@"Warning: knob \"%@\" is not connected", knobBlue);
        
        // register all led that is connected to our "network"
        YColorLed* led = yFirstColorLed();
        while(led){
            [mixer addLED:led];
            led = [led nextColorLed];
        }
        
        // never hanling loop that will..
        while(1){
            // ... handle all event durring 5000ms without using lots of CPU ...
            ySleep(5000, NULL);
            // ... and check for device plug/unplug
            yUpdateDeviceList(NULL);
        }
    }
    return 0;
}



