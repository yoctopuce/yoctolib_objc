/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Counter functions
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


#import "yocto_counter.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YCounter
// Constructor is protected, use yFindCounter factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Counter";
//--- (YCounter attributes initialization)
    _decimalMode = Y_DECIMALMODE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackCounter = NULL;
    _timedReportCallbackCounter = NULL;
//--- (end of YCounter attributes initialization)
    return self;
}
//--- (YCounter yapiwrapper)
//--- (end of YCounter yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YCounter cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YCounter cleanup)
}
//--- (YCounter private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "decimalMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _decimalMode =  (Y_DECIMALMODE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YCounter private methods implementation)
//--- (YCounter public methods implementation)
/**
 * Returns a value indicating if the senseur compute whole or fractional values.
 *
 * @return either YCounter.DECIMALMODE_FALSE or YCounter.DECIMALMODE_TRUE, according to a value
 * indicating if the senseur compute whole or fractional values
 *
 * On failure, throws an exception or returns YCounter.DECIMALMODE_INVALID.
 */
-(Y_DECIMALMODE_enum) get_decimalMode
{
    Y_DECIMALMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DECIMALMODE_INVALID;
        }
    }
    res = _decimalMode;
    return res;
}


-(Y_DECIMALMODE_enum) decimalMode
{
    return [self get_decimalMode];
}

/**
 * Changes the sensor's operating mode so that it computes integer or decimal values.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YCounter.DECIMALMODE_FALSE or YCounter.DECIMALMODE_TRUE, according to the
 * sensor's operating mode so that it computes integer or decimal values
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_decimalMode:(Y_DECIMALMODE_enum) newval
{
    return [self setDecimalMode:newval];
}
-(int) setDecimalMode:(Y_DECIMALMODE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"decimalMode" :rest_val];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a counter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the counter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCounter.isOnline() to test if the counter is
 * indeed online at a given time. In case of ambiguity when looking for
 * a counter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the counter, for instance
 *         MyDevice.counter.
 *
 * @return a YCounter object allowing you to drive the counter.
 */
+(YCounter*) FindCounter:(NSString*)func
{
    YCounter* obj;
    obj = (YCounter*) [YFunction _FindFromCache:@"Counter" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YCounter alloc] initWith:func]);
        [YFunction _AddToCache:@"Counter" :func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is then invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness,
 * remember to call one of these two functions periodically. The callback is called once juste after beeing
 * registered, passing the current advertised value  of the function, provided that it is not an empty string.
 * To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YCounterValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackCounter = callback;
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
    if (_valueCallbackCounter != NULL) {
        _valueCallbackCounter(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YCounterTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackCounter = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackCounter != NULL) {
        _timedReportCallbackCounter(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)command
{
    return [self set_command:command];
}

/**
 * Reset the counter to zero.
 *
 * @return YAPI.SUCCESS if the call succeeds. Please note that this function only resets
 *         the integer part of the counter. In CONTINUOUS mode, the decimal part is calculated
 *         from the angle measured by the sensor. To set the decimal part of the sensor to zero,
 *         the origin of the sensor must be changed with the YOrientation.zero().
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) zero
{
    return [self sendCommand:@"Z"];
}


-(YCounter*)   nextCounter
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YCounter FindCounter:hwid];
}

+(YCounter *) FirstCounter
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Counter":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YCounter FindCounter:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YCounter public methods implementation)
@end

//--- (YCounter functions)

YCounter *yFindCounter(NSString* func)
{
    return [YCounter FindCounter:func];
}

YCounter *yFirstCounter(void)
{
    return [YCounter FirstCounter];
}

//--- (end of YCounter functions)

