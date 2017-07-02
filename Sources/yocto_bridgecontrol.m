/*********************************************************************
 *
 * $Id: yocto_bridgecontrol.m 27708 2017-06-01 12:36:32Z seb $
 *
 * Implements the high-level API for BridgeControl functions
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


#import "yocto_bridgecontrol.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YBridgeControl

// Constructor is protected, use yFindBridgeControl factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"BridgeControl";
//--- (YBridgeControl attributes initialization)
    _excitationMode = Y_EXCITATIONMODE_INVALID;
    _bridgeLatency = Y_BRIDGELATENCY_INVALID;
    _adValue = Y_ADVALUE_INVALID;
    _adGain = Y_ADGAIN_INVALID;
    _valueCallbackBridgeControl = NULL;
//--- (end of YBridgeControl attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YBridgeControl cleanup)
    ARC_dealloc(super);
//--- (end of YBridgeControl cleanup)
}
//--- (YBridgeControl private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "excitationMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _excitationMode =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "bridgeLatency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _bridgeLatency =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "adValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _adValue =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "adGain")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _adGain =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YBridgeControl private methods implementation)
//--- (YBridgeControl public methods implementation)
/**
 * Returns the current Wheatstone bridge excitation method.
 *
 * @return a value among Y_EXCITATIONMODE_INTERNAL_AC, Y_EXCITATIONMODE_INTERNAL_DC and
 * Y_EXCITATIONMODE_EXTERNAL_DC corresponding to the current Wheatstone bridge excitation method
 *
 * On failure, throws an exception or returns Y_EXCITATIONMODE_INVALID.
 */
-(Y_EXCITATIONMODE_enum) get_excitationMode
{
    Y_EXCITATIONMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_EXCITATIONMODE_INVALID;
        }
    }
    res = _excitationMode;
    return res;
}


-(Y_EXCITATIONMODE_enum) excitationMode
{
    return [self get_excitationMode];
}

/**
 * Changes the current Wheatstone bridge excitation method.
 *
 * @param newval : a value among Y_EXCITATIONMODE_INTERNAL_AC, Y_EXCITATIONMODE_INTERNAL_DC and
 * Y_EXCITATIONMODE_EXTERNAL_DC corresponding to the current Wheatstone bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_excitationMode:(Y_EXCITATIONMODE_enum) newval
{
    return [self setExcitationMode:newval];
}
-(int) setExcitationMode:(Y_EXCITATIONMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"excitationMode" :rest_val];
}
/**
 * Returns the current Wheatstone bridge excitation method.
 *
 * @return an integer corresponding to the current Wheatstone bridge excitation method
 *
 * On failure, throws an exception or returns Y_BRIDGELATENCY_INVALID.
 */
-(int) get_bridgeLatency
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_BRIDGELATENCY_INVALID;
        }
    }
    res = _bridgeLatency;
    return res;
}


-(int) bridgeLatency
{
    return [self get_bridgeLatency];
}

/**
 * Changes the current Wheatstone bridge excitation method.
 *
 * @param newval : an integer corresponding to the current Wheatstone bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bridgeLatency:(int) newval
{
    return [self setBridgeLatency:newval];
}
-(int) setBridgeLatency:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"bridgeLatency" :rest_val];
}
/**
 * Returns the raw value returned by the ratiometric A/D converter
 * during last read.
 *
 * @return an integer corresponding to the raw value returned by the ratiometric A/D converter
 *         during last read
 *
 * On failure, throws an exception or returns Y_ADVALUE_INVALID.
 */
-(int) get_adValue
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADVALUE_INVALID;
        }
    }
    res = _adValue;
    return res;
}


-(int) adValue
{
    return [self get_adValue];
}
/**
 * Returns the current ratiometric A/D converter gain. The gain is automatically
 * configured according to the signalRange set in the corresponding genericSensor.
 *
 * @return an integer corresponding to the current ratiometric A/D converter gain
 *
 * On failure, throws an exception or returns Y_ADGAIN_INVALID.
 */
-(int) get_adGain
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADGAIN_INVALID;
        }
    }
    res = _adGain;
    return res;
}


-(int) adGain
{
    return [self get_adGain];
}
/**
 * Retrieves a Wheatstone bridge controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Wheatstone bridge controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBridgeControl.isOnline() to test if the Wheatstone bridge controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Wheatstone bridge controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Wheatstone bridge controller
 *
 * @return a YBridgeControl object allowing you to drive the Wheatstone bridge controller.
 */
+(YBridgeControl*) FindBridgeControl:(NSString*)func
{
    YBridgeControl* obj;
    obj = (YBridgeControl*) [YFunction _FindFromCache:@"BridgeControl" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YBridgeControl alloc] initWith:func]);
        [YFunction _AddToCache:@"BridgeControl" : func :obj];
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
-(int) registerValueCallback:(YBridgeControlValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackBridgeControl = callback;
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
    if (_valueCallbackBridgeControl != NULL) {
        _valueCallbackBridgeControl(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YBridgeControl*)   nextBridgeControl
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YBridgeControl FindBridgeControl:hwid];
}

+(YBridgeControl *) FirstBridgeControl
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"BridgeControl":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YBridgeControl FindBridgeControl:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YBridgeControl public methods implementation)

@end
//--- (BridgeControl functions)

YBridgeControl *yFindBridgeControl(NSString* func)
{
    return [YBridgeControl FindBridgeControl:func];
}

YBridgeControl *yFirstBridgeControl(void)
{
    return [YBridgeControl FirstBridgeControl];
}

//--- (end of BridgeControl functions)
