/*********************************************************************
 *
 * $Id: yocto_motor.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindMotor(), the high-level API for Motor functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

@class YMotor;

//--- (YMotor globals)
typedef void (*YMotorValueCallback)(YMotor *func, NSString *functionValue);
#ifndef _Y_MOTORSTATUS_ENUM
#define _Y_MOTORSTATUS_ENUM
typedef enum {
    Y_MOTORSTATUS_IDLE = 0,
    Y_MOTORSTATUS_BRAKE = 1,
    Y_MOTORSTATUS_FORWD = 2,
    Y_MOTORSTATUS_BACKWD = 3,
    Y_MOTORSTATUS_LOVOLT = 4,
    Y_MOTORSTATUS_HICURR = 5,
    Y_MOTORSTATUS_HIHEAT = 6,
    Y_MOTORSTATUS_FAILSF = 7,
    Y_MOTORSTATUS_INVALID = -1,
} Y_MOTORSTATUS_enum;
#endif
#define Y_DRIVINGFORCE_INVALID          YAPI_INVALID_DOUBLE
#define Y_BRAKINGFORCE_INVALID          YAPI_INVALID_DOUBLE
#define Y_CUTOFFVOLTAGE_INVALID         YAPI_INVALID_DOUBLE
#define Y_OVERCURRENTLIMIT_INVALID      YAPI_INVALID_INT
#define Y_FREQUENCY_INVALID             YAPI_INVALID_DOUBLE
#define Y_STARTERTIME_INVALID           YAPI_INVALID_INT
#define Y_FAILSAFETIMEOUT_INVALID       YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YMotor globals)

//--- (YMotor class start)
/**
 * YMotor Class: Motor function interface
 *
 * Yoctopuce application programming interface allows you to drive the
 * power sent to the motor to make it turn both ways, but also to drive accelerations
 * and decelerations. The motor will then accelerate automatically: you will not
 * have to monitor it. The API also allows to slow down the motor by shortening
 * its terminals: the motor will then act as an electromagnetic brake.
 */
@interface YMotor : YFunction
//--- (end of YMotor class start)
{
@protected
//--- (YMotor attributes declaration)
    Y_MOTORSTATUS_enum _motorStatus;
    double          _drivingForce;
    double          _brakingForce;
    double          _cutOffVoltage;
    int             _overCurrentLimit;
    double          _frequency;
    int             _starterTime;
    int             _failSafeTimeout;
    NSString*       _command;
    YMotorValueCallback _valueCallbackMotor;
//--- (end of YMotor attributes declaration)
}
// Constructor is protected, use yFindMotor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YMotor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YMotor private methods declaration)
//--- (YMotor public methods declaration)
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
-(Y_MOTORSTATUS_enum)     get_motorStatus;


-(Y_MOTORSTATUS_enum) motorStatus;
-(int)     set_motorStatus:(Y_MOTORSTATUS_enum) newval;
-(int)     setMotorStatus:(Y_MOTORSTATUS_enum) newval;

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
-(int)     set_drivingForce:(double) newval;
-(int)     setDrivingForce:(double) newval;

/**
 * Returns the power sent to the motor, as a percentage between -100% and +100%.
 *
 * @return a floating point number corresponding to the power sent to the motor, as a percentage
 * between -100% and +100%
 *
 * On failure, throws an exception or returns Y_DRIVINGFORCE_INVALID.
 */
-(double)     get_drivingForce;


-(double) drivingForce;
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
-(int)     set_brakingForce:(double) newval;
-(int)     setBrakingForce:(double) newval;

/**
 * Returns the braking force applied to the motor, as a percentage.
 * The value 0 corresponds to no braking (free wheel).
 *
 * @return a floating point number corresponding to the braking force applied to the motor, as a percentage
 *
 * On failure, throws an exception or returns Y_BRAKINGFORCE_INVALID.
 */
-(double)     get_brakingForce;


-(double) brakingForce;
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
-(int)     set_cutOffVoltage:(double) newval;
-(int)     setCutOffVoltage:(double) newval;

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
-(double)     get_cutOffVoltage;


-(double) cutOffVoltage;
/**
 * Returns the current threshold (in mA) above which the controller automatically
 * switches to error state. A zero value means that there is no limit.
 *
 * @return an integer corresponding to the current threshold (in mA) above which the controller automatically
 *         switches to error state
 *
 * On failure, throws an exception or returns Y_OVERCURRENTLIMIT_INVALID.
 */
-(int)     get_overCurrentLimit;


-(int) overCurrentLimit;
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
-(int)     set_overCurrentLimit:(int) newval;
-(int)     setOverCurrentLimit:(int) newval;

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
-(int)     set_frequency:(double) newval;
-(int)     setFrequency:(double) newval;

/**
 * Returns the PWM frequency used to control the motor.
 *
 * @return a floating point number corresponding to the PWM frequency used to control the motor
 *
 * On failure, throws an exception or returns Y_FREQUENCY_INVALID.
 */
-(double)     get_frequency;


-(double) frequency;
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
-(int)     get_starterTime;


-(int) starterTime;
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
-(int)     set_starterTime:(int) newval;
-(int)     setStarterTime:(int) newval;

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
-(int)     get_failSafeTimeout;


-(int) failSafeTimeout;
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
-(int)     set_failSafeTimeout:(int) newval;
-(int)     setFailSafeTimeout:(int) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a motor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMotor.isOnline() to test if the motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the motor
 *
 * @return a YMotor object allowing you to drive the motor.
 */
+(YMotor*)     FindMotor:(NSString*)func;

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
-(int)     registerValueCallback:(YMotorValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Rearms the controller failsafe timer. When the motor is running and the failsafe feature
 * is active, this function should be called periodically to prove that the control process
 * is running properly. Otherwise, the motor is automatically stopped after the specified
 * timeout. Calling a motor <i>set</i> function implicitely rearms the failsafe timer.
 */
-(int)     keepALive;

/**
 * Reset the controller state to IDLE. This function must be invoked explicitely
 * after any error condition is signaled.
 */
-(int)     resetStatus;

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
-(int)     drivingForceMove:(double)targetPower :(int)delay;

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
-(int)     brakingForceMove:(double)targetPower :(int)delay;


/**
 * Continues the enumeration of motors started using yFirstMotor().
 *
 * @return a pointer to a YMotor object, corresponding to
 *         a motor currently online, or a null pointer
 *         if there are no more motors to enumerate.
 */
-(YMotor*) nextMotor;
/**
 * Starts the enumeration of motors currently accessible.
 * Use the method YMotor.nextMotor() to iterate on
 * next motors.
 *
 * @return a pointer to a YMotor object, corresponding to
 *         the first motor currently online, or a null pointer
 *         if there are none.
 */
+(YMotor*) FirstMotor;
//--- (end of YMotor public methods declaration)

@end

//--- (Motor functions declaration)
/**
 * Retrieves a motor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMotor.isOnline() to test if the motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the motor
 *
 * @return a YMotor object allowing you to drive the motor.
 */
YMotor* yFindMotor(NSString* func);
/**
 * Starts the enumeration of motors currently accessible.
 * Use the method YMotor.nextMotor() to iterate on
 * next motors.
 *
 * @return a pointer to a YMotor object, corresponding to
 *         the first motor currently online, or a null pointer
 *         if there are none.
 */
YMotor* yFirstMotor(void);

//--- (end of Motor functions declaration)
CF_EXTERN_C_END

