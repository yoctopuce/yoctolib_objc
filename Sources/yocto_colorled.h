/*********************************************************************
 *
 * $Id: yocto_colorled.h 14325 2014-01-11 01:42:47Z seb $
 *
 * Declares yFindColorLed(), the high-level API for ColorLed functions
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

@class YColorLed;

//--- (YColorLed globals)
typedef void (*YColorLedValueCallback)(YColorLed *func, NSString *functionValue);
#ifndef _STRUCT_MOVE
#define _STRUCT_MOVE
typedef struct _YMove {
    int             target;
    int             ms;
    int             moving;
} YMove;
#endif
#define Y_RGBMOVE_INVALID (YMove){YAPI_INVALID_INT,YAPI_INVALID_INT,YAPI_INVALID_UINT}
#define Y_HSLMOVE_INVALID (YMove){YAPI_INVALID_INT,YAPI_INVALID_INT,YAPI_INVALID_UINT}
#define Y_RGBCOLOR_INVALID              YAPI_INVALID_UINT
#define Y_HSLCOLOR_INVALID              YAPI_INVALID_UINT
#define Y_RGBCOLORATPOWERON_INVALID     YAPI_INVALID_UINT
//--- (end of YColorLed globals)

//--- (YColorLed class start)
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
//--- (end of YColorLed class start)
{
@protected
//--- (YColorLed attributes declaration)
    int             _rgbColor;
    int             _hslColor;
    YMove           _rgbMove;
    YMove           _hslMove;
    int             _rgbColorAtPowerOn;
    YColorLedValueCallback _valueCallbackColorLed;
//--- (end of YColorLed attributes declaration)
}
// Constructor is protected, use yFindColorLed factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YColorLed private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YColorLed private methods declaration)
//--- (YColorLed public methods declaration)
/**
 * Returns the current RGB color of the led.
 * 
 * @return an integer corresponding to the current RGB color of the led
 * 
 * On failure, throws an exception or returns Y_RGBCOLOR_INVALID.
 */
-(int)     get_rgbColor;


-(int) rgbColor;
/**
 * Changes the current color of the led, using a RGB color. Encoding is done as follows: 0xRRGGBB.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a RGB color
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColor:(int) newval;
-(int)     setRgbColor:(int) newval;

/**
 * Returns the current HSL color of the led.
 * 
 * @return an integer corresponding to the current HSL color of the led
 * 
 * On failure, throws an exception or returns Y_HSLCOLOR_INVALID.
 */
-(int)     get_hslColor;


-(int) hslColor;
/**
 * Changes the current color of the led, using a color HSL. Encoding is done as follows: 0xHHSSLL.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a color HSL
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hslColor:(int) newval;
-(int)     setHslColor:(int) newval;

-(YMove)     get_rgbMove;


-(YMove) rgbMove;
-(int)     set_rgbMove:(YMove) newval;
-(int)     setRgbMove:(YMove) newval;

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
-(int)     rgbMove:(int)rgb_target :(int)ms_duration;

-(YMove)     get_hslMove;


-(YMove) hslMove;
-(int)     set_hslMove:(YMove) newval;
-(int)     setHslMove:(YMove) newval;

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
-(int)     hslMove:(int)hsl_target :(int)ms_duration;

/**
 * Returns the configured color to be displayed when the module is turned on.
 * 
 * @return an integer corresponding to the configured color to be displayed when the module is turned on
 * 
 * On failure, throws an exception or returns Y_RGBCOLORATPOWERON_INVALID.
 */
-(int)     get_rgbColorAtPowerOn;


-(int) rgbColorAtPowerOn;
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
-(int)     set_rgbColorAtPowerOn:(int) newval;
-(int)     setRgbColorAtPowerOn:(int) newval;

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
+(YColorLed*)     FindColorLed:(NSString*)func;

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
-(int)     registerValueCallback:(YColorLedValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of RGB leds started using yFirstColorLed().
 * 
 * @return a pointer to a YColorLed object, corresponding to
 *         an RGB led currently online, or a null pointer
 *         if there are no more RGB leds to enumerate.
 */
-(YColorLed*) nextColorLed;
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
//--- (end of YColorLed public methods declaration)

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

