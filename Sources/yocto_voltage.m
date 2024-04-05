/*********************************************************************
 *
 *  $Id: yocto_voltage.m 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Implements the high-level API for Voltage functions
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


#import "yocto_voltage.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YVoltage
// Constructor is protected, use yFindVoltage factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Voltage";
//--- (YVoltage attributes initialization)
    _enabled = Y_ENABLED_INVALID;
    _valueCallbackVoltage = NULL;
    _timedReportCallbackVoltage = NULL;
//--- (end of YVoltage attributes initialization)
    return self;
}
//--- (YVoltage yapiwrapper)
//--- (end of YVoltage yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YVoltage cleanup)
    ARC_dealloc(super);
//--- (end of YVoltage cleanup)
}
//--- (YVoltage private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YVoltage private methods implementation)
//--- (YVoltage public methods implementation)
/**
 * Returns the activation state of this input.
 *
 * @return either YVoltage.ENABLED_FALSE or YVoltage.ENABLED_TRUE, according to the activation state of this input
 *
 * On failure, throws an exception or returns YVoltage.ENABLED_INVALID.
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
 * Changes the activation state of this voltage input. When AC measurements are disabled,
 * the device will always assume a DC signal, and vice-versa. When both AC and DC measurements
 * are active, the device switches between AC and DC mode based on the relative amplitude
 * of variations compared to the average value.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YVoltage.ENABLED_FALSE or YVoltage.ENABLED_TRUE, according to the activation
 * state of this voltage input
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * Retrieves a voltage sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the voltage sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltage.isOnline() to test if the voltage sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage sensor, for instance
 *         MOTORCTL.voltage.
 *
 * @return a YVoltage object allowing you to drive the voltage sensor.
 */
+(YVoltage*) FindVoltage:(NSString*)func
{
    YVoltage* obj;
    obj = (YVoltage*) [YFunction _FindFromCache:@"Voltage" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YVoltage alloc] initWith:func]);
        [YFunction _AddToCache:@"Voltage" : func :obj];
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
-(int) registerValueCallback:(YVoltageValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackVoltage = callback;
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
    if (_valueCallbackVoltage != NULL) {
        _valueCallbackVoltage(self, value);
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
-(int) registerTimedReportCallback:(YVoltageTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackVoltage = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackVoltage != NULL) {
        _timedReportCallbackVoltage(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YVoltage*)   nextVoltage
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YVoltage FindVoltage:hwid];
}

+(YVoltage *) FirstVoltage
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Voltage":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YVoltage FindVoltage:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YVoltage public methods implementation)
@end

//--- (YVoltage functions)

YVoltage *yFindVoltage(NSString* func)
{
    return [YVoltage FindVoltage:func];
}

YVoltage *yFirstVoltage(void)
{
    return [YVoltage FirstVoltage];
}

//--- (end of YVoltage functions)

