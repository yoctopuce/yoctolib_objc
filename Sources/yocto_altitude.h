/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindAltitude(), the high-level API for Altitude functions
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

@class YAltitude;

//--- (YAltitude globals)
typedef void (*YAltitudeValueCallback)(YAltitude *func, NSString *functionValue);
typedef void (*YAltitudeTimedReportCallback)(YAltitude *func, YMeasure *measure);
#define Y_QNH_INVALID                   YAPI_INVALID_DOUBLE
#define Y_TECHNOLOGY_INVALID            YAPI_INVALID_STRING
//--- (end of YAltitude globals)

//--- (YAltitude class start)
/**
 * YAltitude Class: altimeter control interface, available for instance in the Yocto-Altimeter-V2 or
 * the Yocto-GPS-V2
 *
 * The YAltitude class allows you to read and configure Yoctopuce altimeters.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 * This class adds the ability to configure the barometric pressure adjusted to
 * sea level (QNH) for barometric sensors.
 */
@interface YAltitude : YSensor
//--- (end of YAltitude class start)
{
@protected
//--- (YAltitude attributes declaration)
    double          _qnh;
    NSString*       _technology;
    YAltitudeValueCallback _valueCallbackAltitude;
    YAltitudeTimedReportCallback _timedReportCallbackAltitude;
//--- (end of YAltitude attributes declaration)
}
// Constructor is protected, use yFindAltitude factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YAltitude private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YAltitude private methods declaration)
//--- (YAltitude yapiwrapper declaration)
//--- (end of YAltitude yapiwrapper declaration)
//--- (YAltitude public methods declaration)
/**
 * Changes the current estimated altitude. This allows one to compensate for
 * ambient pressure variations and to work in relative mode.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the current estimated altitude
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentValue:(double) newval;
-(int)     setCurrentValue:(double) newval;

/**
 * Changes the barometric pressure adjusted to sea level used to compute
 * the altitude (QNH). This enables you to compensate for atmospheric pressure
 * changes due to weather conditions. Applicable to barometric altimeters only.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the barometric pressure adjusted to sea
 * level used to compute
 *         the altitude (QNH)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_qnh:(double) newval;
-(int)     setQnh:(double) newval;

/**
 * Returns the barometric pressure adjusted to sea level used to compute
 * the altitude (QNH). Applicable to barometric altimeters only.
 *
 * @return a floating point number corresponding to the barometric pressure adjusted to sea level used to compute
 *         the altitude (QNH)
 *
 * On failure, throws an exception or returns YAltitude.QNH_INVALID.
 */
-(double)     get_qnh;


-(double) qnh;
/**
 * Returns the technology used by the sesnor to compute
 * altitude. Possibles values are  "barometric" and "gps"
 *
 * @return a string corresponding to the technology used by the sesnor to compute
 *         altitude
 *
 * On failure, throws an exception or returns YAltitude.TECHNOLOGY_INVALID.
 */
-(NSString*)     get_technology;


-(NSString*) technology;
/**
 * Retrieves an altimeter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the altimeter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAltitude.isOnline() to test if the altimeter is
 * indeed online at a given time. In case of ambiguity when looking for
 * an altimeter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the altimeter, for instance
 *         YALTIMK2.altitude.
 *
 * @return a YAltitude object allowing you to drive the altimeter.
 */
+(YAltitude*)     FindAltitude:(NSString*)func;

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
-(int)     registerValueCallback:(YAltitudeValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YAltitudeTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of altimeters started using yFirstAltitude().
 * Caution: You can't make any assumption about the returned altimeters order.
 * If you want to find a specific an altimeter, use Altitude.findAltitude()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YAltitude object, corresponding to
 *         an altimeter currently online, or a nil pointer
 *         if there are no more altimeters to enumerate.
 */
-(nullable YAltitude*) nextAltitude
NS_SWIFT_NAME(nextAltitude());
/**
 * Starts the enumeration of altimeters currently accessible.
 * Use the method YAltitude.nextAltitude() to iterate on
 * next altimeters.
 *
 * @return a pointer to a YAltitude object, corresponding to
 *         the first altimeter currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YAltitude*) FirstAltitude
NS_SWIFT_NAME(FirstAltitude());
//--- (end of YAltitude public methods declaration)

@end

//--- (YAltitude functions declaration)
/**
 * Retrieves an altimeter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the altimeter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAltitude.isOnline() to test if the altimeter is
 * indeed online at a given time. In case of ambiguity when looking for
 * an altimeter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the altimeter, for instance
 *         YALTIMK2.altitude.
 *
 * @return a YAltitude object allowing you to drive the altimeter.
 */
YAltitude* yFindAltitude(NSString* func);
/**
 * Starts the enumeration of altimeters currently accessible.
 * Use the method YAltitude.nextAltitude() to iterate on
 * next altimeters.
 *
 * @return a pointer to a YAltitude object, corresponding to
 *         the first altimeter currently online, or a nil pointer
 *         if there are none.
 */
YAltitude* yFirstAltitude(void);

//--- (end of YAltitude functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

