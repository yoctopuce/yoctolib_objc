/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindCounter(), the high-level API for Counter functions
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

@class YCounter;

//--- (YCounter globals)
typedef void (*YCounterValueCallback)(YCounter *func, NSString *functionValue);
typedef void (*YCounterTimedReportCallback)(YCounter *func, YMeasure *measure);
//--- (end of YCounter globals)

//--- (YCounter class start)
/**
 * YCounter Class: counter control interface
 *
 * The YCounter class allows you to read and configure Yoctopuce gcounters.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YCounter : YSensor
//--- (end of YCounter class start)
{
@protected
//--- (YCounter attributes declaration)
    YCounterValueCallback _valueCallbackCounter;
    YCounterTimedReportCallback _timedReportCallbackCounter;
//--- (end of YCounter attributes declaration)
}
// Constructor is protected, use yFindCounter factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YCounter private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YCounter private methods declaration)
//--- (YCounter yapiwrapper declaration)
//--- (end of YCounter yapiwrapper declaration)
//--- (YCounter public methods declaration)
/**
 * Retrieves a counter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the counter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCounter.isOnline() to test if the counter is
 * indeed online at a given time. In case of ambiguity when looking for
 * a counter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the counter, for instance
 *         MyDevice.counter.
 *
 * @return a YCounter object allowing you to drive the counter.
 */
+(YCounter*)     FindCounter:(NSString*)func;

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
-(int)     registerValueCallback:(YCounterValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YCounterTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of gcounters started using yFirstCounter().
 * Caution: You can't make any assumption about the returned gcounters order.
 * If you want to find a specific a counter, use Counter.findCounter()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YCounter object, corresponding to
 *         a counter currently online, or a nil pointer
 *         if there are no more gcounters to enumerate.
 */
-(nullable YCounter*) nextCounter
NS_SWIFT_NAME(nextCounter());
/**
 * Starts the enumeration of gcounters currently accessible.
 * Use the method YCounter.nextCounter() to iterate on
 * next gcounters.
 *
 * @return a pointer to a YCounter object, corresponding to
 *         the first counter currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YCounter*) FirstCounter
NS_SWIFT_NAME(FirstCounter());
//--- (end of YCounter public methods declaration)

@end

//--- (YCounter functions declaration)
/**
 * Retrieves a counter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the counter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCounter.isOnline() to test if the counter is
 * indeed online at a given time. In case of ambiguity when looking for
 * a counter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the counter, for instance
 *         MyDevice.counter.
 *
 * @return a YCounter object allowing you to drive the counter.
 */
YCounter* yFindCounter(NSString* func);
/**
 * Starts the enumeration of gcounters currently accessible.
 * Use the method YCounter.nextCounter() to iterate on
 * next gcounters.
 *
 * @return a pointer to a YCounter object, corresponding to
 *         the first counter currently online, or a nil pointer
 *         if there are none.
 */
YCounter* yFirstCounter(void);

//--- (end of YCounter functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

