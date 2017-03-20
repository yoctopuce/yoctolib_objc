/*********************************************************************
 *
 * $Id: yocto_multiaxiscontroller.m 26672 2017-02-28 13:43:38Z seb $
 *
 * Implements the high-level API for MultiAxisController functions
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


#import "yocto_multiaxiscontroller.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YMultiAxisController

// Constructor is protected, use yFindMultiAxisController factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"MultiAxisController";
//--- (YMultiAxisController attributes initialization)
    _nAxis = Y_NAXIS_INVALID;
    _globalState = Y_GLOBALSTATE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackMultiAxisController = NULL;
//--- (end of YMultiAxisController attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YMultiAxisController cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YMultiAxisController cleanup)
}
//--- (YMultiAxisController private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "nAxis")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nAxis =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "globalState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _globalState =  atoi(j->token);
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
//--- (end of YMultiAxisController private methods implementation)
//--- (YMultiAxisController public methods implementation)
/**
 * Returns the number of synchronized controllers.
 *
 * @return an integer corresponding to the number of synchronized controllers
 *
 * On failure, throws an exception or returns Y_NAXIS_INVALID.
 */
-(int) get_nAxis
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_NAXIS_INVALID;
        }
    }
    res = _nAxis;
    return res;
}


-(int) nAxis
{
    return [self get_nAxis];
}

/**
 * Changes the number of synchronized controllers.
 *
 * @param newval : an integer corresponding to the number of synchronized controllers
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_nAxis:(int) newval
{
    return [self setNAxis:newval];
}
-(int) setNAxis:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"nAxis" :rest_val];
}
/**
 * Returns the stepper motor set overall state.
 *
 * @return a value among Y_GLOBALSTATE_ABSENT, Y_GLOBALSTATE_ALERT, Y_GLOBALSTATE_HI_Z,
 * Y_GLOBALSTATE_STOP, Y_GLOBALSTATE_RUN and Y_GLOBALSTATE_BATCH corresponding to the stepper motor
 * set overall state
 *
 * On failure, throws an exception or returns Y_GLOBALSTATE_INVALID.
 */
-(Y_GLOBALSTATE_enum) get_globalState
{
    Y_GLOBALSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_GLOBALSTATE_INVALID;
        }
    }
    res = _globalState;
    return res;
}


-(Y_GLOBALSTATE_enum) globalState
{
    return [self get_globalState];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
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
 * Retrieves a multi-axis controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-axis controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiAxisController.isOnline() to test if the multi-axis controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-axis controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the multi-axis controller
 *
 * @return a YMultiAxisController object allowing you to drive the multi-axis controller.
 */
+(YMultiAxisController*) FindMultiAxisController:(NSString*)func
{
    YMultiAxisController* obj;
    obj = (YMultiAxisController*) [YFunction _FindFromCache:@"MultiAxisController" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YMultiAxisController alloc] initWith:func]);
        [YFunction _AddToCache:@"MultiAxisController" : func :obj];
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
-(int) registerValueCallback:(YMultiAxisControllerValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackMultiAxisController = callback;
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
    if (_valueCallbackMultiAxisController != NULL) {
        _valueCallbackMultiAxisController(self, value);
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
 * Reinitialize all controllers and clear all alert flags.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    return [self sendCommand:@"Z"];
}

/**
 * Starts all motors backward at the specified speeds, to search for the motor home position.
 *
 * @param speed : desired speed for all axis, in steps per second.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) findHomePosition:(NSMutableArray*)speed
{
    NSString* cmd;
    int i;
    int ndim;
    ndim = (int)[speed count];
    cmd = [NSString stringWithFormat:@"H%d",(int) floor(1000*[[speed objectAtIndex:0] intValue]+0.5)];
    i = 1;
    while (i + 1 < ndim) {
        cmd = [NSString stringWithFormat:@"%@,%d", cmd,(int) floor(1000*[[speed objectAtIndex:i] intValue]+0.5)];
        i = i + 1;
    }
    return [self sendCommand:cmd];
}

/**
 * Starts all motors synchronously to reach a given absolute position.
 * The time needed to reach the requested position will depend on the lowest
 * acceleration and max speed parameters configured for all motors.
 * The final position will be reached on all axis at the same time.
 *
 * @param absPos : absolute position, measured in steps from each origin.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) moveTo:(NSMutableArray*)absPos
{
    NSString* cmd;
    int i;
    int ndim;
    ndim = (int)[absPos count];
    cmd = [NSString stringWithFormat:@"M%d",(int) floor(16*[[absPos objectAtIndex:0] intValue]+0.5)];
    i = 1;
    while (i + 1 < ndim) {
        cmd = [NSString stringWithFormat:@"%@,%d", cmd,(int) floor(16*[[absPos objectAtIndex:i] intValue]+0.5)];
        i = i + 1;
    }
    return [self sendCommand:cmd];
}

/**
 * Starts all motors synchronously to reach a given relative position.
 * The time needed to reach the requested position will depend on the lowest
 * acceleration and max speed parameters configured for all motors.
 * The final position will be reached on all axis at the same time.
 *
 * @param relPos : relative position, measured in steps from the current position.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) moveRel:(NSMutableArray*)relPos
{
    NSString* cmd;
    int i;
    int ndim;
    ndim = (int)[relPos count];
    cmd = [NSString stringWithFormat:@"m%d",(int) floor(16*[[relPos objectAtIndex:0] intValue]+0.5)];
    i = 1;
    while (i + 1 < ndim) {
        cmd = [NSString stringWithFormat:@"%@,%d", cmd,(int) floor(16*[[relPos objectAtIndex:i] intValue]+0.5)];
        i = i + 1;
    }
    return [self sendCommand:cmd];
}

/**
 * Keep the motor in the same state for the specified amount of time, before processing next command.
 *
 * @param waitMs : wait time, specified in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) pause:(int)waitMs
{
    return [self sendCommand:[NSString stringWithFormat:@"_%d",waitMs]];
}

/**
 * Stops the motor with an emergency alert, without taking any additional precaution.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) emergencyStop
{
    return [self sendCommand:@"!"];
}

/**
 * Stops the motor smoothly as soon as possible, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) abortAndBrake
{
    return [self sendCommand:@"B"];
}

/**
 * Turn the controller into Hi-Z mode immediately, without waiting for ongoing move completion.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) abortAndHiZ
{
    return [self sendCommand:@"z"];
}


-(YMultiAxisController*)   nextMultiAxisController
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YMultiAxisController FindMultiAxisController:hwid];
}

+(YMultiAxisController *) FirstMultiAxisController
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"MultiAxisController":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YMultiAxisController FindMultiAxisController:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YMultiAxisController public methods implementation)

@end
//--- (MultiAxisController functions)

YMultiAxisController *yFindMultiAxisController(NSString* func)
{
    return [YMultiAxisController FindMultiAxisController:func];
}

YMultiAxisController *yFirstMultiAxisController(void)
{
    return [YMultiAxisController FirstMultiAxisController];
}

//--- (end of MultiAxisController functions)
