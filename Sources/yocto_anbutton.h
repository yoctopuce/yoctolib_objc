/*********************************************************************
 *
 * $Id: yocto_anbutton.h 9945 2013-02-20 21:46:06Z seb $
 *
 * Declares yFindAnButton(), the high-level API for AnButton functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

//--- (YAnButton definitions)
typedef enum {
    Y_ANALOGCALIBRATION_OFF = 0,
    Y_ANALOGCALIBRATION_ON = 1,
    Y_ANALOGCALIBRATION_INVALID = -1
} Y_ANALOGCALIBRATION_enum;

typedef enum {
    Y_ISPRESSED_FALSE = 0,
    Y_ISPRESSED_TRUE = 1,
    Y_ISPRESSED_INVALID = -1
} Y_ISPRESSED_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_CALIBRATEDVALUE_INVALID       (0xffffffff)
#define Y_RAWVALUE_INVALID              (0xffffffff)
#define Y_CALIBRATIONMAX_INVALID        (0xffffffff)
#define Y_CALIBRATIONMIN_INVALID        (0xffffffff)
#define Y_SENSITIVITY_INVALID           (0xffffffff)
#define Y_LASTTIMEPRESSED_INVALID       (0xffffffff)
#define Y_LASTTIMERELEASED_INVALID      (0xffffffff)
#define Y_PULSECOUNTER_INVALID          (0xffffffff)
#define Y_PULSETIMER_INVALID            (0xffffffff)
//--- (end of YAnButton definitions)

/**
 * YAnButton Class: AnButton function interface
 * 
 * Yoctopuce application programming interface allows you to measure the state
 * of a simple button as well as to read an analog potentiometer (variable resistance).
 * This can be use for instance with a continuous rotating knob, a throttle grip
 * or a joystick. The module is capable to calibrate itself on min and max values,
 * in order to compute a calibrated value that varies proportionally with the
 * potentiometer position, regardless of its total resistance.
 */
@interface YAnButton : YFunction
{
@protected

// Attributes (function value cache)
//--- (YAnButton attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    unsigned        _calibratedValue;
    unsigned        _rawValue;
    Y_ANALOGCALIBRATION_enum _analogCalibration;
    unsigned        _calibrationMax;
    unsigned        _calibrationMin;
    unsigned        _sensitivity;
    Y_ISPRESSED_enum _isPressed;
    unsigned        _lastTimePressed;
    unsigned        _lastTimeReleased;
    unsigned        _pulseCounter;
    unsigned        _pulseTimer;
//--- (end of YAnButton attributes)
}
//--- (YAnButton declaration)
// Constructor is protected, use yFindAnButton factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

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
-(void)     registerValueCallback:(YFunctionUpdateCallback) callback;   
/**
 * comment from .yc definition
 */
-(void)     set_objectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object withSelector:(SEL)selector;

//--- (end of YAnButton declaration)
//--- (YAnButton accessors declaration)

/**
 * Continues the enumeration of analog inputs started using yFirstAnButton().
 * 
 * @return a pointer to a YAnButton object, corresponding to
 *         an analog input currently online, or a null pointer
 *         if there are no more analog inputs to enumerate.
 */
-(YAnButton*) nextAnButton;
/**
 * Retrieves an analog input for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the analog input is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAnButton.isOnline() to test if the analog input is
 * indeed online at a given time. In case of ambiguity when looking for
 * an analog input by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the analog input
 * 
 * @return a YAnButton object allowing you to drive the analog input.
 */
+(YAnButton*) FindAnButton:(NSString*) func;
/**
 * Starts the enumeration of analog inputs currently accessible.
 * Use the method YAnButton.nextAnButton() to iterate on
 * next analog inputs.
 * 
 * @return a pointer to a YAnButton object, corresponding to
 *         the first analog input currently online, or a null pointer
 *         if there are none.
 */
+(YAnButton*) FirstAnButton;

/**
 * Returns the logical name of the analog input.
 * 
 * @return a string corresponding to the logical name of the analog input
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the analog input. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the analog input
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the analog input (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the analog input (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the current calibrated input value (between 0 and 1000, included).
 * 
 * @return an integer corresponding to the current calibrated input value (between 0 and 1000, included)
 * 
 * On failure, throws an exception or returns Y_CALIBRATEDVALUE_INVALID.
 */
-(unsigned) get_calibratedValue;
-(unsigned) calibratedValue;

/**
 * Returns the current measured input value as-is (between 0 and 4095, included).
 * 
 * @return an integer corresponding to the current measured input value as-is (between 0 and 4095, included)
 * 
 * On failure, throws an exception or returns Y_RAWVALUE_INVALID.
 */
-(unsigned) get_rawValue;
-(unsigned) rawValue;

/**
 * Tells if a calibration process is currently ongoing.
 * 
 * @return either Y_ANALOGCALIBRATION_OFF or Y_ANALOGCALIBRATION_ON
 * 
 * On failure, throws an exception or returns Y_ANALOGCALIBRATION_INVALID.
 */
-(Y_ANALOGCALIBRATION_enum) get_analogCalibration;
-(Y_ANALOGCALIBRATION_enum) analogCalibration;

/**
 * Starts or stops the calibration process. Remember to call the saveToFlash()
 * method of the module at the end of the calibration if the modification must be kept.
 * 
 * @param newval : either Y_ANALOGCALIBRATION_OFF or Y_ANALOGCALIBRATION_ON
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_CALIBRATIONMAX_INVALID.
 */
-(unsigned) get_calibrationMax;
-(unsigned) calibrationMax;

/**
 * Changes the maximal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 * 
 * @param newval : an integer corresponding to the maximal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_calibrationMax:(unsigned) newval;
-(int)     setCalibrationMax:(unsigned) newval;

/**
 * Returns the minimal value measured during the calibration (between 0 and 4095, included).
 * 
 * @return an integer corresponding to the minimal value measured during the calibration (between 0
 * and 4095, included)
 * 
 * On failure, throws an exception or returns Y_CALIBRATIONMIN_INVALID.
 */
-(unsigned) get_calibrationMin;
-(unsigned) calibrationMin;

/**
 * Changes the minimal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 * 
 * @param newval : an integer corresponding to the minimal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_calibrationMin:(unsigned) newval;
-(int)     setCalibrationMin:(unsigned) newval;

/**
 * Returns the sensibility for the input (between 1 and 255, included) for triggering user callbacks.
 * 
 * @return an integer corresponding to the sensibility for the input (between 1 and 255, included) for
 * triggering user callbacks
 * 
 * On failure, throws an exception or returns Y_SENSITIVITY_INVALID.
 */
-(unsigned) get_sensitivity;
-(unsigned) sensitivity;

/**
 * Changes the sensibility for the input (between 1 and 255, included) for triggering user callbacks.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * 
 * @param newval : an integer corresponding to the sensibility for the input (between 1 and 255,
 * included) for triggering user callbacks
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_sensitivity:(unsigned) newval;
-(int)     setSensitivity:(unsigned) newval;

/**
 * Returns true if the input (considered as binary) is active (closed contact), and false otherwise.
 * 
 * @return either Y_ISPRESSED_FALSE or Y_ISPRESSED_TRUE, according to true if the input (considered as
 * binary) is active (closed contact), and false otherwise
 * 
 * On failure, throws an exception or returns Y_ISPRESSED_INVALID.
 */
-(Y_ISPRESSED_enum) get_isPressed;
-(Y_ISPRESSED_enum) isPressed;

/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was pressed (the input contact transitionned from open to closed).
 * 
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was pressed (the input contact transitionned from open to closed)
 * 
 * On failure, throws an exception or returns Y_LASTTIMEPRESSED_INVALID.
 */
-(unsigned) get_lastTimePressed;
-(unsigned) lastTimePressed;

/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was released (the input contact transitionned from closed to open).
 * 
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was released (the input contact transitionned from closed to open)
 * 
 * On failure, throws an exception or returns Y_LASTTIMERELEASED_INVALID.
 */
-(unsigned) get_lastTimeReleased;
-(unsigned) lastTimeReleased;

/**
 * Returns the pulse counter value
 * 
 * @return an integer corresponding to the pulse counter value
 * 
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(unsigned) get_pulseCounter;
-(unsigned) pulseCounter;

-(int)     set_pulseCounter:(unsigned) newval;
-(int)     setPulseCounter:(unsigned) newval;

/**
 * Returns the pulse counter value as well as his timer
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetCounter;

/**
 * Returns the timer of the pulses counter (ms)
 * 
 * @return an integer corresponding to the timer of the pulses counter (ms)
 * 
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(unsigned) get_pulseTimer;
-(unsigned) pulseTimer;


//--- (end of YAnButton accessors declaration)
@end

//--- (AnButton functions declaration)

/**
 * Retrieves an analog input for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the analog input is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAnButton.isOnline() to test if the analog input is
 * indeed online at a given time. In case of ambiguity when looking for
 * an analog input by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the analog input
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
 *         the first analog input currently online, or a null pointer
 *         if there are none.
 */
YAnButton* yFirstAnButton(void);

//--- (end of AnButton functions declaration)
CF_EXTERN_C_END

