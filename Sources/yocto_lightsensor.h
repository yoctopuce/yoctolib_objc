/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindLightSensor(), the high-level API for LightSensor functions
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

@class YLightSensor;

//--- (YLightSensor globals)
typedef void (*YLightSensorValueCallback)(YLightSensor *func, NSString *functionValue);
typedef void (*YLightSensorTimedReportCallback)(YLightSensor *func, YMeasure *measure);
#ifndef _Y_MEASURETYPE_ENUM
#define _Y_MEASURETYPE_ENUM
typedef enum {
    Y_MEASURETYPE_HUMAN_EYE = 0,
    Y_MEASURETYPE_WIDE_SPECTRUM = 1,
    Y_MEASURETYPE_INFRARED = 2,
    Y_MEASURETYPE_HIGH_RATE = 3,
    Y_MEASURETYPE_HIGH_ENERGY = 4,
    Y_MEASURETYPE_HIGH_RESOLUTION = 5,
    Y_MEASURETYPE_INVALID = -1,
} Y_MEASURETYPE_enum;
#endif
//--- (end of YLightSensor globals)

//--- (YLightSensor class start)
/**
 * YLightSensor Class: light sensor control interface, available for instance in the Yocto-Light-V4,
 * the Yocto-Proximity or the Yocto-RangeFinder
 *
 * The YLightSensor class allows you to read and configure Yoctopuce light sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 * This class adds the ability to easily perform a one-point linear calibration
 * to compensate the effect of a glass or filter placed in front of the sensor.
 * For some light sensors with several working modes, this class can select the
 * desired working mode.
 */
@interface YLightSensor : YSensor
//--- (end of YLightSensor class start)
{
@protected
//--- (YLightSensor attributes declaration)
    Y_MEASURETYPE_enum _measureType;
    YLightSensorValueCallback _valueCallbackLightSensor;
    YLightSensorTimedReportCallback _timedReportCallbackLightSensor;
//--- (end of YLightSensor attributes declaration)
}
// Constructor is protected, use yFindLightSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YLightSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YLightSensor private methods declaration)
//--- (YLightSensor yapiwrapper declaration)
//--- (end of YLightSensor yapiwrapper declaration)
//--- (YLightSensor public methods declaration)
-(int)     set_currentValue:(double) newval;
-(int)     setCurrentValue:(double) newval;

/**
 * Changes the sensor-specific calibration parameter so that the current value
 * matches a desired target (linear scaling).
 *
 * @param calibratedVal : the desired target value.
 *
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     calibrate:(double)calibratedVal;

/**
 * Returns the type of light measure.
 *
 * @return a value among YLightSensor.MEASURETYPE_HUMAN_EYE, YLightSensor.MEASURETYPE_WIDE_SPECTRUM,
 * YLightSensor.MEASURETYPE_INFRARED, YLightSensor.MEASURETYPE_HIGH_RATE,
 * YLightSensor.MEASURETYPE_HIGH_ENERGY and YLightSensor.MEASURETYPE_HIGH_RESOLUTION corresponding to
 * the type of light measure
 *
 * On failure, throws an exception or returns YLightSensor.MEASURETYPE_INVALID.
 */
-(Y_MEASURETYPE_enum)     get_measureType;


-(Y_MEASURETYPE_enum) measureType;
/**
 * Changes the light sensor type used in the device. The measure can either
 * approximate the response of the human eye, focus on a specific light
 * spectrum, depending on the capabilities of the light-sensitive cell.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YLightSensor.MEASURETYPE_HUMAN_EYE,
 * YLightSensor.MEASURETYPE_WIDE_SPECTRUM, YLightSensor.MEASURETYPE_INFRARED,
 * YLightSensor.MEASURETYPE_HIGH_RATE, YLightSensor.MEASURETYPE_HIGH_ENERGY and
 * YLightSensor.MEASURETYPE_HIGH_RESOLUTION corresponding to the light sensor type used in the device
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_measureType:(Y_MEASURETYPE_enum) newval;
-(int)     setMeasureType:(Y_MEASURETYPE_enum) newval;

/**
 * Retrieves a light sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the light sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLightSensor.isOnline() to test if the light sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a light sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the light sensor, for instance
 *         LIGHTMK4.lightSensor.
 *
 * @return a YLightSensor object allowing you to drive the light sensor.
 */
+(YLightSensor*)     FindLightSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YLightSensorValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YLightSensorTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of light sensors started using yFirstLightSensor().
 * Caution: You can't make any assumption about the returned light sensors order.
 * If you want to find a specific a light sensor, use LightSensor.findLightSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YLightSensor object, corresponding to
 *         a light sensor currently online, or a nil pointer
 *         if there are no more light sensors to enumerate.
 */
-(nullable YLightSensor*) nextLightSensor
NS_SWIFT_NAME(nextLightSensor());
/**
 * Starts the enumeration of light sensors currently accessible.
 * Use the method YLightSensor.nextLightSensor() to iterate on
 * next light sensors.
 *
 * @return a pointer to a YLightSensor object, corresponding to
 *         the first light sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YLightSensor*) FirstLightSensor
NS_SWIFT_NAME(FirstLightSensor());
//--- (end of YLightSensor public methods declaration)

@end

//--- (YLightSensor functions declaration)
/**
 * Retrieves a light sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the light sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLightSensor.isOnline() to test if the light sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a light sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the light sensor, for instance
 *         LIGHTMK4.lightSensor.
 *
 * @return a YLightSensor object allowing you to drive the light sensor.
 */
YLightSensor* yFindLightSensor(NSString* func);
/**
 * Starts the enumeration of light sensors currently accessible.
 * Use the method YLightSensor.nextLightSensor() to iterate on
 * next light sensors.
 *
 * @return a pointer to a YLightSensor object, corresponding to
 *         the first light sensor currently online, or a nil pointer
 *         if there are none.
 */
YLightSensor* yFirstLightSensor(void);

//--- (end of YLightSensor functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

