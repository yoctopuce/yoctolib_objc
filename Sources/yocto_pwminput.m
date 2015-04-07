/*********************************************************************
 *
 * $Id: yocto_pwminput.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for PwmInput functions
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


#import "yocto_pwminput.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YPwmInput

// Constructor is protected, use yFindPwmInput factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"PwmInput";
//--- (YPwmInput attributes initialization)
    _dutyCycle = Y_DUTYCYCLE_INVALID;
    _pulseDuration = Y_PULSEDURATION_INVALID;
    _frequency = Y_FREQUENCY_INVALID;
    _period = Y_PERIOD_INVALID;
    _pulseCounter = Y_PULSECOUNTER_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _pwmReportMode = Y_PWMREPORTMODE_INVALID;
    _valueCallbackPwmInput = NULL;
    _timedReportCallbackPwmInput = NULL;
//--- (end of YPwmInput attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YPwmInput cleanup)
    ARC_dealloc(super);
//--- (end of YPwmInput cleanup)
}
//--- (YPwmInput private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
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
    if(!strcmp(j->token, "pwmReportMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pwmReportMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPwmInput private methods implementation)
//--- (YPwmInput public methods implementation)
/**
 * Returns the PWM duty cycle, in per cents.
 *
 * @return a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * On failure, throws an exception or returns Y_DUTYCYCLE_INVALID.
 */
-(double) get_dutyCycle
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DUTYCYCLE_INVALID;
        }
    }
    return _dutyCycle;
}


-(double) dutyCycle
{
    return [self get_dutyCycle];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSEDURATION_INVALID;
        }
    }
    return _pulseDuration;
}


-(double) pulseDuration
{
    return [self get_pulseDuration];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_FREQUENCY_INVALID;
        }
    }
    return _frequency;
}


-(double) frequency
{
    return [self get_frequency];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PERIOD_INVALID;
        }
    }
    return _period;
}


-(double) period
{
    return [self get_period];
}
/**
 * Returns the pulse counter value. Actually that
 * counter is incremented twice per period. That counter is
 * limited  to 1 billion
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
 * Returns the timer of the pulses counter (ms)
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
 * Returns the parameter (frequency/duty cycle, pulse width, edges count) returned by the
 * get_currentValue function and callbacks. Attention
 *
 * @return a value among Y_PWMREPORTMODE_PWM_DUTYCYCLE, Y_PWMREPORTMODE_PWM_FREQUENCY,
 * Y_PWMREPORTMODE_PWM_PULSEDURATION and Y_PWMREPORTMODE_PWM_EDGECOUNT corresponding to the parameter
 * (frequency/duty cycle, pulse width, edges count) returned by the get_currentValue function and callbacks
 *
 * On failure, throws an exception or returns Y_PWMREPORTMODE_INVALID.
 */
-(Y_PWMREPORTMODE_enum) get_pwmReportMode
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PWMREPORTMODE_INVALID;
        }
    }
    return _pwmReportMode;
}


-(Y_PWMREPORTMODE_enum) pwmReportMode
{
    return [self get_pwmReportMode];
}

/**
 * Modifies the  parameter  type (frequency/duty cycle, pulse width, or edge count) returned by the
 * get_currentValue function and callbacks.
 * The edge count value is limited to the 6 lowest digits. For values greater than one million, use
 * get_pulseCounter().
 *
 * @param newval : a value among Y_PWMREPORTMODE_PWM_DUTYCYCLE, Y_PWMREPORTMODE_PWM_FREQUENCY,
 * Y_PWMREPORTMODE_PWM_PULSEDURATION and Y_PWMREPORTMODE_PWM_EDGECOUNT
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pwmReportMode:(Y_PWMREPORTMODE_enum) newval
{
    return [self setPwmReportMode:newval];
}
-(int) setPwmReportMode:(Y_PWMREPORTMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"pwmReportMode" :rest_val];
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
 * Use the method YPwmInput.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YPwmInput object allowing you to drive $THEFUNCTION$.
 */
+(YPwmInput*) FindPwmInput:(NSString*)func
{
    YPwmInput* obj;
    obj = (YPwmInput*) [YFunction _FindFromCache:@"PwmInput" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPwmInput alloc] initWith:func]);
        [YFunction _AddToCache:@"PwmInput" : func :obj];
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
-(int) registerValueCallback:(YPwmInputValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPwmInput = callback;
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
    if (_valueCallbackPwmInput != NULL) {
        _valueCallbackPwmInput(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YPwmInputTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackPwmInput = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackPwmInput != NULL) {
        _timedReportCallbackPwmInput(self, value);
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


-(YPwmInput*)   nextPwmInput
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPwmInput FindPwmInput:hwid];
}

+(YPwmInput *) FirstPwmInput
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"PwmInput":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPwmInput FindPwmInput:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPwmInput public methods implementation)

@end
//--- (PwmInput functions)

YPwmInput *yFindPwmInput(NSString* func)
{
    return [YPwmInput FindPwmInput:func];
}

YPwmInput *yFirstPwmInput(void)
{
    return [YPwmInput FirstPwmInput];
}

//--- (end of PwmInput functions)
