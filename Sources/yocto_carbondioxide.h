/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindCarbonDioxide(), the high-level API for CarbonDioxide functions
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

@class YCarbonDioxide;

//--- (YCarbonDioxide globals)
typedef void (*YCarbonDioxideValueCallback)(YCarbonDioxide *func, NSString *functionValue);
typedef void (*YCarbonDioxideTimedReportCallback)(YCarbonDioxide *func, YMeasure *measure);
#define Y_ABCPERIOD_INVALID             YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YCarbonDioxide globals)

//--- (YCarbonDioxide class start)
/**
 * YCarbonDioxide Class: CO2 sensor control interface, available for instance in the Yocto-CO2-V2
 *
 * The YCarbonDioxide class allows you to read and configure Yoctopuce CO2 sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 * This class adds the ability to perform manual calibration if required.
 */
@interface YCarbonDioxide : YSensor
//--- (end of YCarbonDioxide class start)
{
@protected
//--- (YCarbonDioxide attributes declaration)
    int             _abcPeriod;
    NSString*       _command;
    YCarbonDioxideValueCallback _valueCallbackCarbonDioxide;
    YCarbonDioxideTimedReportCallback _timedReportCallbackCarbonDioxide;
//--- (end of YCarbonDioxide attributes declaration)
}
// Constructor is protected, use yFindCarbonDioxide factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YCarbonDioxide private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YCarbonDioxide private methods declaration)
//--- (YCarbonDioxide yapiwrapper declaration)
//--- (end of YCarbonDioxide yapiwrapper declaration)
//--- (YCarbonDioxide public methods declaration)
/**
 * Returns the Automatic Baseline Calibration period, in hours. A negative value
 * means that automatic baseline calibration is disabled.
 *
 * @return an integer corresponding to the Automatic Baseline Calibration period, in hours
 *
 * On failure, throws an exception or returns YCarbonDioxide.ABCPERIOD_INVALID.
 */
-(int)     get_abcPeriod;


-(int) abcPeriod;
/**
 * Changes Automatic Baseline Calibration period, in hours. If you need
 * to disable automatic baseline calibration (for instance when using the
 * sensor in an environment that is constantly above 400 ppm CO2), set the
 * period to -1. For the Yocto-CO2-V2, the only possible values are 24 and -1.
 * Remember to call the saveToFlash() method of the
 * module if the modification must be kept.
 *
 * @param newval : an integer corresponding to Automatic Baseline Calibration period, in hours
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_abcPeriod:(int) newval;
-(int)     setAbcPeriod:(int) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a CO2 sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the CO2 sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCarbonDioxide.isOnline() to test if the CO2 sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a CO2 sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the CO2 sensor, for instance
 *         YCO2MK02.carbonDioxide.
 *
 * @return a YCarbonDioxide object allowing you to drive the CO2 sensor.
 */
+(YCarbonDioxide*)     FindCarbonDioxide:(NSString*)func;

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
-(int)     registerValueCallback:(YCarbonDioxideValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YCarbonDioxideTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Triggers a forced calibration of the sensor at a given CO2 level, specified
 * between 400ppm and 2000ppm. Before invoking this command, the sensor must
 * have been maintained within the specified CO2 density during at least two
 * minutes.
 *
 * @param refVal : reference CO2 density for the calibration
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerForcedCalibration:(double)refVal;

/**
 * Triggers a baseline calibration at standard CO2 ambiant level (400ppm).
 * It is normally not necessary to manually calibrate the sensor, because
 * the built-in automatic baseline calibration procedure will automatically
 * fix any long-term drift based on the lowest level of CO2 observed over the
 * automatic calibration period. However, if automatic baseline calibration
 * is disabled, you may want to manually trigger a calibration from time to
 * time. Before starting a baseline calibration, make sure to put the sensor
 * in a standard environment (e.g. outside in fresh air) at around 400 ppm
 * for at least two minutes.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerBaselineCalibration;

-(int)     triggetBaselineCalibration;

/**
 * Triggers a zero calibration of the sensor on carbon dioxide-free air -
 * for use with first generation Yocto-CO2 only.
 * It is normally not necessary to manually calibrate the sensor, because
 * the built-in automatic baseline calibration procedure will automatically
 * fix any long-term drift based on the lowest level of CO2 observed over the
 * automatic calibration period. However, if you disable automatic baseline
 * calibration, you may want to manually trigger a calibration from time to
 * time. Before starting a zero calibration, you should circulate carbon
 * dioxide-free air within the sensor for a minute or two, using a small pipe
 * connected to the sensor. Please contact support@yoctopuce.com for more details
 * on the zero calibration procedure.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerZeroCalibration;

-(int)     triggetZeroCalibration;


/**
 * Continues the enumeration of CO2 sensors started using yFirstCarbonDioxide().
 * Caution: You can't make any assumption about the returned CO2 sensors order.
 * If you want to find a specific a CO2 sensor, use CarbonDioxide.findCarbonDioxide()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YCarbonDioxide object, corresponding to
 *         a CO2 sensor currently online, or a nil pointer
 *         if there are no more CO2 sensors to enumerate.
 */
-(nullable YCarbonDioxide*) nextCarbonDioxide
NS_SWIFT_NAME(nextCarbonDioxide());
/**
 * Starts the enumeration of CO2 sensors currently accessible.
 * Use the method YCarbonDioxide.nextCarbonDioxide() to iterate on
 * next CO2 sensors.
 *
 * @return a pointer to a YCarbonDioxide object, corresponding to
 *         the first CO2 sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YCarbonDioxide*) FirstCarbonDioxide
NS_SWIFT_NAME(FirstCarbonDioxide());
//--- (end of YCarbonDioxide public methods declaration)

@end

//--- (YCarbonDioxide functions declaration)
/**
 * Retrieves a CO2 sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the CO2 sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCarbonDioxide.isOnline() to test if the CO2 sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a CO2 sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the CO2 sensor, for instance
 *         YCO2MK02.carbonDioxide.
 *
 * @return a YCarbonDioxide object allowing you to drive the CO2 sensor.
 */
YCarbonDioxide* yFindCarbonDioxide(NSString* func);
/**
 * Starts the enumeration of CO2 sensors currently accessible.
 * Use the method YCarbonDioxide.nextCarbonDioxide() to iterate on
 * next CO2 sensors.
 *
 * @return a pointer to a YCarbonDioxide object, corresponding to
 *         the first CO2 sensor currently online, or a nil pointer
 *         if there are none.
 */
YCarbonDioxide* yFirstCarbonDioxide(void);

//--- (end of YCarbonDioxide functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

