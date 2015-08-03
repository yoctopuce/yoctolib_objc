/*********************************************************************
 *
 * $Id: yocto_motor.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for Motor functions
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


#import "yocto_motor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YMotor

// Constructor is protected, use yFindMotor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Motor";
//--- (YMotor attributes initialization)
    _motorStatus = Y_MOTORSTATUS_INVALID;
    _drivingForce = Y_DRIVINGFORCE_INVALID;
    _brakingForce = Y_BRAKINGFORCE_INVALID;
    _cutOffVoltage = Y_CUTOFFVOLTAGE_INVALID;
    _overCurrentLimit = Y_OVERCURRENTLIMIT_INVALID;
    _frequency = Y_FREQUENCY_INVALID;
    _starterTime = Y_STARTERTIME_INVALID;
    _failSafeTimeout = Y_FAILSAFETIMEOUT_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackMotor = NULL;
//--- (end of YMotor attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YMotor cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YMotor cleanup)
}
//--- (YMotor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "motorStatus")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _motorStatus =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "drivingForce")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _drivingForce =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "brakingForce")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _brakingForce =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "cutOffVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _cutOffVoltage =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "overCurrentLimit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _overCurrentLimit =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "frequency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _frequency =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "starterTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _starterTime =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "failSafeTimeout")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _failSafeTimeout =  atoi(j->token);
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
//--- (end of YMotor private methods implementation)
//--- (YMotor public methods implementation)
/**
 * Return the controller state. Possible states are:
 * IDLE   when the motor is stopped/in free wheel, ready to start;
 * FORWD  when the controller is driving the motor forward;
 * BACKWD when the controller is driving the motor backward;
 * BRAKE  when the controller is braking;
 * LOVOLT when the controller has detected a low voltage condition;
 * HICURR when the controller has detected an overcurrent condition;
 * HIHEAT when the controller has detected an overheat condition;
 * FAILSF when the controller switched on the failsafe security.
 *
 * When an error condition occurred (LOVOLT, HICURR, HIHEAT, FAILSF), the controller
 * status must be explicitly reset using the resetStatus function.
 *
 * @return a value among Y_MOTORSTATUS_IDLE, Y_MOTORSTATUS_BRAKE, Y_MOTORSTATUS_FORWD,
 * Y_MOTORSTATUS_BACKWD, Y_MOTORSTATUS_LOVOLT, Y_MOTORSTATUS_HICURR, Y_MOTORSTATUS_HIHEAT and Y_MOTORSTATUS_FAILSF
 *
 * On failure, throws an exception or returns Y_MOTORSTATUS_INVALID.
 */
-(Y_MOTORSTATUS_enum) get_motorStatus
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MOTORSTATUS_INVALID;
        }
    }
    return _motorStatus;
}


-(Y_MOTORSTATUS_enum) motorStatus
{
    return [self get_motorStatus];
}

-(int) set_motorStatus:(Y_MOTORSTATUS_enum) newval
{
    return [self setMotorStatus:newval];
}
-(int) setMotorStatus:(Y_MOTORSTATUS_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"motorStatus" :rest_val];
}

/**
 * Changes immediately the power sent to the motor. The value is a percentage between -100%
 * to 100%. If you want go easy on your mechanics and avoid excessive current consumption,
 * try to avoid brutal power changes. For example, immediate transition from forward full power
 * to reverse full power is a very bad idea. Each time the driving power is modified, the
 * braking power is set to zero.
 *
 * @param newval : a floating point number corresponding to immediately the power sent to the motor
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_drivingForce:(double) newval
{
    return [self setDrivingForce:newval];
}
-(int) setDrivingForce:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"drivingForce" :rest_val];
}
/**
 * Returns the power sent to the motor, as a percentage between -100% and +100%.
 *
 * @return a floating point number corresponding to the power sent to the motor, as a percentage
 * between -100% and +100%
 *
 * On failure, throws an exception or returns Y_DRIVINGFORCE_INVALID.
 */
-(double) get_drivingForce
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DRIVINGFORCE_INVALID;
        }
    }
    return _drivingForce;
}


-(double) drivingForce
{
    return [self get_drivingForce];
}

/**
 * Changes immediately the braking force applied to the motor (in percents).
 * The value 0 corresponds to no braking (free wheel). When the braking force
 * is changed, the driving power is set to zero. The value is a percentage.
 *
 * @param newval : a floating point number corresponding to immediately the braking force applied to
 * the motor (in percents)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_brakingForce:(double) newval
{
    return [self setBrakingForce:newval];
}
-(int) setBrakingForce:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"brakingForce" :rest_val];
}
/**
 * Returns the braking force applied to the motor, as a percentage.
 * The value 0 corresponds to no braking (free wheel).
 *
 * @return a floating point number corresponding to the braking force applied to the motor, as a percentage
 *
 * On failure, throws an exception or returns Y_BRAKINGFORCE_INVALID.
 */
-(double) get_brakingForce
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_BRAKINGFORCE_INVALID;
        }
    }
    return _brakingForce;
}


-(double) brakingForce
{
    return [self get_brakingForce];
}

/**
 * Changes the threshold voltage under which the controller automatically switches to error state
 * and prevents further current draw. This setting prevent damage to a battery that can
 * occur when drawing current from an "empty" battery.
 * Note that whatever the cutoff threshold, the controller switches to undervoltage
 * error state if the power supply goes under 3V, even for a very brief time.
 *
 * @param newval : a floating point number corresponding to the threshold voltage under which the
 * controller automatically switches to error state
 *         and prevents further current draw
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_cutOffVoltage:(double) newval
{
    return [self setCutOffVoltage:newval];
}
-(int) setCutOffVoltage:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"cutOffVoltage" :rest_val];
}
/**
 * Returns the threshold voltage under which the controller automatically switches to error state
 * and prevents further current draw. This setting prevents damage to a battery that can
 * occur when drawing current from an "empty" battery.
 *
 * @return a floating point number corresponding to the threshold voltage under which the controller
 * automatically switches to error state
 *         and prevents further current draw
 *
 * On failure, throws an exception or returns Y_CUTOFFVOLTAGE_INVALID.
 */
-(double) get_cutOffVoltage
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CUTOFFVOLTAGE_INVALID;
        }
    }
    return _cutOffVoltage;
}


-(double) cutOffVoltage
{
    return [self get_cutOffVoltage];
}
/**
 * Returns the current threshold (in mA) above which the controller automatically
 * switches to error state. A zero value means that there is no limit.
 *
 * @return an integer corresponding to the current threshold (in mA) above which the controller automatically
 *         switches to error state
 *
 * On failure, throws an exception or returns Y_OVERCURRENTLIMIT_INVALID.
 */
-(int) get_overCurrentLimit
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_OVERCURRENTLIMIT_INVALID;
        }
    }
    return _overCurrentLimit;
}


-(int) overCurrentLimit
{
    return [self get_overCurrentLimit];
}

/**
 * Changes the current threshold (in mA) above which the controller automatically
 * switches to error state. A zero value means that there is no limit. Note that whatever the
 * current limit is, the controller switches to OVERCURRENT status if the current
 * goes above 32A, even for a very brief time.
 *
 * @param newval : an integer corresponding to the current threshold (in mA) above which the
 * controller automatically
 *         switches to error state
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_overCurrentLimit:(int) newval
{
    return [self setOverCurrentLimit:newval];
}
-(int) setOverCurrentLimit:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"overCurrentLimit" :rest_val];
}

/**
 * Changes the PWM frequency used to control the motor. Low frequency is usually
 * more efficient and may help the motor to start, but an audible noise might be
 * generated. A higher frequency reduces the noise, but more energy is converted
 * into heat.
 *
 * @param newval : a floating point number corresponding to the PWM frequency used to control the motor
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_frequency:(double) newval
{
    return [self setFrequency:newval];
}
-(int) setFrequency:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"frequency" :rest_val];
}
/**
 * Returns the PWM frequency used to control the motor.
 *
 * @return a floating point number corresponding to the PWM frequency used to control the motor
 *
 * On failure, throws an exception or returns Y_FREQUENCY_INVALID.
 */
-(double) get_frequency
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_FREQUENCY_INVALID;
        }
    }
    return _frequency;
}


-(double) frequency
{
    return [self get_frequency];
}
/**
 * Returns the duration (in ms) during which the motor is driven at low frequency to help
 * it start up.
 *
 * @return an integer corresponding to the duration (in ms) during which the motor is driven at low
 * frequency to help
 *         it start up
 *
 * On failure, throws an exception or returns Y_STARTERTIME_INVALID.
 */
-(int) get_starterTime
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STARTERTIME_INVALID;
        }
    }
    return _starterTime;
}


-(int) starterTime
{
    return [self get_starterTime];
}

/**
 * Changes the duration (in ms) during which the motor is driven at low frequency to help
 * it start up.
 *
 * @param newval : an integer corresponding to the duration (in ms) during which the motor is driven
 * at low frequency to help
 *         it start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_starterTime:(int) newval
{
    return [self setStarterTime:newval];
}
-(int) setStarterTime:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"starterTime" :rest_val];
}
/**
 * Returns the delay in milliseconds allowed for the controller to run autonomously without
 * receiving any instruction from the control process. When this delay has elapsed,
 * the controller automatically stops the motor and switches to FAILSAFE error.
 * Failsafe security is disabled when the value is zero.
 *
 * @return an integer corresponding to the delay in milliseconds allowed for the controller to run
 * autonomously without
 *         receiving any instruction from the control process
 *
 * On failure, throws an exception or returns Y_FAILSAFETIMEOUT_INVALID.
 */
-(int) get_failSafeTimeout
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_FAILSAFETIMEOUT_INVALID;
        }
    }
    return _failSafeTimeout;
}


-(int) failSafeTimeout
{
    return [self get_failSafeTimeout];
}

/**
 * Changes the delay in milliseconds allowed for the controller to run autonomously without
 * receiving any instruction from the control process. When this delay has elapsed,
 * the controller automatically stops the motor and switches to FAILSAFE error.
 * Failsafe security is disabled when the value is zero.
 *
 * @param newval : an integer corresponding to the delay in milliseconds allowed for the controller to
 * run autonomously without
 *         receiving any instruction from the control process
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_failSafeTimeout:(int) newval
{
    return [self setFailSafeTimeout:newval];
}
-(int) setFailSafeTimeout:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"failSafeTimeout" :rest_val];
}
-(NSString*) get_command
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    return _command;
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
 * Use the method YMotor.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YMotor object allowing you to drive $THEFUNCTION$.
 */
+(YMotor*) FindMotor:(NSString*)func
{
    YMotor* obj;
    obj = (YMotor*) [YFunction _FindFromCache:@"Motor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YMotor alloc] initWith:func]);
        [YFunction _AddToCache:@"Motor" : func :obj];
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
-(int) registerValueCallback:(YMotorValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackMotor = callback;
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
    if (_valueCallbackMotor != NULL) {
        _valueCallbackMotor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Rearms the controller failsafe timer. When the motor is running and the failsafe feature
 * is active, this function should be called periodically to prove that the control process
 * is running properly. Otherwise, the motor is automatically stopped after the specified
 * timeout. Calling a motor <i>set</i> function implicitely rearms the failsafe timer.
 */
-(int) keepALive
{
    return [self set_command:@"K"];
}

/**
 * Reset the controller state to IDLE. This function must be invoked explicitely
 * after any error condition is signaled.
 */
-(int) resetStatus
{
    return [self set_motorStatus:Y_MOTORSTATUS_IDLE];
}

/**
 * Changes progressively the power sent to the moteur for a specific duration.
 *
 * @param targetPower : desired motor power, in percents (between -100% and +100%)
 * @param delay : duration (in ms) of the transition
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drivingForceMove:(double)targetPower :(int)delay
{
    return [self set_command:[NSString stringWithFormat:@"P%d,%d",(int) floor(targetPower*10+0.5),delay]];
}

/**
 * Changes progressively the braking force applied to the motor for a specific duration.
 *
 * @param targetPower : desired braking force, in percents
 * @param delay : duration (in ms) of the transition
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) brakingForceMove:(double)targetPower :(int)delay
{
    return [self set_command:[NSString stringWithFormat:@"B%d,%d",(int) floor(targetPower*10+0.5),delay]];
}


-(YMotor*)   nextMotor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YMotor FindMotor:hwid];
}

+(YMotor *) FirstMotor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Motor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YMotor FindMotor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YMotor public methods implementation)

@end
//--- (Motor functions)

YMotor *yFindMotor(NSString* func)
{
    return [YMotor FindMotor:func];
}

YMotor *yFirstMotor(void)
{
    return [YMotor FirstMotor];
}

//--- (end of Motor functions)
