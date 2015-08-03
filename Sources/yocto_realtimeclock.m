/*********************************************************************
 *
 * $Id: yocto_realtimeclock.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for RealTimeClock functions
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


#import "yocto_realtimeclock.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YRealTimeClock

// Constructor is protected, use yFindRealTimeClock factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"RealTimeClock";
//--- (YRealTimeClock attributes initialization)
    _unixTime = Y_UNIXTIME_INVALID;
    _dateTime = Y_DATETIME_INVALID;
    _utcOffset = Y_UTCOFFSET_INVALID;
    _timeSet = Y_TIMESET_INVALID;
    _valueCallbackRealTimeClock = NULL;
//--- (end of YRealTimeClock attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YRealTimeClock cleanup)
    ARC_release(_dateTime);
    _dateTime = nil;
    ARC_dealloc(super);
//--- (end of YRealTimeClock cleanup)
}
//--- (YRealTimeClock private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "unixTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _unixTime =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "dateTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_dateTime);
        _dateTime =  [self _parseString:j];
        ARC_retain(_dateTime);
        return 1;
    }
    if(!strcmp(j->token, "utcOffset")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _utcOffset =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "timeSet")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _timeSet =  (Y_TIMESET_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YRealTimeClock private methods implementation)
//--- (YRealTimeClock public methods implementation)
/**
 * Returns the current time in Unix format (number of elapsed seconds since Jan 1st, 1970).
 *
 * @return an integer corresponding to the current time in Unix format (number of elapsed seconds
 * since Jan 1st, 1970)
 *
 * On failure, throws an exception or returns Y_UNIXTIME_INVALID.
 */
-(s64) get_unixTime
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_UNIXTIME_INVALID;
        }
    }
    return _unixTime;
}


-(s64) unixTime
{
    return [self get_unixTime];
}

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
-(int) set_unixTime:(s64) newval
{
    return [self setUnixTime:newval];
}
-(int) setUnixTime:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"unixTime" :rest_val];
}
/**
 * Returns the current time in the form "YYYY/MM/DD hh:mm:ss"
 *
 * @return a string corresponding to the current time in the form "YYYY/MM/DD hh:mm:ss"
 *
 * On failure, throws an exception or returns Y_DATETIME_INVALID.
 */
-(NSString*) get_dateTime
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DATETIME_INVALID;
        }
    }
    return _dateTime;
}


-(NSString*) dateTime
{
    return [self get_dateTime];
}
/**
 * Returns the number of seconds between current time and UTC time (time zone).
 *
 * @return an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * On failure, throws an exception or returns Y_UTCOFFSET_INVALID.
 */
-(int) get_utcOffset
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_UTCOFFSET_INVALID;
        }
    }
    return _utcOffset;
}


-(int) utcOffset
{
    return [self get_utcOffset];
}

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
-(int) set_utcOffset:(int) newval
{
    return [self setUtcOffset:newval];
}
-(int) setUtcOffset:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"utcOffset" :rest_val];
}
/**
 * Returns true if the clock has been set, and false otherwise.
 *
 * @return either Y_TIMESET_FALSE or Y_TIMESET_TRUE, according to true if the clock has been set, and
 * false otherwise
 *
 * On failure, throws an exception or returns Y_TIMESET_INVALID.
 */
-(Y_TIMESET_enum) get_timeSet
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TIMESET_INVALID;
        }
    }
    return _timeSet;
}


-(Y_TIMESET_enum) timeSet
{
    return [self get_timeSet];
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
 * Use the method YRealTimeClock.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YRealTimeClock object allowing you to drive $THEFUNCTION$.
 */
+(YRealTimeClock*) FindRealTimeClock:(NSString*)func
{
    YRealTimeClock* obj;
    obj = (YRealTimeClock*) [YFunction _FindFromCache:@"RealTimeClock" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YRealTimeClock alloc] initWith:func]);
        [YFunction _AddToCache:@"RealTimeClock" : func :obj];
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
-(int) registerValueCallback:(YRealTimeClockValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackRealTimeClock = callback;
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
    if (_valueCallbackRealTimeClock != NULL) {
        _valueCallbackRealTimeClock(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YRealTimeClock*)   nextRealTimeClock
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YRealTimeClock FindRealTimeClock:hwid];
}

+(YRealTimeClock *) FirstRealTimeClock
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"RealTimeClock":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRealTimeClock FindRealTimeClock:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YRealTimeClock public methods implementation)

@end
//--- (RealTimeClock functions)

YRealTimeClock *yFindRealTimeClock(NSString* func)
{
    return [YRealTimeClock FindRealTimeClock:func];
}

YRealTimeClock *yFirstRealTimeClock(void)
{
    return [YRealTimeClock FirstRealTimeClock];
}

//--- (end of RealTimeClock functions)
