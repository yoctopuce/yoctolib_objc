/*********************************************************************
 *
 * $Id: yocto_wakeupmonitor.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindWakeUpMonitor(), the high-level API for WakeUpMonitor functions
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

@class YWakeUpMonitor;

//--- (YWakeUpMonitor globals)
typedef void (*YWakeUpMonitorValueCallback)(YWakeUpMonitor *func, NSString *functionValue);
#ifndef _Y_WAKEUPREASON_ENUM
#define _Y_WAKEUPREASON_ENUM
typedef enum {
    Y_WAKEUPREASON_USBPOWER = 0,
    Y_WAKEUPREASON_EXTPOWER = 1,
    Y_WAKEUPREASON_ENDOFSLEEP = 2,
    Y_WAKEUPREASON_EXTSIG1 = 3,
    Y_WAKEUPREASON_SCHEDULE1 = 4,
    Y_WAKEUPREASON_SCHEDULE2 = 5,
    Y_WAKEUPREASON_INVALID = -1,
} Y_WAKEUPREASON_enum;
#endif
#ifndef _Y_WAKEUPSTATE_ENUM
#define _Y_WAKEUPSTATE_ENUM
typedef enum {
    Y_WAKEUPSTATE_SLEEPING = 0,
    Y_WAKEUPSTATE_AWAKE = 1,
    Y_WAKEUPSTATE_INVALID = -1,
} Y_WAKEUPSTATE_enum;
#endif
#define Y_POWERDURATION_INVALID         YAPI_INVALID_INT
#define Y_SLEEPCOUNTDOWN_INVALID        YAPI_INVALID_INT
#define Y_NEXTWAKEUP_INVALID            YAPI_INVALID_LONG
#define Y_RTCTIME_INVALID               YAPI_INVALID_LONG
//--- (end of YWakeUpMonitor globals)

//--- (YWakeUpMonitor class start)
/**
 * YWakeUpMonitor Class: WakeUpMonitor function interface
 *
 * The WakeUpMonitor function handles globally all wake-up sources, as well
 * as automated sleep mode.
 */
@interface YWakeUpMonitor : YFunction
//--- (end of YWakeUpMonitor class start)
{
@protected
//--- (YWakeUpMonitor attributes declaration)
    int             _powerDuration;
    int             _sleepCountdown;
    s64             _nextWakeUp;
    Y_WAKEUPREASON_enum _wakeUpReason;
    Y_WAKEUPSTATE_enum _wakeUpState;
    s64             _rtcTime;
    int             _endOfTime;
    YWakeUpMonitorValueCallback _valueCallbackWakeUpMonitor;
//--- (end of YWakeUpMonitor attributes declaration)
}
// Constructor is protected, use yFindWakeUpMonitor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YWakeUpMonitor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YWakeUpMonitor private methods declaration)
//--- (YWakeUpMonitor public methods declaration)
/**
 * Returns the maximal wake up time (in seconds) before automatically going to sleep.
 *
 * @return an integer corresponding to the maximal wake up time (in seconds) before automatically going to sleep
 *
 * On failure, throws an exception or returns Y_POWERDURATION_INVALID.
 */
-(int)     get_powerDuration;


-(int) powerDuration;
/**
 * Changes the maximal wake up time (seconds) before automatically going to sleep.
 *
 * @param newval : an integer corresponding to the maximal wake up time (seconds) before automatically
 * going to sleep
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerDuration:(int) newval;
-(int)     setPowerDuration:(int) newval;

/**
 * Returns the delay before the  next sleep period.
 *
 * @return an integer corresponding to the delay before the  next sleep period
 *
 * On failure, throws an exception or returns Y_SLEEPCOUNTDOWN_INVALID.
 */
-(int)     get_sleepCountdown;


-(int) sleepCountdown;
/**
 * Changes the delay before the next sleep period.
 *
 * @param newval : an integer corresponding to the delay before the next sleep period
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_sleepCountdown:(int) newval;
-(int)     setSleepCountdown:(int) newval;

/**
 * Returns the next scheduled wake up date/time (UNIX format)
 *
 * @return an integer corresponding to the next scheduled wake up date/time (UNIX format)
 *
 * On failure, throws an exception or returns Y_NEXTWAKEUP_INVALID.
 */
-(s64)     get_nextWakeUp;


-(s64) nextWakeUp;
/**
 * Changes the days of the week when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the week when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_nextWakeUp:(s64) newval;
-(int)     setNextWakeUp:(s64) newval;

/**
 * Returns the latest wake up reason.
 *
 * @return a value among Y_WAKEUPREASON_USBPOWER, Y_WAKEUPREASON_EXTPOWER, Y_WAKEUPREASON_ENDOFSLEEP,
 * Y_WAKEUPREASON_EXTSIG1, Y_WAKEUPREASON_SCHEDULE1 and Y_WAKEUPREASON_SCHEDULE2 corresponding to the
 * latest wake up reason
 *
 * On failure, throws an exception or returns Y_WAKEUPREASON_INVALID.
 */
-(Y_WAKEUPREASON_enum)     get_wakeUpReason;


-(Y_WAKEUPREASON_enum) wakeUpReason;
/**
 * Returns  the current state of the monitor
 *
 * @return either Y_WAKEUPSTATE_SLEEPING or Y_WAKEUPSTATE_AWAKE, according to  the current state of the monitor
 *
 * On failure, throws an exception or returns Y_WAKEUPSTATE_INVALID.
 */
-(Y_WAKEUPSTATE_enum)     get_wakeUpState;


-(Y_WAKEUPSTATE_enum) wakeUpState;
-(int)     set_wakeUpState:(Y_WAKEUPSTATE_enum) newval;
-(int)     setWakeUpState:(Y_WAKEUPSTATE_enum) newval;

-(s64)     get_rtcTime;


-(s64) rtcTime;
/**
 * Retrieves a monitor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the monitor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpMonitor.isOnline() to test if the monitor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a monitor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the monitor
 *
 * @return a YWakeUpMonitor object allowing you to drive the monitor.
 */
+(YWakeUpMonitor*)     FindWakeUpMonitor:(NSString*)func;

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
-(int)     registerValueCallback:(YWakeUpMonitorValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Forces a wake up.
 */
-(int)     wakeUp;

/**
 * Goes to sleep until the next wake up condition is met,  the
 * RTC time must have been set before calling this function.
 *
 * @param secBeforeSleep : number of seconds before going into sleep mode,
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sleep:(int)secBeforeSleep;

/**
 * Goes to sleep for a specific duration or until the next wake up condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 *
 * @param secUntilWakeUp : number of seconds before next wake up
 * @param secBeforeSleep : number of seconds before going into sleep mode
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sleepFor:(int)secUntilWakeUp :(int)secBeforeSleep;

/**
 * Go to sleep until a specific date is reached or until the next wake up condition is met, the
 * RTC time must have been set before calling this function. The count down before sleep
 * can be canceled with resetSleepCountDown.
 *
 * @param wakeUpTime : wake-up datetime (UNIX format)
 * @param secBeforeSleep : number of seconds before going into sleep mode
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sleepUntil:(int)wakeUpTime :(int)secBeforeSleep;

/**
 * Resets the sleep countdown.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     resetSleepCountDown;


/**
 * Continues the enumeration of monitors started using yFirstWakeUpMonitor().
 *
 * @return a pointer to a YWakeUpMonitor object, corresponding to
 *         a monitor currently online, or a null pointer
 *         if there are no more monitors to enumerate.
 */
-(YWakeUpMonitor*) nextWakeUpMonitor;
/**
 * Starts the enumeration of monitors currently accessible.
 * Use the method YWakeUpMonitor.nextWakeUpMonitor() to iterate on
 * next monitors.
 *
 * @return a pointer to a YWakeUpMonitor object, corresponding to
 *         the first monitor currently online, or a null pointer
 *         if there are none.
 */
+(YWakeUpMonitor*) FirstWakeUpMonitor;
//--- (end of YWakeUpMonitor public methods declaration)

@end

//--- (WakeUpMonitor functions declaration)
/**
 * Retrieves a monitor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the monitor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpMonitor.isOnline() to test if the monitor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a monitor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the monitor
 *
 * @return a YWakeUpMonitor object allowing you to drive the monitor.
 */
YWakeUpMonitor* yFindWakeUpMonitor(NSString* func);
/**
 * Starts the enumeration of monitors currently accessible.
 * Use the method YWakeUpMonitor.nextWakeUpMonitor() to iterate on
 * next monitors.
 *
 * @return a pointer to a YWakeUpMonitor object, corresponding to
 *         the first monitor currently online, or a null pointer
 *         if there are none.
 */
YWakeUpMonitor* yFirstWakeUpMonitor(void);

//--- (end of WakeUpMonitor functions declaration)
CF_EXTERN_C_END

