/*********************************************************************
 *
 *  $Id: yocto_airquality.m Fri, 23 Oct 2026 10:30:35 +0000 generated $
 *
 *  Implements the high-level API for AirQuality functions
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


#import "yocto_airquality.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YAirQuality
// Constructor is protected, use yFindAirQuality factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"AirQuality";
//--- (YAirQuality attributes initialization)
    _ubaIndex = Y_UBAINDEX_INVALID;
    _relativeIndex = Y_RELATIVEINDEX_INVALID;
    _aqiMode = Y_AQIMODE_INVALID;
    _valueCallbackAirQuality = NULL;
    _timedReportCallbackAirQuality = NULL;
//--- (end of YAirQuality attributes initialization)
    return self;
}
//--- (YAirQuality yapiwrapper)
//--- (end of YAirQuality yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YAirQuality cleanup)
    ARC_dealloc(super);
//--- (end of YAirQuality cleanup)
}
//--- (YAirQuality private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "ubaIndex")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ubaIndex =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "relativeIndex")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _relativeIndex =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "aqiMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _aqiMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YAirQuality private methods implementation)
//--- (YAirQuality public methods implementation)
/**
 * Returns the current air quality index, according to UBA (from 1 to 5).
 *
 * @return a floating point number corresponding to the current air quality index, according to UBA (from 1 to 5)
 *
 * On failure, throws an exception or returns YAirQuality.UBAINDEX_INVALID.
 */
-(double) get_ubaIndex
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_UBAINDEX_INVALID;
        }
    }
    res = _ubaIndex;
    return res;
}


-(double) ubaIndex
{
    return [self get_ubaIndex];
}
/**
 * Returns the relative air quality index, according to ScioSense (from 0 to 500).
 * A value below 100 indicates better-than-average air quality compared to the past 24 hours,
 * while a value above 100 indicates poorer-than-average air quality compared to the past 24 hours.
 *
 * @return a floating point number corresponding to the relative air quality index, according to
 * ScioSense (from 0 to 500)
 *
 * On failure, throws an exception or returns YAirQuality.RELATIVEINDEX_INVALID.
 */
-(double) get_relativeIndex
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RELATIVEINDEX_INVALID;
        }
    }
    res = _relativeIndex;
    return res;
}


-(double) relativeIndex
{
    return [self get_relativeIndex];
}
/**
 * Returns the type of index reported by the get_currentValue function and callbacks (UBA index or relative index).
 *
 * @return either YAirQuality.AQIMODE_RELATIVE or YAirQuality.AQIMODE_UBA, according to the type of
 * index reported by the get_currentValue function and callbacks (UBA index or relative index)
 *
 * On failure, throws an exception or returns YAirQuality.AQIMODE_INVALID.
 */
-(Y_AQIMODE_enum) get_aqiMode
{
    Y_AQIMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_AQIMODE_INVALID;
        }
    }
    res = _aqiMode;
    return res;
}


-(Y_AQIMODE_enum) aqiMode
{
    return [self get_aqiMode];
}

/**
 * Changes the the type of index reported by the get_currentValue function and callbacks (UBA index or
 * relative index).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YAirQuality.AQIMODE_RELATIVE or YAirQuality.AQIMODE_UBA, according to the
 * the type of index reported by the get_currentValue function and callbacks (UBA index or relative index)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_aqiMode:(Y_AQIMODE_enum) newval
{
    return [self setAqiMode:newval];
}
-(int) setAqiMode:(Y_AQIMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"aqiMode" :rest_val];
}
/**
 * Retrieves an air quality sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the air quality sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAirQuality.isOnline() to test if the air quality sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an air quality sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the air quality sensor, for instance
 *         MyDevice.airQuality.
 *
 * @return a YAirQuality object allowing you to drive the air quality sensor.
 */
+(YAirQuality*) FindAirQuality:(NSString*)func
{
    YAirQuality* obj;
    obj = (YAirQuality*) [YFunction _FindFromCache:@"AirQuality" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YAirQuality alloc] initWith:func]);
        [YFunction _AddToCache:@"AirQuality" :func :obj];
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
-(int) registerValueCallback:(YAirQualityValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackAirQuality = callback;
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
    if (_valueCallbackAirQuality != NULL) {
        _valueCallbackAirQuality(self, value);
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
-(int) registerTimedReportCallback:(YAirQualityTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackAirQuality = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackAirQuality != NULL) {
        _timedReportCallbackAirQuality(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YAirQuality*)   nextAirQuality
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YAirQuality FindAirQuality:hwid];
}

+(YAirQuality *) FirstAirQuality
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"AirQuality":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YAirQuality FindAirQuality:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YAirQuality public methods implementation)
@end

//--- (YAirQuality functions)

YAirQuality *yFindAirQuality(NSString* func)
{
    return [YAirQuality FindAirQuality:func];
}

YAirQuality *yFirstAirQuality(void)
{
    return [YAirQuality FirstAirQuality];
}

//--- (end of YAirQuality functions)

