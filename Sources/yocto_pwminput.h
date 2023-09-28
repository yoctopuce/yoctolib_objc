/*********************************************************************
 *
 *  $Id: yocto_pwminput.h 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Declares yFindPwmInput(), the high-level API for PwmInput functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN

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
    Y_PWMREPORTMODE_PWM_PULSECOUNT = 4,
    Y_PWMREPORTMODE_PWM_CPS = 5,
    Y_PWMREPORTMODE_PWM_CPM = 6,
    Y_PWMREPORTMODE_PWM_STATE = 7,
    Y_PWMREPORTMODE_PWM_FREQ_CPS = 8,
    Y_PWMREPORTMODE_PWM_FREQ_CPM = 9,
    Y_PWMREPORTMODE_PWM_PERIODCOUNT = 10,
    Y_PWMREPORTMODE_INVALID = -1,
} Y_PWMREPORTMODE_enum;
#endif
#define Y_DUTYCYCLE_INVALID             YAPI_INVALID_DOUBLE
#define Y_PULSEDURATION_INVALID         YAPI_INVALID_DOUBLE
#define Y_FREQUENCY_INVALID             YAPI_INVALID_DOUBLE
#define Y_PERIOD_INVALID                YAPI_INVALID_DOUBLE
#define Y_PULSECOUNTER_INVALID          YAPI_INVALID_LONG
#define Y_PULSETIMER_INVALID            YAPI_INVALID_LONG
#define Y_DEBOUNCEPERIOD_INVALID        YAPI_INVALID_UINT
#define Y_BANDWIDTH_INVALID             YAPI_INVALID_UINT
#define Y_EDGESPERPERIOD_INVALID        YAPI_INVALID_UINT
//--- (end of YPwmInput globals)

//--- (YPwmInput class start)
/**
 * YPwmInput Class: PWM input control interface, available for instance in the Yocto-PWM-Rx
 *
 * The YPwmInput class allows you to read and configure Yoctopuce PWM inputs.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 * This class adds the ability to configure the signal parameter used to transmit
 * information: the duty cycle, the frequency or the pulse width.
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
    int             _debouncePeriod;
    int             _bandwidth;
    int             _edgesPerPeriod;
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
//--- (YPwmInput yapiwrapper declaration)
//--- (end of YPwmInput yapiwrapper declaration)
//--- (YPwmInput public methods declaration)
/**
 * Changes the measuring unit for the measured quantity. That unit
 * is just a string which is automatically initialized each time
 * the measurement mode is changed. But is can be set to an
 * arbitrary value.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the measured quantity
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the PWM duty cycle, in per cents.
 *
 * @return a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * On failure, throws an exception or returns YPwmInput.DUTYCYCLE_INVALID.
 */
-(double)     get_dutyCycle;


-(double) dutyCycle;
/**
 * Returns the PWM pulse length in milliseconds, as a floating point number.
 *
 * @return a floating point number corresponding to the PWM pulse length in milliseconds, as a
 * floating point number
 *
 * On failure, throws an exception or returns YPwmInput.PULSEDURATION_INVALID.
 */
-(double)     get_pulseDuration;


-(double) pulseDuration;
/**
 * Returns the PWM frequency in Hz.
 *
 * @return a floating point number corresponding to the PWM frequency in Hz
 *
 * On failure, throws an exception or returns YPwmInput.FREQUENCY_INVALID.
 */
-(double)     get_frequency;


-(double) frequency;
/**
 * Returns the PWM period in milliseconds.
 *
 * @return a floating point number corresponding to the PWM period in milliseconds
 *
 * On failure, throws an exception or returns YPwmInput.PERIOD_INVALID.
 */
-(double)     get_period;


-(double) period;
/**
 * Returns the pulse counter value. Actually that
 * counter is incremented twice per period. That counter is
 * limited  to 1 billion.
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns YPwmInput.PULSECOUNTER_INVALID.
 */
-(s64)     get_pulseCounter;


-(s64) pulseCounter;
-(int)     set_pulseCounter:(s64) newval;
-(int)     setPulseCounter:(s64) newval;

/**
 * Returns the timer of the pulses counter (ms).
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
 *
 * On failure, throws an exception or returns YPwmInput.PULSETIMER_INVALID.
 */
-(s64)     get_pulseTimer;


-(s64) pulseTimer;
/**
 * Returns the parameter (frequency/duty cycle, pulse width, edges count) returned by the
 * get_currentValue function and callbacks. Attention
 *
 * @return a value among YPwmInput.PWMREPORTMODE_PWM_DUTYCYCLE, YPwmInput.PWMREPORTMODE_PWM_FREQUENCY,
 * YPwmInput.PWMREPORTMODE_PWM_PULSEDURATION, YPwmInput.PWMREPORTMODE_PWM_EDGECOUNT,
 * YPwmInput.PWMREPORTMODE_PWM_PULSECOUNT, YPwmInput.PWMREPORTMODE_PWM_CPS,
 * YPwmInput.PWMREPORTMODE_PWM_CPM, YPwmInput.PWMREPORTMODE_PWM_STATE,
 * YPwmInput.PWMREPORTMODE_PWM_FREQ_CPS, YPwmInput.PWMREPORTMODE_PWM_FREQ_CPM and
 * YPwmInput.PWMREPORTMODE_PWM_PERIODCOUNT corresponding to the parameter (frequency/duty cycle, pulse
 * width, edges count) returned by the get_currentValue function and callbacks
 *
 * On failure, throws an exception or returns YPwmInput.PWMREPORTMODE_INVALID.
 */
-(Y_PWMREPORTMODE_enum)     get_pwmReportMode;


-(Y_PWMREPORTMODE_enum) pwmReportMode;
/**
 * Changes the  parameter  type (frequency/duty cycle, pulse width, or edge count) returned by the
 * get_currentValue function and callbacks.
 * The edge count value is limited to the 6 lowest digits. For values greater than one million, use
 * get_pulseCounter().
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YPwmInput.PWMREPORTMODE_PWM_DUTYCYCLE,
 * YPwmInput.PWMREPORTMODE_PWM_FREQUENCY, YPwmInput.PWMREPORTMODE_PWM_PULSEDURATION,
 * YPwmInput.PWMREPORTMODE_PWM_EDGECOUNT, YPwmInput.PWMREPORTMODE_PWM_PULSECOUNT,
 * YPwmInput.PWMREPORTMODE_PWM_CPS, YPwmInput.PWMREPORTMODE_PWM_CPM,
 * YPwmInput.PWMREPORTMODE_PWM_STATE, YPwmInput.PWMREPORTMODE_PWM_FREQ_CPS,
 * YPwmInput.PWMREPORTMODE_PWM_FREQ_CPM and YPwmInput.PWMREPORTMODE_PWM_PERIODCOUNT corresponding to
 * the  parameter  type (frequency/duty cycle, pulse width, or edge count) returned by the
 * get_currentValue function and callbacks
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pwmReportMode:(Y_PWMREPORTMODE_enum) newval;
-(int)     setPwmReportMode:(Y_PWMREPORTMODE_enum) newval;

/**
 * Returns the shortest expected pulse duration, in ms. Any shorter pulse will be automatically ignored (debounce).
 *
 * @return an integer corresponding to the shortest expected pulse duration, in ms
 *
 * On failure, throws an exception or returns YPwmInput.DEBOUNCEPERIOD_INVALID.
 */
-(int)     get_debouncePeriod;


-(int) debouncePeriod;
/**
 * Changes the shortest expected pulse duration, in ms. Any shorter pulse will be automatically ignored (debounce).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the shortest expected pulse duration, in ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_debouncePeriod:(int) newval;
-(int)     setDebouncePeriod:(int) newval;

/**
 * Returns the input signal sampling rate, in kHz.
 *
 * @return an integer corresponding to the input signal sampling rate, in kHz
 *
 * On failure, throws an exception or returns YPwmInput.BANDWIDTH_INVALID.
 */
-(int)     get_bandwidth;


-(int) bandwidth;
/**
 * Changes the input signal sampling rate, measured in kHz.
 * A lower sampling frequency can be used to hide hide-frequency bounce effects,
 * for instance on electromechanical contacts, but limits the measure resolution.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the input signal sampling rate, measured in kHz
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bandwidth:(int) newval;
-(int)     setBandwidth:(int) newval;

/**
 * Returns the number of edges detected per preiod. For a clean PWM signal, this should be exactly two,
 * but in cas the signal is created by a mechanical contact with bounces, it can get higher.
 *
 * @return an integer corresponding to the number of edges detected per preiod
 *
 * On failure, throws an exception or returns YPwmInput.EDGESPERPERIOD_INVALID.
 */
-(int)     get_edgesPerPeriod;


-(int) edgesPerPeriod;
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
 * @param func : a string that uniquely characterizes the PWM input, for instance
 *         YPWMRX01.pwmInput1.
 *
 * @return a YPwmInput object allowing you to drive the PWM input.
 */
+(YPwmInput*)     FindPwmInput:(NSString*)func;

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
-(int)     registerValueCallback:(YPwmInputValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     registerTimedReportCallback:(YPwmInputTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetCounter;


/**
 * Continues the enumeration of PWM inputs started using yFirstPwmInput().
 * Caution: You can't make any assumption about the returned PWM inputs order.
 * If you want to find a specific a PWM input, use PwmInput.findPwmInput()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YPwmInput object, corresponding to
 *         a PWM input currently online, or a nil pointer
 *         if there are no more PWM inputs to enumerate.
 */
-(nullable YPwmInput*) nextPwmInput
NS_SWIFT_NAME(nextPwmInput());
/**
 * Starts the enumeration of PWM inputs currently accessible.
 * Use the method YPwmInput.nextPwmInput() to iterate on
 * next PWM inputs.
 *
 * @return a pointer to a YPwmInput object, corresponding to
 *         the first PWM input currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YPwmInput*) FirstPwmInput
NS_SWIFT_NAME(FirstPwmInput());
//--- (end of YPwmInput public methods declaration)

@end

//--- (YPwmInput functions declaration)
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
 * @param func : a string that uniquely characterizes the PWM input, for instance
 *         YPWMRX01.pwmInput1.
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
 *         the first PWM input currently online, or a nil pointer
 *         if there are none.
 */
YPwmInput* yFirstPwmInput(void);

//--- (end of YPwmInput functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

