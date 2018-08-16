/*********************************************************************
 *
 * $Id: yocto_colorled.m 31436 2018-08-07 15:28:18Z seb $
 *
 * Implements the high-level API for ColorLed functions
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


#import "yocto_colorled.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YColorLed

// Constructor is protected, use yFindColorLed factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"ColorLed";
//--- (YColorLed attributes initialization)
    _rgbColor = Y_RGBCOLOR_INVALID;
    _hslColor = Y_HSLCOLOR_INVALID;
    _rgbMove = Y_RGBMOVE_INVALID;
    _hslMove = Y_HSLMOVE_INVALID;
    _rgbColorAtPowerOn = Y_RGBCOLORATPOWERON_INVALID;
    _blinkSeqSize = Y_BLINKSEQSIZE_INVALID;
    _blinkSeqMaxSize = Y_BLINKSEQMAXSIZE_INVALID;
    _blinkSeqSignature = Y_BLINKSEQSIGNATURE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackColorLed = NULL;
//--- (end of YColorLed attributes initialization)
    return self;
}
//--- (YColorLed yapiwrapper)
//--- (end of YColorLed yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YColorLed cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YColorLed cleanup)
}
//--- (YColorLed private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "rgbColor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rgbColor =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "hslColor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _hslColor =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rgbMove")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        if(j->st == YJSON_PARSE_STRUCT) {
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _rgbMove.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _rgbMove.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _rgbMove.ms = atoi(j->token);
                }
            }
        }
        return 1;
    }
    if(!strcmp(j->token, "hslMove")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        if(j->st == YJSON_PARSE_STRUCT) {
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _hslMove.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _hslMove.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) == YJSON_PARSE_AVAIL)
                        _hslMove.ms = atoi(j->token);
                }
            }
        }
        return 1;
    }
    if(!strcmp(j->token, "rgbColorAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rgbColorAtPowerOn =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinkSeqSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinkSeqSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinkSeqMaxSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinkSeqMaxSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinkSeqSignature")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinkSeqSignature =  atoi(j->token);
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
//--- (end of YColorLed private methods implementation)
//--- (YColorLed public methods implementation)
/**
 * Returns the current RGB color of the LED.
 *
 * @return an integer corresponding to the current RGB color of the LED
 *
 * On failure, throws an exception or returns Y_RGBCOLOR_INVALID.
 */
-(int) get_rgbColor
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RGBCOLOR_INVALID;
        }
    }
    res = _rgbColor;
    return res;
}


-(int) rgbColor
{
    return [self get_rgbColor];
}

/**
 * Changes the current color of the LED, using an RGB color. Encoding is done as follows: 0xRRGGBB.
 *
 * @param newval : an integer corresponding to the current color of the LED, using an RGB color
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColor:(int) newval
{
    return [self setRgbColor:newval];
}
-(int) setRgbColor:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"rgbColor" :rest_val];
}
/**
 * Returns the current HSL color of the LED.
 *
 * @return an integer corresponding to the current HSL color of the LED
 *
 * On failure, throws an exception or returns Y_HSLCOLOR_INVALID.
 */
-(int) get_hslColor
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_HSLCOLOR_INVALID;
        }
    }
    res = _hslColor;
    return res;
}


-(int) hslColor
{
    return [self get_hslColor];
}

/**
 * Changes the current color of the LED, using a color HSL. Encoding is done as follows: 0xHHSSLL.
 *
 * @param newval : an integer corresponding to the current color of the LED, using a color HSL
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColor:(int) newval
{
    return [self setHslColor:newval];
}
-(int) setHslColor:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"hslColor" :rest_val];
}
-(YMove) get_rgbMove
{
    YMove res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RGBMOVE_INVALID;
        }
    }
    res = _rgbMove;
    return res;
}


-(YMove) rgbMove
{
    return [self get_rgbMove];
}

-(int) set_rgbMove:(YMove) newval
{
    return [self setRgbMove:newval];
}
-(int) setRgbMove:(YMove) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",newval.target,newval.ms];
    return [self _setAttr:@"rgbMove" :rest_val];
}

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
-(int) rgbMove:(int)rgb_target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",rgb_target,ms_duration];
    return [self _setAttr:@"rgbMove" :rest_val];
}
-(YMove) get_hslMove
{
    YMove res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_HSLMOVE_INVALID;
        }
    }
    res = _hslMove;
    return res;
}


-(YMove) hslMove
{
    return [self get_hslMove];
}

-(int) set_hslMove:(YMove) newval
{
    return [self setHslMove:newval];
}
-(int) setHslMove:(YMove) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",newval.target,newval.ms];
    return [self _setAttr:@"hslMove" :rest_val];
}

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
-(int) hslMove:(int)hsl_target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",hsl_target,ms_duration];
    return [self _setAttr:@"hslMove" :rest_val];
}
/**
 * Returns the configured color to be displayed when the module is turned on.
 *
 * @return an integer corresponding to the configured color to be displayed when the module is turned on
 *
 * On failure, throws an exception or returns Y_RGBCOLORATPOWERON_INVALID.
 */
-(int) get_rgbColorAtPowerOn
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RGBCOLORATPOWERON_INVALID;
        }
    }
    res = _rgbColorAtPowerOn;
    return res;
}


-(int) rgbColorAtPowerOn
{
    return [self get_rgbColorAtPowerOn];
}

/**
 * Changes the color that the LED will display by default when the module is turned on.
 *
 * @param newval : an integer corresponding to the color that the LED will display by default when the
 * module is turned on
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColorAtPowerOn:(int) newval
{
    return [self setRgbColorAtPowerOn:newval];
}
-(int) setRgbColorAtPowerOn:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"rgbColorAtPowerOn" :rest_val];
}
/**
 * Returns the current length of the blinking sequence.
 *
 * @return an integer corresponding to the current length of the blinking sequence
 *
 * On failure, throws an exception or returns Y_BLINKSEQSIZE_INVALID.
 */
-(int) get_blinkSeqSize
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKSEQSIZE_INVALID;
        }
    }
    res = _blinkSeqSize;
    return res;
}


-(int) blinkSeqSize
{
    return [self get_blinkSeqSize];
}
/**
 * Returns the maximum length of the blinking sequence.
 *
 * @return an integer corresponding to the maximum length of the blinking sequence
 *
 * On failure, throws an exception or returns Y_BLINKSEQMAXSIZE_INVALID.
 */
-(int) get_blinkSeqMaxSize
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKSEQMAXSIZE_INVALID;
        }
    }
    res = _blinkSeqMaxSize;
    return res;
}


-(int) blinkSeqMaxSize
{
    return [self get_blinkSeqMaxSize];
}
/**
 * Return the blinking sequence signature. Since blinking
 * sequences cannot be read from the device, this can be used
 * to detect if a specific blinking sequence is already
 * programmed.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_BLINKSEQSIGNATURE_INVALID.
 */
-(int) get_blinkSeqSignature
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKSEQSIGNATURE_INVALID;
        }
    }
    res = _blinkSeqSignature;
    return res;
}


-(int) blinkSeqSignature
{
    return [self get_blinkSeqSignature];
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
 * @param func : a string that uniquely characterizes the RGB LED
 *
 * @return a YColorLed object allowing you to drive the RGB LED.
 */
+(YColorLed*) FindColorLed:(NSString*)func
{
    YColorLed* obj;
    obj = (YColorLed*) [YFunction _FindFromCache:@"ColorLed" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YColorLed alloc] initWith:func]);
        [YFunction _AddToCache:@"ColorLed" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YColorLedValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackColorLed = callback;
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
    if (_valueCallbackColorLed != NULL) {
        _valueCallbackColorLed(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)command
{
    return [self set_command:command];
}

/**
 * Add a new transition to the blinking sequence, the move will
 * be performed in the HSL space.
 *
 * @param HSLcolor : desired HSL color when the traisntion is completed
 * @param msDelay : duration of the color transition, in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addHslMoveToBlinkSeq:(int)HSLcolor :(int)msDelay
{
    return [self sendCommand:[NSString stringWithFormat:@"H%d,%d",HSLcolor,msDelay]];
}

/**
 * Adds a new transition to the blinking sequence, the move is
 * performed in the RGB space.
 *
 * @param RGBcolor : desired RGB color when the transition is completed
 * @param msDelay : duration of the color transition, in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addRgbMoveToBlinkSeq:(int)RGBcolor :(int)msDelay
{
    return [self sendCommand:[NSString stringWithFormat:@"R%d,%d",RGBcolor,msDelay]];
}

/**
 * Starts the preprogrammed blinking sequence. The sequence is
 * run in a loop until it is stopped by stopBlinkSeq or an explicit
 * change.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) startBlinkSeq
{
    return [self sendCommand:@"S"];
}

/**
 * Stops the preprogrammed blinking sequence.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) stopBlinkSeq
{
    return [self sendCommand:@"X"];
}

/**
 * Resets the preprogrammed blinking sequence.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) resetBlinkSeq
{
    return [self sendCommand:@"Z"];
}


-(YColorLed*)   nextColorLed
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YColorLed FindColorLed:hwid];
}

+(YColorLed *) FirstColorLed
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"ColorLed":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YColorLed FindColorLed:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YColorLed public methods implementation)

@end
//--- (YColorLed functions)

YColorLed *yFindColorLed(NSString* func)
{
    return [YColorLed FindColorLed:func];
}

YColorLed *yFirstColorLed(void)
{
    return [YColorLed FirstColorLed];
}

//--- (end of YColorLed functions)
