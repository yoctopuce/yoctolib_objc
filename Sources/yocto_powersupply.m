/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for PowerSupply functions
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


#import "yocto_powersupply.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YPowerSupply
// Constructor is protected, use yFindPowerSupply factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"PowerSupply";
//--- (YPowerSupply attributes initialization)
    _voltageLimit = Y_VOLTAGELIMIT_INVALID;
    _currentLimit = Y_CURRENTLIMIT_INVALID;
    _powerOutput = Y_POWEROUTPUT_INVALID;
    _measuredVoltage = Y_MEASUREDVOLTAGE_INVALID;
    _measuredCurrent = Y_MEASUREDCURRENT_INVALID;
    _inputVoltage = Y_INPUTVOLTAGE_INVALID;
    _voltageTransition = Y_VOLTAGETRANSITION_INVALID;
    _voltageLimitAtStartUp = Y_VOLTAGELIMITATSTARTUP_INVALID;
    _currentLimitAtStartUp = Y_CURRENTLIMITATSTARTUP_INVALID;
    _powerOutputAtStartUp = Y_POWEROUTPUTATSTARTUP_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackPowerSupply = NULL;
//--- (end of YPowerSupply attributes initialization)
    return self;
}
//--- (YPowerSupply yapiwrapper)
//--- (end of YPowerSupply yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YPowerSupply cleanup)
    ARC_release(_voltageTransition);
    _voltageTransition = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YPowerSupply cleanup)
}
//--- (YPowerSupply private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "voltageLimit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageLimit =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentLimit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentLimit =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "powerOutput")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerOutput =  (Y_POWEROUTPUT_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "measuredVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _measuredVoltage =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "measuredCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _measuredCurrent =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "inputVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _inputVoltage =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "voltageTransition")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_voltageTransition);
        _voltageTransition =  [self _parseString:j];
        ARC_retain(_voltageTransition);
        return 1;
    }
    if(!strcmp(j->token, "voltageLimitAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageLimitAtStartUp =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentLimitAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentLimitAtStartUp =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "powerOutputAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerOutputAtStartUp =  (Y_POWEROUTPUTATSTARTUP_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPowerSupply private methods implementation)
//--- (YPowerSupply public methods implementation)

/**
 * Changes the voltage limit, in V.
 *
 * @param newval : a floating point number corresponding to the voltage limit, in V
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageLimit:(double) newval
{
    return [self setVoltageLimit:newval];
}
-(int) setVoltageLimit:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"voltageLimit" :rest_val];
}
/**
 * Returns the voltage limit, in V.
 *
 * @return a floating point number corresponding to the voltage limit, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGELIMIT_INVALID.
 */
-(double) get_voltageLimit
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGELIMIT_INVALID;
        }
    }
    res = _voltageLimit;
    return res;
}


-(double) voltageLimit
{
    return [self get_voltageLimit];
}

/**
 * Changes the current limit, in mA.
 *
 * @param newval : a floating point number corresponding to the current limit, in mA
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentLimit:(double) newval
{
    return [self setCurrentLimit:newval];
}
-(int) setCurrentLimit:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentLimit" :rest_val];
}
/**
 * Returns the current limit, in mA.
 *
 * @return a floating point number corresponding to the current limit, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.CURRENTLIMIT_INVALID.
 */
-(double) get_currentLimit
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTLIMIT_INVALID;
        }
    }
    res = _currentLimit;
    return res;
}


-(double) currentLimit
{
    return [self get_currentLimit];
}
/**
 * Returns the power supply output switch state.
 *
 * @return either YPowerSupply.POWEROUTPUT_OFF or YPowerSupply.POWEROUTPUT_ON, according to the power
 * supply output switch state
 *
 * On failure, throws an exception or returns YPowerSupply.POWEROUTPUT_INVALID.
 */
-(Y_POWEROUTPUT_enum) get_powerOutput
{
    Y_POWEROUTPUT_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWEROUTPUT_INVALID;
        }
    }
    res = _powerOutput;
    return res;
}


-(Y_POWEROUTPUT_enum) powerOutput
{
    return [self get_powerOutput];
}

/**
 * Changes the power supply output switch state.
 *
 * @param newval : either YPowerSupply.POWEROUTPUT_OFF or YPowerSupply.POWEROUTPUT_ON, according to
 * the power supply output switch state
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerOutput:(Y_POWEROUTPUT_enum) newval
{
    return [self setPowerOutput:newval];
}
-(int) setPowerOutput:(Y_POWEROUTPUT_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"powerOutput" :rest_val];
}
/**
 * Returns the measured output voltage, in V.
 *
 * @return a floating point number corresponding to the measured output voltage, in V
 *
 * On failure, throws an exception or returns YPowerSupply.MEASUREDVOLTAGE_INVALID.
 */
-(double) get_measuredVoltage
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MEASUREDVOLTAGE_INVALID;
        }
    }
    res = _measuredVoltage;
    return res;
}


-(double) measuredVoltage
{
    return [self get_measuredVoltage];
}
/**
 * Returns the measured output current, in mA.
 *
 * @return a floating point number corresponding to the measured output current, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.MEASUREDCURRENT_INVALID.
 */
-(double) get_measuredCurrent
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MEASUREDCURRENT_INVALID;
        }
    }
    res = _measuredCurrent;
    return res;
}


-(double) measuredCurrent
{
    return [self get_measuredCurrent];
}
/**
 * Returns the measured input voltage, in V.
 *
 * @return a floating point number corresponding to the measured input voltage, in V
 *
 * On failure, throws an exception or returns YPowerSupply.INPUTVOLTAGE_INVALID.
 */
-(double) get_inputVoltage
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_INPUTVOLTAGE_INVALID;
        }
    }
    res = _inputVoltage;
    return res;
}


-(double) inputVoltage
{
    return [self get_inputVoltage];
}
-(NSString*) get_voltageTransition
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGETRANSITION_INVALID;
        }
    }
    res = _voltageTransition;
    return res;
}


-(NSString*) voltageTransition
{
    return [self get_voltageTransition];
}

-(int) set_voltageTransition:(NSString*) newval
{
    return [self setVoltageTransition:newval];
}
-(int) setVoltageTransition:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"voltageTransition" :rest_val];
}

/**
 * Changes the voltage set point at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the voltage set point at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageLimitAtStartUp:(double) newval
{
    return [self setVoltageLimitAtStartUp:newval];
}
-(int) setVoltageLimitAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"voltageLimitAtStartUp" :rest_val];
}
/**
 * Returns the selected voltage limit at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage limit at device startup, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGELIMITATSTARTUP_INVALID.
 */
-(double) get_voltageLimitAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGELIMITATSTARTUP_INVALID;
        }
    }
    res = _voltageLimitAtStartUp;
    return res;
}


-(double) voltageLimitAtStartUp
{
    return [self get_voltageLimitAtStartUp];
}

/**
 * Changes the current limit at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the current limit at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentLimitAtStartUp:(double) newval
{
    return [self setCurrentLimitAtStartUp:newval];
}
-(int) setCurrentLimitAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentLimitAtStartUp" :rest_val];
}
/**
 * Returns the selected current limit at device startup, in mA.
 *
 * @return a floating point number corresponding to the selected current limit at device startup, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.CURRENTLIMITATSTARTUP_INVALID.
 */
-(double) get_currentLimitAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTLIMITATSTARTUP_INVALID;
        }
    }
    res = _currentLimitAtStartUp;
    return res;
}


-(double) currentLimitAtStartUp
{
    return [self get_currentLimitAtStartUp];
}
/**
 * Returns the power supply output switch state.
 *
 * @return either YPowerSupply.POWEROUTPUTATSTARTUP_OFF or YPowerSupply.POWEROUTPUTATSTARTUP_ON,
 * according to the power supply output switch state
 *
 * On failure, throws an exception or returns YPowerSupply.POWEROUTPUTATSTARTUP_INVALID.
 */
-(Y_POWEROUTPUTATSTARTUP_enum) get_powerOutputAtStartUp
{
    Y_POWEROUTPUTATSTARTUP_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWEROUTPUTATSTARTUP_INVALID;
        }
    }
    res = _powerOutputAtStartUp;
    return res;
}


-(Y_POWEROUTPUTATSTARTUP_enum) powerOutputAtStartUp
{
    return [self get_powerOutputAtStartUp];
}

/**
 * Changes the power supply output switch state at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : either YPowerSupply.POWEROUTPUTATSTARTUP_OFF or
 * YPowerSupply.POWEROUTPUTATSTARTUP_ON, according to the power supply output switch state at device start up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerOutputAtStartUp:(Y_POWEROUTPUTATSTARTUP_enum) newval
{
    return [self setPowerOutputAtStartUp:newval];
}
-(int) setPowerOutputAtStartUp:(Y_POWEROUTPUTATSTARTUP_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"powerOutputAtStartUp" :rest_val];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a regulated power supply for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the regulated power supply is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPowerSupply.isOnline() to test if the regulated power supply is
 * indeed online at a given time. In case of ambiguity when looking for
 * a regulated power supply by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the regulated power supply, for instance
 *         MyDevice.powerSupply.
 *
 * @return a YPowerSupply object allowing you to drive the regulated power supply.
 */
+(YPowerSupply*) FindPowerSupply:(NSString*)func
{
    YPowerSupply* obj;
    obj = (YPowerSupply*) [YFunction _FindFromCache:@"PowerSupply" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPowerSupply alloc] initWith:func]);
        [YFunction _AddToCache:@"PowerSupply" :func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YPowerSupplyValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPowerSupply = callback;
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
    if (_valueCallbackPowerSupply != NULL) {
        _valueCallbackPowerSupply(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Performs a smooth transition of output voltage. Any explicit voltage
 * change cancels any ongoing transition process.
 *
 * @param V_target   : new output voltage value at the end of the transition
 *         (floating-point number, representing the end voltage in V)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI.SUCCESS when the call succeeds.
 */
-(int) voltageMove:(double)V_target :(int)ms_duration
{
    NSString* newval;
    if (V_target < 0.0) {
        V_target  = 0.0;
    }
    newval = [NSString stringWithFormat:@"%d:%d",(int) floor(V_target*65536+0.5),ms_duration];

    return [self set_voltageTransition:newval];
}


-(YPowerSupply*)   nextPowerSupply
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPowerSupply FindPowerSupply:hwid];
}

+(YPowerSupply *) FirstPowerSupply
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"PowerSupply":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPowerSupply FindPowerSupply:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPowerSupply public methods implementation)
@end

//--- (YPowerSupply functions)

YPowerSupply *yFindPowerSupply(NSString* func)
{
    return [YPowerSupply FindPowerSupply:func];
}

YPowerSupply *yFirstPowerSupply(void)
{
    return [YPowerSupply FirstPowerSupply];
}

//--- (end of YPowerSupply functions)

