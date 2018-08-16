/*********************************************************************
 *
 * $Id: yocto_carbondioxide.m 31436 2018-08-07 15:28:18Z seb $
 *
 * Implements the high-level API for CarbonDioxide functions
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


#import "yocto_carbondioxide.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YCarbonDioxide

// Constructor is protected, use yFindCarbonDioxide factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"CarbonDioxide";
//--- (YCarbonDioxide attributes initialization)
    _abcPeriod = Y_ABCPERIOD_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackCarbonDioxide = NULL;
    _timedReportCallbackCarbonDioxide = NULL;
//--- (end of YCarbonDioxide attributes initialization)
    return self;
}
//--- (YCarbonDioxide yapiwrapper)
//--- (end of YCarbonDioxide yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YCarbonDioxide cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YCarbonDioxide cleanup)
}
//--- (YCarbonDioxide private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "abcPeriod")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _abcPeriod =  atoi(j->token);
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
//--- (end of YCarbonDioxide private methods implementation)
//--- (YCarbonDioxide public methods implementation)
/**
 * Returns the Automatic Baseline Calibration period, in hours. A negative value
 * means that automatic baseline calibration is disabled.
 *
 * @return an integer corresponding to the Automatic Baseline Calibration period, in hours
 *
 * On failure, throws an exception or returns Y_ABCPERIOD_INVALID.
 */
-(int) get_abcPeriod
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ABCPERIOD_INVALID;
        }
    }
    res = _abcPeriod;
    return res;
}


-(int) abcPeriod
{
    return [self get_abcPeriod];
}

/**
 * Changes Automatic Baseline Calibration period, in hours. If you need
 * to disable automatic baseline calibration (for instance when using the
 * sensor in an environment that is constantly above 400ppm CO2), set the
 * period to -1. Remember to call the saveToFlash() method of the
 * module if the modification must be kept.
 *
 * @param newval : an integer corresponding to Automatic Baseline Calibration period, in hours
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_abcPeriod:(int) newval
{
    return [self setAbcPeriod:newval];
}
-(int) setAbcPeriod:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"abcPeriod" :rest_val];
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
 * Retrieves a CO2 sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the CO2 sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCarbonDioxide.isOnline() to test if the CO2 sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a CO2 sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the CO2 sensor
 *
 * @return a YCarbonDioxide object allowing you to drive the CO2 sensor.
 */
+(YCarbonDioxide*) FindCarbonDioxide:(NSString*)func
{
    YCarbonDioxide* obj;
    obj = (YCarbonDioxide*) [YFunction _FindFromCache:@"CarbonDioxide" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YCarbonDioxide alloc] initWith:func]);
        [YFunction _AddToCache:@"CarbonDioxide" : func :obj];
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
-(int) registerValueCallback:(YCarbonDioxideValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackCarbonDioxide = callback;
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
    if (_valueCallbackCarbonDioxide != NULL) {
        _valueCallbackCarbonDioxide(self, value);
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
-(int) registerTimedReportCallback:(YCarbonDioxideTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackCarbonDioxide = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackCarbonDioxide != NULL) {
        _timedReportCallbackCarbonDioxide(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Triggers a baseline calibration at standard CO2 ambiant level (400ppm).
 * It is normally not necessary to manually calibrate the sensor, because
 * the built-in automatic baseline calibration procedure will automatically
 * fix any long-term drift based on the lowest level of CO2 observed over the
 * automatic calibration period. However, if you disable automatic baseline
 * calibration, you may want to manually trigger a calibration from time to
 * time. Before starting a baseline calibration, make sure to put the sensor
 * in a standard environment (e.g. outside in fresh air) at around 400ppm.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerBaselineCalibration
{
    return [self set_command:@"BC"];
}

-(int) triggetBaselineCalibration
{
    return [self triggerBaselineCalibration];
}

/**
 * Triggers a zero calibration of the sensor on carbon dioxide-free air.
 * It is normally not necessary to manually calibrate the sensor, because
 * the built-in automatic baseline calibration procedure will automatically
 * fix any long-term drift based on the lowest level of CO2 observed over the
 * automatic calibration period. However, if you disable automatic baseline
 * calibration, you may want to manually trigger a calibration from time to
 * time. Before starting a zero calibration, you should circulate carbon
 * dioxide-free air within the sensor for a minute or two, using a small pipe
 * connected to the sensor. Please contact support@yoctopuce.com for more details
 * on the zero calibration procedure.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerZeroCalibration
{
    return [self set_command:@"ZC"];
}

-(int) triggetZeroCalibration
{
    return [self triggerZeroCalibration];
}


-(YCarbonDioxide*)   nextCarbonDioxide
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YCarbonDioxide FindCarbonDioxide:hwid];
}

+(YCarbonDioxide *) FirstCarbonDioxide
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"CarbonDioxide":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YCarbonDioxide FindCarbonDioxide:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YCarbonDioxide public methods implementation)

@end
//--- (YCarbonDioxide functions)

YCarbonDioxide *yFindCarbonDioxide(NSString* func)
{
    return [YCarbonDioxide FindCarbonDioxide:func];
}

YCarbonDioxide *yFirstCarbonDioxide(void)
{
    return [YCarbonDioxide FirstCarbonDioxide];
}

//--- (end of YCarbonDioxide functions)
