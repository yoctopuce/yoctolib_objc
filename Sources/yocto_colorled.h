/*********************************************************************
 *
 *  $Id: yocto_colorled.h 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Declares yFindColorLed(), the high-level API for ColorLed functions
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
#define Y_BLINKSEQSIZE_INVALID          YAPI_INVALID_UINT
#define Y_BLINKSEQMAXSIZE_INVALID       YAPI_INVALID_UINT
#define Y_BLINKSEQSIGNATURE_INVALID     YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YColorLed globals)

//--- (YColorLed class start)
/**
 * YColorLed Class: RGB LED control interface, available for instance in the Yocto-Color-V2, the
 * Yocto-MaxiBuzzer or the Yocto-PowerColor
 *
 * The ColorLed class allows you to drive a color LED.
 * The color can be specified using RGB coordinates as well as HSL coordinates.
 * The module performs all conversions form RGB to HSL automatically. It is then
 * self-evident to turn on a LED with a given hue and to progressively vary its
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
    int             _blinkSeqSize;
    int             _blinkSeqMaxSize;
    int             _blinkSeqSignature;
    NSString*       _command;
    YColorLedValueCallback _valueCallbackColorLed;
//--- (end of YColorLed attributes declaration)
}
// Constructor is protected, use yFindColorLed factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YColorLed private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YColorLed private methods declaration)
//--- (YColorLed yapiwrapper declaration)
//--- (end of YColorLed yapiwrapper declaration)
//--- (YColorLed public methods declaration)
/**
 * Returns the current RGB color of the LED.
 *
 * @return an integer corresponding to the current RGB color of the LED
 *
 * On failure, throws an exception or returns YColorLed.RGBCOLOR_INVALID.
 */
-(int)     get_rgbColor;


-(int) rgbColor;
/**
 * Changes the current color of the LED, using an RGB color. Encoding is done as follows: 0xRRGGBB.
 *
 * @param newval : an integer corresponding to the current color of the LED, using an RGB color
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColor:(int) newval;
-(int)     setRgbColor:(int) newval;

/**
 * Returns the current HSL color of the LED.
 *
 * @return an integer corresponding to the current HSL color of the LED
 *
 * On failure, throws an exception or returns YColorLed.HSLCOLOR_INVALID.
 */
-(int)     get_hslColor;


-(int) hslColor;
/**
 * Changes the current color of the LED, using a specific HSL color. Encoding is done as follows: 0xHHSSLL.
 *
 * @param newval : an integer corresponding to the current color of the LED, using a specific HSL color
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * @return YAPI.SUCCESS if the call succeeds.
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     hslMove:(int)hsl_target :(int)ms_duration;

/**
 * Returns the configured color to be displayed when the module is turned on.
 *
 * @return an integer corresponding to the configured color to be displayed when the module is turned on
 *
 * On failure, throws an exception or returns YColorLed.RGBCOLORATPOWERON_INVALID.
 */
-(int)     get_rgbColorAtPowerOn;


-(int) rgbColorAtPowerOn;
/**
 * Changes the color that the LED displays by default when the module is turned on.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the color that the LED displays by default when the
 * module is turned on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColorAtPowerOn:(int) newval;
-(int)     setRgbColorAtPowerOn:(int) newval;

/**
 * Returns the current length of the blinking sequence.
 *
 * @return an integer corresponding to the current length of the blinking sequence
 *
 * On failure, throws an exception or returns YColorLed.BLINKSEQSIZE_INVALID.
 */
-(int)     get_blinkSeqSize;


-(int) blinkSeqSize;
/**
 * Returns the maximum length of the blinking sequence.
 *
 * @return an integer corresponding to the maximum length of the blinking sequence
 *
 * On failure, throws an exception or returns YColorLed.BLINKSEQMAXSIZE_INVALID.
 */
-(int)     get_blinkSeqMaxSize;


-(int) blinkSeqMaxSize;
/**
 * Returns the blinking sequence signature. Since blinking
 * sequences cannot be read from the device, this can be used
 * to detect if a specific blinking sequence is already
 * programmed.
 *
 * @return an integer corresponding to the blinking sequence signature
 *
 * On failure, throws an exception or returns YColorLed.BLINKSEQSIGNATURE_INVALID.
 */
-(int)     get_blinkSeqSignature;


-(int) blinkSeqSignature;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves an RGB LED for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RGB LED is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLed.isOnline() to test if the RGB LED is
 * indeed online at a given time. In case of ambiguity when looking for
 * an RGB LED by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RGB LED, for instance
 *         YRGBLED2.colorLed1.
 *
 * @return a YColorLed object allowing you to drive the RGB LED.
 */
+(YColorLed*)     FindColorLed:(NSString*)func;

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
-(int)     registerValueCallback:(YColorLedValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)command;

/**
 * Add a new transition to the blinking sequence, the move will
 * be performed in the HSL space.
 *
 * @param HSLcolor : desired HSL color when the transition is completed
 * @param msDelay : duration of the color transition, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addHslMoveToBlinkSeq:(int)HSLcolor :(int)msDelay;

/**
 * Adds a new transition to the blinking sequence, the move is
 * performed in the RGB space.
 *
 * @param RGBcolor : desired RGB color when the transition is completed
 * @param msDelay : duration of the color transition, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addRgbMoveToBlinkSeq:(int)RGBcolor :(int)msDelay;

/**
 * Starts the preprogrammed blinking sequence. The sequence is
 * run in a loop until it is stopped by stopBlinkSeq or an explicit
 * change.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     startBlinkSeq;

/**
 * Stops the preprogrammed blinking sequence.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     stopBlinkSeq;

/**
 * Resets the preprogrammed blinking sequence.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     resetBlinkSeq;


/**
 * Continues the enumeration of RGB LEDs started using yFirstColorLed().
 * Caution: You can't make any assumption about the returned RGB LEDs order.
 * If you want to find a specific an RGB LED, use ColorLed.findColorLed()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YColorLed object, corresponding to
 *         an RGB LED currently online, or a nil pointer
 *         if there are no more RGB LEDs to enumerate.
 */
-(nullable YColorLed*) nextColorLed
NS_SWIFT_NAME(nextColorLed());
/**
 * Starts the enumeration of RGB LEDs currently accessible.
 * Use the method YColorLed.nextColorLed() to iterate on
 * next RGB LEDs.
 *
 * @return a pointer to a YColorLed object, corresponding to
 *         the first RGB LED currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YColorLed*) FirstColorLed
NS_SWIFT_NAME(FirstColorLed());
//--- (end of YColorLed public methods declaration)

@end

//--- (YColorLed functions declaration)
/**
 * Retrieves an RGB LED for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RGB LED is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLed.isOnline() to test if the RGB LED is
 * indeed online at a given time. In case of ambiguity when looking for
 * an RGB LED by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RGB LED, for instance
 *         YRGBLED2.colorLed1.
 *
 * @return a YColorLed object allowing you to drive the RGB LED.
 */
YColorLed* yFindColorLed(NSString* func);
/**
 * Starts the enumeration of RGB LEDs currently accessible.
 * Use the method YColorLed.nextColorLed() to iterate on
 * next RGB LEDs.
 *
 * @return a pointer to a YColorLed object, corresponding to
 *         the first RGB LED currently online, or a nil pointer
 *         if there are none.
 */
YColorLed* yFirstColorLed(void);

//--- (end of YColorLed functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

