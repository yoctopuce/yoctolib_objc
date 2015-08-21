/*********************************************************************
 *
 * $Id: yocto_humidity.m 21211 2015-08-19 16:03:29Z seb $
 *
 * Implements the high-level API for Humidity functions
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


#import "yocto_humidity.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YHumidity

// Constructor is protected, use yFindHumidity factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Humidity";
//--- (YHumidity attributes initialization)
    _relHum = Y_RELHUM_INVALID;
    _absHum = Y_ABSHUM_INVALID;
    _valueCallbackHumidity = NULL;
    _timedReportCallbackHumidity = NULL;
//--- (end of YHumidity attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YHumidity cleanup)
    ARC_dealloc(super);
//--- (end of YHumidity cleanup)
}
//--- (YHumidity private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "relHum")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _relHum =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "absHum")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _absHum =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YHumidity private methods implementation)
//--- (YHumidity public methods implementation)

/**
 * Changes the primary unit for measuring humidity. That unit is a string.
 * If that strings starts with the letter 'g', the primary measured value is the absolute
 * humidity, in g/m3. Otherwise, the primary measured value will be the relative humidity
 * (RH), in per cents.
 *
 * Remember to call the saveToFlash() method of the module if the modification
 * must be kept.
 *
 * @param newval : a string corresponding to the primary unit for measuring humidity
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_unit:(NSString*) newval
{
    return [self setUnit:newval];
}
-(int) setUnit:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"unit" :rest_val];
}
/**
 * Returns the current relative humidity, in per cents.
 *
 * @return a floating point number corresponding to the current relative humidity, in per cents
 *
 * On failure, throws an exception or returns Y_RELHUM_INVALID.
 */
-(double) get_relHum
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RELHUM_INVALID;
        }
    }
    return _relHum;
}


-(double) relHum
{
    return [self get_relHum];
}
/**
 * Returns the current absolute humidity, in grams per cubic meter of air.
 *
 * @return a floating point number corresponding to the current absolute humidity, in grams per cubic meter of air
 *
 * On failure, throws an exception or returns Y_ABSHUM_INVALID.
 */
-(double) get_absHum
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ABSHUM_INVALID;
        }
    }
    return _absHum;
}


-(double) absHum
{
    return [self get_absHum];
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
 * Use the method YHumidity.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YHumidity object allowing you to drive $THEFUNCTION$.
 */
+(YHumidity*) FindHumidity:(NSString*)func
{
    YHumidity* obj;
    obj = (YHumidity*) [YFunction _FindFromCache:@"Humidity" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YHumidity alloc] initWith:func]);
        [YFunction _AddToCache:@"Humidity" : func :obj];
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
-(int) registerValueCallback:(YHumidityValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackHumidity = callback;
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
    if (_valueCallbackHumidity != NULL) {
        _valueCallbackHumidity(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YHumidityTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackHumidity = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackHumidity != NULL) {
        _timedReportCallbackHumidity(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YHumidity*)   nextHumidity
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YHumidity FindHumidity:hwid];
}

+(YHumidity *) FirstHumidity
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Humidity":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YHumidity FindHumidity:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YHumidity public methods implementation)

@end
//--- (Humidity functions)

YHumidity *yFindHumidity(NSString* func)
{
    return [YHumidity FindHumidity:func];
}

YHumidity *yFirstHumidity(void)
{
    return [YHumidity FirstHumidity];
}

//--- (end of Humidity functions)
