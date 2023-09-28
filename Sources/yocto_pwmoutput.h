/*********************************************************************
 *
 *  $Id: yocto_pwmoutput.h 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Declares yFindPwmOutput(), the high-level API for PwmOutput functions
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

@class YPwmOutput;

//--- (YPwmOutput globals)
typedef void (*YPwmOutputValueCallback)(YPwmOutput *func, NSString *functionValue);
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
#ifndef _Y_ENABLEDATPOWERON_ENUM
#define _Y_ENABLEDATPOWERON_ENUM
typedef enum {
    Y_ENABLEDATPOWERON_FALSE = 0,
    Y_ENABLEDATPOWERON_TRUE = 1,
    Y_ENABLEDATPOWERON_INVALID = -1,
} Y_ENABLEDATPOWERON_enum;
#endif
#define Y_FREQUENCY_INVALID             YAPI_INVALID_DOUBLE
#define Y_PERIOD_INVALID                YAPI_INVALID_DOUBLE
#define Y_DUTYCYCLE_INVALID             YAPI_INVALID_DOUBLE
#define Y_PULSEDURATION_INVALID         YAPI_INVALID_DOUBLE
#define Y_PWMTRANSITION_INVALID         YAPI_INVALID_STRING
#define Y_DUTYCYCLEATPOWERON_INVALID    YAPI_INVALID_DOUBLE
//--- (end of YPwmOutput globals)

//--- (YPwmOutput class start)
/**
 * YPwmOutput Class: PWM generator control interface, available for instance in the Yocto-PWM-Tx
 *
 * The YPwmOutput class allows you to drive a pulse-width modulated output (PWM).
 * You can configure the frequency as well as the duty cycle, and setup progressive
 * transitions.
 */
@interface YPwmOutput : YFunction
//--- (end of YPwmOutput class start)
{
@protected
//--- (YPwmOutput attributes declaration)
    Y_ENABLED_enum  _enabled;
    double          _frequency;
    double          _period;
    double          _dutyCycle;
    double          _pulseDuration;
    NSString*       _pwmTransition;
    Y_ENABLEDATPOWERON_enum _enabledAtPowerOn;
    double          _dutyCycleAtPowerOn;
    YPwmOutputValueCallback _valueCallbackPwmOutput;
//--- (end of YPwmOutput attributes declaration)
}
// Constructor is protected, use yFindPwmOutput factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPwmOutput private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPwmOutput private methods declaration)
//--- (YPwmOutput yapiwrapper declaration)
//--- (end of YPwmOutput yapiwrapper declaration)
//--- (YPwmOutput public methods declaration)
/**
 * Returns the state of the PWM generators.
 *
 * @return either YPwmOutput.ENABLED_FALSE or YPwmOutput.ENABLED_TRUE, according to the state of the PWM generators
 *
 * On failure, throws an exception or returns YPwmOutput.ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Stops or starts the PWM.
 *
 * @param newval : either YPwmOutput.ENABLED_FALSE or YPwmOutput.ENABLED_TRUE
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_frequency:(double) newval;
-(int)     setFrequency:(double) newval;

/**
 * Returns the PWM frequency in Hz.
 *
 * @return a floating point number corresponding to the PWM frequency in Hz
 *
 * On failure, throws an exception or returns YPwmOutput.FREQUENCY_INVALID.
 */
-(double)     get_frequency;


-(double) frequency;
/**
 * Changes the PWM period in milliseconds. Caution: in order to avoid  random truncation of
 * the current pulse, the change will not be applied
 * before the end of the current period. This can significantly affect reaction
 * time at low frequencies. If you call the matching module saveToFlash()
 * method, the frequency will be kept after a device power cycle.
 *
 * @param newval : a floating point number corresponding to the PWM period in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_period:(double) newval;
-(int)     setPeriod:(double) newval;

/**
 * Returns the PWM period in milliseconds.
 *
 * @return a floating point number corresponding to the PWM period in milliseconds
 *
 * On failure, throws an exception or returns YPwmOutput.PERIOD_INVALID.
 */
-(double)     get_period;


-(double) period;
/**
 * Changes the PWM duty cycle, in per cents.
 *
 * @param newval : a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_dutyCycle:(double) newval;
-(int)     setDutyCycle:(double) newval;

/**
 * Returns the PWM duty cycle, in per cents.
 *
 * @return a floating point number corresponding to the PWM duty cycle, in per cents
 *
 * On failure, throws an exception or returns YPwmOutput.DUTYCYCLE_INVALID.
 */
-(double)     get_dutyCycle;


-(double) dutyCycle;
/**
 * Changes the PWM pulse length, in milliseconds. A pulse length cannot be longer than period,
 * otherwise it is truncated.
 *
 * @param newval : a floating point number corresponding to the PWM pulse length, in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pulseDuration:(double) newval;
-(int)     setPulseDuration:(double) newval;

/**
 * Returns the PWM pulse length in milliseconds, as a floating point number.
 *
 * @return a floating point number corresponding to the PWM pulse length in milliseconds, as a
 * floating point number
 *
 * On failure, throws an exception or returns YPwmOutput.PULSEDURATION_INVALID.
 */
-(double)     get_pulseDuration;


-(double) pulseDuration;
-(NSString*)     get_pwmTransition;


-(NSString*) pwmTransition;
-(int)     set_pwmTransition:(NSString*) newval;
-(int)     setPwmTransition:(NSString*) newval;

/**
 * Returns the state of the PWM at device power on.
 *
 * @return either YPwmOutput.ENABLEDATPOWERON_FALSE or YPwmOutput.ENABLEDATPOWERON_TRUE, according to
 * the state of the PWM at device power on
 *
 * On failure, throws an exception or returns YPwmOutput.ENABLEDATPOWERON_INVALID.
 */
-(Y_ENABLEDATPOWERON_enum)     get_enabledAtPowerOn;


-(Y_ENABLEDATPOWERON_enum) enabledAtPowerOn;
/**
 * Changes the state of the PWM at device power on. Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : either YPwmOutput.ENABLEDATPOWERON_FALSE or YPwmOutput.ENABLEDATPOWERON_TRUE,
 * according to the state of the PWM at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;
-(int)     setEnabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;

/**
 * Changes the PWM duty cycle at device power on. Remember to call the matching
 * module saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : a floating point number corresponding to the PWM duty cycle at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_dutyCycleAtPowerOn:(double) newval;
-(int)     setDutyCycleAtPowerOn:(double) newval;

/**
 * Returns the PWM generators duty cycle at device power on as a floating point number between 0 and 100.
 *
 * @return a floating point number corresponding to the PWM generators duty cycle at device power on
 * as a floating point number between 0 and 100
 *
 * On failure, throws an exception or returns YPwmOutput.DUTYCYCLEATPOWERON_INVALID.
 */
-(double)     get_dutyCycleAtPowerOn;


-(double) dutyCycleAtPowerOn;
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
+(YPwmOutput*)     FindPwmOutput:(NSString*)func;

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
-(int)     registerValueCallback:(YPwmOutputValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Performs a smooth transition of the pulse duration toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param ms_target   : new pulse duration at the end of the transition
 *         (floating-point number, representing the pulse duration in milliseconds)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     pulseDurationMove:(double)ms_target :(int)ms_duration;

/**
 * Performs a smooth change of the duty cycle toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param target      : new duty cycle at the end of the transition
 *         (percentage, floating-point number between 0 and 100)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     dutyCycleMove:(double)target :(int)ms_duration;

/**
 * Performs a smooth frequency change toward a given value.
 * Any period, frequency, duty cycle or pulse width change will cancel any ongoing transition process.
 *
 * @param target      : new frequency at the end of the transition (floating-point number)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     frequencyMove:(double)target :(int)ms_duration;

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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     phaseMove:(double)target :(int)ms_duration;

/**
 * Trigger a given number of pulses of specified duration, at current frequency.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param ms_target : desired pulse duration
 *         (floating-point number, representing the pulse duration in milliseconds)
 * @param n_pulses  : desired pulse count
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerPulsesByDuration:(double)ms_target :(int)n_pulses;

/**
 * Trigger a given number of pulses of specified duration, at current frequency.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param target   : desired duty cycle for the generated pulses
 *         (percentage, floating-point number between 0 and 100)
 * @param n_pulses : desired pulse count
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerPulsesByDutyCycle:(double)target :(int)n_pulses;

/**
 * Trigger a given number of pulses at the specified frequency, using current duty cycle.
 * At the end of the pulse train, revert to the original state of the PWM generator.
 *
 * @param target   : desired frequency for the generated pulses (floating-point number)
 * @param n_pulses : desired pulse count
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerPulsesByFrequency:(double)target :(int)n_pulses;

-(int)     markForRepeat;

-(int)     repeatFromMark;


/**
 * Continues the enumeration of PWM generators started using yFirstPwmOutput().
 * Caution: You can't make any assumption about the returned PWM generators order.
 * If you want to find a specific a PWM generator, use PwmOutput.findPwmOutput()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YPwmOutput object, corresponding to
 *         a PWM generator currently online, or a nil pointer
 *         if there are no more PWM generators to enumerate.
 */
-(nullable YPwmOutput*) nextPwmOutput
NS_SWIFT_NAME(nextPwmOutput());
/**
 * Starts the enumeration of PWM generators currently accessible.
 * Use the method YPwmOutput.nextPwmOutput() to iterate on
 * next PWM generators.
 *
 * @return a pointer to a YPwmOutput object, corresponding to
 *         the first PWM generator currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YPwmOutput*) FirstPwmOutput
NS_SWIFT_NAME(FirstPwmOutput());
//--- (end of YPwmOutput public methods declaration)

@end

//--- (YPwmOutput functions declaration)
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
YPwmOutput* yFindPwmOutput(NSString* func);
/**
 * Starts the enumeration of PWM generators currently accessible.
 * Use the method YPwmOutput.nextPwmOutput() to iterate on
 * next PWM generators.
 *
 * @return a pointer to a YPwmOutput object, corresponding to
 *         the first PWM generator currently online, or a nil pointer
 *         if there are none.
 */
YPwmOutput* yFirstPwmOutput(void);

//--- (end of YPwmOutput functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

