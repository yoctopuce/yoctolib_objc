/*********************************************************************
 *
 * $Id: yocto_temperature.h 16543 2014-06-13 12:15:09Z mvuilleu $
 *
 * Declares yFindTemperature(), the high-level API for Temperature functions
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

@class YTemperature;

//--- (YTemperature globals)
typedef void (*YTemperatureValueCallback)(YTemperature *func, NSString *functionValue);
typedef void (*YTemperatureTimedReportCallback)(YTemperature *func, YMeasure *measure);
#ifndef _Y_SENSORTYPE_ENUM
#define _Y_SENSORTYPE_ENUM
typedef enum {
    Y_SENSORTYPE_DIGITAL = 0,
    Y_SENSORTYPE_TYPE_K = 1,
    Y_SENSORTYPE_TYPE_E = 2,
    Y_SENSORTYPE_TYPE_J = 3,
    Y_SENSORTYPE_TYPE_N = 4,
    Y_SENSORTYPE_TYPE_R = 5,
    Y_SENSORTYPE_TYPE_S = 6,
    Y_SENSORTYPE_TYPE_T = 7,
    Y_SENSORTYPE_PT100_4WIRES = 8,
    Y_SENSORTYPE_PT100_3WIRES = 9,
    Y_SENSORTYPE_PT100_2WIRES = 10,
    Y_SENSORTYPE_INVALID = -1,
} Y_SENSORTYPE_enum;
#endif

//--- (end of YTemperature globals)

//--- (YTemperature class start)
/**
 * YTemperature Class: Temperature function interface
 * 
 * The Yoctopuce application programming interface allows you to read an instant
 * measure of the sensor, as well as the minimal and maximal values observed.
 */
@interface YTemperature : YSensor
//--- (end of YTemperature class start)
{
@protected
//--- (YTemperature attributes declaration)
    Y_SENSORTYPE_enum _sensorType;
    YTemperatureValueCallback _valueCallbackTemperature;
    YTemperatureTimedReportCallback _timedReportCallbackTemperature;
//--- (end of YTemperature attributes declaration)
}
// Constructor is protected, use yFindTemperature factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YTemperature private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YTemperature private methods declaration)
//--- (YTemperature public methods declaration)
/**
 * Returns the temperature sensor type.
 * 
 * @return a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES and
 * Y_SENSORTYPE_PT100_2WIRES corresponding to the temperature sensor type
 * 
 * On failure, throws an exception or returns Y_SENSORTYPE_INVALID.
 */
-(Y_SENSORTYPE_enum)     get_sensorType;


-(Y_SENSORTYPE_enum) sensorType;
/**
 * Modify the temperature sensor type.  This function is used to
 * to define the type of thermocouple (K,E...) used with the device.
 * This will have no effect if module is using a digital sensor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES and Y_SENSORTYPE_PT100_2WIRES
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_sensorType:(Y_SENSORTYPE_enum) newval;
-(int)     setSensorType:(Y_SENSORTYPE_enum) newval;

/**
 * Retrieves a temperature sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the temperature sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTemperature.isOnline() to test if the temperature sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a temperature sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the temperature sensor
 * 
 * @return a YTemperature object allowing you to drive the temperature sensor.
 */
+(YTemperature*)     FindTemperature:(NSString*)func;

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
-(int)     registerValueCallback:(YTemperatureValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YTemperatureTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of temperature sensors started using yFirstTemperature().
 * 
 * @return a pointer to a YTemperature object, corresponding to
 *         a temperature sensor currently online, or a null pointer
 *         if there are no more temperature sensors to enumerate.
 */
-(YTemperature*) nextTemperature;
/**
 * Starts the enumeration of temperature sensors currently accessible.
 * Use the method YTemperature.nextTemperature() to iterate on
 * next temperature sensors.
 * 
 * @return a pointer to a YTemperature object, corresponding to
 *         the first temperature sensor currently online, or a null pointer
 *         if there are none.
 */
+(YTemperature*) FirstTemperature;
//--- (end of YTemperature public methods declaration)

@end

//--- (Temperature functions declaration)
/**
 * Retrieves a temperature sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the temperature sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTemperature.isOnline() to test if the temperature sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a temperature sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the temperature sensor
 * 
 * @return a YTemperature object allowing you to drive the temperature sensor.
 */
YTemperature* yFindTemperature(NSString* func);
/**
 * Starts the enumeration of temperature sensors currently accessible.
 * Use the method YTemperature.nextTemperature() to iterate on
 * next temperature sensors.
 * 
 * @return a pointer to a YTemperature object, corresponding to
 *         the first temperature sensor currently online, or a null pointer
 *         if there are none.
 */
YTemperature* yFirstTemperature(void);

//--- (end of Temperature functions declaration)
CF_EXTERN_C_END

