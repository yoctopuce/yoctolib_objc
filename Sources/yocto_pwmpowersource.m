/*********************************************************************
 *
 * $Id: yocto_pwmpowersource.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for PwmPowerSource functions
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


#import "yocto_pwmpowersource.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YPwmPowerSource

// Constructor is protected, use yFindPwmPowerSource factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"PwmPowerSource";
//--- (YPwmPowerSource attributes initialization)
    _powerMode = Y_POWERMODE_INVALID;
    _valueCallbackPwmPowerSource = NULL;
//--- (end of YPwmPowerSource attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YPwmPowerSource cleanup)
    ARC_dealloc(super);
//--- (end of YPwmPowerSource cleanup)
}
//--- (YPwmPowerSource private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "powerMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPwmPowerSource private methods implementation)
//--- (YPwmPowerSource public methods implementation)
/**
 * Returns the selected power source for the PWM on the same device
 *
 * @return a value among Y_POWERMODE_USB_5V, Y_POWERMODE_USB_3V, Y_POWERMODE_EXT_V and
 * Y_POWERMODE_OPNDRN corresponding to the selected power source for the PWM on the same device
 *
 * On failure, throws an exception or returns Y_POWERMODE_INVALID.
 */
-(Y_POWERMODE_enum) get_powerMode
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWERMODE_INVALID;
        }
    }
    return _powerMode;
}


-(Y_POWERMODE_enum) powerMode
{
    return [self get_powerMode];
}

/**
 * Changes  the PWM power source. PWM can use isolated 5V from USB, isolated 3V from USB or
 * voltage from an external power source. The PWM can also work in open drain  mode. In that
 * mode, the PWM actively pulls the line down.
 * Warning: this setting is common to all PWM on the same device. If you change that parameter,
 * all PWM located on the same device are  affected.
 * If you want the change to be kept after a device reboot, make sure  to call the matching
 * module saveToFlash().
 *
 * @param newval : a value among Y_POWERMODE_USB_5V, Y_POWERMODE_USB_3V, Y_POWERMODE_EXT_V and
 * Y_POWERMODE_OPNDRN corresponding to  the PWM power source
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_powerMode:(Y_POWERMODE_enum) newval
{
    return [self setPowerMode:newval];
}
-(int) setPowerMode:(Y_POWERMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"powerMode" :rest_val];
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
 * Use the method YPwmPowerSource.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YPwmPowerSource object allowing you to drive $THEFUNCTION$.
 */
+(YPwmPowerSource*) FindPwmPowerSource:(NSString*)func
{
    YPwmPowerSource* obj;
    obj = (YPwmPowerSource*) [YFunction _FindFromCache:@"PwmPowerSource" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPwmPowerSource alloc] initWith:func]);
        [YFunction _AddToCache:@"PwmPowerSource" : func :obj];
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
-(int) registerValueCallback:(YPwmPowerSourceValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPwmPowerSource = callback;
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
    if (_valueCallbackPwmPowerSource != NULL) {
        _valueCallbackPwmPowerSource(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YPwmPowerSource*)   nextPwmPowerSource
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPwmPowerSource FindPwmPowerSource:hwid];
}

+(YPwmPowerSource *) FirstPwmPowerSource
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"PwmPowerSource":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPwmPowerSource FindPwmPowerSource:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPwmPowerSource public methods implementation)

@end
//--- (PwmPowerSource functions)

YPwmPowerSource *yFindPwmPowerSource(NSString* func)
{
    return [YPwmPowerSource FindPwmPowerSource:func];
}

YPwmPowerSource *yFirstPwmPowerSource(void)
{
    return [YPwmPowerSource FirstPwmPowerSource];
}

//--- (end of PwmPowerSource functions)
