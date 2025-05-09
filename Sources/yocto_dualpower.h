/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindDualPower(), the high-level API for DualPower functions
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

@class YDualPower;

//--- (YDualPower globals)
typedef void (*YDualPowerValueCallback)(YDualPower *func, NSString *functionValue);
#ifndef _Y_POWERSTATE_ENUM
#define _Y_POWERSTATE_ENUM
typedef enum {
    Y_POWERSTATE_OFF = 0,
    Y_POWERSTATE_FROM_USB = 1,
    Y_POWERSTATE_FROM_EXT = 2,
    Y_POWERSTATE_INVALID = -1,
} Y_POWERSTATE_enum;
#endif
#ifndef _Y_POWERCONTROL_ENUM
#define _Y_POWERCONTROL_ENUM
typedef enum {
    Y_POWERCONTROL_AUTO = 0,
    Y_POWERCONTROL_FROM_USB = 1,
    Y_POWERCONTROL_FROM_EXT = 2,
    Y_POWERCONTROL_OFF = 3,
    Y_POWERCONTROL_INVALID = -1,
} Y_POWERCONTROL_enum;
#endif
#define Y_EXTVOLTAGE_INVALID            YAPI_INVALID_UINT
//--- (end of YDualPower globals)

//--- (YDualPower class start)
/**
 * YDualPower Class: dual power switch control interface, available for instance in the Yocto-Servo
 *
 * The YDualPower class allows you to control
 * the power source to use for module functions that require high current.
 * The module can also automatically disconnect the external power
 * when a voltage drop is observed on the external power source
 * (external battery running out of power).
 */
@interface YDualPower : YFunction
//--- (end of YDualPower class start)
{
@protected
//--- (YDualPower attributes declaration)
    Y_POWERSTATE_enum _powerState;
    Y_POWERCONTROL_enum _powerControl;
    int             _extVoltage;
    YDualPowerValueCallback _valueCallbackDualPower;
//--- (end of YDualPower attributes declaration)
}
// Constructor is protected, use yFindDualPower factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YDualPower private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YDualPower private methods declaration)
//--- (YDualPower yapiwrapper declaration)
//--- (end of YDualPower yapiwrapper declaration)
//--- (YDualPower public methods declaration)
/**
 * Returns the current power source for module functions that require lots of current.
 *
 * @return a value among YDualPower.POWERSTATE_OFF, YDualPower.POWERSTATE_FROM_USB and
 * YDualPower.POWERSTATE_FROM_EXT corresponding to the current power source for module functions that
 * require lots of current
 *
 * On failure, throws an exception or returns YDualPower.POWERSTATE_INVALID.
 */
-(Y_POWERSTATE_enum)     get_powerState;


-(Y_POWERSTATE_enum) powerState;
/**
 * Returns the selected power source for module functions that require lots of current.
 *
 * @return a value among YDualPower.POWERCONTROL_AUTO, YDualPower.POWERCONTROL_FROM_USB,
 * YDualPower.POWERCONTROL_FROM_EXT and YDualPower.POWERCONTROL_OFF corresponding to the selected
 * power source for module functions that require lots of current
 *
 * On failure, throws an exception or returns YDualPower.POWERCONTROL_INVALID.
 */
-(Y_POWERCONTROL_enum)     get_powerControl;


-(Y_POWERCONTROL_enum) powerControl;
/**
 * Changes the selected power source for module functions that require lots of current.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YDualPower.POWERCONTROL_AUTO, YDualPower.POWERCONTROL_FROM_USB,
 * YDualPower.POWERCONTROL_FROM_EXT and YDualPower.POWERCONTROL_OFF corresponding to the selected
 * power source for module functions that require lots of current
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns YDualPower.EXTVOLTAGE_INVALID.
 */
-(int)     get_extVoltage;


-(int) extVoltage;
/**
 * Retrieves a dual power switch for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the dual power switch is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDualPower.isOnline() to test if the dual power switch is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power switch by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the dual power switch, for instance
 *         SERVORC1.dualPower.
 *
 * @return a YDualPower object allowing you to drive the dual power switch.
 */
+(YDualPower*)     FindDualPower:(NSString*)func;

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
-(int)     registerValueCallback:(YDualPowerValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of dual power switches started using yFirstDualPower().
 * Caution: You can't make any assumption about the returned dual power switches order.
 * If you want to find a specific a dual power switch, use DualPower.findDualPower()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YDualPower object, corresponding to
 *         a dual power switch currently online, or a nil pointer
 *         if there are no more dual power switches to enumerate.
 */
-(nullable YDualPower*) nextDualPower
NS_SWIFT_NAME(nextDualPower());
/**
 * Starts the enumeration of dual power switches currently accessible.
 * Use the method YDualPower.nextDualPower() to iterate on
 * next dual power switches.
 *
 * @return a pointer to a YDualPower object, corresponding to
 *         the first dual power switch currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YDualPower*) FirstDualPower
NS_SWIFT_NAME(FirstDualPower());
//--- (end of YDualPower public methods declaration)

@end

//--- (YDualPower functions declaration)
/**
 * Retrieves a dual power switch for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the dual power switch is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDualPower.isOnline() to test if the dual power switch is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power switch by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the dual power switch, for instance
 *         SERVORC1.dualPower.
 *
 * @return a YDualPower object allowing you to drive the dual power switch.
 */
YDualPower* yFindDualPower(NSString* func);
/**
 * Starts the enumeration of dual power switches currently accessible.
 * Use the method YDualPower.nextDualPower() to iterate on
 * next dual power switches.
 *
 * @return a pointer to a YDualPower object, corresponding to
 *         the first dual power switch currently online, or a nil pointer
 *         if there are none.
 */
YDualPower* yFirstDualPower(void);

//--- (end of YDualPower functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

