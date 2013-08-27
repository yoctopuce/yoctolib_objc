/*********************************************************************
 *
 * $Id: yocto_watchdog.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindWatchdog(), the high-level API for Watchdog functions
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


#import "yocto_watchdog.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YWatchdog

// Constructor is protected, use yFindWatchdog factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YWatchdog attributes)
   if(!(self = [super initProtected:@"Watchdog":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _state = Y_STATE_INVALID;
    _output = Y_OUTPUT_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _countdown = Y_COUNTDOWN_INVALID;
    _autoStart = Y_AUTOSTART_INVALID;
    _running = Y_RUNNING_INVALID;
    _triggerDelay = Y_TRIGGERDELAY_INVALID;
    _triggerDuration = Y_TRIGGERDURATION_INVALID;
//--- (end of YWatchdog attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YWatchdog cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of YWatchdog cleanup)
    ARC_dealloc(super);
}
//--- (YWatchdog implementation)

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
        } else if(!strcmp(j->token, "state")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _state =  (Y_STATE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "output")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _output =  (Y_OUTPUT_enum)atoi(j->token);
        } else if(!strcmp(j->token, "pulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _pulseTimer =  atoi(j->token);
        } else if(!strcmp(j->token, "delayedPulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else if(!strcmp(j->token, "countdown")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _countdown =  atoi(j->token);
        } else if(!strcmp(j->token, "autoStart")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _autoStart =  (Y_AUTOSTART_enum)atoi(j->token);
        } else if(!strcmp(j->token, "running")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _running =  (Y_RUNNING_enum)atoi(j->token);
        } else if(!strcmp(j->token, "triggerDelay")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _triggerDelay =  atoi(j->token);
        } else if(!strcmp(j->token, "triggerDuration")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _triggerDuration =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the watchdog.
 * 
 * @return a string corresponding to the logical name of the watchdog
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
 * Changes the logical name of the watchdog. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the watchdog
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
 * Returns the current value of the watchdog (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the watchdog (no more than 6 characters)
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
 * Returns the state of the watchdog (A for the idle position, B for the active position).
 * 
 * @return either Y_STATE_A or Y_STATE_B, according to the state of the watchdog (A for the idle
 * position, B for the active position)
 * 
 * On failure, throws an exception or returns Y_STATE_INVALID.
 */
-(Y_STATE_enum) get_state
{
    return [self state];
}
-(Y_STATE_enum) state
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_STATE_INVALID;
    }
    return _state;
}

/**
 * Changes the state of the watchdog (A for the idle position, B for the active position).
 * 
 * @param newval : either Y_STATE_A or Y_STATE_B, according to the state of the watchdog (A for the
 * idle position, B for the active position)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_state:(Y_STATE_enum) newval
{
    return [self setState:newval];
}
-(int) setState:(Y_STATE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"state" :rest_val];
}

/**
 * Returns the output state of the watchdog, when used as a simple switch (single throw).
 * 
 * @return either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the watchdog, when
 * used as a simple switch (single throw)
 * 
 * On failure, throws an exception or returns Y_OUTPUT_INVALID.
 */
-(Y_OUTPUT_enum) get_output
{
    return [self output];
}
-(Y_OUTPUT_enum) output
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OUTPUT_INVALID;
    }
    return _output;
}

/**
 * Changes the output state of the watchdog, when used as a simple switch (single throw).
 * 
 * @param newval : either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the watchdog,
 * when used as a simple switch (single throw)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_output:(Y_OUTPUT_enum) newval
{
    return [self setOutput:newval];
}
-(int) setOutput:(Y_OUTPUT_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"output" :rest_val];
}

/**
 * Returns the number of milliseconds remaining before the watchdog is returned to idle position
 * (state A), during a measured pulse generation. When there is no ongoing pulse, returns zero.
 * 
 * @return an integer corresponding to the number of milliseconds remaining before the watchdog is
 * returned to idle position
 *         (state A), during a measured pulse generation
 * 
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(unsigned) get_pulseTimer
{
    return [self pulseTimer];
}
-(unsigned) pulseTimer
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PULSETIMER_INVALID;
    }
    return _pulseTimer;
}

-(int) set_pulseTimer:(unsigned) newval
{
    return [self setPulseTimer:newval];
}
-(int) setPulseTimer:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

/**
 * Sets the relay to output B (active) for a specified duration, then brings it
 * automatically back to output A (idle state).
 * 
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulse :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", ms_duration];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

-(YRETCODE) get_delayedPulseTimer :(s32*)target :(s32*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _delayedPulseTimer.target;
    *ms = _delayedPulseTimer.ms;
    *moving = _delayedPulseTimer.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_delayedPulseTimer :(s32)target :(s32)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
    return [self _setAttr:@"delayedPulseTimer" :rest_val];
}

/**
 * Schedules a pulse.
 * 
 * @param ms_delay : waiting time before the pulse, in millisecondes
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) delayedPulse :(int)ms_delay :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",ms_delay,ms_duration];
    return [self _setAttr:@"delayedPulseTimer" :rest_val];
}

/**
 * Returns the number of milliseconds remaining before a pulse (delayedPulse() call)
 * When there is no scheduled pulse, returns zero.
 * 
 * @return an integer corresponding to the number of milliseconds remaining before a pulse (delayedPulse() call)
 *         When there is no scheduled pulse, returns zero
 * 
 * On failure, throws an exception or returns Y_COUNTDOWN_INVALID.
 */
-(unsigned) get_countdown
{
    return [self countdown];
}
-(unsigned) countdown
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_COUNTDOWN_INVALID;
    }
    return _countdown;
}

/**
 * Returns the watchdog runing state at module power up.
 * 
 * @return either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runing state at module power up
 * 
 * On failure, throws an exception or returns Y_AUTOSTART_INVALID.
 */
-(Y_AUTOSTART_enum) get_autoStart
{
    return [self autoStart];
}
-(Y_AUTOSTART_enum) autoStart
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_AUTOSTART_INVALID;
    }
    return _autoStart;
}

/**
 * Changes the watchdog runningsttae at module power up. Remember to call the
 * saveToFlash() method and then to reboot the module to apply this setting.
 * 
 * @param newval : either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runningsttae at
 * module power up
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_autoStart:(Y_AUTOSTART_enum) newval
{
    return [self setAutoStart:newval];
}
-(int) setAutoStart:(Y_AUTOSTART_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"autoStart" :rest_val];
}

/**
 * Returns the watchdog running state.
 * 
 * @return either Y_RUNNING_OFF or Y_RUNNING_ON, according to the watchdog running state
 * 
 * On failure, throws an exception or returns Y_RUNNING_INVALID.
 */
-(Y_RUNNING_enum) get_running
{
    return [self running];
}
-(Y_RUNNING_enum) running
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RUNNING_INVALID;
    }
    return _running;
}

/**
 * Changes the running state of the watchdog.
 * 
 * @param newval : either Y_RUNNING_OFF or Y_RUNNING_ON, according to the running state of the watchdog
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_running:(Y_RUNNING_enum) newval
{
    return [self setRunning:newval];
}
-(int) setRunning:(Y_RUNNING_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"running" :rest_val];
}

/**
 * Resets the watchdog. When the watchdog is running, this function
 * must be called on a regular basis to prevent the watchog to
 * trigger
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetWatchdog
{
    NSString* rest_val;
    rest_val = @"1";
    return [self _setAttr:@"running" :rest_val];
}

/**
 * Returns  the waiting duration before a reset is automatically triggered by the watchdog, in milliseconds.
 * 
 * @return an integer corresponding to  the waiting duration before a reset is automatically triggered
 * by the watchdog, in milliseconds
 * 
 * On failure, throws an exception or returns Y_TRIGGERDELAY_INVALID.
 */
-(unsigned) get_triggerDelay
{
    return [self triggerDelay];
}
-(unsigned) triggerDelay
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_TRIGGERDELAY_INVALID;
    }
    return _triggerDelay;
}

/**
 * Changes the waiting delay before a reset is triggered by the watchdog, in milliseconds.
 * 
 * @param newval : an integer corresponding to the waiting delay before a reset is triggered by the
 * watchdog, in milliseconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_triggerDelay:(unsigned) newval
{
    return [self setTriggerDelay:newval];
}
-(int) setTriggerDelay:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"triggerDelay" :rest_val];
}

/**
 * Returns the duration of resets caused by the watchdog, in milliseconds.
 * 
 * @return an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
 * 
 * On failure, throws an exception or returns Y_TRIGGERDURATION_INVALID.
 */
-(unsigned) get_triggerDuration
{
    return [self triggerDuration];
}
-(unsigned) triggerDuration
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_TRIGGERDURATION_INVALID;
    }
    return _triggerDuration;
}

/**
 * Changes the duration of resets caused by the watchdog, in milliseconds.
 * 
 * @param newval : an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_triggerDuration:(unsigned) newval
{
    return [self setTriggerDuration:newval];
}
-(int) setTriggerDuration:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"triggerDuration" :rest_val];
}

-(YWatchdog*)   nextWatchdog
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindWatchdog(hwid);
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

+(YWatchdog*) FindWatchdog:(NSString*) func
{
    YWatchdog * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YWatchdog"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YWatchdog"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YWatchdog"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YWatchdog"] objectForKey:func];
    } else {
        retVal = [[YWatchdog alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YWatchdog"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YWatchdog *) FirstWatchdog
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Watchdog":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YWatchdog FindWatchdog:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YWatchdog implementation)

@end
//--- (Watchdog functions)

YWatchdog *yFindWatchdog(NSString* func)
{
    return [YWatchdog FindWatchdog:func];
}

YWatchdog *yFirstWatchdog(void)
{
    return [YWatchdog FirstWatchdog];
}

//--- (end of Watchdog functions)
