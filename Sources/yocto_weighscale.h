/*********************************************************************
 *
 * $Id: yocto_weighscale.h 28207 2017-07-28 16:26:38Z mvuilleu $
 *
 * Declares yFindWeighScale(), the high-level API for WeighScale functions
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

@class YWeighScale;

//--- (YWeighScale globals)
typedef void (*YWeighScaleValueCallback)(YWeighScale *func, NSString *functionValue);
typedef void (*YWeighScaleTimedReportCallback)(YWeighScale *func, YMeasure *measure);
#ifndef _Y_EXCITATION_ENUM
#define _Y_EXCITATION_ENUM
typedef enum {
    Y_EXCITATION_OFF = 0,
    Y_EXCITATION_DC = 1,
    Y_EXCITATION_AC = 2,
    Y_EXCITATION_INVALID = -1,
} Y_EXCITATION_enum;
#endif
#define Y_ADAPTRATIO_INVALID            YAPI_INVALID_DOUBLE
#define Y_COMPTEMPERATURE_INVALID       YAPI_INVALID_DOUBLE
#define Y_COMPENSATION_INVALID          YAPI_INVALID_DOUBLE
#define Y_ZEROTRACKING_INVALID          YAPI_INVALID_DOUBLE
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YWeighScale globals)

//--- (YWeighScale class start)
/**
 * YWeighScale Class: WeighScale function interface
 *
 * The YWeighScale class provides a weight measurement from a ratiometric load cell
 * sensor. It can be used to control the bridge excitation parameters, in order to avoid
 * measure shifts caused by temperature variation in the electronics, and can also
 * automatically apply an additional correction factor based on temperature to
 * compensate for offsets in the load cell itself.
 */
@interface YWeighScale : YSensor
//--- (end of YWeighScale class start)
{
@protected
//--- (YWeighScale attributes declaration)
    Y_EXCITATION_enum _excitation;
    double          _adaptRatio;
    double          _compTemperature;
    double          _compensation;
    double          _zeroTracking;
    NSString*       _command;
    YWeighScaleValueCallback _valueCallbackWeighScale;
    YWeighScaleTimedReportCallback _timedReportCallbackWeighScale;
//--- (end of YWeighScale attributes declaration)
}
// Constructor is protected, use yFindWeighScale factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YWeighScale private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YWeighScale private methods declaration)
//--- (YWeighScale public methods declaration)
/**
 * Returns the current load cell bridge excitation method.
 *
 * @return a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding to the
 * current load cell bridge excitation method
 *
 * On failure, throws an exception or returns Y_EXCITATION_INVALID.
 */
-(Y_EXCITATION_enum)     get_excitation;


-(Y_EXCITATION_enum) excitation;
/**
 * Changes the current load cell bridge excitation method.
 *
 * @param newval : a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding
 * to the current load cell bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_excitation:(Y_EXCITATION_enum) newval;
-(int)     setExcitation:(Y_EXCITATION_enum) newval;

/**
 * Changes the compensation temperature update rate, in percents.
 *
 * @param newval : a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_adaptRatio:(double) newval;
-(int)     setAdaptRatio:(double) newval;

/**
 * Returns the compensation temperature update rate, in percents.
 * the maximal value is 65 percents.
 *
 * @return a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * On failure, throws an exception or returns Y_ADAPTRATIO_INVALID.
 */
-(double)     get_adaptRatio;


-(double) adaptRatio;
/**
 * Returns the current compensation temperature.
 *
 * @return a floating point number corresponding to the current compensation temperature
 *
 * On failure, throws an exception or returns Y_COMPTEMPERATURE_INVALID.
 */
-(double)     get_compTemperature;


-(double) compTemperature;
/**
 * Returns the current current thermal compensation value.
 *
 * @return a floating point number corresponding to the current current thermal compensation value
 *
 * On failure, throws an exception or returns Y_COMPENSATION_INVALID.
 */
-(double)     get_compensation;


-(double) compensation;
/**
 * Changes the compensation temperature update rate, in percents.
 *
 * @param newval : a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_zeroTracking:(double) newval;
-(int)     setZeroTracking:(double) newval;

/**
 * Returns the zero tracking threshold value. When this threshold is larger than
 * zero, any measure under the threshold will automatically be ignored and the
 * zero compensation will be updated.
 *
 * @return a floating point number corresponding to the zero tracking threshold value
 *
 * On failure, throws an exception or returns Y_ZEROTRACKING_INVALID.
 */
-(double)     get_zeroTracking;


-(double) zeroTracking;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a weighing scale sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the weighing scale sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWeighScale.isOnline() to test if the weighing scale sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a weighing scale sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the weighing scale sensor
 *
 * @return a YWeighScale object allowing you to drive the weighing scale sensor.
 */
+(YWeighScale*)     FindWeighScale:(NSString*)func;

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
-(int)     registerValueCallback:(YWeighScaleValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YWeighScaleTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Adapts the load cell signal bias (stored in the corresponding genericSensor)
 * so that the current signal corresponds to a zero weight.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     tare;

/**
 * Configures the load cell span parameters (stored in the corresponding genericSensor)
 * so that the current signal corresponds to the specified reference weight.
 *
 * @param currWeight : reference weight presently on the load cell.
 * @param maxWeight : maximum weight to be expectect on the load cell.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setupSpan:(double)currWeight :(double)maxWeight;

/**
 * Records a weight offset thermal compensation table, in order to automatically correct the
 * measured weight based on the compensation temperature.
 * The weight correction will be applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, corresponding to all
 *         temperatures for which an offset correction is specified.
 * @param compValues : array of floating point numbers, corresponding to the offset correction
 *         to apply for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_offsetCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues;

/**
 * Retrieves the weight offset thermal compensation table previously configured using the
 * set_offsetCompensationTable function.
 * The weight correction is applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, that is filled by the function
 *         with all temperatures for which an offset correction is specified.
 * @param compValues : array of floating point numbers, that is filled by the function
 *         with the offset correction applied for each of the temperature
 *         included in the first argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     loadOffsetCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues;

/**
 * Records a weight span thermal compensation table, in order to automatically correct the
 * measured weight based on the compensation temperature.
 * The weight correction will be applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, corresponding to all
 *         temperatures for which a span correction is specified.
 * @param compValues : array of floating point numbers, corresponding to the span correction
 *         (in percents) to apply for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_spanCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues;

/**
 * Retrieves the weight span thermal compensation table previously configured using the
 * set_spanCompensationTable function.
 * The weight correction is applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, that is filled by the function
 *         with all temperatures for which an span correction is specified.
 * @param compValues : array of floating point numbers, that is filled by the function
 *         with the span correction applied for each of the temperature
 *         included in the first argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     loadSpanCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues;


/**
 * Continues the enumeration of weighing scale sensors started using yFirstWeighScale().
 *
 * @return a pointer to a YWeighScale object, corresponding to
 *         a weighing scale sensor currently online, or a nil pointer
 *         if there are no more weighing scale sensors to enumerate.
 */
-(YWeighScale*) nextWeighScale;
/**
 * Starts the enumeration of weighing scale sensors currently accessible.
 * Use the method YWeighScale.nextWeighScale() to iterate on
 * next weighing scale sensors.
 *
 * @return a pointer to a YWeighScale object, corresponding to
 *         the first weighing scale sensor currently online, or a nil pointer
 *         if there are none.
 */
+(YWeighScale*) FirstWeighScale;
//--- (end of YWeighScale public methods declaration)

@end

//--- (WeighScale functions declaration)
/**
 * Retrieves a weighing scale sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the weighing scale sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWeighScale.isOnline() to test if the weighing scale sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a weighing scale sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the weighing scale sensor
 *
 * @return a YWeighScale object allowing you to drive the weighing scale sensor.
 */
YWeighScale* yFindWeighScale(NSString* func);
/**
 * Starts the enumeration of weighing scale sensors currently accessible.
 * Use the method YWeighScale.nextWeighScale() to iterate on
 * next weighing scale sensors.
 *
 * @return a pointer to a YWeighScale object, corresponding to
 *         the first weighing scale sensor currently online, or a nil pointer
 *         if there are none.
 */
YWeighScale* yFirstWeighScale(void);

//--- (end of WeighScale functions declaration)
CF_EXTERN_C_END

