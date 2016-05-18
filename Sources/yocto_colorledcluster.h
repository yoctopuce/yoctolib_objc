/*********************************************************************
 *
 * $Id: yocto_colorledcluster.h 24475 2016-05-12 14:03:35Z mvuilleu $
 *
 * Declares yFindColorLedCluster(), the high-level API for ColorLedCluster functions
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

@class YColorLedCluster;

//--- (YColorLedCluster globals)
typedef void (*YColorLedClusterValueCallback)(YColorLedCluster *func, NSString *functionValue);
#define Y_ACTIVELEDCOUNT_INVALID        YAPI_INVALID_UINT
#define Y_MAXLEDCOUNT_INVALID           YAPI_INVALID_UINT
#define Y_BLINKSEQMAXCOUNT_INVALID      YAPI_INVALID_UINT
#define Y_BLINKSEQMAXSIZE_INVALID       YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YColorLedCluster globals)

//--- (YColorLedCluster class start)
/**
 * YColorLedCluster Class: ColorLedCluster function interface
 *
 * The Yoctopuce application programming interface
 * allows you to drive a color LED cluster  using RGB coordinates as well as HSL coordinates.
 * The module performs all conversions form RGB to HSL automatically. It is then
 * self-evident to turn on a LED with a given hue and to progressively vary its
 * saturation or lightness. If needed, you can find more information on the
 * difference between RGB and HSL in the section following this one.
 */
@interface YColorLedCluster : YFunction
//--- (end of YColorLedCluster class start)
{
@protected
//--- (YColorLedCluster attributes declaration)
    int             _activeLedCount;
    int             _maxLedCount;
    int             _blinkSeqMaxCount;
    int             _blinkSeqMaxSize;
    NSString*       _command;
    YColorLedClusterValueCallback _valueCallbackColorLedCluster;
//--- (end of YColorLedCluster attributes declaration)
}
// Constructor is protected, use yFindColorLedCluster factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YColorLedCluster private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YColorLedCluster private methods declaration)
//--- (YColorLedCluster public methods declaration)
/**
 * Returns the number of LEDs currently handled by the device.
 *
 * @return an integer corresponding to the number of LEDs currently handled by the device
 *
 * On failure, throws an exception or returns Y_ACTIVELEDCOUNT_INVALID.
 */
-(int)     get_activeLedCount;


-(int) activeLedCount;
/**
 * Changes the number of LEDs currently handled by the device.
 *
 * @param newval : an integer corresponding to the number of LEDs currently handled by the device
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_activeLedCount:(int) newval;
-(int)     setActiveLedCount:(int) newval;

/**
 * Returns the maximum number of LEDs that the device can handle.
 *
 * @return an integer corresponding to the maximum number of LEDs that the device can handle
 *
 * On failure, throws an exception or returns Y_MAXLEDCOUNT_INVALID.
 */
-(int)     get_maxLedCount;


-(int) maxLedCount;
/**
 * Returns the maximum number of sequences that the device can handle
 *
 * @return an integer corresponding to the maximum number of sequences that the device can handle
 *
 * On failure, throws an exception or returns Y_BLINKSEQMAXCOUNT_INVALID.
 */
-(int)     get_blinkSeqMaxCount;


-(int) blinkSeqMaxCount;
/**
 * Returns the maximum length of sequences.
 *
 * @return an integer corresponding to the maximum length of sequences
 *
 * On failure, throws an exception or returns Y_BLINKSEQMAXSIZE_INVALID.
 */
-(int)     get_blinkSeqMaxSize;


-(int) blinkSeqMaxSize;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a RGB LED cluster for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RGB LED cluster is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLedCluster.isOnline() to test if the RGB LED cluster is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RGB LED cluster by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the RGB LED cluster
 *
 * @return a YColorLedCluster object allowing you to drive the RGB LED cluster.
 */
+(YColorLedCluster*)     FindColorLedCluster:(NSString*)func;

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
-(int)     registerValueCallback:(YColorLedClusterValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)command;

/**
 * Changes the current color of consecutve LEDs in the cluster , using a RGB color. Encoding is done
 * as follows: 0xRRGGBB.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColor:(int)ledIndex :(int)count :(int)rgbValue;

/**
 * Changes the  color at device startup of consecutve LEDs in the cluster , using a RGB color.
 * Encoding is done as follows: 0xRRGGBB.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbColorAtPowerOn:(int)ledIndex :(int)count :(int)rgbValue;

/**
 * Changes the current color of consecutive LEDs in the cluster, using a HSL color. Encoding is done
 * as follows: 0xHHSSLL.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param hslValue :  new color.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hslColor:(int)ledIndex :(int)count :(int)hslValue;

/**
 * Allows you to modify the current color of a group of adjacent LEDs to another color, in a seamless and
 * autonomous manner. The transition is performed in the RGB space.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color (0xRRGGBB).
 * @param delay    :  transition duration in ms
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     rgb_move:(int)ledIndex :(int)count :(int)rgbValue :(int)delay;

/**
 * Allows you to modify the current color of a group of adjacent LEDs  to another color, in a seamless and
 * autonomous manner. The transition is performed in the HSL space. In HSL, hue is a circular
 * value (0..360°). There are always two paths to perform the transition: by increasing
 * or by decreasing the hue. The module selects the shortest transition.
 * If the difference is exactly 180°, the module selects the transition which increases
 * the hue.
 *
 * @param ledIndex :  index of the fisrt affected LED.
 * @param count    :  affected LED count.
 * @param hslValue :  new color (0xHHSSLL).
 * @param delay    :  transition duration in ms
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     hsl_move:(int)ledIndex :(int)count :(int)hslValue :(int)delay;

/**
 * Adds an RGB transition to a sequence. A sequence is a transition list, which can
 * be executed in loop by a group of LEDs.  Sequences are persistent and are saved
 * in the device flash memory as soon as the module saveToFlash() method is called.
 *
 * @param seqIndex :  sequence index.
 * @param rgbValue :  target color (0xRRGGBB)
 * @param delay    :  transition duration in ms
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addRgbMoveToBlinkSeq:(int)seqIndex :(int)rgbValue :(int)delay;

/**
 * Adds an HSL transition to a sequence. A sequence is a transition list, which can
 * be executed in loop by an group of LEDs.  Sequences are persistant and are saved
 * in the device flash memory as soon as the module saveToFlash() method is called.
 *
 * @param seqIndex : sequence index.
 * @param hslValue : target color (0xHHSSLL)
 * @param delay    : transition duration in ms
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addHslMoveToBlinkSeq:(int)seqIndex :(int)hslValue :(int)delay;

/**
 * Adds a mirror ending to a sequence. When the sequence will reach the end of the last
 * transition, its running speed will automatically be reversed so that the sequence plays
 * in the reverse direction, like in a mirror. After the first transition of the sequence
 * is played at the end of the reverse execution, the sequence starts again in
 * the initial direction.
 *
 * @param seqIndex : sequence index.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addMirrorToBlinkSeq:(int)seqIndex;

/**
 * Links adjacent LEDs to a specific sequence. These LEDs start to execute
 * the sequence as soon as  startBlinkSeq is called. It is possible to add an offset
 * in the execution: that way we  can have several groups of LED executing the same
 * sequence, with a  temporal offset. A LED cannot be linked to more than one sequence.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param offset   :  execution offset in ms.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     linkLedToBlinkSeq:(int)ledIndex :(int)count :(int)seqIndex :(int)offset;

/**
 * Links adjacent LEDs to a specific sequence at device poweron. Don't forget to configure
 * the sequence auto start flag as well and call saveLedsState. It is possible to add an offset
 * in the execution: that way we  can have several groups of LEDs executing the same
 * sequence, with a  temporal offset. A LED cannot be linked to more than one sequence.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param offset   :  execution offset in ms.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     linkLedToBlinkSeqAtPowerOn:(int)ledIndex :(int)count :(int)seqIndex :(int)offset;

/**
 * Links adjacent LEDs to a specific sequence. These LED start to execute
 * the sequence as soon as  startBlinkSeq is called. This function automatically
 * introduces a shift between LEDs so that the specified number of sequence periods
 * appears on the group of LEDs (wave effect).
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param periods  :  number of periods to show on LEDs.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     linkLedToPeriodicBlinkSeq:(int)ledIndex :(int)count :(int)seqIndex :(int)periods;

/**
 * Unlinks adjacent LEDs from a  sequence.
 *
 * @param ledIndex  :  index of the first affected LED.
 * @param count     :  affected LED count.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     unlinkLedFromBlinkSeq:(int)ledIndex :(int)count;

/**
 * Starts a sequence execution: every LED linked to that sequence starts to
 * run it in a loop.
 *
 * @param seqIndex :  index of the sequence to start.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     startBlinkSeq:(int)seqIndex;

/**
 * Stops a sequence execution. If started again, the execution
 * restarts from the beginning.
 *
 * @param seqIndex :  index of the sequence to stop.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     stopBlinkSeq:(int)seqIndex;

/**
 * Stops a sequence execution and resets its contents. Leds linked to this
 * sequence are not automatically updated anymore.
 *
 * @param seqIndex :  index of the sequence to reset
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     resetBlinkSeq:(int)seqIndex;

/**
 * Configures a sequence to make it start automatically at device
 * startup. Don't forget to call  saveLedsState() to make sure the
 * modification is saved in the device flash memory.
 *
 * @param seqIndex :  index of the sequence to reset
 * @param autostart :  boolean telling if the sequence must start automatically or not.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_blinkSeqAutoStart:(int)seqIndex :(bool)autostart;

/**
 * Changes the execution speed of a sequence. The natural execution speed is 1000 per
 * thousand. If you configure a slower speed, you can play the sequence in slow-motion.
 * If you set a negative speed, you can play the sequence in reverse direction.
 *
 * @param seqIndex :  index of the sequence to start.
 * @param speed :     sequence running speed (-1000...1000).
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_blinkSeqSpeed:(int)seqIndex :(int)speed;

/**
 * Saves the cluster power-on configuration, this includes
 * LED start-up colors, sequence steps and sequence auto-start flags.
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     saveLedsState;

/**
 * Sends a binary buffer to the LED RGB buffer, as is.
 * First three bytes are RGB components for first LED, the
 * next three bytes for the second LED, etc.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbBuffer:(NSData*)buff;

/**
 * Sends 24bit RGB colors (provided as a list of integers) to the LED RGB buffer, as is.
 * The first number represents the RGB value of the first LED, the second number represents
 * the RGB value of the second LED, etc.
 *
 * @param rgbList : a list of 24bit RGB codes, in the form 0xRRGGBB
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rgbArray:(NSMutableArray*)rgbList;

/**
 * Sets up a smooth RGB color transition to the specified pixel-by-pixel list of RGB
 * color codes. The first color code represents the target RGB value of the first LED,
 * the second color code represents the target value of the second LED, etc.
 *
 * @param rgbList : a list of target 24bit RGB codes, in the form 0xRRGGBB
 * @param delay   : transition duration in ms
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     rgbArray_move:(NSMutableArray*)rgbList :(int)delay;

/**
 * Sends a binary buffer to the LED HSL buffer, as is.
 * First three bytes are HSL components for first LED, the
 * next three bytes for the second LED, etc.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hslBuffer:(NSData*)buff;

/**
 * Sends 24bit HSL colors (provided as a list of integers) to the LED HSL buffer, as is.
 * The first number represents the HSL value of the first LED, the second number represents
 * the HSL value of the second LED, etc.
 *
 * @param hslList : a list of 24bit HSL codes, in the form 0xHHSSLL
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     set_hslArray:(NSMutableArray*)hslList;

/**
 * Sets up a smooth HSL color transition to the specified pixel-by-pixel list of HSL
 * color codes. The first color code represents the target HSL value of the first LED,
 * the second color code represents the target value of the second LED, etc.
 *
 * @param hslList : a list of target 24bit HSL codes, in the form 0xHHSSLL
 * @param delay   : transition duration in ms
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     hslArray_move:(NSMutableArray*)hslList :(int)delay;

/**
 * Returns a binary buffer with content from the LED RGB buffer, as is.
 * First three bytes are RGB components for the first LED in the interval,
 * the next three bytes for the second LED in the interval, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a binary buffer with RGB components of selected LEDs.
 *         On failure, throws an exception or returns an empty binary buffer.
 */
-(NSMutableData*)     get_rgbColorBuffer:(int)ledIndex :(int)count;

/**
 * Returns a list on 24bit RGB color values with the current colors displayed on
 * the RGB leds. The first number represents the RGB value of the first LED,
 * the second number represents the RGB value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of 24bit color codes with RGB components of selected LEDs, as 0xRRGGBB.
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_rgbColorArray:(int)ledIndex :(int)count;

/**
 * Returns a list on 24bit RGB color values with the RGB LEDs startup colors.
 * The first number represents the startup RGB value of the first LED,
 * the second number represents the RGB value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED  which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of 24bit color codes with RGB components of selected LEDs, as 0xRRGGBB.
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_rgbColorArrayAtPowerOn:(int)ledIndex :(int)count;

/**
 * Returns a list on sequence index for each RGB LED. The first number represents the
 * sequence index for the the first LED, the second number represents the sequence
 * index for the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of integers with sequence index
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_linkedSeqArray:(int)ledIndex :(int)count;

/**
 * Returns a list on 32 bit signatures for specified blinking sequences.
 * Since blinking sequences cannot be read from the device, this can be used
 * to detect if a specific blinking sequence is already programmed.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of 32 bit integer signatures
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_blinkSeqSignatures:(int)seqIndex :(int)count;

/**
 * Returns a list of integers with the current speed for specified blinking sequences.
 *
 * @param seqIndex : index of the first sequence speed which should be returned
 * @param count    : number of sequence speeds which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_blinkSeqStateSpeed:(int)seqIndex :(int)count;

/**
 * Returns a list of integers with the "auto-start at power on" flag state for specified blinking sequences.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_blinkSeqStateAtPowerOn:(int)seqIndex :(int)count;

/**
 * Returns a list of integers with the started state for specified blinking sequences.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *         On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_blinkSeqState:(int)seqIndex :(int)count;


/**
 * Continues the enumeration of RGB LED clusters started using yFirstColorLedCluster().
 *
 * @return a pointer to a YColorLedCluster object, corresponding to
 *         a RGB LED cluster currently online, or a null pointer
 *         if there are no more RGB LED clusters to enumerate.
 */
-(YColorLedCluster*) nextColorLedCluster;
/**
 * Starts the enumeration of RGB LED clusters currently accessible.
 * Use the method YColorLedCluster.nextColorLedCluster() to iterate on
 * next RGB LED clusters.
 *
 * @return a pointer to a YColorLedCluster object, corresponding to
 *         the first RGB LED cluster currently online, or a null pointer
 *         if there are none.
 */
+(YColorLedCluster*) FirstColorLedCluster;
//--- (end of YColorLedCluster public methods declaration)

@end

//--- (ColorLedCluster functions declaration)
/**
 * Retrieves a RGB LED cluster for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RGB LED cluster is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLedCluster.isOnline() to test if the RGB LED cluster is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RGB LED cluster by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the RGB LED cluster
 *
 * @return a YColorLedCluster object allowing you to drive the RGB LED cluster.
 */
YColorLedCluster* yFindColorLedCluster(NSString* func);
/**
 * Starts the enumeration of RGB LED clusters currently accessible.
 * Use the method YColorLedCluster.nextColorLedCluster() to iterate on
 * next RGB LED clusters.
 *
 * @return a pointer to a YColorLedCluster object, corresponding to
 *         the first RGB LED cluster currently online, or a null pointer
 *         if there are none.
 */
YColorLedCluster* yFirstColorLedCluster(void);

//--- (end of ColorLedCluster functions declaration)
CF_EXTERN_C_END

