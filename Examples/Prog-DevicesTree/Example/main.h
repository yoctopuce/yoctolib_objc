//
//  main.h
//  Example
//
//  Created by Sébastien Rinsoz on 17.01.16.
//  Copyright © 2016 Yoctopuce Sàrl. All rights reserved.
//

#ifndef main_h
#define main_h

#import <Foundation/Foundation.h>


@interface  YoctoShield : NSObject
{
@private
    NSString*         _serial;
    NSMutableArray*  _subDevices;
}

// Constructor is private, use getDevice factory method
-(id)           initWithSerial:(NSString*)serial;
-(NSString*)	getSerial;
-(bool) 		addSubDevice:(NSString*) serial;
-(void)    		removeSubDevice:(NSString*) serial;
-(void) 		describe;
@end


@interface  RootDevice : NSObject
{
@private
    NSString*         _serial;
    NSString*         _url;
    NSMutableArray*  _shields;
    NSMutableArray*  _subDevices;
}

// Constructor is private, use getDevice factory method
-(id)           initWithSerial:(NSString*)serial :(NSString*)url;
-(NSString*)	getSerial;
-(void) 		addSubDevice:(NSString*) serial;
-(void)    		removeSubDevice:(NSString*) serial;
-(void) 		describe;
@end


#endif /* main_h */
