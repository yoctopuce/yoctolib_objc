/*********************************************************************
 *
 *  $Id: yocto_arithmeticsensor.h 43619 2021-01-29 09:14:45Z mvuilleu $
 *
 *  Declares yFindArithmeticSensor(), the high-level API for ArithmeticSensor functions
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

@class YArithmeticSensor;

//--- (YArithmeticSensor globals)
typedef void (*YArithmeticSensorValueCallback)(YArithmeticSensor *func, NSString *functionValue);
typedef void (*YArithmeticSensorTimedReportCallback)(YArithmeticSensor *func, YMeasure *measure);
#define Y_DESCRIPTION_INVALID           YAPI_INVALID_STRING
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YArithmeticSensor globals)

//--- (YArithmeticSensor class start)
/**
 * YArithmeticSensor Class: arithmetic sensor control interface, available for instance in the
 * Yocto-MaxiMicroVolt-Rx
 *
 * The YArithmeticSensor class allows some Yoctopuce devices to compute in real-time
 * values based on an arithmetic formula involving one or more measured signals as
 * well as the temperature. As for any physical sensor, the computed values can be
 * read by callback and stored in the built-in datalogger.
 */
@interface YArithmeticSensor : YSensor
//--- (end of YArithmeticSensor class start)
{
@protected
//--- (YArithmeticSensor attributes declaration)
    NSString*       _description;
    NSString*       _command;
    YArithmeticSensorValueCallback _valueCallbackArithmeticSensor;
    YArithmeticSensorTimedReportCallback _timedReportCallbackArithmeticSensor;
//--- (end of YArithmeticSensor attributes declaration)
}
// Constructor is protected, use yFindArithmeticSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YArithmeticSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YArithmeticSensor private methods declaration)
//--- (YArithmeticSensor yapiwrapper declaration)
//--- (end of YArithmeticSensor yapiwrapper declaration)
//--- (YArithmeticSensor public methods declaration)
/**
 * Changes the measuring unit for the arithmetic sensor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the arithmetic sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns a short informative description of the formula.
 *
 * @return a string corresponding to a short informative description of the formula
 *
 * On failure, throws an exception or returns YArithmeticSensor.DESCRIPTION_INVALID.
 */
-(NSString*)     get_description;


-(NSString*) description;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves an arithmetic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the arithmetic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YArithmeticSensor.isOnline() to test if the arithmetic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an arithmetic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the arithmetic sensor, for instance
 *         RXUVOLT1.arithmeticSensor1.
 *
 * @return a YArithmeticSensor object allowing you to drive the arithmetic sensor.
 */
+(YArithmeticSensor*)     FindArithmeticSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YArithmeticSensorValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YArithmeticSensorTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Defines the arithmetic function by means of an algebraic expression. The expression
 * may include references to device sensors, by their physical or logical name, to
 * usual math functions and to auxiliary functions defined separately.
 *
 * @param expr : the algebraic expression defining the function.
 * @param descr : short informative description of the expression.
 *
 * @return the current expression value if the call succeeds.
 *
 * On failure, throws an exception or returns YAPI_INVALID_DOUBLE.
 */
-(double)     defineExpression:(NSString*)expr :(NSString*)descr;

/**
 * Retrieves the algebraic expression defining the arithmetic function, as previously
 * configured using the defineExpression function.
 *
 * @return a string containing the mathematical expression.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSString*)     loadExpression;

/**
 * Defines a auxiliary function by means of a table of reference points. Intermediate values
 * will be interpolated between specified reference points. The reference points are given
 * as pairs of floating point numbers.
 * The auxiliary function will be available for use by all ArithmeticSensor objects of the
 * device. Up to nine auxiliary function can be defined in a device, each containing up to
 * 96 reference points.
 *
 * @param name : auxiliary function name, up to 16 characters.
 * @param inputValues : array of floating point numbers, corresponding to the function input value.
 * @param outputValues : array of floating point numbers, corresponding to the output value
 *         desired for each of the input value, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     defineAuxiliaryFunction:(NSString*)name :(NSMutableArray*)inputValues :(NSMutableArray*)outputValues;

/**
 * Retrieves the reference points table defining an auxiliary function previously
 * configured using the defineAuxiliaryFunction function.
 *
 * @param name : auxiliary function name, up to 16 characters.
 * @param inputValues : array of floating point numbers, that is filled by the function
 *         with all the function reference input value.
 * @param outputValues : array of floating point numbers, that is filled by the function
 *         output value for each of the input value, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     loadAuxiliaryFunction:(NSString*)name :(NSMutableArray*)inputValues :(NSMutableArray*)outputValues;


/**
 * Continues the enumeration of arithmetic sensors started using yFirstArithmeticSensor().
 * Caution: You can't make any assumption about the returned arithmetic sensors order.
 * If you want to find a specific an arithmetic sensor, use ArithmeticSensor.findArithmeticSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YArithmeticSensor object, corresponding to
 *         an arithmetic sensor currently online, or a nil pointer
 *         if there are no more arithmetic sensors to enumerate.
 */
-(nullable YArithmeticSensor*) nextArithmeticSensor
NS_SWIFT_NAME(nextArithmeticSensor());
/**
 * Starts the enumeration of arithmetic sensors currently accessible.
 * Use the method YArithmeticSensor.nextArithmeticSensor() to iterate on
 * next arithmetic sensors.
 *
 * @return a pointer to a YArithmeticSensor object, corresponding to
 *         the first arithmetic sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YArithmeticSensor*) FirstArithmeticSensor
NS_SWIFT_NAME(FirstArithmeticSensor());
//--- (end of YArithmeticSensor public methods declaration)

@end

//--- (YArithmeticSensor functions declaration)
/**
 * Retrieves an arithmetic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the arithmetic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YArithmeticSensor.isOnline() to test if the arithmetic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an arithmetic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the arithmetic sensor, for instance
 *         RXUVOLT1.arithmeticSensor1.
 *
 * @return a YArithmeticSensor object allowing you to drive the arithmetic sensor.
 */
YArithmeticSensor* yFindArithmeticSensor(NSString* func);
/**
 * Starts the enumeration of arithmetic sensors currently accessible.
 * Use the method YArithmeticSensor.nextArithmeticSensor() to iterate on
 * next arithmetic sensors.
 *
 * @return a pointer to a YArithmeticSensor object, corresponding to
 *         the first arithmetic sensor currently online, or a nil pointer
 *         if there are none.
 */
YArithmeticSensor* yFirstArithmeticSensor(void);

//--- (end of YArithmeticSensor functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

