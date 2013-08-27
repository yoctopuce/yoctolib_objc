/*********************************************************************
 *
 * $Id: yocto_wakeupschedule.m 12469 2013-08-22 10:11:58Z seb $
 *
 * Implements yFindWakeUpSchedule(), the high-level API for WakeUpSchedule functions
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
-(id)              initWithFunction:(NSString*) func
{
//--- (YWakeUpSchedule attributes)
   if(!(self = [super initProtected:@"WakeUpSchedule":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _minutesA = Y_MINUTESA_INVALID;
    _minutesB = Y_MINUTESB_INVALID;
    _hours = Y_HOURS_INVALID;
    _weekDays = Y_WEEKDAYS_INVALID;
    _monthDays = Y_MONTHDAYS_INVALID;
    _months = Y_MONTHS_INVALID;
    _nextOccurence = Y_NEXTOCCURENCE_INVALID;
//--- (end of YWakeUpSchedule attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YWakeUpSchedule cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of YWakeUpSchedule cleanup)
    ARC_dealloc(super);
}
//--- (YWakeUpSchedule implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "minutesA")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _minutesA =  atoi(j->token);
        } else if(!strcmp(j->token, "minutesB")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _minutesB =  atoi(j->token);
        } else if(!strcmp(j->token, "hours")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _hours =  atoi(j->token);
        } else if(!strcmp(j->token, "weekDays")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _weekDays =  atoi(j->token);
        } else if(!strcmp(j->token, "monthDays")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _monthDays =  atoi(j->token);
        } else if(!strcmp(j->token, "months")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _months =  atoi(j->token);
        } else if(!strcmp(j->token, "nextOccurence")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _nextOccurence =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the wake-up schedule.
 * 
 * @return a string corresponding to the logical name of the wake-up schedule
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

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
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the wake-up schedule (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the wake-up schedule (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the minutes 00-29 of each hour scheduled for wake-up.
 * 
 * @return an integer corresponding to the minutes 00-29 of each hour scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MINUTESA_INVALID.
 */
-(unsigned) get_minutesA
{
    return [self minutesA];
}
-(unsigned) minutesA
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MINUTESA_INVALID;
    }
    return _minutesA;
}

/**
 * Changes the minutes 00-29 where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the minutes 00-29 where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutesA:(unsigned) newval
{
    return [self setMinutesA:newval];
}
-(int) setMinutesA:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"minutesA" :rest_val];
}

/**
 * Returns the minutes 30-59 of each hour scheduled for wake-up.
 * 
 * @return an integer corresponding to the minutes 30-59 of each hour scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MINUTESB_INVALID.
 */
-(unsigned) get_minutesB
{
    return [self minutesB];
}
-(unsigned) minutesB
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MINUTESB_INVALID;
    }
    return _minutesB;
}

/**
 * Changes the minutes 30-59 where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the minutes 30-59 where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutesB:(unsigned) newval
{
    return [self setMinutesB:newval];
}
-(int) setMinutesB:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"minutesB" :rest_val];
}

/**
 * Returns the hours  scheduled for wake-up.
 * 
 * @return an integer corresponding to the hours  scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_HOURS_INVALID.
 */
-(int) get_hours
{
    return [self hours];
}
-(int) hours
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_HOURS_INVALID;
    }
    return _hours;
}

/**
 * Changes the hours where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the hours where a wake up must take place
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"hours" :rest_val];
}

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_WEEKDAYS_INVALID.
 */
-(int) get_weekDays
{
    return [self weekDays];
}
-(int) weekDays
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_WEEKDAYS_INVALID;
    }
    return _weekDays;
}

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"weekDays" :rest_val];
}

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MONTHDAYS_INVALID.
 */
-(unsigned) get_monthDays
{
    return [self monthDays];
}
-(unsigned) monthDays
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MONTHDAYS_INVALID;
    }
    return _monthDays;
}

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_monthDays:(unsigned) newval
{
    return [self setMonthDays:newval];
}
-(int) setMonthDays:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"monthDays" :rest_val];
}

/**
 * Returns the days of week scheduled for wake-up.
 * 
 * @return an integer corresponding to the days of week scheduled for wake-up
 * 
 * On failure, throws an exception or returns Y_MONTHS_INVALID.
 */
-(int) get_months
{
    return [self months];
}
-(int) months
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MONTHS_INVALID;
    }
    return _months;
}

/**
 * Changes the days of the week where a wake up must take place.
 * 
 * @param newval : an integer corresponding to the days of the week where a wake up must take place
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"months" :rest_val];
}

/**
 * Returns the  nextwake up date/time (seconds) wake up occurence
 * 
 * @return an integer corresponding to the  nextwake up date/time (seconds) wake up occurence
 * 
 * On failure, throws an exception or returns Y_NEXTOCCURENCE_INVALID.
 */
-(unsigned) get_nextOccurence
{
    return [self nextOccurence];
}
-(unsigned) nextOccurence
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_NEXTOCCURENCE_INVALID;
    }
    return _nextOccurence;
}
/**
 * Returns every the minutes of each hour scheduled for wake-up.
 */
-(long) get_minutes
{
    long res;
    res = [self get_minutesB];
    res = res << 30;
    res = res + [self get_minutesA];
    return res;
    
}

/**
 * Changes all the minutes where a wake up must take place.
 * 
 * @param bitmap : Minutes 00-59 of each hour scheduled for wake-up.,
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_minutes :(long)bitmap
{
    [self set_minutesA:bitmap & 0x3fffffff];
    bitmap = bitmap >> 30;
    return [self set_minutesB:bitmap & 0x3fffffff];
    
}


-(YWakeUpSchedule*)   nextWakeUpSchedule
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindWakeUpSchedule(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YWakeUpSchedule*) FindWakeUpSchedule:(NSString*) func
{
    YWakeUpSchedule * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YWakeUpSchedule"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YWakeUpSchedule"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YWakeUpSchedule"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YWakeUpSchedule"] objectForKey:func];
    } else {
        retVal = [[YWakeUpSchedule alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YWakeUpSchedule"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of YWakeUpSchedule implementation)

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
