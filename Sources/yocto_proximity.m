/*********************************************************************
 *
 * $Id: pic24config.php 25964 2016-11-21 15:30:59Z mvuilleu $
 *
 * Implements the high-level API for Proximity functions
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
    _detectionThreshold = Y_DETECTIONTHRESHOLD_INVALID;
    _isPresent = Y_ISPRESENT_INVALID;
    _lastTimeApproached = Y_LASTTIMEAPPROACHED_INVALID;
    _lastTimeRemoved = Y_LASTTIMEREMOVED_INVALID;
    _pulseCounter = Y_PULSECOUNTER_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _valueCallbackProximity = NULL;
    _timedReportCallbackProximity = NULL;
//--- (end of YProximity attributes initialization)
    return self;
}
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
    if(!strcmp(j->token, "detectionThreshold")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _detectionThreshold =  atoi(j->token);
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
    return [super _parseAttr:j];
}
//--- (end of YProximity private methods implementation)
//--- (YProximity public methods implementation)
/**
 * Returns the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @return an integer corresponding to the threshold used to determine the logical state of the
 * proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * On failure, throws an exception or returns Y_DETECTIONTHRESHOLD_INVALID.
 */
-(int) get_detectionThreshold
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DETECTIONTHRESHOLD_INVALID;
        }
    }
    return _detectionThreshold;
}


-(int) detectionThreshold
{
    return [self get_detectionThreshold];
}

/**
 * Changes the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @param newval : an integer corresponding to the threshold used to determine the logical state of
 * the proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns true if the input (considered as binary) is active (detection value is smaller than the
 * specified threshold), and false otherwise.
 *
 * @return either Y_ISPRESENT_FALSE or Y_ISPRESENT_TRUE, according to true if the input (considered as
 * binary) is active (detection value is smaller than the specified threshold), and false otherwise
 *
 * On failure, throws an exception or returns Y_ISPRESENT_INVALID.
 */
-(Y_ISPRESENT_enum) get_isPresent
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ISPRESENT_INVALID;
        }
    }
    return _isPresent;
}


-(Y_ISPRESENT_enum) isPresent
{
    return [self get_isPresent];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was pressed (the input contact transitioned from absent to present).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was pressed (the input contact transitioned from absent to present)
 *
 * On failure, throws an exception or returns Y_LASTTIMEAPPROACHED_INVALID.
 */
-(s64) get_lastTimeApproached
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMEAPPROACHED_INVALID;
        }
    }
    return _lastTimeApproached;
}


-(s64) lastTimeApproached
{
    return [self get_lastTimeApproached];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was released (the input contact transitioned from present to absent).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was released (the input contact transitioned from present to absent)
 *
 * On failure, throws an exception or returns Y_LASTTIMEREMOVED_INVALID.
 */
-(s64) get_lastTimeRemoved
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMEREMOVED_INVALID;
        }
    }
    return _lastTimeRemoved;
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
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(s64) get_pulseCounter
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSECOUNTER_INVALID;
        }
    }
    return _pulseCounter;
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
 * Returns the timer of the pulses counter (ms).
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(s64) get_pulseTimer
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSETIMER_INVALID;
        }
    }
    return _pulseTimer;
}


-(s64) pulseTimer
{
    return [self get_pulseTimer];
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
 * @param func : a string that uniquely characterizes the proximity sensor
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
-(int) registerValueCallback:(YProximityValueCallback)callback
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
-(int) registerTimedReportCallback:(YProximityTimedReportCallback)callback
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
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
//--- (Proximity functions)

YProximity *yFindProximity(NSString* func)
{
    return [YProximity FindProximity:func];
}

YProximity *yFirstProximity(void)
{
    return [YProximity FirstProximity];
}

//--- (end of Proximity functions)
