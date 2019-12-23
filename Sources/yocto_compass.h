/*********************************************************************
 *
 *  $Id: yocto_compass.h 38899 2019-12-20 17:21:03Z mvuilleu $
 *
 *  Declares yFindCompass(), the high-level API for Compass functions
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

@class YCompass;

//--- (YCompass globals)
typedef void (*YCompassValueCallback)(YCompass *func, NSString *functionValue);
typedef void (*YCompassTimedReportCallback)(YCompass *func, YMeasure *measure);
#ifndef _Y_AXIS_ENUM
#define _Y_AXIS_ENUM
typedef enum {
    Y_AXIS_X = 0,
    Y_AXIS_Y = 1,
    Y_AXIS_Z = 2,
    Y_AXIS_INVALID = -1,
} Y_AXIS_enum;
#endif
#define Y_BANDWIDTH_INVALID             YAPI_INVALID_UINT
#define Y_MAGNETICHEADING_INVALID       YAPI_INVALID_DOUBLE
//--- (end of YCompass globals)

//--- (YCompass class start)
/**
 * YCompass Class: compass function control interface, available for instance in the Yocto-3D-V2
 *
 * The YCompass class allows you to read and configure Yoctopuce compass functions.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YCompass : YSensor
//--- (end of YCompass class start)
{
@protected
//--- (YCompass attributes declaration)
    int             _bandwidth;
    Y_AXIS_enum     _axis;
    double          _magneticHeading;
    YCompassValueCallback _valueCallbackCompass;
    YCompassTimedReportCallback _timedReportCallbackCompass;
//--- (end of YCompass attributes declaration)
}
// Constructor is protected, use yFindCompass factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YCompass private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YCompass private methods declaration)
//--- (YCompass yapiwrapper declaration)
//--- (end of YCompass yapiwrapper declaration)
//--- (YCompass public methods declaration)
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
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the measure update frequency, measured in Hz (Yocto-3D-V2 only)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bandwidth:(int) newval;
-(int)     setBandwidth:(int) newval;

-(Y_AXIS_enum)     get_axis;


-(Y_AXIS_enum) axis;
/**
 * Returns the magnetic heading, regardless of the configured bearing.
 *
 * @return a floating point number corresponding to the magnetic heading, regardless of the configured bearing
 *
 * On failure, throws an exception or returns Y_MAGNETICHEADING_INVALID.
 */
-(double)     get_magneticHeading;


-(double) magneticHeading;
/**
 * Retrieves a compass function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the compass function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCompass.isOnline() to test if the compass function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a compass function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the compass function, for instance
 *         Y3DMK002.compass.
 *
 * @return a YCompass object allowing you to drive the compass function.
 */
+(YCompass*)     FindCompass:(NSString*)func;

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
-(int)     registerValueCallback:(YCompassValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YCompassTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of compass functions started using yFirstCompass().
 * Caution: You can't make any assumption about the returned compass functions order.
 * If you want to find a specific a compass function, use Compass.findCompass()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YCompass object, corresponding to
 *         a compass function currently online, or a nil pointer
 *         if there are no more compass functions to enumerate.
 */
-(YCompass*) nextCompass;
/**
 * Starts the enumeration of compass functions currently accessible.
 * Use the method YCompass.nextCompass() to iterate on
 * next compass functions.
 *
 * @return a pointer to a YCompass object, corresponding to
 *         the first compass function currently online, or a nil pointer
 *         if there are none.
 */
+(YCompass*) FirstCompass;
//--- (end of YCompass public methods declaration)

@end

//--- (YCompass functions declaration)
/**
 * Retrieves a compass function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the compass function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCompass.isOnline() to test if the compass function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a compass function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the compass function, for instance
 *         Y3DMK002.compass.
 *
 * @return a YCompass object allowing you to drive the compass function.
 */
YCompass* yFindCompass(NSString* func);
/**
 * Starts the enumeration of compass functions currently accessible.
 * Use the method YCompass.nextCompass() to iterate on
 * next compass functions.
 *
 * @return a pointer to a YCompass object, corresponding to
 *         the first compass function currently online, or a nil pointer
 *         if there are none.
 */
YCompass* yFirstCompass(void);

//--- (end of YCompass functions declaration)
CF_EXTERN_C_END

