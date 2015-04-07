/*********************************************************************
 *
 * $Id: yocto_led.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindLed(), the high-level API for Led functions
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
 * Yoctopuce application programming interface
 * allows you not only to drive the intensity of the led, but also to
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
//--- (YLed public methods declaration)
/**
 * Returns the current led state.
 *
 * @return either Y_POWER_OFF or Y_POWER_ON, according to the current led state
 *
 * On failure, throws an exception or returns Y_POWER_INVALID.
 */
-(Y_POWER_enum)     get_power;


-(Y_POWER_enum) power;
/**
 * Changes the state of the led.
 *
 * @param newval : either Y_POWER_OFF or Y_POWER_ON, according to the state of the led
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_power:(Y_POWER_enum) newval;
-(int)     setPower:(Y_POWER_enum) newval;

/**
 * Returns the current led intensity (in per cent).
 *
 * @return an integer corresponding to the current led intensity (in per cent)
 *
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int)     get_luminosity;


-(int) luminosity;
/**
 * Changes the current led intensity (in per cent).
 *
 * @param newval : an integer corresponding to the current led intensity (in per cent)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_luminosity:(int) newval;
-(int)     setLuminosity:(int) newval;

/**
 * Returns the current led signaling mode.
 *
 * @return a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current led signaling mode
 *
 * On failure, throws an exception or returns Y_BLINKING_INVALID.
 */
-(Y_BLINKING_enum)     get_blinking;


-(Y_BLINKING_enum) blinking;
/**
 * Changes the current led signaling mode.
 *
 * @param newval : a value among Y_BLINKING_STILL, Y_BLINKING_RELAX, Y_BLINKING_AWARE, Y_BLINKING_RUN,
 * Y_BLINKING_CALL and Y_BLINKING_PANIC corresponding to the current led signaling mode
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_blinking:(Y_BLINKING_enum) newval;
-(int)     setBlinking:(Y_BLINKING_enum) newval;

/**
 * Retrieves a led for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the led is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if the led is
 * indeed online at a given time. In case of ambiguity when looking for
 * a led by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the led
 *
 * @return a YLed object allowing you to drive the led.
 */
+(YLed*)     FindLed:(NSString*)func;

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
-(int)     registerValueCallback:(YLedValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of leds started using yFirstLed().
 *
 * @return a pointer to a YLed object, corresponding to
 *         a led currently online, or a null pointer
 *         if there are no more leds to enumerate.
 */
-(YLed*) nextLed;
/**
 * Starts the enumeration of leds currently accessible.
 * Use the method YLed.nextLed() to iterate on
 * next leds.
 *
 * @return a pointer to a YLed object, corresponding to
 *         the first led currently online, or a null pointer
 *         if there are none.
 */
+(YLed*) FirstLed;
//--- (end of YLed public methods declaration)

@end

//--- (Led functions declaration)
/**
 * Retrieves a led for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the led is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YLed.isOnline() to test if the led is
 * indeed online at a given time. In case of ambiguity when looking for
 * a led by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the led
 *
 * @return a YLed object allowing you to drive the led.
 */
YLed* yFindLed(NSString* func);
/**
 * Starts the enumeration of leds currently accessible.
 * Use the method YLed.nextLed() to iterate on
 * next leds.
 *
 * @return a pointer to a YLed object, corresponding to
 *         the first led currently online, or a null pointer
 *         if there are none.
 */
YLed* yFirstLed(void);

//--- (end of Led functions declaration)
CF_EXTERN_C_END

