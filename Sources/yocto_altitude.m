/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Altitude functions
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


#import "yocto_altitude.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YAltitude
// Constructor is protected, use yFindAltitude factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Altitude";
//--- (YAltitude attributes initialization)
    _qnh = Y_QNH_INVALID;
    _technology = Y_TECHNOLOGY_INVALID;
    _valueCallbackAltitude = NULL;
    _timedReportCallbackAltitude = NULL;
//--- (end of YAltitude attributes initialization)
    return self;
}
//--- (YAltitude yapiwrapper)
//--- (end of YAltitude yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YAltitude cleanup)
    ARC_release(_technology);
    _technology = nil;
    ARC_dealloc(super);
//--- (end of YAltitude cleanup)
}
//--- (YAltitude private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "qnh")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _qnh =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "technology")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_technology);
        _technology =  [self _parseString:j];
        ARC_retain(_technology);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YAltitude private methods implementation)
//--- (YAltitude public methods implementation)

/**
 * Changes the current estimated altitude. This allows one to compensate for
 * ambient pressure variations and to work in relative mode.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the current estimated altitude
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentValue:(double) newval
{
    return [self setCurrentValue:newval];
}
-(int) setCurrentValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentValue" :rest_val];
}

/**
 * Changes the barometric pressure adjusted to sea level used to compute
 * the altitude (QNH). This enables you to compensate for atmospheric pressure
 * changes due to weather conditions. Applicable to barometric altimeters only.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the barometric pressure adjusted to sea
 * level used to compute
 *         the altitude (QNH)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_qnh:(double) newval
{
    return [self setQnh:newval];
}
-(int) setQnh:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"qnh" :rest_val];
}
/**
 * Returns the barometric pressure adjusted to sea level used to compute
 * the altitude (QNH). Applicable to barometric altimeters only.
 *
 * @return a floating point number corresponding to the barometric pressure adjusted to sea level used to compute
 *         the altitude (QNH)
 *
 * On failure, throws an exception or returns YAltitude.QNH_INVALID.
 */
-(double) get_qnh
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_QNH_INVALID;
        }
    }
    res = _qnh;
    return res;
}


-(double) qnh
{
    return [self get_qnh];
}
/**
 * Returns the technology used by the sesnor to compute
 * altitude. Possibles values are  "barometric" and "gps"
 *
 * @return a string corresponding to the technology used by the sesnor to compute
 *         altitude
 *
 * On failure, throws an exception or returns YAltitude.TECHNOLOGY_INVALID.
 */
-(NSString*) get_technology
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TECHNOLOGY_INVALID;
        }
    }
    res = _technology;
    return res;
}


-(NSString*) technology
{
    return [self get_technology];
}
/**
 * Retrieves an altimeter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the altimeter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAltitude.isOnline() to test if the altimeter is
 * indeed online at a given time. In case of ambiguity when looking for
 * an altimeter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the altimeter, for instance
 *         YALTIMK2.altitude.
 *
 * @return a YAltitude object allowing you to drive the altimeter.
 */
+(YAltitude*) FindAltitude:(NSString*)func
{
    YAltitude* obj;
    obj = (YAltitude*) [YFunction _FindFromCache:@"Altitude" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YAltitude alloc] initWith:func]);
        [YFunction _AddToCache:@"Altitude" :func :obj];
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
-(int) registerValueCallback:(YAltitudeValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackAltitude = callback;
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
    if (_valueCallbackAltitude != NULL) {
        _valueCallbackAltitude(self, value);
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
-(int) registerTimedReportCallback:(YAltitudeTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackAltitude = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackAltitude != NULL) {
        _timedReportCallbackAltitude(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YAltitude*)   nextAltitude
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YAltitude FindAltitude:hwid];
}

+(YAltitude *) FirstAltitude
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Altitude":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YAltitude FindAltitude:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YAltitude public methods implementation)
@end

//--- (YAltitude functions)

YAltitude *yFindAltitude(NSString* func)
{
    return [YAltitude FindAltitude:func];
}

YAltitude *yFirstAltitude(void)
{
    return [YAltitude FirstAltitude];
}

//--- (end of YAltitude functions)

