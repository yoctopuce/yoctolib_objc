/*********************************************************************
 *
 * $Id: yocto_wakeupschedule.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for WakeUpSchedule functions
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


#import "yocto_wakeupschedule.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YWakeUpSchedule

// Constructor is protected, use yFindWakeUpSchedule factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"WakeUpSchedule";
//--- (YWakeUpSchedule attributes initialization)
    _minutesA = Y_MINUTESA_INVALID;
    _minutesB = Y_MINUTESB_INVALID;
    _hours = Y_HOURS_INVALID;
    _weekDays = Y_WEEKDAYS_INVALID;
    _monthDays = Y_MONTHDAYS_INVALID;
    _months = Y_MONTHS_INVALID;
    _nextOccurence = Y_NEXTOCCURENCE_INVALID;
    _valueCallbackWakeUpSchedule = NULL;
//--- (end of YWakeUpSchedule attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YWakeUpSchedule cleanup)
    ARC_dealloc(super);
//--- (end of YWakeUpSchedule cleanup)
}
//--- (YWakeUpSchedule private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "minutesA")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _minutesA =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "minutesB")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _minutesB =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "hours")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _hours =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "weekDays")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _weekDays =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "monthDays")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _monthDays =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "months")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _months =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "nextOccurence")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nextOccurence =  atol(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YWakeUpSchedule private methods implementation)
//--- (YWakeUpSchedule public methods implementation)
/**
 * Returns the minutes in the 00-29 interval of each hour scheduled for wake up.
 *
 * @return an integer corresponding to the minutes in the 00-29 interval of each hour scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MINUTESA_INVALID.
 */
-(int) get_minutesA
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MINUTESA_INVALID;
        }
    }
    return _minutesA;
}


-(int) minutesA
{
    return [self get_minutesA];
}

/**
 * Changes the minutes in the 00-29 interval when a wake up must take place.
 *
 * @param newval : an integer corresponding to the minutes in the 00-29 interval when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutesA:(int) newval
{
    return [self setMinutesA:newval];
}
-(int) setMinutesA:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"minutesA" :rest_val];
}
/**
 * Returns the minutes in the 30-59 intervalof each hour scheduled for wake up.
 *
 * @return an integer corresponding to the minutes in the 30-59 intervalof each hour scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MINUTESB_INVALID.
 */
-(int) get_minutesB
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MINUTESB_INVALID;
        }
    }
    return _minutesB;
}


-(int) minutesB
{
    return [self get_minutesB];
}

/**
 * Changes the minutes in the 30-59 interval when a wake up must take place.
 *
 * @param newval : an integer corresponding to the minutes in the 30-59 interval when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutesB:(int) newval
{
    return [self setMinutesB:newval];
}
-(int) setMinutesB:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"minutesB" :rest_val];
}
/**
 * Returns the hours scheduled for wake up.
 *
 * @return an integer corresponding to the hours scheduled for wake up
 *
 * On failure, throws an exception or returns Y_HOURS_INVALID.
 */
-(int) get_hours
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_HOURS_INVALID;
        }
    }
    return _hours;
}


-(int) hours
{
    return [self get_hours];
}

/**
 * Changes the hours when a wake up must take place.
 *
 * @param newval : an integer corresponding to the hours when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hours:(int) newval
{
    return [self setHours:newval];
}
-(int) setHours:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"hours" :rest_val];
}
/**
 * Returns the days of the week scheduled for wake up.
 *
 * @return an integer corresponding to the days of the week scheduled for wake up
 *
 * On failure, throws an exception or returns Y_WEEKDAYS_INVALID.
 */
-(int) get_weekDays
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_WEEKDAYS_INVALID;
        }
    }
    return _weekDays;
}


-(int) weekDays
{
    return [self get_weekDays];
}

/**
 * Changes the days of the week when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the week when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_weekDays:(int) newval
{
    return [self setWeekDays:newval];
}
-(int) setWeekDays:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"weekDays" :rest_val];
}
/**
 * Returns the days of the month scheduled for wake up.
 *
 * @return an integer corresponding to the days of the month scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MONTHDAYS_INVALID.
 */
-(int) get_monthDays
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MONTHDAYS_INVALID;
        }
    }
    return _monthDays;
}


-(int) monthDays
{
    return [self get_monthDays];
}

/**
 * Changes the days of the month when a wake up must take place.
 *
 * @param newval : an integer corresponding to the days of the month when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_monthDays:(int) newval
{
    return [self setMonthDays:newval];
}
-(int) setMonthDays:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"monthDays" :rest_val];
}
/**
 * Returns the months scheduled for wake up.
 *
 * @return an integer corresponding to the months scheduled for wake up
 *
 * On failure, throws an exception or returns Y_MONTHS_INVALID.
 */
-(int) get_months
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MONTHS_INVALID;
        }
    }
    return _months;
}


-(int) months
{
    return [self get_months];
}

/**
 * Changes the months when a wake up must take place.
 *
 * @param newval : an integer corresponding to the months when a wake up must take place
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_months:(int) newval
{
    return [self setMonths:newval];
}
-(int) setMonths:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"months" :rest_val];
}
/**
 * Returns the date/time (seconds) of the next wake up occurence
 *
 * @return an integer corresponding to the date/time (seconds) of the next wake up occurence
 *
 * On failure, throws an exception or returns Y_NEXTOCCURENCE_INVALID.
 */
-(s64) get_nextOccurence
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEXTOCCURENCE_INVALID;
        }
    }
    return _nextOccurence;
}


-(s64) nextOccurence
{
    return [self get_nextOccurence];
}
/**
 * Retrieves $AFUNCTION$ for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that $THEFUNCTION$ is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWakeUpSchedule.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YWakeUpSchedule object allowing you to drive $THEFUNCTION$.
 */
+(YWakeUpSchedule*) FindWakeUpSchedule:(NSString*)func
{
    YWakeUpSchedule* obj;
    obj = (YWakeUpSchedule*) [YFunction _FindFromCache:@"WakeUpSchedule" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YWakeUpSchedule alloc] initWith:func]);
        [YFunction _AddToCache:@"WakeUpSchedule" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YWakeUpScheduleValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackWakeUpSchedule = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackWakeUpSchedule != NULL) {
        _valueCallbackWakeUpSchedule(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Returns all the minutes of each hour that are scheduled for wake up.
 */
-(s64) get_minutes
{
    s64 res;
    // may throw an exception
    res = [self get_minutesB];
    res = ((res) << (30));
    res = res + [self get_minutesA];
    return res;
}

/**
 * Changes all the minutes where a wake up must take place.
 *
 * @param bitmap : Minutes 00-59 of each hour scheduled for wake up.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutes:(s64)bitmap
{
    [self set_minutesA:(int)(((bitmap) & (0x3fffffff)))];
    bitmap = ((bitmap) >> (30));
    return [self set_minutesB:(int)(((bitmap) & (0x3fffffff)))];
}


-(YWakeUpSchedule*)   nextWakeUpSchedule
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YWakeUpSchedule FindWakeUpSchedule:hwid];
}

+(YWakeUpSchedule *) FirstWakeUpSchedule
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"WakeUpSchedule":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YWakeUpSchedule FindWakeUpSchedule:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YWakeUpSchedule public methods implementation)

@end
//--- (WakeUpSchedule functions)

YWakeUpSchedule *yFindWakeUpSchedule(NSString* func)
{
    return [YWakeUpSchedule FindWakeUpSchedule:func];
}

YWakeUpSchedule *yFirstWakeUpSchedule(void)
{
    return [YWakeUpSchedule FirstWakeUpSchedule];
}

//--- (end of WakeUpSchedule functions)
