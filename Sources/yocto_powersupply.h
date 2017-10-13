/*********************************************************************
 *
 * $Id: yocto_powersupply.h 28752 2017-10-03 08:41:02Z seb $
 *
 * Declares yFindPowerSupply(), the high-level API for PowerSupply functions
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
#ifndef _Y_VOLTAGESENSE_ENUM
#define _Y_VOLTAGESENSE_ENUM
typedef enum {
    Y_VOLTAGESENSE_INT = 0,
    Y_VOLTAGESENSE_EXT = 1,
    Y_VOLTAGESENSE_INVALID = -1,
} Y_VOLTAGESENSE_enum;
#endif
#define Y_VOLTAGESETPOINT_INVALID       YAPI_INVALID_DOUBLE
#define Y_CURRENTLIMIT_INVALID          YAPI_INVALID_DOUBLE
#define Y_MEASUREDVOLTAGE_INVALID       YAPI_INVALID_DOUBLE
#define Y_MEASUREDCURRENT_INVALID       YAPI_INVALID_DOUBLE
#define Y_INPUTVOLTAGE_INVALID          YAPI_INVALID_DOUBLE
#define Y_VINT_INVALID                  YAPI_INVALID_DOUBLE
#define Y_LDOTEMPERATURE_INVALID        YAPI_INVALID_DOUBLE
#define Y_VOLTAGETRANSITION_INVALID     YAPI_INVALID_STRING
#define Y_VOLTAGEATSTARTUP_INVALID      YAPI_INVALID_DOUBLE
#define Y_CURRENTATSTARTUP_INVALID      YAPI_INVALID_DOUBLE
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YPowerSupply globals)

//--- (YPowerSupply class start)
/**
 * YPowerSupply Class: PowerSupply function interface
 *
 * The Yoctopuce application programming interface allows you to change the voltage set point,
 * the current limit and the enable/disable the output.
 */
@interface YPowerSupply : YFunction
//--- (end of YPowerSupply class start)
{
@protected
//--- (YPowerSupply attributes declaration)
    double          _voltageSetPoint;
    double          _currentLimit;
    Y_POWEROUTPUT_enum _powerOutput;
    Y_VOLTAGESENSE_enum _voltageSense;
    double          _measuredVoltage;
    double          _measuredCurrent;
    double          _inputVoltage;
    double          _vInt;
    double          _ldoTemperature;
    NSString*       _voltageTransition;
    double          _voltageAtStartUp;
    double          _currentAtStartUp;
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
//--- (YPowerSupply public methods declaration)
/**
 * Changes the voltage set point, in V.
 *
 * @param newval : a floating point number corresponding to the voltage set point, in V
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageSetPoint:(double) newval;
-(int)     setVoltageSetPoint:(double) newval;

/**
 * Returns the voltage set point, in V.
 *
 * @return a floating point number corresponding to the voltage set point, in V
 *
 * On failure, throws an exception or returns Y_VOLTAGESETPOINT_INVALID.
 */
-(double)     get_voltageSetPoint;


-(double) voltageSetPoint;
/**
 * Changes the current limit, in mA.
 *
 * @param newval : a floating point number corresponding to the current limit, in mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_CURRENTLIMIT_INVALID.
 */
-(double)     get_currentLimit;


-(double) currentLimit;
/**
 * Returns the power supply output switch state.
 *
 * @return either Y_POWEROUTPUT_OFF or Y_POWEROUTPUT_ON, according to the power supply output switch state
 *
 * On failure, throws an exception or returns Y_POWEROUTPUT_INVALID.
 */
-(Y_POWEROUTPUT_enum)     get_powerOutput;


-(Y_POWEROUTPUT_enum) powerOutput;
/**
 * Changes the power supply output switch state.
 *
 * @param newval : either Y_POWEROUTPUT_OFF or Y_POWEROUTPUT_ON, according to the power supply output switch state
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerOutput:(Y_POWEROUTPUT_enum) newval;
-(int)     setPowerOutput:(Y_POWEROUTPUT_enum) newval;

/**
 * Returns the output voltage control point.
 *
 * @return either Y_VOLTAGESENSE_INT or Y_VOLTAGESENSE_EXT, according to the output voltage control point
 *
 * On failure, throws an exception or returns Y_VOLTAGESENSE_INVALID.
 */
-(Y_VOLTAGESENSE_enum)     get_voltageSense;


-(Y_VOLTAGESENSE_enum) voltageSense;
/**
 * Changes the voltage control point.
 *
 * @param newval : either Y_VOLTAGESENSE_INT or Y_VOLTAGESENSE_EXT, according to the voltage control point
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageSense:(Y_VOLTAGESENSE_enum) newval;
-(int)     setVoltageSense:(Y_VOLTAGESENSE_enum) newval;

/**
 * Returns the measured output voltage, in V.
 *
 * @return a floating point number corresponding to the measured output voltage, in V
 *
 * On failure, throws an exception or returns Y_MEASUREDVOLTAGE_INVALID.
 */
-(double)     get_measuredVoltage;


-(double) measuredVoltage;
/**
 * Returns the measured output current, in mA.
 *
 * @return a floating point number corresponding to the measured output current, in mA
 *
 * On failure, throws an exception or returns Y_MEASUREDCURRENT_INVALID.
 */
-(double)     get_measuredCurrent;


-(double) measuredCurrent;
/**
 * Returns the measured input voltage, in V.
 *
 * @return a floating point number corresponding to the measured input voltage, in V
 *
 * On failure, throws an exception or returns Y_INPUTVOLTAGE_INVALID.
 */
-(double)     get_inputVoltage;


-(double) inputVoltage;
/**
 * Returns the internal voltage, in V.
 *
 * @return a floating point number corresponding to the internal voltage, in V
 *
 * On failure, throws an exception or returns Y_VINT_INVALID.
 */
-(double)     get_vInt;


-(double) vInt;
/**
 * Returns the LDO temperature, in Celsius.
 *
 * @return a floating point number corresponding to the LDO temperature, in Celsius
 *
 * On failure, throws an exception or returns Y_LDOTEMPERATURE_INVALID.
 */
-(double)     get_ldoTemperature;


-(double) ldoTemperature;
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
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageAtStartUp:(double) newval;
-(int)     setVoltageAtStartUp:(double) newval;

/**
 * Returns the selected voltage set point at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage set point at device startup, in V
 *
 * On failure, throws an exception or returns Y_VOLTAGEATSTARTUP_INVALID.
 */
-(double)     get_voltageAtStartUp;


-(double) voltageAtStartUp;
/**
 * Changes the current limit at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the current limit at device start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentAtStartUp:(double) newval;
-(int)     setCurrentAtStartUp:(double) newval;

/**
 * Returns the selected current limit at device startup, in mA.
 *
 * @return a floating point number corresponding to the selected current limit at device startup, in mA
 *
 * On failure, throws an exception or returns Y_CURRENTATSTARTUP_INVALID.
 */
-(double)     get_currentAtStartUp;


-(double) currentAtStartUp;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a regulated power supply for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
 * @param func : a string that uniquely characterizes the regulated power supply
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
-(int)     registerValueCallback:(YPowerSupplyValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Performs a smooth transistion of output voltage. Any explicit voltage
 * change cancels any ongoing transition process.
 *
 * @param V_target   : new output voltage value at the end of the transition
 *         (floating-point number, representing the end voltage in V)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 */
-(int)     voltageMove:(double)V_target :(int)ms_duration;


/**
 * Continues the enumeration of regulated power supplies started using yFirstPowerSupply().
 *
 * @return a pointer to a YPowerSupply object, corresponding to
 *         a regulated power supply currently online, or a nil pointer
 *         if there are no more regulated power supplies to enumerate.
 */
-(YPowerSupply*) nextPowerSupply;
/**
 * Starts the enumeration of regulated power supplies currently accessible.
 * Use the method YPowerSupply.nextPowerSupply() to iterate on
 * next regulated power supplies.
 *
 * @return a pointer to a YPowerSupply object, corresponding to
 *         the first regulated power supply currently online, or a nil pointer
 *         if there are none.
 */
+(YPowerSupply*) FirstPowerSupply;
//--- (end of YPowerSupply public methods declaration)

@end

//--- (YPowerSupply functions declaration)
/**
 * Retrieves a regulated power supply for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
 * @param func : a string that uniquely characterizes the regulated power supply
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
CF_EXTERN_C_END

