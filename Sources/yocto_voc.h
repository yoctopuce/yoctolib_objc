/*********************************************************************
 *
 *  $Id: yocto_voc.h 32906 2018-11-02 10:18:15Z seb $
 *
 *  Declares yFindVoc(), the high-level API for Voc functions
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

@class YVoc;

//--- (YVoc globals)
typedef void (*YVocValueCallback)(YVoc *func, NSString *functionValue);
typedef void (*YVocTimedReportCallback)(YVoc *func, YMeasure *measure);
//--- (end of YVoc globals)

//--- (YVoc class start)
/**
 * YVoc Class: Voc function interface
 *
 * The Yoctopuce class YVoc allows you to read and configure Yoctopuce Volatile Organic
 * Compound sensors. It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, to access the autonomous datalogger.
 */
@interface YVoc : YSensor
//--- (end of YVoc class start)
{
@protected
//--- (YVoc attributes declaration)
    YVocValueCallback _valueCallbackVoc;
    YVocTimedReportCallback _timedReportCallbackVoc;
//--- (end of YVoc attributes declaration)
}
// Constructor is protected, use yFindVoc factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YVoc private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YVoc private methods declaration)
//--- (YVoc yapiwrapper declaration)
//--- (end of YVoc yapiwrapper declaration)
//--- (YVoc public methods declaration)
/**
 * Retrieves a Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoc.isOnline() to test if the Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Volatile Organic Compound sensor
 *
 * @return a YVoc object allowing you to drive the Volatile Organic Compound sensor.
 */
+(YVoc*)     FindVoc:(NSString*)func;

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
-(int)     registerValueCallback:(YVocValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YVocTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of Volatile Organic Compound sensors started using yFirstVoc().
 * Caution: You can't make any assumption about the returned Volatile Organic Compound sensors order.
 * If you want to find a specific a Volatile Organic Compound sensor, use Voc.findVoc()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YVoc object, corresponding to
 *         a Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are no more Volatile Organic Compound sensors to enumerate.
 */
-(YVoc*) nextVoc;
/**
 * Starts the enumeration of Volatile Organic Compound sensors currently accessible.
 * Use the method YVoc.nextVoc() to iterate on
 * next Volatile Organic Compound sensors.
 *
 * @return a pointer to a YVoc object, corresponding to
 *         the first Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are none.
 */
+(YVoc*) FirstVoc;
//--- (end of YVoc public methods declaration)

@end

//--- (YVoc functions declaration)
/**
 * Retrieves a Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoc.isOnline() to test if the Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Volatile Organic Compound sensor
 *
 * @return a YVoc object allowing you to drive the Volatile Organic Compound sensor.
 */
YVoc* yFindVoc(NSString* func);
/**
 * Starts the enumeration of Volatile Organic Compound sensors currently accessible.
 * Use the method YVoc.nextVoc() to iterate on
 * next Volatile Organic Compound sensors.
 *
 * @return a pointer to a YVoc object, corresponding to
 *         the first Volatile Organic Compound sensor currently online, or a nil pointer
 *         if there are none.
 */
YVoc* yFirstVoc(void);

//--- (end of YVoc functions declaration)
CF_EXTERN_C_END

