/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindTvoc(), the high-level API for Tvoc functions
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

@class YTvoc;

//--- (YTvoc globals)
typedef void (*YTvocValueCallback)(YTvoc *func, NSString *functionValue);
typedef void (*YTvocTimedReportCallback)(YTvoc *func, YMeasure *measure);
//--- (end of YTvoc globals)

//--- (YTvoc class start)
/**
 * YTvoc Class: Total Volatile Organic Compound sensor control interface, available for instance in
 * the Yocto-VOC-V3
 *
 * The YTvoc class allows you to read and configure Yoctopuce Total Volatile Organic Compound sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YTvoc : YSensor
//--- (end of YTvoc class start)
{
@protected
//--- (YTvoc attributes declaration)
    YTvocValueCallback _valueCallbackTvoc;
    YTvocTimedReportCallback _timedReportCallbackTvoc;
//--- (end of YTvoc attributes declaration)
}
// Constructor is protected, use yFindTvoc factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YTvoc private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YTvoc private methods declaration)
//--- (YTvoc yapiwrapper declaration)
//--- (end of YTvoc yapiwrapper declaration)
//--- (YTvoc public methods declaration)
/**
 * Retrieves a Total  Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the Total  Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTvoc.isOnline() to test if the Total  Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Total  Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Total  Volatile Organic Compound sensor, for instance
 *         YVOCMK03.tvoc.
 *
 * @return a YTvoc object allowing you to drive the Total  Volatile Organic Compound sensor.
 */
+(YTvoc*)     FindTvoc:(NSString*)func;

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
-(int)     registerValueCallback:(YTvocValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YTvocTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of Total Volatile Organic Compound sensors started using yFirstTvoc().
 * Caution: You can't make any assumption about the returned Total Volatile Organic Compound sensors order.
 * If you want to find a specific a Total  Volatile Organic Compound sensor, use Tvoc.findTvoc()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YTvoc object, corresponding to
 *         a Total  Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are no more Total Volatile Organic Compound sensors to enumerate.
 */
-(nullable YTvoc*) nextTvoc
NS_SWIFT_NAME(nextTvoc());
/**
 * Starts the enumeration of Total Volatile Organic Compound sensors currently accessible.
 * Use the method YTvoc.nextTvoc() to iterate on
 * next Total Volatile Organic Compound sensors.
 *
 * @return a pointer to a YTvoc object, corresponding to
 *         the first Total Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YTvoc*) FirstTvoc
NS_SWIFT_NAME(FirstTvoc());
//--- (end of YTvoc public methods declaration)

@end

//--- (YTvoc functions declaration)
/**
 * Retrieves a Total  Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the Total  Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTvoc.isOnline() to test if the Total  Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Total  Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Total  Volatile Organic Compound sensor, for instance
 *         YVOCMK03.tvoc.
 *
 * @return a YTvoc object allowing you to drive the Total  Volatile Organic Compound sensor.
 */
YTvoc* yFindTvoc(NSString* func);
/**
 * Starts the enumeration of Total Volatile Organic Compound sensors currently accessible.
 * Use the method YTvoc.nextTvoc() to iterate on
 * next Total Volatile Organic Compound sensors.
 *
 * @return a pointer to a YTvoc object, corresponding to
 *         the first Total Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are none.
 */
YTvoc* yFirstTvoc(void);

//--- (end of YTvoc functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

