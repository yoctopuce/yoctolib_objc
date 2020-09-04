/*********************************************************************
 *
 *  $Id: yocto_servo.m 41625 2020-08-31 07:09:39Z seb $
 *
 *  Implements the high-level API for Servo functions
 *
 *  - - - - - - - - - License information: - - - - - - - - -
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
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Servo";
//--- (YServo attributes initialization)
    _position = Y_POSITION_INVALID;
    _enabled = Y_ENABLED_INVALID;
    _range = Y_RANGE_INVALID;
    _neutral = Y_NEUTRAL_INVALID;
    _move = Y_MOVE_INVALID;
    _positionAtPowerOn = Y_POSITIONATPOWERON_INVALID;
    _enabledAtPowerOn = Y_ENABLEDATPOWERON_INVALID;
    _valueCallbackServo = NULL;
//--- (end of YServo attributes initialization)
    return self;
}
//--- (YServo yapiwrapper)
//--- (end of YServo yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YServo cleanup)
    ARC_dealloc(super);
//--- (end of YServo cleanup)
}
//--- (YServo private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "position")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _position =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "range")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _range =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "neutral")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _neutral =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "move")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        if(j->st == YJSON_PARSE_STRUCT) {
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _move.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _move.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _move.ms = atoi(j->token);
                }
            }
        }
        return 1;
    }
    if(!strcmp(j->token, "positionAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _positionAtPowerOn =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "enabledAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabledAtPowerOn =  (Y_ENABLEDATPOWERON_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YServo private methods implementation)
//--- (YServo public methods implementation)
/**
 * Returns the current servo position.
 *
 * @return an integer corresponding to the current servo position
 *
 * On failure, throws an exception or returns Y_POSITION_INVALID.
 */
-(int) get_position
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POSITION_INVALID;
        }
    }
    res = _position;
    return res;
}


-(int) position
{
    return [self get_position];
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
 * Returns the state of the RC servo motors.
 *
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the state of the RC servo motors
 *
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    Y_ENABLED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLED_INVALID;
        }
    }
    res = _enabled;
    return res;
}


-(Y_ENABLED_enum) enabled
{
    return [self get_enabled];
}

/**
 * Stops or starts the RC servo motor.
 *
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabled:(Y_ENABLED_enum) newval
{
    return [self setEnabled:newval];
}
-(int) setEnabled:(Y_ENABLED_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabled" :rest_val];
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RANGE_INVALID;
        }
    }
    res = _range;
    return res;
}


-(int) range
{
    return [self get_range];
}

/**
 * Changes the range of use of the servo, specified in per cents.
 * A range of 100% corresponds to a standard control signal, that varies
 * from 1 [ms] to 2 [ms], When using a servo that supports a double range,
 * from 0.5 [ms] to 2.5 [ms], you can select a range of 200%.
 * Be aware that using a range higher than what is supported by the servo
 * is likely to damage the servo. Remember to call the matching module
 * saveToFlash() method, otherwise this call will have no effect.
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
    rest_val = [NSString stringWithFormat:@"%d", newval];
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEUTRAL_INVALID;
        }
    }
    res = _neutral;
    return res;
}


-(int) neutral
{
    return [self get_neutral];
}

/**
 * Changes the duration of the pulse corresponding to the neutral position of the servo.
 * The duration is specified in microseconds, and the standard value is 1500 [us].
 * This setting makes it possible to shift the range of use of the servo.
 * Be aware that using a range higher than what is supported by the servo is
 * likely to damage the servo. Remember to call the matching module
 * saveToFlash() method, otherwise this call will have no effect.
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
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"neutral" :rest_val];
}
-(YMove) get_move
{
    YMove res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MOVE_INVALID;
        }
    }
    res = _move;
    return res;
}


-(YMove) move
{
    return [self get_move];
}

-(int) set_move:(YMove) newval
{
    return [self setMove:newval];
}
-(int) setMove:(YMove) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",newval.target,newval.ms];
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
-(int) move:(int)target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms_duration];
    return [self _setAttr:@"move" :rest_val];
}
/**
 * Returns the servo position at device power up.
 *
 * @return an integer corresponding to the servo position at device power up
 *
 * On failure, throws an exception or returns Y_POSITIONATPOWERON_INVALID.
 */
-(int) get_positionAtPowerOn
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POSITIONATPOWERON_INVALID;
        }
    }
    res = _positionAtPowerOn;
    return res;
}


-(int) positionAtPowerOn
{
    return [self get_positionAtPowerOn];
}

/**
 * Configure the servo position at device power up. Remember to call the matching
 * module saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_positionAtPowerOn:(int) newval
{
    return [self setPositionAtPowerOn:newval];
}
-(int) setPositionAtPowerOn:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"positionAtPowerOn" :rest_val];
}
/**
 * Returns the servo signal generator state at power up.
 *
 * @return either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE, according to the servo signal
 * generator state at power up
 *
 * On failure, throws an exception or returns Y_ENABLEDATPOWERON_INVALID.
 */
-(Y_ENABLEDATPOWERON_enum) get_enabledAtPowerOn
{
    Y_ENABLEDATPOWERON_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLEDATPOWERON_INVALID;
        }
    }
    res = _enabledAtPowerOn;
    return res;
}


-(Y_ENABLEDATPOWERON_enum) enabledAtPowerOn
{
    return [self get_enabledAtPowerOn];
}

/**
 * Configure the servo signal generator state at power up. Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval
{
    return [self setEnabledAtPowerOn:newval];
}
-(int) setEnabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabledAtPowerOn" :rest_val];
}
/**
 * Retrieves a RC servo motor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RC servo motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YServo.isOnline() to test if the RC servo motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RC servo motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RC servo motor, for instance
 *         SERVORC1.servo1.
 *
 * @return a YServo object allowing you to drive the RC servo motor.
 */
+(YServo*) FindServo:(NSString*)func
{
    YServo* obj;
    obj = (YServo*) [YFunction _FindFromCache:@"Servo" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YServo alloc] initWith:func]);
        [YFunction _AddToCache:@"Servo" : func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YServoValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackServo = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackServo != NULL) {
        _valueCallbackServo(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YServo*)   nextServo
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YServo FindServo:hwid];
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

//--- (end of YServo public methods implementation)

@end
//--- (YServo functions)

YServo *yFindServo(NSString* func)
{
    return [YServo FindServo:func];
}

YServo *yFirstServo(void)
{
    return [YServo FirstServo];
}

//--- (end of YServo functions)
