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

#import <Cocoa/Cocoa.h>
#import "yocto_api.h"

@interface YCAppDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableArray  *_modulelist;
    YModule         *_ledmodule;
    NSTimer         *_timer;
    IBOutlet NSComboBox *_combobox;
    IBOutlet NSTextFieldCell *_serial;
    IBOutlet NSTextField *_productName;
    IBOutlet NSTextField *_logicalName;
    IBOutlet NSTextField *_firmware;
    IBOutlet NSButton *_beacon;
    IBOutlet NSSlider *_luminosity;
    IBOutlet NSColorWell *_led1;
    IBOutlet NSColorWell *_led2;
}

@property (assign) IBOutlet NSWindow *window;

// Device handling related
-(void)         DeviceUpdate:(YModule*)module;
-(void)         DevicePlug:(YModule *)  module;
-(void)         DeviceUnplug:(YModule *)  module;
- (void)         refreshInfos;
- (IBAction)    updateModuleList:(id)sender;
- (IBAction)    updateToDevice:(id)sender;
// NSComboBox Related
- (NSInteger)   numberOfItemsInComboBox:(NSComboBox *)cb;
- (id)          comboBox:(NSComboBox *) tv objectValueForItemAtIndex:(NSInteger)index;
- (void)        comboBoxSelectionDidChange:(NSNotification *)notification;


@end
