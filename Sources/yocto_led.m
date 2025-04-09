/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Led functions
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
//--- (YLed yapiwrapper)
//--- (end of YLed yapiwrapper)
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
 * Returns the current LED state.
 *
 * @return either YLed.POWER_OFF or YLed.POWER_ON, according to the current LED state
 *
 * On failure, throws an exception or returns YLed.POWER_INVALID.
 */
-(Y_POWER_enum) get_power
{
    Y_POWER_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWER_INVALID;
        }
    }
    res = _power;
    return res;
}


-(Y_POWER_enum) power
{
    return [self get_power];
}

/**
 * Changes the state of the LED.
 *
 * @param newval : either YLed.POWER_OFF or YLed.POWER_ON, according to the state of the LED
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * Returns the current LED intensity (in per cent).
 *
 * @return an integer corresponding to the current LED intensity (in per cent)
 *
 * On failure, throws an exception or returns YLed.LUMINOSITY_INVALID.
 */
-(int) get_luminosity
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LUMINOSITY_INVALID;
        }
    }
    res = _luminosity;
    return res;
}


-(int) luminosity
{
    return [self get_luminosity];
}

/**
 * Changes the current LED intensity (in per cent). Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the current LED intensity (in per cent)
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * Returns the current LED signaling mode.
 *
 * @return a value among YLed.BLINKING_STILL, YLed.BLINKING_RELAX, YLed.BLINKING_AWARE,
 * YLed.BLINKING_RUN, YLed.BLINKING_CALL and YLed.BLINKING_PANIC corresponding to the current LED signaling mode
 *
 * On failure, throws an exception or returns YLed.BLINKING_INVALID.
 */
-(Y_BLINKING_enum) get_blinking
{
    Y_BLINKING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKING_INVALID;
        }
    }
    res = _blinking;
    return res;
}


-(Y_BLINKING_enum) blinking
{
    return [self get_blinking];
}

/**
 * Changes the current LED signaling mode.
 *
 * @param newval : a value among YLed.BLINKING_STILL, YLed.BLINKING_RELAX, YLed.BLINKING_AWARE,
 * YLed.BLINKING_RUN, YLed.BLINKING_CALL and YLed.BLINKING_PANIC corresponding to the current LED signaling mode
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * Retrieves a monochrome LED for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the monochrome LED is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if the monochrome LED is
 * indeed online at a given time. In case of ambiguity when looking for
 * a monochrome LED by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the monochrome LED, for instance
 *         YBUZZER2.led1.
 *
 * @return a YLed object allowing you to drive the monochrome LED.
 */
+(YLed*) FindLed:(NSString*)func
{
    YLed* obj;
    obj = (YLed*) [YFunction _FindFromCache:@"Led" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YLed alloc] initWith:func]);
        [YFunction _AddToCache:@"Led" :func :obj];
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
-(int) registerValueCallback:(YLedValueCallback _Nullable)callback
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

//--- (YLed functions)

YLed *yFindLed(NSString* func)
{
    return [YLed FindLed:func];
}

YLed *yFirstLed(void)
{
    return [YLed FirstLed];
}

//--- (end of YLed functions)

