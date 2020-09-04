/*********************************************************************
 *
 *  $Id: yocto_pwmoutput.m 41625 2020-08-31 07:09:39Z seb $
 *
 *  Implements the high-level API for PwmOutput functions
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


#import "yocto_pwmoutput.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YPwmOutput

// Constructor is protected, use yFindPwmOutput factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"PwmOutput";
//--- (YPwmOutput attributes initialization)
    _enabled = Y_ENABLED_INVALID;
    _frequency = Y_FREQUENCY_INVALID;
    _period = Y_PERIOD_INVALID;
    _dutyCycle = Y_DUTYCYCLE_INVALID;
    _pulseDuration = Y_PULSEDURATION_INVALID;
    _pwmTransition = Y_PWMTRANSITION_INVALID;
    _enabledAtPowerOn = Y_ENABLEDATPOWERON_INVALID;
    _dutyCycleAtPowerOn = Y_DUTYCYCLEATPOWERON_INVALID;
    _valueCallbackPwmOutput = NULL;
//--- (end of YPwmOutput attributes initialization)
    return self;
}
//--- (YPwmOutput yapiwrapper)
//--- (end of YPwmOutput yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YPwmOutput cleanup)
    ARC_release(_pwmTransition);
    _pwmTransition = nil;
    ARC_dealloc(super);
//--- (end of YPwmOutput cleanup)
}
//--- (YPwmOutput private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "frequency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _frequency =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "period")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _period =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "dutyCycle")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _dutyCycle =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "pulseDuration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseDuration =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "pwmTransition")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_pwmTransition);
        _pwmTransition =  [self _parseString:j];
        ARC_retain(_pwmTransition);
        return 1;
    }
    if(!strcmp(j->token, "enabledAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabledAtPowerOn =  (Y_ENABLEDATPOWERON_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "dutyCycleAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _dutyCycleAtPowerOn =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPwmOutput private methods implementation)
//--- (YPwmOutput public methods implementation)
/**
 * Returns the state of the PWM generators.
 *
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the state of the PWM generators
 *
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    Y_ENABLED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLED_INVALID;
        }
    }
    res = _enabled;
    return res;
}


-(Y_ENABLED_enum) enabled
{
    return [self get_enabled];
}

/**
 * Stops or starts the PWM.
 *
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabled:(Y_ENABLED_enum) newval
{
    return [self setEnabled:newval];
}
-(int) setEnabled:(Y_ENABLED_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabled" :rest_val];
}

/**
 * Changes the PWM frequency. The duty cycle is kept unchanged thanks to an
 * automatic pulse width change, in other words, the change will not be applied
 * before the end of the current period. This can significantly affect reaction
 * time at low frequencies. If you call the matching module saveToFlash()
 * method, the frequency will be kept after a device power cycle.
 * To stop the PWM signal, do not set the frequency to zero, use the set_enabled()
 * method instead.
 *
 * @param newval : a floating point number corresponding to the PWM frequency
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_frequency:(double) newval
{
    return [self setFrequency:newval];
}
-(int) setFrequency:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"frequency" :rest_val];
}
/**
 * Returns the PWM frequency in Hz.
 *
 * @return a floating point number corresponding to the PWM frequency in Hz
 *
 * On failure, throws an exception or returns Y_FREQUENCY_INVALID.
 */
-(double) get_frequency
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_FREQUENCY_INVALID;
        }
    }
    res = _frequency;
    return res;
}


-(double) frequency
{
    return [self get_frequency];
}

/**
 * Changes the PWM period in milliseconds. Caution: in order to avoid  random truncation of
 * the current pulse, the change will not be applied
 * before the end of the current period. This can significantly affect reaction
 * time at low frequencies. If you call the matching module saveToFlash()
 * method, the frequency will be kept after a device power cycle.
 *
 * @param newval : a floating point number corresponding to the PWM period in milliseconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_period:(double) newval
{
    return [self setPeriod:newval];
}
-(int) setPeriod:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"period" :rest_val];
}
/**
 * Returns the PWM period in milliseconds.
 *
 * @return a floating point number corresponding to the PWM period in milliseconds
 *
 * On failure, throws an exception or returns Y_PERIOD_INVALID.
 */
-(double) get_period
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PERIOD_INVALID;
        }
    }
    res = _period;
    return res;
}


-(double) period
{
    return [self get_period];
}

/**
 * Changes the PWM duty cycle, in per cents.
 *
 * @param newval : a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_dutyCycle:(double) newval
{
    return [self setDutyCycle:newval];
}
-(int) setDutyCycle:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"dutyCycle" :rest_val];
}
/**
 * Returns the PWM duty cycle, in per cents.
 *
 * @return a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * On failure, throws an exception or returns Y_DUTYCYCLE_INVALID.
 */
-(double) get_dutyCycle
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DUTYCYCLE_INVALID;
        }
    }
    res = _dutyCycle;
    return res;
}


-(double) dutyCycle
{
    return [self get_dutyCycle];
}

/**
 * Changes the PWM pulse length, in milliseconds. A pulse length cannot be longer than period,
 * otherwise it is truncated.
 *
 * @param newval : a floating point number corresponding to the PWM pulse length, in milliseconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pulseDuration:(double) newval
{
    return [self setPulseDuration:newval];
}
-(int) setPulseDuration:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"pulseDuration" :rest_val];
}
/**
 * Returns the PWM pulse length in milliseconds, as a floating point number.
 *
 * @return a floating point number corresponding to the PWM pulse length in milliseconds, as a
 * floating point number
 *
 * On failure, throws an exception or returns Y_PULSEDURATION_INVALID.
 */
-(double) get_pulseDuration
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSEDURATION_INVALID;
        }
    }
    res = _pulseDuration;
    return res;
}


-(double) pulseDuration
{
    return [self get_pulseDuration];
}
-(NSString*) get_pwmTransition
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PWMTRANSITION_INVALID;
        }
    }
    res = _pwmTransition;
    return res;
}


-(NSString*) pwmTransition
{
    return [self get_pwmTransition];
}

-(int) set_pwmTransition:(NSString*) newval
{
    return [self setPwmTransition:newval];
}
-(int) setPwmTransition:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"pwmTransition" :rest_val];
}
/**
 * Returns the state of the PWM at device power on.
 *
 * @return either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE, according to the state of the
 * PWM at device power on
 *
 * On failure, throws an exception or returns Y_ENABLEDATPOWERON_INVALID.
 */
-(Y_ENABLEDATPOWERON_enum) get_enabledAtPowerOn
{
    Y_ENABLEDATPOWERON_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLEDATPOWERON_INVALID;
        }
    }
    res = _enabledAtPowerOn;
    return res;
}


-(Y_ENABLEDATPOWERON_enum) enabledAtPowerOn
{
    return [self get_enabledAtPowerOn];
}

/**
 * Changes the state of the PWM at device power on. Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE, according to the state
 * of the PWM at device power on
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval
{
    return [self setEnabledAtPowerOn:newval];
}
-(int) setEnabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabledAtPowerOn" :rest_val];
}

/**
 * Changes the PWM duty cycle at device power on. Remember to call the matching
 * module saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : a floating point number corresponding to the PWM duty cycle at device power on
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_dutyCycleAtPowerOn:(double) newval
{
    return [self setDutyCycleAtPowerOn:newval];
}
-(int) setDutyCycleAtPowerOn:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"dutyCycleAtPowerOn" :rest_val];
}
/**
 * Returns the PWM generators duty cycle at device power on as a floating point number between 0 and 100.
 *
 * @return a floating point number corresponding to the PWM generators duty cycle at device power on
 * as a floating point number between 0 and 100
 *
 * On failure, throws an exception or returns Y_DUTYCYCLEATPOWERON_INVALID.
 */
-(double) get_dutyCycleAtPowerOn
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DUTYCYCLEATPOWERON_INVALID;
        }
    }
    res = _dutyCycleAtPowerOn;
    return res;
}


-(double) dutyCycleAtPowerOn
{
    return [self get_dutyCycleAtPowerOn];
}
/**
 * Retrieves a PWM generator for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the PWM generator is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmOutput.isOnline() to test if the PWM generator is
 * indeed online at a given time. In case of ambiguity when looking for
 * a PWM generator by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the PWM generator, for instance
 *         YPWMTX01.pwmOutput1.
 *
 * @return a YPwmOutput object allowing you to drive the PWM generator.
 */
+(YPwmOutput*) FindPwmOutput:(NSString*)func
{
    YPwmOutput* obj;
    obj = (YPwmOutput*) [YFunction _FindFromCache:@"PwmOutput" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPwmOutput alloc] initWith:func]);
        [YFunction _AddToCache:@"PwmOutput" : func :obj];
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
-(int) registerValueCallback:(YPwmOutputValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPwmOutput = callback;
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
    if (_valueCallbackPwmOutput != NULL) {
        _valueCallbackPwmOutput(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Performs a smooth transition of the pulse duration toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param ms_target   : new pulse duration at the end of the transition
 *         (floating-point number, representing the pulse duration in milliseconds)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulseDurationMove:(double)ms_target :(int)ms_duration
{
    NSString* newval;
    if (ms_target < 0.0) {
        ms_target = 0.0;
    }
    newval = [NSString stringWithFormat:@"%dms:%d", (int) floor(ms_target*65536+0.5),ms_duration];
    return [self set_pwmTransition:newval];
}

/**
 * Performs a smooth change of the duty cycle toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param target      : new duty cycle at the end of the transition
 *         (percentage, floating-point number between 0 and 100)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) dutyCycleMove:(double)target :(int)ms_duration
{
    NSString* newval;
    if (target < 0.0) {
        target = 0.0;
    }
    if (target > 100.0) {
        target = 100.0;
    }
    newval = [NSString stringWithFormat:@"%d:%d", (int) floor(target*65536+0.5),ms_duration];
    return [self set_pwmTransition:newval];
}

/**
 * Performs a smooth frequency change toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param target      : new frequency at the end of the transition (floating-point number)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) frequencyMove:(double)target :(int)ms_duration
{
    NSString* newval;
    if (target < 0.001) {
        target = 0.001;
    }
    newval = [NSString stringWithFormat:@"%gHz:%d", target,ms_duration];
    return [self set_pwmTransition:newval];
}

/**
 * Performs a smooth transition toward a specified value of the phase shift between this channel
 * and the other channel. The phase shift is executed by slightly changing the frequency
 * temporarily during the specified duration. This function only makes sense when both channels
 * are running, either at the same frequency, or at a multiple of the channel frequency.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param target      : phase shift at the end of the transition, in milliseconds (floating-point number)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) phaseMove:(double)target :(int)ms_duration
{
    NSString* newval;
    newval = [NSString stringWithFormat:@"%gps:%d", target,ms_duration];
    return [self set_pwmTransition:newval];
}

/**
 * Trigger a given number of pulses of specified duration, at current frequency.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param ms_target : desired pulse duration
 *         (floating-point number, representing the pulse duration in milliseconds)
 * @param n_pulses  : desired pulse count
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerPulsesByDuration:(double)ms_target :(int)n_pulses
{
    NSString* newval;
    if (ms_target < 0.0) {
        ms_target = 0.0;
    }
    newval = [NSString stringWithFormat:@"%dms*%d", (int) floor(ms_target*65536+0.5),n_pulses];
    return [self set_pwmTransition:newval];
}

/**
 * Trigger a given number of pulses of specified duration, at current frequency.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param target   : desired duty cycle for the generated pulses
 *         (percentage, floating-point number between 0 and 100)
 * @param n_pulses : desired pulse count
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerPulsesByDutyCycle:(double)target :(int)n_pulses
{
    NSString* newval;
    if (target < 0.0) {
        target = 0.0;
    }
    if (target > 100.0) {
        target = 100.0;
    }
    newval = [NSString stringWithFormat:@"%d*%d", (int) floor(target*65536+0.5),n_pulses];
    return [self set_pwmTransition:newval];
}

/**
 * Trigger a given number of pulses at the specified frequency, using current duty cycle.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param target   : desired frequency for the generated pulses (floating-point number)
 * @param n_pulses : desired pulse count
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerPulsesByFrequency:(double)target :(int)n_pulses
{
    NSString* newval;
    if (target < 0.001) {
        target = 0.001;
    }
    newval = [NSString stringWithFormat:@"%gHz*%d", target,n_pulses];
    return [self set_pwmTransition:newval];
}

-(int) markForRepeat
{
    return [self set_pwmTransition:@":"];
}

-(int) repeatFromMark
{
    return [self set_pwmTransition:@"R"];
}


-(YPwmOutput*)   nextPwmOutput
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPwmOutput FindPwmOutput:hwid];
}

+(YPwmOutput *) FirstPwmOutput
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"PwmOutput":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPwmOutput FindPwmOutput:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPwmOutput public methods implementation)

@end
//--- (YPwmOutput functions)

YPwmOutput *yFindPwmOutput(NSString* func)
{
    return [YPwmOutput FindPwmOutput:func];
}

YPwmOutput *yFirstPwmOutput(void)
{
    return [YPwmOutput FirstPwmOutput];
}

//--- (end of YPwmOutput functions)
