/*********************************************************************
 *
 * $Id: yocto_steppermotor.m 30483 2018-03-29 07:43:07Z mvuilleu $
 *
 * Implements the high-level API for StepperMotor functions
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


#import "yocto_steppermotor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YStepperMotor

// Constructor is protected, use yFindStepperMotor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"StepperMotor";
//--- (YStepperMotor attributes initialization)
    _motorState = Y_MOTORSTATE_INVALID;
    _diags = Y_DIAGS_INVALID;
    _stepPos = Y_STEPPOS_INVALID;
    _speed = Y_SPEED_INVALID;
    _pullinSpeed = Y_PULLINSPEED_INVALID;
    _maxAccel = Y_MAXACCEL_INVALID;
    _maxSpeed = Y_MAXSPEED_INVALID;
    _stepping = Y_STEPPING_INVALID;
    _overcurrent = Y_OVERCURRENT_INVALID;
    _tCurrStop = Y_TCURRSTOP_INVALID;
    _tCurrRun = Y_TCURRRUN_INVALID;
    _alertMode = Y_ALERTMODE_INVALID;
    _auxMode = Y_AUXMODE_INVALID;
    _auxSignal = Y_AUXSIGNAL_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackStepperMotor = NULL;
//--- (end of YStepperMotor attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YStepperMotor cleanup)
    ARC_release(_alertMode);
    _alertMode = nil;
    ARC_release(_auxMode);
    _auxMode = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YStepperMotor cleanup)
}
//--- (YStepperMotor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "motorState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _motorState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "diags")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _diags =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "stepPos")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _stepPos =  atof(j->token) / 16.0;
        return 1;
    }
    if(!strcmp(j->token, "speed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _speed =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "pullinSpeed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pullinSpeed =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "maxAccel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxAccel =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "maxSpeed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxSpeed =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "stepping")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _stepping =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "overcurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _overcurrent =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "tCurrStop")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _tCurrStop =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "tCurrRun")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _tCurrRun =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "alertMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_alertMode);
        _alertMode =  [self _parseString:j];
        ARC_retain(_alertMode);
        return 1;
    }
    if(!strcmp(j->token, "auxMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_auxMode);
        _auxMode =  [self _parseString:j];
        ARC_retain(_auxMode);
        return 1;
    }
    if(!strcmp(j->token, "auxSignal")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _auxSignal =  atoi(j->token);
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
//--- (end of YStepperMotor private methods implementation)
//--- (YStepperMotor public methods implementation)
/**
 * Returns the motor working state.
 *
 * @return a value among Y_MOTORSTATE_ABSENT, Y_MOTORSTATE_ALERT, Y_MOTORSTATE_HI_Z,
 * Y_MOTORSTATE_STOP, Y_MOTORSTATE_RUN and Y_MOTORSTATE_BATCH corresponding to the motor working state
 *
 * On failure, throws an exception or returns Y_MOTORSTATE_INVALID.
 */
-(Y_MOTORSTATE_enum) get_motorState
{
    Y_MOTORSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MOTORSTATE_INVALID;
        }
    }
    res = _motorState;
    return res;
}


-(Y_MOTORSTATE_enum) motorState
{
    return [self get_motorState];
}
/**
 * Returns the stepper motor controller diagnostics, as a bitmap.
 *
 * @return an integer corresponding to the stepper motor controller diagnostics, as a bitmap
 *
 * On failure, throws an exception or returns Y_DIAGS_INVALID.
 */
-(int) get_diags
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DIAGS_INVALID;
        }
    }
    res = _diags;
    return res;
}


-(int) diags
{
    return [self get_diags];
}

/**
 * Changes the current logical motor position, measured in steps.
 * This command does not cause any motor move, as its purpose is only to setup
 * the origin of the position counter. The fractional part of the position,
 * that corresponds to the physical position of the rotor, is not changed.
 * To trigger a motor move, use methods moveTo() or moveRel()
 * instead.
 *
 * @param newval : a floating point number corresponding to the current logical motor position, measured in steps
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_stepPos:(double) newval
{
    return [self setStepPos:newval];
}
-(int) setStepPos:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%.2f", floor(newval * 100.0)/100.0];
    return [self _setAttr:@"stepPos" :rest_val];
}
/**
 * Returns the current logical motor position, measured in steps.
 * The value may include a fractional part when micro-stepping is in use.
 *
 * @return a floating point number corresponding to the current logical motor position, measured in steps
 *
 * On failure, throws an exception or returns Y_STEPPOS_INVALID.
 */
-(double) get_stepPos
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STEPPOS_INVALID;
        }
    }
    res = _stepPos;
    return res;
}


-(double) stepPos
{
    return [self get_stepPos];
}
/**
 * Returns current motor speed, measured in steps per second.
 * To change speed, use method changeSpeed().
 *
 * @return a floating point number corresponding to current motor speed, measured in steps per second
 *
 * On failure, throws an exception or returns Y_SPEED_INVALID.
 */
-(double) get_speed
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SPEED_INVALID;
        }
    }
    res = _speed;
    return res;
}


-(double) speed
{
    return [self get_speed];
}

/**
 * Changes the motor speed immediately reachable from stop state, measured in steps per second.
 *
 * @param newval : a floating point number corresponding to the motor speed immediately reachable from
 * stop state, measured in steps per second
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pullinSpeed:(double) newval
{
    return [self setPullinSpeed:newval];
}
-(int) setPullinSpeed:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"pullinSpeed" :rest_val];
}
/**
 * Returns the motor speed immediately reachable from stop state, measured in steps per second.
 *
 * @return a floating point number corresponding to the motor speed immediately reachable from stop
 * state, measured in steps per second
 *
 * On failure, throws an exception or returns Y_PULLINSPEED_INVALID.
 */
-(double) get_pullinSpeed
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULLINSPEED_INVALID;
        }
    }
    res = _pullinSpeed;
    return res;
}


-(double) pullinSpeed
{
    return [self get_pullinSpeed];
}

/**
 * Changes the maximal motor acceleration, measured in steps per second^2.
 *
 * @param newval : a floating point number corresponding to the maximal motor acceleration, measured
 * in steps per second^2
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_maxAccel:(double) newval
{
    return [self setMaxAccel:newval];
}
-(int) setMaxAccel:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"maxAccel" :rest_val];
}
/**
 * Returns the maximal motor acceleration, measured in steps per second^2.
 *
 * @return a floating point number corresponding to the maximal motor acceleration, measured in steps per second^2
 *
 * On failure, throws an exception or returns Y_MAXACCEL_INVALID.
 */
-(double) get_maxAccel
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXACCEL_INVALID;
        }
    }
    res = _maxAccel;
    return res;
}


-(double) maxAccel
{
    return [self get_maxAccel];
}

/**
 * Changes the maximal motor speed, measured in steps per second.
 *
 * @param newval : a floating point number corresponding to the maximal motor speed, measured in steps per second
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_maxSpeed:(double) newval
{
    return [self setMaxSpeed:newval];
}
-(int) setMaxSpeed:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"maxSpeed" :rest_val];
}
/**
 * Returns the maximal motor speed, measured in steps per second.
 *
 * @return a floating point number corresponding to the maximal motor speed, measured in steps per second
 *
 * On failure, throws an exception or returns Y_MAXSPEED_INVALID.
 */
-(double) get_maxSpeed
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXSPEED_INVALID;
        }
    }
    res = _maxSpeed;
    return res;
}


-(double) maxSpeed
{
    return [self get_maxSpeed];
}
/**
 * Returns the stepping mode used to drive the motor.
 *
 * @return a value among Y_STEPPING_MICROSTEP16, Y_STEPPING_MICROSTEP8, Y_STEPPING_MICROSTEP4,
 * Y_STEPPING_HALFSTEP and Y_STEPPING_FULLSTEP corresponding to the stepping mode used to drive the motor
 *
 * On failure, throws an exception or returns Y_STEPPING_INVALID.
 */
-(Y_STEPPING_enum) get_stepping
{
    Y_STEPPING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STEPPING_INVALID;
        }
    }
    res = _stepping;
    return res;
}


-(Y_STEPPING_enum) stepping
{
    return [self get_stepping];
}

/**
 * Changes the stepping mode used to drive the motor.
 *
 * @param newval : a value among Y_STEPPING_MICROSTEP16, Y_STEPPING_MICROSTEP8, Y_STEPPING_MICROSTEP4,
 * Y_STEPPING_HALFSTEP and Y_STEPPING_FULLSTEP corresponding to the stepping mode used to drive the motor
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_stepping:(Y_STEPPING_enum) newval
{
    return [self setStepping:newval];
}
-(int) setStepping:(Y_STEPPING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"stepping" :rest_val];
}
/**
 * Returns the overcurrent alert and emergency stop threshold, measured in mA.
 *
 * @return an integer corresponding to the overcurrent alert and emergency stop threshold, measured in mA
 *
 * On failure, throws an exception or returns Y_OVERCURRENT_INVALID.
 */
-(int) get_overcurrent
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_OVERCURRENT_INVALID;
        }
    }
    res = _overcurrent;
    return res;
}


-(int) overcurrent
{
    return [self get_overcurrent];
}

/**
 * Changes the overcurrent alert and emergency stop threshold, measured in mA.
 *
 * @param newval : an integer corresponding to the overcurrent alert and emergency stop threshold, measured in mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_overcurrent:(int) newval
{
    return [self setOvercurrent:newval];
}
-(int) setOvercurrent:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"overcurrent" :rest_val];
}
/**
 * Returns the torque regulation current when the motor is stopped, measured in mA.
 *
 * @return an integer corresponding to the torque regulation current when the motor is stopped, measured in mA
 *
 * On failure, throws an exception or returns Y_TCURRSTOP_INVALID.
 */
-(int) get_tCurrStop
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TCURRSTOP_INVALID;
        }
    }
    res = _tCurrStop;
    return res;
}


-(int) tCurrStop
{
    return [self get_tCurrStop];
}

/**
 * Changes the torque regulation current when the motor is stopped, measured in mA.
 *
 * @param newval : an integer corresponding to the torque regulation current when the motor is
 * stopped, measured in mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_tCurrStop:(int) newval
{
    return [self setTCurrStop:newval];
}
-(int) setTCurrStop:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"tCurrStop" :rest_val];
}
/**
 * Returns the torque regulation current when the motor is running, measured in mA.
 *
 * @return an integer corresponding to the torque regulation current when the motor is running, measured in mA
 *
 * On failure, throws an exception or returns Y_TCURRRUN_INVALID.
 */
-(int) get_tCurrRun
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TCURRRUN_INVALID;
        }
    }
    res = _tCurrRun;
    return res;
}


-(int) tCurrRun
{
    return [self get_tCurrRun];
}

/**
 * Changes the torque regulation current when the motor is running, measured in mA.
 *
 * @param newval : an integer corresponding to the torque regulation current when the motor is
 * running, measured in mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_tCurrRun:(int) newval
{
    return [self setTCurrRun:newval];
}
-(int) setTCurrRun:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"tCurrRun" :rest_val];
}
-(NSString*) get_alertMode
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ALERTMODE_INVALID;
        }
    }
    res = _alertMode;
    return res;
}


-(NSString*) alertMode
{
    return [self get_alertMode];
}

-(int) set_alertMode:(NSString*) newval
{
    return [self setAlertMode:newval];
}
-(int) setAlertMode:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"alertMode" :rest_val];
}
-(NSString*) get_auxMode
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUXMODE_INVALID;
        }
    }
    res = _auxMode;
    return res;
}


-(NSString*) auxMode
{
    return [self get_auxMode];
}

-(int) set_auxMode:(NSString*) newval
{
    return [self setAuxMode:newval];
}
-(int) setAuxMode:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"auxMode" :rest_val];
}
/**
 * Returns the current value of the signal generated on the auxiliary output.
 *
 * @return an integer corresponding to the current value of the signal generated on the auxiliary output
 *
 * On failure, throws an exception or returns Y_AUXSIGNAL_INVALID.
 */
-(int) get_auxSignal
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUXSIGNAL_INVALID;
        }
    }
    res = _auxSignal;
    return res;
}


-(int) auxSignal
{
    return [self get_auxSignal];
}

/**
 * Changes the value of the signal generated on the auxiliary output.
 * Acceptable values depend on the auxiliary output signal type configured.
 *
 * @param newval : an integer corresponding to the value of the signal generated on the auxiliary output
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_auxSignal:(int) newval
{
    return [self setAuxSignal:newval];
}
-(int) setAuxSignal:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"auxSignal" :rest_val];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
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
 * Retrieves a stepper motor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the stepper motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YStepperMotor.isOnline() to test if the stepper motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a stepper motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the stepper motor
 *
 * @return a YStepperMotor object allowing you to drive the stepper motor.
 */
+(YStepperMotor*) FindStepperMotor:(NSString*)func
{
    YStepperMotor* obj;
    obj = (YStepperMotor*) [YFunction _FindFromCache:@"StepperMotor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YStepperMotor alloc] initWith:func]);
        [YFunction _AddToCache:@"StepperMotor" : func :obj];
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
-(int) registerValueCallback:(YStepperMotorValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackStepperMotor = callback;
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
    if (_valueCallbackStepperMotor != NULL) {
        _valueCallbackStepperMotor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)command
{
    NSString* id;
    NSString* url;
    NSMutableData* retBin;
    int res;
    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange( 12, 1)];
    url = [NSString stringWithFormat:@"cmd.txt?%@=%@", id,command];
    //may throw an exception
    retBin = [self _download:url];
    res = (((u8*)([retBin bytes]))[0]);
    if (res == 49) {
        if (!(res == 48)) {[self _throw: YAPI_DEVICE_BUSY: @"Motor command pipeline is full, try again later"]; return YAPI_DEVICE_BUSY;}
    } else {
        if (!(res == 48)) {[self _throw: YAPI_IO_ERROR: @"Motor command failed permanently"]; return YAPI_IO_ERROR;}
    }
    return YAPI_SUCCESS;
}

/**
 * Reinitialize the controller and clear all alert flags.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    return [self set_command:@"Z"];
}

/**
 * Starts the motor backward at the specified speed, to search for the motor home position.
 *
 * @param speed : desired speed, in steps per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) findHomePosition:(double)speed
{
    return [self sendCommand:[NSString stringWithFormat:@"H%d",(int) floor(1000*speed+0.5)]];
}

/**
 * Starts the motor at a given speed. The time needed to reach the requested speed
 * will depend on the acceleration parameters configured for the motor.
 *
 * @param speed : desired speed, in steps per second. The minimal non-zero speed
 *         is 0.001 pulse per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) changeSpeed:(double)speed
{
    return [self sendCommand:[NSString stringWithFormat:@"R%d",(int) floor(1000*speed+0.5)]];
}

/**
 * Starts the motor to reach a given absolute position. The time needed to reach the requested
 * position will depend on the acceleration and max speed parameters configured for
 * the motor.
 *
 * @param absPos : absolute position, measured in steps from the origin.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) moveTo:(double)absPos
{
    return [self sendCommand:[NSString stringWithFormat:@"M%d",(int) floor(16*absPos+0.5)]];
}

/**
 * Starts the motor to reach a given relative position. The time needed to reach the requested
 * position will depend on the acceleration and max speed parameters configured for
 * the motor.
 *
 * @param relPos : relative position, measured in steps from the current position.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) moveRel:(double)relPos
{
    return [self sendCommand:[NSString stringWithFormat:@"m%d",(int) floor(16*relPos+0.5)]];
}

/**
 * Starts the motor to reach a given relative position, keeping the speed under the
 * specified limit. The time needed to reach the requested position will depend on
 * the acceleration parameters configured for the motor.
 *
 * @param relPos : relative position, measured in steps from the current position.
 * @param maxSpeed : limit speed, in steps per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) moveRelSlow:(double)relPos :(double)maxSpeed
{
    return [self sendCommand:[NSString stringWithFormat:@"m%d@%d",(int) floor(16*relPos+0.5),(int) floor(1000*maxSpeed+0.5)]];
}

/**
 * Keep the motor in the same state for the specified amount of time, before processing next command.
 *
 * @param waitMs : wait time, specified in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) pause:(int)waitMs
{
    return [self sendCommand:[NSString stringWithFormat:@"_%d",waitMs]];
}

/**
 * Stops the motor with an emergency alert, without taking any additional precaution.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) emergencyStop
{
    return [self set_command:@"!"];
}

/**
 * Move one step in the direction opposite the direction set when the most recent alert was raised.
 * The move occures even if the system is still in alert mode (end switch depressed). Caution.
 * use this function with great care as it may cause mechanical damages !
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) alertStepOut
{
    return [self set_command:@"."];
}

/**
 * Move one single step in the selected direction without regards to end switches.
 * The move occures even if the system is still in alert mode (end switch depressed). Caution.
 * use this function with great care as it may cause mechanical damages !
 *
 * @param dir : Value +1 ou -1, according to the desired direction of the move
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) alertStepDir:(int)dir
{
    if (!(dir != 0)) {[self _throw: YAPI_INVALID_ARGUMENT: @"direction must be +1 or -1"]; return YAPI_INVALID_ARGUMENT;}
    if (dir > 0) {
        return [self set_command:@".+"];
    }
    return [self set_command:@".-"];
}

/**
 * Stops the motor smoothly as soon as possible, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) abortAndBrake
{
    return [self set_command:@"B"];
}

/**
 * Turn the controller into Hi-Z mode immediately, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) abortAndHiZ
{
    return [self set_command:@"z"];
}


-(YStepperMotor*)   nextStepperMotor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YStepperMotor FindStepperMotor:hwid];
}

+(YStepperMotor *) FirstStepperMotor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"StepperMotor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YStepperMotor FindStepperMotor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YStepperMotor public methods implementation)

@end
//--- (YStepperMotor functions)

YStepperMotor *yFindStepperMotor(NSString* func)
{
    return [YStepperMotor FindStepperMotor:func];
}

YStepperMotor *yFirstStepperMotor(void)
{
    return [YStepperMotor FirstStepperMotor];
}

//--- (end of YStepperMotor functions)
