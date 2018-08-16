/*********************************************************************
 *
 * $Id: yocto_multiaxiscontroller.h 31436 2018-08-07 15:28:18Z seb $
 *
 * Declares yFindMultiAxisController(), the high-level API for MultiAxisController functions
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

@class YMultiAxisController;

//--- (YMultiAxisController globals)
typedef void (*YMultiAxisControllerValueCallback)(YMultiAxisController *func, NSString *functionValue);
#ifndef _Y_GLOBALSTATE_ENUM
#define _Y_GLOBALSTATE_ENUM
typedef enum {
    Y_GLOBALSTATE_ABSENT = 0,
    Y_GLOBALSTATE_ALERT = 1,
    Y_GLOBALSTATE_HI_Z = 2,
    Y_GLOBALSTATE_STOP = 3,
    Y_GLOBALSTATE_RUN = 4,
    Y_GLOBALSTATE_BATCH = 5,
    Y_GLOBALSTATE_INVALID = -1,
} Y_GLOBALSTATE_enum;
#endif
#define Y_NAXIS_INVALID                 YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YMultiAxisController globals)

//--- (YMultiAxisController class start)
/**
 * YMultiAxisController Class: MultiAxisController function interface
 *
 * The Yoctopuce application programming interface allows you to drive a stepper motor.
 */
@interface YMultiAxisController : YFunction
//--- (end of YMultiAxisController class start)
{
@protected
//--- (YMultiAxisController attributes declaration)
    int             _nAxis;
    Y_GLOBALSTATE_enum _globalState;
    NSString*       _command;
    YMultiAxisControllerValueCallback _valueCallbackMultiAxisController;
//--- (end of YMultiAxisController attributes declaration)
}
// Constructor is protected, use yFindMultiAxisController factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YMultiAxisController private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YMultiAxisController private methods declaration)
//--- (YMultiAxisController yapiwrapper declaration)
//--- (end of YMultiAxisController yapiwrapper declaration)
//--- (YMultiAxisController public methods declaration)
/**
 * Returns the number of synchronized controllers.
 *
 * @return an integer corresponding to the number of synchronized controllers
 *
 * On failure, throws an exception or returns Y_NAXIS_INVALID.
 */
-(int)     get_nAxis;


-(int) nAxis;
/**
 * Changes the number of synchronized controllers.
 *
 * @param newval : an integer corresponding to the number of synchronized controllers
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_nAxis:(int) newval;
-(int)     setNAxis:(int) newval;

/**
 * Returns the stepper motor set overall state.
 *
 * @return a value among Y_GLOBALSTATE_ABSENT, Y_GLOBALSTATE_ALERT, Y_GLOBALSTATE_HI_Z,
 * Y_GLOBALSTATE_STOP, Y_GLOBALSTATE_RUN and Y_GLOBALSTATE_BATCH corresponding to the stepper motor
 * set overall state
 *
 * On failure, throws an exception or returns Y_GLOBALSTATE_INVALID.
 */
-(Y_GLOBALSTATE_enum)     get_globalState;


-(Y_GLOBALSTATE_enum) globalState;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a multi-axis controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-axis controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiAxisController.isOnline() to test if the multi-axis controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-axis controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-axis controller
 *
 * @return a YMultiAxisController object allowing you to drive the multi-axis controller.
 */
+(YMultiAxisController*)     FindMultiAxisController:(NSString*)func;

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
-(int)     registerValueCallback:(YMultiAxisControllerValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)command;

/**
 * Reinitialize all controllers and clear all alert flags.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

/**
 * Starts all motors backward at the specified speeds, to search for the motor home position.
 *
 * @param speed : desired speed for all axis, in steps per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     findHomePosition:(NSMutableArray*)speed;

/**
 * Starts all motors synchronously to reach a given absolute position.
 * The time needed to reach the requested position will depend on the lowest
 * acceleration and max speed parameters configured for all motors.
 * The final position will be reached on all axis at the same time.
 *
 * @param absPos : absolute position, measured in steps from each origin.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     moveTo:(NSMutableArray*)absPos;

/**
 * Starts all motors synchronously to reach a given relative position.
 * The time needed to reach the requested position will depend on the lowest
 * acceleration and max speed parameters configured for all motors.
 * The final position will be reached on all axis at the same time.
 *
 * @param relPos : relative position, measured in steps from the current position.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     moveRel:(NSMutableArray*)relPos;

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
 * Continues the enumeration of multi-axis controllers started using yFirstMultiAxisController().
 *
 * @return a pointer to a YMultiAxisController object, corresponding to
 *         a multi-axis controller currently online, or a nil pointer
 *         if there are no more multi-axis controllers to enumerate.
 */
-(YMultiAxisController*) nextMultiAxisController;
/**
 * Starts the enumeration of multi-axis controllers currently accessible.
 * Use the method YMultiAxisController.nextMultiAxisController() to iterate on
 * next multi-axis controllers.
 *
 * @return a pointer to a YMultiAxisController object, corresponding to
 *         the first multi-axis controller currently online, or a nil pointer
 *         if there are none.
 */
+(YMultiAxisController*) FirstMultiAxisController;
//--- (end of YMultiAxisController public methods declaration)

@end

//--- (YMultiAxisController functions declaration)
/**
 * Retrieves a multi-axis controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-axis controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiAxisController.isOnline() to test if the multi-axis controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-axis controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-axis controller
 *
 * @return a YMultiAxisController object allowing you to drive the multi-axis controller.
 */
YMultiAxisController* yFindMultiAxisController(NSString* func);
/**
 * Starts the enumeration of multi-axis controllers currently accessible.
 * Use the method YMultiAxisController.nextMultiAxisController() to iterate on
 * next multi-axis controllers.
 *
 * @return a pointer to a YMultiAxisController object, corresponding to
 *         the first multi-axis controller currently online, or a nil pointer
 *         if there are none.
 */
YMultiAxisController* yFirstMultiAxisController(void);

//--- (end of YMultiAxisController functions declaration)
CF_EXTERN_C_END

