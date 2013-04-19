/*********************************************************************
 *
 * $Id: yocto_colorled.h 9945 2013-02-20 21:46:06Z seb $
 *
 * Declares yFindColorLed(), the high-level API for ColorLed functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

//--- (YColorLed definitions)
#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_RGBCOLOR_INVALID              (0xffffffff)
#define Y_HSLCOLOR_INVALID              (0xffffffff)
#define Y_RGBCOLORATPOWERON_INVALID     (0xffffffff)
//--- (end of YColorLed definitions)

/**
 * YColorLed Class: ColorLed function interface
 * 
 * Yoctopuce application programming interface
 * allows you to drive a color led using RGB coordinates as well as HSL coordinates.
 * The module performs all conversions form RGB to HSL automatically. It is then
 * self-evident to turn on a led with a given hue and to progressively vary its
 * saturation or lightness. If needed, you can find more information on the
 * difference between RGB and HSL in the section following this one.
 */
@interface YColorLed : YFunction
{
@protected

// Attributes (function value cache)
//--- (YColorLed attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    unsigned        _rgbColor;
    unsigned        _hslColor;
    struct {
        s32             target;
        s16             ms;
        u8              moving;
    }  _rgbMove;
    struct {
        s32             target;
        s16             ms;
        u8              moving;
    }  _hslMove;
    unsigned        _rgbColorAtPowerOn;
//--- (end of YColorLed attributes)
}
//--- (YColorLed declaration)
// Constructor is protected, use yFindColorLed factory function to instantiate
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

//--- (end of YColorLed declaration)
//--- (YColorLed accessors declaration)

/**
 * Continues the enumeration of RGB leds started using yFirstColorLed().
 * 
 * @return a pointer to a YColorLed object, corresponding to
 *         an RGB led currently online, or a null pointer
 *         if there are no more RGB leds to enumerate.
 */
-(YColorLed*) nextColorLed;
/**
 * Retrieves an RGB led for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the RGB led is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLed.isOnline() to test if the RGB led is
 * indeed online at a given time. In case of ambiguity when looking for
 * an RGB led by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the RGB led
 * 
 * @return a YColorLed object allowing you to drive the RGB led.
 */
+(YColorLed*) FindColorLed:(NSString*) func;
/**
 * Starts the enumeration of RGB leds currently accessible.
 * Use the method YColorLed.nextColorLed() to iterate on
 * next RGB leds.
 * 
 * @return a pointer to a YColorLed object, corresponding to
 *         the first RGB led currently online, or a null pointer
 *         if there are none.
 */
+(YColorLed*) FirstColorLed;

/**
 * Returns the logical name of the RGB led.
 * 
 * @return a string corresponding to the logical name of the RGB led
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the RGB led. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the RGB led
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the RGB led (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the RGB led (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the current RGB color of the led.
 * 
 * @return an integer corresponding to the current RGB color of the led
 * 
 * On failure, throws an exception or returns Y_RGBCOLOR_INVALID.
 */
-(unsigned) get_rgbColor;
-(unsigned) rgbColor;

/**
 * Changes the current color of the led, using a RGB color. Encoding is done as follows: 0xRRGGBB.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a RGB color
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColor:(unsigned) newval;
-(int)     setRgbColor:(unsigned) newval;

/**
 * Returns the current HSL color of the led.
 * 
 * @return an integer corresponding to the current HSL color of the led
 * 
 * On failure, throws an exception or returns Y_HSLCOLOR_INVALID.
 */
-(unsigned) get_hslColor;
-(unsigned) hslColor;

/**
 * Changes the current color of the led, using a color HSL. Encoding is done as follows: 0xHHSSLL.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a color HSL
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hslColor:(unsigned) newval;
-(int)     setHslColor:(unsigned) newval;

-(YRETCODE) get_rgbMove :(s32*)target :(s16*)ms :(u8*)moving;

-(YRETCODE)     set_rgbMove :(s32)target :(s16)ms :(u8)moving;

/**
 * Performs a smooth transition in the RGB color space between the current color and a target color.
 * 
 * @param rgb_target  : desired RGB color at the end of the transition
 * @param ms_duration : duration of the transition, in millisecond
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     rgbMove :(int)rgb_target :(int)ms_duration;

-(YRETCODE) get_hslMove :(s32*)target :(s16*)ms :(u8*)moving;

-(YRETCODE)     set_hslMove :(s32)target :(s16)ms :(u8)moving;

/**
 * Performs a smooth transition in the HSL color space between the current color and a target color.
 * 
 * @param hsl_target  : desired HSL color at the end of the transition
 * @param ms_duration : duration of the transition, in millisecond
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     hslMove :(int)hsl_target :(int)ms_duration;

/**
 * Returns the configured color to be displayed when the module is turned on.
 * 
 * @return an integer corresponding to the configured color to be displayed when the module is turned on
 * 
 * On failure, throws an exception or returns Y_RGBCOLORATPOWERON_INVALID.
 */
-(unsigned) get_rgbColorAtPowerOn;
-(unsigned) rgbColorAtPowerOn;

/**
 * Changes the color that the led will display by default when the module is turned on.
 * This color will be displayed as soon as the module is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * change should be kept.
 * 
 * @param newval : an integer corresponding to the color that the led will display by default when the
 * module is turned on
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColorAtPowerOn:(unsigned) newval;
-(int)     setRgbColorAtPowerOn:(unsigned) newval;


//--- (end of YColorLed accessors declaration)
@end

//--- (ColorLed functions declaration)

/**
 * Retrieves an RGB led for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the RGB led is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLed.isOnline() to test if the RGB led is
 * indeed online at a given time. In case of ambiguity when looking for
 * an RGB led by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the RGB led
 * 
 * @return a YColorLed object allowing you to drive the RGB led.
 */
YColorLed* yFindColorLed(NSString* func);
/**
 * Starts the enumeration of RGB leds currently accessible.
 * Use the method YColorLed.nextColorLed() to iterate on
 * next RGB leds.
 * 
 * @return a pointer to a YColorLed object, corresponding to
 *         the first RGB led currently online, or a null pointer
 *         if there are none.
 */
YColorLed* yFirstColorLed(void);

//--- (end of ColorLed functions declaration)
CF_EXTERN_C_END

