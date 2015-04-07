/*********************************************************************
 *
 * $Id: yocto_gyro.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindGyro(), the high-level API for Gyro functions
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


@class YQt;

//--- (generated code: YQt globals)
typedef void (*YQtValueCallback)(YQt *func, NSString *functionValue);
typedef void (*YQtTimedReportCallback)(YQt *func, YMeasure *measure);
//--- (end of generated code: YQt globals)

//--- (generated code: YQt class start)
/**
 * YQt Class: Quaternion interface
 *
 * The Yoctopuce API YQt class provides direct access to the Yocto3D attitude estimation
 * using a quaternion. It is usually not needed to use the YQt class directly, as the
 * YGyro class provides a more convenient higher-level interface.
 */
@interface YQt : YSensor
//--- (end of generated code: YQt class start)
{
@protected
//--- (generated code: YQt attributes declaration)
    YQtValueCallback _valueCallbackQt;
    YQtTimedReportCallback _timedReportCallbackQt;
//--- (end of generated code: YQt attributes declaration)
}
// Constructor is protected, use yFindQt factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YQt private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YQt private methods declaration)
//--- (generated code: YQt public methods declaration)
/**
 * Retrieves a quaternion component for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quaternion component is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQt.isOnline() to test if the quaternion component is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quaternion component by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the quaternion component
 *
 * @return a YQt object allowing you to drive the quaternion component.
 */
+(YQt*)     FindQt:(NSString*)func;

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerValueCallback:(YQtValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerTimedReportCallback:(YQtTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of quaternion components started using yFirstQt().
 *
 * @return a pointer to a YQt object, corresponding to
 *         a quaternion component currently online, or a null pointer
 *         if there are no more quaternion components to enumerate.
 */
-(YQt*) nextQt;
/**
 * Starts the enumeration of quaternion components currently accessible.
 * Use the method YQt.nextQt() to iterate on
 * next quaternion components.
 *
 * @return a pointer to a YQt object, corresponding to
 *         the first quaternion component currently online, or a null pointer
 *         if there are none.
 */
+(YQt*) FirstQt;
//--- (end of generated code: YQt public methods declaration)

@end

//--- (generated code: Qt functions declaration)
/**
 * Retrieves a quaternion component for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quaternion component is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQt.isOnline() to test if the quaternion component is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quaternion component by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the quaternion component
 *
 * @return a YQt object allowing you to drive the quaternion component.
 */
YQt* yFindQt(NSString* func);
/**
 * Starts the enumeration of quaternion components currently accessible.
 * Use the method YQt.nextQt() to iterate on
 * next quaternion components.
 *
 * @return a pointer to a YQt object, corresponding to
 *         the first quaternion component currently online, or a null pointer
 *         if there are none.
 */
YQt* yFirstQt(void);

//--- (end of generated code: Qt functions declaration)


@class YGyro;

//--- (generated code: YGyro globals)
typedef void (*YGyroValueCallback)(YGyro *func, NSString *functionValue);
typedef void (*YGyroTimedReportCallback)(YGyro *func, YMeasure *measure);
#define Y_XVALUE_INVALID                YAPI_INVALID_DOUBLE
#define Y_YVALUE_INVALID                YAPI_INVALID_DOUBLE
#define Y_ZVALUE_INVALID                YAPI_INVALID_DOUBLE
//--- (end of generated code: YGyro globals)

typedef void(*YQuatCallback)(YGyro *yGyro, double w, double x, double y, double z);
typedef void(*YAnglesCallback)(YGyro *yGyro, double roll, double pitch, double head);

//--- (generated code: YGyro class start)
/**
 * YGyro Class: Gyroscope function interface
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
@interface YGyro : YSensor
//--- (end of generated code: YGyro class start)
{
@protected
//--- (generated code: YGyro attributes declaration)
    double          _xValue;
    double          _yValue;
    double          _zValue;
    YGyroValueCallback _valueCallbackGyro;
    YGyroTimedReportCallback _timedReportCallbackGyro;
    int             _qt_stamp;
    YQt*            _qt_w;
    YQt*            _qt_x;
    YQt*            _qt_y;
    YQt*            _qt_z;
    double          _w;
    double          _x;
    double          _y;
    double          _z;
    int             _angles_stamp;
    double          _head;
    double          _pitch;
    double          _roll;
    YQuatCallback   _quatCallback;
    YAnglesCallback _anglesCallback;
//--- (end of generated code: YGyro attributes declaration)
}
// Constructor is protected, use yFindGyro factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YGyro private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YGyro private methods declaration)
//--- (generated code: YGyro public methods declaration)
/**
 * Returns the angular velocity around the X axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the X axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_XVALUE_INVALID.
 */
-(double)     get_xValue;


-(double) xValue;
/**
 * Returns the angular velocity around the Y axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the Y axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_YVALUE_INVALID.
 */
-(double)     get_yValue;


-(double) yValue;
/**
 * Returns the angular velocity around the Z axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the Z axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_ZVALUE_INVALID.
 */
-(double)     get_zValue;


-(double) zValue;
/**
 * Retrieves a gyroscope for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the gyroscope is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGyro.isOnline() to test if the gyroscope is
 * indeed online at a given time. In case of ambiguity when looking for
 * a gyroscope by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the gyroscope
 *
 * @return a YGyro object allowing you to drive the gyroscope.
 */
+(YGyro*)     FindGyro:(NSString*)func;

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerValueCallback:(YGyroValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerTimedReportCallback:(YGyroTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

-(int)     _loadQuaternion;

-(int)     _loadAngles;

/**
 * Returns the estimated roll angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the roll angle can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to roll angle
 *         in degrees, between -180 and +180.
 */
-(double)     get_roll;

/**
 * Returns the estimated pitch angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the pitch angle can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to pitch angle
 *         in degrees, between -90 and +90.
 */
-(double)     get_pitch;

/**
 * Returns the estimated heading angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the heading can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to heading
 *         in degrees, between 0 and 360.
 */
-(double)     get_heading;

/**
 * Returns the w component (real part) of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 *
 * @return a floating-point number corresponding to the w
 *         component of the quaternion.
 */
-(double)     get_quaternionW;

/**
 * Returns the x component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The x component is
 * mostly correlated with rotations on the roll axis.
 *
 * @return a floating-point number corresponding to the x
 *         component of the quaternion.
 */
-(double)     get_quaternionX;

/**
 * Returns the y component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The y component is
 * mostly correlated with rotations on the pitch axis.
 *
 * @return a floating-point number corresponding to the y
 *         component of the quaternion.
 */
-(double)     get_quaternionY;

/**
 * Returns the x component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The x component is
 * mostly correlated with changes of heading.
 *
 * @return a floating-point number corresponding to the z
 *         component of the quaternion.
 */
-(double)     get_quaternionZ;

/**
 * Registers a callback function that will be invoked each time that the estimated
 * device orientation has changed. The call frequency is typically around 95Hz during a move.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered.
 * For good responsiveness, remember to call one of these two functions periodically.
 * To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to invoke, or a null pointer.
 *         The callback function should take five arguments:
 *         the YGyro object of the turning device, and the floating
 *         point values of the four components w, x, y and z
 *         (as floating-point numbers).
 * @noreturn
 */
-(int)     registerQuaternionCallback:(YQuatCallback)callback;

/**
 * Registers a callback function that will be invoked each time that the estimated
 * device orientation has changed. The call frequency is typically around 95Hz during a move.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered.
 * For good responsiveness, remember to call one of these two functions periodically.
 * To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to invoke, or a null pointer.
 *         The callback function should take four arguments:
 *         the YGyro object of the turning device, and the floating
 *         point values of the three angles roll, pitch and heading
 *         in degrees (as floating-point numbers).
 * @noreturn
 */
-(int)     registerAnglesCallback:(YAnglesCallback)callback;

-(int)     _invokeGyroCallbacks:(int)qtIndex :(double)qtValue;


/**
 * Continues the enumeration of gyroscopes started using yFirstGyro().
 *
 * @return a pointer to a YGyro object, corresponding to
 *         a gyroscope currently online, or a null pointer
 *         if there are no more gyroscopes to enumerate.
 */
-(YGyro*) nextGyro;
/**
 * Starts the enumeration of gyroscopes currently accessible.
 * Use the method YGyro.nextGyro() to iterate on
 * next gyroscopes.
 *
 * @return a pointer to a YGyro object, corresponding to
 *         the first gyro currently online, or a null pointer
 *         if there are none.
 */
+(YGyro*) FirstGyro;
//--- (end of generated code: YGyro public methods declaration)

@end

//--- (generated code: Gyro functions declaration)
/**
 * Retrieves a gyroscope for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the gyroscope is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGyro.isOnline() to test if the gyroscope is
 * indeed online at a given time. In case of ambiguity when looking for
 * a gyroscope by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the gyroscope
 *
 * @return a YGyro object allowing you to drive the gyroscope.
 */
YGyro* yFindGyro(NSString* func);
/**
 * Starts the enumeration of gyroscopes currently accessible.
 * Use the method YGyro.nextGyro() to iterate on
 * next gyroscopes.
 *
 * @return a pointer to a YGyro object, corresponding to
 *         the first gyro currently online, or a null pointer
 *         if there are none.
 */
YGyro* yFirstGyro(void);

//--- (end of generated code: Gyro functions declaration)
CF_EXTERN_C_END

