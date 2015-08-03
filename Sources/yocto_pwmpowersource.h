/*********************************************************************
 *
 * $Id: yocto_pwmpowersource.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindPwmPowerSource(), the high-level API for PwmPowerSource functions
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

@class YPwmPowerSource;

//--- (YPwmPowerSource globals)
typedef void (*YPwmPowerSourceValueCallback)(YPwmPowerSource *func, NSString *functionValue);
#ifndef _Y_POWERMODE_ENUM
#define _Y_POWERMODE_ENUM
typedef enum {
    Y_POWERMODE_USB_5V = 0,
    Y_POWERMODE_USB_3V = 1,
    Y_POWERMODE_EXT_V = 2,
    Y_POWERMODE_OPNDRN = 3,
    Y_POWERMODE_INVALID = -1,
} Y_POWERMODE_enum;
#endif
//--- (end of YPwmPowerSource globals)

//--- (YPwmPowerSource class start)
/**
 * YPwmPowerSource Class: PwmPowerSource function interface
 *
 * The Yoctopuce application programming interface allows you to configure
 * the voltage source used by all PWM on the same device.
 */
@interface YPwmPowerSource : YFunction
//--- (end of YPwmPowerSource class start)
{
@protected
//--- (YPwmPowerSource attributes declaration)
    Y_POWERMODE_enum _powerMode;
    YPwmPowerSourceValueCallback _valueCallbackPwmPowerSource;
//--- (end of YPwmPowerSource attributes declaration)
}
// Constructor is protected, use yFindPwmPowerSource factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YPwmPowerSource private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YPwmPowerSource private methods declaration)
//--- (YPwmPowerSource public methods declaration)
/**
 * Returns the selected power source for the PWM on the same device
 *
 * @return a value among Y_POWERMODE_USB_5V, Y_POWERMODE_USB_3V, Y_POWERMODE_EXT_V and
 * Y_POWERMODE_OPNDRN corresponding to the selected power source for the PWM on the same device
 *
 * On failure, throws an exception or returns Y_POWERMODE_INVALID.
 */
-(Y_POWERMODE_enum)     get_powerMode;


-(Y_POWERMODE_enum) powerMode;
/**
 * Changes  the PWM power source. PWM can use isolated 5V from USB, isolated 3V from USB or
 * voltage from an external power source. The PWM can also work in open drain  mode. In that
 * mode, the PWM actively pulls the line down.
 * Warning: this setting is common to all PWM on the same device. If you change that parameter,
 * all PWM located on the same device are  affected.
 * If you want the change to be kept after a device reboot, make sure  to call the matching
 * module saveToFlash().
 *
 * @param newval : a value among Y_POWERMODE_USB_5V, Y_POWERMODE_USB_3V, Y_POWERMODE_EXT_V and
 * Y_POWERMODE_OPNDRN corresponding to  the PWM power source
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerMode:(Y_POWERMODE_enum) newval;
-(int)     setPowerMode:(Y_POWERMODE_enum) newval;

/**
 * Retrieves a voltage source for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmPowerSource.isOnline() to test if the voltage source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the voltage source
 *
 * @return a YPwmPowerSource object allowing you to drive the voltage source.
 */
+(YPwmPowerSource*)     FindPwmPowerSource:(NSString*)func;

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
-(int)     registerValueCallback:(YPwmPowerSourceValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of Voltage sources started using yFirstPwmPowerSource().
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         a voltage source currently online, or a null pointer
 *         if there are no more Voltage sources to enumerate.
 */
-(YPwmPowerSource*) nextPwmPowerSource;
/**
 * Starts the enumeration of Voltage sources currently accessible.
 * Use the method YPwmPowerSource.nextPwmPowerSource() to iterate on
 * next Voltage sources.
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         the first source currently online, or a null pointer
 *         if there are none.
 */
+(YPwmPowerSource*) FirstPwmPowerSource;
//--- (end of YPwmPowerSource public methods declaration)

@end

//--- (PwmPowerSource functions declaration)
/**
 * Retrieves a voltage source for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmPowerSource.isOnline() to test if the voltage source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the voltage source
 *
 * @return a YPwmPowerSource object allowing you to drive the voltage source.
 */
YPwmPowerSource* yFindPwmPowerSource(NSString* func);
/**
 * Starts the enumeration of Voltage sources currently accessible.
 * Use the method YPwmPowerSource.nextPwmPowerSource() to iterate on
 * next Voltage sources.
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         the first source currently online, or a null pointer
 *         if there are none.
 */
YPwmPowerSource* yFirstPwmPowerSource(void);

//--- (end of PwmPowerSource functions declaration)
CF_EXTERN_C_END

