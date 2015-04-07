/*********************************************************************
 *
 * $Id: yocto_led.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for Led functions
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


#import "yocto_led.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YLed

// Constructor is protected, use yFindLed factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Led";
//--- (YLed attributes initialization)
    _power = Y_POWER_INVALID;
    _luminosity = Y_LUMINOSITY_INVALID;
    _blinking = Y_BLINKING_INVALID;
    _valueCallbackLed = NULL;
//--- (end of YLed attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YLed cleanup)
    ARC_dealloc(super);
//--- (end of YLed cleanup)
}
//--- (YLed private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "power")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _power =  (Y_POWER_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "luminosity")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _luminosity =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinking")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinking =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YLed private methods implementation)
//--- (YLed public methods implementation)
/**
 * Returns the current led state.
 *
 * @return either Y_POWER_OFF or Y_POWER_ON, according to the current led state
 *
 * On failure, throws an exception or returns Y_POWER_INVALID.
 */
-(Y_POWER_enum) get_power
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWER_INVALID;
        }
    }
    return _power;
}


-(Y_POWER_enum) power
{
    return [self get_power];
}

/**
 * Changes the state of the led.
 *
 * @param newval : either Y_POWER_OFF or Y_POWER_ON, according to the state of the led
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_power:(Y_POWER_enum) newval
{
    return [self setPower:newval];
}
-(int) setPower:(Y_POWER_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"power" :rest_val];
}
/**
 * Returns the current led intensity (in per cent).
 *
 * @return an integer corresponding to the current led intensity (in per cent)
 *
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int) get_luminosity
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LUMINOSITY_INVALID;
        }
    }
    return _luminosity;
}


-(int) luminosity
{
    return [self get_luminosity];
}

/**
 * Changes the current led intensity (in per cent).
 *
 * @param newval : an integer corresponding to the current led intensity (in per cent)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_luminosity:(int) newval
{
    return [self setLuminosity:newval];
}
-(int) setLuminosity:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"luminosity" :rest_val];
}
/**
 * Returns the current led signaling mode.
 *
 * @return a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current led signaling mode
 *
 * On failure, throws an exception or returns Y_BLINKING_INVALID.
 */
-(Y_BLINKING_enum) get_blinking
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKING_INVALID;
        }
    }
    return _blinking;
}


-(Y_BLINKING_enum) blinking
{
    return [self get_blinking];
}

/**
 * Changes the current led signaling mode.
 *
 * @param newval : a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current led signaling mode
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_blinking:(Y_BLINKING_enum) newval
{
    return [self setBlinking:newval];
}
-(int) setBlinking:(Y_BLINKING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"blinking" :rest_val];
}
/**
 * Retrieves $AFUNCTION$ for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that $THEFUNCTION$ is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YLed object allowing you to drive $THEFUNCTION$.
 */
+(YLed*) FindLed:(NSString*)func
{
    YLed* obj;
    obj = (YLed*) [YFunction _FindFromCache:@"Led" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YLed alloc] initWith:func]);
        [YFunction _AddToCache:@"Led" : func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YLedValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackLed = callback;
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
    if (_valueCallbackLed != NULL) {
        _valueCallbackLed(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YLed*)   nextLed
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YLed FindLed:hwid];
}

+(YLed *) FirstLed
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Led":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YLed FindLed:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YLed public methods implementation)

@end
//--- (Led functions)

YLed *yFindLed(NSString* func)
{
    return [YLed FindLed:func];
}

YLed *yFirstLed(void)
{
    return [YLed FirstLed];
}

//--- (end of Led functions)
