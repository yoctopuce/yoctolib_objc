/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindPwmPowerSource(), the high-level API for PwmPowerSource functions
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
 * YPwmPowerSource Class: PWM generator power source control interface, available for instance in the Yocto-PWM-Tx
 *
 * The YPwmPowerSource class allows you to configure
 * the voltage source used by all PWM outputs on the same device.
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
//--- (YPwmPowerSource yapiwrapper declaration)
//--- (end of YPwmPowerSource yapiwrapper declaration)
//--- (YPwmPowerSource public methods declaration)
/**
 * Returns the selected power source for the PWM on the same device.
 *
 * @return a value among YPwmPowerSource.POWERMODE_USB_5V, YPwmPowerSource.POWERMODE_USB_3V,
 * YPwmPowerSource.POWERMODE_EXT_V and YPwmPowerSource.POWERMODE_OPNDRN corresponding to the selected
 * power source for the PWM on the same device
 *
 * On failure, throws an exception or returns YPwmPowerSource.POWERMODE_INVALID.
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
 * @param newval : a value among YPwmPowerSource.POWERMODE_USB_5V, YPwmPowerSource.POWERMODE_USB_3V,
 * YPwmPowerSource.POWERMODE_EXT_V and YPwmPowerSource.POWERMODE_OPNDRN corresponding to  the PWM power source
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_powerMode:(Y_POWERMODE_enum) newval;
-(int)     setPowerMode:(Y_POWERMODE_enum) newval;

/**
 * Retrieves a PWM generator power source for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the PWM generator power source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmPowerSource.isOnline() to test if the PWM generator power source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a PWM generator power source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the PWM generator power source, for instance
 *         YPWMTX01.pwmPowerSource.
 *
 * @return a YPwmPowerSource object allowing you to drive the PWM generator power source.
 */
+(YPwmPowerSource*)     FindPwmPowerSource:(NSString*)func;

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
-(int)     registerValueCallback:(YPwmPowerSourceValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of PWM generator power sources started using yFirstPwmPowerSource().
 * Caution: You can't make any assumption about the returned PWM generator power sources order.
 * If you want to find a specific a PWM generator power source, use PwmPowerSource.findPwmPowerSource()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         a PWM generator power source currently online, or a nil pointer
 *         if there are no more PWM generator power sources to enumerate.
 */
-(nullable YPwmPowerSource*) nextPwmPowerSource
NS_SWIFT_NAME(nextPwmPowerSource());
/**
 * Starts the enumeration of PWM generator power sources currently accessible.
 * Use the method YPwmPowerSource.nextPwmPowerSource() to iterate on
 * next PWM generator power sources.
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         the first PWM generator power source currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YPwmPowerSource*) FirstPwmPowerSource
NS_SWIFT_NAME(FirstPwmPowerSource());
//--- (end of YPwmPowerSource public methods declaration)

@end

//--- (YPwmPowerSource functions declaration)
/**
 * Retrieves a PWM generator power source for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the PWM generator power source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPwmPowerSource.isOnline() to test if the PWM generator power source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a PWM generator power source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the PWM generator power source, for instance
 *         YPWMTX01.pwmPowerSource.
 *
 * @return a YPwmPowerSource object allowing you to drive the PWM generator power source.
 */
YPwmPowerSource* yFindPwmPowerSource(NSString* func);
/**
 * Starts the enumeration of PWM generator power sources currently accessible.
 * Use the method YPwmPowerSource.nextPwmPowerSource() to iterate on
 * next PWM generator power sources.
 *
 * @return a pointer to a YPwmPowerSource object, corresponding to
 *         the first PWM generator power source currently online, or a nil pointer
 *         if there are none.
 */
YPwmPowerSource* yFirstPwmPowerSource(void);

//--- (end of YPwmPowerSource functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

