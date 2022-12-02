/*********************************************************************
 *
 *  $Id: yocto_genericsensor.h 51903 2022-11-29 17:25:59Z mvuilleu $
 *
 *  Declares yFindGenericSensor(), the high-level API for GenericSensor functions
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

@class YGenericSensor;

//--- (YGenericSensor globals)
typedef void (*YGenericSensorValueCallback)(YGenericSensor *func, NSString *functionValue);
typedef void (*YGenericSensorTimedReportCallback)(YGenericSensor *func, YMeasure *measure);
#ifndef _Y_SIGNALSAMPLING_ENUM
#define _Y_SIGNALSAMPLING_ENUM
typedef enum {
    Y_SIGNALSAMPLING_HIGH_RATE = 0,
    Y_SIGNALSAMPLING_HIGH_RATE_FILTERED = 1,
    Y_SIGNALSAMPLING_LOW_NOISE = 2,
    Y_SIGNALSAMPLING_LOW_NOISE_FILTERED = 3,
    Y_SIGNALSAMPLING_HIGHEST_RATE = 4,
    Y_SIGNALSAMPLING_AC = 5,
    Y_SIGNALSAMPLING_INVALID = -1,
} Y_SIGNALSAMPLING_enum;
#endif
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
#define Y_SIGNALVALUE_INVALID           YAPI_INVALID_DOUBLE
#define Y_SIGNALUNIT_INVALID            YAPI_INVALID_STRING
#define Y_SIGNALRANGE_INVALID           YAPI_INVALID_STRING
#define Y_VALUERANGE_INVALID            YAPI_INVALID_STRING
#define Y_SIGNALBIAS_INVALID            YAPI_INVALID_DOUBLE
//--- (end of YGenericSensor globals)

//--- (YGenericSensor class start)
/**
 * YGenericSensor Class: GenericSensor control interface, available for instance in the
 * Yocto-0-10V-Rx, the Yocto-4-20mA-Rx, the Yocto-Bridge or the Yocto-milliVolt-Rx
 *
 * The YGenericSensor class allows you to read and configure Yoctopuce signal
 * transducers. It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, to access the autonomous datalogger.
 * This class adds the ability to configure the automatic conversion between the
 * measured signal and the corresponding engineering unit.
 */
@interface YGenericSensor : YSensor
//--- (end of YGenericSensor class start)
{
@protected
//--- (YGenericSensor attributes declaration)
    double          _signalValue;
    NSString*       _signalUnit;
    NSString*       _signalRange;
    NSString*       _valueRange;
    double          _signalBias;
    Y_SIGNALSAMPLING_enum _signalSampling;
    Y_ENABLED_enum  _enabled;
    YGenericSensorValueCallback _valueCallbackGenericSensor;
    YGenericSensorTimedReportCallback _timedReportCallbackGenericSensor;
//--- (end of YGenericSensor attributes declaration)
}
// Constructor is protected, use yFindGenericSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YGenericSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YGenericSensor private methods declaration)
//--- (YGenericSensor yapiwrapper declaration)
//--- (end of YGenericSensor yapiwrapper declaration)
//--- (YGenericSensor public methods declaration)
/**
 * Changes the measuring unit for the measured value.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the measured value
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the current value of the electrical signal measured by the sensor.
 *
 * @return a floating point number corresponding to the current value of the electrical signal
 * measured by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALVALUE_INVALID.
 */
-(double)     get_signalValue;


-(double) signalValue;
/**
 * Returns the measuring unit of the electrical signal used by the sensor.
 *
 * @return a string corresponding to the measuring unit of the electrical signal used by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALUNIT_INVALID.
 */
-(NSString*)     get_signalUnit;


-(NSString*) signalUnit;
/**
 * Returns the input signal range used by the sensor.
 *
 * @return a string corresponding to the input signal range used by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALRANGE_INVALID.
 */
-(NSString*)     get_signalRange;


-(NSString*) signalRange;
/**
 * Changes the input signal range used by the sensor.
 * When the input signal gets out of the planned range, the output value
 * will be set to an arbitrary large value, whose sign indicates the direction
 * of the range overrun.
 *
 * For a 4-20mA sensor, the default input signal range is "4...20".
 * For a 0-10V sensor, the default input signal range is "0.1...10".
 * For numeric communication interfaces, the default input signal range is
 * "-999999.999...999999.999".
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the input signal range used by the sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_signalRange:(NSString*) newval;
-(int)     setSignalRange:(NSString*) newval;

/**
 * Returns the physical value range measured by the sensor.
 *
 * @return a string corresponding to the physical value range measured by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.VALUERANGE_INVALID.
 */
-(NSString*)     get_valueRange;


-(NSString*) valueRange;
/**
 * Changes the output value range, corresponding to the physical value measured
 * by the sensor. The default output value range is the same as the input signal
 * range (1:1 mapping), but you can change it so that the function automatically
 * computes the physical value encoded by the input signal. Be aware that, as a
 * side effect, the range modification may automatically modify the display resolution.
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the output value range, corresponding to the physical value measured
 *         by the sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_valueRange:(NSString*) newval;
-(int)     setValueRange:(NSString*) newval;

/**
 * Changes the electric signal bias for zero shift adjustment.
 * If your electric signal reads positive when it should be zero, setup
 * a positive signalBias of the same value to fix the zero shift.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_signalBias:(double) newval;
-(int)     setSignalBias:(double) newval;

/**
 * Returns the electric signal bias for zero shift adjustment.
 * A positive bias means that the signal is over-reporting the measure,
 * while a negative bias means that the signal is under-reporting the measure.
 *
 * @return a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALBIAS_INVALID.
 */
-(double)     get_signalBias;


-(double) signalBias;
/**
 * Returns the electric signal sampling method to use.
 * The HIGH_RATE method uses the highest sampling frequency, without any filtering.
 * The HIGH_RATE_FILTERED method adds a windowed 7-sample median filter.
 * The LOW_NOISE method uses a reduced acquisition frequency to reduce noise.
 * The LOW_NOISE_FILTERED method combines a reduced frequency with the median filter
 * to get measures as stable as possible when working on a noisy signal.
 *
 * @return a value among YGenericSensor.SIGNALSAMPLING_HIGH_RATE,
 * YGenericSensor.SIGNALSAMPLING_HIGH_RATE_FILTERED, YGenericSensor.SIGNALSAMPLING_LOW_NOISE,
 * YGenericSensor.SIGNALSAMPLING_LOW_NOISE_FILTERED, YGenericSensor.SIGNALSAMPLING_HIGHEST_RATE and
 * YGenericSensor.SIGNALSAMPLING_AC corresponding to the electric signal sampling method to use
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALSAMPLING_INVALID.
 */
-(Y_SIGNALSAMPLING_enum)     get_signalSampling;


-(Y_SIGNALSAMPLING_enum) signalSampling;
/**
 * Changes the electric signal sampling method to use.
 * The HIGH_RATE method uses the highest sampling frequency, without any filtering.
 * The HIGH_RATE_FILTERED method adds a windowed 7-sample median filter.
 * The LOW_NOISE method uses a reduced acquisition frequency to reduce noise.
 * The LOW_NOISE_FILTERED method combines a reduced frequency with the median filter
 * to get measures as stable as possible when working on a noisy signal.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a value among YGenericSensor.SIGNALSAMPLING_HIGH_RATE,
 * YGenericSensor.SIGNALSAMPLING_HIGH_RATE_FILTERED, YGenericSensor.SIGNALSAMPLING_LOW_NOISE,
 * YGenericSensor.SIGNALSAMPLING_LOW_NOISE_FILTERED, YGenericSensor.SIGNALSAMPLING_HIGHEST_RATE and
 * YGenericSensor.SIGNALSAMPLING_AC corresponding to the electric signal sampling method to use
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_signalSampling:(Y_SIGNALSAMPLING_enum) newval;
-(int)     setSignalSampling:(Y_SIGNALSAMPLING_enum) newval;

/**
 * Returns the activation state of this input.
 *
 * @return either YGenericSensor.ENABLED_FALSE or YGenericSensor.ENABLED_TRUE, according to the
 * activation state of this input
 *
 * On failure, throws an exception or returns YGenericSensor.ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Changes the activation state of this input. When an input is disabled,
 * its value is no more updated. On some devices, disabling an input can
 * improve the refresh rate of the other active inputs.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YGenericSensor.ENABLED_FALSE or YGenericSensor.ENABLED_TRUE, according to
 * the activation state of this input
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Retrieves a generic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the generic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGenericSensor.isOnline() to test if the generic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a generic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the generic sensor, for instance
 *         RX010V01.genericSensor1.
 *
 * @return a YGenericSensor object allowing you to drive the generic sensor.
 */
+(YGenericSensor*)     FindGenericSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YGenericSensorValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YGenericSensorTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Adjusts the signal bias so that the current signal value is need
 * precisely as zero. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     zeroAdjust;


/**
 * Continues the enumeration of generic sensors started using yFirstGenericSensor().
 * Caution: You can't make any assumption about the returned generic sensors order.
 * If you want to find a specific a generic sensor, use GenericSensor.findGenericSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YGenericSensor object, corresponding to
 *         a generic sensor currently online, or a nil pointer
 *         if there are no more generic sensors to enumerate.
 */
-(nullable YGenericSensor*) nextGenericSensor
NS_SWIFT_NAME(nextGenericSensor());
/**
 * Starts the enumeration of generic sensors currently accessible.
 * Use the method YGenericSensor.nextGenericSensor() to iterate on
 * next generic sensors.
 *
 * @return a pointer to a YGenericSensor object, corresponding to
 *         the first generic sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YGenericSensor*) FirstGenericSensor
NS_SWIFT_NAME(FirstGenericSensor());
//--- (end of YGenericSensor public methods declaration)

@end

//--- (YGenericSensor functions declaration)
/**
 * Retrieves a generic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the generic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGenericSensor.isOnline() to test if the generic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a generic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the generic sensor, for instance
 *         RX010V01.genericSensor1.
 *
 * @return a YGenericSensor object allowing you to drive the generic sensor.
 */
YGenericSensor* yFindGenericSensor(NSString* func);
/**
 * Starts the enumeration of generic sensors currently accessible.
 * Use the method YGenericSensor.nextGenericSensor() to iterate on
 * next generic sensors.
 *
 * @return a pointer to a YGenericSensor object, corresponding to
 *         the first generic sensor currently online, or a nil pointer
 *         if there are none.
 */
YGenericSensor* yFirstGenericSensor(void);

//--- (end of YGenericSensor functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

