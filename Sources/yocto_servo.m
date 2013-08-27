/*********************************************************************
 *
 * $Id: yocto_servo.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindServo(), the high-level API for Servo functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 *  Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 *  Yoctopuce Sarl (hereafter Licensor) grants to you a perpetual
 *  non-exclusive license to use, modify, copy and integrate this
 *  file into your software for the sole purpose of interfacing 
 *  with Yoctopuce products. 
 *
 *  You may reproduce and distribute copies of this file in 
 *  source or object form, as long as the sole purpose of this
 *  code is to interface with Yoctopuce products. You must retain 
 *  this notice in the distributed source file.
 *
 *  You should refer to Yoctopuce General Terms and Conditions
 *  for additional information regarding your rights and 
 *  obligations.
 *
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *  WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *  WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *  FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *  EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *  INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *  COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *  SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *  LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *  CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *  BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *  WARRANTY, OR OTHERWISE.
 *
 *********************************************************************/


#import "yocto_servo.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YServo

// Constructor is protected, use yFindServo factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YServo attributes)
   if(!(self = [super initProtected:@"Servo":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _position = Y_POSITION_INVALID;
    _range = Y_RANGE_INVALID;
    _neutral = Y_NEUTRAL_INVALID;
//--- (end of YServo attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YServo cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of YServo cleanup)
    ARC_dealloc(super);
}
//--- (YServo implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "position")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _position =  atoi(j->token);
        } else if(!strcmp(j->token, "range")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _range =  atoi(j->token);
        } else if(!strcmp(j->token, "neutral")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _neutral =  atoi(j->token);
        } else if(!strcmp(j->token, "move")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the servo.
 * 
 * @return a string corresponding to the logical name of the servo
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * Changes the logical name of the servo. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the servo
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the servo (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the servo (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the current servo position.
 * 
 * @return an integer corresponding to the current servo position
 * 
 * On failure, throws an exception or returns Y_POSITION_INVALID.
 */
-(int) get_position
{
    return [self position];
}
-(int) position
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_POSITION_INVALID;
    }
    return _position;
}

/**
 * Changes immediately the servo driving position.
 * 
 * @param newval : an integer corresponding to immediately the servo driving position
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_position:(int) newval
{
    return [self setPosition:newval];
}
-(int) setPosition:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"position" :rest_val];
}

/**
 * Returns the current range of use of the servo.
 * 
 * @return an integer corresponding to the current range of use of the servo
 * 
 * On failure, throws an exception or returns Y_RANGE_INVALID.
 */
-(int) get_range
{
    return [self range];
}
-(int) range
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RANGE_INVALID;
    }
    return _range;
}

/**
 * Changes the range of use of the servo, specified in per cents.
 * A range of 100% corresponds to a standard control signal, that varies
 * from 1 [ms] to 2 [ms], When using a servo that supports a double range,
 * from 0.5 [ms] to 2.5 [ms], you can select a range of 200%.
 * Be aware that using a range higher than what is supported by the servo
 * is likely to damage the servo.
 * 
 * @param newval : an integer corresponding to the range of use of the servo, specified in per cents
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_range:(int) newval
{
    return [self setRange:newval];
}
-(int) setRange:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"range" :rest_val];
}

/**
 * Returns the duration in microseconds of a neutral pulse for the servo.
 * 
 * @return an integer corresponding to the duration in microseconds of a neutral pulse for the servo
 * 
 * On failure, throws an exception or returns Y_NEUTRAL_INVALID.
 */
-(int) get_neutral
{
    return [self neutral];
}
-(int) neutral
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_NEUTRAL_INVALID;
    }
    return _neutral;
}

/**
 * Changes the duration of the pulse corresponding to the neutral position of the servo.
 * The duration is specified in microseconds, and the standard value is 1500 [us].
 * This setting makes it possible to shift the range of use of the servo.
 * Be aware that using a range higher than what is supported by the servo is
 * likely to damage the servo.
 * 
 * @param newval : an integer corresponding to the duration of the pulse corresponding to the neutral
 * position of the servo
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_neutral:(int) newval
{
    return [self setNeutral:newval];
}
-(int) setNeutral:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"neutral" :rest_val];
}

-(YRETCODE) get_move :(s32*)target :(s16*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _move.target;
    *ms = _move.ms;
    *moving = _move.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_move :(s32)target :(s16)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
    return [self _setAttr:@"move" :rest_val];
}

/**
 * Performs a smooth move at constant speed toward a given position.
 * 
 * @param target      : new position at the end of the move
 * @param ms_duration : total duration of the move, in milliseconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) move :(int)target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms_duration];
    return [self _setAttr:@"move" :rest_val];
}

-(YServo*)   nextServo
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindServo(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YServo*) FindServo:(NSString*) func
{
    YServo * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YServo"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YServo"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YServo"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YServo"] objectForKey:func];
    } else {
        retVal = [[YServo alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YServo"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YServo *) FirstServo
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Servo":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YServo FindServo:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YServo implementation)

@end
//--- (Servo functions)

YServo *yFindServo(NSString* func)
{
    return [YServo FindServo:func];
}

YServo *yFirstServo(void)
{
    return [YServo FirstServo];
}

//--- (end of Servo functions)
