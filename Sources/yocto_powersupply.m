/*********************************************************************
 *
 *  $Id: yocto_powersupply.m 43619 2021-01-29 09:14:45Z mvuilleu $
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
    _voltageSetPoint = Y_VOLTAGESETPOINT_INVALID;
    _currentLimit = Y_CURRENTLIMIT_INVALID;
    _powerOutput = Y_POWEROUTPUT_INVALID;
    _voltageSense = Y_VOLTAGESENSE_INVALID;
    _measuredVoltage = Y_MEASUREDVOLTAGE_INVALID;
    _measuredCurrent = Y_MEASUREDCURRENT_INVALID;
    _inputVoltage = Y_INPUTVOLTAGE_INVALID;
    _vInt = Y_VINT_INVALID;
    _ldoTemperature = Y_LDOTEMPERATURE_INVALID;
    _voltageTransition = Y_VOLTAGETRANSITION_INVALID;
    _voltageAtStartUp = Y_VOLTAGEATSTARTUP_INVALID;
    _currentAtStartUp = Y_CURRENTATSTARTUP_INVALID;
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
    if(!strcmp(j->token, "voltageSetPoint")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageSetPoint =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentLimit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentLimit =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "powerOutput")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerOutput =  (Y_POWEROUTPUT_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "voltageSense")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageSense =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "measuredVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _measuredVoltage =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "measuredCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _measuredCurrent =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "inputVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _inputVoltage =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "vInt")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _vInt =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "ldoTemperature")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ldoTemperature =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "voltageTransition")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_voltageTransition);
        _voltageTransition =  [self _parseString:j];
        ARC_retain(_voltageTransition);
        return 1;
    }
    if(!strcmp(j->token, "voltageAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageAtStartUp =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentAtStartUp =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
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
 * Changes the voltage set point, in V.
 *
 * @param newval : a floating point number corresponding to the voltage set point, in V
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageSetPoint:(double) newval
{
    return [self setVoltageSetPoint:newval];
}
-(int) setVoltageSetPoint:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"voltageSetPoint" :rest_val];
}
/**
 * Returns the voltage set point, in V.
 *
 * @return a floating point number corresponding to the voltage set point, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGESETPOINT_INVALID.
 */
-(double) get_voltageSetPoint
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGESETPOINT_INVALID;
        }
    }
    res = _voltageSetPoint;
    return res;
}


-(double) voltageSetPoint
{
    return [self get_voltageSetPoint];
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
 * Returns the output voltage control point.
 *
 * @return either YPowerSupply.VOLTAGESENSE_INT or YPowerSupply.VOLTAGESENSE_EXT, according to the
 * output voltage control point
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGESENSE_INVALID.
 */
-(Y_VOLTAGESENSE_enum) get_voltageSense
{
    Y_VOLTAGESENSE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGESENSE_INVALID;
        }
    }
    res = _voltageSense;
    return res;
}


-(Y_VOLTAGESENSE_enum) voltageSense
{
    return [self get_voltageSense];
}

/**
 * Changes the voltage control point.
 *
 * @param newval : either YPowerSupply.VOLTAGESENSE_INT or YPowerSupply.VOLTAGESENSE_EXT, according to
 * the voltage control point
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageSense:(Y_VOLTAGESENSE_enum) newval
{
    return [self setVoltageSense:newval];
}
-(int) setVoltageSense:(Y_VOLTAGESENSE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"voltageSense" :rest_val];
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
/**
 * Returns the internal voltage, in V.
 *
 * @return a floating point number corresponding to the internal voltage, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VINT_INVALID.
 */
-(double) get_vInt
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VINT_INVALID;
        }
    }
    res = _vInt;
    return res;
}


-(double) vInt
{
    return [self get_vInt];
}
/**
 * Returns the LDO temperature, in Celsius.
 *
 * @return a floating point number corresponding to the LDO temperature, in Celsius
 *
 * On failure, throws an exception or returns YPowerSupply.LDOTEMPERATURE_INVALID.
 */
-(double) get_ldoTemperature
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LDOTEMPERATURE_INVALID;
        }
    }
    res = _ldoTemperature;
    return res;
}


-(double) ldoTemperature
{
    return [self get_ldoTemperature];
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
-(int) set_voltageAtStartUp:(double) newval
{
    return [self setVoltageAtStartUp:newval];
}
-(int) setVoltageAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"voltageAtStartUp" :rest_val];
}
/**
 * Returns the selected voltage set point at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage set point at device startup, in V
 *
 * On failure, throws an exception or returns YPowerSupply.VOLTAGEATSTARTUP_INVALID.
 */
-(double) get_voltageAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGEATSTARTUP_INVALID;
        }
    }
    res = _voltageAtStartUp;
    return res;
}


-(double) voltageAtStartUp
{
    return [self get_voltageAtStartUp];
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
-(int) set_currentAtStartUp:(double) newval
{
    return [self setCurrentAtStartUp:newval];
}
-(int) setCurrentAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentAtStartUp" :rest_val];
}
/**
 * Returns the selected current limit at device startup, in mA.
 *
 * @return a floating point number corresponding to the selected current limit at device startup, in mA
 *
 * On failure, throws an exception or returns YPowerSupply.CURRENTATSTARTUP_INVALID.
 */
-(double) get_currentAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTATSTARTUP_INVALID;
        }
    }
    res = _currentAtStartUp;
    return res;
}


-(double) currentAtStartUp
{
    return [self get_currentAtStartUp];
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
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
        [YFunction _AddToCache:@"PowerSupply" : func :obj];
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
    newval = [NSString stringWithFormat:@"%d:%d", (int) floor(V_target*65536+0.5),ms_duration];

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
