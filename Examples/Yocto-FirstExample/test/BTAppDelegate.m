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

#import "BTAppDelegate.h"

@implementation BTAppDelegate
@synthesize _beacon;
@synthesize _tempDisplay;

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSError *error;
    if(YISERR([YAPI RegisterHub:@"usb" :&error])){
        NSLog(@"errmgs=%@\n",[error localizedDescription]);
    }
    _tempSensor = [YTemperature FirstTemperature];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];

    
}
-(void) update
{
    if([_tempSensor isOnline]){
        [_tempDisplay setFloatValue:[_tempSensor get_currentValue]];
        YModule *moduleOfTempSensor=[_tempSensor module];
        [_beacon setState:[moduleOfTempSensor get_beacon]];
    }else{
        [_tempDisplay setStringValue:@"disconnected"];
    }
}

- (IBAction)_SetBeacon:(id)sender 
{
    if(![_tempSensor isOnline])
        return;
    if([sender state])
        [[_tempSensor module] set_beacon:Y_BEACON_ON];
    else
        [[_tempSensor module] set_beacon:Y_BEACON_OFF];
        
}


@end
