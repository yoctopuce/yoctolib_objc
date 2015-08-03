/*********************************************************************
 *
 * $Id: yocto_poweroutput.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for PowerOutput functions
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


#import "yocto_poweroutput.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YPowerOutput

// Constructor is protected, use yFindPowerOutput factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"PowerOutput";
//--- (YPowerOutput attributes initialization)
    _voltage = Y_VOLTAGE_INVALID;
    _valueCallbackPowerOutput = NULL;
//--- (end of YPowerOutput attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YPowerOutput cleanup)
    ARC_dealloc(super);
//--- (end of YPowerOutput cleanup)
}
//--- (YPowerOutput private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "voltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltage =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPowerOutput private methods implementation)
//--- (YPowerOutput public methods implementation)
/**
 * Returns the voltage on the power ouput featured by
 * the module.
 *
 * @return a value among Y_VOLTAGE_OFF, Y_VOLTAGE_OUT3V3 and Y_VOLTAGE_OUT5V corresponding to the
 * voltage on the power ouput featured by
 *         the module
 *
 * On failure, throws an exception or returns Y_VOLTAGE_INVALID.
 */
-(Y_VOLTAGE_enum) get_voltage
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGE_INVALID;
        }
    }
    return _voltage;
}


-(Y_VOLTAGE_enum) voltage
{
    return [self get_voltage];
}

/**
 * Changes the voltage on the power output provided by the
 * module. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_VOLTAGE_OFF, Y_VOLTAGE_OUT3V3 and Y_VOLTAGE_OUT5V corresponding to
 * the voltage on the power output provided by the
 *         module
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltage:(Y_VOLTAGE_enum) newval
{
    return [self setVoltage:newval];
}
-(int) setVoltage:(Y_VOLTAGE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"voltage" :rest_val];
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
 * Use the method YPowerOutput.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YPowerOutput object allowing you to drive $THEFUNCTION$.
 */
+(YPowerOutput*) FindPowerOutput:(NSString*)func
{
    YPowerOutput* obj;
    obj = (YPowerOutput*) [YFunction _FindFromCache:@"PowerOutput" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPowerOutput alloc] initWith:func]);
        [YFunction _AddToCache:@"PowerOutput" : func :obj];
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
-(int) registerValueCallback:(YPowerOutputValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPowerOutput = callback;
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
    if (_valueCallbackPowerOutput != NULL) {
        _valueCallbackPowerOutput(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YPowerOutput*)   nextPowerOutput
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPowerOutput FindPowerOutput:hwid];
}

+(YPowerOutput *) FirstPowerOutput
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"PowerOutput":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPowerOutput FindPowerOutput:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPowerOutput public methods implementation)

@end
//--- (PowerOutput functions)

YPowerOutput *yFindPowerOutput(NSString* func)
{
    return [YPowerOutput FindPowerOutput:func];
}

YPowerOutput *yFirstPowerOutput(void)
{
    return [YPowerOutput FirstPowerOutput];
}

//--- (end of PowerOutput functions)
