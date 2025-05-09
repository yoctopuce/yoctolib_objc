/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for WakeUpMonitor functions
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


#import "yocto_wakeupmonitor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YWakeUpMonitor
// Constructor is protected, use yFindWakeUpMonitor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"WakeUpMonitor";
//--- (YWakeUpMonitor attributes initialization)
    _powerDuration = Y_POWERDURATION_INVALID;
    _sleepCountdown = Y_SLEEPCOUNTDOWN_INVALID;
    _nextWakeUp = Y_NEXTWAKEUP_INVALID;
    _wakeUpReason = Y_WAKEUPREASON_INVALID;
    _wakeUpState = Y_WAKEUPSTATE_INVALID;
    _rtcTime = Y_RTCTIME_INVALID;
    _endOfTime = 2145960000;
    _valueCallbackWakeUpMonitor = NULL;
//--- (end of YWakeUpMonitor attributes initialization)
    return self;
}
//--- (YWakeUpMonitor yapiwrapper)
//--- (end of YWakeUpMonitor yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YWakeUpMonitor cleanup)
    ARC_dealloc(super);
//--- (end of YWakeUpMonitor cleanup)
}
//--- (YWakeUpMonitor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "powerDuration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerDuration =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "sleepCountdown")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _sleepCountdown =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "nextWakeUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nextWakeUp =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "wakeUpReason")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _wakeUpReason =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "wakeUpState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _wakeUpState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rtcTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rtcTime =  atol(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YWakeUpMonitor private methods implementation)
//--- (YWakeUpMonitor public methods implementation)
/**
 * Returns the maximal wake up time (in seconds) before automatically going to sleep.
 *
 * @return an integer corresponding to the maximal wake up time (in seconds) before automatically going to sleep
 *
 * On failure, throws an exception or returns YWakeUpMonitor.POWERDURATION_INVALID.
 */
-(int) get_powerDuration
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWERDURATION_INVALID;
        }
    }
    res = _powerDuration;
    return res;
}


-(int) powerDuration
{
    return [self get_powerDuration];
}

/**
 * Changes the maximal wake up time (seconds) before automatically going to sleep.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the maximal wake up time (seconds) before automatically
 * going to sleep
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerDuration:(int) newval
{
    return [self setPowerDuration:newval];
}
-(int) setPowerDuration:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"powerDuration" :rest_val];
}
/**
 * Returns the delay before the  next sleep period.
 *
 * @return an integer corresponding to the delay before the  next sleep period
 *
 * On failure, throws an exception or returns YWakeUpMonitor.SLEEPCOUNTDOWN_INVALID.
 */
-(int) get_sleepCountdown
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SLEEPCOUNTDOWN_INVALID;
        }
    }
    res = _sleepCountdown;
    return res;
}


-(int) sleepCountdown
{
    return [self get_sleepCountdown];
}

/**
 * Changes the delay before the next sleep period.
 *
 * @param newval : an integer corresponding to the delay before the next sleep period
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_sleepCountdown:(int) newval
{
    return [self setSleepCountdown:newval];
}
-(int) setSleepCountdown:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"sleepCountdown" :rest_val];
}
/**
 * Returns the next scheduled wake up date/time (UNIX format).
 *
 * @return an integer corresponding to the next scheduled wake up date/time (UNIX format)
 *
 * On failure, throws an exception or returns YWakeUpMonitor.NEXTWAKEUP_INVALID.
 */
-(s64) get_nextWakeUp
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEXTWAKEUP_INVALID;
        }
    }
    res = _nextWakeUp;
    return res;
}


-(s64) nextWakeUp
{
    return [self get_nextWakeUp];
}

/**
 * Changes the days of the week when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the week when a wake up must take place
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_nextWakeUp:(s64) newval
{
    return [self setNextWakeUp:newval];
}
-(int) setNextWakeUp:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"nextWakeUp" :rest_val];
}
/**
 * Returns the latest wake up reason.
 *
 * @return a value among YWakeUpMonitor.WAKEUPREASON_USBPOWER, YWakeUpMonitor.WAKEUPREASON_EXTPOWER,
 * YWakeUpMonitor.WAKEUPREASON_ENDOFSLEEP, YWakeUpMonitor.WAKEUPREASON_EXTSIG1,
 * YWakeUpMonitor.WAKEUPREASON_SCHEDULE1, YWakeUpMonitor.WAKEUPREASON_SCHEDULE2 and
 * YWakeUpMonitor.WAKEUPREASON_SCHEDULE3 corresponding to the latest wake up reason
 *
 * On failure, throws an exception or returns YWakeUpMonitor.WAKEUPREASON_INVALID.
 */
-(Y_WAKEUPREASON_enum) get_wakeUpReason
{
    Y_WAKEUPREASON_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WAKEUPREASON_INVALID;
        }
    }
    res = _wakeUpReason;
    return res;
}


-(Y_WAKEUPREASON_enum) wakeUpReason
{
    return [self get_wakeUpReason];
}
/**
 * Returns  the current state of the monitor.
 *
 * @return either YWakeUpMonitor.WAKEUPSTATE_SLEEPING or YWakeUpMonitor.WAKEUPSTATE_AWAKE, according
 * to  the current state of the monitor
 *
 * On failure, throws an exception or returns YWakeUpMonitor.WAKEUPSTATE_INVALID.
 */
-(Y_WAKEUPSTATE_enum) get_wakeUpState
{
    Y_WAKEUPSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WAKEUPSTATE_INVALID;
        }
    }
    res = _wakeUpState;
    return res;
}


-(Y_WAKEUPSTATE_enum) wakeUpState
{
    return [self get_wakeUpState];
}

-(int) set_wakeUpState:(Y_WAKEUPSTATE_enum) newval
{
    return [self setWakeUpState:newval];
}
-(int) setWakeUpState:(Y_WAKEUPSTATE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"wakeUpState" :rest_val];
}
-(s64) get_rtcTime
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RTCTIME_INVALID;
        }
    }
    res = _rtcTime;
    return res;
}


-(s64) rtcTime
{
    return [self get_rtcTime];
}
/**
 * Retrieves a wake-up monitor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the wake-up monitor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpMonitor.isOnline() to test if the wake-up monitor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wake-up monitor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the wake-up monitor, for instance
 *         YHUBGSM5.wakeUpMonitor.
 *
 * @return a YWakeUpMonitor object allowing you to drive the wake-up monitor.
 */
+(YWakeUpMonitor*) FindWakeUpMonitor:(NSString*)func
{
    YWakeUpMonitor* obj;
    obj = (YWakeUpMonitor*) [YFunction _FindFromCache:@"WakeUpMonitor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YWakeUpMonitor alloc] initWith:func]);
        [YFunction _AddToCache:@"WakeUpMonitor" :func :obj];
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
-(int) registerValueCallback:(YWakeUpMonitorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackWakeUpMonitor = callback;
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
    if (_valueCallbackWakeUpMonitor != NULL) {
        _valueCallbackWakeUpMonitor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Forces a wake up.
 */
-(int) wakeUp
{
    return [self set_wakeUpState:Y_WAKEUPSTATE_AWAKE];
}

/**
 * Goes to sleep until the next wake up condition is met,  the
 * RTC time must have been set before calling this function.
 *
 * @param secBeforeSleep : number of seconds before going into sleep mode,
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleep:(int)secBeforeSleep
{
    int currTime;
    currTime = (int)([self get_rtcTime]);
    if (!(currTime != 0)) {[self _throw:YAPI_RTC_NOT_READY:@"RTC time not set"]; return YAPI_RTC_NOT_READY;}
    [self set_nextWakeUp:_endOfTime];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS;
}

/**
 * Goes to sleep for a specific duration or until the next wake up condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 *
 * @param secUntilWakeUp : number of seconds before next wake up
 * @param secBeforeSleep : number of seconds before going into sleep mode
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleepFor:(int)secUntilWakeUp :(int)secBeforeSleep
{
    int currTime;
    currTime = (int)([self get_rtcTime]);
    if (!(currTime != 0)) {[self _throw:YAPI_RTC_NOT_READY:@"RTC time not set"]; return YAPI_RTC_NOT_READY;}
    [self set_nextWakeUp:currTime+secUntilWakeUp];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS;
}

/**
 * Go to sleep until a specific date is reached or until the next wake up condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 *
 * @param wakeUpTime : wake-up datetime (UNIX format)
 * @param secBeforeSleep : number of seconds before going into sleep mode
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleepUntil:(int)wakeUpTime :(int)secBeforeSleep
{
    int currTime;
    currTime = (int)([self get_rtcTime]);
    if (!(currTime != 0)) {[self _throw:YAPI_RTC_NOT_READY:@"RTC time not set"]; return YAPI_RTC_NOT_READY;}
    [self set_nextWakeUp:wakeUpTime];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS;
}

/**
 * Resets the sleep countdown.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) resetSleepCountDown
{
    [self set_sleepCountdown:0];
    [self set_nextWakeUp:0];
    return YAPI_SUCCESS;
}


-(YWakeUpMonitor*)   nextWakeUpMonitor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YWakeUpMonitor FindWakeUpMonitor:hwid];
}

+(YWakeUpMonitor *) FirstWakeUpMonitor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"WakeUpMonitor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YWakeUpMonitor FindWakeUpMonitor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YWakeUpMonitor public methods implementation)
@end

//--- (YWakeUpMonitor functions)

YWakeUpMonitor *yFindWakeUpMonitor(NSString* func)
{
    return [YWakeUpMonitor FindWakeUpMonitor:func];
}

YWakeUpMonitor *yFirstWakeUpMonitor(void)
{
    return [YWakeUpMonitor FirstWakeUpMonitor];
}

//--- (end of YWakeUpMonitor functions)

