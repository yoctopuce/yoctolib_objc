/*********************************************************************
 *
 * $Id: yocto_currentloopoutput.h 28752 2017-10-03 08:41:02Z seb $
 *
 * Declares yFindCurrentLoopOutput(), the high-level API for CurrentLoopOutput functions
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

@class YCurrentLoopOutput;

//--- (YCurrentLoopOutput globals)
typedef void (*YCurrentLoopOutputValueCallback)(YCurrentLoopOutput *func, NSString *functionValue);
#ifndef _Y_LOOPPOWER_ENUM
#define _Y_LOOPPOWER_ENUM
typedef enum {
    Y_LOOPPOWER_NOPWR = 0,
    Y_LOOPPOWER_LOWPWR = 1,
    Y_LOOPPOWER_POWEROK = 2,
    Y_LOOPPOWER_INVALID = -1,
} Y_LOOPPOWER_enum;
#endif
#define Y_CURRENT_INVALID               YAPI_INVALID_DOUBLE
#define Y_CURRENTTRANSITION_INVALID     YAPI_INVALID_STRING
#define Y_CURRENTATSTARTUP_INVALID      YAPI_INVALID_DOUBLE
//--- (end of YCurrentLoopOutput globals)

//--- (YCurrentLoopOutput class start)
/**
 * YCurrentLoopOutput Class: CurrentLoopOutput function interface
 *
 * The Yoctopuce application programming interface allows you to change the value of the 4-20mA
 * output as well as to know the current loop state.
 */
@interface YCurrentLoopOutput : YFunction
//--- (end of YCurrentLoopOutput class start)
{
@protected
//--- (YCurrentLoopOutput attributes declaration)
    double          _current;
    NSString*       _currentTransition;
    double          _currentAtStartUp;
    Y_LOOPPOWER_enum _loopPower;
    YCurrentLoopOutputValueCallback _valueCallbackCurrentLoopOutput;
//--- (end of YCurrentLoopOutput attributes declaration)
}
// Constructor is protected, use yFindCurrentLoopOutput factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YCurrentLoopOutput private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YCurrentLoopOutput private methods declaration)
//--- (YCurrentLoopOutput public methods declaration)
/**
 * Changes the current loop, the valid range is from 3 to 21mA. If the loop is
 * not propely powered, the  target current is not reached and
 * loopPower is set to LOWPWR.
 *
 * @param newval : a floating point number corresponding to the current loop, the valid range is from 3 to 21mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_current:(double) newval;
-(int)     setCurrent:(double) newval;

/**
 * Returns the loop current set point in mA.
 *
 * @return a floating point number corresponding to the loop current set point in mA
 *
 * On failure, throws an exception or returns Y_CURRENT_INVALID.
 */
-(double)     get_current;


-(double) current;
-(NSString*)     get_currentTransition;


-(NSString*) currentTransition;
-(int)     set_currentTransition:(NSString*) newval;
-(int)     setCurrentTransition:(NSString*) newval;

/**
 * Changes the loop current at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the loop current at device start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentAtStartUp:(double) newval;
-(int)     setCurrentAtStartUp:(double) newval;

/**
 * Returns the current in the loop at device startup, in mA.
 *
 * @return a floating point number corresponding to the current in the loop at device startup, in mA
 *
 * On failure, throws an exception or returns Y_CURRENTATSTARTUP_INVALID.
 */
-(double)     get_currentAtStartUp;


-(double) currentAtStartUp;
/**
 * Returns the loop powerstate.  POWEROK: the loop
 * is powered. NOPWR: the loop in not powered. LOWPWR: the loop is not
 * powered enough to maintain the current required (insufficient voltage).
 *
 * @return a value among Y_LOOPPOWER_NOPWR, Y_LOOPPOWER_LOWPWR and Y_LOOPPOWER_POWEROK corresponding
 * to the loop powerstate
 *
 * On failure, throws an exception or returns Y_LOOPPOWER_INVALID.
 */
-(Y_LOOPPOWER_enum)     get_loopPower;


-(Y_LOOPPOWER_enum) loopPower;
/**
 * Retrieves a 4-20mA output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the 4-20mA output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCurrentLoopOutput.isOnline() to test if the 4-20mA output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a 4-20mA output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the 4-20mA output
 *
 * @return a YCurrentLoopOutput object allowing you to drive the 4-20mA output.
 */
+(YCurrentLoopOutput*)     FindCurrentLoopOutput:(NSString*)func;

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
-(int)     registerValueCallback:(YCurrentLoopOutputValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Performs a smooth transistion of current flowing in the loop. Any current explicit
 * change cancels any ongoing transition process.
 *
 * @param mA_target   : new current value at the end of the transition
 *         (floating-point number, representing the end current in mA)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 */
-(int)     currentMove:(double)mA_target :(int)ms_duration;


/**
 * Continues the enumeration of 4-20mA outputs started using yFirstCurrentLoopOutput().
 *
 * @return a pointer to a YCurrentLoopOutput object, corresponding to
 *         a 4-20mA output currently online, or a nil pointer
 *         if there are no more 4-20mA outputs to enumerate.
 */
-(YCurrentLoopOutput*) nextCurrentLoopOutput;
/**
 * Starts the enumeration of 4-20mA outputs currently accessible.
 * Use the method YCurrentLoopOutput.nextCurrentLoopOutput() to iterate on
 * next 4-20mA outputs.
 *
 * @return a pointer to a YCurrentLoopOutput object, corresponding to
 *         the first 4-20mA output currently online, or a nil pointer
 *         if there are none.
 */
+(YCurrentLoopOutput*) FirstCurrentLoopOutput;
//--- (end of YCurrentLoopOutput public methods declaration)

@end

//--- (YCurrentLoopOutput functions declaration)
/**
 * Retrieves a 4-20mA output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the 4-20mA output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCurrentLoopOutput.isOnline() to test if the 4-20mA output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a 4-20mA output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the 4-20mA output
 *
 * @return a YCurrentLoopOutput object allowing you to drive the 4-20mA output.
 */
YCurrentLoopOutput* yFindCurrentLoopOutput(NSString* func);
/**
 * Starts the enumeration of 4-20mA outputs currently accessible.
 * Use the method YCurrentLoopOutput.nextCurrentLoopOutput() to iterate on
 * next 4-20mA outputs.
 *
 * @return a pointer to a YCurrentLoopOutput object, corresponding to
 *         the first 4-20mA output currently online, or a nil pointer
 *         if there are none.
 */
YCurrentLoopOutput* yFirstCurrentLoopOutput(void);

//--- (end of YCurrentLoopOutput functions declaration)
CF_EXTERN_C_END

