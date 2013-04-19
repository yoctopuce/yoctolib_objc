//
//  YIVAppDelegate.h
//  Yocto-Inventory
//
//  Created by Sébastien Rinsoz on 1/4/12.
//  Copyright (c) 2012 Yoctopuce Sàrl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YIVAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextFieldCell *_message;
    IBOutlet NSTableView    *_textView;

    NSMutableArray          *_modulelist;
    NSTimer                 *_timer;
}
@property (unsafe_unretained) IBOutlet NSWindow *window;
- (IBAction)updateModuleList:(id)sender;

@end
