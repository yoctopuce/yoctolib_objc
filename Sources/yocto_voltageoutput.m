/*********************************************************************
 *
 * $Id: pic24config.php 27548 2017-05-19 06:07:04Z mvuilleu $
 *
 * Implements the high-level API for VoltageOutput functions
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


#import "yocto_voltageoutput.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YVoltageOutput

// Constructor is protected, use yFindVoltageOutput factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"VoltageOutput";
//--- (YVoltageOutput attributes initialization)
    _currentVoltage = Y_CURRENTVOLTAGE_INVALID;
    _voltageTransition = Y_VOLTAGETRANSITION_INVALID;
    _voltageAtStartUp = Y_VOLTAGEATSTARTUP_INVALID;
    _valueCallbackVoltageOutput = NULL;
//--- (end of YVoltageOutput attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YVoltageOutput cleanup)
    ARC_release(_voltageTransition);
    _voltageTransition = nil;
    ARC_dealloc(super);
//--- (end of YVoltageOutput cleanup)
}
//--- (YVoltageOutput private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "currentVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentVoltage =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "voltageTransition")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_voltageTransition);
        _voltageTransition =  [self _parseString:j];
        ARC_retain(_voltageTransition);
        return 1;
    }
    if(!strcmp(j->token, "voltageAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageAtStartUp =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YVoltageOutput private methods implementation)
//--- (YVoltageOutput public methods implementation)

/**
 * Changes the output voltage. Valid range is from 0 to 10V.
 *
 * @param newval : a floating point number corresponding to the output voltage
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentVoltage:(double) newval
{
    return [self setCurrentVoltage:newval];
}
-(int) setCurrentVoltage:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentVoltage" :rest_val];
}
/**
 * Returns the loop current set point in mA.
 *
 * @return a floating point number corresponding to the loop current set point in mA
 *
 * On failure, throws an exception or returns Y_CURRENTVOLTAGE_INVALID.
 */
-(double) get_currentVoltage
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTVOLTAGE_INVALID;
        }
    }
    res = _currentVoltage;
    return res;
}


-(double) currentVoltage
{
    return [self get_currentVoltage];
}
-(NSString*) get_voltageTransition
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGETRANSITION_INVALID;
        }
    }
    res = _voltageTransition;
    return res;
}


-(NSString*) voltageTransition
{
    return [self get_voltageTransition];
}

-(int) set_voltageTransition:(NSString*) newval
{
    return [self setVoltageTransition:newval];
}
-(int) setVoltageTransition:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"voltageTransition" :rest_val];
}

/**
 * Changes the output voltage at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the output voltage at device start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageAtStartUp:(double) newval
{
    return [self setVoltageAtStartUp:newval];
}
-(int) setVoltageAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"voltageAtStartUp" :rest_val];
}
/**
 * Returns the selected voltage output at device startup, in V.
 *
 * @return a floating point number corresponding to the selected voltage output at device startup, in V
 *
 * On failure, throws an exception or returns Y_VOLTAGEATSTARTUP_INVALID.
 */
-(double) get_voltageAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGEATSTARTUP_INVALID;
        }
    }
    res = _voltageAtStartUp;
    return res;
}


-(double) voltageAtStartUp
{
    return [self get_voltageAtStartUp];
}
/**
 * Retrieves a voltage output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the voltage output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoltageOutput.isOnline() to test if the voltage output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the voltage output
 *
 * @return a YVoltageOutput object allowing you to drive the voltage output.
 */
+(YVoltageOutput*) FindVoltageOutput:(NSString*)func
{
    YVoltageOutput* obj;
    obj = (YVoltageOutput*) [YFunction _FindFromCache:@"VoltageOutput" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YVoltageOutput alloc] initWith:func]);
        [YFunction _AddToCache:@"VoltageOutput" : func :obj];
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
-(int) registerValueCallback:(YVoltageOutputValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackVoltageOutput = callback;
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
    if (_valueCallbackVoltageOutput != NULL) {
        _valueCallbackVoltageOutput(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Performs a smooth transistion of output voltage. Any explicit voltage
 * change cancels any ongoing transition process.
 *
 * @param V_target   : new output voltage value at the end of the transition
 *         (floating-point number, representing the end voltage in V)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 */
-(int) voltageMove:(double)V_target :(int)ms_duration
{
    NSString* newval;
    if (V_target < 0.0) {
        V_target  = 0.0;
    }
    if (V_target > 10.0) {
        V_target = 10.0;
    }
    newval = [NSString stringWithFormat:@"%d:%d", (int) floor(V_target*1000+0.5),ms_duration];

    return [self set_voltageTransition:newval];
}


-(YVoltageOutput*)   nextVoltageOutput
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YVoltageOutput FindVoltageOutput:hwid];
}

+(YVoltageOutput *) FirstVoltageOutput
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"VoltageOutput":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YVoltageOutput FindVoltageOutput:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YVoltageOutput public methods implementation)

@end
//--- (VoltageOutput functions)

YVoltageOutput *yFindVoltageOutput(NSString* func)
{
    return [YVoltageOutput FindVoltageOutput:func];
}

YVoltageOutput *yFirstVoltageOutput(void)
{
    return [YVoltageOutput FirstVoltageOutput];
}

//--- (end of VoltageOutput functions)
