/*********************************************************************
 *
 * $Id: yocto_dualpower.h 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Declares yFindDualPower(), the high-level API for DualPower functions
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

//--- (YDualPower definitions)
typedef enum {
    Y_POWERSTATE_OFF = 0,
    Y_POWERSTATE_FROM_USB = 1,
    Y_POWERSTATE_FROM_EXT = 2,
    Y_POWERSTATE_INVALID = -1
} Y_POWERSTATE_enum;

typedef enum {
    Y_POWERCONTROL_AUTO = 0,
    Y_POWERCONTROL_FROM_USB = 1,
    Y_POWERCONTROL_FROM_EXT = 2,
    Y_POWERCONTROL_OFF = 3,
    Y_POWERCONTROL_INVALID = -1
} Y_POWERCONTROL_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_EXTVOLTAGE_INVALID            (0xffffffff)
//--- (end of YDualPower definitions)

/**
 * YDualPower Class: External power supply control interface
 * 
 * Yoctopuce application programming interface allows you to control
 * the power source to use for module functions that require high current.
 * The module can also automatically disconnect the external power
 * when a voltage drop is observed on the external power source
 * (external battery running out of power).
 */
@interface YDualPower : YFunction
{
@protected

// Attributes (function value cache)
//--- (YDualPower attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    Y_POWERSTATE_enum _powerState;
    Y_POWERCONTROL_enum _powerControl;
    unsigned        _extVoltage;
//--- (end of YDualPower attributes)
}
//--- (YDualPower declaration)
// Constructor is protected, use yFindDualPower factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

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
-(void)     registerValueCallback:(YFunctionUpdateCallback) callback;   
/**
 * comment from .yc definition
 */
-(void)     set_objectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object withSelector:(SEL)selector;

//--- (end of YDualPower declaration)
//--- (YDualPower accessors declaration)

/**
 * Continues the enumeration of dual power controls started using yFirstDualPower().
 * 
 * @return a pointer to a YDualPower object, corresponding to
 *         a dual power control currently online, or a null pointer
 *         if there are no more dual power controls to enumerate.
 */
-(YDualPower*) nextDualPower;
/**
 * Retrieves a dual power control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the power control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDualPower.isOnline() to test if the power control is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the power control
 * 
 * @return a YDualPower object allowing you to drive the power control.
 */
+(YDualPower*) FindDualPower:(NSString*) func;
/**
 * Starts the enumeration of dual power controls currently accessible.
 * Use the method YDualPower.nextDualPower() to iterate on
 * next dual power controls.
 * 
 * @return a pointer to a YDualPower object, corresponding to
 *         the first dual power control currently online, or a null pointer
 *         if there are none.
 */
+(YDualPower*) FirstDualPower;

/**
 * Returns the logical name of the power control.
 * 
 * @return a string corresponding to the logical name of the power control
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the power control. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the power control
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the power control (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the power control (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the current power source for module functions that require lots of current.
 * 
 * @return a value among Y_POWERSTATE_OFF, Y_POWERSTATE_FROM_USB and Y_POWERSTATE_FROM_EXT
 * corresponding to the current power source for module functions that require lots of current
 * 
 * On failure, throws an exception or returns Y_POWERSTATE_INVALID.
 */
-(Y_POWERSTATE_enum) get_powerState;
-(Y_POWERSTATE_enum) powerState;

/**
 * Returns the selected power source for module functions that require lots of current.
 * 
 * @return a value among Y_POWERCONTROL_AUTO, Y_POWERCONTROL_FROM_USB, Y_POWERCONTROL_FROM_EXT and
 * Y_POWERCONTROL_OFF corresponding to the selected power source for module functions that require lots of current
 * 
 * On failure, throws an exception or returns Y_POWERCONTROL_INVALID.
 */
-(Y_POWERCONTROL_enum) get_powerControl;
-(Y_POWERCONTROL_enum) powerControl;

/**
 * Changes the selected power source for module functions that require lots of current.
 * 
 * @param newval : a value among Y_POWERCONTROL_AUTO, Y_POWERCONTROL_FROM_USB, Y_POWERCONTROL_FROM_EXT
 * and Y_POWERCONTROL_OFF corresponding to the selected power source for module functions that require
 * lots of current
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerControl:(Y_POWERCONTROL_enum) newval;
-(int)     setPowerControl:(Y_POWERCONTROL_enum) newval;

/**
 * Returns the measured voltage on the external power source, in millivolts.
 * 
 * @return an integer corresponding to the measured voltage on the external power source, in millivolts
 * 
 * On failure, throws an exception or returns Y_EXTVOLTAGE_INVALID.
 */
-(unsigned) get_extVoltage;
-(unsigned) extVoltage;


//--- (end of YDualPower accessors declaration)
@end

//--- (DualPower functions declaration)

/**
 * Retrieves a dual power control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the power control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDualPower.isOnline() to test if the power control is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the power control
 * 
 * @return a YDualPower object allowing you to drive the power control.
 */
YDualPower* yFindDualPower(NSString* func);
/**
 * Starts the enumeration of dual power controls currently accessible.
 * Use the method YDualPower.nextDualPower() to iterate on
 * next dual power controls.
 * 
 * @return a pointer to a YDualPower object, corresponding to
 *         the first dual power control currently online, or a null pointer
 *         if there are none.
 */
YDualPower* yFirstDualPower(void);

//--- (end of DualPower functions declaration)
CF_EXTERN_C_END

