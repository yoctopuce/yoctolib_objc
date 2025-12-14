/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindAnButton(), the high-level API for AnButton functions
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

@class YAnButton;

//--- (YAnButton globals)
typedef void (*YAnButtonValueCallback)(YAnButton *func, NSString *functionValue);
#ifndef _Y_ANALOGCALIBRATION_ENUM
#define _Y_ANALOGCALIBRATION_ENUM
typedef enum {
    Y_ANALOGCALIBRATION_OFF = 0,
    Y_ANALOGCALIBRATION_ON = 1,
    Y_ANALOGCALIBRATION_INVALID = -1,
} Y_ANALOGCALIBRATION_enum;
#endif
#ifndef _Y_ISPRESSED_ENUM
#define _Y_ISPRESSED_ENUM
typedef enum {
    Y_ISPRESSED_FALSE = 0,
    Y_ISPRESSED_TRUE = 1,
    Y_ISPRESSED_INVALID = -1,
} Y_ISPRESSED_enum;
#endif
#ifndef _Y_INPUTTYPE_ENUM
#define _Y_INPUTTYPE_ENUM
typedef enum {
    Y_INPUTTYPE_ANALOG_FAST = 0,
    Y_INPUTTYPE_DIGITAL4 = 1,
    Y_INPUTTYPE_ANALOG_SMOOTH = 2,
    Y_INPUTTYPE_DIGITAL_FAST = 3,
    Y_INPUTTYPE_INVALID = -1,
} Y_INPUTTYPE_enum;
#endif
#define Y_CALIBRATEDVALUE_INVALID       YAPI_INVALID_UINT
#define Y_RAWVALUE_INVALID              YAPI_INVALID_UINT
#define Y_CALIBRATIONMAX_INVALID        YAPI_INVALID_UINT
#define Y_CALIBRATIONMIN_INVALID        YAPI_INVALID_UINT
#define Y_SENSITIVITY_INVALID           YAPI_INVALID_UINT
#define Y_LASTTIMEPRESSED_INVALID       YAPI_INVALID_LONG
#define Y_LASTTIMERELEASED_INVALID      YAPI_INVALID_LONG
#define Y_PULSECOUNTER_INVALID          YAPI_INVALID_LONG
#define Y_PULSETIMER_INVALID            YAPI_INVALID_LONG
//--- (end of YAnButton globals)

//--- (YAnButton class start)
/**
 * YAnButton Class: analog input control interface, available for instance in the Yocto-Buzzer, the
 * Yocto-Knob, the Yocto-MaxiBuzzer or the Yocto-MaxiDisplay
 *
 * The YAnButton class provide access to basic resistive inputs.
 * Such inputs can be used to measure the state
 * of a simple button as well as to read an analog potentiometer (variable resistance).
 * This can be use for instance with a continuous rotating knob, a throttle grip
 * or a joystick. The module is capable to calibrate itself on min and max values,
 * in order to compute a calibrated value that varies proportionally with the
 * potentiometer position, regardless of its total resistance.
 */
@interface YAnButton : YFunction
//--- (end of YAnButton class start)
{
@protected
//--- (YAnButton attributes declaration)
    int             _calibratedValue;
    int             _rawValue;
    Y_ANALOGCALIBRATION_enum _analogCalibration;
    int             _calibrationMax;
    int             _calibrationMin;
    int             _sensitivity;
    Y_ISPRESSED_enum _isPressed;
    s64             _lastTimePressed;
    s64             _lastTimeReleased;
    s64             _pulseCounter;
    s64             _pulseTimer;
    Y_INPUTTYPE_enum _inputType;
    YAnButtonValueCallback _valueCallbackAnButton;
//--- (end of YAnButton attributes declaration)
}
// Constructor is protected, use yFindAnButton factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YAnButton private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YAnButton private methods declaration)
//--- (YAnButton yapiwrapper declaration)
//--- (end of YAnButton yapiwrapper declaration)
//--- (YAnButton public methods declaration)
/**
 * Returns the current calibrated input value (between 0 and 1000, included).
 *
 * @return an integer corresponding to the current calibrated input value (between 0 and 1000, included)
 *
 * On failure, throws an exception or returns YAnButton.CALIBRATEDVALUE_INVALID.
 */
-(int)     get_calibratedValue;


-(int) calibratedValue;
/**
 * Returns the current measured input value as-is (between 0 and 4095, included).
 *
 * @return an integer corresponding to the current measured input value as-is (between 0 and 4095, included)
 *
 * On failure, throws an exception or returns YAnButton.RAWVALUE_INVALID.
 */
-(int)     get_rawValue;


-(int) rawValue;
/**
 * Tells if a calibration process is currently ongoing.
 *
 * @return either YAnButton.ANALOGCALIBRATION_OFF or YAnButton.ANALOGCALIBRATION_ON
 *
 * On failure, throws an exception or returns YAnButton.ANALOGCALIBRATION_INVALID.
 */
-(Y_ANALOGCALIBRATION_enum)     get_analogCalibration;


-(Y_ANALOGCALIBRATION_enum) analogCalibration;
/**
 * Starts or stops the calibration process. Remember to call the saveToFlash()
 * method of the module at the end of the calibration if the modification must be kept.
 *
 * @param newval : either YAnButton.ANALOGCALIBRATION_OFF or YAnButton.ANALOGCALIBRATION_ON
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_analogCalibration:(Y_ANALOGCALIBRATION_enum) newval;
-(int)     setAnalogCalibration:(Y_ANALOGCALIBRATION_enum) newval;

/**
 * Returns the maximal value measured during the calibration (between 0 and 4095, included).
 *
 * @return an integer corresponding to the maximal value measured during the calibration (between 0
 * and 4095, included)
 *
 * On failure, throws an exception or returns YAnButton.CALIBRATIONMAX_INVALID.
 */
-(int)     get_calibrationMax;


-(int) calibrationMax;
/**
 * Changes the maximal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the maximal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_calibrationMax:(int) newval;
-(int)     setCalibrationMax:(int) newval;

/**
 * Returns the minimal value measured during the calibration (between 0 and 4095, included).
 *
 * @return an integer corresponding to the minimal value measured during the calibration (between 0
 * and 4095, included)
 *
 * On failure, throws an exception or returns YAnButton.CALIBRATIONMIN_INVALID.
 */
-(int)     get_calibrationMin;


-(int) calibrationMin;
/**
 * Changes the minimal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the minimal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_calibrationMin:(int) newval;
-(int)     setCalibrationMin:(int) newval;

/**
 * Returns the sensibility for the input (between 1 and 1000) for triggering user callbacks.
 *
 * @return an integer corresponding to the sensibility for the input (between 1 and 1000) for
 * triggering user callbacks
 *
 * On failure, throws an exception or returns YAnButton.SENSITIVITY_INVALID.
 */
-(int)     get_sensitivity;


-(int) sensitivity;
/**
 * Changes the sensibility for the input (between 1 and 1000) for triggering user callbacks.
 * The sensibility is used to filter variations around a fixed value, but does not preclude the
 * transmission of events when the input value evolves constantly in the same direction.
 * Special case: when the value 1000 is used, the callback will only be thrown when the logical state
 * of the input switches from pressed to released and back.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the sensibility for the input (between 1 and 1000) for
 * triggering user callbacks
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_sensitivity:(int) newval;
-(int)     setSensitivity:(int) newval;

/**
 * Returns true if the input (considered as binary) is active (closed contact), and false otherwise.
 *
 * @return either YAnButton.ISPRESSED_FALSE or YAnButton.ISPRESSED_TRUE, according to true if the
 * input (considered as binary) is active (closed contact), and false otherwise
 *
 * On failure, throws an exception or returns YAnButton.ISPRESSED_INVALID.
 */
-(Y_ISPRESSED_enum)     get_isPressed;


-(Y_ISPRESSED_enum) isPressed;
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was pressed (the input contact transitioned from open to closed).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was pressed (the input contact transitioned from open to closed)
 *
 * On failure, throws an exception or returns YAnButton.LASTTIMEPRESSED_INVALID.
 */
-(s64)     get_lastTimePressed;


-(s64) lastTimePressed;
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was released (the input contact transitioned from closed to open).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was released (the input contact transitioned from closed to open)
 *
 * On failure, throws an exception or returns YAnButton.LASTTIMERELEASED_INVALID.
 */
-(s64)     get_lastTimeReleased;


-(s64) lastTimeReleased;
/**
 * Returns the pulse counter value. The value is a 32 bit integer. In case
 * of overflow (>=2^32), the counter will wrap. To reset the counter, just
 * call the resetCounter() method.
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns YAnButton.PULSECOUNTER_INVALID.
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
 * On failure, throws an exception or returns YAnButton.PULSETIMER_INVALID.
 */
-(s64)     get_pulseTimer;


-(s64) pulseTimer;
/**
 * Returns the decoding method applied to the input (analog or multiplexed binary switches).
 *
 * @return a value among YAnButton.INPUTTYPE_ANALOG_FAST, YAnButton.INPUTTYPE_DIGITAL4,
 * YAnButton.INPUTTYPE_ANALOG_SMOOTH and YAnButton.INPUTTYPE_DIGITAL_FAST corresponding to the
 * decoding method applied to the input (analog or multiplexed binary switches)
 *
 * On failure, throws an exception or returns YAnButton.INPUTTYPE_INVALID.
 */
-(Y_INPUTTYPE_enum)     get_inputType;


-(Y_INPUTTYPE_enum) inputType;
/**
 * Changes the decoding method applied to the input (analog or multiplexed binary switches).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YAnButton.INPUTTYPE_ANALOG_FAST, YAnButton.INPUTTYPE_DIGITAL4,
 * YAnButton.INPUTTYPE_ANALOG_SMOOTH and YAnButton.INPUTTYPE_DIGITAL_FAST corresponding to the
 * decoding method applied to the input (analog or multiplexed binary switches)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_inputType:(Y_INPUTTYPE_enum) newval;
-(int)     setInputType:(Y_INPUTTYPE_enum) newval;

/**
 * Retrieves an analog input for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the analog input is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAnButton.isOnline() to test if the analog input is
 * indeed online at a given time. In case of ambiguity when looking for
 * an analog input by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the analog input, for instance
 *         YBUZZER2.anButton1.
 *
 * @return a YAnButton object allowing you to drive the analog input.
 */
+(YAnButton*)     FindAnButton:(NSString*)func;

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
-(int)     registerValueCallback:(YAnButtonValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetCounter;


/**
 * Continues the enumeration of analog inputs started using yFirstAnButton().
 * Caution: You can't make any assumption about the returned analog inputs order.
 * If you want to find a specific an analog input, use AnButton.findAnButton()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YAnButton object, corresponding to
 *         an analog input currently online, or a nil pointer
 *         if there are no more analog inputs to enumerate.
 */
-(nullable YAnButton*) nextAnButton
NS_SWIFT_NAME(nextAnButton());
/**
 * Starts the enumeration of analog inputs currently accessible.
 * Use the method YAnButton.nextAnButton() to iterate on
 * next analog inputs.
 *
 * @return a pointer to a YAnButton object, corresponding to
 *         the first analog input currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YAnButton*) FirstAnButton
NS_SWIFT_NAME(FirstAnButton());
//--- (end of YAnButton public methods declaration)

@end

//--- (YAnButton functions declaration)
/**
 * Retrieves an analog input for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the analog input is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAnButton.isOnline() to test if the analog input is
 * indeed online at a given time. In case of ambiguity when looking for
 * an analog input by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the analog input, for instance
 *         YBUZZER2.anButton1.
 *
 * @return a YAnButton object allowing you to drive the analog input.
 */
YAnButton* yFindAnButton(NSString* func);
/**
 * Starts the enumeration of analog inputs currently accessible.
 * Use the method YAnButton.nextAnButton() to iterate on
 * next analog inputs.
 *
 * @return a pointer to a YAnButton object, corresponding to
 *         the first analog input currently online, or a nil pointer
 *         if there are none.
 */
YAnButton* yFirstAnButton(void);

//--- (end of YAnButton functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

