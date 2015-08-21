/*********************************************************************
 *
 * $Id: yocto_humidity.h 21211 2015-08-19 16:03:29Z seb $
 *
 * Declares yFindHumidity(), the high-level API for Humidity functions
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

@class YHumidity;

//--- (YHumidity globals)
typedef void (*YHumidityValueCallback)(YHumidity *func, NSString *functionValue);
typedef void (*YHumidityTimedReportCallback)(YHumidity *func, YMeasure *measure);
#define Y_RELHUM_INVALID                YAPI_INVALID_DOUBLE
#define Y_ABSHUM_INVALID                YAPI_INVALID_DOUBLE
//--- (end of YHumidity globals)

//--- (YHumidity class start)
/**
 * YHumidity Class: Humidity function interface
 *
 * The Yoctopuce class YHumidity allows you to read and configure Yoctopuce humidity
 * sensors. It inherits from YSensor class the core functions to read measurements,
 * register callback functions, access to the autonomous datalogger.
 */
@interface YHumidity : YSensor
//--- (end of YHumidity class start)
{
@protected
//--- (YHumidity attributes declaration)
    double          _relHum;
    double          _absHum;
    YHumidityValueCallback _valueCallbackHumidity;
    YHumidityTimedReportCallback _timedReportCallbackHumidity;
//--- (end of YHumidity attributes declaration)
}
// Constructor is protected, use yFindHumidity factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YHumidity private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YHumidity private methods declaration)
//--- (YHumidity public methods declaration)
/**
 * Changes the primary unit for measuring humidity. That unit is a string.
 * If that strings starts with the letter 'g', the primary measured value is the absolute
 * humidity, in g/m3. Otherwise, the primary measured value will be the relative humidity
 * (RH), in per cents.
 *
 * Remember to call the saveToFlash() method of the module if the modification
 * must be kept.
 *
 * @param newval : a string corresponding to the primary unit for measuring humidity
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the current relative humidity, in per cents.
 *
 * @return a floating point number corresponding to the current relative humidity, in per cents
 *
 * On failure, throws an exception or returns Y_RELHUM_INVALID.
 */
-(double)     get_relHum;


-(double) relHum;
/**
 * Returns the current absolute humidity, in grams per cubic meter of air.
 *
 * @return a floating point number corresponding to the current absolute humidity, in grams per cubic meter of air
 *
 * On failure, throws an exception or returns Y_ABSHUM_INVALID.
 */
-(double)     get_absHum;


-(double) absHum;
/**
 * Retrieves a humidity sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the humidity sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHumidity.isOnline() to test if the humidity sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a humidity sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the humidity sensor
 *
 * @return a YHumidity object allowing you to drive the humidity sensor.
 */
+(YHumidity*)     FindHumidity:(NSString*)func;

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
-(int)     registerValueCallback:(YHumidityValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YHumidityTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of humidity sensors started using yFirstHumidity().
 *
 * @return a pointer to a YHumidity object, corresponding to
 *         a humidity sensor currently online, or a null pointer
 *         if there are no more humidity sensors to enumerate.
 */
-(YHumidity*) nextHumidity;
/**
 * Starts the enumeration of humidity sensors currently accessible.
 * Use the method YHumidity.nextHumidity() to iterate on
 * next humidity sensors.
 *
 * @return a pointer to a YHumidity object, corresponding to
 *         the first humidity sensor currently online, or a null pointer
 *         if there are none.
 */
+(YHumidity*) FirstHumidity;
//--- (end of YHumidity public methods declaration)

@end

//--- (Humidity functions declaration)
/**
 * Retrieves a humidity sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the humidity sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHumidity.isOnline() to test if the humidity sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a humidity sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the humidity sensor
 *
 * @return a YHumidity object allowing you to drive the humidity sensor.
 */
YHumidity* yFindHumidity(NSString* func);
/**
 * Starts the enumeration of humidity sensors currently accessible.
 * Use the method YHumidity.nextHumidity() to iterate on
 * next humidity sensors.
 *
 * @return a pointer to a YHumidity object, corresponding to
 *         the first humidity sensor currently online, or a null pointer
 *         if there are none.
 */
YHumidity* yFirstHumidity(void);

//--- (end of Humidity functions declaration)
CF_EXTERN_C_END

