/*********************************************************************
 *
 * $Id: yocto_colorled.m 9801 2013-02-11 17:09:59Z seb $
 *
 * Implements yFindColorLed(), the high-level API for ColorLed functions
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


#import "yocto_colorled.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


static NSMutableDictionary* _ColorLedCache = nil;

@implementation YColorLed

// Constructor is protected, use yFindColorLed factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YColorLed attributes)
   if(!(self = [super initProtected:@"ColorLed":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _rgbColor = Y_RGBCOLOR_INVALID;
    _hslColor = Y_HSLCOLOR_INVALID;
    _rgbColorAtPowerOn = Y_RGBCOLORATPOWERON_INVALID;
//--- (end of YColorLed attributes)
    return self;
}
//--- (YColorLed implementation)

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
        } else if(!strcmp(j->token, "rgbColor")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _rgbColor =  atoi(j->token);
        } else if(!strcmp(j->token, "hslColor")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _hslColor =  atoi(j->token);
        } else if(!strcmp(j->token, "rgbMove")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _rgbMove.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _rgbMove.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _rgbMove.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else if(!strcmp(j->token, "hslMove")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            if(j->st != YJSON_PARSE_STRUCT) goto failed;
            while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
                if(!strcmp(j->token, "moving")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _hslMove.moving = atoi(j->token);
                } else if(!strcmp(j->token, "target")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _hslMove.target = atoi(j->token);
                } else if(!strcmp(j->token, "ms")) {
                    if(yJsonParse(j) != YJSON_PARSE_AVAIL) goto failed;
                    _hslMove.ms = atoi(j->token);
                }
            }
            if(j->st != YJSON_PARSE_STRUCT) goto failed; 
            
        } else if(!strcmp(j->token, "rgbColorAtPowerOn")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _rgbColorAtPowerOn =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the RGB led.
 * 
 * @return a string corresponding to the logical name of the RGB led
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
 * Returns the current value of the RGB led (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the RGB led (no more than 6 characters)
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
 * Returns the current RGB color of the led.
 * 
 * @return an integer corresponding to the current RGB color of the led
 * 
 * On failure, throws an exception or returns Y_RGBCOLOR_INVALID.
 */
-(unsigned) get_rgbColor
{
    return [self rgbColor];
}
-(unsigned) rgbColor
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RGBCOLOR_INVALID;
    }
    return _rgbColor;
}

/**
 * Changes the current color of the led, using a RGB color. Encoding is done as follows: 0xRRGGBB.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a RGB color
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColor:(unsigned) newval
{
    return [self setRgbColor:newval];
}
-(int) setRgbColor:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"rgbColor" :rest_val];
}

/**
 * Returns the current HSL color of the led.
 * 
 * @return an integer corresponding to the current HSL color of the led
 * 
 * On failure, throws an exception or returns Y_HSLCOLOR_INVALID.
 */
-(unsigned) get_hslColor
{
    return [self hslColor];
}
-(unsigned) hslColor
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_HSLCOLOR_INVALID;
    }
    return _hslColor;
}

/**
 * Changes the current color of the led, using a color HSL. Encoding is done as follows: 0xHHSSLL.
 * 
 * @param newval : an integer corresponding to the current color of the led, using a color HSL
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColor:(unsigned) newval
{
    return [self setHslColor:newval];
}
-(int) setHslColor:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"hslColor" :rest_val];
}

-(YRETCODE) get_rgbMove :(s32*)target :(s16*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _rgbMove.target;
    *ms = _rgbMove.ms;
    *moving = _rgbMove.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_rgbMove :(s32)target :(s16)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
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
-(int) rgbMove :(int)rgb_target :(int)ms_duration
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",rgb_target,ms_duration];
    return [self _setAttr:@"rgbMove" :rest_val];
}

-(YRETCODE) get_hslMove :(s32*)target :(s16*)ms :(u8*)moving
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return YAPI_IO_ERROR;
    }
    *target = _hslMove.target;
    *ms = _hslMove.ms;
    *moving = _hslMove.moving;
    return YAPI_SUCCESS;
}

-(YRETCODE) set_hslMove :(s32)target :(s16)ms :(u8)moving
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d:%d",target,ms];
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
-(int) hslMove :(int)hsl_target :(int)ms_duration
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
-(unsigned) get_rgbColorAtPowerOn
{
    return [self rgbColorAtPowerOn];
}
-(unsigned) rgbColorAtPowerOn
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RGBCOLORATPOWERON_INVALID;
    }
    return _rgbColorAtPowerOn;
}

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
-(int) set_rgbColorAtPowerOn:(unsigned) newval
{
    return [self setRgbColorAtPowerOn:newval];
}
-(int) setRgbColorAtPowerOn:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"0x%06x",newval];
    return [self _setAttr:@"rgbColorAtPowerOn" :rest_val];
}

-(YColorLed*)   nextColorLed
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindColorLed(hwid);
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

+(YColorLed*) FindColorLed:(NSString*) func
{
    YColorLed * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    {
        if (_ColorLedCache == nil){
            _ColorLedCache = [[NSMutableDictionary alloc] init];
        }
        if(nil != [_ColorLedCache objectForKey:func]){
            retVal = [_ColorLedCache objectForKey:func];
       } else {
           YColorLed *newColorLed = [[YColorLed alloc] initWithFunction:func];
           [_ColorLedCache setObject:newColorLed forKey:func];
           retVal = newColorLed;
           ARC_autorelease(retVal);
       }
   }
   return retVal;
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

//--- (end of YColorLed implementation)

@end
//--- (ColorLed functions)

YColorLed *yFindColorLed(NSString* func)
{
    return [YColorLed FindColorLed:func];
}

YColorLed *yFirstColorLed(void)
{
    return [YColorLed FirstColorLed];
}

//--- (end of ColorLed functions)
