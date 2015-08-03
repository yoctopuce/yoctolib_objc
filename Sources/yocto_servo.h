/*********************************************************************
 *
 * $Id: yocto_servo.h 20287 2015-05-08 13:40:21Z seb $
 *
 * Declares yFindServo(), the high-level API for Servo functions
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
 * YServo Class: Servo function interface
 *
 * Yoctopuce application programming interface allows you not only to move
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
//--- (YServo public methods declaration)
/**
 * Returns the current servo position.
 *
 * @return an integer corresponding to the current servo position
 *
 * On failure, throws an exception or returns Y_POSITION_INVALID.
 */
-(int)     get_position;


-(int) position;
/**
 * Changes immediately the servo driving position.
 *
 * @param newval : an integer corresponding to immediately the servo driving position
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_position:(int) newval;
-(int)     setPosition:(int) newval;

/**
 * Returns the state of the servos.
 *
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the state of the servos
 *
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Stops or starts the servo.
 *
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_RANGE_INVALID.
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
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_NEUTRAL_INVALID.
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
 * @return YAPI_SUCCESS if the call succeeds.
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
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     move:(int)target :(int)ms_duration;

/**
 * Returns the servo position at device power up.
 *
 * @return an integer corresponding to the servo position at device power up
 *
 * On failure, throws an exception or returns Y_POSITIONATPOWERON_INVALID.
 */
-(int)     get_positionAtPowerOn;


-(int) positionAtPowerOn;
/**
 * Configure the servo position at device power up. Remember to call the matching
 * module saveToFlash() method, otherwise this call will have no effect.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_positionAtPowerOn:(int) newval;
-(int)     setPositionAtPowerOn:(int) newval;

/**
 * Returns the servo signal generator state at power up.
 *
 * @return either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE, according to the servo signal
 * generator state at power up
 *
 * On failure, throws an exception or returns Y_ENABLEDATPOWERON_INVALID.
 */
-(Y_ENABLEDATPOWERON_enum)     get_enabledAtPowerOn;


-(Y_ENABLEDATPOWERON_enum) enabledAtPowerOn;
/**
 * Configure the servo signal generator state at power up. Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : either Y_ENABLEDATPOWERON_FALSE or Y_ENABLEDATPOWERON_TRUE
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;
-(int)     setEnabledAtPowerOn:(Y_ENABLEDATPOWERON_enum) newval;

/**
 * Retrieves a servo for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the servo is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YServo.isOnline() to test if the servo is
 * indeed online at a given time. In case of ambiguity when looking for
 * a servo by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the servo
 *
 * @return a YServo object allowing you to drive the servo.
 */
+(YServo*)     FindServo:(NSString*)func;

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
-(int)     registerValueCallback:(YServoValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of servos started using yFirstServo().
 *
 * @return a pointer to a YServo object, corresponding to
 *         a servo currently online, or a null pointer
 *         if there are no more servos to enumerate.
 */
-(YServo*) nextServo;
/**
 * Starts the enumeration of servos currently accessible.
 * Use the method YServo.nextServo() to iterate on
 * next servos.
 *
 * @return a pointer to a YServo object, corresponding to
 *         the first servo currently online, or a null pointer
 *         if there are none.
 */
+(YServo*) FirstServo;
//--- (end of YServo public methods declaration)

@end

//--- (Servo functions declaration)
/**
 * Retrieves a servo for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the servo is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YServo.isOnline() to test if the servo is
 * indeed online at a given time. In case of ambiguity when looking for
 * a servo by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the servo
 *
 * @return a YServo object allowing you to drive the servo.
 */
YServo* yFindServo(NSString* func);
/**
 * Starts the enumeration of servos currently accessible.
 * Use the method YServo.nextServo() to iterate on
 * next servos.
 *
 * @return a pointer to a YServo object, corresponding to
 *         the first servo currently online, or a null pointer
 *         if there are none.
 */
YServo* yFirstServo(void);

//--- (end of Servo functions declaration)
CF_EXTERN_C_END

