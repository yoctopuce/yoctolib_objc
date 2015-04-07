/*********************************************************************
 *
 * $Id: yocto_groundspeed.h 19746 2015-03-17 10:34:00Z seb $
 *
 * Declares yFindGroundSpeed(), the high-level API for GroundSpeed functions
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

@class YGroundSpeed;

//--- (YGroundSpeed globals)
typedef void (*YGroundSpeedValueCallback)(YGroundSpeed *func, NSString *functionValue);
typedef void (*YGroundSpeedTimedReportCallback)(YGroundSpeed *func, YMeasure *measure);
//--- (end of YGroundSpeed globals)

//--- (YGroundSpeed class start)
/**
 * YGroundSpeed Class: GroundSpeed function interface
 *
 * The Yoctopuce class YGroundSpeed allows you to read the ground speed from Yoctopuce
 * geolocalization sensors. It inherits from the YSensor class the core functions to
 * read measurements, register callback functions, access the autonomous
 * datalogger.
 */
@interface YGroundSpeed : YSensor
//--- (end of YGroundSpeed class start)
{
@protected
//--- (YGroundSpeed attributes declaration)
    YGroundSpeedValueCallback _valueCallbackGroundSpeed;
    YGroundSpeedTimedReportCallback _timedReportCallbackGroundSpeed;
//--- (end of YGroundSpeed attributes declaration)
}
// Constructor is protected, use yFindGroundSpeed factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YGroundSpeed private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YGroundSpeed private methods declaration)
//--- (YGroundSpeed public methods declaration)
/**
 * Retrieves a ground speed sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the ground speed sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGroundSpeed.isOnline() to test if the ground speed sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a ground speed sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the ground speed sensor
 *
 * @return a YGroundSpeed object allowing you to drive the ground speed sensor.
 */
+(YGroundSpeed*)     FindGroundSpeed:(NSString*)func;

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
-(int)     registerValueCallback:(YGroundSpeedValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YGroundSpeedTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of ground speed sensors started using yFirstGroundSpeed().
 *
 * @return a pointer to a YGroundSpeed object, corresponding to
 *         a ground speed sensor currently online, or a null pointer
 *         if there are no more ground speed sensors to enumerate.
 */
-(YGroundSpeed*) nextGroundSpeed;
/**
 * Starts the enumeration of ground speed sensors currently accessible.
 * Use the method YGroundSpeed.nextGroundSpeed() to iterate on
 * next ground speed sensors.
 *
 * @return a pointer to a YGroundSpeed object, corresponding to
 *         the first ground speed sensor currently online, or a null pointer
 *         if there are none.
 */
+(YGroundSpeed*) FirstGroundSpeed;
//--- (end of YGroundSpeed public methods declaration)

@end

//--- (GroundSpeed functions declaration)
/**
 * Retrieves a ground speed sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the ground speed sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGroundSpeed.isOnline() to test if the ground speed sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a ground speed sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the ground speed sensor
 *
 * @return a YGroundSpeed object allowing you to drive the ground speed sensor.
 */
YGroundSpeed* yFindGroundSpeed(NSString* func);
/**
 * Starts the enumeration of ground speed sensors currently accessible.
 * Use the method YGroundSpeed.nextGroundSpeed() to iterate on
 * next ground speed sensors.
 *
 * @return a pointer to a YGroundSpeed object, corresponding to
 *         the first ground speed sensor currently online, or a null pointer
 *         if there are none.
 */
YGroundSpeed* yFirstGroundSpeed(void);

//--- (end of GroundSpeed functions declaration)
CF_EXTERN_C_END

