/*********************************************************************
 *
 * $Id: yocto_vsource.m 10263 2013-03-11 17:25:38Z seb $
 *
 * Implements yFindVSource(), the high-level API for VSource functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/


#import "yocto_vsource.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


static NSMutableDictionary* _VSourceCache = nil;

@implementation YVSource

// Constructor is protected, use yFindVSource factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YVSource attributes)
   if(!(self = [super initProtected:@"VSource":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _unit = Y_UNIT_INVALID;
    _voltage = Y_VOLTAGE_INVALID;
    _failure = Y_FAILURE_INVALID;
    _overHeat = Y_OVERHEAT_INVALID;
    _overCurrent = Y_OVERCURRENT_INVALID;
    _overLoad = Y_OVERLOAD_INVALID;
    _regulationFailure = Y_REGULATIONFAILURE_INVALID;
    _extPowerFailure = Y_EXTPOWERFAILURE_INVALID;
//--- (end of YVSource attributes)
    return self;
}
//--- (YVSource implementation)

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
        } else if(!strcmp(j->token, "unit")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_unit);
            _unit =  [self _parseString:j];
            ARC_retain(_unit);
        } else if(!strcmp(j->token, "voltage")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _voltage =  atoi(j->token);
        } else if(!strcmp(j->token, "failure")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _failure =  (Y_FAILURE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "overHeat")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _overHeat =  (Y_OVERHEAT_enum)atoi(j->token);
        } else if(!strcmp(j->token, "overCurrent")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _overCurrent =  (Y_OVERCURRENT_enum)atoi(j->token);
        } else if(!strcmp(j->token, "overLoad")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _overLoad =  (Y_OVERLOAD_enum)atoi(j->token);
        } else if(!strcmp(j->token, "regulationFailure")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _regulationFailure =  (Y_REGULATIONFAILURE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "extPowerFailure")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _extPowerFailure =  (Y_EXTPOWERFAILURE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "move")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _move.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else if(!strcmp(j->token, "pulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _pulseTimer.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _pulseTimer.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _pulseTimer.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the voltage source.
 * 
 * @return a string corresponding to the logical name of the voltage source
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
 * Changes the logical name of the voltage source. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the voltage source
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
 * Returns the current value of the voltage source (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the voltage source (no more than 6 characters)
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
 * Returns the measuring unit for the voltage.
 * 
 * @return a string corresponding to the measuring unit for the voltage
 * 
 * On failure, throws an exception or returns Y_UNIT_INVALID.
 */
-(NSString*) get_unit
{
    return [self unit];
}
-(NSString*) unit
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UNIT_INVALID;
    }
    return _unit;
}

/**
 * Returns the voltage output command (mV)
 * 
 * @return an integer corresponding to the voltage output command (mV)
 * 
 * On failure, throws an exception or returns Y_VOLTAGE_INVALID.
 */
-(int) get_voltage
{
    return [self voltage];
}
-(int) voltage
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_VOLTAGE_INVALID;
    }
    return _voltage;
}

/**
 * Tunes the device output voltage (milliVolts).
 * 
 * @param newval : an integer
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltage:(int) newval
{
    return [self setVoltage:newval];
}
-(int) setVoltage:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"voltage" :rest_val];
}

/**
 * Returns true if the  module is in failure mode. More information can be obtained by testing
 * get_overheat, get_overcurrent etc... When a error condition is met, the output voltage is
 * set to zéro and cannot be changed until the reset() function is called.
 * 
 * @return either Y_FAILURE_FALSE or Y_FAILURE_TRUE, according to true if the  module is in failure mode
 * 
 * On failure, throws an exception or returns Y_FAILURE_INVALID.
 */
-(Y_FAILURE_enum) get_failure
{
    return [self failure];
}
-(Y_FAILURE_enum) failure
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_FAILURE_INVALID;
    }
    return _failure;
}

-(int) set_failure:(Y_FAILURE_enum) newval
{
    return [self setFailure:newval];
}
-(int) setFailure:(Y_FAILURE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"failure" :rest_val];
}

/**
 * Returns TRUE if the  module is overheating.
 * 
 * @return either Y_OVERHEAT_FALSE or Y_OVERHEAT_TRUE, according to TRUE if the  module is overheating
 * 
 * On failure, throws an exception or returns Y_OVERHEAT_INVALID.
 */
-(Y_OVERHEAT_enum) get_overHeat
{
    return [self overHeat];
}
-(Y_OVERHEAT_enum) overHeat
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OVERHEAT_INVALID;
    }
    return _overHeat;
}

/**
 * Returns true if the appliance connected to the device is too greedy .
 * 
 * @return either Y_OVERCURRENT_FALSE or Y_OVERCURRENT_TRUE, according to true if the appliance
 * connected to the device is too greedy
 * 
 * On failure, throws an exception or returns Y_OVERCURRENT_INVALID.
 */
-(Y_OVERCURRENT_enum) get_overCurrent
{
    return [self overCurrent];
}
-(Y_OVERCURRENT_enum) overCurrent
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OVERCURRENT_INVALID;
    }
    return _overCurrent;
}

/**
 * Returns true if the device is not able to maintaint the requested voltage output  .
 * 
 * @return either Y_OVERLOAD_FALSE or Y_OVERLOAD_TRUE, according to true if the device is not able to
 * maintaint the requested voltage output
 * 
 * On failure, throws an exception or returns Y_OVERLOAD_INVALID.
 */
-(Y_OVERLOAD_enum) get_overLoad
{
    return [self overLoad];
}
-(Y_OVERLOAD_enum) overLoad
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OVERLOAD_INVALID;
    }
    return _overLoad;
}

/**
 * Returns true if the voltage output is too high regarding the requested voltage  .
 * 
 * @return either Y_REGULATIONFAILURE_FALSE or Y_REGULATIONFAILURE_TRUE, according to true if the
 * voltage output is too high regarding the requested voltage
 * 
 * On failure, throws an exception or returns Y_REGULATIONFAILURE_INVALID.
 */
-(Y_REGULATIONFAILURE_enum) get_regulationFailure
{
    return [self regulationFailure];
}
-(Y_REGULATIONFAILURE_enum) regulationFailure
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_REGULATIONFAILURE_INVALID;
    }
    return _regulationFailure;
}

/**
 * Returns true if external power supply voltage is too low.
 * 
 * @return either Y_EXTPOWERFAILURE_FALSE or Y_EXTPOWERFAILURE_TRUE, according to true if external
 * power supply voltage is too low
 * 
 * On failure, throws an exception or returns Y_EXTPOWERFAILURE_INVALID.
 */
-(Y_EXTPOWERFAILURE_enum) get_extPowerFailure
{
    return [self extPowerFailure];
}
-(Y_EXTPOWERFAILURE_enum) extPowerFailure
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_EXTPOWERFAILURE_INVALID;
    }
    return _extPowerFailure;
}

-(YRETCODE) get_move :(s32*)target :(s16*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _move.target;
    *ms = _move.ms;
    *moving = _move.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_move :(s32)target :(s16)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
    return [self _setAttr:@"move" :rest_val];
}

/**
 * Performs a smooth move at constant speed toward a given value.
 * 
 * @param target      : new output value at end of transition, in milliVolts.
 * @param ms_duration : transition duration, in milliseconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) voltageMove :(int)target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms_duration];
    return [self _setAttr:@"move" :rest_val];
}

-(YRETCODE) get_pulseTimer :(s16*)target :(s32*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _pulseTimer.target;
    *ms = _pulseTimer.ms;
    *moving = _pulseTimer.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_pulseTimer :(s16)target :(s32)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

/**
 * Sets device output to a specific volatage, for a specified duration, then brings it
 * automatically to 0V.
 * 
 * @param voltage : pulse voltage, in millivolts
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulse :(int)voltage :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",voltage,ms_duration];
    return [self _setAttr:@"pulseTimer" :rest_val];
}

-(YVSource*)   nextVSource
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindVSource(hwid);
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

+(YVSource*) FindVSource:(NSString*) func
{
    YVSource * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    {
        if (_VSourceCache == nil){
            _VSourceCache = [[NSMutableDictionary alloc] init];
        }
        if(nil != [_VSourceCache objectForKey:func]){
            retVal = [_VSourceCache objectForKey:func];
       } else {
           YVSource *newVSource = [[YVSource alloc] initWithFunction:func];
           [_VSourceCache setObject:newVSource forKey:func];
           retVal = newVSource;
           ARC_autorelease(retVal);
       }
   }
   return retVal;
}

+(YVSource *) FirstVSource
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"VSource":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YVSource FindVSource:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YVSource implementation)

@end
//--- (VSource functions)

YVSource *yFindVSource(NSString* func)
{
    return [YVSource FindVSource:func];
}

YVSource *yFirstVSource(void)
{
    return [YVSource FirstVSource];
}

//--- (end of VSource functions)
