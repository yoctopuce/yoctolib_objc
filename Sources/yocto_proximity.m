/*********************************************************************
 *
 *  $Id: yocto_proximity.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for Proximity functions
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


#import "yocto_proximity.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YProximity
// Constructor is protected, use yFindProximity factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Proximity";
//--- (YProximity attributes initialization)
    _signalValue = Y_SIGNALVALUE_INVALID;
    _detectionThreshold = Y_DETECTIONTHRESHOLD_INVALID;
    _detectionHysteresis = Y_DETECTIONHYSTERESIS_INVALID;
    _presenceMinTime = Y_PRESENCEMINTIME_INVALID;
    _removalMinTime = Y_REMOVALMINTIME_INVALID;
    _isPresent = Y_ISPRESENT_INVALID;
    _lastTimeApproached = Y_LASTTIMEAPPROACHED_INVALID;
    _lastTimeRemoved = Y_LASTTIMEREMOVED_INVALID;
    _pulseCounter = Y_PULSECOUNTER_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _proximityReportMode = Y_PROXIMITYREPORTMODE_INVALID;
    _valueCallbackProximity = NULL;
    _timedReportCallbackProximity = NULL;
//--- (end of YProximity attributes initialization)
    return self;
}
//--- (YProximity yapiwrapper)
//--- (end of YProximity yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YProximity cleanup)
    ARC_dealloc(super);
//--- (end of YProximity cleanup)
}
//--- (YProximity private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "signalValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signalValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "detectionThreshold")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _detectionThreshold =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "detectionHysteresis")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _detectionHysteresis =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "presenceMinTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _presenceMinTime =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "removalMinTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _removalMinTime =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "isPresent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _isPresent =  (Y_ISPRESENT_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastTimeApproached")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastTimeApproached =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastTimeRemoved")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastTimeRemoved =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pulseCounter")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseCounter =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pulseTimer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseTimer =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "proximityReportMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _proximityReportMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YProximity private methods implementation)
//--- (YProximity public methods implementation)
/**
 * Returns the current value of signal measured by the proximity sensor.
 *
 * @return a floating point number corresponding to the current value of signal measured by the proximity sensor
 *
 * On failure, throws an exception or returns YProximity.SIGNALVALUE_INVALID.
 */
-(double) get_signalValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALVALUE_INVALID;
        }
    }
    res = floor(_signalValue * 1000+0.5) / 1000;
    return res;
}


-(double) signalValue
{
    return [self get_signalValue];
}
/**
 * Returns the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @return an integer corresponding to the threshold used to determine the logical state of the
 * proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * On failure, throws an exception or returns YProximity.DETECTIONTHRESHOLD_INVALID.
 */
-(int) get_detectionThreshold
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DETECTIONTHRESHOLD_INVALID;
        }
    }
    res = _detectionThreshold;
    return res;
}


-(int) detectionThreshold
{
    return [self get_detectionThreshold];
}

/**
 * Changes the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the threshold used to determine the logical state of
 * the proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_detectionThreshold:(int) newval
{
    return [self setDetectionThreshold:newval];
}
-(int) setDetectionThreshold:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"detectionThreshold" :rest_val];
}
/**
 * Returns the hysteresis used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @return an integer corresponding to the hysteresis used to determine the logical state of the
 * proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * On failure, throws an exception or returns YProximity.DETECTIONHYSTERESIS_INVALID.
 */
-(int) get_detectionHysteresis
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DETECTIONHYSTERESIS_INVALID;
        }
    }
    res = _detectionHysteresis;
    return res;
}


-(int) detectionHysteresis
{
    return [self get_detectionHysteresis];
}

/**
 * Changes the hysteresis used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the hysteresis used to determine the logical state of
 * the proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_detectionHysteresis:(int) newval
{
    return [self setDetectionHysteresis:newval];
}
-(int) setDetectionHysteresis:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"detectionHysteresis" :rest_val];
}
/**
 * Returns the minimal detection duration before signalling a presence event. Any shorter detection is
 * considered as noise or bounce (false positive) and filtered out.
 *
 * @return an integer corresponding to the minimal detection duration before signalling a presence event
 *
 * On failure, throws an exception or returns YProximity.PRESENCEMINTIME_INVALID.
 */
-(int) get_presenceMinTime
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PRESENCEMINTIME_INVALID;
        }
    }
    res = _presenceMinTime;
    return res;
}


-(int) presenceMinTime
{
    return [self get_presenceMinTime];
}

/**
 * Changes the minimal detection duration before signalling a presence event. Any shorter detection is
 * considered as noise or bounce (false positive) and filtered out.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the minimal detection duration before signalling a presence event
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_presenceMinTime:(int) newval
{
    return [self setPresenceMinTime:newval];
}
-(int) setPresenceMinTime:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"presenceMinTime" :rest_val];
}
/**
 * Returns the minimal detection duration before signalling a removal event. Any shorter detection is
 * considered as noise or bounce (false positive) and filtered out.
 *
 * @return an integer corresponding to the minimal detection duration before signalling a removal event
 *
 * On failure, throws an exception or returns YProximity.REMOVALMINTIME_INVALID.
 */
-(int) get_removalMinTime
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REMOVALMINTIME_INVALID;
        }
    }
    res = _removalMinTime;
    return res;
}


-(int) removalMinTime
{
    return [self get_removalMinTime];
}

/**
 * Changes the minimal detection duration before signalling a removal event. Any shorter detection is
 * considered as noise or bounce (false positive) and filtered out.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the minimal detection duration before signalling a removal event
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_removalMinTime:(int) newval
{
    return [self setRemovalMinTime:newval];
}
-(int) setRemovalMinTime:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"removalMinTime" :rest_val];
}
/**
 * Returns true if the input (considered as binary) is active (detection value is smaller than the
 * specified threshold), and false otherwise.
 *
 * @return either YProximity.ISPRESENT_FALSE or YProximity.ISPRESENT_TRUE, according to true if the
 * input (considered as binary) is active (detection value is smaller than the specified threshold),
 * and false otherwise
 *
 * On failure, throws an exception or returns YProximity.ISPRESENT_INVALID.
 */
-(Y_ISPRESENT_enum) get_isPresent
{
    Y_ISPRESENT_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ISPRESENT_INVALID;
        }
    }
    res = _isPresent;
    return res;
}


-(Y_ISPRESENT_enum) isPresent
{
    return [self get_isPresent];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last observed
 * detection (the input contact transitioned from absent to present).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last observed
 *         detection (the input contact transitioned from absent to present)
 *
 * On failure, throws an exception or returns YProximity.LASTTIMEAPPROACHED_INVALID.
 */
-(s64) get_lastTimeApproached
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMEAPPROACHED_INVALID;
        }
    }
    res = _lastTimeApproached;
    return res;
}


-(s64) lastTimeApproached
{
    return [self get_lastTimeApproached];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last observed
 * detection (the input contact transitioned from present to absent).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last observed
 *         detection (the input contact transitioned from present to absent)
 *
 * On failure, throws an exception or returns YProximity.LASTTIMEREMOVED_INVALID.
 */
-(s64) get_lastTimeRemoved
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMEREMOVED_INVALID;
        }
    }
    res = _lastTimeRemoved;
    return res;
}


-(s64) lastTimeRemoved
{
    return [self get_lastTimeRemoved];
}
/**
 * Returns the pulse counter value. The value is a 32 bit integer. In case
 * of overflow (>=2^32), the counter will wrap. To reset the counter, just
 * call the resetCounter() method.
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns YProximity.PULSECOUNTER_INVALID.
 */
-(s64) get_pulseCounter
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSECOUNTER_INVALID;
        }
    }
    res = _pulseCounter;
    return res;
}


-(s64) pulseCounter
{
    return [self get_pulseCounter];
}

-(int) set_pulseCounter:(s64) newval
{
    return [self setPulseCounter:newval];
}
-(int) setPulseCounter:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"pulseCounter" :rest_val];
}
/**
 * Returns the timer of the pulse counter (ms).
 *
 * @return an integer corresponding to the timer of the pulse counter (ms)
 *
 * On failure, throws an exception or returns YProximity.PULSETIMER_INVALID.
 */
-(s64) get_pulseTimer
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSETIMER_INVALID;
        }
    }
    res = _pulseTimer;
    return res;
}


-(s64) pulseTimer
{
    return [self get_pulseTimer];
}
/**
 * Returns the parameter (sensor value, presence or pulse count) returned by the get_currentValue
 * function and callbacks.
 *
 * @return a value among YProximity.PROXIMITYREPORTMODE_NUMERIC,
 * YProximity.PROXIMITYREPORTMODE_PRESENCE and YProximity.PROXIMITYREPORTMODE_PULSECOUNT corresponding
 * to the parameter (sensor value, presence or pulse count) returned by the get_currentValue function and callbacks
 *
 * On failure, throws an exception or returns YProximity.PROXIMITYREPORTMODE_INVALID.
 */
-(Y_PROXIMITYREPORTMODE_enum) get_proximityReportMode
{
    Y_PROXIMITYREPORTMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PROXIMITYREPORTMODE_INVALID;
        }
    }
    res = _proximityReportMode;
    return res;
}


-(Y_PROXIMITYREPORTMODE_enum) proximityReportMode
{
    return [self get_proximityReportMode];
}

/**
 * Changes the  parameter  type (sensor value, presence or pulse count) returned by the
 * get_currentValue function and callbacks.
 * The edge count value is limited to the 6 lowest digits. For values greater than one million, use
 * get_pulseCounter().
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YProximity.PROXIMITYREPORTMODE_NUMERIC,
 * YProximity.PROXIMITYREPORTMODE_PRESENCE and YProximity.PROXIMITYREPORTMODE_PULSECOUNT corresponding
 * to the  parameter  type (sensor value, presence or pulse count) returned by the get_currentValue
 * function and callbacks
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_proximityReportMode:(Y_PROXIMITYREPORTMODE_enum) newval
{
    return [self setProximityReportMode:newval];
}
-(int) setProximityReportMode:(Y_PROXIMITYREPORTMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"proximityReportMode" :rest_val];
}
/**
 * Retrieves a proximity sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the proximity sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YProximity.isOnline() to test if the proximity sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a proximity sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the proximity sensor, for instance
 *         YPROXIM1.proximity1.
 *
 * @return a YProximity object allowing you to drive the proximity sensor.
 */
+(YProximity*) FindProximity:(NSString*)func
{
    YProximity* obj;
    obj = (YProximity*) [YFunction _FindFromCache:@"Proximity" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YProximity alloc] initWith:func]);
        [YFunction _AddToCache:@"Proximity" : func :obj];
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
-(int) registerValueCallback:(YProximityValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackProximity = callback;
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
    if (_valueCallbackProximity != NULL) {
        _valueCallbackProximity(self, value);
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
-(int) registerTimedReportCallback:(YProximityTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackProximity = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackProximity != NULL) {
        _timedReportCallbackProximity(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Resets the pulse counter value as well as its timer.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetCounter
{
    return [self set_pulseCounter:0];
}


-(YProximity*)   nextProximity
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YProximity FindProximity:hwid];
}

+(YProximity *) FirstProximity
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Proximity":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YProximity FindProximity:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YProximity public methods implementation)
@end

//--- (YProximity functions)

YProximity *yFindProximity(NSString* func)
{
    return [YProximity FindProximity:func];
}

YProximity *yFirstProximity(void)
{
    return [YProximity FirstProximity];
}

//--- (end of YProximity functions)

