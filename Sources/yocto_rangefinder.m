/*********************************************************************
 *
 * $Id: yocto_rangefinder.m 26329 2017-01-11 14:04:39Z mvuilleu $
 *
 * Implements the high-level API for RangeFinder functions
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


#import "yocto_rangefinder.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YRangeFinder

// Constructor is protected, use yFindRangeFinder factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"RangeFinder";
//--- (YRangeFinder attributes initialization)
    _rangeFinderMode = Y_RANGEFINDERMODE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackRangeFinder = NULL;
    _timedReportCallbackRangeFinder = NULL;
//--- (end of YRangeFinder attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YRangeFinder cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YRangeFinder cleanup)
}
//--- (YRangeFinder private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "rangeFinderMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rangeFinderMode =  atoi(j->token);
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
//--- (end of YRangeFinder private methods implementation)
//--- (YRangeFinder public methods implementation)

/**
 * Changes the measuring unit for the measured temperature. That unit is a string.
 * String value can be " or mm. Any other value will be ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * WARNING: if a specific calibration is defined for the rangeFinder function, a
 * unit system change will probably break it.
 *
 * @param newval : a string corresponding to the measuring unit for the measured temperature
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns the rangefinder running mode. The rangefinder running mode
 * allows to put priority on precision, speed or maximum range.
 *
 * @return a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder running mode
 *
 * On failure, throws an exception or returns Y_RANGEFINDERMODE_INVALID.
 */
-(Y_RANGEFINDERMODE_enum) get_rangeFinderMode
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RANGEFINDERMODE_INVALID;
        }
    }
    return _rangeFinderMode;
}


-(Y_RANGEFINDERMODE_enum) rangeFinderMode
{
    return [self get_rangeFinderMode];
}

/**
 * Changes the rangefinder running mode, allowing to put priority on
 * precision, speed or maximum range.
 *
 * @param newval : a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder
 * running mode, allowing to put priority on
 *         precision, speed or maximum range
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rangeFinderMode:(Y_RANGEFINDERMODE_enum) newval
{
    return [self setRangeFinderMode:newval];
}
-(int) setRangeFinderMode:(Y_RANGEFINDERMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"rangeFinderMode" :rest_val];
}
-(NSString*) get_command
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    return _command;
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
 * Retrieves a range finder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the range finder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRangeFinder.isOnline() to test if the range finder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a range finder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the range finder
 *
 * @return a YRangeFinder object allowing you to drive the range finder.
 */
+(YRangeFinder*) FindRangeFinder:(NSString*)func
{
    YRangeFinder* obj;
    obj = (YRangeFinder*) [YFunction _FindFromCache:@"RangeFinder" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YRangeFinder alloc] initWith:func]);
        [YFunction _AddToCache:@"RangeFinder" : func :obj];
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
-(int) registerValueCallback:(YRangeFinderValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackRangeFinder = callback;
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
    if (_valueCallbackRangeFinder != NULL) {
        _valueCallbackRangeFinder(self, value);
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
-(int) registerTimedReportCallback:(YRangeFinderTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackRangeFinder = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackRangeFinder != NULL) {
        _timedReportCallbackRangeFinder(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Triggers a sensor calibration according to the current ambient temperature. That
 * calibration process needs no physical interaction with the sensor. It is performed
 * automatically at device startup, but it is recommended to start it again when the
 * temperature delta since last calibration exceeds 8°C.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) triggerTempCalibration
{
    return [self set_command:@"T"];
}


-(YRangeFinder*)   nextRangeFinder
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YRangeFinder FindRangeFinder:hwid];
}

+(YRangeFinder *) FirstRangeFinder
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"RangeFinder":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRangeFinder FindRangeFinder:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YRangeFinder public methods implementation)

@end
//--- (RangeFinder functions)

YRangeFinder *yFindRangeFinder(NSString* func)
{
    return [YRangeFinder FindRangeFinder:func];
}

YRangeFinder *yFirstRangeFinder(void)
{
    return [YRangeFinder FirstRangeFinder];
}

//--- (end of RangeFinder functions)
