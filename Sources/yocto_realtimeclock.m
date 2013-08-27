/*********************************************************************
 *
 * $Id: yocto_realtimeclock.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindRealTimeClock(), the high-level API for RealTimeClock functions
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
-(id)              initWithFunction:(NSString*) func
{
//--- (YRealTimeClock attributes)
   if(!(self = [super initProtected:@"RealTimeClock":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _unixTime = Y_UNIXTIME_INVALID;
    _dateTime = Y_DATETIME_INVALID;
    _utcOffset = Y_UTCOFFSET_INVALID;
    _timeSet = Y_TIMESET_INVALID;
//--- (end of YRealTimeClock attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YRealTimeClock cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_release(_dateTime);
    _dateTime = nil;
//--- (end of YRealTimeClock cleanup)
    ARC_dealloc(super);
}
//--- (YRealTimeClock implementation)

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
        } else if(!strcmp(j->token, "unixTime")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _unixTime =  atoi(j->token);
        } else if(!strcmp(j->token, "dateTime")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_dateTime);
            _dateTime =  [self _parseString:j];
            ARC_retain(_dateTime);
        } else if(!strcmp(j->token, "utcOffset")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _utcOffset =  atoi(j->token);
        } else if(!strcmp(j->token, "timeSet")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _timeSet =  (Y_TIMESET_enum)atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the clock.
 * 
 * @return a string corresponding to the logical name of the clock
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
 * Returns the current value of the clock (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the clock (no more than 6 characters)
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
 * Returns the current time in Unix format (number of elapsed seconds since Jan 1st, 1970).
 * 
 * @return an integer corresponding to the current time in Unix format (number of elapsed seconds
 * since Jan 1st, 1970)
 * 
 * On failure, throws an exception or returns Y_UNIXTIME_INVALID.
 */
-(unsigned) get_unixTime
{
    return [self unixTime];
}
-(unsigned) unixTime
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UNIXTIME_INVALID;
    }
    return _unixTime;
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
-(int) set_unixTime:(unsigned) newval
{
    return [self setUnixTime:newval];
}
-(int) setUnixTime:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
    return [self dateTime];
}
-(NSString*) dateTime
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_DATETIME_INVALID;
    }
    return _dateTime;
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
    return [self utcOffset];
}
-(int) utcOffset
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UTCOFFSET_INVALID;
    }
    return _utcOffset;
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
    return [self timeSet];
}
-(Y_TIMESET_enum) timeSet
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_TIMESET_INVALID;
    }
    return _timeSet;
}

-(YRealTimeClock*)   nextRealTimeClock
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindRealTimeClock(hwid);
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

+(YRealTimeClock*) FindRealTimeClock:(NSString*) func
{
    YRealTimeClock * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YRealTimeClock"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YRealTimeClock"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YRealTimeClock"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YRealTimeClock"] objectForKey:func];
    } else {
        retVal = [[YRealTimeClock alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YRealTimeClock"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of YRealTimeClock implementation)

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
