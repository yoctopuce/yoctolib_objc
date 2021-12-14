/*********************************************************************
 *
 *  $Id: yocto_realtimeclock.h 47630 2021-12-10 17:04:48Z mvuilleu $
 *
 *  Declares yFindRealTimeClock(), the high-level API for RealTimeClock functions
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

@class YRealTimeClock;

//--- (YRealTimeClock globals)
typedef void (*YRealTimeClockValueCallback)(YRealTimeClock *func, NSString *functionValue);
#ifndef _Y_TIMESET_ENUM
#define _Y_TIMESET_ENUM
typedef enum {
    Y_TIMESET_FALSE = 0,
    Y_TIMESET_TRUE = 1,
    Y_TIMESET_INVALID = -1,
} Y_TIMESET_enum;
#endif
#define Y_UNIXTIME_INVALID              YAPI_INVALID_LONG
#define Y_DATETIME_INVALID              YAPI_INVALID_STRING
#define Y_UTCOFFSET_INVALID             YAPI_INVALID_INT
//--- (end of YRealTimeClock globals)

//--- (YRealTimeClock class start)
/**
 * YRealTimeClock Class: real-time clock control interface, available for instance in the
 * YoctoHub-GSM-2G, the YoctoHub-GSM-4G, the YoctoHub-Wireless-g or the YoctoHub-Wireless-n
 *
 * The YRealTimeClock class provide access to the embedded real-time clock available on some Yoctopuce
 * devices. It can provide current date and time, even after a power outage
 * lasting several days. It is the base for automated wake-up functions provided by the WakeUpScheduler.
 * The current time may represent a local time as well as an UTC time, but no automatic time change
 * will occur to account for daylight saving time.
 */
@interface YRealTimeClock : YFunction
//--- (end of YRealTimeClock class start)
{
@protected
//--- (YRealTimeClock attributes declaration)
    s64             _unixTime;
    NSString*       _dateTime;
    int             _utcOffset;
    Y_TIMESET_enum  _timeSet;
    YRealTimeClockValueCallback _valueCallbackRealTimeClock;
//--- (end of YRealTimeClock attributes declaration)
}
// Constructor is protected, use yFindRealTimeClock factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YRealTimeClock private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YRealTimeClock private methods declaration)
//--- (YRealTimeClock yapiwrapper declaration)
//--- (end of YRealTimeClock yapiwrapper declaration)
//--- (YRealTimeClock public methods declaration)
/**
 * Returns the current time in Unix format (number of elapsed seconds since Jan 1st, 1970).
 *
 * @return an integer corresponding to the current time in Unix format (number of elapsed seconds
 * since Jan 1st, 1970)
 *
 * On failure, throws an exception or returns YRealTimeClock.UNIXTIME_INVALID.
 */
-(s64)     get_unixTime;


-(s64) unixTime;
/**
 * Changes the current time. Time is specifid in Unix format (number of elapsed seconds since Jan 1st, 1970).
 *
 * @param newval : an integer corresponding to the current time
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unixTime:(s64) newval;
-(int)     setUnixTime:(s64) newval;

/**
 * Returns the current time in the form "YYYY/MM/DD hh:mm:ss".
 *
 * @return a string corresponding to the current time in the form "YYYY/MM/DD hh:mm:ss"
 *
 * On failure, throws an exception or returns YRealTimeClock.DATETIME_INVALID.
 */
-(NSString*)     get_dateTime;


-(NSString*) dateTime;
/**
 * Returns the number of seconds between current time and UTC time (time zone).
 *
 * @return an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * On failure, throws an exception or returns YRealTimeClock.UTCOFFSET_INVALID.
 */
-(int)     get_utcOffset;


-(int) utcOffset;
/**
 * Changes the number of seconds between current time and UTC time (time zone).
 * The timezone is automatically rounded to the nearest multiple of 15 minutes.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_utcOffset:(int) newval;
-(int)     setUtcOffset:(int) newval;

/**
 * Returns true if the clock has been set, and false otherwise.
 *
 * @return either YRealTimeClock.TIMESET_FALSE or YRealTimeClock.TIMESET_TRUE, according to true if
 * the clock has been set, and false otherwise
 *
 * On failure, throws an exception or returns YRealTimeClock.TIMESET_INVALID.
 */
-(Y_TIMESET_enum)     get_timeSet;


-(Y_TIMESET_enum) timeSet;
/**
 * Retrieves a real-time clock for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the real-time clock is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRealTimeClock.isOnline() to test if the real-time clock is
 * indeed online at a given time. In case of ambiguity when looking for
 * a real-time clock by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the real-time clock, for instance
 *         YHUBGSM1.realTimeClock.
 *
 * @return a YRealTimeClock object allowing you to drive the real-time clock.
 */
+(YRealTimeClock*)     FindRealTimeClock:(NSString*)func;

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
-(int)     registerValueCallback:(YRealTimeClockValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of real-time clocks started using yFirstRealTimeClock().
 * Caution: You can't make any assumption about the returned real-time clocks order.
 * If you want to find a specific a real-time clock, use RealTimeClock.findRealTimeClock()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         a real-time clock currently online, or a nil pointer
 *         if there are no more real-time clocks to enumerate.
 */
-(nullable YRealTimeClock*) nextRealTimeClock
NS_SWIFT_NAME(nextRealTimeClock());
/**
 * Starts the enumeration of real-time clocks currently accessible.
 * Use the method YRealTimeClock.nextRealTimeClock() to iterate on
 * next real-time clocks.
 *
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         the first real-time clock currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YRealTimeClock*) FirstRealTimeClock
NS_SWIFT_NAME(FirstRealTimeClock());
//--- (end of YRealTimeClock public methods declaration)

@end

//--- (YRealTimeClock functions declaration)
/**
 * Retrieves a real-time clock for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the real-time clock is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRealTimeClock.isOnline() to test if the real-time clock is
 * indeed online at a given time. In case of ambiguity when looking for
 * a real-time clock by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the real-time clock, for instance
 *         YHUBGSM1.realTimeClock.
 *
 * @return a YRealTimeClock object allowing you to drive the real-time clock.
 */
YRealTimeClock* yFindRealTimeClock(NSString* func);
/**
 * Starts the enumeration of real-time clocks currently accessible.
 * Use the method YRealTimeClock.nextRealTimeClock() to iterate on
 * next real-time clocks.
 *
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         the first real-time clock currently online, or a nil pointer
 *         if there are none.
 */
YRealTimeClock* yFirstRealTimeClock(void);

//--- (end of YRealTimeClock functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

