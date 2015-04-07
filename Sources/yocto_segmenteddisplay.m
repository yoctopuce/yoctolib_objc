/*********************************************************************
 *
 * $Id: yocto_segmenteddisplay.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for SegmentedDisplay functions
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


#import "yocto_segmenteddisplay.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YSegmentedDisplay

// Constructor is protected, use yFindSegmentedDisplay factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SegmentedDisplay";
//--- (YSegmentedDisplay attributes initialization)
    _displayedText = Y_DISPLAYEDTEXT_INVALID;
    _displayMode = Y_DISPLAYMODE_INVALID;
    _valueCallbackSegmentedDisplay = NULL;
//--- (end of YSegmentedDisplay attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YSegmentedDisplay cleanup)
    ARC_release(_displayedText);
    _displayedText = nil;
    ARC_dealloc(super);
//--- (end of YSegmentedDisplay cleanup)
}
//--- (YSegmentedDisplay private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "displayedText")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_displayedText);
        _displayedText =  [self _parseString:j];
        ARC_retain(_displayedText);
        return 1;
    }
    if(!strcmp(j->token, "displayMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _displayMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YSegmentedDisplay private methods implementation)
//--- (YSegmentedDisplay public methods implementation)
/**
 * Returns the text currently displayed on the screen.
 *
 * @return a string corresponding to the text currently displayed on the screen
 *
 * On failure, throws an exception or returns Y_DISPLAYEDTEXT_INVALID.
 */
-(NSString*) get_displayedText
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYEDTEXT_INVALID;
        }
    }
    return _displayedText;
}


-(NSString*) displayedText
{
    return [self get_displayedText];
}

/**
 * Changes the text currently displayed on the screen.
 *
 * @param newval : a string corresponding to the text currently displayed on the screen
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_displayedText:(NSString*) newval
{
    return [self setDisplayedText:newval];
}
-(int) setDisplayedText:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"displayedText" :rest_val];
}
-(Y_DISPLAYMODE_enum) get_displayMode
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISPLAYMODE_INVALID;
        }
    }
    return _displayMode;
}


-(Y_DISPLAYMODE_enum) displayMode
{
    return [self get_displayMode];
}

-(int) set_displayMode:(Y_DISPLAYMODE_enum) newval
{
    return [self setDisplayMode:newval];
}
-(int) setDisplayMode:(Y_DISPLAYMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"displayMode" :rest_val];
}
/**
 * Retrieves $AFUNCTION$ for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that $THEFUNCTION$ is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSegmentedDisplay.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YSegmentedDisplay object allowing you to drive $THEFUNCTION$.
 */
+(YSegmentedDisplay*) FindSegmentedDisplay:(NSString*)func
{
    YSegmentedDisplay* obj;
    obj = (YSegmentedDisplay*) [YFunction _FindFromCache:@"SegmentedDisplay" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSegmentedDisplay alloc] initWith:func]);
        [YFunction _AddToCache:@"SegmentedDisplay" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YSegmentedDisplayValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSegmentedDisplay = callback;
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
    if (_valueCallbackSegmentedDisplay != NULL) {
        _valueCallbackSegmentedDisplay(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YSegmentedDisplay*)   nextSegmentedDisplay
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSegmentedDisplay FindSegmentedDisplay:hwid];
}

+(YSegmentedDisplay *) FirstSegmentedDisplay
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SegmentedDisplay":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSegmentedDisplay FindSegmentedDisplay:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSegmentedDisplay public methods implementation)

@end
//--- (SegmentedDisplay functions)

YSegmentedDisplay *yFindSegmentedDisplay(NSString* func)
{
    return [YSegmentedDisplay FindSegmentedDisplay:func];
}

YSegmentedDisplay *yFirstSegmentedDisplay(void)
{
    return [YSegmentedDisplay FirstSegmentedDisplay];
}

//--- (end of SegmentedDisplay functions)
