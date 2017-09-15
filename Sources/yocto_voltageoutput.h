/*********************************************************************
 *
 * $Id: yocto_voltageoutput.h 28491 2017-09-12 13:25:28Z seb $
 *
 * Declares yFindVoltageOutput(), the high-level API for VoltageOutput functions
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

@class YVoltageOutput;

//--- (YVoltageOutput globals)
typedef void (*YVoltageOutputValueCallback)(YVoltageOutput *func, NSString *functionValue);
#define Y_CURRENTVOLTAGE_INVALID        YAPI_INVALID_DOUBLE
#define Y_VOLTAGETRANSITION_INVALID     YAPI_INVALID_STRING
#define Y_VOLTAGEATSTARTUP_INVALID      YAPI_INVALID_DOUBLE
//--- (end of YVoltageOutput globals)

//--- (YVoltageOutput class start)
/**
 * YVoltageOutput Class: VoltageOutput function interface
 *
 * The Yoctopuce application programming interface allows you to change the value of the voltage output.
 */
@interface YVoltageOutput : YFunction
//--- (end of YVoltageOutput class start)
{
@protected
//--- (YVoltageOutput attributes declaration)
    double          _currentVoltage;
    NSString*       _voltageTransition;
    double          _voltageAtStartUp;
    YVoltageOutputValueCallback _valueCallbackVoltageOutput;
//--- (end of YVoltageOutput attributes declaration)
}
// Constructor is protected, use yFindVoltageOutput factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YVoltageOutput private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YVoltageOutput private methods declaration)
//--- (YVoltageOutput public methods declaration)
/**
 * Changes the output voltage, in V. Valid range is from 0 to 10V.
 *
 * @param newval : a floating point number corresponding to the output voltage, in V
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentVoltage:(double) newval;
-(int)     setCurrentVoltage:(double) newval;

/**
 * Returns the output voltage set point, in V.
 *
 * @return a floating point number corresponding to the output voltage set point, in V
 *
 * On failure, throws an exception or returns Y_CURRENTVOLTAGE_INVALID.
 */
-(double)     get_currentVoltage;


-(double) currentVoltage;
-(NSString*)     get_voltageTransition;


-(NSString*) voltageTransition;
-(int)     set_voltageTransition:(NSString*) newval;
-(int)     setVoltageTransition:(NSString*) newval;

/**
 * Changes the output voltage at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the output voltage at device start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageAtStartUp:(double) newval;
-(int)     setVoltageAtStartUp:(double) newval;

/**
 * Returns the selected voltage output at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage output at device startup, in V
 *
 * On failure, throws an exception or returns Y_VOLTAGEATSTARTUP_INVALID.
 */
-(double)     get_voltageAtStartUp;


-(double) voltageAtStartUp;
/**
 * Retrieves a voltage output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltageOutput.isOnline() to test if the voltage output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage output
 *
 * @return a YVoltageOutput object allowing you to drive the voltage output.
 */
+(YVoltageOutput*)     FindVoltageOutput:(NSString*)func;

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
-(int)     registerValueCallback:(YVoltageOutputValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Performs a smooth transistion of output voltage. Any explicit voltage
 * change cancels any ongoing transition process.
 *
 * @param V_target   : new output voltage value at the end of the transition
 *         (floating-point number, representing the end voltage in V)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 */
-(int)     voltageMove:(double)V_target :(int)ms_duration;


/**
 * Continues the enumeration of voltage outputs started using yFirstVoltageOutput().
 *
 * @return a pointer to a YVoltageOutput object, corresponding to
 *         a voltage output currently online, or a nil pointer
 *         if there are no more voltage outputs to enumerate.
 */
-(YVoltageOutput*) nextVoltageOutput;
/**
 * Starts the enumeration of voltage outputs currently accessible.
 * Use the method YVoltageOutput.nextVoltageOutput() to iterate on
 * next voltage outputs.
 *
 * @return a pointer to a YVoltageOutput object, corresponding to
 *         the first voltage output currently online, or a nil pointer
 *         if there are none.
 */
+(YVoltageOutput*) FirstVoltageOutput;
//--- (end of YVoltageOutput public methods declaration)

@end

//--- (VoltageOutput functions declaration)
/**
 * Retrieves a voltage output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltageOutput.isOnline() to test if the voltage output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage output
 *
 * @return a YVoltageOutput object allowing you to drive the voltage output.
 */
YVoltageOutput* yFindVoltageOutput(NSString* func);
/**
 * Starts the enumeration of voltage outputs currently accessible.
 * Use the method YVoltageOutput.nextVoltageOutput() to iterate on
 * next voltage outputs.
 *
 * @return a pointer to a YVoltageOutput object, corresponding to
 *         the first voltage output currently online, or a nil pointer
 *         if there are none.
 */
YVoltageOutput* yFirstVoltageOutput(void);

//--- (end of VoltageOutput functions declaration)
CF_EXTERN_C_END

