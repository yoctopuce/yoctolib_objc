/*********************************************************************
 *
 * $Id: yocto_magnetometer.h 31436 2018-08-07 15:28:18Z seb $
 *
 * Declares yFindMagnetometer(), the high-level API for Magnetometer functions
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

@class YMagnetometer;

//--- (YMagnetometer globals)
typedef void (*YMagnetometerValueCallback)(YMagnetometer *func, NSString *functionValue);
typedef void (*YMagnetometerTimedReportCallback)(YMagnetometer *func, YMeasure *measure);
#define Y_BANDWIDTH_INVALID             YAPI_INVALID_INT
#define Y_XVALUE_INVALID                YAPI_INVALID_DOUBLE
#define Y_YVALUE_INVALID                YAPI_INVALID_DOUBLE
#define Y_ZVALUE_INVALID                YAPI_INVALID_DOUBLE
//--- (end of YMagnetometer globals)

//--- (YMagnetometer class start)
/**
 * YMagnetometer Class: Magnetometer function interface
 *
 * The YSensor class is the parent class for all Yoctopuce sensors. It can be
 * used to read the current value and unit of any sensor, read the min/max
 * value, configure autonomous recording frequency and access recorded data.
 * It also provide a function to register a callback invoked each time the
 * observed value changes, or at a predefined interval. Using this class rather
 * than a specific subclass makes it possible to create generic applications
 * that work with any Yoctopuce sensor, even those that do not yet exist.
 * Note: The YAnButton class is the only analog input which does not inherit
 * from YSensor.
 */
@interface YMagnetometer : YSensor
//--- (end of YMagnetometer class start)
{
@protected
//--- (YMagnetometer attributes declaration)
    int             _bandwidth;
    double          _xValue;
    double          _yValue;
    double          _zValue;
    YMagnetometerValueCallback _valueCallbackMagnetometer;
    YMagnetometerTimedReportCallback _timedReportCallbackMagnetometer;
//--- (end of YMagnetometer attributes declaration)
}
// Constructor is protected, use yFindMagnetometer factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YMagnetometer private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YMagnetometer private methods declaration)
//--- (YMagnetometer yapiwrapper declaration)
//--- (end of YMagnetometer yapiwrapper declaration)
//--- (YMagnetometer public methods declaration)
/**
 * Returns the measure update frequency, measured in Hz (Yocto-3D-V2 only).
 *
 * @return an integer corresponding to the measure update frequency, measured in Hz (Yocto-3D-V2 only)
 *
 * On failure, throws an exception or returns Y_BANDWIDTH_INVALID.
 */
-(int)     get_bandwidth;


-(int) bandwidth;
/**
 * Changes the measure update frequency, measured in Hz (Yocto-3D-V2 only). When the
 * frequency is lower, the device performs averaging.
 *
 * @param newval : an integer corresponding to the measure update frequency, measured in Hz (Yocto-3D-V2 only)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bandwidth:(int) newval;
-(int)     setBandwidth:(int) newval;

/**
 * Returns the X component of the magnetic field, as a floating point number.
 *
 * @return a floating point number corresponding to the X component of the magnetic field, as a
 * floating point number
 *
 * On failure, throws an exception or returns Y_XVALUE_INVALID.
 */
-(double)     get_xValue;


-(double) xValue;
/**
 * Returns the Y component of the magnetic field, as a floating point number.
 *
 * @return a floating point number corresponding to the Y component of the magnetic field, as a
 * floating point number
 *
 * On failure, throws an exception or returns Y_YVALUE_INVALID.
 */
-(double)     get_yValue;


-(double) yValue;
/**
 * Returns the Z component of the magnetic field, as a floating point number.
 *
 * @return a floating point number corresponding to the Z component of the magnetic field, as a
 * floating point number
 *
 * On failure, throws an exception or returns Y_ZVALUE_INVALID.
 */
-(double)     get_zValue;


-(double) zValue;
/**
 * Retrieves a magnetometer for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the magnetometer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMagnetometer.isOnline() to test if the magnetometer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a magnetometer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the magnetometer
 *
 * @return a YMagnetometer object allowing you to drive the magnetometer.
 */
+(YMagnetometer*)     FindMagnetometer:(NSString*)func;

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
-(int)     registerValueCallback:(YMagnetometerValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YMagnetometerTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of magnetometers started using yFirstMagnetometer().
 *
 * @return a pointer to a YMagnetometer object, corresponding to
 *         a magnetometer currently online, or a nil pointer
 *         if there are no more magnetometers to enumerate.
 */
-(YMagnetometer*) nextMagnetometer;
/**
 * Starts the enumeration of magnetometers currently accessible.
 * Use the method YMagnetometer.nextMagnetometer() to iterate on
 * next magnetometers.
 *
 * @return a pointer to a YMagnetometer object, corresponding to
 *         the first magnetometer currently online, or a nil pointer
 *         if there are none.
 */
+(YMagnetometer*) FirstMagnetometer;
//--- (end of YMagnetometer public methods declaration)

@end

//--- (YMagnetometer functions declaration)
/**
 * Retrieves a magnetometer for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the magnetometer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMagnetometer.isOnline() to test if the magnetometer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a magnetometer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the magnetometer
 *
 * @return a YMagnetometer object allowing you to drive the magnetometer.
 */
YMagnetometer* yFindMagnetometer(NSString* func);
/**
 * Starts the enumeration of magnetometers currently accessible.
 * Use the method YMagnetometer.nextMagnetometer() to iterate on
 * next magnetometers.
 *
 * @return a pointer to a YMagnetometer object, corresponding to
 *         the first magnetometer currently online, or a nil pointer
 *         if there are none.
 */
YMagnetometer* yFirstMagnetometer(void);

//--- (end of YMagnetometer functions declaration)
CF_EXTERN_C_END

