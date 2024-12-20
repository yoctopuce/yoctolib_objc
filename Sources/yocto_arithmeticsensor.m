/*********************************************************************
 *
 *  $Id: yocto_arithmeticsensor.m 63508 2024-11-28 10:46:01Z seb $
 *
 *  Implements the high-level API for ArithmeticSensor functions
 *
 *  - - - - - - - - - License information: - - - - - - - - -
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


#import "yocto_arithmeticsensor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YArithmeticSensor
// Constructor is protected, use yFindArithmeticSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"ArithmeticSensor";
//--- (YArithmeticSensor attributes initialization)
    _description = Y_DESCRIPTION_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackArithmeticSensor = NULL;
    _timedReportCallbackArithmeticSensor = NULL;
//--- (end of YArithmeticSensor attributes initialization)
    return self;
}
//--- (YArithmeticSensor yapiwrapper)
//--- (end of YArithmeticSensor yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YArithmeticSensor cleanup)
    ARC_release(_description);
    _description = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YArithmeticSensor cleanup)
}
//--- (YArithmeticSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "description")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_description);
        _description =  [self _parseString:j];
        ARC_retain(_description);
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
//--- (end of YArithmeticSensor private methods implementation)
//--- (YArithmeticSensor public methods implementation)

/**
 * Changes the measuring unit for the arithmetic sensor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the arithmetic sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_unit:(NSString*) newval
{
    return [self setUnit:newval];
}
-(int) setUnit:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"unit" :rest_val];
}
/**
 * Returns a short informative description of the formula.
 *
 * @return a string corresponding to a short informative description of the formula
 *
 * On failure, throws an exception or returns YArithmeticSensor.DESCRIPTION_INVALID.
 */
-(NSString*) get_description
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DESCRIPTION_INVALID;
        }
    }
    res = _description;
    return res;
}


-(NSString*) description
{
    return [self get_description];
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
 * Retrieves an arithmetic sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the arithmetic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YArithmeticSensor.isOnline() to test if the arithmetic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an arithmetic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the arithmetic sensor, for instance
 *         RXUVOLT1.arithmeticSensor1.
 *
 * @return a YArithmeticSensor object allowing you to drive the arithmetic sensor.
 */
+(YArithmeticSensor*) FindArithmeticSensor:(NSString*)func
{
    YArithmeticSensor* obj;
    obj = (YArithmeticSensor*) [YFunction _FindFromCache:@"ArithmeticSensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YArithmeticSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"ArithmeticSensor" :func :obj];
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
-(int) registerValueCallback:(YArithmeticSensorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackArithmeticSensor = callback;
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
    if (_valueCallbackArithmeticSensor != NULL) {
        _valueCallbackArithmeticSensor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YArithmeticSensorTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackArithmeticSensor = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackArithmeticSensor != NULL) {
        _timedReportCallbackArithmeticSensor(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Defines the arithmetic function by means of an algebraic expression. The expression
 * may include references to device sensors, by their physical or logical name, to
 * usual math functions and to auxiliary functions defined separately.
 *
 * @param expr : the algebraic expression defining the function.
 * @param descr : short informative description of the expression.
 *
 * @return the current expression value if the call succeeds.
 *
 * On failure, throws an exception or returns YAPI_INVALID_DOUBLE.
 */
-(double) defineExpression:(NSString*)expr :(NSString*)descr
{
    NSString* id;
    NSString* fname;
    NSString* content;
    NSMutableData* data;
    NSString* diags;
    double resval;
    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange(16, (int)[(id) length] - 16)];
    fname = [NSString stringWithFormat:@"arithmExpr%@.txt",id];

    content = [NSString stringWithFormat:@"// %@\n%@",descr,expr];
    data = [self _uploadEx:fname :[NSMutableData dataWithData:[content dataUsingEncoding:NSISOLatin1StringEncoding]]];
    diags = ARC_sendAutorelease([[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding]);
    if (!([[diags substringWithRange:NSMakeRange(0, 8)] isEqualToString:@"Result: "])) {[self _throw:YAPI_INVALID_ARGUMENT:diags]; return YAPI_INVALID_DOUBLE;}
    resval = [[diags substringWithRange:NSMakeRange(8, (int)[(diags) length]-8)] doubleValue];
    return resval;
}

/**
 * Retrieves the algebraic expression defining the arithmetic function, as previously
 * configured using the defineExpression function.
 *
 * @return a string containing the mathematical expression.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSString*) loadExpression
{
    NSString* id;
    NSString* fname;
    NSString* content;
    int idx;
    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange(16, (int)[(id) length] - 16)];
    fname = [NSString stringWithFormat:@"arithmExpr%@.txt",id];

    content = ARC_sendAutorelease([[NSString alloc] initWithData:[self _download:fname] encoding:NSISOLatin1StringEncoding]);
    idx = _ystrpos(content, @"\n");
    if (idx > 0) {
        content = [content substringWithRange:NSMakeRange(idx+1, (int)[(content) length]-(idx+1))];
    }
    return content;
}

/**
 * Defines a auxiliary function by means of a table of reference points. Intermediate values
 * will be interpolated between specified reference points. The reference points are given
 * as pairs of floating point numbers.
 * The auxiliary function will be available for use by all ArithmeticSensor objects of the
 * device. Up to nine auxiliary function can be defined in a device, each containing up to
 * 96 reference points.
 *
 * @param name : auxiliary function name, up to 16 characters.
 * @param inputValues : array of floating point numbers, corresponding to the function input value.
 * @param outputValues : array of floating point numbers, corresponding to the output value
 *         desired for each of the input value, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) defineAuxiliaryFunction:(NSString*)name :(NSMutableArray*)inputValues :(NSMutableArray*)outputValues
{
    int siz;
    NSString* defstr;
    int idx;
    double inputVal;
    double outputVal;
    NSString* fname;
    siz = (int)[inputValues count];
    if (!(siz > 1)) {[self _throw:YAPI_INVALID_ARGUMENT:@"auxiliary function must be defined by at least two points"]; return YAPI_INVALID_ARGUMENT;}
    if (!(siz == (int)[outputValues count])) {[self _throw:YAPI_INVALID_ARGUMENT:@"table sizes mismatch"]; return YAPI_INVALID_ARGUMENT;}
    defstr = @"";
    idx = 0;
    while (idx < siz) {
        inputVal = [[inputValues objectAtIndex:idx] doubleValue];
        outputVal = [[outputValues objectAtIndex:idx] doubleValue];
        defstr = [NSString stringWithFormat:@"%@%g:%g\n",defstr,inputVal,outputVal];
        idx = idx + 1;
    }
    fname = [NSString stringWithFormat:@"userMap%@.txt",name];

    return [self _upload:fname :[NSMutableData dataWithData:[defstr dataUsingEncoding:NSISOLatin1StringEncoding]]];
}

/**
 * Retrieves the reference points table defining an auxiliary function previously
 * configured using the defineAuxiliaryFunction function.
 *
 * @param name : auxiliary function name, up to 16 characters.
 * @param inputValues : array of floating point numbers, that is filled by the function
 *         with all the function reference input value.
 * @param outputValues : array of floating point numbers, that is filled by the function
 *         output value for each of the input value, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadAuxiliaryFunction:(NSString*)name :(NSMutableArray*)inputValues :(NSMutableArray*)outputValues
{
    NSString* fname;
    NSMutableData* defbin;
    int siz;

    fname = [NSString stringWithFormat:@"userMap%@.txt",name];
    defbin = [self _download:fname];
    siz = (int)[defbin length];
    if (!(siz > 0)) {[self _throw:YAPI_INVALID_ARGUMENT:@"auxiliary function does not exist"]; return YAPI_INVALID_ARGUMENT;}
    [inputValues removeAllObjects];
    [outputValues removeAllObjects];
    // FIXME: decode line by line
    return YAPI_SUCCESS;
}


-(YArithmeticSensor*)   nextArithmeticSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YArithmeticSensor FindArithmeticSensor:hwid];
}

+(YArithmeticSensor *) FirstArithmeticSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"ArithmeticSensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YArithmeticSensor FindArithmeticSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YArithmeticSensor public methods implementation)
@end

//--- (YArithmeticSensor functions)

YArithmeticSensor *yFindArithmeticSensor(NSString* func)
{
    return [YArithmeticSensor FindArithmeticSensor:func];
}

YArithmeticSensor *yFirstArithmeticSensor(void)
{
    return [YArithmeticSensor FirstArithmeticSensor];
}

//--- (end of YArithmeticSensor functions)

