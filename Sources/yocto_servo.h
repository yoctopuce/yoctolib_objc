/*********************************************************************
 *
 *  $Id: yocto_servo.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Declares yFindServo(), the high-level API for Servo functions
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
NS_ASSUME_NONNULL_BEGIN

@class YServo;

//--- (YServo globals)
typedef void (*YServoValueCallback)(YServo *func, NSString *functionValue);
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
#ifndef _STRUCT_MOVE
#define _STRUCT_MOVE
typedef struct _YMove {
    int             target;
    int             ms;
    int             moving;
} YMove;
#endif
#define Y_MOVE_INVALID (YMove){YAPI_INVALID_INT,YAPI_INVALID_INT,YAPI_INVALID_UINT}
#ifndef _Y_ENABLEDATPOWERON_ENUM
#define _Y_ENABLEDATPOWERON_ENUM
typedef enum {
    Y_ENABLEDATPOWERON_FALSE = 0,
    Y_ENABLEDATPOWERON_TRUE = 1,
    Y_ENABLEDATPOWERON_INVALID = -1,
} Y_ENABLEDATPOWERON_enum;
#endif
#define Y_POSITION_INVALID              YAPI_INVALID_INT
#define Y_RANGE_INVALID                 YAPI_INVALID_UINT
#define Y_NEUTRAL_INVALID               YAPI_INVALID_UINT
#define Y_POSITIONATPOWERON_INVALID     YAPI_INVALID_INT
//--- (end of YServo globals)

//--- (YServo class start)
/**
 * YServo Class: RC servo motor control interface, available for instance in the Yocto-Servo
 *
 * The YServo class is designed to drive remote-control servo motors
 * outputs. This class allows you not only to move
 * a servo to a given position, but also to specify the time interval
 * in which the move should be performed. This makes it possible to
 * synchronize two servos involved in a same move.
 */
@interface YServo : YFunction
//--- (end of YServo class start)
{
@protected
//--- (YServo attributes declaration)
    int             _position;
    Y_ENABLED_enum  _enabled;
    int             _range;
    int             _neutral;
    YMove           _move;
    int             _positionAtPowerOn;
    Y_ENABLEDATPOWERON_enum _enabledAtPowerOn;
    YServoValueCallback _valueCallbackServo;
//--- (end of YServo attributes declaration)
}
// Constructor is protected, use yFindServo factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YServo private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YServo private methods declaration)
//--- (YServo yapiwrapper declaration)
//--- (end of YServo yapiwrapper declaration)
//--- (YServo public methods declaration)
/**
 * Returns the current servo position.
 *
 * @return an integer corresponding to the current servo position
 *
 * On failure, throws an exception or returns YServo.POSITION_INVALID.
 */
-(int)     get_position;


-(int) position;
/**
 * Changes immediately the servo driving position.
 *
 * @param newval : an integer corresponding to immediately the servo driving position
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_position:(int) newval;
-(int)     setPosition:(int) newval;

/**
 * Returns the state of the RC servo motors.
 *
 * @return either YServo.ENABLED_FALSE or YServo.ENABLED_TRUE, according to the state of the RC servo motors
 *
 * On failure, throws an exception or returns YServo.ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Stops or starts the RC servo motor.
 *
 * @param newval : either YServo.ENABLED_FALSE or YServo.ENABLED_TRUE
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Returns the current range of use of the servo.
 *
 * @return an integer corresponding to the current range of use of the servo
 *
 * On failure, throws an exception or returns YServo.RANGE_INVALID.
 */
-(int)     get_range;


-(int) range;
/**
 * Changes the range of use of the servo, specified in per cents.
 * A range of 100% corresponds to a standard control signal, that varies
 * from 1 [ms] to 2 [ms], When using a servo that supports a double range,
 * from 0.5 [ms] to 2.5 [ms], you can select a range of 200%.
 * Be aware that using a range higher than what is supported by the servo
 * is likely to damage the servo. Remember to call the matching module
 * saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : an integer corresponding to the range of use of the servo, specified in per cents
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_range:(int) newval;
-(int)     setRange:(int) newval;

/**
 * Returns the duration in microseconds of a neutral pulse for the servo.
 *
 * @return an integer corresponding to the duration in microseconds of a neutral pulse for the servo
 *
 * On failure, throws an exception or returns YServo.NEUTRAL_INVALID.
 */
-(int)     get_neutral;


-(int) neutral;
/**
 * Changes the duration of the pulse corresponding to the neutral position of the servo.
 * The duration is specified in microseconds, and the standard value is 1500 [us].
 * This setting makes it possible to shift the range of use of the servo.
 * Be aware that using a range higher than what is supported by the servo is
 * likely to damage the servo. Remember to call the matching module
 * saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : an integer corresponding to the duration of the pulse corresponding to the neutral
 * position of the servo
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_neutral:(int) newval;
-(int)     setNeutral:(int) newval;

-(YMove)     get_move;


-(YMove) move;
-(int)     set_move:(YMove) newval;
-(int)     setMove:(YMove) newval;

/**
 * Performs a smooth move at constant speed toward a given position.
 *
 * @param target      : new position at the end of the move
 * @param ms_duration : total duration of the move, in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     move:(int)target :(int)ms_duration;

/**
 * Returns the servo position at device power up.
 *
 * @return an integer corresponding to the servo position at device power up
 *
 * On failure, throws an exception or returns YServo.POSITIONATPOWERON_INVALID.
 */
-(int)     get_positionAtPowerOn;


-(int) positionAtPowerOn;
/**
 * Configure the servo position at device power up. Remember to call the matching
 * module saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_positionAtPowerOn:(int) newval;
-(int)     setPositionAtPowerOn:(int) newval;

/**
 * Returns the servo signal generator state at power up.
 *
 * @return either YServo.ENABLEDATPOWERON_FALSE or YServo.ENABLEDATPOWERON_TRUE, according to the
 * servo signal generator state at power up
 *
 * On failure, throws an exception or returns YServo.ENABLEDATPOWERON_INVALID.
 */
-(Y_ENABLEDATPOWERON_enum)     get_enabledAtPowerOn;


-(Y_ENABLEDATPOWERON_enum) enabledAtPowerOn;
/**
 * Configure the servo signal generator state at power up. Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : either YServo.ENABLEDATPOWERON_FALSE or YServo.ENABLEDATPOWERON_TRUE
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;
-(int)     setEnabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;

/**
 * Retrieves a RC servo motor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the RC servo motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YServo.isOnline() to test if the RC servo motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RC servo motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RC servo motor, for instance
 *         SERVORC1.servo1.
 *
 * @return a YServo object allowing you to drive the RC servo motor.
 */
+(YServo*)     FindServo:(NSString*)func;

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
-(int)     registerValueCallback:(YServoValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of RC servo motors started using yFirstServo().
 * Caution: You can't make any assumption about the returned RC servo motors order.
 * If you want to find a specific a RC servo motor, use Servo.findServo()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YServo object, corresponding to
 *         a RC servo motor currently online, or a nil pointer
 *         if there are no more RC servo motors to enumerate.
 */
-(nullable YServo*) nextServo
NS_SWIFT_NAME(nextServo());
/**
 * Starts the enumeration of RC servo motors currently accessible.
 * Use the method YServo.nextServo() to iterate on
 * next RC servo motors.
 *
 * @return a pointer to a YServo object, corresponding to
 *         the first RC servo motor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YServo*) FirstServo
NS_SWIFT_NAME(FirstServo());
//--- (end of YServo public methods declaration)

@end

//--- (YServo functions declaration)
/**
 * Retrieves a RC servo motor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the RC servo motor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YServo.isOnline() to test if the RC servo motor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RC servo motor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RC servo motor, for instance
 *         SERVORC1.servo1.
 *
 * @return a YServo object allowing you to drive the RC servo motor.
 */
YServo* yFindServo(NSString* func);
/**
 * Starts the enumeration of RC servo motors currently accessible.
 * Use the method YServo.nextServo() to iterate on
 * next RC servo motors.
 *
 * @return a pointer to a YServo object, corresponding to
 *         the first RC servo motor currently online, or a nil pointer
 *         if there are none.
 */
YServo* yFirstServo(void);

//--- (end of YServo functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

