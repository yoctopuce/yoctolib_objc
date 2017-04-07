/*********************************************************************
 *
 * $Id: yocto_currentloopoutput.m 27107 2017-04-06 22:17:56Z seb $
 *
 * Implements the high-level API for CurrentLoopOutput functions
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


#import "yocto_currentloopoutput.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YCurrentLoopOutput

// Constructor is protected, use yFindCurrentLoopOutput factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"CurrentLoopOutput";
//--- (YCurrentLoopOutput attributes initialization)
    _current = Y_CURRENT_INVALID;
    _currentTransition = Y_CURRENTTRANSITION_INVALID;
    _currentAtStartUp = Y_CURRENTATSTARTUP_INVALID;
    _loopPower = Y_LOOPPOWER_INVALID;
    _valueCallbackCurrentLoopOutput = NULL;
//--- (end of YCurrentLoopOutput attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YCurrentLoopOutput cleanup)
    ARC_release(_currentTransition);
    _currentTransition = nil;
    ARC_dealloc(super);
//--- (end of YCurrentLoopOutput cleanup)
}
//--- (YCurrentLoopOutput private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "current")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _current =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentTransition")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_currentTransition);
        _currentTransition =  [self _parseString:j];
        ARC_retain(_currentTransition);
        return 1;
    }
    if(!strcmp(j->token, "currentAtStartUp")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentAtStartUp =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "loopPower")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _loopPower =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YCurrentLoopOutput private methods implementation)
//--- (YCurrentLoopOutput public methods implementation)

/**
 * Changes the current loop, the valid range is from 3 to 21mA. If the loop is
 * not propely powered, the  target current is not reached and
 * loopPower is set to LOWPWR.
 *
 * @param newval : a floating point number corresponding to the current loop, the valid range is from 3 to 21mA
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_current:(double) newval
{
    return [self setCurrent:newval];
}
-(int) setCurrent:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"current" :rest_val];
}
/**
 * Returns the loop current set point in mA.
 *
 * @return a floating point number corresponding to the loop current set point in mA
 *
 * On failure, throws an exception or returns Y_CURRENT_INVALID.
 */
-(double) get_current
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENT_INVALID;
        }
    }
    res = _current;
    return res;
}


-(double) current
{
    return [self get_current];
}
-(NSString*) get_currentTransition
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTTRANSITION_INVALID;
        }
    }
    res = _currentTransition;
    return res;
}


-(NSString*) currentTransition
{
    return [self get_currentTransition];
}

-(int) set_currentTransition:(NSString*) newval
{
    return [self setCurrentTransition:newval];
}
-(int) setCurrentTransition:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"currentTransition" :rest_val];
}

/**
 * Changes the loop current at device start up. Remember to call the matching
 * module saveToFlash() method, otherwise this call has no effect.
 *
 * @param newval : a floating point number corresponding to the loop current at device start up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentAtStartUp:(double) newval
{
    return [self setCurrentAtStartUp:newval];
}
-(int) setCurrentAtStartUp:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentAtStartUp" :rest_val];
}
/**
 * Returns the current in the loop at device startup, in mA.
 *
 * @return a floating point number corresponding to the current in the loop at device startup, in mA
 *
 * On failure, throws an exception or returns Y_CURRENTATSTARTUP_INVALID.
 */
-(double) get_currentAtStartUp
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTATSTARTUP_INVALID;
        }
    }
    res = _currentAtStartUp;
    return res;
}


-(double) currentAtStartUp
{
    return [self get_currentAtStartUp];
}
/**
 * Returns the loop powerstate.  POWEROK: the loop
 * is powered. NOPWR: the loop in not powered. LOWPWR: the loop is not
 * powered enough to maintain the current required (insufficient voltage).
 *
 * @return a value among Y_LOOPPOWER_NOPWR, Y_LOOPPOWER_LOWPWR and Y_LOOPPOWER_POWEROK corresponding
 * to the loop powerstate
 *
 * On failure, throws an exception or returns Y_LOOPPOWER_INVALID.
 */
-(Y_LOOPPOWER_enum) get_loopPower
{
    Y_LOOPPOWER_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOOPPOWER_INVALID;
        }
    }
    res = _loopPower;
    return res;
}


-(Y_LOOPPOWER_enum) loopPower
{
    return [self get_loopPower];
}
/**
 * Retrieves a 4-20mA output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the 4-20mA output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCurrentLoopOutput.isOnline() to test if the 4-20mA output is
 * indeed online at a given time. In case of ambiguity when looking for
 * a 4-20mA output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the 4-20mA output
 *
 * @return a YCurrentLoopOutput object allowing you to drive the 4-20mA output.
 */
+(YCurrentLoopOutput*) FindCurrentLoopOutput:(NSString*)func
{
    YCurrentLoopOutput* obj;
    obj = (YCurrentLoopOutput*) [YFunction _FindFromCache:@"CurrentLoopOutput" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YCurrentLoopOutput alloc] initWith:func]);
        [YFunction _AddToCache:@"CurrentLoopOutput" : func :obj];
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
-(int) registerValueCallback:(YCurrentLoopOutputValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackCurrentLoopOutput = callback;
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
    if (_valueCallbackCurrentLoopOutput != NULL) {
        _valueCallbackCurrentLoopOutput(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Performs a smooth transistion of current flowing in the loop. Any current explicit
 * change cancels any ongoing transition process.
 *
 * @param mA_target   : new current value at the end of the transition
 *         (floating-point number, representing the transition duration in mA)
 * @param ms_duration : total duration of the transition, in milliseconds
 *
 * @return YAPI_SUCCESS when the call succeeds.
 */
-(int) currentMove:(double)mA_target :(int)ms_duration
{
    NSString* newval;
    if (mA_target < 3.0) {
        mA_target  = 3.0;
    }
    if (mA_target > 21.0) {
        mA_target = 21.0;
    }
    newval = [NSString stringWithFormat:@"%d:%d", (int) floor(mA_target*1000+0.5),ms_duration];
    
    return [self set_currentTransition:newval];
}


-(YCurrentLoopOutput*)   nextCurrentLoopOutput
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YCurrentLoopOutput FindCurrentLoopOutput:hwid];
}

+(YCurrentLoopOutput *) FirstCurrentLoopOutput
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"CurrentLoopOutput":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YCurrentLoopOutput FindCurrentLoopOutput:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YCurrentLoopOutput public methods implementation)

@end
//--- (CurrentLoopOutput functions)

YCurrentLoopOutput *yFindCurrentLoopOutput(NSString* func)
{
    return [YCurrentLoopOutput FindCurrentLoopOutput:func];
}

YCurrentLoopOutput *yFirstCurrentLoopOutput(void)
{
    return [YCurrentLoopOutput FirstCurrentLoopOutput];
}

//--- (end of CurrentLoopOutput functions)
