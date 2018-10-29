/*********************************************************************
 *
 *  $Id: yocto_led.h 32610 2018-10-10 06:52:20Z seb $
 *
 *  Declares yFindLed(), the high-level API for Led functions
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

@class YLed;

//--- (YLed globals)
typedef void (*YLedValueCallback)(YLed *func, NSString *functionValue);
#ifndef _Y_POWER_ENUM
#define _Y_POWER_ENUM
typedef enum {
    Y_POWER_OFF = 0,
    Y_POWER_ON = 1,
    Y_POWER_INVALID = -1,
} Y_POWER_enum;
#endif
#ifndef _Y_BLINKING_ENUM
#define _Y_BLINKING_ENUM
typedef enum {
    Y_BLINKING_STILL = 0,
    Y_BLINKING_RELAX = 1,
    Y_BLINKING_AWARE = 2,
    Y_BLINKING_RUN = 3,
    Y_BLINKING_CALL = 4,
    Y_BLINKING_PANIC = 5,
    Y_BLINKING_INVALID = -1,
} Y_BLINKING_enum;
#endif
#define Y_LUMINOSITY_INVALID            YAPI_INVALID_UINT
//--- (end of YLed globals)

//--- (YLed class start)
/**
 * YLed Class: Led function interface
 *
 * The Yoctopuce application programming interface
 * allows you not only to drive the intensity of the LED, but also to
 * have it blink at various preset frequencies.
 */
@interface YLed : YFunction
//--- (end of YLed class start)
{
@protected
//--- (YLed attributes declaration)
    Y_POWER_enum    _power;
    int             _luminosity;
    Y_BLINKING_enum _blinking;
    YLedValueCallback _valueCallbackLed;
//--- (end of YLed attributes declaration)
}
// Constructor is protected, use yFindLed factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YLed private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YLed private methods declaration)
//--- (YLed yapiwrapper declaration)
//--- (end of YLed yapiwrapper declaration)
//--- (YLed public methods declaration)
/**
 * Returns the current LED state.
 *
 * @return either Y_POWER_OFF or Y_POWER_ON, according to the current LED state
 *
 * On failure, throws an exception or returns Y_POWER_INVALID.
 */
-(Y_POWER_enum)     get_power;


-(Y_POWER_enum) power;
/**
 * Changes the state of the LED.
 *
 * @param newval : either Y_POWER_OFF or Y_POWER_ON, according to the state of the LED
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_power:(Y_POWER_enum) newval;
-(int)     setPower:(Y_POWER_enum) newval;

/**
 * Returns the current LED intensity (in per cent).
 *
 * @return an integer corresponding to the current LED intensity (in per cent)
 *
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int)     get_luminosity;


-(int) luminosity;
/**
 * Changes the current LED intensity (in per cent).
 *
 * @param newval : an integer corresponding to the current LED intensity (in per cent)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_luminosity:(int) newval;
-(int)     setLuminosity:(int) newval;

/**
 * Returns the current LED signaling mode.
 *
 * @return a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current LED signaling mode
 *
 * On failure, throws an exception or returns Y_BLINKING_INVALID.
 */
-(Y_BLINKING_enum)     get_blinking;


-(Y_BLINKING_enum) blinking;
/**
 * Changes the current LED signaling mode.
 *
 * @param newval : a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current LED signaling mode
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_blinking:(Y_BLINKING_enum) newval;
-(int)     setBlinking:(Y_BLINKING_enum) newval;

/**
 * Retrieves a LED for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the LED is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if the LED is
 * indeed online at a given time. In case of ambiguity when looking for
 * a LED by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the LED
 *
 * @return a YLed object allowing you to drive the LED.
 */
+(YLed*)     FindLed:(NSString*)func;

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
-(int)     registerValueCallback:(YLedValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of LEDs started using yFirstLed().
 *
 * @return a pointer to a YLed object, corresponding to
 *         a LED currently online, or a nil pointer
 *         if there are no more LEDs to enumerate.
 */
-(YLed*) nextLed;
/**
 * Starts the enumeration of LEDs currently accessible.
 * Use the method YLed.nextLed() to iterate on
 * next LEDs.
 *
 * @return a pointer to a YLed object, corresponding to
 *         the first LED currently online, or a nil pointer
 *         if there are none.
 */
+(YLed*) FirstLed;
//--- (end of YLed public methods declaration)

@end

//--- (YLed functions declaration)
/**
 * Retrieves a LED for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the LED is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if the LED is
 * indeed online at a given time. In case of ambiguity when looking for
 * a LED by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the LED
 *
 * @return a YLed object allowing you to drive the LED.
 */
YLed* yFindLed(NSString* func);
/**
 * Starts the enumeration of LEDs currently accessible.
 * Use the method YLed.nextLed() to iterate on
 * next LEDs.
 *
 * @return a pointer to a YLed object, corresponding to
 *         the first LED currently online, or a nil pointer
 *         if there are none.
 */
YLed* yFirstLed(void);

//--- (end of YLed functions declaration)
CF_EXTERN_C_END

