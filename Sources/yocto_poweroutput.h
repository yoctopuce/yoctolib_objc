/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindPowerOutput(), the high-level API for PowerOutput functions
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

@class YPowerOutput;

//--- (YPowerOutput globals)
typedef void (*YPowerOutputValueCallback)(YPowerOutput *func, NSString *functionValue);
#ifndef _Y_VOLTAGE_ENUM
#define _Y_VOLTAGE_ENUM
typedef enum {
    Y_VOLTAGE_OFF = 0,
    Y_VOLTAGE_OUT3V3 = 1,
    Y_VOLTAGE_OUT5V = 2,
    Y_VOLTAGE_OUT4V7 = 3,
    Y_VOLTAGE_OUT1V8 = 4,
    Y_VOLTAGE_INVALID = -1,
} Y_VOLTAGE_enum;
#endif
//--- (end of YPowerOutput globals)

//--- (YPowerOutput class start)
/**
 * YPowerOutput Class: power output control interface, available for instance in the Yocto-I2C, the
 * Yocto-MaxiMicroVolt-Rx, the Yocto-SPI or the Yocto-Serial
 *
 * The YPowerOutput class allows you to control
 * the power output featured on some Yoctopuce devices.
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
//--- (YPowerOutput yapiwrapper declaration)
//--- (end of YPowerOutput yapiwrapper declaration)
//--- (YPowerOutput public methods declaration)
/**
 * Returns the voltage on the power output featured by the module.
 *
 * @return a value among YPowerOutput.VOLTAGE_OFF, YPowerOutput.VOLTAGE_OUT3V3,
 * YPowerOutput.VOLTAGE_OUT5V, YPowerOutput.VOLTAGE_OUT4V7 and YPowerOutput.VOLTAGE_OUT1V8
 * corresponding to the voltage on the power output featured by the module
 *
 * On failure, throws an exception or returns YPowerOutput.VOLTAGE_INVALID.
 */
-(Y_VOLTAGE_enum)     get_voltage;


-(Y_VOLTAGE_enum) voltage;
/**
 * Changes the voltage on the power output provided by the
 * module. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YPowerOutput.VOLTAGE_OFF, YPowerOutput.VOLTAGE_OUT3V3,
 * YPowerOutput.VOLTAGE_OUT5V, YPowerOutput.VOLTAGE_OUT4V7 and YPowerOutput.VOLTAGE_OUT1V8
 * corresponding to the voltage on the power output provided by the
 *         module
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltage:(Y_VOLTAGE_enum) newval;
-(int)     setVoltage:(Y_VOLTAGE_enum) newval;

/**
 * Retrieves a power output for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the power output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerOutput.isOnline() to test if the power output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a power output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the power output, for instance
 *         YI2CMK01.powerOutput.
 *
 * @return a YPowerOutput object allowing you to drive the power output.
 */
+(YPowerOutput*)     FindPowerOutput:(NSString*)func;

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
-(int)     registerValueCallback:(YPowerOutputValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of power output started using yFirstPowerOutput().
 * Caution: You can't make any assumption about the returned power output order.
 * If you want to find a specific a power output, use PowerOutput.findPowerOutput()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         a power output currently online, or a nil pointer
 *         if there are no more power output to enumerate.
 */
-(nullable YPowerOutput*) nextPowerOutput
NS_SWIFT_NAME(nextPowerOutput());
/**
 * Starts the enumeration of power output currently accessible.
 * Use the method YPowerOutput.nextPowerOutput() to iterate on
 * next power output.
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         the first power output currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YPowerOutput*) FirstPowerOutput
NS_SWIFT_NAME(FirstPowerOutput());
//--- (end of YPowerOutput public methods declaration)

@end

//--- (YPowerOutput functions declaration)
/**
 * Retrieves a power output for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the power output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerOutput.isOnline() to test if the power output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a power output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the power output, for instance
 *         YI2CMK01.powerOutput.
 *
 * @return a YPowerOutput object allowing you to drive the power output.
 */
YPowerOutput* yFindPowerOutput(NSString* func);
/**
 * Starts the enumeration of power output currently accessible.
 * Use the method YPowerOutput.nextPowerOutput() to iterate on
 * next power output.
 *
 * @return a pointer to a YPowerOutput object, corresponding to
 *         the first power output currently online, or a nil pointer
 *         if there are none.
 */
YPowerOutput* yFirstPowerOutput(void);

//--- (end of YPowerOutput functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

