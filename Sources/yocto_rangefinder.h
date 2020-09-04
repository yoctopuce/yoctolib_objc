/*********************************************************************
 *
 *  $Id: yocto_rangefinder.h 41625 2020-08-31 07:09:39Z seb $
 *
 *  Declares yFindRangeFinder(), the high-level API for RangeFinder functions
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

@class YRangeFinder;

//--- (YRangeFinder globals)
typedef void (*YRangeFinderValueCallback)(YRangeFinder *func, NSString *functionValue);
typedef void (*YRangeFinderTimedReportCallback)(YRangeFinder *func, YMeasure *measure);
#ifndef _Y_RANGEFINDERMODE_ENUM
#define _Y_RANGEFINDERMODE_ENUM
typedef enum {
    Y_RANGEFINDERMODE_DEFAULT = 0,
    Y_RANGEFINDERMODE_LONG_RANGE = 1,
    Y_RANGEFINDERMODE_HIGH_ACCURACY = 2,
    Y_RANGEFINDERMODE_HIGH_SPEED = 3,
    Y_RANGEFINDERMODE_INVALID = -1,
} Y_RANGEFINDERMODE_enum;
#endif
#define Y_TIMEFRAME_INVALID             YAPI_INVALID_LONG
#define Y_QUALITY_INVALID               YAPI_INVALID_UINT
#define Y_HARDWARECALIBRATION_INVALID   YAPI_INVALID_STRING
#define Y_CURRENTTEMPERATURE_INVALID    YAPI_INVALID_DOUBLE
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YRangeFinder globals)

//--- (YRangeFinder class start)
/**
 * YRangeFinder Class: range finder control interface, available for instance in the Yocto-RangeFinder
 *
 * The YRangeFinder class allows you to read and configure Yoctopuce range finders.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 * This class adds the ability to easily perform a one-point linear calibration
 * to compensate the effect of a glass or filter placed in front of the sensor.
 */
@interface YRangeFinder : YSensor
//--- (end of YRangeFinder class start)
{
@protected
//--- (YRangeFinder attributes declaration)
    Y_RANGEFINDERMODE_enum _rangeFinderMode;
    s64             _timeFrame;
    int             _quality;
    NSString*       _hardwareCalibration;
    double          _currentTemperature;
    NSString*       _command;
    YRangeFinderValueCallback _valueCallbackRangeFinder;
    YRangeFinderTimedReportCallback _timedReportCallbackRangeFinder;
//--- (end of YRangeFinder attributes declaration)
}
// Constructor is protected, use yFindRangeFinder factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YRangeFinder private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YRangeFinder private methods declaration)
//--- (YRangeFinder yapiwrapper declaration)
//--- (end of YRangeFinder yapiwrapper declaration)
//--- (YRangeFinder public methods declaration)
/**
 * Changes the measuring unit for the measured range. That unit is a string.
 * String value can be " or mm. Any other value is ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * WARNING: if a specific calibration is defined for the rangeFinder function, a
 * unit system change will probably break it.
 *
 * @param newval : a string corresponding to the measuring unit for the measured range
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the range finder running mode. The rangefinder running mode
 * allows you to put priority on precision, speed or maximum range.
 *
 * @return a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the range finder running mode
 *
 * On failure, throws an exception or returns Y_RANGEFINDERMODE_INVALID.
 */
-(Y_RANGEFINDERMODE_enum)     get_rangeFinderMode;


-(Y_RANGEFINDERMODE_enum) rangeFinderMode;
/**
 * Changes the rangefinder running mode, allowing you to put priority on
 * precision, speed or maximum range.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder
 * running mode, allowing you to put priority on
 *         precision, speed or maximum range
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rangeFinderMode:(Y_RANGEFINDERMODE_enum) newval;
-(int)     setRangeFinderMode:(Y_RANGEFINDERMODE_enum) newval;

/**
 * Returns the time frame used to measure the distance and estimate the measure
 * reliability. The time frame is expressed in milliseconds.
 *
 * @return an integer corresponding to the time frame used to measure the distance and estimate the measure
 *         reliability
 *
 * On failure, throws an exception or returns Y_TIMEFRAME_INVALID.
 */
-(s64)     get_timeFrame;


-(s64) timeFrame;
/**
 * Changes the time frame used to measure the distance and estimate the measure
 * reliability. The time frame is expressed in milliseconds. A larger timeframe
 * improves stability and reliability, at the cost of higher latency, but prevents
 * the detection of events shorter than the time frame.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the time frame used to measure the distance and estimate the measure
 *         reliability
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_timeFrame:(s64) newval;
-(int)     setTimeFrame:(s64) newval;

/**
 * Returns a measure quality estimate, based on measured dispersion.
 *
 * @return an integer corresponding to a measure quality estimate, based on measured dispersion
 *
 * On failure, throws an exception or returns Y_QUALITY_INVALID.
 */
-(int)     get_quality;


-(int) quality;
-(NSString*)     get_hardwareCalibration;


-(NSString*) hardwareCalibration;
-(int)     set_hardwareCalibration:(NSString*) newval;
-(int)     setHardwareCalibration:(NSString*) newval;

/**
 * Returns the current sensor temperature, as a floating point number.
 *
 * @return a floating point number corresponding to the current sensor temperature, as a floating point number
 *
 * On failure, throws an exception or returns Y_CURRENTTEMPERATURE_INVALID.
 */
-(double)     get_currentTemperature;


-(double) currentTemperature;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a range finder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the range finder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRangeFinder.isOnline() to test if the range finder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a range finder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the range finder, for instance
 *         YRNGFND1.rangeFinder1.
 *
 * @return a YRangeFinder object allowing you to drive the range finder.
 */
+(YRangeFinder*)     FindRangeFinder:(NSString*)func;

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
-(int)     registerValueCallback:(YRangeFinderValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YRangeFinderTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Returns the temperature at the time when the latest calibration was performed.
 * This function can be used to determine if a new calibration for ambient temperature
 * is required.
 *
 * @return a temperature, as a floating point number.
 *         On failure, throws an exception or return YAPI_INVALID_DOUBLE.
 */
-(double)     get_hardwareCalibrationTemperature;

/**
 * Triggers a sensor calibration according to the current ambient temperature. That
 * calibration process needs no physical interaction with the sensor. It is performed
 * automatically at device startup, but it is recommended to start it again when the
 * temperature delta since the latest calibration exceeds 8°C.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerTemperatureCalibration;

/**
 * Triggers the photon detector hardware calibration.
 * This function is part of the calibration procedure to compensate for the the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerSpadCalibration;

/**
 * Triggers the hardware offset calibration of the distance sensor.
 * This function is part of the calibration procedure to compensate for the the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @param targetDist : true distance of the calibration target, in mm or inches, depending
 *         on the unit selected in the device
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerOffsetCalibration:(double)targetDist;

/**
 * Triggers the hardware cross-talk calibration of the distance sensor.
 * This function is part of the calibration procedure to compensate for the the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @param targetDist : true distance of the calibration target, in mm or inches, depending
 *         on the unit selected in the device
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerXTalkCalibration:(double)targetDist;

/**
 * Cancels the effect of previous hardware calibration procedures to compensate
 * for cover glass, and restores factory settings.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     cancelCoverGlassCalibrations;


/**
 * Continues the enumeration of range finders started using yFirstRangeFinder().
 * Caution: You can't make any assumption about the returned range finders order.
 * If you want to find a specific a range finder, use RangeFinder.findRangeFinder()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         a range finder currently online, or a nil pointer
 *         if there are no more range finders to enumerate.
 */
-(nullable YRangeFinder*) nextRangeFinder
NS_SWIFT_NAME(nextRangeFinder());
/**
 * Starts the enumeration of range finders currently accessible.
 * Use the method YRangeFinder.nextRangeFinder() to iterate on
 * next range finders.
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         the first range finder currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YRangeFinder*) FirstRangeFinder
NS_SWIFT_NAME(FirstRangeFinder());
//--- (end of YRangeFinder public methods declaration)

@end

//--- (YRangeFinder functions declaration)
/**
 * Retrieves a range finder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the range finder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRangeFinder.isOnline() to test if the range finder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a range finder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the range finder, for instance
 *         YRNGFND1.rangeFinder1.
 *
 * @return a YRangeFinder object allowing you to drive the range finder.
 */
YRangeFinder* yFindRangeFinder(NSString* func);
/**
 * Starts the enumeration of range finders currently accessible.
 * Use the method YRangeFinder.nextRangeFinder() to iterate on
 * next range finders.
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         the first range finder currently online, or a nil pointer
 *         if there are none.
 */
YRangeFinder* yFirstRangeFinder(void);

//--- (end of YRangeFinder functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

