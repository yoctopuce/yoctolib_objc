/*********************************************************************
 *
 * $Id: yocto_poweroutput.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindPowerOutput(), the high-level API for PowerOutput functions
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

@class YPowerOutput;

//--- (YPowerOutput globals)
typedef void (*YPowerOutputValueCallback)(YPowerOutput *func, NSString *functionValue);
#ifndef _Y_VOLTAGE_ENUM
#define _Y_VOLTAGE_ENUM
typedef enum {
    Y_VOLTAGE_OFF = 0,
    Y_VOLTAGE_OUT3V3 = 1,
    Y_VOLTAGE_OUT5V = 2,
    Y_VOLTAGE_INVALID = -1,
} Y_VOLTAGE_enum;
#endif
//--- (end of YPowerOutput globals)

//--- (YPowerOutput class start)
/**
 * YPowerOutput Class: External power supply control interface
 *
 * Yoctopuce application programming interface allows you to control
 * the power ouput featured on some devices such as the Yocto-Serial.
 */
@interface YPowerOutput : YFunction
//--- (end of YPowerOutput class start)
{
@protected
//--- (YPowerOutput attributes declaration)
    Y_VOLTAGE_enum  _voltage;
    YPowerOutputValueCallback _valueCallbackPowerOutput;
//--- (end of YPowerOutput attributes declaration)
}
// Constructor is protected, use yFindPowerOutput factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPowerOutput private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPowerOutput private methods declaration)
//--- (YPowerOutput public methods declaration)
/**
 * Returns the voltage on the power ouput featured by
 * the module.
 *
 * @return a value among Y_VOLTAGE_OFF, Y_VOLTAGE_OUT3V3 and Y_VOLTAGE_OUT5V corresponding to the
 * voltage on the power ouput featured by
 *         the module
 *
 * On failure, throws an exception or returns Y_VOLTAGE_INVALID.
 */
-(Y_VOLTAGE_enum)     get_voltage;


-(Y_VOLTAGE_enum) voltage;
/**
 * Changes the voltage on the power output provided by the
 * module. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_VOLTAGE_OFF, Y_VOLTAGE_OUT3V3 and Y_VOLTAGE_OUT5V corresponding to
 * the voltage on the power output provided by the
 *         module
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltage:(Y_VOLTAGE_enum) newval;
-(int)     setVoltage:(Y_VOLTAGE_enum) newval;

/**
 * Retrieves a dual power  ouput control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the power ouput control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerOutput.isOnline() to test if the power ouput control is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power  ouput control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the power ouput control
 *
 * @return a YPowerOutput object allowing you to drive the power ouput control.
 */
+(YPowerOutput*)     FindPowerOutput:(NSString*)func;

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
-(int)     registerValueCallback:(YPowerOutputValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of dual power ouput controls started using yFirstPowerOutput().
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         a dual power  ouput control currently online, or a null pointer
 *         if there are no more dual power ouput controls to enumerate.
 */
-(YPowerOutput*) nextPowerOutput;
/**
 * Starts the enumeration of dual power ouput controls currently accessible.
 * Use the method YPowerOutput.nextPowerOutput() to iterate on
 * next dual power ouput controls.
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         the first dual power ouput control currently online, or a null pointer
 *         if there are none.
 */
+(YPowerOutput*) FirstPowerOutput;
//--- (end of YPowerOutput public methods declaration)

@end

//--- (PowerOutput functions declaration)
/**
 * Retrieves a dual power  ouput control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the power ouput control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerOutput.isOnline() to test if the power ouput control is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power  ouput control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the power ouput control
 *
 * @return a YPowerOutput object allowing you to drive the power ouput control.
 */
YPowerOutput* yFindPowerOutput(NSString* func);
/**
 * Starts the enumeration of dual power ouput controls currently accessible.
 * Use the method YPowerOutput.nextPowerOutput() to iterate on
 * next dual power ouput controls.
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         the first dual power ouput control currently online, or a null pointer
 *         if there are none.
 */
YPowerOutput* yFirstPowerOutput(void);

//--- (end of PowerOutput functions declaration)
CF_EXTERN_C_END

