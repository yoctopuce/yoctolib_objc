/*********************************************************************
 *
 * $Id: yocto_wakeupmonitor.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindWakeUpMonitor(), the high-level API for WakeUpMonitor functions
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


#import "yocto_wakeupmonitor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YWakeUpMonitor

// Constructor is protected, use yFindWakeUpMonitor factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YWakeUpMonitor attributes)
   if(!(self = [super initProtected:@"WakeUpMonitor":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _powerDuration = Y_POWERDURATION_INVALID;
    _sleepCountdown = Y_SLEEPCOUNTDOWN_INVALID;
    _nextWakeUp = Y_NEXTWAKEUP_INVALID;
    _wakeUpReason = Y_WAKEUPREASON_INVALID;
    _wakeUpState = Y_WAKEUPSTATE_INVALID;
    _rtcTime = Y_RTCTIME_INVALID;
    _endOfTime = 2145960000;
//--- (end of YWakeUpMonitor attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YWakeUpMonitor cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of YWakeUpMonitor cleanup)
    ARC_dealloc(super);
}
//--- (YWakeUpMonitor implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "powerDuration")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _powerDuration =  atoi(j->token);
        } else if(!strcmp(j->token, "sleepCountdown")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _sleepCountdown =  atoi(j->token);
        } else if(!strcmp(j->token, "nextWakeUp")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _nextWakeUp =  atoi(j->token);
        } else if(!strcmp(j->token, "wakeUpReason")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _wakeUpReason =  atoi(j->token);
        } else if(!strcmp(j->token, "wakeUpState")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _wakeUpState =  atoi(j->token);
        } else if(!strcmp(j->token, "rtcTime")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _rtcTime =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the monitor.
 * 
 * @return a string corresponding to the logical name of the monitor
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * Changes the logical name of the monitor. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the monitor
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the monitor (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the monitor (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the maximal wake up time (seconds) before going to sleep automatically.
 * 
 * @return an integer corresponding to the maximal wake up time (seconds) before going to sleep automatically
 * 
 * On failure, throws an exception or returns Y_POWERDURATION_INVALID.
 */
-(int) get_powerDuration
{
    return [self powerDuration];
}
-(int) powerDuration
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_POWERDURATION_INVALID;
    }
    return _powerDuration;
}

/**
 * Changes the maximal wake up time (seconds) before going to sleep automatically.
 * 
 * @param newval : an integer corresponding to the maximal wake up time (seconds) before going to
 * sleep automatically
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns the delay before next sleep.
 * 
 * @return an integer corresponding to the delay before next sleep
 * 
 * On failure, throws an exception or returns Y_SLEEPCOUNTDOWN_INVALID.
 */
-(int) get_sleepCountdown
{
    return [self sleepCountdown];
}
-(int) sleepCountdown
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SLEEPCOUNTDOWN_INVALID;
    }
    return _sleepCountdown;
}

/**
 * Changes the delay before next sleep.
 * 
 * @param newval : an integer corresponding to the delay before next sleep
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns the next scheduled wake-up date/time (UNIX format)
 * 
 * @return an integer corresponding to the next scheduled wake-up date/time (UNIX format)
 * 
 * On failure, throws an exception or returns Y_NEXTWAKEUP_INVALID.
 */
-(unsigned) get_nextWakeUp
{
    return [self nextWakeUp];
}
-(unsigned) nextWakeUp
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_NEXTWAKEUP_INVALID;
    }
    return _nextWakeUp;
}

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_nextWakeUp:(unsigned) newval
{
    return [self setNextWakeUp:newval];
}
-(int) setNextWakeUp:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"nextWakeUp" :rest_val];
}

/**
 * Return the last wake up reason.
 * 
 * @return a value among Y_WAKEUPREASON_USBPOWER, Y_WAKEUPREASON_EXTPOWER, Y_WAKEUPREASON_ENDOFSLEEP,
 * Y_WAKEUPREASON_EXTSIG1, Y_WAKEUPREASON_EXTSIG2, Y_WAKEUPREASON_EXTSIG3, Y_WAKEUPREASON_EXTSIG4,
 * Y_WAKEUPREASON_SCHEDULE1, Y_WAKEUPREASON_SCHEDULE2, Y_WAKEUPREASON_SCHEDULE3,
 * Y_WAKEUPREASON_SCHEDULE4, Y_WAKEUPREASON_SCHEDULE5 and Y_WAKEUPREASON_SCHEDULE6
 * 
 * On failure, throws an exception or returns Y_WAKEUPREASON_INVALID.
 */
-(Y_WAKEUPREASON_enum) get_wakeUpReason
{
    return [self wakeUpReason];
}
-(Y_WAKEUPREASON_enum) wakeUpReason
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_WAKEUPREASON_INVALID;
    }
    return _wakeUpReason;
}

/**
 * Returns  the current state of the monitor
 * 
 * @return either Y_WAKEUPSTATE_SLEEPING or Y_WAKEUPSTATE_AWAKE, according to  the current state of the monitor
 * 
 * On failure, throws an exception or returns Y_WAKEUPSTATE_INVALID.
 */
-(Y_WAKEUPSTATE_enum) get_wakeUpState
{
    return [self wakeUpState];
}
-(Y_WAKEUPSTATE_enum) wakeUpState
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_WAKEUPSTATE_INVALID;
    }
    return _wakeUpState;
}

-(int) set_wakeUpState:(Y_WAKEUPSTATE_enum) newval
{
    return [self setWakeUpState:newval];
}
-(int) setWakeUpState:(Y_WAKEUPSTATE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"wakeUpState" :rest_val];
}

-(unsigned) get_rtcTime
{
    return [self rtcTime];
}
-(unsigned) rtcTime
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RTCTIME_INVALID;
    }
    return _rtcTime;
}
/**
 * Forces a wakeup.
 */
-(int) wakeUp
{
    return [self set_wakeUpState:Y_WAKEUPSTATE_AWAKE];
    
}

/**
 * Go to sleep until the next wakeup condition is met,  the
 * RTC time must have been set before calling this function.
 * 
 * @param secBeforeSleep : number of seconds before going into sleep mode,
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleep :(int)secBeforeSleep
{
    int currTime;
    currTime = [self get_rtcTime];
    if (!(currTime != 0)) {[self _throw: YAPI_RTC_NOT_READY: @"RTC time not set"]; return  YAPI_RTC_NOT_READY;};
    [self set_nextWakeUp:_endOfTime];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS; 
    
}

/**
 * Go to sleep for a specific time or until the next wakeup condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 * 
 * @param secUntilWakeUp : sleep duration, in secondes
 * @param secBeforeSleep : number of seconds before going into sleep mode
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleepFor :(int)secUntilWakeUp :(int)secBeforeSleep
{
    int currTime;
    currTime = [self get_rtcTime];
    if (!(currTime != 0)) {[self _throw: YAPI_RTC_NOT_READY: @"RTC time not set"]; return  YAPI_RTC_NOT_READY;};
    [self set_nextWakeUp:currTime+secUntilWakeUp];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS; 
    
}

/**
 * Go to sleep until a specific date is reached or until the next wakeup condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 * 
 * @param wakeUpTime : wake-up datetime (UNIX format)
 * @param secBeforeSleep : number of seconds before going into sleep mode
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sleepUntil :(int)wakeUpTime :(int)secBeforeSleep
{
    int currTime;
    currTime = [self get_rtcTime];
    if (!(currTime != 0)) {[self _throw: YAPI_RTC_NOT_READY: @"RTC time not set"]; return  YAPI_RTC_NOT_READY;};
    [self set_nextWakeUp:wakeUpTime];
    [self set_sleepCountdown:secBeforeSleep];
    return YAPI_SUCCESS; 
    
}

/**
 * Reset the sleep countdown.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
    return yFindWakeUpMonitor(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YWakeUpMonitor*) FindWakeUpMonitor:(NSString*) func
{
    YWakeUpMonitor * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YWakeUpMonitor"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YWakeUpMonitor"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YWakeUpMonitor"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YWakeUpMonitor"] objectForKey:func];
    } else {
        retVal = [[YWakeUpMonitor alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YWakeUpMonitor"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of YWakeUpMonitor implementation)

@end
//--- (WakeUpMonitor functions)

YWakeUpMonitor *yFindWakeUpMonitor(NSString* func)
{
    return [YWakeUpMonitor FindWakeUpMonitor:func];
}

YWakeUpMonitor *yFirstWakeUpMonitor(void)
{
    return [YWakeUpMonitor FirstWakeUpMonitor];
}

//--- (end of WakeUpMonitor functions)
