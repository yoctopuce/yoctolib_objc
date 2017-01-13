/*********************************************************************
 *
 * $Id: pic24config.php 26169 2016-12-12 01:36:34Z mvuilleu $
 *
 * Declares yFindProximity(), the high-level API for Proximity functions
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

@class YProximity;

//--- (YProximity globals)
typedef void (*YProximityValueCallback)(YProximity *func, NSString *functionValue);
typedef void (*YProximityTimedReportCallback)(YProximity *func, YMeasure *measure);
#ifndef _Y_ISPRESENT_ENUM
#define _Y_ISPRESENT_ENUM
typedef enum {
    Y_ISPRESENT_FALSE = 0,
    Y_ISPRESENT_TRUE = 1,
    Y_ISPRESENT_INVALID = -1,
} Y_ISPRESENT_enum;
#endif
#define Y_DETECTIONTHRESHOLD_INVALID    YAPI_INVALID_UINT
#define Y_LASTTIMEAPPROACHED_INVALID    YAPI_INVALID_LONG
#define Y_LASTTIMEREMOVED_INVALID       YAPI_INVALID_LONG
#define Y_PULSECOUNTER_INVALID          YAPI_INVALID_LONG
#define Y_PULSETIMER_INVALID            YAPI_INVALID_LONG
//--- (end of YProximity globals)

//--- (YProximity class start)
/**
 * YProximity Class: Proximity function interface
 *
 * The Yoctopuce class YProximity allows you to use and configure Yoctopuce proximity
 * sensors. It inherits from YSensor class the core functions to read measurements,
 * register callback functions, access to the autonomous datalogger.
 * This class adds the ability to easily perform a one-point linear calibration
 * to compensate the effect of a glass or filter placed in front of the sensor.
 */
@interface YProximity : YSensor
//--- (end of YProximity class start)
{
@protected
//--- (YProximity attributes declaration)
    int             _detectionThreshold;
    Y_ISPRESENT_enum _isPresent;
    s64             _lastTimeApproached;
    s64             _lastTimeRemoved;
    s64             _pulseCounter;
    s64             _pulseTimer;
    YProximityValueCallback _valueCallbackProximity;
    YProximityTimedReportCallback _timedReportCallbackProximity;
//--- (end of YProximity attributes declaration)
}
// Constructor is protected, use yFindProximity factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YProximity private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YProximity private methods declaration)
//--- (YProximity public methods declaration)
/**
 * Returns the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @return an integer corresponding to the threshold used to determine the logical state of the
 * proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * On failure, throws an exception or returns Y_DETECTIONTHRESHOLD_INVALID.
 */
-(int)     get_detectionThreshold;


-(int) detectionThreshold;
/**
 * Changes the threshold used to determine the logical state of the proximity sensor, when considered
 * as a binary input (on/off).
 *
 * @param newval : an integer corresponding to the threshold used to determine the logical state of
 * the proximity sensor, when considered
 *         as a binary input (on/off)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_detectionThreshold:(int) newval;
-(int)     setDetectionThreshold:(int) newval;

/**
 * Returns true if the input (considered as binary) is active (detection value is smaller than the
 * specified threshold), and false otherwise.
 *
 * @return either Y_ISPRESENT_FALSE or Y_ISPRESENT_TRUE, according to true if the input (considered as
 * binary) is active (detection value is smaller than the specified threshold), and false otherwise
 *
 * On failure, throws an exception or returns Y_ISPRESENT_INVALID.
 */
-(Y_ISPRESENT_enum)     get_isPresent;


-(Y_ISPRESENT_enum) isPresent;
/**
 * Returns the number of elapsed milliseconds between the module power on and the last observed
 * detection (the input contact transitioned from absent to present).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last observed
 *         detection (the input contact transitioned from absent to present)
 *
 * On failure, throws an exception or returns Y_LASTTIMEAPPROACHED_INVALID.
 */
-(s64)     get_lastTimeApproached;


-(s64) lastTimeApproached;
/**
 * Returns the number of elapsed milliseconds between the module power on and the last observed
 * detection (the input contact transitioned from present to absent).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last observed
 *         detection (the input contact transitioned from present to absent)
 *
 * On failure, throws an exception or returns Y_LASTTIMEREMOVED_INVALID.
 */
-(s64)     get_lastTimeRemoved;


-(s64) lastTimeRemoved;
/**
 * Returns the pulse counter value. The value is a 32 bit integer. In case
 * of overflow (>=2^32), the counter will wrap. To reset the counter, just
 * call the resetCounter() method.
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(s64)     get_pulseCounter;


-(s64) pulseCounter;
-(int)     set_pulseCounter:(s64) newval;
-(int)     setPulseCounter:(s64) newval;

/**
 * Returns the timer of the pulses counter (ms).
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(s64)     get_pulseTimer;


-(s64) pulseTimer;
/**
 * Retrieves a proximity sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the proximity sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YProximity.isOnline() to test if the proximity sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a proximity sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the proximity sensor
 *
 * @return a YProximity object allowing you to drive the proximity sensor.
 */
+(YProximity*)     FindProximity:(NSString*)func;

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
-(int)     registerValueCallback:(YProximityValueCallback)callback;

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
-(int)     registerTimedReportCallback:(YProximityTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetCounter;


/**
 * Continues the enumeration of proximity sensors started using yFirstProximity().
 *
 * @return a pointer to a YProximity object, corresponding to
 *         a proximity sensor currently online, or a nil pointer
 *         if there are no more proximity sensors to enumerate.
 */
-(YProximity*) nextProximity;
/**
 * Starts the enumeration of proximity sensors currently accessible.
 * Use the method YProximity.nextProximity() to iterate on
 * next proximity sensors.
 *
 * @return a pointer to a YProximity object, corresponding to
 *         the first proximity sensor currently online, or a nil pointer
 *         if there are none.
 */
+(YProximity*) FirstProximity;
//--- (end of YProximity public methods declaration)

@end

//--- (Proximity functions declaration)
/**
 * Retrieves a proximity sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the proximity sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YProximity.isOnline() to test if the proximity sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a proximity sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the proximity sensor
 *
 * @return a YProximity object allowing you to drive the proximity sensor.
 */
YProximity* yFindProximity(NSString* func);
/**
 * Starts the enumeration of proximity sensors currently accessible.
 * Use the method YProximity.nextProximity() to iterate on
 * next proximity sensors.
 *
 * @return a pointer to a YProximity object, corresponding to
 *         the first proximity sensor currently online, or a nil pointer
 *         if there are none.
 */
YProximity* yFirstProximity(void);

//--- (end of Proximity functions declaration)
CF_EXTERN_C_END

