/*********************************************************************
 *
 * $Id: yocto_display.m 75525 2026-08-14 08:04:04Z mvuilleu $
 *
 * Implements yFindDisplay(), the high-level API for Display functions
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


#import "yocto_display.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"




@implementation YDisplayLayer


-(id)   initWithDisplay:(YDisplay *)display andLayerID:(int)layerid
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YDisplayLayer attributes initialization)
    _cmdbuff = @"";
    _hidden = NO;
    _polyPrevX = 0;
    _polyPrevY = 0;
//--- (end of generated code: YDisplayLayer attributes initialization)
    _display =display;
    _id = layerid;
    return self;
}

-(id)   initWith:(YDisplay *)display :(int)layerid
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YDisplayLayer attributes initialization)
    _cmdbuff = @"";
    _hidden = NO;
    _polyPrevX = 0;
    _polyPrevY = 0;
//--- (end of generated code: YDisplayLayer attributes initialization)
    _display =display;
    _id = layerid;
    return self;
}


-(void) dealloc
{
//--- (generated code: YDisplayLayer cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YDisplayLayer cleanup)
}


//--- (generated code: YDisplayLayer private methods implementation)

//--- (end of generated code: YDisplayLayer private methods implementation)

//--- (generated code: YDisplayLayer public methods implementation)
-(bool) must_be_flushed
{
    return (int)[(_cmdbuff) length] > 0;
}

-(int) resetHiddenFlag
{
    _hidden = NO;
    return YAPI_SUCCESS;
}

-(int) flush_now
{
    int res;
    res = YAPI_SUCCESS;
    if ((int)[(_cmdbuff) length] > 0) {
        res = [_display sendCommand:_cmdbuff];
        _cmdbuff = @"";
    }
    return res;
}

-(int) command_push:(NSString*)cmd
{
    int res;
    res = YAPI_SUCCESS;
    if ((int)[(_cmdbuff) length] + (int)[(cmd) length] >= 64) {
        // force flush before, to prevent overflow
        [self flush_now];
    }
    if ((int)[(_cmdbuff) length] == 0) {
        // always prepend layer ID first
        _cmdbuff = [NSString stringWithFormat:@"%d",_id];
    }
    _cmdbuff = [NSString stringWithFormat:@"%@%@", _cmdbuff, cmd];
    return res;
}

-(int) command_flush:(NSString*)cmd
{
    int res;

    res = [self command_push:cmd];
    if (_hidden) {
        return res;
    }
    if ([_display isFrozen]) {
        return res;
    }
    return [self flush_now];
}

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
-(int) reset
{
    _hidden = NO;
    return [self command_flush:@"X"];
}

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
-(int) clear
{
    return [self command_flush:@"x"];
}

/**
 * Selects the color to be used for all subsequent drawing functions,
 * for filling as well as for line and text drawing.
 * To select a different fill and outline color, use
 * selectFillColor and selectLineColor.
 * The pen color is provided as an RGB value.
 * For grayscale or monochrome displays, the value is
 * automatically converted to the proper range.
 *
 * @param color : the desired pen color, as a 24-bit RGB value
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectColorPen:(int)color
{
    return [self command_push:[NSString stringWithFormat:@"c%06x",color]];
}

/**
 * Selects the pen gray level for all subsequent drawing functions,
 * for filling as well as for line and text drawing.
 * To select a different fill and outline color, use
 * selectFillColor and selectLineColor.
 * The gray level is provided as a number between
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
-(int) selectGrayPen:(int)graylevel
{
    return [self command_push:[NSString stringWithFormat:@"g%d",graylevel]];
}

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
-(int) selectEraser
{
    return [self command_push:@"e"];
}

/**
 * Selects the color to be used for filling rectangular bars,
 * discs and polygons. The color is provided as an RGB value.
 * For grayscale or monochrome displays, the value is
 * automatically converted to the proper range.
 * You can also use the constants FG_INK to use the
 * default drawing colour, BG_INK to use the default
 * background colour, and NO_INK to disable filling.
 *
 * @param color : the desired drawing color, as a 24-bit RGB value,
 *         or one of the constants NO_INK, FG_INK
 *         or BG_INK
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectFillColor:(int)color
{
    int r;
    int g;
    int b;
    if (color==-1) {
        return [self command_push:@"f_"];
    }
    if (color==-2) {
        return [self command_push:@"f-"];
    }
    if (color==-3) {
        return [self command_push:@"f."];
    }
    r = ((color >> 20) & 15);
    g = ((color >> 12) & 15);
    b = ((color >> 4) & 15);
    return [self command_push:[NSString stringWithFormat:@"f%x%x%x",r,g,b]];
}

/**
 * Selects the color to be used for drawing the outline of rectangular
 * bars, discs and polygons, as well as for drawing lines and text.
 * The color is provided as an RGB value.
 * For grayscale or monochrome displays, the value is
 * automatically converted to the proper range.
 * You can also use the constants FG_INK to use the
 * default drawing colour, BG_INK to use the default
 * background colour, and NO_INK to disable outline drawing.
 *
 * @param color : the desired drawing color, as a 24-bit RGB value,
 *         or one of the constants NO_INK, FG_INK
 *         or BG_INK
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectLineColor:(int)color
{
    int r;
    int g;
    int b;
    if (color==-1) {
        return [self command_push:@"l_"];
    }
    if (color==-2) {
        return [self command_push:@"l-"];
    }
    if (color==-3) {
        return [self command_push:@"l*"];
    }
    r = ((color >> 20) & 15);
    g = ((color >> 12) & 15);
    b = ((color >> 4) & 15);
    return [self command_push:[NSString stringWithFormat:@"l%x%x%x",r,g,b]];
}

/**
 * Selects the line width for drawing the outline of rectangular
 * bars, discs and polygons, as well as for drawing lines.
 *
 * @param width : the desired line width, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectLineWidth:(int)width
{
    return [self command_push:[NSString stringWithFormat:@"t%d",width]];
}

-(int) setAntialiasingMode:(bool)mode
{
    return [self command_push:[NSString stringWithFormat:@"a%d",mode]];
}

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
-(int) drawPixel:(int)x :(int)y
{
    return [self command_flush:[NSString stringWithFormat:@"P%d,%d",x,y]];
}

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
-(int) drawRect:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_flush:[NSString stringWithFormat:@"R%d,%d,%d,%d",x1,y1,x2,y2]];
}

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
-(int) drawBar:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_flush:[NSString stringWithFormat:@"B%d,%d,%d,%d",x1,y1,x2,y2]];
}

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
-(int) drawCircle:(int)x :(int)y :(int)r
{
    return [self command_flush:[NSString stringWithFormat:@"C%d,%d,%d",x,y,r]];
}

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
-(int) drawDisc:(int)x :(int)y :(int)r
{
    return [self command_flush:[NSString stringWithFormat:@"D%d,%d,%d",x,y,r]];
}

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
-(int) selectFont:(NSString*)fontname
{
    return [self command_push:[NSString stringWithFormat:@"&%@%c",fontname,27]];
}

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
-(int) drawText:(int)x :(int)y :(Y_ALIGN)anchor :(NSString*)text
{
    int textlen;
    NSString* destname;
    textlen = (int)[(text) length];
    if (textlen > 60) {
        if (textlen > 1000) {
            [_display _throw:YAPI_INVALID_ARGUMENT :@"text too large (max 1000 characters)"];
            return YAPI_INVALID_ARGUMENT;
        }
        [_display flushLayers];
        destname = [NSString stringWithFormat:@"layer%d:T%d,%d,%d,",_id,x,y,anchor];
        return [_display upload:destname :[NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]]];
    }
    return [self command_flush:[NSString stringWithFormat:@"T%d,%d,%d,%@%c",x,y,anchor,text,27]];
}

/**
 * Draws an image previously uploaded to the device filesystem, at the specified position.
 * At present time, GIF images are the only supported image format. If you experience
 * problems using an image file, check the device logs for any error message such as
 * missing image file or bad image file format.
 *
 * @param x : the distance from left of layer to the left of the image, in pixels
 * @param y : the distance from top of layer to the top of the image, in pixels
 * @param imagename : the GIF file name
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawImage:(int)x :(int)y :(NSString*)imagename
{
    return [self command_flush:[NSString stringWithFormat:@"*%d,%d,%@%c",x,y,imagename,27]];
}

/**
 * Draws a GIF image provided as a binary buffer at the specified position.
 * If the image drawing must be included in an animation sequence, save it
 * in the device filesystem first and use drawImage instead.
 *
 * @param x : the distance from left of layer to the left of the image, in pixels
 * @param y : the distance from top of layer to the top of the image, in pixels
 * @param gifimage : a binary object with the content of a GIF file
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawGIF:(int)x :(int)y :(NSData*)gifimage
{
    NSString* destname;
    [_display flushLayers];
    destname = [NSString stringWithFormat:@"layer%d:G,-1@%d,%d",_id,x,y];
    return [_display upload:destname :gifimage];
}

/**
 * Draws a bitmap at the specified position. The bitmap is provided as a binary object,
 * where each pixel maps to a bit, from left to right and from top to bottom.
 * The most significant bit of each byte maps to the leftmost pixel, and the least
 * significant bit maps to the rightmost pixel. Bits set to 1 are drawn using the
 * layer selected pen color. Bits set to 0 are drawn using the specified background
 * color, unless NO_INK (-1) is specified, in which case they are not
 * drawn at all (as if transparent).
 *
 * @param x : the distance from left of layer to the left of the bitmap, in pixels
 * @param y : the distance from top of layer to the top of the bitmap, in pixels
 * @param w : the width of the bitmap, in pixels
 * @param bitmap : a binary object
 * @param bgcol : the RGB background color to use for zero bits, as a 24-bit RGB value,
 *         or one of the constants NO_INK, FG_INK or BG_INK
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawBitmap:(int)x :(int)y :(int)w :(NSData*)bitmap :(int)bgcol
{
    NSString* destname;
    int r;
    int g;
    int b;
    NSString* rgbcol;
    if ((w < 0) || (w > 512)) {
        [_display _throw:YAPI_INVALID_ARGUMENT :@"bitmap width must be in range 1...512"];
        return YAPI_INVALID_ARGUMENT;
    }
    [_display flushLayers];
    if (bgcol <= 255) {
        if (bgcol >= -1) {
            // backward-compatible behaviour (gray level)
            rgbcol = [NSString stringWithFormat:@"%d",bgcol];
        } else {
            // background color or foreground color
            if (bgcol <= -3) {
                rgbcol = @"#.";
            } else {
                rgbcol = @"#-";
            }
        }
    } else {
        // RGB color
        r = ((bgcol >> 20) & 15);
        g = ((bgcol >> 12) & 15);
        b = ((bgcol >> 4) & 15);
        rgbcol = [NSString stringWithFormat:@"#%x%x%x",r,g,b];
    }
    destname = [NSString stringWithFormat:@"layer%d:%d,%@@%d,%d",_id,w,rgbcol,x,y];
    return [_display upload:destname :bitmap];
}

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
-(int) moveTo:(int)x :(int)y
{
    return [self command_push:[NSString stringWithFormat:@"@%d,%d",x,y]];
}

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
-(int) lineTo:(int)x :(int)y
{
    return [self command_flush:[NSString stringWithFormat:@"-%d,%d",x,y]];
}

/**
 * Starts drawing a polygon with the first corner at the specified position.
 *
 * @param x : the distance from left of layer, in pixels
 * @param y : the distance from top of layer, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) polygonStart:(int)x :(int)y
{
    _polyPrevX = x;
    _polyPrevY = y;
    return [self command_push:[NSString stringWithFormat:@"[%d,%d",x,y]];
}

/**
 * Adds a point to the currently open polygon, previously opened using
 * polygonStart.
 *
 * @param x : the distance from left of layer to the new point, in pixels
 * @param y : the distance from top of layer to the new point, in pixels
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) polygonAdd:(int)x :(int)y
{
    int dx;
    int dy;
    dx = x - _polyPrevX;
    dy = y - _polyPrevY;
    _polyPrevX = x;
    _polyPrevY = y;
    return [self command_flush:[NSString stringWithFormat:@";%d,%d",dx,dy]];
}

/**
 * Closes the currently open polygon, fill its content the fill color currently
 * selected for the layer, and draw its outline using the selected line color.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) polygonEnd
{
    return [self command_flush:@"]"];
}

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
-(int) consoleOut:(NSString*)text
{
    int textlen;
    NSString* destname;
    textlen = (int)[(text) length];
    if (textlen > 60) {
        if (textlen > 1000) {
            [_display _throw:YAPI_INVALID_ARGUMENT :@"text too large (max 1000 characters)"];
            return YAPI_INVALID_ARGUMENT;
        }
        [_display flushLayers];
        destname = [NSString stringWithFormat:@"layer%d:!",_id];
        return [_display upload:destname :[NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]]];
    }
    return [self command_flush:[NSString stringWithFormat:@"!%@%c",text,27]];
}

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
-(int) setConsoleMargins:(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_push:[NSString stringWithFormat:@"m%d,%d,%d,%d",x1,y1,x2,y2]];
}

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
-(int) setConsoleBackground:(int)bgcol
{
    return [self command_push:[NSString stringWithFormat:@"b%d",bgcol]];
}

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
-(int) setConsoleWordWrap:(bool)wordwrap
{
    return [self command_push:[NSString stringWithFormat:@"w%d",wordwrap]];
}

/**
 * Blanks the console area within console margins, and resets the console pointer
 * to the upper left corner of the console.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) clearConsole
{
    return [self command_flush:@"^"];
}

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
-(int) setLayerPosition:(int)x :(int)y :(int)scrollTime
{
    return [self command_flush:[NSString stringWithFormat:@"#%d,%d,%d",x,y,scrollTime]];
}

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
-(int) hide
{
    [self command_push:@"h"];
    _hidden = YES;
    return [self flush_now];
}

/**
 * Shows the layer. Shows the layer again after a hide command.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) unhide
{
    _hidden = NO;
    return [self command_flush:@"s"];
}

/**
 * Gets parent YDisplay. Returns the parent YDisplay object of the current YDisplayLayer.
 *
 * @return an YDisplay object
 */
-(YDisplay*) get_display
{
    return _display;
}

/**
 * Returns the display width, in pixels.
 *
 * @return an integer corresponding to the display width, in pixels
 *
 * On failure, throws an exception or returns Y_DISPLAYWIDTH_INVALID.
 */
-(int) get_displayWidth
{
    return [_display get_displayWidth];
}

/**
 * Returns the display height, in pixels.
 *
 * @return an integer corresponding to the display height, in pixels
 *
 * On failure, throws an exception or returns Y_DISPLAYHEIGHT_INVALID.
 */
-(int) get_displayHeight
{
    return [_display get_displayHeight];
}

/**
 * Returns the width of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the width of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns Y_LAYERWIDTH_INVALID.
 */
-(int) get_layerWidth
{
    return [_display get_layerWidth];
}

/**
 * Returns the height of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the height of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns Y_LAYERHEIGHT_INVALID.
 */
-(int) get_layerHeight
{
    return [_display get_layerHeight];
}

//--- (end of generated code: YDisplayLayer public methods implementation)

@end
//--- (generated code: YDisplayLayer functions)
//--- (end of generated code: YDisplayLayer functions)




@implementation YDisplay

// Constructor is protected, use yFindDisplay factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"Display";
//--- (generated code: YDisplay attributes initialization)
    _enabled = Y_ENABLED_INVALID;
    _startupSeq = Y_STARTUPSEQ_INVALID;
    _brightness = Y_BRIGHTNESS_INVALID;
    _autoInvertDelay = Y_AUTOINVERTDELAY_INVALID;
    _orientation = Y_ORIENTATION_INVALID;
    _displayPanel = Y_DISPLAYPANEL_INVALID;
    _displayWidth = Y_DISPLAYWIDTH_INVALID;
    _displayHeight = Y_DISPLAYHEIGHT_INVALID;
    _displayType = Y_DISPLAYTYPE_INVALID;
    _layerWidth = Y_LAYERWIDTH_INVALID;
    _layerHeight = Y_LAYERHEIGHT_INVALID;
    _layerCount = Y_LAYERCOUNT_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackDisplay = NULL;
    _allDisplayLayers = [NSMutableArray array];
    _frozenUntil = 0;
//--- (end of generated code: YDisplay attributes initialization)
    return self;
}


-(void) dealloc
{
//--- (generated code: YDisplay cleanup)
    ARC_release(_startupSeq);
    _startupSeq = nil;
    ARC_release(_displayPanel);
    _displayPanel = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of generated code: YDisplay cleanup)
}

//--- (generated code: YDisplay private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "startupSeq")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_startupSeq);
        _startupSeq =  [self _parseString:j];
        ARC_retain(_startupSeq);
        return 1;
    }
    if(!strcmp(j->token, "brightness")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _brightness =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "autoInvertDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _autoInvertDelay =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "orientation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _orientation =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "displayPanel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_displayPanel);
        _displayPanel =  [self _parseString:j];
        ARC_retain(_displayPanel);
        return 1;
    }
    if(!strcmp(j->token, "displayWidth")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _displayWidth =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "displayHeight")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _displayHeight =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "displayType")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _displayType =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "layerWidth")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _layerWidth =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "layerHeight")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _layerHeight =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "layerCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _layerCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YDisplay private methods implementation)


//--- (generated code: YDisplay public methods implementation)
/**
 * Returns true if the screen is powered, false otherwise.
 *
 * @return either YDisplay.ENABLED_FALSE or YDisplay.ENABLED_TRUE, according to true if the screen is
 * powered, false otherwise
 *
 * On failure, throws an exception or returns YDisplay.ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    Y_ENABLED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLED_INVALID;
        }
    }
    res = _enabled;
    return res;
}


-(Y_ENABLED_enum) enabled
{
    return [self get_enabled];
}

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
-(int) set_enabled:(Y_ENABLED_enum) newval
{
    return [self setEnabled:newval];
}
-(int) setEnabled:(Y_ENABLED_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabled" :rest_val];
}
/**
 * Returns the name of the sequence to play when the displayed is powered on.
 *
 * @return a string corresponding to the name of the sequence to play when the displayed is powered on
 *
 * On failure, throws an exception or returns YDisplay.STARTUPSEQ_INVALID.
 */
-(NSString*) get_startupSeq
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_STARTUPSEQ_INVALID;
        }
    }
    res = _startupSeq;
    return res;
}


-(NSString*) startupSeq
{
    return [self get_startupSeq];
}

/**
 * Changes the name of the sequence to play when the display is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the name of the sequence to play when the display is powered on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_startupSeq:(NSString*) newval
{
    return [self setStartupSeq:newval];
}
-(int) setStartupSeq:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"startupSeq" :rest_val];
}
/**
 * Returns the luminosity of the  module informative LEDs (from 0 to 100).
 *
 * @return an integer corresponding to the luminosity of the  module informative LEDs (from 0 to 100)
 *
 * On failure, throws an exception or returns YDisplay.BRIGHTNESS_INVALID.
 */
-(int) get_brightness
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BRIGHTNESS_INVALID;
        }
    }
    res = _brightness;
    return res;
}


-(int) brightness
{
    return [self get_brightness];
}

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
-(int) set_brightness:(int) newval
{
    return [self setBrightness:newval];
}
-(int) setBrightness:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"brightness" :rest_val];
}
/**
 * Returns the interval between automatic display inversions, or 0 if automatic
 * inversion is disabled. Using the automatic inversion mechanism reduces the
 * burn-in that occurs on OLED screens over long periods when the same content
 * remains displayed on the screen.
 *
 * @return an integer corresponding to the interval between automatic display inversions, or 0 if automatic
 *         inversion is disabled
 *
 * On failure, throws an exception or returns YDisplay.AUTOINVERTDELAY_INVALID.
 */
-(int) get_autoInvertDelay
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUTOINVERTDELAY_INVALID;
        }
    }
    res = _autoInvertDelay;
    return res;
}


-(int) autoInvertDelay
{
    return [self get_autoInvertDelay];
}

/**
 * Changes the interval between automatic display inversions.
 * The parameter is the number of seconds, or 0 to disable automatic inversion.
 * Using the automatic inversion mechanism reduces the burn-in that occurs on OLED
 * screens over long periods when the same content remains displayed on the screen.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the interval between automatic display inversions
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_autoInvertDelay:(int) newval
{
    return [self setAutoInvertDelay:newval];
}
-(int) setAutoInvertDelay:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"autoInvertDelay" :rest_val];
}
/**
 * Returns the currently selected display orientation. The orientation is defined as the side of the
 * screen where the
 * USB connector (for OLED displays) or the ribbon cable (for ePaper panels) is located when the
 * display is up straight.
 *
 * @return a value among YDisplay.ORIENTATION_LEFT, YDisplay.ORIENTATION_UP,
 * YDisplay.ORIENTATION_RIGHT and YDisplay.ORIENTATION_DOWN corresponding to the currently selected
 * display orientation
 *
 * On failure, throws an exception or returns YDisplay.ORIENTATION_INVALID.
 */
-(Y_ORIENTATION_enum) get_orientation
{
    Y_ORIENTATION_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ORIENTATION_INVALID;
        }
    }
    res = _orientation;
    return res;
}


-(Y_ORIENTATION_enum) orientation
{
    return [self get_orientation];
}

/**
 * Changes the display orientation. he orientation is defined as the side of the screen where the
 * USB connector (for OLED displays) or the ribbon cable (for ePaper panels) is located when the
 * display is up straight. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a value among YDisplay.ORIENTATION_LEFT, YDisplay.ORIENTATION_UP,
 * YDisplay.ORIENTATION_RIGHT and YDisplay.ORIENTATION_DOWN corresponding to the display orientation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_orientation:(Y_ORIENTATION_enum) newval
{
    return [self setOrientation:newval];
}
-(int) setOrientation:(Y_ORIENTATION_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"orientation" :rest_val];
}
/**
 * Returns the exact model of the display panel.
 *
 * @return a string corresponding to the exact model of the display panel
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYPANEL_INVALID.
 */
-(NSString*) get_displayPanel
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYPANEL_INVALID;
        }
    }
    res = _displayPanel;
    return res;
}


-(NSString*) displayPanel
{
    return [self get_displayPanel];
}

/**
 * Changes the model of display to match the connected display panel.
 * This function has no effect if the module does not support the selected
 * display panel. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the model of display to match the connected display panel
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_displayPanel:(NSString*) newval
{
    return [self setDisplayPanel:newval];
}
-(int) setDisplayPanel:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"displayPanel" :rest_val];
}
/**
 * Returns the display width, in pixels.
 *
 * @return an integer corresponding to the display width, in pixels
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYWIDTH_INVALID.
 */
-(int) get_displayWidth
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYWIDTH_INVALID;
        }
    }
    res = _displayWidth;
    return res;
}


-(int) displayWidth
{
    return [self get_displayWidth];
}
/**
 * Returns the display height, in pixels.
 *
 * @return an integer corresponding to the display height, in pixels
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYHEIGHT_INVALID.
 */
-(int) get_displayHeight
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYHEIGHT_INVALID;
        }
    }
    res = _displayHeight;
    return res;
}


-(int) displayHeight
{
    return [self get_displayHeight];
}
/**
 * Returns the display type: monochrome OLED, black and white ePaper, color ePaper, and so on.
 *
 * @return a value among YDisplay.DISPLAYTYPE_MONO, YDisplay.DISPLAYTYPE_EPAPER_BW,
 * YDisplay.DISPLAYTYPE_EPAPER_BWR and YDisplay.DISPLAYTYPE_EPAPER_BWRY corresponding to the display
 * type: monochrome OLED, black and white ePaper, color ePaper, and so on
 *
 * On failure, throws an exception or returns YDisplay.DISPLAYTYPE_INVALID.
 */
-(Y_DISPLAYTYPE_enum) get_displayType
{
    Y_DISPLAYTYPE_enum res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYTYPE_INVALID;
        }
    }
    res = _displayType;
    return res;
}


-(Y_DISPLAYTYPE_enum) displayType
{
    return [self get_displayType];
}
/**
 * Returns the width of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the width of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns YDisplay.LAYERWIDTH_INVALID.
 */
-(int) get_layerWidth
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LAYERWIDTH_INVALID;
        }
    }
    res = _layerWidth;
    return res;
}


-(int) layerWidth
{
    return [self get_layerWidth];
}
/**
 * Returns the height of the layers to draw on, in pixels.
 *
 * @return an integer corresponding to the height of the layers to draw on, in pixels
 *
 * On failure, throws an exception or returns YDisplay.LAYERHEIGHT_INVALID.
 */
-(int) get_layerHeight
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LAYERHEIGHT_INVALID;
        }
    }
    res = _layerHeight;
    return res;
}


-(int) layerHeight
{
    return [self get_layerHeight];
}
/**
 * Returns the number of available layers to draw on.
 *
 * @return an integer corresponding to the number of available layers to draw on
 *
 * On failure, throws an exception or returns YDisplay.LAYERCOUNT_INVALID.
 */
-(int) get_layerCount
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LAYERCOUNT_INVALID;
        }
    }
    res = _layerCount;
    return res;
}


-(int) layerCount
{
    return [self get_layerCount];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a display for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
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
+(YDisplay*) FindDisplay:(NSString*)func
{
    YDisplay* obj;
    obj = (YDisplay*) [YFunction _FindFromCache:@"Display" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDisplay alloc] initWith:func]);
        [YFunction _AddToCache:@"Display" :func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is then invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness,
 * remember to call one of these two functions periodically. The callback is called once juste after beeing
 * registered, passing the current advertised value  of the function, provided that it is not an empty string.
 * To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YDisplayValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDisplay = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackDisplay != NULL) {
        _valueCallbackDisplay(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)cmd
{
    if (!(_recording)) {
        return [self set_command:cmd];
    }
    _sequence = [NSString stringWithFormat:@"%@%@\n",_sequence,cmd];
    return YAPI_SUCCESS;
}

-(int) flushLayers
{
    for (YDisplayLayer* _each  in _allDisplayLayers) {
        if ([((YDisplayLayer*)_each) must_be_flushed]) {
            [((YDisplayLayer*)_each) flush_now];
        }
    }
    return YAPI_SUCCESS;
}

-(int) resetHiddenLayerFlags
{
    for (YDisplayLayer* _each  in _allDisplayLayers) {
        [((YDisplayLayer*)_each) resetHiddenFlag];
    }
    return YAPI_SUCCESS;
}

-(bool) isFrozen
{
    if (_frozenUntil == 0) {
        return NO;
    }
    if (_frozenUntil <= [YAPI GetTickCount]) {
        _frozenUntil = 0;
        return NO;
    }
    return YES;
}

/**
 * Returns the fast refresh usage policy in use (ePaper displays only).
 * This setting is combined with the regenerate policy to determine when the screen
 * should be updated using a fast update versus or regenerated using a slower,
 * flickering full refresh.
 *
 * @return a value among the YDisplay.FASTREFRESH enumeration
 *         (YDisplay.FASTREFRESH_WHENEVER_POSSIBLE,
 *         YDisplay.FASTREFRESH_WHENEVER_SUPPORTED,
 *         YDisplay.FASTREFRESH_NEVER).
 *
 * On failure, throws an exception or returns YDisplay.FASTREFRESH_INVALID.
 */
-(Y_FASTREFRESH) get_fastRefreshPolicy
{
    int combined;
    int fmod;
    combined = [self get_brightness];
    if (combined < 0) {
        return Y_FASTREFRESH_INVALID;
    }
    fmod = (combined / 25);
    if (fmod >= 2) {
        fmod = fmod - 2;
    }
    return (Y_FASTREFRESH) fmod;
}

/**
 * Returns the display regeneration minimal frequency (ePaper displays only).
 * This setting is combined with the fast refresh usage policy to determine
 * when the screen should be updated using a fast update versus or regenerated
 * using a slower, flickering full refresh. To change the display regeneration minimal
 * frequency, use methode set_fastRefreshPolicy().
 *
 * @return a value among the YDisplay.REGENERATE enumeration
 *         (YDisplay.REGENERATE_ON_REQUEST_ONLY,
 *         YDisplay.REGENERATE_EVERY_DAY, YDisplay.REGENERATE_EVERY_12H,
 *         YDisplay.REGENERATE_EVERY_6H, YDisplay.REGENERATE_EVERY_3H,
 *         YDisplay.REGENERATE_EVERY_2H, YDisplay.REGENERATE_EVERY_HOUR,
 *         YDisplay.REGENERATE_EVERY_30MIN, YDisplay.REGENERATE_EVERY_15MIN,
 *         YDisplay.REGENERATE_EVERY_480, YDisplay.REGENERATE_EVERY_432,
 *         YDisplay.REGENERATE_EVERY_360, YDisplay.REGENERATE_EVERY_288,
 *         YDisplay.REGENERATE_EVERY_240, YDisplay.REGENERATE_EVERY_192,
 *         YDisplay.REGENERATE_EVERY_144, YDisplay.REGENERATE_EVERY_96,
 *         YDisplay.REGENERATE_EVERY_48, YDisplay.REGENERATE_EVERY_36,
 *         YDisplay.REGENERATE_EVERY_24, YDisplay.REGENERATE_EVERY_12,
 *         YDisplay.REGENERATE_EVERY_10, YDisplay.REGENERATE_EVERY_8,
 *         YDisplay.REGENERATE_EVERY_6, YDisplay.REGENERATE_EVERY_4,
 *         YDisplay.REGENERATE_ALWAYS).
 *
 * On failure, throws an exception or returns YDisplay.REGENERATE_INVALID.
 */
-(Y_REGENERATE) get_regeneratePolicy
{
    int combined;
    int fval;
    combined= [self get_brightness];
    if (combined < 0) {
        return Y_REGENERATE_INVALID;
    }
    if (combined >= 100) {
        fval = 25;
    } else {
        fval = (combined % 25);
    }
    return (Y_REGENERATE) fval;
}

/**
 * Changes the fast refresh usage policy and display regeneration minimal frequency
 * (ePaper displays only). These settings jointly determine when the screen should be
 * updated using a fast update versus or regenerated using a slower, flickering full
 * refresh.
 *
 * @param fastRefresh : a value among the YDisplay.FASTREFRESH enumeration
 *         (YDisplay.FASTREFRESH_WHENEVER_POSSIBLE,
 *         YDisplay.FASTREFRESH_WHENEVER_SUPPORTED,
 *         YDisplay.FASTREFRESH_NEVER),
 *         corresponding to the policy for using fast refresh.
 * @param regenerate : a value among the enumeration YRefFrame.REGENERATE
 *         (YDisplay.REGENERATE_ON_REQUEST_ONLY,
 *         YDisplay.REGENERATE_EVERY_DAY, YDisplay.REGENERATE_EVERY_12H,
 *         YDisplay.REGENERATE_EVERY_6H, YDisplay.REGENERATE_EVERY_3H,
 *         YDisplay.REGENERATE_EVERY_2H, YDisplay.REGENERATE_EVERY_HOUR,
 *         YDisplay.REGENERATE_EVERY_30MIN, YDisplay.REGENERATE_EVERY_15MIN,
 *         YDisplay.REGENERATE_EVERY_480, YDisplay.REGENERATE_EVERY_432,
 *         YDisplay.REGENERATE_EVERY_360, YDisplay.REGENERATE_EVERY_288,
 *         YDisplay.REGENERATE_EVERY_240, YDisplay.REGENERATE_EVERY_192,
 *         YDisplay.REGENERATE_EVERY_144, YDisplay.REGENERATE_EVERY_96,
 *         YDisplay.REGENERATE_EVERY_48, YDisplay.REGENERATE_EVERY_36,
 *         YDisplay.REGENERATE_EVERY_24, YDisplay.REGENERATE_EVERY_12,
 *         YDisplay.REGENERATE_EVERY_10, YDisplay.REGENERATE_EVERY_8,
 *         YDisplay.REGENERATE_EVERY_6, YDisplay.REGENERATE_EVERY_4,
 *         YDisplay.REGENERATE_ALWAYS),
 *         corresponding to the display minimal regeneration frequency.
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_fastRefreshPolicy:(Y_FASTREFRESH)fastRefresh :(Y_REGENERATE)regenerate
{
    int combined;
    int fmod;
    int fval;
    fmod = fastRefresh;
    fval = regenerate;
    if ((fval == 25) || (fmod == 2)) {
        combined = 100;
    } else {
        combined = 50 + fmod * 25 + fval;
    }
    return [self set_brightness:combined];
}

/**
 * Clears the display screen and resets all display layers to their default state.
 * Using this function in a sequence will kill the sequence play-back. Do not use that
 * function to reset the display at sequence start-up.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetAll
{
    [self flushLayers];
    [self resetHiddenLayerFlags];
    return [self sendCommand:@"Z"];
}

/**
 * Forces an ePaper screen to perform a regenerative update using the slow
 * update method. Periodic use of the slow method (total panel update with
 * multiple inversions) prevents ghosting effects and improves contrast.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) regenerateDisplay
{
    return [self sendCommand:@"z"];
}

/**
 * Returns the current state of an ePaper display, specifically to
 * determine whether an update is in progress or whether a
 * configuration issue has been detected. If a display configuration
 * error has been detected, the error message can be retrieved.
 *
 * @param errmsg : a string passed by reference to receive the error message.
 *
 * @return a value among the enumeration YDisplay.DISPLAYSTATE
 *         (YDisplay.DISPLAYSTATE_FAILURE, YDisplay.DISPLAYSTATE_OFF,
 *         YDisplay.DISPLAYSTATE_POWERING, YDisplay.DISPLAYSTATE_IDLE,
 *         YDisplay.DISPLAYSTATE_REFRESHING)
 *         corresponding to the current display state.
 */
-(Y_DISPLAYSTATE) get_ePaperState:(NSString*)errmsg
{
    NSMutableData* json;
    NSString* jsonStr;
    NSString* dispError;
    int dispState;

    if ([self get_displayType] == Y_DISPLAYTYPE_MONO) {
        errmsg = @"Not an ePaper display";
        return (Y_DISPLAYSTATE) 0;
    }
    json = [self _download:@"disp.json"];
    if ((int)[json length] == 0) {
        errmsg = [self get_errorMessage];
        return (Y_DISPLAYSTATE) 0;
    } else {
        jsonStr = ARC_sendAutorelease([[NSString alloc] initWithData:json encoding:NSISOLatin1StringEncoding]);
        dispError = [self _decode_json_string:[self _get_json_path:jsonStr :@"err"]];
        errmsg = dispError;
        if ((int)[(dispError) length] > 0) {
            return (Y_DISPLAYSTATE) 0;
        }
        dispState = [[self _json_get_key:json :@"state"] intValue];
        if (dispState > 10) {
            return (Y_DISPLAYSTATE) 4;
        }
        if (dispState == 10) {
            return (Y_DISPLAYSTATE) 3;
        }
        if (dispState > 0) {
            return (Y_DISPLAYSTATE) 2;
        }
    }
    return (Y_DISPLAYSTATE) 1;
}

/**
 * Disables screen refresh for a short period of time. The combination of
 * postponeRefresh and triggerRefresh can be used as an
 * alternative to double-buffering to avoid flickering during display updates.
 *
 * @param duration : duration of deactivation in milliseconds (max. 30 seconds)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) postponeRefresh:(int)duration
{
    _frozenUntil = [YAPI GetTickCount] + duration;
    return [self sendCommand:[NSString stringWithFormat:@"H%d",duration]];
}

/**
 * Triggers an immediate screen refresh. The combination of
 * postponeRefresh and triggerRefresh can be used as an
 * alternative to double-buffering to avoid flickering during display updates.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerRefresh
{
    _frozenUntil = 0;
    [self flushLayers];
    return [self sendCommand:@"H0"];
}

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
-(int) fade:(int)brightness :(int)duration
{
    [self flushLayers];
    return [self sendCommand:[NSString stringWithFormat:@"+%d,%d",brightness,duration]];
}

/**
 * Starts to record all display commands into a sequence, for later replay.
 * The name used to store the sequence is specified when calling
 * saveSequence(), once the recording is complete.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) newSequence
{
    [self flushLayers];
    _sequence = @"";
    _recording = YES;
    return YAPI_SUCCESS;
}

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
-(int) saveSequence:(NSString*)sequenceName
{
    [self flushLayers];
    _recording = NO;
    [self _upload:sequenceName :[NSMutableData dataWithData:[_sequence dataUsingEncoding:NSISOLatin1StringEncoding]]];
    //We need to use YPRINTF("") for Objective-C
    _sequence = [NSString stringWithFormat:@""];
    return YAPI_SUCCESS;
}

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
-(int) playSequence:(NSString*)sequenceName
{
    [self flushLayers];
    return [self sendCommand:[NSString stringWithFormat:@"S%@",sequenceName]];
}

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
-(int) pauseSequence:(int)delay_ms
{
    [self flushLayers];
    return [self sendCommand:[NSString stringWithFormat:@"W%d",delay_ms]];
}

/**
 * Stops immediately any ongoing sequence replay.
 * The display is left as is.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) stopSequence
{
    [self flushLayers];
    return [self sendCommand:@"S"];
}

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
-(int) upload:(NSString*)pathname :(NSData*)content
{
    [self flushLayers];
    return [self _upload:pathname :content];
}

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
-(int) copyLayerContent:(int)srcLayerId :(int)dstLayerId
{
    [self flushLayers];
    return [self sendCommand:[NSString stringWithFormat:@"o%d,%d",srcLayerId,dstLayerId]];
}

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
-(int) swapLayerContent:(int)layerIdA :(int)layerIdB
{
    [self flushLayers];
    return [self sendCommand:[NSString stringWithFormat:@"E%d,%d",layerIdA,layerIdB]];
}

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
-(YDisplayLayer*) get_displayLayer:(int)layerId
{
    int layercount;
    int idx;
    layercount = [self get_layerCount];
    if (!((layerId >= 0) && (layerId < layercount))) {[self _throw:YAPI_INVALID_ARGUMENT:@"invalid DisplayLayer index"]; return nil;}
    if ((int)[_allDisplayLayers count] == 0) {
        idx = 0;
        while (idx < layercount) {
            [_allDisplayLayers addObject:ARC_sendAutorelease([[YDisplayLayer alloc] initWith:self :idx])];
            idx = idx + 1;
        }
    }
    return [_allDisplayLayers objectAtIndex:layerId];
}

/**
 * Returns a color image with the current content of the display.
 * The image is returned as a binary object, where each byte represents a pixel,
 * from left to right and from top to bottom. The palette used to map byte
 * values to RGB colors is filled into the list provided as argument.
 * In all cases, the first palette entry (value 0) corresponds to the
 * screen default background color.
 * The image dimensions are given by the display width and height.
 *
 * @param palette : a list to be filled with the image palette
 *
 * @return a binary object if the call succeeds.
 *
 * On failure, throws an exception or returns an empty binary object.
 */
-(NSMutableData*) readDisplay:(NSMutableArray*)palette
{
    NSMutableData* zipmap;
    int zipsize;
    int zipwidth;
    int zipheight;
    int ziprotate;
    int zipcolors;
    int zipcol;
    int zipbits;
    int zipmask;
    int srcpos;
    int endrun;
    int srcpat;
    int srcbit;
    int srcval;
    int srcx;
    int srcy;
    int srci;
    NSMutableData* pixmap;
    int pixcount;
    int pixval;
    int pixpos;
    NSMutableData* rotmap;
    pixmap = [NSMutableData dataWithLength:0];
    // Check if the display firmware has autoInvertDelay and pixels.bin support

    if ([self get_autoInvertDelay] < 0) {
        // Old firmware, use uncompressed GIF output to rebuild pixmap
        zipmap = [self _download:@"display.gif"];
        zipsize = (int)[zipmap length];
        if (zipsize == 0) {
            return pixmap;
        }
        if (!(zipsize >= 32)) {[self _throw:YAPI_IO_ERROR:@"not a GIF image"]; return pixmap;}
        if (!(((((u8*)([zipmap bytes]))[0]) == 71) && ((((u8*)([zipmap bytes]))[2]) == 70))) {[self _throw:YAPI_INVALID_ARGUMENT:@"not a GIF image"]; return pixmap;}
        zipwidth = (((u8*)([zipmap bytes]))[6]) + 256 * (((u8*)([zipmap bytes]))[7]);
        zipheight = (((u8*)([zipmap bytes]))[8]) + 256 * (((u8*)([zipmap bytes]))[9]);
        [palette removeAllObjects];
        zipcol = (((u8*)([zipmap bytes]))[13]) * 65536 + (((u8*)([zipmap bytes]))[14]) * 256 + (((u8*)([zipmap bytes]))[15]);
        [palette addObject:[NSNumber numberWithLong:zipcol]];
        zipcol = (((u8*)([zipmap bytes]))[16]) * 65536 + (((u8*)([zipmap bytes]))[17]) * 256 + (((u8*)([zipmap bytes]))[18]);
        [palette addObject:[NSNumber numberWithLong:zipcol]];
        pixcount = zipwidth * zipheight;
        pixmap = [NSMutableData dataWithLength:pixcount];
        pixpos = 0;
        srcpos = 30;
        zipsize = zipsize - 2;
        while (srcpos < zipsize) {
            // load next run size
            endrun = srcpos + 1 + (((u8*)([zipmap bytes]))[srcpos]);
            srcpos = srcpos + 1;
            while (srcpos < endrun) {
                srcval = (((u8*)([zipmap bytes]))[srcpos]);
                srcpos = srcpos + 1;
                srcbit = 8;
                while (srcbit != 0) {
                    if (srcbit < 3) {
                        srcval = srcval + ((((u8*)([zipmap bytes]))[srcpos]) << srcbit);
                        srcpos = srcpos + 1;
                    }
                    pixval = (srcval & 7);
                    srcval = (srcval >> 3);
                    if (!((pixval > 1) && (pixval != 4))) {[self _throw:YAPI_INVALID_ARGUMENT:@"unexpected encoding"]; return pixmap;}
                    (((u8*)([pixmap mutableBytes]))[pixpos]) = pixval;
                    pixpos = pixpos + 1;
                    srcbit = srcbit - 3;
                }
            }
        }
        return pixmap;
    }
    // New firmware, use compressed pixels.bin
    zipmap = [self _download:@"pixels.bin"];
    zipsize = (int)[zipmap length];
    if (zipsize == 0) {
        return pixmap;
    }
    if (!(zipsize >= 16)) {[self _throw:YAPI_IO_ERROR:@"not a pixmap"]; return pixmap;}
    if (!(((((u8*)([zipmap bytes]))[0]) == 80) && ((((u8*)([zipmap bytes]))[2]) == 88))) {[self _throw:YAPI_INVALID_ARGUMENT:@"not a pixmap"]; return pixmap;}
    zipwidth = (((u8*)([zipmap bytes]))[4]) + 256 * (((u8*)([zipmap bytes]))[5]);
    zipheight = (((u8*)([zipmap bytes]))[6]) + 256 * (((u8*)([zipmap bytes]))[7]);
    ziprotate = (((u8*)([zipmap bytes]))[8]);
    zipcolors = (((u8*)([zipmap bytes]))[9]);
    [palette removeAllObjects];
    srcpos = 10;
    srci = 0;
    while (srci < zipcolors) {
        zipcol = (((u8*)([zipmap bytes]))[srcpos]) * 65536 + (((u8*)([zipmap bytes]))[srcpos+1]) * 256 + (((u8*)([zipmap bytes]))[srcpos+2]);
        [palette addObject:[NSNumber numberWithLong:zipcol]];
        srcpos = srcpos + 3;
        srci = srci + 1;
    }
    zipbits = 1;
    while ((1 << zipbits) < zipcolors) {
        zipbits = zipbits + 1;
    }
    zipmask = (1 << zipbits) - 1;
    pixcount = zipwidth * zipheight;
    pixmap = [NSMutableData dataWithLength:pixcount];
    srcx = 0;
    srcy = 0;
    srcval = 0;
    while (srcpos < zipsize) {
        // load next compression pattern byte
        srcpat = (((u8*)([zipmap bytes]))[srcpos]);
        srcpos = srcpos + 1;
        srcbit = 7;
        while (srcbit >= 0) {
            // get next bitmap byte
            if ((srcpat & 128) != 0) {
                srcval = (((u8*)([zipmap bytes]))[srcpos]);
                srcpos = srcpos + 1;
                if (zipbits > 1) {
                    srcval = (srcval << 8) + (((u8*)([zipmap bytes]))[srcpos]);
                    srcpos = srcpos + 1;
                }
            }
            srcpat = (srcpat << 1);
            pixpos = srcy * zipwidth + srcx;
            // produce 8 pixels
            srci = 7 * zipbits;
            while (srci >= 0) {
                pixval = ((srcval >> srci) & zipmask);
                (((u8*)([pixmap mutableBytes]))[pixpos]) = pixval;
                pixpos = pixpos + 1;
                srci = srci - zipbits;
            }
            srcy = srcy + 1;
            if (srcy >= zipheight) {
                srcy = 0;
                srcx = srcx + 8;
                // drop last bytes if image is not a multiple of 8
                if (srcx >= zipwidth) {
                    srcbit = 0;
                }
            }
            srcbit = srcbit - 1;
        }
    }
    // rotate pixmap to match display orientation
    if (ziprotate == 0) {
        return pixmap;
    }
    if ((ziprotate & 2) != 0) {
        // rotate buffer 180 degrees by swapping pixels
        srcpos = 0;
        pixpos = pixcount - 1;
        while (srcpos < pixpos) {
            pixval = (((u8*)([pixmap bytes]))[srcpos]);
            (((u8*)([pixmap mutableBytes]))[srcpos]) = (((u8*)([pixmap bytes]))[pixpos]);
            (((u8*)([pixmap mutableBytes]))[pixpos]) = pixval;
            srcpos = srcpos + 1;
            pixpos = pixpos - 1;
        }
    }
    if ((ziprotate & 1) == 0) {
        return pixmap;
    }
    // rotate 90 ccw: first pixel is bottom left
    rotmap = [NSMutableData dataWithLength:pixcount];
    srcx = 0;
    srcy = zipwidth - 1;
    srcpos = 0;
    while (srcpos < pixcount) {
        pixval = (((u8*)([pixmap bytes]))[srcpos]);
        pixpos = srcy * zipheight + srcx;
        (((u8*)([rotmap mutableBytes]))[pixpos]) = pixval;
        srcy = srcy - 1;
        if (srcy < 0) {
            srcx = srcx + 1;
            srcy = zipwidth - 1;
        }
        srcpos = srcpos + 1;
    }
    return rotmap;
}


-(YDisplay*)   nextDisplay
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDisplay FindDisplay:hwid];
}

+(YDisplay *) FirstDisplay
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Display":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDisplay FindDisplay:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YDisplay public methods implementation)





@end
//--- (generated code: YDisplay functions)

YDisplay *yFindDisplay(NSString* func)
{
    return [YDisplay FindDisplay:func];
}

YDisplay *yFirstDisplay(void)
{
    return [YDisplay FirstDisplay];
}

//--- (end of generated code: YDisplay functions)
