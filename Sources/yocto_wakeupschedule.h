/*********************************************************************
 *
 * $Id: yocto_wakeupschedule.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindWakeUpSchedule(), the high-level API for WakeUpSchedule functions
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

@class YWakeUpSchedule;

//--- (YWakeUpSchedule globals)
typedef void (*YWakeUpScheduleValueCallback)(YWakeUpSchedule *func, NSString *functionValue);
#define Y_MINUTESA_INVALID              YAPI_INVALID_UINT
#define Y_MINUTESB_INVALID              YAPI_INVALID_UINT
#define Y_HOURS_INVALID                 YAPI_INVALID_UINT
#define Y_WEEKDAYS_INVALID              YAPI_INVALID_UINT
#define Y_MONTHDAYS_INVALID             YAPI_INVALID_UINT
#define Y_MONTHS_INVALID                YAPI_INVALID_UINT
#define Y_NEXTOCCURENCE_INVALID         YAPI_INVALID_LONG
//--- (end of YWakeUpSchedule globals)

//--- (YWakeUpSchedule class start)
/**
 * YWakeUpSchedule Class: WakeUpSchedule function interface
 *
 * The WakeUpSchedule function implements a wake up condition. The wake up time is
 * specified as a set of months and/or days and/or hours and/or minutes when the
 * wake up should happen.
 */
@interface YWakeUpSchedule : YFunction
//--- (end of YWakeUpSchedule class start)
{
@protected
//--- (YWakeUpSchedule attributes declaration)
    int             _minutesA;
    int             _minutesB;
    int             _hours;
    int             _weekDays;
    int             _monthDays;
    int             _months;
    s64             _nextOccurence;
    YWakeUpScheduleValueCallback _valueCallbackWakeUpSchedule;
//--- (end of YWakeUpSchedule attributes declaration)
}
// Constructor is protected, use yFindWakeUpSchedule factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YWakeUpSchedule private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YWakeUpSchedule private methods declaration)
//--- (YWakeUpSchedule public methods declaration)
/**
 * Returns the minutes in the 00-29 interval of each hour scheduled for wake up.
 *
 * @return an integer corresponding to the minutes in the 00-29 interval of each hour scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MINUTESA_INVALID.
 */
-(int)     get_minutesA;


-(int) minutesA;
/**
 * Changes the minutes in the 00-29 interval when a wake up must take place.
 *
 * @param newval : an integer corresponding to the minutes in the 00-29 interval when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutesA:(int) newval;
-(int)     setMinutesA:(int) newval;

/**
 * Returns the minutes in the 30-59 intervalof each hour scheduled for wake up.
 *
 * @return an integer corresponding to the minutes in the 30-59 intervalof each hour scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MINUTESB_INVALID.
 */
-(int)     get_minutesB;


-(int) minutesB;
/**
 * Changes the minutes in the 30-59 interval when a wake up must take place.
 *
 * @param newval : an integer corresponding to the minutes in the 30-59 interval when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutesB:(int) newval;
-(int)     setMinutesB:(int) newval;

/**
 * Returns the hours scheduled for wake up.
 *
 * @return an integer corresponding to the hours scheduled for wake up
 *
 * On failure, throws an exception or returns Y_HOURS_INVALID.
 */
-(int)     get_hours;


-(int) hours;
/**
 * Changes the hours when a wake up must take place.
 *
 * @param newval : an integer corresponding to the hours when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hours:(int) newval;
-(int)     setHours:(int) newval;

/**
 * Returns the days of the week scheduled for wake up.
 *
 * @return an integer corresponding to the days of the week scheduled for wake up
 *
 * On failure, throws an exception or returns Y_WEEKDAYS_INVALID.
 */
-(int)     get_weekDays;


-(int) weekDays;
/**
 * Changes the days of the week when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the week when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_weekDays:(int) newval;
-(int)     setWeekDays:(int) newval;

/**
 * Returns the days of the month scheduled for wake up.
 *
 * @return an integer corresponding to the days of the month scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MONTHDAYS_INVALID.
 */
-(int)     get_monthDays;


-(int) monthDays;
/**
 * Changes the days of the month when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the month when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_monthDays:(int) newval;
-(int)     setMonthDays:(int) newval;

/**
 * Returns the months scheduled for wake up.
 *
 * @return an integer corresponding to the months scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MONTHS_INVALID.
 */
-(int)     get_months;


-(int) months;
/**
 * Changes the months when a wake up must take place.
 *
 * @param newval : an integer corresponding to the months when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_months:(int) newval;
-(int)     setMonths:(int) newval;

/**
 * Returns the date/time (seconds) of the next wake up occurence
 *
 * @return an integer corresponding to the date/time (seconds) of the next wake up occurence
 *
 * On failure, throws an exception or returns Y_NEXTOCCURENCE_INVALID.
 */
-(s64)     get_nextOccurence;


-(s64) nextOccurence;
/**
 * Retrieves a wake up schedule for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the wake up schedule is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpSchedule.isOnline() to test if the wake up schedule is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wake up schedule by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the wake up schedule
 *
 * @return a YWakeUpSchedule object allowing you to drive the wake up schedule.
 */
+(YWakeUpSchedule*)     FindWakeUpSchedule:(NSString*)func;

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
-(int)     registerValueCallback:(YWakeUpScheduleValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Returns all the minutes of each hour that are scheduled for wake up.
 */
-(s64)     get_minutes;

/**
 * Changes all the minutes where a wake up must take place.
 *
 * @param bitmap : Minutes 00-59 of each hour scheduled for wake up.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutes:(s64)bitmap;


/**
 * Continues the enumeration of wake up schedules started using yFirstWakeUpSchedule().
 *
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         a wake up schedule currently online, or a null pointer
 *         if there are no more wake up schedules to enumerate.
 */
-(YWakeUpSchedule*) nextWakeUpSchedule;
/**
 * Starts the enumeration of wake up schedules currently accessible.
 * Use the method YWakeUpSchedule.nextWakeUpSchedule() to iterate on
 * next wake up schedules.
 *
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         the first wake up schedule currently online, or a null pointer
 *         if there are none.
 */
+(YWakeUpSchedule*) FirstWakeUpSchedule;
//--- (end of YWakeUpSchedule public methods declaration)

@end

//--- (WakeUpSchedule functions declaration)
/**
 * Retrieves a wake up schedule for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the wake up schedule is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpSchedule.isOnline() to test if the wake up schedule is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wake up schedule by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the wake up schedule
 *
 * @return a YWakeUpSchedule object allowing you to drive the wake up schedule.
 */
YWakeUpSchedule* yFindWakeUpSchedule(NSString* func);
/**
 * Starts the enumeration of wake up schedules currently accessible.
 * Use the method YWakeUpSchedule.nextWakeUpSchedule() to iterate on
 * next wake up schedules.
 *
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         the first wake up schedule currently online, or a null pointer
 *         if there are none.
 */
YWakeUpSchedule* yFirstWakeUpSchedule(void);

//--- (end of WakeUpSchedule functions declaration)
CF_EXTERN_C_END

