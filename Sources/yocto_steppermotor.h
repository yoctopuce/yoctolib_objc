/*********************************************************************
 *
 *  $Id: yocto_steppermotor.h 32906 2018-11-02 10:18:15Z seb $
 *
 *  Declares yFindStepperMotor(), the high-level API for StepperMotor functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

@class YStepperMotor;

//--- (YStepperMotor globals)
typedef void (*YStepperMotorValueCallback)(YStepperMotor *func, NSString *functionValue);
#ifndef _Y_MOTORSTATE_ENUM
#define _Y_MOTORSTATE_ENUM
typedef enum {
    Y_MOTORSTATE_ABSENT = 0,
    Y_MOTORSTATE_ALERT = 1,
    Y_MOTORSTATE_HI_Z = 2,
    Y_MOTORSTATE_STOP = 3,
    Y_MOTORSTATE_RUN = 4,
    Y_MOTORSTATE_BATCH = 5,
    Y_MOTORSTATE_INVALID = -1,
} Y_MOTORSTATE_enum;
#endif
#ifndef _Y_STEPPING_ENUM
#define _Y_STEPPING_ENUM
typedef enum {
    Y_STEPPING_MICROSTEP16 = 0,
    Y_STEPPING_MICROSTEP8 = 1,
    Y_STEPPING_MICROSTEP4 = 2,
    Y_STEPPING_HALFSTEP = 3,
    Y_STEPPING_FULLSTEP = 4,
    Y_STEPPING_INVALID = -1,
} Y_STEPPING_enum;
#endif
#define Y_DIAGS_INVALID                 YAPI_INVALID_UINT
#define Y_STEPPOS_INVALID               YAPI_INVALID_DOUBLE
#define Y_SPEED_INVALID                 YAPI_INVALID_DOUBLE
#define Y_PULLINSPEED_INVALID           YAPI_INVALID_DOUBLE
#define Y_MAXACCEL_INVALID              YAPI_INVALID_DOUBLE
#define Y_MAXSPEED_INVALID              YAPI_INVALID_DOUBLE
#define Y_OVERCURRENT_INVALID           YAPI_INVALID_UINT
#define Y_TCURRSTOP_INVALID             YAPI_INVALID_UINT
#define Y_TCURRRUN_INVALID              YAPI_INVALID_UINT
#define Y_ALERTMODE_INVALID             YAPI_INVALID_STRING
#define Y_AUXMODE_INVALID               YAPI_INVALID_STRING
#define Y_AUXSIGNAL_INVALID             YAPI_INVALID_INT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YStepperMotor globals)

//--- (YStepperMotor class start)
/**
 * YStepperMotor Class: StepperMotor function interface
 *
 * The Yoctopuce application programming interface allows you to drive a stepper motor.
 */
@interface YStepperMotor : YFunction
//--- (end of YStepperMotor class start)
{
@protected
//--- (YStepperMotor attributes declaration)
    Y_MOTORSTATE_enum _motorState;
    int             _diags;
    double          _stepPos;
    double          _speed;
    double          _pullinSpeed;
    double          _maxAccel;
    double          _maxSpeed;
    Y_STEPPING_enum _stepping;
    int             _overcurrent;
    int             _tCurrStop;
    int             _tCurrRun;
    NSString*       _alertMode;
    NSString*       _auxMode;
    int             _auxSignal;
    NSString*       _command;
    YStepperMotorValueCallback _valueCallbackStepperMotor;
//--- (end of YStepperMotor attributes declaration)
}
// Constructor is protected, use yFindStepperMotor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YStepperMotor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YStepperMotor private methods declaration)
//--- (YStepperMotor yapiwrapper declaration)
//--- (end of YStepperMotor yapiwrapper declaration)
//--- (YStepperMotor public methods declaration)
/**
 * Returns the motor working state.
 *
 * @return a value among Y_MOTORSTATE_ABSENT, Y_MOTORSTATE_ALERT, Y_MOTORSTATE_HI_Z,
 * Y_MOTORSTATE_STOP, Y_MOTORSTATE_RUN and Y_MOTORSTATE_BATCH corresponding to the motor working state
 *
 * On failure, throws an exception or returns Y_MOTORSTATE_INVALID.
 */
-(Y_MOTORSTATE_enum)     get_motorState;


-(Y_MOTORSTATE_enum) motorState;
/**
 * Returns the stepper motor controller diagnostics, as a bitmap.
 *
 * @return an integer corresponding to the stepper motor controller diagnostics, as a bitmap
 *
 * On failure, throws an exception or returns Y_DIAGS_INVALID.
 */
-(int)     get_diags;


-(int) diags;
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
-(int)     set_stepPos:(double) newval;
-(int)     setStepPos:(double) newval;

/**
 * Returns the current logical motor position, measured in steps.
 * The value may include a fractional part when micro-stepping is in use.
 *
 * @return a floating point number corresponding to the current logical motor position, measured in steps
 *
 * On failure, throws an exception or returns Y_STEPPOS_INVALID.
 */
-(double)     get_stepPos;


-(double) stepPos;
/**
 * Returns current motor speed, measured in steps per second.
 * To change speed, use method changeSpeed().
 *
 * @return a floating point number corresponding to current motor speed, measured in steps per second
 *
 * On failure, throws an exception or returns Y_SPEED_INVALID.
 */
-(double)     get_speed;


-(double) speed;
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
-(int)     set_pullinSpeed:(double) newval;
-(int)     setPullinSpeed:(double) newval;

/**
 * Returns the motor speed immediately reachable from stop state, measured in steps per second.
 *
 * @return a floating point number corresponding to the motor speed immediately reachable from stop
 * state, measured in steps per second
 *
 * On failure, throws an exception or returns Y_PULLINSPEED_INVALID.
 */
-(double)     get_pullinSpeed;


-(double) pullinSpeed;
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
-(int)     set_maxAccel:(double) newval;
-(int)     setMaxAccel:(double) newval;

/**
 * Returns the maximal motor acceleration, measured in steps per second^2.
 *
 * @return a floating point number corresponding to the maximal motor acceleration, measured in steps per second^2
 *
 * On failure, throws an exception or returns Y_MAXACCEL_INVALID.
 */
-(double)     get_maxAccel;


-(double) maxAccel;
/**
 * Changes the maximal motor speed, measured in steps per second.
 *
 * @param newval : a floating point number corresponding to the maximal motor speed, measured in steps per second
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_maxSpeed:(double) newval;
-(int)     setMaxSpeed:(double) newval;

/**
 * Returns the maximal motor speed, measured in steps per second.
 *
 * @return a floating point number corresponding to the maximal motor speed, measured in steps per second
 *
 * On failure, throws an exception or returns Y_MAXSPEED_INVALID.
 */
-(double)     get_maxSpeed;


-(double) maxSpeed;
/**
 * Returns the stepping mode used to drive the motor.
 *
 * @return a value among Y_STEPPING_MICROSTEP16, Y_STEPPING_MICROSTEP8, Y_STEPPING_MICROSTEP4,
 * Y_STEPPING_HALFSTEP and Y_STEPPING_FULLSTEP corresponding to the stepping mode used to drive the motor
 *
 * On failure, throws an exception or returns Y_STEPPING_INVALID.
 */
-(Y_STEPPING_enum)     get_stepping;


-(Y_STEPPING_enum) stepping;
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
-(int)     set_stepping:(Y_STEPPING_enum) newval;
-(int)     setStepping:(Y_STEPPING_enum) newval;

/**
 * Returns the overcurrent alert and emergency stop threshold, measured in mA.
 *
 * @return an integer corresponding to the overcurrent alert and emergency stop threshold, measured in mA
 *
 * On failure, throws an exception or returns Y_OVERCURRENT_INVALID.
 */
-(int)     get_overcurrent;


-(int) overcurrent;
/**
 * Changes the overcurrent alert and emergency stop threshold, measured in mA.
 *
 * @param newval : an integer corresponding to the overcurrent alert and emergency stop threshold, measured in mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_overcurrent:(int) newval;
-(int)     setOvercurrent:(int) newval;

/**
 * Returns the torque regulation current when the motor is stopped, measured in mA.
 *
 * @return an integer corresponding to the torque regulation current when the motor is stopped, measured in mA
 *
 * On failure, throws an exception or returns Y_TCURRSTOP_INVALID.
 */
-(int)     get_tCurrStop;


-(int) tCurrStop;
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
-(int)     set_tCurrStop:(int) newval;
-(int)     setTCurrStop:(int) newval;

/**
 * Returns the torque regulation current when the motor is running, measured in mA.
 *
 * @return an integer corresponding to the torque regulation current when the motor is running, measured in mA
 *
 * On failure, throws an exception or returns Y_TCURRRUN_INVALID.
 */
-(int)     get_tCurrRun;


-(int) tCurrRun;
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
-(int)     set_tCurrRun:(int) newval;
-(int)     setTCurrRun:(int) newval;

-(NSString*)     get_alertMode;


-(NSString*) alertMode;
-(int)     set_alertMode:(NSString*) newval;
-(int)     setAlertMode:(NSString*) newval;

-(NSString*)     get_auxMode;


-(NSString*) auxMode;
-(int)     set_auxMode:(NSString*) newval;
-(int)     setAuxMode:(NSString*) newval;

/**
 * Returns the current value of the signal generated on the auxiliary output.
 *
 * @return an integer corresponding to the current value of the signal generated on the auxiliary output
 *
 * On failure, throws an exception or returns Y_AUXSIGNAL_INVALID.
 */
-(int)     get_auxSignal;


-(int) auxSignal;
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
-(int)     set_auxSignal:(int) newval;
-(int)     setAuxSignal:(int) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

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
+(YStepperMotor*)     FindStepperMotor:(NSString*)func;

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
-(int)     registerValueCallback:(YStepperMotorValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)command;

/**
 * Reinitialize the controller and clear all alert flags.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

/**
 * Starts the motor backward at the specified speed, to search for the motor home position.
 *
 * @param speed : desired speed, in steps per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     findHomePosition:(double)speed;

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
-(int)     changeSpeed:(double)speed;

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
-(int)     moveTo:(double)absPos;

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
-(int)     moveRel:(double)relPos;

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
-(int)     moveRelSlow:(double)relPos :(double)maxSpeed;

/**
 * Keep the motor in the same state for the specified amount of time, before processing next command.
 *
 * @param waitMs : wait time, specified in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     pause:(int)waitMs;

/**
 * Stops the motor with an emergency alert, without taking any additional precaution.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     emergencyStop;

/**
 * Move one step in the direction opposite the direction set when the most recent alert was raised.
 * The move occures even if the system is still in alert mode (end switch depressed). Caution.
 * use this function with great care as it may cause mechanical damages !
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     alertStepOut;

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
-(int)     alertStepDir:(int)dir;

/**
 * Stops the motor smoothly as soon as possible, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     abortAndBrake;

/**
 * Turn the controller into Hi-Z mode immediately, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     abortAndHiZ;


/**
 * Continues the enumeration of stepper motors started using yFirstStepperMotor().
 * Caution: You can't make any assumption about the returned stepper motors order.
 * If you want to find a specific a stepper motor, use StepperMotor.findStepperMotor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YStepperMotor object, corresponding to
 *         a stepper motor currently online, or a nil pointer
 *         if there are no more stepper motors to enumerate.
 */
-(YStepperMotor*) nextStepperMotor;
/**
 * Starts the enumeration of stepper motors currently accessible.
 * Use the method YStepperMotor.nextStepperMotor() to iterate on
 * next stepper motors.
 *
 * @return a pointer to a YStepperMotor object, corresponding to
 *         the first stepper motor currently online, or a nil pointer
 *         if there are none.
 */
+(YStepperMotor*) FirstStepperMotor;
//--- (end of YStepperMotor public methods declaration)

@end

//--- (YStepperMotor functions declaration)
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
YStepperMotor* yFindStepperMotor(NSString* func);
/**
 * Starts the enumeration of stepper motors currently accessible.
 * Use the method YStepperMotor.nextStepperMotor() to iterate on
 * next stepper motors.
 *
 * @return a pointer to a YStepperMotor object, corresponding to
 *         the first stepper motor currently online, or a nil pointer
 *         if there are none.
 */
YStepperMotor* yFirstStepperMotor(void);

//--- (end of YStepperMotor functions declaration)
CF_EXTERN_C_END

