/*********************************************************************
 *
 * $Id: yocto_display.h 43619 2021-01-29 09:14:45Z mvuilleu $
 *
 * Declares yFindDisplay(), the high-level API for Display functions
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
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
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

#import "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN
@class YDisplay;

//--- (generated code: YDisplayLayer globals)
#ifndef _Y_Y_ALIGN
#define _Y_Y_ALIGN
typedef enum {
    Y_ALIGN_TOP_LEFT = 0 ,
    Y_ALIGN_CENTER_LEFT = 1 ,
    Y_ALIGN_BASELINE_LEFT = 2 ,
    Y_ALIGN_BOTTOM_LEFT = 3 ,
    Y_ALIGN_TOP_CENTER = 4 ,
    Y_ALIGN_CENTER = 5 ,
    Y_ALIGN_BASELINE_CENTER = 6 ,
    Y_ALIGN_BOTTOM_CENTER = 7 ,
    Y_ALIGN_TOP_DECIMAL = 8 ,
    Y_ALIGN_CENTER_DECIMAL = 9 ,
    Y_ALIGN_BASELINE_DECIMAL = 10 ,
    Y_ALIGN_BOTTOM_DECIMAL = 11 ,
    Y_ALIGN_TOP_RIGHT = 12 ,
    Y_ALIGN_CENTER_RIGHT = 13 ,
    Y_ALIGN_BASELINE_RIGHT = 14 ,
    Y_ALIGN_BOTTOM_RIGHT = 15
} Y_ALIGN;

#endif
//--- (end of generated code: YDisplayLayer globals)

//--- (generated code: YDisplay globals)
typedef void (*YDisplayValueCallback)(YDisplay *func, NSString *functionValue);
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
#ifndef _Y_ORIENTATION_ENUM
#define _Y_ORIENTATION_ENUM
typedef enum {
    Y_ORIENTATION_LEFT = 0,
    Y_ORIENTATION_UP = 1,
    Y_ORIENTATION_RIGHT = 2,
    Y_ORIENTATION_DOWN = 3,
    Y_ORIENTATION_INVALID = -1,
} Y_ORIENTATION_enum;
#endif
#ifndef _Y_DISPLAYTYPE_ENUM
#define _Y_DISPLAYTYPE_ENUM
typedef enum {
    Y_DISPLAYTYPE_MONO = 0,
    Y_DISPLAYTYPE_GRAY = 1,
    Y_DISPLAYTYPE_RGB = 2,
    Y_DISPLAYTYPE_INVALID = -1,
} Y_DISPLAYTYPE_enum;
#endif
#define Y_STARTUPSEQ_INVALID            YAPI_INVALID_STRING
#define Y_BRIGHTNESS_INVALID            YAPI_INVALID_UINT
#define Y_DISPLAYWIDTH_INVALID          YAPI_INVALID_UINT
#define Y_DISPLAYHEIGHT_INVALID         YAPI_INVALID_UINT
#define Y_LAYERWIDTH_INVALID            YAPI_INVALID_UINT
#define Y_LAYERHEIGHT_INVALID           YAPI_INVALID_UINT
#define Y_LAYERCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of generated code: YDisplay globals)

@class YDisplay;

//--- (generated code: YDisplayLayer class start)
/**
 * YDisplayLayer Class: Interface for drawing into display layers, obtained by calling display.get_displayLayer.
 *
 * Each DisplayLayer represents an image layer containing objects
 * to display (bitmaps, text, etc.). The content is displayed only when
 * the layer is active on the screen (and not masked by other
 * overlapping layers).
 */
@interface YDisplayLayer : NSObject
//--- (end of generated code: YDisplayLayer class start)
{
@protected
    YDisplay *_display;
    int _id;
    NSMutableString *_cmdbuff;
    bool   _hidden;
//--- (generated code: YDisplayLayer attributes declaration)
//--- (end of generated code: YDisplayLayer attributes declaration)

}

-(id)    initWithDisplay:(YDisplay*)display andLayerID:(int)layerid;
-(id)    initWith:(YDisplay*)display :(int)layerid;


// internal function to send a command for this layer
-(int)   command_push:(NSString*)cmd;
-(int)   command_flush:(NSString*)cmd;
-(int)   flush_now;

//--- (generated code: YDisplayLayer private methods declaration)
//--- (end of generated code: YDisplayLayer private methods declaration)
//--- (generated code: YDisplayLayer public methods declaration)
/**
 * Reverts the layer to its initial state (fully transparent, default settings).
 * Reinitializes the drawing pointer to the upper left position,
 * and selects the most visible pen color. If you only want to erase the layer
 * content, use the method clear() instead.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

/**
 * Erases the whole content of the layer (makes it fully transparent).
 * This method does not change any other attribute of the layer.
 * To reinitialize the layer attributes to defaults settings, use the method
 * reset() instead.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     clear;

/**
 * Selects the pen color for all subsequent drawing functions,
 * including text drawing. The pen color is provided as an RGB value.
 * For grayscale or monochrome displays, the value is
 * automatically converted to the proper range.
 *
 * @param color : the desired pen color, as a 24-bit RGB value
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     selectColorPen:(int)color;

/**
 * Selects the pen gray level for all subsequent drawing functions,
 * including text drawing. The gray level is provided as a number between
 * 0 (black) and 255 (white, or whichever the lightest color is).
 * For monochrome displays (without gray levels), any value
 * lower than 128 is rendered as black, and any value equal
 * or above to 128 is non-black.
 *
 * @param graylevel : the desired gray level, from 0 to 255
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     selectGrayPen:(int)graylevel;

/**
 * Selects an eraser instead of a pen for all subsequent drawing functions,
 * except for bitmap copy functions. Any point drawn using the eraser
 * becomes transparent (as when the layer is empty), showing the other
 * layers beneath it.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     selectEraser;

/**
 * Enables or disables anti-aliasing for drawing oblique lines and circles.
 * Anti-aliasing provides a smoother aspect when looked from far enough,
 * but it can add fuzziness when the display is looked from very close.
 * At the end of the day, it is your personal choice.
 * Anti-aliasing is enabled by default on grayscale and color displays,
 * but you can disable it if you prefer. This setting has no effect
 * on monochrome displays.
 *
 * @param mode : true to enable anti-aliasing, false to
 *         disable it.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setAntialiasingMode:(bool)mode;

/**
 * Draws a single pixel at the specified position.
 *
 * @param x : the distance from left of layer, in pixels
 * @param y : the distance from top of layer, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawPixel:(int)x :(int)y;

/**
 * Draws an empty rectangle at a specified position.
 *
 * @param x1 : the distance from left of layer to the left border of the rectangle, in pixels
 * @param y1 : the distance from top of layer to the top border of the rectangle, in pixels
 * @param x2 : the distance from left of layer to the right border of the rectangle, in pixels
 * @param y2 : the distance from top of layer to the bottom border of the rectangle, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawRect:(int)x1 :(int)y1 :(int)x2 :(int)y2;

/**
 * Draws a filled rectangular bar at a specified position.
 *
 * @param x1 : the distance from left of layer to the left border of the rectangle, in pixels
 * @param y1 : the distance from top of layer to the top border of the rectangle, in pixels
 * @param x2 : the distance from left of layer to the right border of the rectangle, in pixels
 * @param y2 : the distance from top of layer to the bottom border of the rectangle, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawBar:(int)x1 :(int)y1 :(int)x2 :(int)y2;

/**
 * Draws an empty circle at a specified position.
 *
 * @param x : the distance from left of layer to the center of the circle, in pixels
 * @param y : the distance from top of layer to the center of the circle, in pixels
 * @param r : the radius of the circle, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawCircle:(int)x :(int)y :(int)r;

/**
 * Draws a filled disc at a given position.
 *
 * @param x : the distance from left of layer to the center of the disc, in pixels
 * @param y : the distance from top of layer to the center of the disc, in pixels
 * @param r : the radius of the disc, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawDisc:(int)x :(int)y :(int)r;

/**
 * Selects a font to use for the next text drawing functions, by providing the name of the
 * font file. You can use a built-in font as well as a font file that you have previously
 * uploaded to the device built-in memory. If you experience problems selecting a font
 * file, check the device logs for any error message such as missing font file or bad font
 * file format.
 *
 * @param fontname : the font file name, embedded fonts are 8x8.yfm, Small.yfm, Medium.yfm, Large.yfm
 * (not available on Yocto-MiniDisplay).
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     selectFont:(NSString*)fontname;

/**
 * Draws a text string at the specified position. The point of the text that is aligned
 * to the specified pixel position is called the anchor point, and can be chosen among
 * several options. Text is rendered from left to right, without implicit wrapping.
 *
 * @param x : the distance from left of layer to the text anchor point, in pixels
 * @param y : the distance from top of layer to the text anchor point, in pixels
 * @param anchor : the text anchor point, chosen among the YDisplayLayer.ALIGN enumeration:
 *         YDisplayLayer.ALIGN_TOP_LEFT,         YDisplayLayer.ALIGN_CENTER_LEFT,
 *         YDisplayLayer.ALIGN_BASELINE_LEFT,    YDisplayLayer.ALIGN_BOTTOM_LEFT,
 *         YDisplayLayer.ALIGN_TOP_CENTER,       YDisplayLayer.ALIGN_CENTER,
 *         YDisplayLayer.ALIGN_BASELINE_CENTER,  YDisplayLayer.ALIGN_BOTTOM_CENTER,
 *         YDisplayLayer.ALIGN_TOP_DECIMAL,      YDisplayLayer.ALIGN_CENTER_DECIMAL,
 *         YDisplayLayer.ALIGN_BASELINE_DECIMAL, YDisplayLayer.ALIGN_BOTTOM_DECIMAL,
 *         YDisplayLayer.ALIGN_TOP_RIGHT,        YDisplayLayer.ALIGN_CENTER_RIGHT,
 *         YDisplayLayer.ALIGN_BASELINE_RIGHT,   YDisplayLayer.ALIGN_BOTTOM_RIGHT.
 * @param text : the text string to draw
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawText:(int)x :(int)y :(Y_ALIGN)anchor :(NSString*)text;

/**
 * Draws a GIF image at the specified position. The GIF image must have been previously
 * uploaded to the device built-in memory. If you experience problems using an image
 * file, check the device logs for any error message such as missing image file or bad
 * image file format.
 *
 * @param x : the distance from left of layer to the left of the image, in pixels
 * @param y : the distance from top of layer to the top of the image, in pixels
 * @param imagename : the GIF file name
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawImage:(int)x :(int)y :(NSString*)imagename;

/**
 * Draws a bitmap at the specified position. The bitmap is provided as a binary object,
 * where each pixel maps to a bit, from left to right and from top to bottom.
 * The most significant bit of each byte maps to the leftmost pixel, and the least
 * significant bit maps to the rightmost pixel. Bits set to 1 are drawn using the
 * layer selected pen color. Bits set to 0 are drawn using the specified background
 * gray level, unless -1 is specified, in which case they are not drawn at all
 * (as if transparent).
 *
 * @param x : the distance from left of layer to the left of the bitmap, in pixels
 * @param y : the distance from top of layer to the top of the bitmap, in pixels
 * @param w : the width of the bitmap, in pixels
 * @param bitmap : a binary object
 * @param bgcol : the background gray level to use for zero bits (0 = black,
 *         255 = white), or -1 to leave the pixels unchanged
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     drawBitmap:(int)x :(int)y :(int)w :(NSData*)bitmap :(int)bgcol;

/**
 * Moves the drawing pointer of this layer to the specified position.
 *
 * @param x : the distance from left of layer, in pixels
 * @param y : the distance from top of layer, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     moveTo:(int)x :(int)y;

/**
 * Draws a line from current drawing pointer position to the specified position.
 * The specified destination pixel is included in the line. The pointer position
 * is then moved to the end point of the line.
 *
 * @param x : the distance from left of layer to the end point of the line, in pixels
 * @param y : the distance from top of layer to the end point of the line, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     lineTo:(int)x :(int)y;

/**
 * Outputs a message in the console area, and advances the console pointer accordingly.
 * The console pointer position is automatically moved to the beginning
 * of the next line when a newline character is met, or when the right margin
 * is hit. When the new text to display extends below the lower margin, the
 * console area is automatically scrolled up.
 *
 * @param text : the message to display
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     consoleOut:(NSString*)text;

/**
 * Sets up display margins for the consoleOut function.
 *
 * @param x1 : the distance from left of layer to the left margin, in pixels
 * @param y1 : the distance from top of layer to the top margin, in pixels
 * @param x2 : the distance from left of layer to the right margin, in pixels
 * @param y2 : the distance from top of layer to the bottom margin, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setConsoleMargins:(int)x1 :(int)y1 :(int)x2 :(int)y2;

/**
 * Sets up the background color used by the clearConsole function and by
 * the console scrolling feature.
 *
 * @param bgcol : the background gray level to use when scrolling (0 = black,
 *         255 = white), or -1 for transparent
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setConsoleBackground:(int)bgcol;

/**
 * Sets up the wrapping behavior used by the consoleOut function.
 *
 * @param wordwrap : true to wrap only between words,
 *         false to wrap on the last column anyway.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setConsoleWordWrap:(bool)wordwrap;

/**
 * Blanks the console area within console margins, and resets the console pointer
 * to the upper left corner of the console.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     clearConsole;

/**
 * Sets the position of the layer relative to the display upper left corner.
 * When smooth scrolling is used, the display offset of the layer is
 * automatically updated during the next milliseconds to animate the move of the layer.
 *
 * @param x : the distance from left of display to the upper left corner of the layer
 * @param y : the distance from top of display to the upper left corner of the layer
 * @param scrollTime : number of milliseconds to use for smooth scrolling, or
 *         0 if the scrolling should be immediate.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     setLayerPosition:(int)x :(int)y :(int)scrollTime;

/**
 * Hides the layer. The state of the layer is preserved but the layer is not displayed
 * on the screen until the next call to unhide(). Hiding the layer can positively
 * affect the drawing speed, since it postpones the rendering until all operations are
 * completed (double-buffering).
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     hide;

/**
 * Shows the layer. Shows the layer again after a hide command.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     unhide;

/**
 * Gets parent YDisplay. Returns the parent YDisplay object of the current YDisplayLayer.
 *
 * @return an YDisplay object
 */
-(YDisplay*)     get_display;

/**
 * Returns the display width, in pixels.
 *
 * @return an integer corresponding to the display width, in pixels
 *
 * On failure, throws an exception or returns Y_DISPLAYWIDTH_INVALID.
 */
-(int)     get_displayWidth;

/**
 * Returns the display height, in pixels.
 *
 * @return an integer corresponding to the display height, in pixels
 *
 * On failure, throws an exception or returns Y_DISPLAYHEIGHT_INVALID.
 */
-(int)     get_displayHeight;

/**
 * Returns the width of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the width of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns Y_LAYERWIDTH_INVALID.
 */
-(int)     get_layerWidth;

/**
 * Returns the height of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the height of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns Y_LAYERHEIGHT_INVALID.
 */
-(int)     get_layerHeight;

-(int)     resetHiddenFlag;


//--- (end of generated code: YDisplayLayer public methods declaration)

@end

//--- (generated code: YDisplayLayer functions declaration)
//--- (end of generated code: YDisplayLayer functions declaration)


//--- (generated code: YDisplay class start)
/**
 * YDisplay Class: display control interface, available for instance in the Yocto-Display, the
 * Yocto-MaxiDisplay, the Yocto-MaxiDisplay-G or the Yocto-MiniDisplay
 *
 * The YDisplay class allows to drive Yoctopuce displays.
 * Yoctopuce display interface has been designed to easily
 * show information and images. The device provides built-in
 * multi-layer rendering. Layers can be drawn offline, individually,
 * and freely moved on the display. It can also replay recorded
 * sequences (animations).
 *
 * In order to draw on the screen, you should use the
 * display.get_displayLayer method to retrieve the layer(s) on
 * which you want to draw, and then use methods defined in
 * YDisplayLayer to draw on the layers.
 */
@interface YDisplay : YFunction
//--- (end of generated code: YDisplay class start)
{
@protected
//--- (generated code: YDisplay attributes declaration)
    Y_ENABLED_enum  _enabled;
    NSString*       _startupSeq;
    int             _brightness;
    Y_ORIENTATION_enum _orientation;
    int             _displayWidth;
    int             _displayHeight;
    Y_DISPLAYTYPE_enum _displayType;
    int             _layerWidth;
    int             _layerHeight;
    int             _layerCount;
    NSString*       _command;
    YDisplayValueCallback _valueCallbackDisplay;
    NSMutableArray* _allDisplayLayers;
//--- (end of generated code: YDisplay attributes declaration)
    bool             _recording;
    NSString  *_sequence;
}
// Constructor is protected, use yFindDisplay factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YDisplay private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YDisplay private methods declaration)

-(int) flushLayers;

-(void) resetHiddenLayerFlags;

-(int) sendCommand:(NSString*)cmd;

//--- (generated code: YDisplay public methods declaration)
/**
 * Returns true if the screen is powered, false otherwise.
 *
 * @return either YDisplay.ENABLED_FALSE or YDisplay.ENABLED_TRUE, according to true if the screen is
 * powered, false otherwise
 *
 * On failure, throws an exception or returns YDisplay.ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Changes the power state of the display.
 *
 * @param newval : either YDisplay.ENABLED_FALSE or YDisplay.ENABLED_TRUE, according to the power
 * state of the display
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Returns the name of the sequence to play when the displayed is powered on.
 *
 * @return a string corresponding to the name of the sequence to play when the displayed is powered on
 *
 * On failure, throws an exception or returns YDisplay.STARTUPSEQ_INVALID.
 */
-(NSString*)     get_startupSeq;


-(NSString*) startupSeq;
/**
 * Changes the name of the sequence to play when the displayed is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the name of the sequence to play when the displayed is powered on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_startupSeq:(NSString*) newval;
-(int)     setStartupSeq:(NSString*) newval;

/**
 * Returns the luminosity of the  module informative LEDs (from 0 to 100).
 *
 * @return an integer corresponding to the luminosity of the  module informative LEDs (from 0 to 100)
 *
 * On failure, throws an exception or returns YDisplay.BRIGHTNESS_INVALID.
 */
-(int)     get_brightness;


-(int) brightness;
/**
 * Changes the brightness of the display. The parameter is a value between 0 and
 * 100. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the brightness of the display
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_brightness:(int) newval;
-(int)     setBrightness:(int) newval;

/**
 * Returns the currently selected display orientation.
 *
 * @return a value among YDisplay.ORIENTATION_LEFT, YDisplay.ORIENTATION_UP,
 * YDisplay.ORIENTATION_RIGHT and YDisplay.ORIENTATION_DOWN corresponding to the currently selected
 * display orientation
 *
 * On failure, throws an exception or returns YDisplay.ORIENTATION_INVALID.
 */
-(Y_ORIENTATION_enum)     get_orientation;


-(Y_ORIENTATION_enum) orientation;
/**
 * Changes the display orientation. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a value among YDisplay.ORIENTATION_LEFT, YDisplay.ORIENTATION_UP,
 * YDisplay.ORIENTATION_RIGHT and YDisplay.ORIENTATION_DOWN corresponding to the display orientation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_orientation:(Y_ORIENTATION_enum) newval;
-(int)     setOrientation:(Y_ORIENTATION_enum) newval;

/**
 * Returns the display width, in pixels.
 *
 * @return an integer corresponding to the display width, in pixels
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYWIDTH_INVALID.
 */
-(int)     get_displayWidth;


-(int) displayWidth;
/**
 * Returns the display height, in pixels.
 *
 * @return an integer corresponding to the display height, in pixels
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYHEIGHT_INVALID.
 */
-(int)     get_displayHeight;


-(int) displayHeight;
/**
 * Returns the display type: monochrome, gray levels or full color.
 *
 * @return a value among YDisplay.DISPLAYTYPE_MONO, YDisplay.DISPLAYTYPE_GRAY and
 * YDisplay.DISPLAYTYPE_RGB corresponding to the display type: monochrome, gray levels or full color
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYTYPE_INVALID.
 */
-(Y_DISPLAYTYPE_enum)     get_displayType;


-(Y_DISPLAYTYPE_enum) displayType;
/**
 * Returns the width of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the width of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns YDisplay.LAYERWIDTH_INVALID.
 */
-(int)     get_layerWidth;


-(int) layerWidth;
/**
 * Returns the height of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the height of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns YDisplay.LAYERHEIGHT_INVALID.
 */
-(int)     get_layerHeight;


-(int) layerHeight;
/**
 * Returns the number of available layers to draw on.
 *
 * @return an integer corresponding to the number of available layers to draw on
 *
 * On failure, throws an exception or returns YDisplay.LAYERCOUNT_INVALID.
 */
-(int)     get_layerCount;


-(int) layerCount;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a display for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the display is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDisplay.isOnline() to test if the display is
 * indeed online at a given time. In case of ambiguity when looking for
 * a display by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the display, for instance
 *         YD128X32.display.
 *
 * @return a YDisplay object allowing you to drive the display.
 */
+(YDisplay*)     FindDisplay:(NSString*)func;

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
-(int)     registerValueCallback:(YDisplayValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Clears the display screen and resets all display layers to their default state.
 * Using this function in a sequence will kill the sequence play-back. Don't use that
 * function to reset the display at sequence start-up.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     resetAll;

/**
 * Smoothly changes the brightness of the screen to produce a fade-in or fade-out
 * effect.
 *
 * @param brightness : the new screen brightness
 * @param duration : duration of the brightness transition, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     fade:(int)brightness :(int)duration;

/**
 * Starts to record all display commands into a sequence, for later replay.
 * The name used to store the sequence is specified when calling
 * saveSequence(), once the recording is complete.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     newSequence;

/**
 * Stops recording display commands and saves the sequence into the specified
 * file on the display internal memory. The sequence can be later replayed
 * using playSequence().
 *
 * @param sequenceName : the name of the newly created sequence
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     saveSequence:(NSString*)sequenceName;

/**
 * Replays a display sequence previously recorded using
 * newSequence() and saveSequence().
 *
 * @param sequenceName : the name of the newly created sequence
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     playSequence:(NSString*)sequenceName;

/**
 * Waits for a specified delay (in milliseconds) before playing next
 * commands in current sequence. This method can be used while
 * recording a display sequence, to insert a timed wait in the sequence
 * (without any immediate effect). It can also be used dynamically while
 * playing a pre-recorded sequence, to suspend or resume the execution of
 * the sequence. To cancel a delay, call the same method with a zero delay.
 *
 * @param delay_ms : the duration to wait, in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     pauseSequence:(int)delay_ms;

/**
 * Stops immediately any ongoing sequence replay.
 * The display is left as is.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     stopSequence;

/**
 * Uploads an arbitrary file (for instance a GIF file) to the display, to the
 * specified full path name. If a file already exists with the same path name,
 * its content is overwritten.
 *
 * @param pathname : path and name of the new file to create
 * @param content : binary buffer with the content to set
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     upload:(NSString*)pathname :(NSData*)content;

/**
 * Copies the whole content of a layer to another layer. The color and transparency
 * of all the pixels from the destination layer are set to match the source pixels.
 * This method only affects the displayed content, but does not change any
 * property of the layer object.
 * Note that layer 0 has no transparency support (it is always completely opaque).
 *
 * @param srcLayerId : the identifier of the source layer (a number in range 0..layerCount-1)
 * @param dstLayerId : the identifier of the destination layer (a number in range 0..layerCount-1)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     copyLayerContent:(int)srcLayerId :(int)dstLayerId;

/**
 * Swaps the whole content of two layers. The color and transparency of all the pixels from
 * the two layers are swapped. This method only affects the displayed content, but does
 * not change any property of the layer objects. In particular, the visibility of each
 * layer stays unchanged. When used between one hidden layer and a visible layer,
 * this method makes it possible to easily implement double-buffering.
 * Note that layer 0 has no transparency support (it is always completely opaque).
 *
 * @param layerIdA : the first layer (a number in range 0..layerCount-1)
 * @param layerIdB : the second layer (a number in range 0..layerCount-1)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     swapLayerContent:(int)layerIdA :(int)layerIdB;

/**
 * Returns a YDisplayLayer object that can be used to draw on the specified
 * layer. The content is displayed only when the layer is active on the
 * screen (and not masked by other overlapping layers).
 *
 * @param layerId : the identifier of the layer (a number in range 0..layerCount-1)
 *
 * @return an YDisplayLayer object
 *
 * On failure, throws an exception or returns nil.
 */
-(YDisplayLayer*)     get_displayLayer:(int)layerId;


/**
 * Continues the enumeration of displays started using yFirstDisplay().
 * Caution: You can't make any assumption about the returned displays order.
 * If you want to find a specific a display, use Display.findDisplay()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YDisplay object, corresponding to
 *         a display currently online, or a nil pointer
 *         if there are no more displays to enumerate.
 */
-(nullable YDisplay*) nextDisplay
NS_SWIFT_NAME(nextDisplay());
/**
 * Starts the enumeration of displays currently accessible.
 * Use the method YDisplay.nextDisplay() to iterate on
 * next displays.
 *
 * @return a pointer to a YDisplay object, corresponding to
 *         the first display currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YDisplay*) FirstDisplay
NS_SWIFT_NAME(FirstDisplay());
//--- (end of generated code: YDisplay public methods declaration)



@end

//--- (generated code: YDisplay functions declaration)
/**
 * Retrieves a display for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the display is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDisplay.isOnline() to test if the display is
 * indeed online at a given time. In case of ambiguity when looking for
 * a display by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the display, for instance
 *         YD128X32.display.
 *
 * @return a YDisplay object allowing you to drive the display.
 */
YDisplay* yFindDisplay(NSString* func);
/**
 * Starts the enumeration of displays currently accessible.
 * Use the method YDisplay.nextDisplay() to iterate on
 * next displays.
 *
 * @return a pointer to a YDisplay object, corresponding to
 *         the first display currently online, or a nil pointer
 *         if there are none.
 */
YDisplay* yFirstDisplay(void);

//--- (end of generated code: YDisplay functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

