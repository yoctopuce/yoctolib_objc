/*********************************************************************
 *
 * $Id: yocto_realtimeclock.h 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Declares yFindRealTimeClock(), the high-level API for RealTimeClock functions
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

//--- (YRealTimeClock definitions)
typedef enum {
    Y_TIMESET_FALSE = 0,
    Y_TIMESET_TRUE = 1,
    Y_TIMESET_INVALID = -1
} Y_TIMESET_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_UNIXTIME_INVALID              (0xffffffff)
#define Y_DATETIME_INVALID              [YAPI  INVALID_STRING]
#define Y_UTCOFFSET_INVALID             (0x80000000)
//--- (end of YRealTimeClock definitions)

/**
 * YRealTimeClock Class: Real Time Clock function interface
 * 
 * The RealTimeClock function maintains and provides current date and time, even accross power cut
 * lasting several days. It is the base for automated wake-up functions provided by the WakeUpScheduler.
 * The current time may represent a local time as well as an UTC time, but no automatic time change
 * will occur to account for daylight saving time.
 */
@interface YRealTimeClock : YFunction
{
@protected

// Attributes (function value cache)
//--- (YRealTimeClock attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    unsigned        _unixTime;
    NSString*       _dateTime;
    int             _utcOffset;
    Y_TIMESET_enum  _timeSet;
//--- (end of YRealTimeClock attributes)
}
//--- (YRealTimeClock declaration)
// Constructor is protected, use yFindRealTimeClock factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

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
-(void)     registerValueCallback:(YFunctionUpdateCallback) callback;   
/**
 * comment from .yc definition
 */
-(void)     set_objectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object withSelector:(SEL)selector;

//--- (end of YRealTimeClock declaration)
//--- (YRealTimeClock accessors declaration)

/**
 * Continues the enumeration of clocks started using yFirstRealTimeClock().
 * 
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         a clock currently online, or a null pointer
 *         if there are no more clocks to enumerate.
 */
-(YRealTimeClock*) nextRealTimeClock;
/**
 * Retrieves a clock for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the clock is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRealTimeClock.isOnline() to test if the clock is
 * indeed online at a given time. In case of ambiguity when looking for
 * a clock by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the clock
 * 
 * @return a YRealTimeClock object allowing you to drive the clock.
 */
+(YRealTimeClock*) FindRealTimeClock:(NSString*) func;
/**
 * Starts the enumeration of clocks currently accessible.
 * Use the method YRealTimeClock.nextRealTimeClock() to iterate on
 * next clocks.
 * 
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         the first clock currently online, or a null pointer
 *         if there are none.
 */
+(YRealTimeClock*) FirstRealTimeClock;

/**
 * Returns the logical name of the clock.
 * 
 * @return a string corresponding to the logical name of the clock
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the clock. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the clock
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the clock (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the clock (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the current time in Unix format (number of elapsed seconds since Jan 1st, 1970).
 * 
 * @return an integer corresponding to the current time in Unix format (number of elapsed seconds
 * since Jan 1st, 1970)
 * 
 * On failure, throws an exception or returns Y_UNIXTIME_INVALID.
 */
-(unsigned) get_unixTime;
-(unsigned) unixTime;

/**
 * Changes the current time. Time is specifid in Unix format (number of elapsed seconds since Jan 1st, 1970).
 * If current UTC time is known, utcOffset will be automatically adjusted for the new specified time.
 * 
 * @param newval : an integer corresponding to the current time
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unixTime:(unsigned) newval;
-(int)     setUnixTime:(unsigned) newval;

/**
 * Returns the current time in the form "YYYY/MM/DD hh:mm:ss"
 * 
 * @return a string corresponding to the current time in the form "YYYY/MM/DD hh:mm:ss"
 * 
 * On failure, throws an exception or returns Y_DATETIME_INVALID.
 */
-(NSString*) get_dateTime;
-(NSString*) dateTime;

/**
 * Returns the number of seconds between current time and UTC time (time zone).
 * 
 * @return an integer corresponding to the number of seconds between current time and UTC time (time zone)
 * 
 * On failure, throws an exception or returns Y_UTCOFFSET_INVALID.
 */
-(int) get_utcOffset;
-(int) utcOffset;

/**
 * Changes the number of seconds between current time and UTC time (time zone).
 * The timezone is automatically rounded to the nearest multiple of 15 minutes.
 * If current UTC time is known, the current time will automatically be updated according to the
 * selected time zone.
 * 
 * @param newval : an integer corresponding to the number of seconds between current time and UTC time (time zone)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_utcOffset:(int) newval;
-(int)     setUtcOffset:(int) newval;

/**
 * Returns true if the clock has been set, and false otherwise.
 * 
 * @return either Y_TIMESET_FALSE or Y_TIMESET_TRUE, according to true if the clock has been set, and
 * false otherwise
 * 
 * On failure, throws an exception or returns Y_TIMESET_INVALID.
 */
-(Y_TIMESET_enum) get_timeSet;
-(Y_TIMESET_enum) timeSet;


//--- (end of YRealTimeClock accessors declaration)
@end

//--- (RealTimeClock functions declaration)

/**
 * Retrieves a clock for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the clock is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRealTimeClock.isOnline() to test if the clock is
 * indeed online at a given time. In case of ambiguity when looking for
 * a clock by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the clock
 * 
 * @return a YRealTimeClock object allowing you to drive the clock.
 */
YRealTimeClock* yFindRealTimeClock(NSString* func);
/**
 * Starts the enumeration of clocks currently accessible.
 * Use the method YRealTimeClock.nextRealTimeClock() to iterate on
 * next clocks.
 * 
 * @return a pointer to a YRealTimeClock object, corresponding to
 *         the first clock currently online, or a null pointer
 *         if there are none.
 */
YRealTimeClock* yFirstRealTimeClock(void);

//--- (end of RealTimeClock functions declaration)
CF_EXTERN_C_END

