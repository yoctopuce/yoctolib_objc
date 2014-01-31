/*********************************************************************
 *
 * $Id: yocto_genericsensor.h 14325 2014-01-11 01:42:47Z seb $
 *
 * Declares yFindGenericSensor(), the high-level API for GenericSensor functions
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

@class YGenericSensor;

//--- (YGenericSensor globals)
typedef void (*YGenericSensorValueCallback)(YGenericSensor *func, NSString *functionValue);
typedef void (*YGenericSensorTimedReportCallback)(YGenericSensor *func, YMeasure *measure);
#define Y_SIGNALVALUE_INVALID           YAPI_INVALID_DOUBLE
#define Y_SIGNALUNIT_INVALID            YAPI_INVALID_STRING
#define Y_SIGNALRANGE_INVALID           YAPI_INVALID_STRING
#define Y_VALUERANGE_INVALID            YAPI_INVALID_STRING
//--- (end of YGenericSensor globals)

//--- (YGenericSensor class start)
/**
 * YGenericSensor Class: GenericSensor function interface
 * 
 * The Yoctopuce application programming interface allows you to read an instant
 * measure of the sensor, as well as the minimal and maximal values observed.
 */
@interface YGenericSensor : YSensor
//--- (end of YGenericSensor class start)
{
@protected
//--- (YGenericSensor attributes declaration)
    double          _signalValue;
    NSString*       _signalUnit;
    NSString*       _signalRange;
    NSString*       _valueRange;
    YGenericSensorValueCallback _valueCallbackGenericSensor;
    YGenericSensorTimedReportCallback _timedReportCallbackGenericSensor;
//--- (end of YGenericSensor attributes declaration)
}
// Constructor is protected, use yFindGenericSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YGenericSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YGenericSensor private methods declaration)
//--- (YGenericSensor public methods declaration)
/**
 * Changes the measuring unit for the measured value.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the measuring unit for the measured value
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the measured value of the electrical signal used by the sensor.
 * 
 * @return a floating point number corresponding to the measured value of the electrical signal used by the sensor
 * 
 * On failure, throws an exception or returns Y_SIGNALVALUE_INVALID.
 */
-(double)     get_signalValue;


-(double) signalValue;
/**
 * Returns the measuring unit of the electrical signal used by the sensor.
 * 
 * @return a string corresponding to the measuring unit of the electrical signal used by the sensor
 * 
 * On failure, throws an exception or returns Y_SIGNALUNIT_INVALID.
 */
-(NSString*)     get_signalUnit;


-(NSString*) signalUnit;
/**
 * Returns the electric signal range used by the sensor.
 * 
 * @return a string corresponding to the electric signal range used by the sensor
 * 
 * On failure, throws an exception or returns Y_SIGNALRANGE_INVALID.
 */
-(NSString*)     get_signalRange;


-(NSString*) signalRange;
/**
 * Changes the electric signal range used by the sensor.
 * 
 * @param newval : a string corresponding to the electric signal range used by the sensor
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_signalRange:(NSString*) newval;
-(int)     setSignalRange:(NSString*) newval;

/**
 * Returns the physical value range measured by the sensor.
 * 
 * @return a string corresponding to the physical value range measured by the sensor
 * 
 * On failure, throws an exception or returns Y_VALUERANGE_INVALID.
 */
-(NSString*)     get_valueRange;


-(NSString*) valueRange;
/**
 * Changes the physical value range measured by the sensor. The range change may have a side effect
 * on the display resolution, as it may be adapted automatically.
 * 
 * @param newval : a string corresponding to the physical value range measured by the sensor
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_valueRange:(NSString*) newval;
-(int)     setValueRange:(NSString*) newval;

/**
 * Retrieves a generic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the generic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGenericSensor.isOnline() to test if the generic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a generic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the generic sensor
 * 
 * @return a YGenericSensor object allowing you to drive the generic sensor.
 */
+(YGenericSensor*)     FindGenericSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YGenericSensorValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YGenericSensorTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of generic sensors started using yFirstGenericSensor().
 * 
 * @return a pointer to a YGenericSensor object, corresponding to
 *         a generic sensor currently online, or a null pointer
 *         if there are no more generic sensors to enumerate.
 */
-(YGenericSensor*) nextGenericSensor;
/**
 * Starts the enumeration of generic sensors currently accessible.
 * Use the method YGenericSensor.nextGenericSensor() to iterate on
 * next generic sensors.
 * 
 * @return a pointer to a YGenericSensor object, corresponding to
 *         the first generic sensor currently online, or a null pointer
 *         if there are none.
 */
+(YGenericSensor*) FirstGenericSensor;
//--- (end of YGenericSensor public methods declaration)

@end

//--- (GenericSensor functions declaration)
/**
 * Retrieves a generic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the generic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGenericSensor.isOnline() to test if the generic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a generic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the generic sensor
 * 
 * @return a YGenericSensor object allowing you to drive the generic sensor.
 */
YGenericSensor* yFindGenericSensor(NSString* func);
/**
 * Starts the enumeration of generic sensors currently accessible.
 * Use the method YGenericSensor.nextGenericSensor() to iterate on
 * next generic sensors.
 * 
 * @return a pointer to a YGenericSensor object, corresponding to
 *         the first generic sensor currently online, or a null pointer
 *         if there are none.
 */
YGenericSensor* yFirstGenericSensor(void);

//--- (end of GenericSensor functions declaration)
CF_EXTERN_C_END

