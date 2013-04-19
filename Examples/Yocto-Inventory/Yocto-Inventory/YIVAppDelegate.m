//
//  YIVAppDelegate.m
//  Yocto-Inventory
//
//  Created by Sébastien Rinsoz on 1/4/12.
//  Copyright (c) 2012 Yoctopuce Sàrl. All rights reserved.
//

#import "YIVAppDelegate.h"
#import "yocto_api.h"

@implementation YIVAppDelegate

@synthesize window = _window;

-(id) init
{
    self = [super init];
    if (self) {
        _modulelist = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSError *error;

    [YAPI DisableExceptions];
    // Insert code here to initialize your application
    // Setup the API to use local USB devices
    if(yRegisterHub(@"usb",&error) != YAPI_SUCCESS) {
        NSString *message = [NSString stringWithFormat:@"RegisterHub error: %@",[error localizedDescription]];
        [_message setStringValue:message];
        NSLog(@"%@\n",message);
        return;
    }
    NSLog(@"we have register USB devices\n");    
    [self updateModuleList:nil];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateModuleList:) userInfo:nil repeats:YES];
}

- (IBAction)updateModuleList:(id)sender {
    NSError *error;
    NSString *message;
    
    if(YISERR(yUpdateDeviceList(&error))) {
        message = [NSString stringWithFormat:@"yUpdateDeviceList has failled:%@",[error localizedDescription]];
        [_message setStringValue:message];
        NSLog(@"%@\n",message);
        return;
    }
    [_modulelist removeAllObjects];
    YModule *mod =  yFirstModule();
    while(mod){
        [_modulelist addObject:mod];
        mod = [mod nextModule]; 
    }
    message = [NSString stringWithFormat:@"%ld Modules detected",(long)[_modulelist count]];
    [_message setStringValue:message];
    [_textView reloadData];
}


-(NSInteger) numberOfRowsInTableView:(NSTabView *)tv
{
    return (NSInteger)[_modulelist count];
}

-(id)               tableView:(NSTabView *) tv
    objectValueForTableColumn:(NSTableColumn *)tableColumn 
                          row:(NSInteger)row
{
    NSString *ident = [tableColumn identifier];
    YModule * m= [_modulelist objectAtIndex:row];
    NSString *value = nil;
    if([ident isEqualToString:@"serial"]){
        value = [m get_serialNumber];
    } else if([ident isEqualToString:@"serial"]){
        value = [m get_logicalName];
    }
    return value;
}

@end
