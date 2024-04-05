/*********************************************************************
 *
 *  $Id: yocto_tilt.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Declares yFindTilt(), the high-level API for Tilt functions
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

@class YTilt;

//--- (YTilt globals)
typedef void (*YTiltValueCallback)(YTilt *func, NSString *functionValue);
typedef void (*YTiltTimedReportCallback)(YTilt *func, YMeasure *measure);
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
//--- (end of YTilt globals)

//--- (YTilt class start)
/**
 * YTilt Class: tilt sensor control interface, available for instance in the Yocto-3D-V2 or the Yocto-Inclinometer
 *
 * The YSensor class is the parent class for all Yoctopuce sensor types. It can be
 * used to read the current value and unit of any sensor, read the min/max
 * value, configure autonomous recording frequency and access recorded data.
 * It also provide a function to register a callback invoked each time the
 * observed value changes, or at a predefined interval. Using this class rather
 * than a specific subclass makes it possible to create generic applications
 * that work with any Yoctopuce sensor, even those that do not yet exist.
 * Note: The YAnButton class is the only analog input which does not inherit
 * from YSensor.
 */
@interface YTilt : YSensor
//--- (end of YTilt class start)
{
@protected
//--- (YTilt attributes declaration)
    int             _bandwidth;
    Y_AXIS_enum     _axis;
    YTiltValueCallback _valueCallbackTilt;
    YTiltTimedReportCallback _timedReportCallbackTilt;
//--- (end of YTilt attributes declaration)
}
// Constructor is protected, use yFindTilt factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YTilt private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YTilt private methods declaration)
//--- (YTilt yapiwrapper declaration)
//--- (end of YTilt yapiwrapper declaration)
//--- (YTilt public methods declaration)
/**
 * Returns the measure update frequency, measured in Hz.
 *
 * @return an integer corresponding to the measure update frequency, measured in Hz
 *
 * On failure, throws an exception or returns YTilt.BANDWIDTH_INVALID.
 */
-(int)     get_bandwidth;


-(int) bandwidth;
/**
 * Changes the measure update frequency, measured in Hz. When the
 * frequency is lower, the device performs averaging.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the measure update frequency, measured in Hz
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bandwidth:(int) newval;
-(int)     setBandwidth:(int) newval;

-(Y_AXIS_enum)     get_axis;


-(Y_AXIS_enum) axis;
/**
 * Retrieves a tilt sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the tilt sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTilt.isOnline() to test if the tilt sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a tilt sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the tilt sensor, for instance
 *         Y3DMK002.tilt1.
 *
 * @return a YTilt object allowing you to drive the tilt sensor.
 */
+(YTilt*)     FindTilt:(NSString*)func;

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
-(int)     registerValueCallback:(YTiltValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YTiltTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Performs a zero calibration for the tilt measurement (Yocto-Inclinometer only).
 * When this method is invoked, a simple shift (translation)
 * is applied so that the current position is reported as a zero angle.
 * Be aware that this shift will also affect the measurement boundaries.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     calibrateToZero;

/**
 * Cancels any previous zero calibration for the tilt measurement (Yocto-Inclinometer only).
 * This function restores the factory zero calibration.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     restoreZeroCalibration;


/**
 * Continues the enumeration of tilt sensors started using yFirstTilt().
 * Caution: You can't make any assumption about the returned tilt sensors order.
 * If you want to find a specific a tilt sensor, use Tilt.findTilt()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YTilt object, corresponding to
 *         a tilt sensor currently online, or a nil pointer
 *         if there are no more tilt sensors to enumerate.
 */
-(nullable YTilt*) nextTilt
NS_SWIFT_NAME(nextTilt());
/**
 * Starts the enumeration of tilt sensors currently accessible.
 * Use the method YTilt.nextTilt() to iterate on
 * next tilt sensors.
 *
 * @return a pointer to a YTilt object, corresponding to
 *         the first tilt sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YTilt*) FirstTilt
NS_SWIFT_NAME(FirstTilt());
//--- (end of YTilt public methods declaration)

@end

//--- (YTilt functions declaration)
/**
 * Retrieves a tilt sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the tilt sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTilt.isOnline() to test if the tilt sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a tilt sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the tilt sensor, for instance
 *         Y3DMK002.tilt1.
 *
 * @return a YTilt object allowing you to drive the tilt sensor.
 */
YTilt* yFindTilt(NSString* func);
/**
 * Starts the enumeration of tilt sensors currently accessible.
 * Use the method YTilt.nextTilt() to iterate on
 * next tilt sensors.
 *
 * @return a pointer to a YTilt object, corresponding to
 *         the first tilt sensor currently online, or a nil pointer
 *         if there are none.
 */
YTilt* yFirstTilt(void);

//--- (end of YTilt functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

