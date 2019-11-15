/*********************************************************************
 *
 *  $Id: yocto_voltage.h 37827 2019-10-25 13:07:48Z mvuilleu $
 *
 *  Declares yFindVoltage(), the high-level API for Voltage functions
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

@class YVoltage;

//--- (YVoltage globals)
typedef void (*YVoltageValueCallback)(YVoltage *func, NSString *functionValue);
typedef void (*YVoltageTimedReportCallback)(YVoltage *func, YMeasure *measure);
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
//--- (end of YVoltage globals)

//--- (YVoltage class start)
/**
 * YVoltage Class: Voltage function interface
 *
 * The YVoltage class allows you to read and configure Yoctopuce voltage
 * sensors, for instance using a Yocto-Watt, a Yocto-Volt or a Yocto-Motor-DC. It inherits from
 * YSensor class the core functions to read measurements,
 * to register callback functions, to access the autonomous datalogger.
 */
@interface YVoltage : YSensor
//--- (end of YVoltage class start)
{
@protected
//--- (YVoltage attributes declaration)
    Y_ENABLED_enum  _enabled;
    YVoltageValueCallback _valueCallbackVoltage;
    YVoltageTimedReportCallback _timedReportCallbackVoltage;
//--- (end of YVoltage attributes declaration)
}
// Constructor is protected, use yFindVoltage factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YVoltage private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YVoltage private methods declaration)
//--- (YVoltage yapiwrapper declaration)
//--- (end of YVoltage yapiwrapper declaration)
//--- (YVoltage public methods declaration)
/**
 * Returns the activation state of this input.
 *
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the activation state of this input
 *
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Changes the activation state of this voltage input. When AC measurements are disabled,
 * the device will always assume a DC signal, and vice-versa. When both AC and DC measurements
 * are active, the device switches between AC and DC mode based on the relative amplitude
 * of variations compared to the average value.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the activation state of this
 * voltage input
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Retrieves a voltage sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltage.isOnline() to test if the voltage sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage sensor, for instance
 *         YWATTMK1.voltage1.
 *
 * @return a YVoltage object allowing you to drive the voltage sensor.
 */
+(YVoltage*)     FindVoltage:(NSString*)func;

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
-(int)     registerValueCallback:(YVoltageValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YVoltageTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of voltage sensors started using yFirstVoltage().
 * Caution: You can't make any assumption about the returned voltage sensors order.
 * If you want to find a specific a voltage sensor, use Voltage.findVoltage()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YVoltage object, corresponding to
 *         a voltage sensor currently online, or a nil pointer
 *         if there are no more voltage sensors to enumerate.
 */
-(YVoltage*) nextVoltage;
/**
 * Starts the enumeration of voltage sensors currently accessible.
 * Use the method YVoltage.nextVoltage() to iterate on
 * next voltage sensors.
 *
 * @return a pointer to a YVoltage object, corresponding to
 *         the first voltage sensor currently online, or a nil pointer
 *         if there are none.
 */
+(YVoltage*) FirstVoltage;
//--- (end of YVoltage public methods declaration)

@end

//--- (YVoltage functions declaration)
/**
 * Retrieves a voltage sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltage.isOnline() to test if the voltage sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage sensor, for instance
 *         YWATTMK1.voltage1.
 *
 * @return a YVoltage object allowing you to drive the voltage sensor.
 */
YVoltage* yFindVoltage(NSString* func);
/**
 * Starts the enumeration of voltage sensors currently accessible.
 * Use the method YVoltage.nextVoltage() to iterate on
 * next voltage sensors.
 *
 * @return a pointer to a YVoltage object, corresponding to
 *         the first voltage sensor currently online, or a nil pointer
 *         if there are none.
 */
YVoltage* yFirstVoltage(void);

//--- (end of YVoltage functions declaration)
CF_EXTERN_C_END

