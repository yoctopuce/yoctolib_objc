/*********************************************************************
 *
 * $Id: yocto_dualpower.m 31436 2018-08-07 15:28:18Z seb $
 *
 * Implements the high-level API for DualPower functions
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


#import "yocto_dualpower.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YDualPower

// Constructor is protected, use yFindDualPower factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"DualPower";
//--- (YDualPower attributes initialization)
    _powerState = Y_POWERSTATE_INVALID;
    _powerControl = Y_POWERCONTROL_INVALID;
    _extVoltage = Y_EXTVOLTAGE_INVALID;
    _valueCallbackDualPower = NULL;
//--- (end of YDualPower attributes initialization)
    return self;
}
//--- (YDualPower yapiwrapper)
//--- (end of YDualPower yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YDualPower cleanup)
    ARC_dealloc(super);
//--- (end of YDualPower cleanup)
}
//--- (YDualPower private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "powerState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "powerControl")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerControl =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "extVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _extVoltage =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YDualPower private methods implementation)
//--- (YDualPower public methods implementation)
/**
 * Returns the current power source for module functions that require lots of current.
 *
 * @return a value among Y_POWERSTATE_OFF, Y_POWERSTATE_FROM_USB and Y_POWERSTATE_FROM_EXT
 * corresponding to the current power source for module functions that require lots of current
 *
 * On failure, throws an exception or returns Y_POWERSTATE_INVALID.
 */
-(Y_POWERSTATE_enum) get_powerState
{
    Y_POWERSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWERSTATE_INVALID;
        }
    }
    res = _powerState;
    return res;
}


-(Y_POWERSTATE_enum) powerState
{
    return [self get_powerState];
}
/**
 * Returns the selected power source for module functions that require lots of current.
 *
 * @return a value among Y_POWERCONTROL_AUTO, Y_POWERCONTROL_FROM_USB, Y_POWERCONTROL_FROM_EXT and
 * Y_POWERCONTROL_OFF corresponding to the selected power source for module functions that require lots of current
 *
 * On failure, throws an exception or returns Y_POWERCONTROL_INVALID.
 */
-(Y_POWERCONTROL_enum) get_powerControl
{
    Y_POWERCONTROL_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWERCONTROL_INVALID;
        }
    }
    res = _powerControl;
    return res;
}


-(Y_POWERCONTROL_enum) powerControl
{
    return [self get_powerControl];
}

/**
 * Changes the selected power source for module functions that require lots of current.
 *
 * @param newval : a value among Y_POWERCONTROL_AUTO, Y_POWERCONTROL_FROM_USB, Y_POWERCONTROL_FROM_EXT
 * and Y_POWERCONTROL_OFF corresponding to the selected power source for module functions that require
 * lots of current
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerControl:(Y_POWERCONTROL_enum) newval
{
    return [self setPowerControl:newval];
}
-(int) setPowerControl:(Y_POWERCONTROL_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"powerControl" :rest_val];
}
/**
 * Returns the measured voltage on the external power source, in millivolts.
 *
 * @return an integer corresponding to the measured voltage on the external power source, in millivolts
 *
 * On failure, throws an exception or returns Y_EXTVOLTAGE_INVALID.
 */
-(int) get_extVoltage
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_EXTVOLTAGE_INVALID;
        }
    }
    res = _extVoltage;
    return res;
}


-(int) extVoltage
{
    return [self get_extVoltage];
}
/**
 * Retrieves a dual power control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the power control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDualPower.isOnline() to test if the power control is
 * indeed online at a given time. In case of ambiguity when looking for
 * a dual power control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the power control
 *
 * @return a YDualPower object allowing you to drive the power control.
 */
+(YDualPower*) FindDualPower:(NSString*)func
{
    YDualPower* obj;
    obj = (YDualPower*) [YFunction _FindFromCache:@"DualPower" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDualPower alloc] initWith:func]);
        [YFunction _AddToCache:@"DualPower" : func :obj];
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
-(int) registerValueCallback:(YDualPowerValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDualPower = callback;
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
    if (_valueCallbackDualPower != NULL) {
        _valueCallbackDualPower(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YDualPower*)   nextDualPower
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDualPower FindDualPower:hwid];
}

+(YDualPower *) FirstDualPower
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"DualPower":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDualPower FindDualPower:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YDualPower public methods implementation)

@end
//--- (YDualPower functions)

YDualPower *yFindDualPower(NSString* func)
{
    return [YDualPower FindDualPower:func];
}

YDualPower *yFirstDualPower(void)
{
    return [YDualPower FirstDualPower];
}

//--- (end of YDualPower functions)
