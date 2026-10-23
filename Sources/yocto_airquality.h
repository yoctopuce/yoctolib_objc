/*********************************************************************
 *
 *  $Id: yocto_airquality.h Fri, 23 Oct 2026 10:30:35 +0000 generated $
 *
 *  Declares yFindAirQuality(), the high-level API for AirQuality functions
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

@class YAirQuality;

//--- (YAirQuality globals)
typedef void (*YAirQualityValueCallback)(YAirQuality *func, NSString *functionValue);
typedef void (*YAirQualityTimedReportCallback)(YAirQuality *func, YMeasure *measure);
#ifndef _Y_AQIMODE_ENUM
#define _Y_AQIMODE_ENUM
typedef enum {
    Y_AQIMODE_RELATIVE = 0,
    Y_AQIMODE_UBA = 1,
    Y_AQIMODE_INVALID = -1,
} Y_AQIMODE_enum;
#endif
#define Y_UBAINDEX_INVALID              YAPI_INVALID_DOUBLE
#define Y_RELATIVEINDEX_INVALID         YAPI_INVALID_DOUBLE
//--- (end of YAirQuality globals)

//--- (YAirQuality class start)
/**
 * YAirQuality Class: air quality sensor control interface
 *
 * The YAirQuality class allows you to read and configure Yoctopuce air quality sensors.
 * It inherits from the YSensor class the core functions to read measures,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YAirQuality : YSensor
//--- (end of YAirQuality class start)
{
@protected
//--- (YAirQuality attributes declaration)
    double          _ubaIndex;
    double          _relativeIndex;
    Y_AQIMODE_enum  _aqiMode;
    YAirQualityValueCallback _valueCallbackAirQuality;
    YAirQualityTimedReportCallback _timedReportCallbackAirQuality;
//--- (end of YAirQuality attributes declaration)
}
// Constructor is protected, use yFindAirQuality factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YAirQuality private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YAirQuality private methods declaration)
//--- (YAirQuality yapiwrapper declaration)
//--- (end of YAirQuality yapiwrapper declaration)
//--- (YAirQuality public methods declaration)
/**
 * Returns the current air quality index, according to UBA (from 1 to 5).
 *
 * @return a floating point number corresponding to the current air quality index, according to UBA (from 1 to 5)
 *
 * On failure, throws an exception or returns YAirQuality.UBAINDEX_INVALID.
 */
-(double)     get_ubaIndex;


-(double) ubaIndex;
/**
 * Returns the relative air quality index, according to ScioSense (from 0 to 500).
 * A value below 100 indicates better-than-average air quality compared to the past 24 hours,
 * while a value above 100 indicates poorer-than-average air quality compared to the past 24 hours.
 *
 * @return a floating point number corresponding to the relative air quality index, according to
 * ScioSense (from 0 to 500)
 *
 * On failure, throws an exception or returns YAirQuality.RELATIVEINDEX_INVALID.
 */
-(double)     get_relativeIndex;


-(double) relativeIndex;
/**
 * Returns the type of index reported by the get_currentValue function and callbacks (UBA index or relative index).
 *
 * @return either YAirQuality.AQIMODE_RELATIVE or YAirQuality.AQIMODE_UBA, according to the type of
 * index reported by the get_currentValue function and callbacks (UBA index or relative index)
 *
 * On failure, throws an exception or returns YAirQuality.AQIMODE_INVALID.
 */
-(Y_AQIMODE_enum)     get_aqiMode;


-(Y_AQIMODE_enum) aqiMode;
/**
 * Changes the the type of index reported by the get_currentValue function and callbacks (UBA index or
 * relative index).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YAirQuality.AQIMODE_RELATIVE or YAirQuality.AQIMODE_UBA, according to the
 * the type of index reported by the get_currentValue function and callbacks (UBA index or relative index)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_aqiMode:(Y_AQIMODE_enum) newval;
-(int)     setAqiMode:(Y_AQIMODE_enum) newval;

/**
 * Retrieves an air quality sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the air quality sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAirQuality.isOnline() to test if the air quality sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an air quality sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the air quality sensor, for instance
 *         MyDevice.airQuality.
 *
 * @return a YAirQuality object allowing you to drive the air quality sensor.
 */
+(YAirQuality*)     FindAirQuality:(NSString*)func;

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is then invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness,
 * remember to call one of these two functions periodically. The callback is called once juste after beeing
 * registered, passing the current advertised value  of the function, provided that it is not an empty string.
 * To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerValueCallback:(YAirQualityValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YAirQualityTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of air quality sensors started using yFirstAirQuality().
 * Caution: You can't make any assumption about the returned air quality sensors order.
 * If you want to find a specific an air quality sensor, use AirQuality.findAirQuality()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YAirQuality object, corresponding to
 *         an air quality sensor currently online, or a nil pointer
 *         if there are no more air quality sensors to enumerate.
 */
-(nullable YAirQuality*) nextAirQuality
NS_SWIFT_NAME(nextAirQuality());
/**
 * Starts the enumeration of air quality sensors currently accessible.
 * Use the method YAirQuality.nextAirQuality() to iterate on
 * next air quality sensors.
 *
 * @return a pointer to a YAirQuality object, corresponding to
 *         the first air quality sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YAirQuality*) FirstAirQuality
NS_SWIFT_NAME(FirstAirQuality());
//--- (end of YAirQuality public methods declaration)

@end

//--- (YAirQuality functions declaration)
/**
 * Retrieves an air quality sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the air quality sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAirQuality.isOnline() to test if the air quality sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an air quality sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the air quality sensor, for instance
 *         MyDevice.airQuality.
 *
 * @return a YAirQuality object allowing you to drive the air quality sensor.
 */
YAirQuality* yFindAirQuality(NSString* func);
/**
 * Starts the enumeration of air quality sensors currently accessible.
 * Use the method YAirQuality.nextAirQuality() to iterate on
 * next air quality sensors.
 *
 * @return a pointer to a YAirQuality object, corresponding to
 *         the first air quality sensor currently online, or a nil pointer
 *         if there are none.
 */
YAirQuality* yFirstAirQuality(void);

//--- (end of YAirQuality functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

