/*********************************************************************
 *
 * $Id: yocto_watchdog.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for Watchdog functions
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
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Watchdog";
//--- (YWatchdog attributes initialization)
    _state = Y_STATE_INVALID;
    _stateAtPowerOn = Y_STATEATPOWERON_INVALID;
    _maxTimeOnStateA = Y_MAXTIMEONSTATEA_INVALID;
    _maxTimeOnStateB = Y_MAXTIMEONSTATEB_INVALID;
    _output = Y_OUTPUT_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _delayedPulseTimer = Y_DELAYEDPULSETIMER_INVALID;
    _countdown = Y_COUNTDOWN_INVALID;
    _autoStart = Y_AUTOSTART_INVALID;
    _running = Y_RUNNING_INVALID;
    _triggerDelay = Y_TRIGGERDELAY_INVALID;
    _triggerDuration = Y_TRIGGERDURATION_INVALID;
    _valueCallbackWatchdog = NULL;
//--- (end of YWatchdog attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YWatchdog cleanup)
    ARC_dealloc(super);
//--- (end of YWatchdog cleanup)
}
//--- (YWatchdog private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "state")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _state =  (Y_STATE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "stateAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _stateAtPowerOn =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "maxTimeOnStateA")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxTimeOnStateA =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "maxTimeOnStateB")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxTimeOnStateB =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "output")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _output =  (Y_OUTPUT_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pulseTimer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseTimer =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "delayedPulseTimer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        if(j->st == YJSON_PARSE_STRUCT) {
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _delayedPulseTimer.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _delayedPulseTimer.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _delayedPulseTimer.ms = atoi(j->token);
                }
            }
        }
        return 1;
    }
    if(!strcmp(j->token, "countdown")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _countdown =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "autoStart")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _autoStart =  (Y_AUTOSTART_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "running")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _running =  (Y_RUNNING_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "triggerDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _triggerDelay =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "triggerDuration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _triggerDuration =  atol(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YWatchdog private methods implementation)
//--- (YWatchdog public methods implementation)
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STATE_INVALID;
        }
    }
    return _state;
}


-(Y_STATE_enum) state
{
    return [self get_state];
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
 * Returns the state of the watchdog at device startup (A for the idle position, B for the active
 * position, UNCHANGED for no change).
 *
 * @return a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 * corresponding to the state of the watchdog at device startup (A for the idle position, B for the
 * active position, UNCHANGED for no change)
 *
 * On failure, throws an exception or returns Y_STATEATPOWERON_INVALID.
 */
-(Y_STATEATPOWERON_enum) get_stateAtPowerOn
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STATEATPOWERON_INVALID;
        }
    }
    return _stateAtPowerOn;
}


-(Y_STATEATPOWERON_enum) stateAtPowerOn
{
    return [self get_stateAtPowerOn];
}

/**
 * Preset the state of the watchdog at device startup (A for the idle position,
 * B for the active position, UNCHANGED for no modification). Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_stateAtPowerOn:(Y_STATEATPOWERON_enum) newval
{
    return [self setStateAtPowerOn:newval];
}
-(int) setStateAtPowerOn:(Y_STATEATPOWERON_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"stateAtPowerOn" :rest_val];
}
/**
 * Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically
 * switching back in to B state. Zero means no maximum time.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEA_INVALID.
 */
-(s64) get_maxTimeOnStateA
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXTIMEONSTATEA_INVALID;
        }
    }
    return _maxTimeOnStateA;
}


-(s64) maxTimeOnStateA
{
    return [self get_maxTimeOnStateA];
}

/**
 * Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically
 * switching back in to B state. Use zero for no maximum time.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_maxTimeOnStateA:(s64) newval
{
    return [self setMaxTimeOnStateA:newval];
}
-(int) setMaxTimeOnStateA:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"maxTimeOnStateA" :rest_val];
}
/**
 * Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically
 * switching back in to A state. Zero means no maximum time.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEB_INVALID.
 */
-(s64) get_maxTimeOnStateB
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXTIMEONSTATEB_INVALID;
        }
    }
    return _maxTimeOnStateB;
}


-(s64) maxTimeOnStateB
{
    return [self get_maxTimeOnStateB];
}

/**
 * Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically
 * switching back in to A state. Use zero for no maximum time.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_maxTimeOnStateB:(s64) newval
{
    return [self setMaxTimeOnStateB:newval];
}
-(int) setMaxTimeOnStateB:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"maxTimeOnStateB" :rest_val];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_OUTPUT_INVALID;
        }
    }
    return _output;
}


-(Y_OUTPUT_enum) output
{
    return [self get_output];
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

-(int) set_pulseTimer:(s64) newval
{
    return [self setPulseTimer:newval];
}
-(int) setPulseTimer:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
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
-(int) pulse:(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)ms_duration];
    return [self _setAttr:@"pulseTimer" :rest_val];
}
-(YDelayedPulse) get_delayedPulseTimer
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DELAYEDPULSETIMER_INVALID;
        }
    }
    return _delayedPulseTimer;
}


-(YDelayedPulse) delayedPulseTimer
{
    return [self get_delayedPulseTimer];
}

-(int) set_delayedPulseTimer:(YDelayedPulse) newval
{
    return [self setDelayedPulseTimer:newval];
}
-(int) setDelayedPulseTimer:(YDelayedPulse) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",newval.target,newval.ms];
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
-(int) delayedPulse:(int)ms_delay :(int)ms_duration
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
-(s64) get_countdown
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COUNTDOWN_INVALID;
        }
    }
    return _countdown;
}


-(s64) countdown
{
    return [self get_countdown];
}
/**
 * Returns the watchdog runing state at module power on.
 *
 * @return either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runing state at module power on
 *
 * On failure, throws an exception or returns Y_AUTOSTART_INVALID.
 */
-(Y_AUTOSTART_enum) get_autoStart
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUTOSTART_INVALID;
        }
    }
    return _autoStart;
}


-(Y_AUTOSTART_enum) autoStart
{
    return [self get_autoStart];
}

/**
 * Changes the watchdog runningsttae at module power on. Remember to call the
 * saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runningsttae at
 * module power on
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RUNNING_INVALID;
        }
    }
    return _running;
}


-(Y_RUNNING_enum) running
{
    return [self get_running];
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
-(s64) get_triggerDelay
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TRIGGERDELAY_INVALID;
        }
    }
    return _triggerDelay;
}


-(s64) triggerDelay
{
    return [self get_triggerDelay];
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
-(int) set_triggerDelay:(s64) newval
{
    return [self setTriggerDelay:newval];
}
-(int) setTriggerDelay:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"triggerDelay" :rest_val];
}
/**
 * Returns the duration of resets caused by the watchdog, in milliseconds.
 *
 * @return an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
 *
 * On failure, throws an exception or returns Y_TRIGGERDURATION_INVALID.
 */
-(s64) get_triggerDuration
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TRIGGERDURATION_INVALID;
        }
    }
    return _triggerDuration;
}


-(s64) triggerDuration
{
    return [self get_triggerDuration];
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
-(int) set_triggerDuration:(s64) newval
{
    return [self setTriggerDuration:newval];
}
-(int) setTriggerDuration:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"triggerDuration" :rest_val];
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
 * Use the method YWatchdog.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YWatchdog object allowing you to drive $THEFUNCTION$.
 */
+(YWatchdog*) FindWatchdog:(NSString*)func
{
    YWatchdog* obj;
    obj = (YWatchdog*) [YFunction _FindFromCache:@"Watchdog" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YWatchdog alloc] initWith:func]);
        [YFunction _AddToCache:@"Watchdog" : func :obj];
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
-(int) registerValueCallback:(YWatchdogValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackWatchdog = callback;
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
    if (_valueCallbackWatchdog != NULL) {
        _valueCallbackWatchdog(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YWatchdog*)   nextWatchdog
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YWatchdog FindWatchdog:hwid];
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

//--- (end of YWatchdog public methods implementation)

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
