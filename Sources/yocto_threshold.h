/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindThreshold(), the high-level API for Threshold functions
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

@class YThreshold;

//--- (YThreshold globals)
typedef void (*YThresholdValueCallback)(YThreshold *func, NSString *functionValue);
#ifndef _Y_THRESHOLDSTATE_ENUM
#define _Y_THRESHOLDSTATE_ENUM
typedef enum {
    Y_THRESHOLDSTATE_SAFE = 0,
    Y_THRESHOLDSTATE_ALERT = 1,
    Y_THRESHOLDSTATE_INVALID = -1,
} Y_THRESHOLDSTATE_enum;
#endif
#define Y_TARGETSENSOR_INVALID          YAPI_INVALID_STRING
#define Y_ALERTLEVEL_INVALID            YAPI_INVALID_DOUBLE
#define Y_SAFELEVEL_INVALID             YAPI_INVALID_DOUBLE
//--- (end of YThreshold globals)

//--- (YThreshold class start)
/**
 * YThreshold Class: Control interface to define a threshold
 *
 * The Threshold class allows you define a threshold on a Yoctopuce sensor
 * to trigger a predefined action, on specific devices where this is implemented.
 */
@interface YThreshold : YFunction
//--- (end of YThreshold class start)
{
@protected
//--- (YThreshold attributes declaration)
    Y_THRESHOLDSTATE_enum _thresholdState;
    NSString*       _targetSensor;
    double          _alertLevel;
    double          _safeLevel;
    YThresholdValueCallback _valueCallbackThreshold;
//--- (end of YThreshold attributes declaration)
}
// Constructor is protected, use yFindThreshold factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YThreshold private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YThreshold private methods declaration)
//--- (YThreshold yapiwrapper declaration)
//--- (end of YThreshold yapiwrapper declaration)
//--- (YThreshold public methods declaration)
/**
 * Returns current state of the threshold function.
 *
 * @return either YThreshold.THRESHOLDSTATE_SAFE or YThreshold.THRESHOLDSTATE_ALERT, according to
 * current state of the threshold function
 *
 * On failure, throws an exception or returns YThreshold.THRESHOLDSTATE_INVALID.
 */
-(Y_THRESHOLDSTATE_enum)     get_thresholdState;


-(Y_THRESHOLDSTATE_enum) thresholdState;
/**
 * Returns the name of the sensor monitored by the threshold function.
 *
 * @return a string corresponding to the name of the sensor monitored by the threshold function
 *
 * On failure, throws an exception or returns YThreshold.TARGETSENSOR_INVALID.
 */
-(NSString*)     get_targetSensor;


-(NSString*) targetSensor;
/**
 * Changes the sensor alert level triggering the threshold function.
 * Remember to call the matching module saveToFlash()
 * method if you want to preserve the setting after reboot.
 *
 * @param newval : a floating point number corresponding to the sensor alert level triggering the
 * threshold function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_alertLevel:(double) newval;
-(int)     setAlertLevel:(double) newval;

/**
 * Returns the sensor alert level, triggering the threshold function.
 *
 * @return a floating point number corresponding to the sensor alert level, triggering the threshold function
 *
 * On failure, throws an exception or returns YThreshold.ALERTLEVEL_INVALID.
 */
-(double)     get_alertLevel;


-(double) alertLevel;
/**
 * Changes the sensor acceptable level for disabling the threshold function.
 * Remember to call the matching module saveToFlash()
 * method if you want to preserve the setting after reboot.
 *
 * @param newval : a floating point number corresponding to the sensor acceptable level for disabling
 * the threshold function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_safeLevel:(double) newval;
-(int)     setSafeLevel:(double) newval;

/**
 * Returns the sensor acceptable level for disabling the threshold function.
 *
 * @return a floating point number corresponding to the sensor acceptable level for disabling the
 * threshold function
 *
 * On failure, throws an exception or returns YThreshold.SAFELEVEL_INVALID.
 */
-(double)     get_safeLevel;


-(double) safeLevel;
/**
 * Retrieves a threshold function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the threshold function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YThreshold.isOnline() to test if the threshold function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a threshold function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the threshold function, for instance
 *         MyDevice.threshold1.
 *
 * @return a YThreshold object allowing you to drive the threshold function.
 */
+(YThreshold*)     FindThreshold:(NSString*)func;

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
-(int)     registerValueCallback:(YThresholdValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of threshold functions started using yFirstThreshold().
 * Caution: You can't make any assumption about the returned threshold functions order.
 * If you want to find a specific a threshold function, use Threshold.findThreshold()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YThreshold object, corresponding to
 *         a threshold function currently online, or a nil pointer
 *         if there are no more threshold functions to enumerate.
 */
-(nullable YThreshold*) nextThreshold
NS_SWIFT_NAME(nextThreshold());
/**
 * Starts the enumeration of threshold functions currently accessible.
 * Use the method YThreshold.nextThreshold() to iterate on
 * next threshold functions.
 *
 * @return a pointer to a YThreshold object, corresponding to
 *         the first threshold function currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YThreshold*) FirstThreshold
NS_SWIFT_NAME(FirstThreshold());
//--- (end of YThreshold public methods declaration)

@end

//--- (YThreshold functions declaration)
/**
 * Retrieves a threshold function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the threshold function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YThreshold.isOnline() to test if the threshold function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a threshold function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the threshold function, for instance
 *         MyDevice.threshold1.
 *
 * @return a YThreshold object allowing you to drive the threshold function.
 */
YThreshold* yFindThreshold(NSString* func);
/**
 * Starts the enumeration of threshold functions currently accessible.
 * Use the method YThreshold.nextThreshold() to iterate on
 * next threshold functions.
 *
 * @return a pointer to a YThreshold object, corresponding to
 *         the first threshold function currently online, or a nil pointer
 *         if there are none.
 */
YThreshold* yFirstThreshold(void);

//--- (end of YThreshold functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

