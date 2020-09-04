/*********************************************************************
 *
 *  $Id: yocto_latitude.h 41625 2020-08-31 07:09:39Z seb $
 *
 *  Declares yFindLatitude(), the high-level API for Latitude functions
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

@class YLatitude;

//--- (YLatitude globals)
typedef void (*YLatitudeValueCallback)(YLatitude *func, NSString *functionValue);
typedef void (*YLatitudeTimedReportCallback)(YLatitude *func, YMeasure *measure);
//--- (end of YLatitude globals)

//--- (YLatitude class start)
/**
 * YLatitude Class: latitude sensor control interface, available for instance in the Yocto-GPS-V2
 *
 * The YLatitude class allows you to read and configure Yoctopuce latitude sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YLatitude : YSensor
//--- (end of YLatitude class start)
{
@protected
//--- (YLatitude attributes declaration)
    YLatitudeValueCallback _valueCallbackLatitude;
    YLatitudeTimedReportCallback _timedReportCallbackLatitude;
//--- (end of YLatitude attributes declaration)
}
// Constructor is protected, use yFindLatitude factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YLatitude private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YLatitude private methods declaration)
//--- (YLatitude yapiwrapper declaration)
//--- (end of YLatitude yapiwrapper declaration)
//--- (YLatitude public methods declaration)
/**
 * Retrieves a latitude sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the latitude sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLatitude.isOnline() to test if the latitude sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a latitude sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the latitude sensor, for instance
 *         YGNSSMK2.latitude.
 *
 * @return a YLatitude object allowing you to drive the latitude sensor.
 */
+(YLatitude*)     FindLatitude:(NSString*)func;

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
-(int)     registerValueCallback:(YLatitudeValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YLatitudeTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of latitude sensors started using yFirstLatitude().
 * Caution: You can't make any assumption about the returned latitude sensors order.
 * If you want to find a specific a latitude sensor, use Latitude.findLatitude()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YLatitude object, corresponding to
 *         a latitude sensor currently online, or a nil pointer
 *         if there are no more latitude sensors to enumerate.
 */
-(nullable YLatitude*) nextLatitude
NS_SWIFT_NAME(nextLatitude());
/**
 * Starts the enumeration of latitude sensors currently accessible.
 * Use the method YLatitude.nextLatitude() to iterate on
 * next latitude sensors.
 *
 * @return a pointer to a YLatitude object, corresponding to
 *         the first latitude sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YLatitude*) FirstLatitude
NS_SWIFT_NAME(FirstLatitude());
//--- (end of YLatitude public methods declaration)

@end

//--- (YLatitude functions declaration)
/**
 * Retrieves a latitude sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the latitude sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLatitude.isOnline() to test if the latitude sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a latitude sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the latitude sensor, for instance
 *         YGNSSMK2.latitude.
 *
 * @return a YLatitude object allowing you to drive the latitude sensor.
 */
YLatitude* yFindLatitude(NSString* func);
/**
 * Starts the enumeration of latitude sensors currently accessible.
 * Use the method YLatitude.nextLatitude() to iterate on
 * next latitude sensors.
 *
 * @return a pointer to a YLatitude object, corresponding to
 *         the first latitude sensor currently online, or a nil pointer
 *         if there are none.
 */
YLatitude* yFirstLatitude(void);

//--- (end of YLatitude functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

