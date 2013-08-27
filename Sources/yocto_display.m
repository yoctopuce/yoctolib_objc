/*********************************************************************
 *
 * $Id: yocto_display.m 12326 2013-08-13 15:52:20Z mvuilleu $
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

//--- (generated code: YDisplayLayer attributes)
//--- (end of generated code: YDisplayLayer attributes)

-(id)   initWithDisplay:(YDisplay *)display andLayerID:(int)layerid
{
    if(!(self = [super init]))
        return nil;
    _display =display;
    _id = layerid;
    _cmdbuff =[[NSMutableString alloc] init];
    return self;
}



-(int) flush_now
{
    int res = YAPI_SUCCESS;
    if([_cmdbuff length] > 0) {
        res = [_display sendCommand:_cmdbuff];
        [_cmdbuff setString:@""];
    }
    return res;
}


// internal function to send a command for this layer
-(int) command_push:(NSString*)cmd
{
    int res = YAPI_SUCCESS;
    
    if([_cmdbuff length] + [cmd length] >= 100) {
        // force flush before, to prevent overflow
        res = [self flush_now];
    }
    if([_cmdbuff length] == 0) {
        // always prepend layer ID first
        [_cmdbuff appendString: [NSString stringWithFormat:@"%d",_id]];
    }
    [_cmdbuff appendString:cmd];
    return res;
}

// internal function to send a command for this layer
-(int) command_flush:(NSString*)cmd
{
    int  res = [self command_push:cmd];
    if(_hidden) {
        return res;
    }
    return [self flush_now];
}



//--- (generated code: YDisplayLayer implementation)

/**
 * Reverts the layer to its initial state (fully transparent, default settings).
 * Reinitializes the drawing pointer to the upper left position,
 * and selects the most visible pen color. If you only want to erase the layer
 * content, use the method clear() instead.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    _hidden = FALSE; 
    return [self command_flush:@"X"]; 
    
}

/**
 * Erases the whole content of the layer (makes it fully transparent).
 * This method does not change any other attribute of the layer.
 * To reinitialize the layer attributes to defaults settings, use the method
 * reset() instead.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) clear
{
    return [self command_flush:@"x"];
}

/**
 * Selects the pen color for all subsequent drawing functions,
 * including text drawing. The pen color is provided as an RGB value.
 * For grayscale or monochrome displays, the value is
 * automatically converted to the proper range.
 * 
 * @param color: the desired pen color, as a 24-bit RGB value
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectColorPen :(int)color
{
    return [self command_push:[NSString stringWithFormat:@"c%06x",color]];
}

/**
 * Selects the pen gray level for all subsequent drawing functions,
 * including text drawing. The gray level is provided as a number between
 * 0 (black) and 255 (white, or whichever the lighest color is).
 * For monochrome displays (without gray levels), any value
 * lower than 128 is rendered as black, and any value equal
 * or above to 128 is non-black.
 * 
 * @param graylevel: the desired gray level, from 0 to 255
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectGrayPen :(int)graylevel
{
    return [self command_push:[NSString stringWithFormat:@"g%d",graylevel]];
}

/**
 * Selects an eraser instead of a pen for all subsequent drawing functions,
 * except for text drawing and bitmap copy functions. Any point drawn
 * using the eraser becomes transparent (as when the layer is empty),
 * showing the other layers beneath it.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectEraser
{
    return [self command_push:@"e"];
}

/**
 * Enables or disables anti-aliasing for drawing oblique lines and circles.
 * Anti-aliasing provides a smoother aspect when looked from far enough,
 * but it can add fuzzyness when the display is looked from very close.
 * At the end of the day, it is your personal choice.
 * Anti-aliasing is enabled by default on grayscale and color displays,
 * but you can disable it if you prefer. This setting has no effect
 * on monochrome displays.
 * 
 * @param mode: <t>true</t> to enable antialiasing, <t>false</t> to
 *         disable it.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setAntialiasingMode :(bool)mode
{
    return [self command_push:[NSString stringWithFormat:@"a%d",mode]];
}

/**
 * Draws a single pixel at the specified position.
 * 
 * @param x: the distance from left of layer, in pixels
 * @param y: the distance from top of layer, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawPixel :(int)x :(int)y
{
    return [self command_flush:[NSString stringWithFormat:@"P%d,%d",x,y]];
}

/**
 * Draws an empty rectangle at a specified position.
 * 
 * @param x1: the distance from left of layer to the left border of the rectangle, in pixels
 * @param y1: the distance from top of layer to the top border of the rectangle, in pixels
 * @param x2: the distance from left of layer to the right border of the rectangle, in pixels
 * @param y2: the distance from top of layer to the bottom border of the rectangle, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawRect :(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_flush:[NSString stringWithFormat:@"R%d,%d,%d,%d",x1,y1,x2,y2]];
}

/**
 * Draws a filled rectangular bar at a specified position.
 * 
 * @param x1: the distance from left of layer to the left border of the rectangle, in pixels
 * @param y1: the distance from top of layer to the top border of the rectangle, in pixels
 * @param x2: the distance from left of layer to the right border of the rectangle, in pixels
 * @param y2: the distance from top of layer to the bottom border of the rectangle, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawBar :(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_flush:[NSString stringWithFormat:@"B%d,%d,%d,%d",x1,y1,x2,y2]];
}

/**
 * Draws an empty circle at a specified position.
 * 
 * @param x: the distance from left of layer to the center of the circle, in pixels
 * @param y: the distance from top of layer to the center of the circle, in pixels
 * @param r: the radius of the circle, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawCircle :(int)x :(int)y :(int)r
{
    return [self command_flush:[NSString stringWithFormat:@"C%d,%d,%d",x,y,r]];
}

/**
 * Draws a filled disc at a given position.
 * 
 * @param x: the distance from left of layer to the center of the disc, in pixels
 * @param y: the distance from top of layer to the center of the disc, in pixels
 * @param r: the radius of the disc, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawDisc :(int)x :(int)y :(int)r
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
 * @param fontname: the font file name
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectFont :(NSString*)fontname
{
    return [self command_push:[NSString stringWithFormat:@"&%@%c",fontname,27]];
}

/**
 * Draws a text string at the specified position. The point of the text that is aligned
 * to the specified pixel position is called the anchor point, and can be chosen among
 * several options. Text is rendered from left to right, without implicit wrapping.
 * 
 * @param x: the distance from left of layer to the text ancor point, in pixels
 * @param y: the distance from top of layer to the text ancor point, in pixels
 * @param anchor: the text anchor point, chosen among the Y_ALIGN enumeration:
 *         Y_ALIGN_TOP_LEFT,    Y_ALIGN_CENTER_LEFT,    Y_ALIGN_BASELINE_LEFT,    Y_ALIGN_BOTTOM_LEFT,
 *         Y_ALIGN_TOP_CENTER,  Y_ALIGN_CENTER,         Y_ALIGN_BASELINE_CENTER,  Y_ALIGN_BOTTOM_CENTER,
 *         Y_ALIGN_TOP_DECIMAL, Y_ALIGN_CENTER_DECIMAL, Y_ALIGN_BASELINE_DECIMAL, Y_ALIGN_BOTTOM_DECIMAL,
 *         Y_ALIGN_TOP_RIGHT,   Y_ALIGN_CENTER_RIGHT,   Y_ALIGN_BASELINE_RIGHT,   Y_ALIGN_BOTTOM_RIGHT.
 * @param text: the text string to draw
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawText :(int)x :(int)y :(Y_ALIGN)anchor :(NSString*)text
{
    return [self command_flush:[NSString stringWithFormat:@"T%d,%d,%d,%@%c",x,y,anchor,text,27]];
}

/**
 * Draws a GIF image at the specified position. The GIF image must have been previously
 * uploaded to the device built-in memory. If you experience problems using an image
 * file, check the device logs for any error message such as missing image file or bad
 * image file format.
 * 
 * @param x: the distance from left of layer to the left of the image, in pixels
 * @param y: the distance from top of layer to the top of the image, in pixels
 * @param imagename: the GIF file name
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawImage :(int)x :(int)y :(NSString*)imagename
{
    return [self command_flush:[NSString stringWithFormat:@"*%d,%d,%@%c",x,y,imagename,27]];
    
}

/**
 * Draws a bitmap at the specified position. The bitmap is provided as a binary object,
 * where each pixel maps to a bit, from left to right and from top to bottom.
 * The most significant bit of each byte maps to the leftmost pixel, and the least
 * significant bit maps to the rightmost pixel. Bits set to 1 are drawn using the
 * layer selected pen color. Bits set to 0 are drawn using the specified background
 * gray level, unless -1 is specified, in which case they are not drawn at all
 * (as if transparent).
 * 
 * @param x: the distance from left of layer to the left of the bitmap, in pixels
 * @param y: the distance from top of layer to the top of the bitmap, in pixels
 * @param w: the width of the bitmap, in pixels
 * @param bitmap: a binary object
 * @param bgcol: the background gray level to use for zero bits (0 = black,
 *         255 = white), or -1 to leave the pixels unchanged
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) drawBitmap :(int)x :(int)y :(int)w :(NSData*)bitmap :(int)bgcol
{
    NSString* destname;
    destname = [NSString stringWithFormat:@"layer%d:%d,%d@%d,%d",_id,w,bgcol,x,y];
    return [_display upload:destname :bitmap];
    
}

/**
 * Moves the drawing pointer of this layer to the specified position.
 * 
 * @param x: the distance from left of layer, in pixels
 * @param y: the distance from top of layer, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) moveTo :(int)x :(int)y
{
    return [self command_push:[NSString stringWithFormat:@"@%d,%d",x,y]];
}

/**
 * Draws a line from current drawing pointer position to the specified position.
 * The specified destination pixel is included in the line. The pointer position
 * is then moved to the end point of the line.
 * 
 * @param x: the distance from left of layer to the end point of the line, in pixels
 * @param y: the distance from top of layer to the end point of the line, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) lineTo :(int)x :(int)y
{
    return [self command_flush:[NSString stringWithFormat:@"-%d,%d",x,y]];
}

/**
 * Outputs a message in the console area, and advances the console pointer accordingly.
 * The console pointer position is automatically moved to the beginning
 * of the next line when a newline character is met, or when the right margin
 * is hit. When the new text to display extends below the lower margin, the
 * console area is automatically scrolled up.
 * 
 * @param text: the message to display
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) consoleOut :(NSString*)text
{
    return [self command_flush:[NSString stringWithFormat:@"!%@%c",text,27]];
}

/**
 * Sets up display margins for the consoleOut function.
 * 
 * @param x1: the distance from left of layer to the left margin, in pixels
 * @param y1: the distance from top of layer to the top margin, in pixels
 * @param x2: the distance from left of layer to the right margin, in pixels
 * @param y2: the distance from top of layer to the bottom margin, in pixels
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setConsoleMargins :(int)x1 :(int)y1 :(int)x2 :(int)y2
{
    return [self command_push:[NSString stringWithFormat:@"m%d,%d,%d,%d",x1,y1,x2,y2]]; 
    
}

/**
 * Sets up the background color used by the clearConsole function and by
 * the console scrolling feature.
 * 
 * @param bgcol: the background gray level to use when scrolling (0 = black,
 *         255 = white), or -1 for transparent
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setConsoleBackground :(int)bgcol
{
    return [self command_push:[NSString stringWithFormat:@"b%d",bgcol]]; 
    
}

/**
 * Sets up the wrapping behaviour used by the consoleOut function.
 * 
 * @param wordwrap: true to wrap only between words,
 *         false to wrap on the last column anyway.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setConsoleWordWrap :(bool)wordwrap
{
    return [self command_push:[NSString stringWithFormat:@"w%d",wordwrap]]; 
    
}

/**
 * Blanks the console area within console margins, and resets the console pointer
 * to the upper left corner of the console.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * @param x: the distance from left of display to the upper left corner of the layer
 * @param y: the distance from top of display to the upper left corner of the layer
 * @param scrollTime: number of milliseconds to use for smooth scrolling, or
 *         0 if the scrolling should be immediate.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setLayerPosition :(int)x :(int)y :(int)scrollTime
{
    return [self command_flush:[NSString stringWithFormat:@"#%d,%d,%d",x,y,scrollTime]]; 
    
}

/**
 * Hides the layer. The state of the layer is perserved but the layer is not displayed
 * on the screen until the next call to unhide(). Hiding the layer can positively
 * affect the drawing speed, since it postpones the rendering until all operations are
 * completed (double-buffering).
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) hide
{
    [self command_push:@"h"]; 
    _hidden = TRUE; 
    return [self flush_now]; 
    
}

/**
 * Shows the layer. Shows the layer again after a hide command.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) unhide
{
    _hidden = FALSE; 
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

-(int) resetHiddenFlag
{
    _hidden = FALSE; 
    return YAPI_SUCCESS;
    
}

//--- (end of generated code: YDisplayLayer implementation)

@end
//--- (generated code: DisplayLayer functions)
//--- (end of generated code: DisplayLayer functions)




@implementation YDisplay

// Constructor is protected, use yFindDisplay factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (generated code: YDisplay attributes)
   if(!(self = [super initProtected:@"Display":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _powerState = Y_POWERSTATE_INVALID;
    _startupSeq = Y_STARTUPSEQ_INVALID;
    _brightness = Y_BRIGHTNESS_INVALID;
    _orientation = Y_ORIENTATION_INVALID;
    _displayWidth = Y_DISPLAYWIDTH_INVALID;
    _displayHeight = Y_DISPLAYHEIGHT_INVALID;
    _displayType = Y_DISPLAYTYPE_INVALID;
    _layerWidth = Y_LAYERWIDTH_INVALID;
    _layerHeight = Y_LAYERHEIGHT_INVALID;
    _layerCount = Y_LAYERCOUNT_INVALID;
    _command = Y_COMMAND_INVALID;
//--- (end of generated code: YDisplay attributes)
    _sequence = [[NSString alloc] init];
    _allDisplayLayers =[[NSMutableArray alloc] init];
    return self;
}


-(void) dealloc
{
    //--- (generated code: YDisplay cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_release(_startupSeq);
    _startupSeq = nil;
    ARC_release(_command);
    _command = nil;
//--- (end of generated code: YDisplay cleanup)
    [super dealloc];
}



//--- (generated code: YDisplay implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "powerState")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _powerState =  (Y_POWERSTATE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "startupSeq")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_startupSeq);
            _startupSeq =  [self _parseString:j];
            ARC_retain(_startupSeq);
        } else if(!strcmp(j->token, "brightness")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _brightness =  atoi(j->token);
        } else if(!strcmp(j->token, "orientation")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _orientation =  atoi(j->token);
        } else if(!strcmp(j->token, "displayWidth")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _displayWidth =  atoi(j->token);
        } else if(!strcmp(j->token, "displayHeight")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _displayHeight =  atoi(j->token);
        } else if(!strcmp(j->token, "displayType")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _displayType =  atoi(j->token);
        } else if(!strcmp(j->token, "layerWidth")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _layerWidth =  atoi(j->token);
        } else if(!strcmp(j->token, "layerHeight")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _layerHeight =  atoi(j->token);
        } else if(!strcmp(j->token, "layerCount")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _layerCount =  atoi(j->token);
        } else if(!strcmp(j->token, "command")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_command);
            _command =  [self _parseString:j];
            ARC_retain(_command);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the display.
 * 
 * @return a string corresponding to the logical name of the display
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * Changes the logical name of the display. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the display
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the display (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the display (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the power state of the display.
 * 
 * @return either Y_POWERSTATE_OFF or Y_POWERSTATE_ON, according to the power state of the display
 * 
 * On failure, throws an exception or returns Y_POWERSTATE_INVALID.
 */
-(Y_POWERSTATE_enum) get_powerState
{
    return [self powerState];
}
-(Y_POWERSTATE_enum) powerState
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_POWERSTATE_INVALID;
    }
    return _powerState;
}

/**
 * Changes the power state of the display.
 * 
 * @param newval : either Y_POWERSTATE_OFF or Y_POWERSTATE_ON, according to the power state of the display
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerState:(Y_POWERSTATE_enum) newval
{
    return [self setPowerState:newval];
}
-(int) setPowerState:(Y_POWERSTATE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"powerState" :rest_val];
}

/**
 * Returns the name of the sequence to play when the displayed is powered on.
 * 
 * @return a string corresponding to the name of the sequence to play when the displayed is powered on
 * 
 * On failure, throws an exception or returns Y_STARTUPSEQ_INVALID.
 */
-(NSString*) get_startupSeq
{
    return [self startupSeq];
}
-(NSString*) startupSeq
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_STARTUPSEQ_INVALID;
    }
    return _startupSeq;
}

/**
 * Changes the name of the sequence to play when the displayed is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the name of the sequence to play when the displayed is powered on
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns the luminosity of the  module informative leds (from 0 to 100).
 * 
 * @return an integer corresponding to the luminosity of the  module informative leds (from 0 to 100)
 * 
 * On failure, throws an exception or returns Y_BRIGHTNESS_INVALID.
 */
-(int) get_brightness
{
    return [self brightness];
}
-(int) brightness
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_BRIGHTNESS_INVALID;
    }
    return _brightness;
}

/**
 * Changes the brightness of the display. The parameter is a value between 0 and
 * 100. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : an integer corresponding to the brightness of the display
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"brightness" :rest_val];
}

/**
 * Returns the currently selected display orientation.
 * 
 * @return a value among Y_ORIENTATION_LEFT, Y_ORIENTATION_UP, Y_ORIENTATION_RIGHT and
 * Y_ORIENTATION_DOWN corresponding to the currently selected display orientation
 * 
 * On failure, throws an exception or returns Y_ORIENTATION_INVALID.
 */
-(Y_ORIENTATION_enum) get_orientation
{
    return [self orientation];
}
-(Y_ORIENTATION_enum) orientation
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ORIENTATION_INVALID;
    }
    return _orientation;
}

/**
 * Changes the display orientation. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 * 
 * @param newval : a value among Y_ORIENTATION_LEFT, Y_ORIENTATION_UP, Y_ORIENTATION_RIGHT and
 * Y_ORIENTATION_DOWN corresponding to the display orientation
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"orientation" :rest_val];
}

/**
 * Returns the display width, in pixels.
 * 
 * @return an integer corresponding to the display width, in pixels
 * 
 * On failure, throws an exception or returns Y_DISPLAYWIDTH_INVALID.
 */
-(unsigned) get_displayWidth
{
    return [self displayWidth];
}
-(unsigned) displayWidth
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_DISPLAYWIDTH_INVALID;
    }
    return _displayWidth;
}

/**
 * Returns the display height, in pixels.
 * 
 * @return an integer corresponding to the display height, in pixels
 * 
 * On failure, throws an exception or returns Y_DISPLAYHEIGHT_INVALID.
 */
-(unsigned) get_displayHeight
{
    return [self displayHeight];
}
-(unsigned) displayHeight
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_DISPLAYHEIGHT_INVALID;
    }
    return _displayHeight;
}

/**
 * Returns the display type: monochrome, gray levels or full color.
 * 
 * @return a value among Y_DISPLAYTYPE_MONO, Y_DISPLAYTYPE_GRAY and Y_DISPLAYTYPE_RGB corresponding to
 * the display type: monochrome, gray levels or full color
 * 
 * On failure, throws an exception or returns Y_DISPLAYTYPE_INVALID.
 */
-(Y_DISPLAYTYPE_enum) get_displayType
{
    return [self displayType];
}
-(Y_DISPLAYTYPE_enum) displayType
{
    if(_displayType == Y_DISPLAYTYPE_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_DISPLAYTYPE_INVALID;
    }
    return _displayType;
}

/**
 * Returns the width of the layers to draw on, in pixels.
 * 
 * @return an integer corresponding to the width of the layers to draw on, in pixels
 * 
 * On failure, throws an exception or returns Y_LAYERWIDTH_INVALID.
 */
-(unsigned) get_layerWidth
{
    return [self layerWidth];
}
-(unsigned) layerWidth
{
    if(_layerWidth == Y_LAYERWIDTH_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LAYERWIDTH_INVALID;
    }
    return _layerWidth;
}

/**
 * Returns the height of the layers to draw on, in pixels.
 * 
 * @return an integer corresponding to the height of the layers to draw on, in pixels
 * 
 * On failure, throws an exception or returns Y_LAYERHEIGHT_INVALID.
 */
-(unsigned) get_layerHeight
{
    return [self layerHeight];
}
-(unsigned) layerHeight
{
    if(_layerHeight == Y_LAYERHEIGHT_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LAYERHEIGHT_INVALID;
    }
    return _layerHeight;
}

/**
 * Returns the number of available layers to draw on.
 * 
 * @return an integer corresponding to the number of available layers to draw on
 * 
 * On failure, throws an exception or returns Y_LAYERCOUNT_INVALID.
 */
-(unsigned) get_layerCount
{
    return [self layerCount];
}
-(unsigned) layerCount
{
    if(_layerCount == Y_LAYERCOUNT_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LAYERCOUNT_INVALID;
    }
    return _layerCount;
}

-(NSString*) get_command
{
    return [self command];
}
-(NSString*) command
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_COMMAND_INVALID;
    }
    return _command;
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
 * Clears the display screen and resets all display layers to their default state.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Smoothly changes the brightness of the screen to produce a fade-in or fade-out
 * effect.
 * 
 * @param brightness: the new screen brightness
 * @param duration: duration of the brightness transition, in milliseconds.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) fade :(int)brightness :(int)duration
{
    [self flushLayers]; 
    return [self sendCommand:[NSString stringWithFormat:@"+%d,%d",brightness,duration]]; 
    
}

/**
 * Starts to record all display commands into a sequence, for later replay.
 * The name used to store the sequence is specified when calling
 * saveSequence(), once the recording is complete.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) newSequence
{
    [self flushLayers];
    _sequence = @""; 
    _recording = TRUE; 
    return YAPI_SUCCESS; 
    
}

/**
 * Stops recording display commands and saves the sequence into the specified
 * file on the display internal memory. The sequence can be later replayed
 * using playSequence().
 * 
 * @param sequenceName : the name of the newly created sequence
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) saveSequence :(NSString*)sequenceName
{
    [self flushLayers];
    _recording = FALSE; 
    [self _upload:sequenceName : [_sequence dataUsingEncoding:NSUTF8StringEncoding]];
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
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) playSequence :(NSString*)sequenceName
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
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pauseSequence :(int)delay_ms
{
    [self flushLayers]; 
    return [self sendCommand:[NSString stringWithFormat:@"W%d",delay_ms]]; 
    
}

/**
 * Stops immediately any ongoing sequence replay.
 * The display is left as is.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) upload :(NSString*)pathname :(NSData*)content
{
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
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) copyLayerContent :(int)srcLayerId :(int)dstLayerId
{
    [self flushLayers]; 
    return [self sendCommand:[NSString stringWithFormat:@"o%d,%d",srcLayerId,dstLayerId]]; 
    
}

/**
 * Swaps the whole content of two layers. The color and transparency of all the pixels from
 * the two layers are swapped. This method only affects the displayed content, but does
 * not change any property of the layer objects. In particular, the visibility of each
 * layer stays unchanged. When used between onae hidden layer and a visible layer,
 * this method makes it possible to easily implement double-buffering.
 * Note that layer 0 has no transparency support (it is always completely opaque).
 * 
 * @param layerIdA : the first layer (a number in range 0..layerCount-1)
 * @param layerIdB : the second layer (a number in range 0..layerCount-1)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) swapLayerContent :(int)layerIdA :(int)layerIdB
{
    [self flushLayers]; 
    return [self sendCommand:[NSString stringWithFormat:@"E%d,%d",layerIdA,layerIdB]]; 
    
}


-(YDisplay*)   nextDisplay
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindDisplay(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YDisplay*) FindDisplay:(NSString*) func
{
    YDisplay * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YDisplay"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YDisplay"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YDisplay"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YDisplay"] objectForKey:func];
    } else {
        retVal = [[YDisplay alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YDisplay"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of generated code: YDisplay implementation)

/**
 * Returns a YDisplayLayer object that can be used to draw on the specified
 * layer. The content is displayed only when the layer is active on the
 * screen (and not masked by other overlapping layers).
 * 
 * @param layerId : the identifier of the layer (a number in range 0..layerCount-1)
 * 
 * @return an YDisplayLayer object
 * 
 * On failure, throws an exception or returns null.
 */

-(YDisplayLayer*) get_displayLayer:(unsigned) layerId
{
    if([_allDisplayLayers count]==0) {
        unsigned nb_display_layer = [self get_layerCount];
        for(unsigned i = 0; i < nb_display_layer; i++) {
            YDisplayLayer *layer =[[YDisplayLayer alloc] initWithDisplay:self andLayerID:i];
            [_allDisplayLayers addObject:layer];
            ARC_release(layer);
        }
    }
    if(layerId >= [_allDisplayLayers count]) {
        [self _throw:YAPI_INVALID_ARGUMENT withMsg:"Invalid layerId"];
        return NULL;
    }
    return [_allDisplayLayers objectAtIndex:layerId];
}

-(int) flushLayers
{
    for(unsigned i = 0; i < [_allDisplayLayers count]; i++) {
        [[_allDisplayLayers objectAtIndex:i] flush_now];
    }
    return YAPI_SUCCESS;
    
}

-(void) resetHiddenLayerFlags
{
    for(unsigned i = 0; i < [_allDisplayLayers count]; i++) {
        [[_allDisplayLayers objectAtIndex:i] resetHiddenFlag];
    }
}

-(int) sendCommand:(NSString*) cmd
{
    if(!_recording) {
        return [self set_command:cmd];
    }
    _sequence = [_sequence stringByAppendingFormat:@"%@\n",cmd];
    return YAPI_SUCCESS;
    
}



@end
//--- (generated code: Display functions)

YDisplay *yFindDisplay(NSString* func)
{
    return [YDisplay FindDisplay:func];
}

YDisplay *yFirstDisplay(void)
{
    return [YDisplay FirstDisplay];
}

//--- (end of generated code: Display functions)
