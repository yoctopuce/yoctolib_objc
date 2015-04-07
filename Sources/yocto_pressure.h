/*********************************************************************
 *
 * $Id: yocto_pressure.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindPressure(), the high-level API for Pressure functions
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

@class YPressure;

//--- (YPressure globals)
typedef void (*YPressureValueCallback)(YPressure *func, NSString *functionValue);
typedef void (*YPressureTimedReportCallback)(YPressure *func, YMeasure *measure);
//--- (end of YPressure globals)

//--- (YPressure class start)
/**
 * YPressure Class: Pressure function interface
 *
 * The Yoctopuce class YPressure allows you to read and configure Yoctopuce pressure
 * sensors. It inherits from YSensor class the core functions to read measurements,
 * register callback functions, access to the autonomous datalogger.
 */
@interface YPressure : YSensor
//--- (end of YPressure class start)
{
@protected
//--- (YPressure attributes declaration)
    YPressureValueCallback _valueCallbackPressure;
    YPressureTimedReportCallback _timedReportCallbackPressure;
//--- (end of YPressure attributes declaration)
}
// Constructor is protected, use yFindPressure factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPressure private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPressure private methods declaration)
//--- (YPressure public methods declaration)
/**
 * Retrieves a pressure sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the pressure sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPressure.isOnline() to test if the pressure sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a pressure sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the pressure sensor
 *
 * @return a YPressure object allowing you to drive the pressure sensor.
 */
+(YPressure*)     FindPressure:(NSString*)func;

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
-(int)     registerValueCallback:(YPressureValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YPressureTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of pressure sensors started using yFirstPressure().
 *
 * @return a pointer to a YPressure object, corresponding to
 *         a pressure sensor currently online, or a null pointer
 *         if there are no more pressure sensors to enumerate.
 */
-(YPressure*) nextPressure;
/**
 * Starts the enumeration of pressure sensors currently accessible.
 * Use the method YPressure.nextPressure() to iterate on
 * next pressure sensors.
 *
 * @return a pointer to a YPressure object, corresponding to
 *         the first pressure sensor currently online, or a null pointer
 *         if there are none.
 */
+(YPressure*) FirstPressure;
//--- (end of YPressure public methods declaration)

@end

//--- (Pressure functions declaration)
/**
 * Retrieves a pressure sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the pressure sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPressure.isOnline() to test if the pressure sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a pressure sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the pressure sensor
 *
 * @return a YPressure object allowing you to drive the pressure sensor.
 */
YPressure* yFindPressure(NSString* func);
/**
 * Starts the enumeration of pressure sensors currently accessible.
 * Use the method YPressure.nextPressure() to iterate on
 * next pressure sensors.
 *
 * @return a pointer to a YPressure object, corresponding to
 *         the first pressure sensor currently online, or a null pointer
 *         if there are none.
 */
YPressure* yFirstPressure(void);

//--- (end of Pressure functions declaration)
CF_EXTERN_C_END

