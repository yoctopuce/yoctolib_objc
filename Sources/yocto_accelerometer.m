/*********************************************************************
 *
 * $Id: yocto_accelerometer.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for Accelerometer functions
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


#import "yocto_accelerometer.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YAccelerometer

// Constructor is protected, use yFindAccelerometer factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Accelerometer";
//--- (YAccelerometer attributes initialization)
    _xValue = Y_XVALUE_INVALID;
    _yValue = Y_YVALUE_INVALID;
    _zValue = Y_ZVALUE_INVALID;
    _gravityCancellation = Y_GRAVITYCANCELLATION_INVALID;
    _valueCallbackAccelerometer = NULL;
    _timedReportCallbackAccelerometer = NULL;
//--- (end of YAccelerometer attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YAccelerometer cleanup)
    ARC_dealloc(super);
//--- (end of YAccelerometer cleanup)
}
//--- (YAccelerometer private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "xValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _xValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "yValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _yValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "zValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _zValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "gravityCancellation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _gravityCancellation =  (Y_GRAVITYCANCELLATION_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YAccelerometer private methods implementation)
//--- (YAccelerometer public methods implementation)
/**
 * Returns the X component of the acceleration, as a floating point number.
 *
 * @return a floating point number corresponding to the X component of the acceleration, as a floating point number
 *
 * On failure, throws an exception or returns Y_XVALUE_INVALID.
 */
-(double) get_xValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_XVALUE_INVALID;
        }
    }
    return _xValue;
}


-(double) xValue
{
    return [self get_xValue];
}
/**
 * Returns the Y component of the acceleration, as a floating point number.
 *
 * @return a floating point number corresponding to the Y component of the acceleration, as a floating point number
 *
 * On failure, throws an exception or returns Y_YVALUE_INVALID.
 */
-(double) get_yValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_YVALUE_INVALID;
        }
    }
    return _yValue;
}


-(double) yValue
{
    return [self get_yValue];
}
/**
 * Returns the Z component of the acceleration, as a floating point number.
 *
 * @return a floating point number corresponding to the Z component of the acceleration, as a floating point number
 *
 * On failure, throws an exception or returns Y_ZVALUE_INVALID.
 */
-(double) get_zValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ZVALUE_INVALID;
        }
    }
    return _zValue;
}


-(double) zValue
{
    return [self get_zValue];
}
-(Y_GRAVITYCANCELLATION_enum) get_gravityCancellation
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_GRAVITYCANCELLATION_INVALID;
        }
    }
    return _gravityCancellation;
}


-(Y_GRAVITYCANCELLATION_enum) gravityCancellation
{
    return [self get_gravityCancellation];
}

-(int) set_gravityCancellation:(Y_GRAVITYCANCELLATION_enum) newval
{
    return [self setGravityCancellation:newval];
}
-(int) setGravityCancellation:(Y_GRAVITYCANCELLATION_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"gravityCancellation" :rest_val];
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
 * Use the method YAccelerometer.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YAccelerometer object allowing you to drive $THEFUNCTION$.
 */
+(YAccelerometer*) FindAccelerometer:(NSString*)func
{
    YAccelerometer* obj;
    obj = (YAccelerometer*) [YFunction _FindFromCache:@"Accelerometer" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YAccelerometer alloc] initWith:func]);
        [YFunction _AddToCache:@"Accelerometer" : func :obj];
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
-(int) registerValueCallback:(YAccelerometerValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackAccelerometer = callback;
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
    if (_valueCallbackAccelerometer != NULL) {
        _valueCallbackAccelerometer(self, value);
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
-(int) registerTimedReportCallback:(YAccelerometerTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackAccelerometer = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackAccelerometer != NULL) {
        _timedReportCallbackAccelerometer(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YAccelerometer*)   nextAccelerometer
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YAccelerometer FindAccelerometer:hwid];
}

+(YAccelerometer *) FirstAccelerometer
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Accelerometer":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YAccelerometer FindAccelerometer:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YAccelerometer public methods implementation)

@end
//--- (Accelerometer functions)

YAccelerometer *yFindAccelerometer(NSString* func)
{
    return [YAccelerometer FindAccelerometer:func];
}

YAccelerometer *yFirstAccelerometer(void)
{
    return [YAccelerometer FirstAccelerometer];
}

//--- (end of Accelerometer functions)
