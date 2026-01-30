/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindAngularSpeed(), the high-level API for AngularSpeed functions
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

@class YAngularSpeed;

//--- (YAngularSpeed globals)
typedef void (*YAngularSpeedValueCallback)(YAngularSpeed *func, NSString *functionValue);
typedef void (*YAngularSpeedTimedReportCallback)(YAngularSpeed *func, YMeasure *measure);
//--- (end of YAngularSpeed globals)

//--- (YAngularSpeed class start)
/**
 * YAngularSpeed Class: tachometer control interface
 *
 * The YAngularSpeed class allows you to read and configure Yoctopuce tachometers.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YAngularSpeed : YSensor
//--- (end of YAngularSpeed class start)
{
@protected
//--- (YAngularSpeed attributes declaration)
    YAngularSpeedValueCallback _valueCallbackAngularSpeed;
    YAngularSpeedTimedReportCallback _timedReportCallbackAngularSpeed;
//--- (end of YAngularSpeed attributes declaration)
}
// Constructor is protected, use yFindAngularSpeed factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YAngularSpeed private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YAngularSpeed private methods declaration)
//--- (YAngularSpeed yapiwrapper declaration)
//--- (end of YAngularSpeed yapiwrapper declaration)
//--- (YAngularSpeed public methods declaration)
/**
 * Retrieves a tachometer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the rtachometer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAngularSpeed.isOnline() to test if the rtachometer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a tachometer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the rtachometer, for instance
 *         MyDevice.angularSpeed.
 *
 * @return a YAngularSpeed object allowing you to drive the rtachometer.
 */
+(YAngularSpeed*)     FindAngularSpeed:(NSString*)func;

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
-(int)     registerValueCallback:(YAngularSpeedValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YAngularSpeedTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of tachometers started using yFirstAngularSpeed().
 * Caution: You can't make any assumption about the returned tachometers order.
 * If you want to find a specific a tachometer, use AngularSpeed.findAngularSpeed()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YAngularSpeed object, corresponding to
 *         a tachometer currently online, or a nil pointer
 *         if there are no more tachometers to enumerate.
 */
-(nullable YAngularSpeed*) nextAngularSpeed
NS_SWIFT_NAME(nextAngularSpeed());
/**
 * Starts the enumeration of tachometers currently accessible.
 * Use the method YAngularSpeed.nextAngularSpeed() to iterate on
 * next tachometers.
 *
 * @return a pointer to a YAngularSpeed object, corresponding to
 *         the first tachometer currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YAngularSpeed*) FirstAngularSpeed
NS_SWIFT_NAME(FirstAngularSpeed());
//--- (end of YAngularSpeed public methods declaration)

@end

//--- (YAngularSpeed functions declaration)
/**
 * Retrieves a tachometer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the rtachometer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAngularSpeed.isOnline() to test if the rtachometer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a tachometer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the rtachometer, for instance
 *         MyDevice.angularSpeed.
 *
 * @return a YAngularSpeed object allowing you to drive the rtachometer.
 */
YAngularSpeed* yFindAngularSpeed(NSString* func);
/**
 * Starts the enumeration of tachometers currently accessible.
 * Use the method YAngularSpeed.nextAngularSpeed() to iterate on
 * next tachometers.
 *
 * @return a pointer to a YAngularSpeed object, corresponding to
 *         the first tachometer currently online, or a nil pointer
 *         if there are none.
 */
YAngularSpeed* yFirstAngularSpeed(void);

//--- (end of YAngularSpeed functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

