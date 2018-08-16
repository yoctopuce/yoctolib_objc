/*********************************************************************
 *
 * $Id: yocto_pwminput.m 31436 2018-08-07 15:28:18Z seb $
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
    _debouncePeriod = Y_DEBOUNCEPERIOD_INVALID;
    _valueCallbackPwmInput = NULL;
    _timedReportCallbackPwmInput = NULL;
//--- (end of YPwmInput attributes initialization)
    return self;
}
//--- (YPwmInput yapiwrapper)
//--- (end of YPwmInput yapiwrapper)
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
    if(!strcmp(j->token, "debouncePeriod")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _debouncePeriod =  atoi(j->token);
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
 * Returns the pulse counter value. Actually that
 * counter is incremented twice per period. That counter is
 * limited  to 1 billion.
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
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
 * Returns the timer of the pulses counter (ms).
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
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
/**
 * Returns the parameter (frequency/duty cycle, pulse width, edges count) returned by the
 * get_currentValue function and callbacks. Attention
 *
 * @return a value among Y_PWMREPORTMODE_PWM_DUTYCYCLE, Y_PWMREPORTMODE_PWM_FREQUENCY,
 * Y_PWMREPORTMODE_PWM_PULSEDURATION, Y_PWMREPORTMODE_PWM_EDGECOUNT, Y_PWMREPORTMODE_PWM_PULSECOUNT,
 * Y_PWMREPORTMODE_PWM_CPS, Y_PWMREPORTMODE_PWM_CPM, Y_PWMREPORTMODE_PWM_STATE,
 * Y_PWMREPORTMODE_PWM_FREQ_CPS and Y_PWMREPORTMODE_PWM_FREQ_CPM corresponding to the parameter
 * (frequency/duty cycle, pulse width, edges count) returned by the get_currentValue function and callbacks
 *
 * On failure, throws an exception or returns Y_PWMREPORTMODE_INVALID.
 */
-(Y_PWMREPORTMODE_enum) get_pwmReportMode
{
    Y_PWMREPORTMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PWMREPORTMODE_INVALID;
        }
    }
    res = _pwmReportMode;
    return res;
}


-(Y_PWMREPORTMODE_enum) pwmReportMode
{
    return [self get_pwmReportMode];
}

/**
 * Changes the  parameter  type (frequency/duty cycle, pulse width, or edge count) returned by the
 * get_currentValue function and callbacks.
 * The edge count value is limited to the 6 lowest digits. For values greater than one million, use
 * get_pulseCounter().
 *
 * @param newval : a value among Y_PWMREPORTMODE_PWM_DUTYCYCLE, Y_PWMREPORTMODE_PWM_FREQUENCY,
 * Y_PWMREPORTMODE_PWM_PULSEDURATION, Y_PWMREPORTMODE_PWM_EDGECOUNT, Y_PWMREPORTMODE_PWM_PULSECOUNT,
 * Y_PWMREPORTMODE_PWM_CPS, Y_PWMREPORTMODE_PWM_CPM, Y_PWMREPORTMODE_PWM_STATE,
 * Y_PWMREPORTMODE_PWM_FREQ_CPS and Y_PWMREPORTMODE_PWM_FREQ_CPM corresponding to the  parameter  type
 * (frequency/duty cycle, pulse width, or edge count) returned by the get_currentValue function and callbacks
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
 * Returns the shortest expected pulse duration, in ms. Any shorter pulse will be automatically ignored (debounce).
 *
 * @return an integer corresponding to the shortest expected pulse duration, in ms
 *
 * On failure, throws an exception or returns Y_DEBOUNCEPERIOD_INVALID.
 */
-(int) get_debouncePeriod
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DEBOUNCEPERIOD_INVALID;
        }
    }
    res = _debouncePeriod;
    return res;
}


-(int) debouncePeriod
{
    return [self get_debouncePeriod];
}

/**
 * Changes the shortest expected pulse duration, in ms. Any shorter pulse will be automatically ignored (debounce).
 *
 * @param newval : an integer corresponding to the shortest expected pulse duration, in ms
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_debouncePeriod:(int) newval
{
    return [self setDebouncePeriod:newval];
}
-(int) setDebouncePeriod:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"debouncePeriod" :rest_val];
}
/**
 * Retrieves a PWM input for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the PWM input is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmInput.isOnline() to test if the PWM input is
 * indeed online at a given time. In case of ambiguity when looking for
 * a PWM input by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the PWM input
 *
 * @return a YPwmInput object allowing you to drive the PWM input.
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
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
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
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YPwmInputTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
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
//--- (YPwmInput functions)

YPwmInput *yFindPwmInput(NSString* func)
{
    return [YPwmInput FindPwmInput:func];
}

YPwmInput *yFirstPwmInput(void)
{
    return [YPwmInput FirstPwmInput];
}

//--- (end of YPwmInput functions)
