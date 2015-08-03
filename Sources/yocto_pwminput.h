/*********************************************************************
 *
 * $Id: yocto_pwminput.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindPwmInput(), the high-level API for PwmInput functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

@class YPwmInput;

//--- (YPwmInput globals)
typedef void (*YPwmInputValueCallback)(YPwmInput *func, NSString *functionValue);
typedef void (*YPwmInputTimedReportCallback)(YPwmInput *func, YMeasure *measure);
#ifndef _Y_PWMREPORTMODE_ENUM
#define _Y_PWMREPORTMODE_ENUM
typedef enum {
    Y_PWMREPORTMODE_PWM_DUTYCYCLE = 0,
    Y_PWMREPORTMODE_PWM_FREQUENCY = 1,
    Y_PWMREPORTMODE_PWM_PULSEDURATION = 2,
    Y_PWMREPORTMODE_PWM_EDGECOUNT = 3,
    Y_PWMREPORTMODE_INVALID = -1,
} Y_PWMREPORTMODE_enum;
#endif
#define Y_DUTYCYCLE_INVALID             YAPI_INVALID_DOUBLE
#define Y_PULSEDURATION_INVALID         YAPI_INVALID_DOUBLE
#define Y_FREQUENCY_INVALID             YAPI_INVALID_DOUBLE
#define Y_PERIOD_INVALID                YAPI_INVALID_DOUBLE
#define Y_PULSECOUNTER_INVALID          YAPI_INVALID_LONG
#define Y_PULSETIMER_INVALID            YAPI_INVALID_LONG
//--- (end of YPwmInput globals)

//--- (YPwmInput class start)
/**
 * YPwmInput Class: PwmInput function interface
 *
 * The Yoctopuce class YPwmInput allows you to read and configure Yoctopuce PWM
 * sensors. It inherits from YSensor class the core functions to read measurements,
 * register callback functions, access to the autonomous datalogger.
 * This class adds the ability to configure the signal parameter used to transmit
 * information: the duty cacle, the frequency or the pulse width.
 */
@interface YPwmInput : YSensor
//--- (end of YPwmInput class start)
{
@protected
//--- (YPwmInput attributes declaration)
    double          _dutyCycle;
    double          _pulseDuration;
    double          _frequency;
    double          _period;
    s64             _pulseCounter;
    s64             _pulseTimer;
    Y_PWMREPORTMODE_enum _pwmReportMode;
    YPwmInputValueCallback _valueCallbackPwmInput;
    YPwmInputTimedReportCallback _timedReportCallbackPwmInput;
//--- (end of YPwmInput attributes declaration)
}
// Constructor is protected, use yFindPwmInput factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPwmInput private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPwmInput private methods declaration)
//--- (YPwmInput public methods declaration)
/**
 * Returns the PWM duty cycle, in per cents.
 *
 * @return a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * On failure, throws an exception or returns Y_DUTYCYCLE_INVALID.
 */
-(double)     get_dutyCycle;


-(double) dutyCycle;
/**
 * Returns the PWM pulse length in milliseconds, as a floating point number.
 *
 * @return a floating point number corresponding to the PWM pulse length in milliseconds, as a
 * floating point number
 *
 * On failure, throws an exception or returns Y_PULSEDURATION_INVALID.
 */
-(double)     get_pulseDuration;


-(double) pulseDuration;
/**
 * Returns the PWM frequency in Hz.
 *
 * @return a floating point number corresponding to the PWM frequency in Hz
 *
 * On failure, throws an exception or returns Y_FREQUENCY_INVALID.
 */
-(double)     get_frequency;


-(double) frequency;
/**
 * Returns the PWM period in milliseconds.
 *
 * @return a floating point number corresponding to the PWM period in milliseconds
 *
 * On failure, throws an exception or returns Y_PERIOD_INVALID.
 */
-(double)     get_period;


-(double) period;
/**
 * Returns the pulse counter value. Actually that
 * counter is incremented twice per period. That counter is
 * limited  to 1 billion
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(s64)     get_pulseCounter;


-(s64) pulseCounter;
-(int)     set_pulseCounter:(s64) newval;
-(int)     setPulseCounter:(s64) newval;

/**
 * Returns the timer of the pulses counter (ms)
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(s64)     get_pulseTimer;


-(s64) pulseTimer;
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
-(Y_PWMREPORTMODE_enum)     get_pwmReportMode;


-(Y_PWMREPORTMODE_enum) pwmReportMode;
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
-(int)     set_pwmReportMode:(Y_PWMREPORTMODE_enum) newval;
-(int)     setPwmReportMode:(Y_PWMREPORTMODE_enum) newval;

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
 * @param func : a string that uniquely characterizes the PWM input
 *
 * @return a YPwmInput object allowing you to drive the PWM input.
 */
+(YPwmInput*)     FindPwmInput:(NSString*)func;

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
-(int)     registerValueCallback:(YPwmInputValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     registerTimedReportCallback:(YPwmInputTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetCounter;


/**
 * Continues the enumeration of PWM inputs started using yFirstPwmInput().
 *
 * @return a pointer to a YPwmInput object, corresponding to
 *         a PWM input currently online, or a null pointer
 *         if there are no more PWM inputs to enumerate.
 */
-(YPwmInput*) nextPwmInput;
/**
 * Starts the enumeration of PWM inputs currently accessible.
 * Use the method YPwmInput.nextPwmInput() to iterate on
 * next PWM inputs.
 *
 * @return a pointer to a YPwmInput object, corresponding to
 *         the first PWM input currently online, or a null pointer
 *         if there are none.
 */
+(YPwmInput*) FirstPwmInput;
//--- (end of YPwmInput public methods declaration)

@end

//--- (PwmInput functions declaration)
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
 * @param func : a string that uniquely characterizes the PWM input
 *
 * @return a YPwmInput object allowing you to drive the PWM input.
 */
YPwmInput* yFindPwmInput(NSString* func);
/**
 * Starts the enumeration of PWM inputs currently accessible.
 * Use the method YPwmInput.nextPwmInput() to iterate on
 * next PWM inputs.
 *
 * @return a pointer to a YPwmInput object, corresponding to
 *         the first PWM input currently online, or a null pointer
 *         if there are none.
 */
YPwmInput* yFirstPwmInput(void);

//--- (end of PwmInput functions declaration)
CF_EXTERN_C_END

