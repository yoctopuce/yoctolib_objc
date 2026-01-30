/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindOrientation(), the high-level API for Orientation functions
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

@class YOrientation;

//--- (YOrientation globals)
typedef void (*YOrientationValueCallback)(YOrientation *func, NSString *functionValue);
typedef void (*YOrientationTimedReportCallback)(YOrientation *func, YMeasure *measure);
//--- (end of YOrientation globals)

//--- (YOrientation class start)
/**
 * YOrientation Class: orientation sensor control interface
 *
 * The YOrientation class allows you to read and configure Yoctopuce orientation sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YOrientation : YSensor
//--- (end of YOrientation class start)
{
@protected
//--- (YOrientation attributes declaration)
    YOrientationValueCallback _valueCallbackOrientation;
    YOrientationTimedReportCallback _timedReportCallbackOrientation;
//--- (end of YOrientation attributes declaration)
}
// Constructor is protected, use yFindOrientation factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YOrientation private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YOrientation private methods declaration)
//--- (YOrientation yapiwrapper declaration)
//--- (end of YOrientation yapiwrapper declaration)
//--- (YOrientation public methods declaration)
/**
 * Retrieves an orientation sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the orientation sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YOrientation.isOnline() to test if the orientation sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an orientation sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the orientation sensor, for instance
 *         MyDevice.orientation.
 *
 * @return a YOrientation object allowing you to drive the orientation sensor.
 */
+(YOrientation*)     FindOrientation:(NSString*)func;

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
-(int)     registerValueCallback:(YOrientationValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YOrientationTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of orientation sensors started using yFirstOrientation().
 * Caution: You can't make any assumption about the returned orientation sensors order.
 * If you want to find a specific an orientation sensor, use Orientation.findOrientation()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YOrientation object, corresponding to
 *         an orientation sensor currently online, or a nil pointer
 *         if there are no more orientation sensors to enumerate.
 */
-(nullable YOrientation*) nextOrientation
NS_SWIFT_NAME(nextOrientation());
/**
 * Starts the enumeration of orientation sensors currently accessible.
 * Use the method YOrientation.nextOrientation() to iterate on
 * next orientation sensors.
 *
 * @return a pointer to a YOrientation object, corresponding to
 *         the first orientation sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YOrientation*) FirstOrientation
NS_SWIFT_NAME(FirstOrientation());
//--- (end of YOrientation public methods declaration)

@end

//--- (YOrientation functions declaration)
/**
 * Retrieves an orientation sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the orientation sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YOrientation.isOnline() to test if the orientation sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an orientation sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the orientation sensor, for instance
 *         MyDevice.orientation.
 *
 * @return a YOrientation object allowing you to drive the orientation sensor.
 */
YOrientation* yFindOrientation(NSString* func);
/**
 * Starts the enumeration of orientation sensors currently accessible.
 * Use the method YOrientation.nextOrientation() to iterate on
 * next orientation sensors.
 *
 * @return a pointer to a YOrientation object, corresponding to
 *         the first orientation sensor currently online, or a nil pointer
 *         if there are none.
 */
YOrientation* yFirstOrientation(void);

//--- (end of YOrientation functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

