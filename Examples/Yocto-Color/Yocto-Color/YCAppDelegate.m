/*********************************************************************
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived 
 *    material from this source file.
 *
 *********************************************************************/

#import "YCAppDelegate.h"
#import "yocto_api.h"
#import "yocto_colorled.h"

@implementation YCAppDelegate

@synthesize window = _window;


static YCAppDelegate *appdelegate;

-(id) init
{
    self = [super init];
    if (self) {
        _modulelist = [[NSMutableArray alloc] init];
    }
    return self;
}

static void  DeviceUpdate(YModule * module)
{
    NSLog(@"update %p\n",module);
    [appdelegate DeviceUpdate:module];
}

static void  DevicePlug(YModule * module)
{
    [appdelegate DevicePlug:module];
}

static void  DeviceUnplug(YModule * module)
{
    [appdelegate DeviceUnplug:module];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    // Setup the API to use local USB devices
    NSError *errmsg;
    yDisableExceptions();
    if(yRegisterHub(@"usb",&errmsg) != YAPI_SUCCESS) {
        NSString *message = [NSString stringWithFormat:@"RegisterHub error: %@",[errmsg localizedDescription]];
        NSLog(@"%@\n",message);
        return;
    }
    appdelegate = self;
    yRegisterDeviceChangeCallback(DeviceUpdate);
    yRegisterDeviceArrivalCallback(DevicePlug);
    yRegisterDeviceRemovalCallback(DeviceUnplug);
    [self updateModuleList:nil];
    [self refreshInfos];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateModuleList:) userInfo:nil repeats:YES];
}



-(void) DeviceUpdate:(YModule *)  module
{
    [self refreshInfos];
}

-(void) DevicePlug:(YModule *)  module
{
    NSLog(@"DevicePlug: %p %@\n",module,[module get_serialNumber]);
    if([[module get_productName] isEqualToString:@"Yocto-Color"]){
        [_modulelist addObject:module];
        if(_ledmodule ==nil){
            [_combobox reloadData];            [_combobox selectItemAtIndex:0];
            _ledmodule = module;
            [self refreshInfos];
        }
    }
}

-(void) DeviceUnplug:(YModule *)  module
{
    NSLog(@"DeviceUnPlug: %p %@\n",module,[module get_serialNumber]);
    if([[module get_productName] isEqualToString:@"Yocto-Color"]){
        [_modulelist removeObjectIdenticalTo:module];
        if(_ledmodule == module){
            [_combobox reloadData];
            _ledmodule =nil;
            [self refreshInfos];
        }
    }
}





- (IBAction)updateModuleList:(id)sender {
    NSError *errmsg;
    NSString *message;
    
    if(YISERR(yUpdateDeviceList(&errmsg))) {
        message = [NSString stringWithFormat:@"yUpdateDeviceList has failled:%@",[errmsg localizedDescription]];
        NSLog(@"%@\n",message);
        return;
    }
    if(YISERR(yHandleEvents(&errmsg))) {
        message = [NSString stringWithFormat:@"yHandleEvents has failled:%@",[errmsg localizedDescription]];
        NSLog(@"%@\n",message);
        return;
    }
    
}


-(NSInteger) numberOfItemsInComboBox:(NSComboBox *)cb
{
    return (NSInteger)[_modulelist count];
}


-(id)               comboBox:(NSComboBox *) tv
    objectValueForItemAtIndex:(NSInteger)index 
{
    YModule * m= [_modulelist objectAtIndex:index];
    NSString *value = [m get_serialNumber];
    return value;
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    NSInteger index   = [_combobox indexOfSelectedItem];
    if(index == -1){
        return;
    }
    _ledmodule = [_modulelist objectAtIndex:index];
    [self refreshInfos];
}


static NSColor* colorFromRGB(NSInteger rgbcolor)
{
    CGFloat rFloat = ((rgbcolor>>16)&0xff);
    CGFloat gFloat = ((rgbcolor>>8)&0xff);
    CGFloat bFloat = (rgbcolor&0xff);
    return [NSColor colorWithCalibratedRed:rFloat/255 green:gFloat/255 blue:bFloat/255 alpha:1.0];
}

static NSInteger RGBFromColor(NSColor *color)
{
    CGFloat red = [color redComponent] * 255.0;
    CGFloat green = [color greenComponent] * 255.0;
    CGFloat blue = [color blueComponent] * 255.0;
    return ((NSInteger)red << 16) + ((NSInteger)green << 8) + (NSInteger)blue;
}






-(void)    refreshInfos
{
    NSLog(@"refresh module infos\n");
    if(_ledmodule==nil){
        [_serial setStringValue:@"invalid"];
        [_productName setStringValue:@"invalid"];
        [_logicalName setStringValue:@"invalid"];
        [_firmware    setStringValue:@"invalid"];
        [_beacon setState:NSOffState];
        [_led1 setColor:[NSColor blackColor]];
        [_led2 setColor:[NSColor blackColor]];
    }else{
        NSString *serial = [_ledmodule get_serialNumber];
        [_serial setStringValue:serial];
        [_productName setStringValue:[_ledmodule get_productName]];
        [_logicalName setStringValue:[_ledmodule get_logicalName]];
        [_firmware    setStringValue:[_ledmodule get_firmwareRelease]];
        if([_ledmodule get_beacon] == Y_BEACON_ON){
            [_beacon setState:NSOnState];
        }else{
            [_beacon setState:NSOffState];
        }
        [_luminosity setIntValue:[_ledmodule get_luminosity]];
    
        YColorLed *led1 = yFindColorLed([serial stringByAppendingString:@".colorLed1"]);
        NSInteger color = [led1 get_rgbColor];
        [_led1 setColor:colorFromRGB(color)];
    
        YColorLed *led2 = yFindColorLed([serial stringByAppendingString:@".colorLed2"]);
        NSInteger color2 = [led2 get_rgbColor];
        [_led2 setColor:colorFromRGB(color2)];
    }
}




- (IBAction)updateToDevice:(id)sender 
{
    if(_ledmodule==nil)
        return;
    if([_beacon state])
        [_ledmodule set_beacon:Y_BEACON_ON];
    else
        [_ledmodule set_beacon:Y_BEACON_OFF];
        
    [_ledmodule set_luminosity:[_luminosity intValue]];

    NSString *serial = [_ledmodule get_serialNumber];
    YColorLed *led1 = yFindColorLed([serial stringByAppendingString:@".colorLed1"]);
    [led1 set_rgbColor:(int)RGBFromColor([_led1 color])];
    
    YColorLed *led2 = yFindColorLed([serial stringByAppendingString:@".colorLed2"]);
    [led2 set_rgbColor:(int)RGBFromColor([_led2 color])];
  
        
}


@end
