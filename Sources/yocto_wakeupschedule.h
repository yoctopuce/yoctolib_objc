/*********************************************************************
 *
 * $Id: yocto_wakeupschedule.h 12469 2013-08-22 10:11:58Z seb $
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

//--- (YWakeUpSchedule definitions)
#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_MINUTESA_INVALID              (0xffffffff)
#define Y_MINUTESB_INVALID              (0xffffffff)
#define Y_HOURS_INVALID                 (-1)
#define Y_WEEKDAYS_INVALID              (-1)
#define Y_MONTHDAYS_INVALID             (0xffffffff)
#define Y_MONTHS_INVALID                (-1)
#define Y_NEXTOCCURENCE_INVALID         (0xffffffff)
//--- (end of YWakeUpSchedule definitions)

/**
 * YWakeUpSchedule Class: WakeUpSchedule function interface
 * 
 * The WakeUpSchedule function implements a wake-up condition. The wake-up time is
 * specified as a set of months and/or days and/or hours and/or minutes where the
 * wake-up should happen.
 */
@interface YWakeUpSchedule : YFunction
{
@protected

// Attributes (function value cache)
//--- (YWakeUpSchedule attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    unsigned        _minutesA;
    unsigned        _minutesB;
    int             _hours;
    int             _weekDays;
    unsigned        _monthDays;
    int             _months;
    unsigned        _nextOccurence;
//--- (end of YWakeUpSchedule attributes)
}
//--- (YWakeUpSchedule declaration)
// Constructor is protected, use yFindWakeUpSchedule factory function to instantiate
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

//--- (end of YWakeUpSchedule declaration)
//--- (YWakeUpSchedule accessors declaration)

/**
 * Continues the enumeration of wake-up schedules started using yFirstWakeUpSchedule().
 * 
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         a wake-up schedule currently online, or a null pointer
 *         if there are no more wake-up schedules to enumerate.
 */
-(YWakeUpSchedule*) nextWakeUpSchedule;
/**
 * Retrieves a wake-up schedule for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the wake-up schedule is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpSchedule.isOnline() to test if the wake-up schedule is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wake-up schedule by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the wake-up schedule
 * 
 * @return a YWakeUpSchedule object allowing you to drive the wake-up schedule.
 */
+(YWakeUpSchedule*) FindWakeUpSchedule:(NSString*) func;
/**
 * Starts the enumeration of wake-up schedules currently accessible.
 * Use the method YWakeUpSchedule.nextWakeUpSchedule() to iterate on
 * next wake-up schedules.
 * 
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         the first wake-up schedule currently online, or a null pointer
 *         if there are none.
 */
+(YWakeUpSchedule*) FirstWakeUpSchedule;

/**
 * Returns the logical name of the wake-up schedule.
 * 
 * @return a string corresponding to the logical name of the wake-up schedule
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the wake-up schedule. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the wake-up schedule
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the wake-up schedule (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the wake-up schedule (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the minutes 00-29 of each hour scheduled for wake-up.
 * 
 * @return an integer corresponding to the minutes 00-29 of each hour scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MINUTESA_INVALID.
 */
-(unsigned) get_minutesA;
-(unsigned) minutesA;

/**
 * Changes the minutes 00-29 where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the minutes 00-29 where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutesA:(unsigned) newval;
-(int)     setMinutesA:(unsigned) newval;

/**
 * Returns the minutes 30-59 of each hour scheduled for wake-up.
 * 
 * @return an integer corresponding to the minutes 30-59 of each hour scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MINUTESB_INVALID.
 */
-(unsigned) get_minutesB;
-(unsigned) minutesB;

/**
 * Changes the minutes 30-59 where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the minutes 30-59 where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutesB:(unsigned) newval;
-(int)     setMinutesB:(unsigned) newval;

/**
 * Returns the hours  scheduled for wake-up.
 * 
 * @return an integer corresponding to the hours  scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_HOURS_INVALID.
 */
-(int) get_hours;
-(int) hours;

/**
 * Changes the hours where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the hours where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hours:(int) newval;
-(int)     setHours:(int) newval;

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_WEEKDAYS_INVALID.
 */
-(int) get_weekDays;
-(int) weekDays;

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_weekDays:(int) newval;
-(int)     setWeekDays:(int) newval;

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MONTHDAYS_INVALID.
 */
-(unsigned) get_monthDays;
-(unsigned) monthDays;

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_monthDays:(unsigned) newval;
-(int)     setMonthDays:(unsigned) newval;

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MONTHS_INVALID.
 */
-(int) get_months;
-(int) months;

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_months:(int) newval;
-(int)     setMonths:(int) newval;

/**
 * Returns the  nextwake up date/time (seconds) wake up occurence
 * 
 * @return an integer corresponding to the  nextwake up date/time (seconds) wake up occurence
 * 
 * On failure, throws an exception or returns Y_NEXTOCCURENCE_INVALID.
 */
-(unsigned) get_nextOccurence;
-(unsigned) nextOccurence;

/**
 * Returns every the minutes of each hour scheduled for wake-up.
 */
-(long)     get_minutes;

/**
 * Changes all the minutes where a wake up must take place.
 * 
 * @param bitmap : Minutes 00-59 of each hour scheduled for wake-up.,
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_minutes :(long)bitmap;


//--- (end of YWakeUpSchedule accessors declaration)
@end

//--- (WakeUpSchedule functions declaration)

/**
 * Retrieves a wake-up schedule for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the wake-up schedule is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpSchedule.isOnline() to test if the wake-up schedule is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wake-up schedule by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the wake-up schedule
 * 
 * @return a YWakeUpSchedule object allowing you to drive the wake-up schedule.
 */
YWakeUpSchedule* yFindWakeUpSchedule(NSString* func);
/**
 * Starts the enumeration of wake-up schedules currently accessible.
 * Use the method YWakeUpSchedule.nextWakeUpSchedule() to iterate on
 * next wake-up schedules.
 * 
 * @return a pointer to a YWakeUpSchedule object, corresponding to
 *         the first wake-up schedule currently online, or a null pointer
 *         if there are none.
 */
YWakeUpSchedule* yFirstWakeUpSchedule(void);

//--- (end of WakeUpSchedule functions declaration)
CF_EXTERN_C_END

