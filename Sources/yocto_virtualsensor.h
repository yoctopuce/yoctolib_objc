/*********************************************************************
 *
 *  $Id: yocto_virtualsensor.h Fri, 23 Oct 2026 10:30:40 +0000 generated $
 *
 *  Declares yFindVirtualSensor(), the high-level API for VirtualSensor functions
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

@class YVirtualSensor;

//--- (YVirtualSensor globals)
typedef void (*YVirtualSensorValueCallback)(YVirtualSensor *func, NSString *functionValue);
typedef void (*YVirtualSensorTimedReportCallback)(YVirtualSensor *func, YMeasure *measure);
#define Y_INVALIDVALUE_INVALID          YAPI_INVALID_DOUBLE
//--- (end of YVirtualSensor globals)

//--- (YVirtualSensor class start)
/**
 * YVirtualSensor Class: virtual sensor control interface
 *
 * The YVirtualSensor class allows you to use Yoctopuce virtual sensors.
 * These sensors make it possible to show external data collected by the user
 * as a Yoctopuce Sensor. This class inherits from YSensor class the core
 * functions to read measurements, to register callback functions, and to access
 * the autonomous datalogger. It adds the ability to change the sensor value as
 * needed, or to mark current value as invalid.
 */
@interface YVirtualSensor : YSensor
//--- (end of YVirtualSensor class start)
{
@protected
//--- (YVirtualSensor attributes declaration)
    double          _invalidValue;
    YVirtualSensorValueCallback _valueCallbackVirtualSensor;
    YVirtualSensorTimedReportCallback _timedReportCallbackVirtualSensor;
//--- (end of YVirtualSensor attributes declaration)
}
// Constructor is protected, use yFindVirtualSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YVirtualSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YVirtualSensor private methods declaration)
//--- (YVirtualSensor yapiwrapper declaration)
//--- (end of YVirtualSensor yapiwrapper declaration)
//--- (YVirtualSensor public methods declaration)
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
 * Changes the current value of the sensor (raw value, before calibration).
 *
 * @param newval : a floating point number corresponding to the current value of the sensor (raw
 * value, before calibration)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentRawValue:(double) newval;
-(int)     setCurrentRawValue:(double) newval;

-(int)     set_sensorState:(int) newval;
-(int)     setSensorState:(int) newval;

/**
 * Changes the invalid value of the sensor, returned if the sensor is read when in invalid state
 * (for instance before having been set). Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the invalid value of the sensor, returned
 * if the sensor is read when in invalid state
 *         (for instance before having been set)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_invalidValue:(double) newval;
-(int)     setInvalidValue:(double) newval;

/**
 * Returns the invalid value of the sensor, returned if the sensor is read when in invalid state
 * (for instance before having been set).
 *
 * @return a floating point number corresponding to the invalid value of the sensor, returned if the
 * sensor is read when in invalid state
 *         (for instance before having been set)
 *
 * On failure, throws an exception or returns YVirtualSensor.INVALIDVALUE_INVALID.
 */
-(double)     get_invalidValue;


-(double) invalidValue;
/**
 * Retrieves a virtual sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the virtual sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVirtualSensor.isOnline() to test if the virtual sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a virtual sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the virtual sensor, for instance
 *         MyDevice.virtualSensor1.
 *
 * @return a YVirtualSensor object allowing you to drive the virtual sensor.
 */
+(YVirtualSensor*)     FindVirtualSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YVirtualSensorValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YVirtualSensorTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Changes the current sensor state to invalid (as if no value would have been ever set).
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_sensorAsInvalid;


/**
 * Continues the enumeration of virtual sensors started using yFirstVirtualSensor().
 * Caution: You can't make any assumption about the returned virtual sensors order.
 * If you want to find a specific a virtual sensor, use VirtualSensor.findVirtualSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YVirtualSensor object, corresponding to
 *         a virtual sensor currently online, or a nil pointer
 *         if there are no more virtual sensors to enumerate.
 */
-(nullable YVirtualSensor*) nextVirtualSensor
NS_SWIFT_NAME(nextVirtualSensor());
/**
 * Starts the enumeration of virtual sensors currently accessible.
 * Use the method YVirtualSensor.nextVirtualSensor() to iterate on
 * next virtual sensors.
 *
 * @return a pointer to a YVirtualSensor object, corresponding to
 *         the first virtual sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YVirtualSensor*) FirstVirtualSensor
NS_SWIFT_NAME(FirstVirtualSensor());
//--- (end of YVirtualSensor public methods declaration)

@end

//--- (YVirtualSensor functions declaration)
/**
 * Retrieves a virtual sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the virtual sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVirtualSensor.isOnline() to test if the virtual sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a virtual sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the virtual sensor, for instance
 *         MyDevice.virtualSensor1.
 *
 * @return a YVirtualSensor object allowing you to drive the virtual sensor.
 */
YVirtualSensor* yFindVirtualSensor(NSString* func);
/**
 * Starts the enumeration of virtual sensors currently accessible.
 * Use the method YVirtualSensor.nextVirtualSensor() to iterate on
 * next virtual sensors.
 *
 * @return a pointer to a YVirtualSensor object, corresponding to
 *         the first virtual sensor currently online, or a nil pointer
 *         if there are none.
 */
YVirtualSensor* yFirstVirtualSensor(void);

//--- (end of YVirtualSensor functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

