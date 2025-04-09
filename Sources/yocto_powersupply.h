/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindPowerSupply(), the high-level API for PowerSupply functions
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

@class YPowerSupply;

//--- (YPowerSupply globals)
typedef void (*YPowerSupplyValueCallback)(YPowerSupply *func, NSString *functionValue);
#ifndef _Y_POWEROUTPUT_ENUM
#define _Y_POWEROUTPUT_ENUM
typedef enum {
    Y_POWEROUTPUT_OFF = 0,
    Y_POWEROUTPUT_ON = 1,
    Y_POWEROUTPUT_INVALID = -1,
} Y_POWEROUTPUT_enum;
#endif
#ifndef _Y_POWEROUTPUTATSTARTUP_ENUM
#define _Y_POWEROUTPUTATSTARTUP_ENUM
typedef enum {
    Y_POWEROUTPUTATSTARTUP_OFF = 0,
    Y_POWEROUTPUTATSTARTUP_ON = 1,
    Y_POWEROUTPUTATSTARTUP_INVALID = -1,
} Y_POWEROUTPUTATSTARTUP_enum;
#endif
#define Y_VOLTAGELIMIT_INVALID          YAPI_INVALID_DOUBLE
#define Y_CURRENTLIMIT_INVALID          YAPI_INVALID_DOUBLE
#define Y_MEASUREDVOLTAGE_INVALID       YAPI_INVALID_DOUBLE
#define Y_MEASUREDCURRENT_INVALID       YAPI_INVALID_DOUBLE
#define Y_INPUTVOLTAGE_INVALID          YAPI_INVALID_DOUBLE
#define Y_VOLTAGETRANSITION_INVALID     YAPI_INVALID_STRING
#define Y_VOLTAGELIMITATSTARTUP_INVALID YAPI_INVALID_DOUBLE
#define Y_CURRENTLIMITATSTARTUP_INVALID YAPI_INVALID_DOUBLE
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YPowerSupply globals)

//--- (YPowerSupply class start)
/**
 * YPowerSupply Class: regulated power supply control interface
 *
 * The YPowerSupply class allows you to drive a Yoctopuce power supply.
 * It can be use to change the voltage and current limits, and to enable/disable
 * the output.
 */
@interface YPowerSupply : YFunction
//--- (end of YPowerSupply class start)
{
@protected
//--- (YPowerSupply attributes declaration)
    double          _voltageLimit;
    double          _currentLimit;
    Y_POWEROUTPUT_enum _powerOutput;
    double          _measuredVoltage;
    double          _measuredCurrent;
    double          _inputVoltage;
    NSString*       _voltageTransition;
    double          _voltageLimitAtStartUp;
    double          _currentLimitAtStartUp;
    Y_POWEROUTPUTATSTARTUP_enum _powerOutputAtStartUp;
    NSString*       _command;
    YPowerSupplyValueCallback _valueCallbackPowerSupply;
//--- (end of YPowerSupply attributes declaration)
}
// Constructor is protected, use yFindPowerSupply factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPowerSupply private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPowerSupply private methods declaration)
//--- (YPowerSupply yapiwrapper declaration)
//--- (end of YPowerSupply yapiwrapper declaration)
//--- (YPowerSupply public methods declaration)
/**
 * Changes the voltage limit, in V.
 *
 * @param newval : a floating point number corresponding to the voltage limit, in V
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageLimit:(double) newval;
-(int)     setVoltageLimit:(double) newval;

/**
 * Returns the voltage limit, in V.
 *
 * @return a floating point number corresponding to the voltage limit, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGELIMIT_INVALID.
 */
-(double)     get_voltageLimit;


-(double) voltageLimit;
/**
 * Changes the current limit, in mA.
 *
 * @param newval : a floating point number corresponding to the current limit, in mA
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentLimit:(double) newval;
-(int)     setCurrentLimit:(double) newval;

/**
 * Returns the current limit, in mA.
 *
 * @return a floating point number corresponding to the current limit, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.CURRENTLIMIT_INVALID.
 */
-(double)     get_currentLimit;


-(double) currentLimit;
/**
 * Returns the power supply output switch state.
 *
 * @return either YPowerSupply.POWEROUTPUT_OFF or YPowerSupply.POWEROUTPUT_ON, according to the power
 * supply output switch state
 *
 * On failure, throws an exception or returns YPowerSupply.POWEROUTPUT_INVALID.
 */
-(Y_POWEROUTPUT_enum)     get_powerOutput;


-(Y_POWEROUTPUT_enum) powerOutput;
/**
 * Changes the power supply output switch state.
 *
 * @param newval : either YPowerSupply.POWEROUTPUT_OFF or YPowerSupply.POWEROUTPUT_ON, according to
 * the power supply output switch state
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerOutput:(Y_POWEROUTPUT_enum) newval;
-(int)     setPowerOutput:(Y_POWEROUTPUT_enum) newval;

/**
 * Returns the measured output voltage, in V.
 *
 * @return a floating point number corresponding to the measured output voltage, in V
 *
 * On failure, throws an exception or returns YPowerSupply.MEASUREDVOLTAGE_INVALID.
 */
-(double)     get_measuredVoltage;


-(double) measuredVoltage;
/**
 * Returns the measured output current, in mA.
 *
 * @return a floating point number corresponding to the measured output current, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.MEASUREDCURRENT_INVALID.
 */
-(double)     get_measuredCurrent;


-(double) measuredCurrent;
/**
 * Returns the measured input voltage, in V.
 *
 * @return a floating point number corresponding to the measured input voltage, in V
 *
 * On failure, throws an exception or returns YPowerSupply.INPUTVOLTAGE_INVALID.
 */
-(double)     get_inputVoltage;


-(double) inputVoltage;
-(NSString*)     get_voltageTransition;


-(NSString*) voltageTransition;
-(int)     set_voltageTransition:(NSString*) newval;
-(int)     setVoltageTransition:(NSString*) newval;

/**
 * Changes the voltage set point at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the voltage set point at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageLimitAtStartUp:(double) newval;
-(int)     setVoltageLimitAtStartUp:(double) newval;

/**
 * Returns the selected voltage limit at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage limit at device startup, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGELIMITATSTARTUP_INVALID.
 */
-(double)     get_voltageLimitAtStartUp;


-(double) voltageLimitAtStartUp;
/**
 * Changes the current limit at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the current limit at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentLimitAtStartUp:(double) newval;
-(int)     setCurrentLimitAtStartUp:(double) newval;

/**
 * Returns the selected current limit at device startup, in mA.
 *
 * @return a floating point number corresponding to the selected current limit at device startup, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.CURRENTLIMITATSTARTUP_INVALID.
 */
-(double)     get_currentLimitAtStartUp;


-(double) currentLimitAtStartUp;
/**
 * Returns the power supply output switch state.
 *
 * @return either YPowerSupply.POWEROUTPUTATSTARTUP_OFF or YPowerSupply.POWEROUTPUTATSTARTUP_ON,
 * according to the power supply output switch state
 *
 * On failure, throws an exception or returns YPowerSupply.POWEROUTPUTATSTARTUP_INVALID.
 */
-(Y_POWEROUTPUTATSTARTUP_enum)     get_powerOutputAtStartUp;


-(Y_POWEROUTPUTATSTARTUP_enum) powerOutputAtStartUp;
/**
 * Changes the power supply output switch state at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : either YPowerSupply.POWEROUTPUTATSTARTUP_OFF or
 * YPowerSupply.POWEROUTPUTATSTARTUP_ON, according to the power supply output switch state at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerOutputAtStartUp:(Y_POWEROUTPUTATSTARTUP_enum) newval;
-(int)     setPowerOutputAtStartUp:(Y_POWEROUTPUTATSTARTUP_enum) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a regulated power supply for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the regulated power supply is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerSupply.isOnline() to test if the regulated power supply is
 * indeed online at a given time. In case of ambiguity when looking for
 * a regulated power supply by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the regulated power supply, for instance
 *         MyDevice.powerSupply.
 *
 * @return a YPowerSupply object allowing you to drive the regulated power supply.
 */
+(YPowerSupply*)     FindPowerSupply:(NSString*)func;

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
-(int)     registerValueCallback:(YPowerSupplyValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Performs a smooth transition of output voltage. Any explicit voltage
 * change cancels any ongoing transition process.
 *
 * @param V_target   : new output voltage value at the end of the transition
 *         (floating-point number, representing the end voltage in V)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI.SUCCESS when the call succeeds.
 */
-(int)     voltageMove:(double)V_target :(int)ms_duration;


/**
 * Continues the enumeration of regulated power supplies started using yFirstPowerSupply().
 * Caution: You can't make any assumption about the returned regulated power supplies order.
 * If you want to find a specific a regulated power supply, use PowerSupply.findPowerSupply()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YPowerSupply object, corresponding to
 *         a regulated power supply currently online, or a nil pointer
 *         if there are no more regulated power supplies to enumerate.
 */
-(nullable YPowerSupply*) nextPowerSupply
NS_SWIFT_NAME(nextPowerSupply());
/**
 * Starts the enumeration of regulated power supplies currently accessible.
 * Use the method YPowerSupply.nextPowerSupply() to iterate on
 * next regulated power supplies.
 *
 * @return a pointer to a YPowerSupply object, corresponding to
 *         the first regulated power supply currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YPowerSupply*) FirstPowerSupply
NS_SWIFT_NAME(FirstPowerSupply());
//--- (end of YPowerSupply public methods declaration)

@end

//--- (YPowerSupply functions declaration)
/**
 * Retrieves a regulated power supply for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the regulated power supply is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerSupply.isOnline() to test if the regulated power supply is
 * indeed online at a given time. In case of ambiguity when looking for
 * a regulated power supply by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the regulated power supply, for instance
 *         MyDevice.powerSupply.
 *
 * @return a YPowerSupply object allowing you to drive the regulated power supply.
 */
YPowerSupply* yFindPowerSupply(NSString* func);
/**
 * Starts the enumeration of regulated power supplies currently accessible.
 * Use the method YPowerSupply.nextPowerSupply() to iterate on
 * next regulated power supplies.
 *
 * @return a pointer to a YPowerSupply object, corresponding to
 *         the first regulated power supply currently online, or a nil pointer
 *         if there are none.
 */
YPowerSupply* yFirstPowerSupply(void);

//--- (end of YPowerSupply functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

