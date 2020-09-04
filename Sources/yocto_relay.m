/*********************************************************************
 *
 *  $Id: yocto_relay.m 41625 2020-08-31 07:09:39Z seb $
 *
 *  Implements the high-level API for Relay functions
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


#import "yocto_relay.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YRelay

// Constructor is protected, use yFindRelay factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Relay";
//--- (YRelay attributes initialization)
    _state = Y_STATE_INVALID;
    _stateAtPowerOn = Y_STATEATPOWERON_INVALID;
    _maxTimeOnStateA = Y_MAXTIMEONSTATEA_INVALID;
    _maxTimeOnStateB = Y_MAXTIMEONSTATEB_INVALID;
    _output = Y_OUTPUT_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _delayedPulseTimer = Y_DELAYEDPULSETIMER_INVALID;
    _countdown = Y_COUNTDOWN_INVALID;
    _valueCallbackRelay = NULL;
    _firm = 0;
//--- (end of YRelay attributes initialization)
    return self;
}
//--- (YRelay yapiwrapper)
//--- (end of YRelay yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YRelay cleanup)
    ARC_dealloc(super);
//--- (end of YRelay cleanup)
}
//--- (YRelay private methods implementation)

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
    return [super _parseAttr:j];
}
//--- (end of YRelay private methods implementation)
//--- (YRelay public methods implementation)
/**
 * Returns the state of the relays (A for the idle position, B for the active position).
 *
 * @return either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
 *
 * On failure, throws an exception or returns Y_STATE_INVALID.
 */
-(Y_STATE_enum) get_state
{
    Y_STATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_STATE_INVALID;
        }
    }
    res = _state;
    return res;
}


-(Y_STATE_enum) state
{
    return [self get_state];
}

/**
 * Changes the state of the relays (A for the idle position, B for the active position).
 *
 * @param newval : either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
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
 * Returns the state of the relays at device startup (A for the idle position,
 * B for the active position, UNCHANGED to leave the relay state as is).
 *
 * @return a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 * corresponding to the state of the relays at device startup (A for the idle position,
 *         B for the active position, UNCHANGED to leave the relay state as is)
 *
 * On failure, throws an exception or returns Y_STATEATPOWERON_INVALID.
 */
-(Y_STATEATPOWERON_enum) get_stateAtPowerOn
{
    Y_STATEATPOWERON_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_STATEATPOWERON_INVALID;
        }
    }
    res = _stateAtPowerOn;
    return res;
}


-(Y_STATEATPOWERON_enum) stateAtPowerOn
{
    return [self get_stateAtPowerOn];
}

/**
 * Changes the state of the relays at device startup (A for the idle position,
 * B for the active position, UNCHANGED to leave the relay state as is).
 * Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 * corresponding to the state of the relays at device startup (A for the idle position,
 *         B for the active position, UNCHANGED to leave the relay state as is)
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
 * Returns the maximum time (ms) allowed for the relay to stay in state
 * A before automatically switching back in to B state. Zero means no time limit.
 *
 * @return an integer corresponding to the maximum time (ms) allowed for the relay to stay in state
 *         A before automatically switching back in to B state
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEA_INVALID.
 */
-(s64) get_maxTimeOnStateA
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXTIMEONSTATEA_INVALID;
        }
    }
    res = _maxTimeOnStateA;
    return res;
}


-(s64) maxTimeOnStateA
{
    return [self get_maxTimeOnStateA];
}

/**
 * Changes the maximum time (ms) allowed for the relay to stay in state A
 * before automatically switching back in to B state. Use zero for no time limit.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the maximum time (ms) allowed for the relay to stay in state A
 *         before automatically switching back in to B state
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
 * Retourne the maximum time (ms) allowed for the relay to stay in state B
 * before automatically switching back in to A state. Zero means no time limit.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEB_INVALID.
 */
-(s64) get_maxTimeOnStateB
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXTIMEONSTATEB_INVALID;
        }
    }
    res = _maxTimeOnStateB;
    return res;
}


-(s64) maxTimeOnStateB
{
    return [self get_maxTimeOnStateB];
}

/**
 * Changes the maximum time (ms) allowed for the relay to stay in state B before
 * automatically switching back in to A state. Use zero for no time limit.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the maximum time (ms) allowed for the relay to stay in
 * state B before
 *         automatically switching back in to A state
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
 * Returns the output state of the relays, when used as a simple switch (single throw).
 *
 * @return either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays, when used
 * as a simple switch (single throw)
 *
 * On failure, throws an exception or returns Y_OUTPUT_INVALID.
 */
-(Y_OUTPUT_enum) get_output
{
    Y_OUTPUT_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_OUTPUT_INVALID;
        }
    }
    res = _output;
    return res;
}


-(Y_OUTPUT_enum) output
{
    return [self get_output];
}

/**
 * Changes the output state of the relays, when used as a simple switch (single throw).
 *
 * @param newval : either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays,
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
 * Returns the number of milliseconds remaining before the relays is returned to idle position
 * (state A), during a measured pulse generation. When there is no ongoing pulse, returns zero.
 *
 * @return an integer corresponding to the number of milliseconds remaining before the relays is
 * returned to idle position
 *         (state A), during a measured pulse generation
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
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
 * @param ms_duration : pulse duration, in milliseconds
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
    YDelayedPulse res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DELAYEDPULSETIMER_INVALID;
        }
    }
    res = _delayedPulseTimer;
    return res;
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
 * @param ms_delay : waiting time before the pulse, in milliseconds
 * @param ms_duration : pulse duration, in milliseconds
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
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COUNTDOWN_INVALID;
        }
    }
    res = _countdown;
    return res;
}


-(s64) countdown
{
    return [self get_countdown];
}
/**
 * Retrieves a relay for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the relay is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRelay.isOnline() to test if the relay is
 * indeed online at a given time. In case of ambiguity when looking for
 * a relay by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the relay, for instance
 *         YLTCHRL1.relay1.
 *
 * @return a YRelay object allowing you to drive the relay.
 */
+(YRelay*) FindRelay:(NSString*)func
{
    YRelay* obj;
    obj = (YRelay*) [YFunction _FindFromCache:@"Relay" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YRelay alloc] initWith:func]);
        [YFunction _AddToCache:@"Relay" : func :obj];
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
-(int) registerValueCallback:(YRelayValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackRelay = callback;
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
    if (_valueCallbackRelay != NULL) {
        _valueCallbackRelay(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Switch the relay to the opposite state.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) toggle
{
    int sta;
    NSString* fw;
    YModule* mo;
    if (_firm == 0) {
        mo = [self get_module];
        fw = [mo get_firmwareRelease];
        if ([fw isEqualToString:Y_FIRMWARERELEASE_INVALID]) {
            return Y_STATE_INVALID;
        }
        _firm = [fw intValue];
    }
    if (_firm < 34921) {
        sta = [self get_state];
        if (sta == Y_STATE_INVALID) {
            return Y_STATE_INVALID;
        }
        if (sta == Y_STATE_B) {
            [self set_state:Y_STATE_A];
        } else {
            [self set_state:Y_STATE_B];
        }
        return YAPI_SUCCESS;
    } else {
        return [self _setAttr:@"state" :@"X"];
    }
}


-(YRelay*)   nextRelay
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YRelay FindRelay:hwid];
}

+(YRelay *) FirstRelay
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Relay":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRelay FindRelay:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YRelay public methods implementation)

@end
//--- (YRelay functions)

YRelay *yFindRelay(NSString* func)
{
    return [YRelay FindRelay:func];
}

YRelay *yFirstRelay(void)
{
    return [YRelay FirstRelay];
}

//--- (end of YRelay functions)
