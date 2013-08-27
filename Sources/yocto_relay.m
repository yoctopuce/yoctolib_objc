/*********************************************************************
 *
 * $Id: yocto_relay.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindRelay(), the high-level API for Relay functions
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


#import "yocto_relay.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YRelay

// Constructor is protected, use yFindRelay factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YRelay attributes)
   if(!(self = [super initProtected:@"Relay":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _state = Y_STATE_INVALID;
    _output = Y_OUTPUT_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _countdown = Y_COUNTDOWN_INVALID;
//--- (end of YRelay attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YRelay cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of YRelay cleanup)
    ARC_dealloc(super);
}
//--- (YRelay implementation)

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
        } else if(!strcmp(j->token, "state")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _state =  (Y_STATE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "output")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _output =  (Y_OUTPUT_enum)atoi(j->token);
        } else if(!strcmp(j->token, "pulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _pulseTimer =  atoi(j->token);
        } else if(!strcmp(j->token, "delayedPulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _delayedPulseTimer.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else if(!strcmp(j->token, "countdown")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _countdown =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the relay.
 * 
 * @return a string corresponding to the logical name of the relay
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
 * Changes the logical name of the relay. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the relay
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
 * Returns the current value of the relay (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the relay (no more than 6 characters)
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
 * Returns the state of the relays (A for the idle position, B for the active position).
 * 
 * @return either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
 * 
 * On failure, throws an exception or returns Y_STATE_INVALID.
 */
-(Y_STATE_enum) get_state
{
    return [self state];
}
-(Y_STATE_enum) state
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_STATE_INVALID;
    }
    return _state;
}

/**
 * Changes the state of the relays (A for the idle position, B for the active position).
 * 
 * @param newval : either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_state:(Y_STATE_enum) newval
{
    return [self setState:newval];
}
-(int) setState:(Y_STATE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"state" :rest_val];
}

/**
 * Returns the output state of the relays, when used as a simple switch (single throw).
 * 
 * @return either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays, when used
 * as a simple switch (single throw)
 * 
 * On failure, throws an exception or returns Y_OUTPUT_INVALID.
 */
-(Y_OUTPUT_enum) get_output
{
    return [self output];
}
-(Y_OUTPUT_enum) output
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OUTPUT_INVALID;
    }
    return _output;
}

/**
 * Changes the output state of the relays, when used as a simple switch (single throw).
 * 
 * @param newval : either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays,
 * when used as a simple switch (single throw)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_output:(Y_OUTPUT_enum) newval
{
    return [self setOutput:newval];
}
-(int) setOutput:(Y_OUTPUT_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"output" :rest_val];
}

/**
 * Returns the number of milliseconds remaining before the relays is returned to idle position
 * (state A), during a measured pulse generation. When there is no ongoing pulse, returns zero.
 * 
 * @return an integer corresponding to the number of milliseconds remaining before the relays is
 * returned to idle position
 *         (state A), during a measured pulse generation
 * 
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(unsigned) get_pulseTimer
{
    return [self pulseTimer];
}
-(unsigned) pulseTimer
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PULSETIMER_INVALID;
    }
    return _pulseTimer;
}

-(int) set_pulseTimer:(unsigned) newval
{
    return [self setPulseTimer:newval];
}
-(int) setPulseTimer:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

/**
 * Sets the relay to output B (active) for a specified duration, then brings it
 * automatically back to output A (idle state).
 * 
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulse :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", ms_duration];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

-(YRETCODE) get_delayedPulseTimer :(s32*)target :(s32*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _delayedPulseTimer.target;
    *ms = _delayedPulseTimer.ms;
    *moving = _delayedPulseTimer.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_delayedPulseTimer :(s32)target :(s32)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
    return [self _setAttr:@"delayedPulseTimer" :rest_val];
}

/**
 * Schedules a pulse.
 * 
 * @param ms_delay : waiting time before the pulse, in millisecondes
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) delayedPulse :(int)ms_delay :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",ms_delay,ms_duration];
    return [self _setAttr:@"delayedPulseTimer" :rest_val];
}

/**
 * Returns the number of milliseconds remaining before a pulse (delayedPulse() call)
 * When there is no scheduled pulse, returns zero.
 * 
 * @return an integer corresponding to the number of milliseconds remaining before a pulse (delayedPulse() call)
 *         When there is no scheduled pulse, returns zero
 * 
 * On failure, throws an exception or returns Y_COUNTDOWN_INVALID.
 */
-(unsigned) get_countdown
{
    return [self countdown];
}
-(unsigned) countdown
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_COUNTDOWN_INVALID;
    }
    return _countdown;
}

-(YRelay*)   nextRelay
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindRelay(hwid);
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

+(YRelay*) FindRelay:(NSString*) func
{
    YRelay * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YRelay"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YRelay"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YRelay"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YRelay"] objectForKey:func];
    } else {
        retVal = [[YRelay alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YRelay"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YRelay *) FirstRelay
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Relay":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRelay FindRelay:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YRelay implementation)

@end
//--- (Relay functions)

YRelay *yFindRelay(NSString* func)
{
    return [YRelay FindRelay:func];
}

YRelay *yFirstRelay(void)
{
    return [YRelay FirstRelay];
}

//--- (end of Relay functions)
