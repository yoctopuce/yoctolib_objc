/*********************************************************************
 *
 *  $Id: yocto_rangefinder.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for RangeFinder functions
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
    _timeFrame = Y_TIMEFRAME_INVALID;
    _quality = Y_QUALITY_INVALID;
    _hardwareCalibration = Y_HARDWARECALIBRATION_INVALID;
    _currentTemperature = Y_CURRENTTEMPERATURE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackRangeFinder = NULL;
    _timedReportCallbackRangeFinder = NULL;
//--- (end of YRangeFinder attributes initialization)
    return self;
}
//--- (YRangeFinder yapiwrapper)
//--- (end of YRangeFinder yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YRangeFinder cleanup)
    ARC_release(_hardwareCalibration);
    _hardwareCalibration = nil;
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
    if(!strcmp(j->token, "timeFrame")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _timeFrame =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "quality")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _quality =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "hardwareCalibration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_hardwareCalibration);
        _hardwareCalibration =  [self _parseString:j];
        ARC_retain(_hardwareCalibration);
        return 1;
    }
    if(!strcmp(j->token, "currentTemperature")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentTemperature =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
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
 * Changes the measuring unit for the measured range. That unit is a string.
 * String value can be " or mm. Any other value is ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * WARNING: if a specific calibration is defined for the rangeFinder function, a
 * unit system change will probably break it.
 *
 * @param newval : a string corresponding to the measuring unit for the measured range
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
 * Returns the range finder running mode. The rangefinder running mode
 * allows you to put priority on precision, speed or maximum range.
 *
 * @return a value among YRangeFinder.RANGEFINDERMODE_DEFAULT,
 * YRangeFinder.RANGEFINDERMODE_LONG_RANGE, YRangeFinder.RANGEFINDERMODE_HIGH_ACCURACY and
 * YRangeFinder.RANGEFINDERMODE_HIGH_SPEED corresponding to the range finder running mode
 *
 * On failure, throws an exception or returns YRangeFinder.RANGEFINDERMODE_INVALID.
 */
-(Y_RANGEFINDERMODE_enum) get_rangeFinderMode
{
    Y_RANGEFINDERMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RANGEFINDERMODE_INVALID;
        }
    }
    res = _rangeFinderMode;
    return res;
}


-(Y_RANGEFINDERMODE_enum) rangeFinderMode
{
    return [self get_rangeFinderMode];
}

/**
 * Changes the rangefinder running mode, allowing you to put priority on
 * precision, speed or maximum range.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YRangeFinder.RANGEFINDERMODE_DEFAULT,
 * YRangeFinder.RANGEFINDERMODE_LONG_RANGE, YRangeFinder.RANGEFINDERMODE_HIGH_ACCURACY and
 * YRangeFinder.RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder running mode, allowing you
 * to put priority on
 *         precision, speed or maximum range
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
/**
 * Returns the time frame used to measure the distance and estimate the measure
 * reliability. The time frame is expressed in milliseconds.
 *
 * @return an integer corresponding to the time frame used to measure the distance and estimate the measure
 *         reliability
 *
 * On failure, throws an exception or returns YRangeFinder.TIMEFRAME_INVALID.
 */
-(s64) get_timeFrame
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TIMEFRAME_INVALID;
        }
    }
    res = _timeFrame;
    return res;
}


-(s64) timeFrame
{
    return [self get_timeFrame];
}

/**
 * Changes the time frame used to measure the distance and estimate the measure
 * reliability. The time frame is expressed in milliseconds. A larger timeframe
 * improves stability and reliability, at the cost of higher latency, but prevents
 * the detection of events shorter than the time frame.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the time frame used to measure the distance and estimate the measure
 *         reliability
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_timeFrame:(s64) newval
{
    return [self setTimeFrame:newval];
}
-(int) setTimeFrame:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"timeFrame" :rest_val];
}
/**
 * Returns a measure quality estimate, based on measured dispersion.
 *
 * @return an integer corresponding to a measure quality estimate, based on measured dispersion
 *
 * On failure, throws an exception or returns YRangeFinder.QUALITY_INVALID.
 */
-(int) get_quality
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_QUALITY_INVALID;
        }
    }
    res = _quality;
    return res;
}


-(int) quality
{
    return [self get_quality];
}
-(NSString*) get_hardwareCalibration
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_HARDWARECALIBRATION_INVALID;
        }
    }
    res = _hardwareCalibration;
    return res;
}


-(NSString*) hardwareCalibration
{
    return [self get_hardwareCalibration];
}

-(int) set_hardwareCalibration:(NSString*) newval
{
    return [self setHardwareCalibration:newval];
}
-(int) setHardwareCalibration:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"hardwareCalibration" :rest_val];
}
/**
 * Returns the current sensor temperature, as a floating point number.
 *
 * @return a floating point number corresponding to the current sensor temperature, as a floating point number
 *
 * On failure, throws an exception or returns YRangeFinder.CURRENTTEMPERATURE_INVALID.
 */
-(double) get_currentTemperature
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTTEMPERATURE_INVALID;
        }
    }
    res = _currentTemperature;
    return res;
}


-(double) currentTemperature
{
    return [self get_currentTemperature];
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
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the range finder, for instance
 *         YRNGFND1.rangeFinder1.
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
-(int) registerValueCallback:(YRangeFinderValueCallback _Nullable)callback
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
-(int) registerTimedReportCallback:(YRangeFinderTimedReportCallback _Nullable)callback
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
 * Returns the temperature at the time when the latest calibration was performed.
 * This function can be used to determine if a new calibration for ambient temperature
 * is required.
 *
 * @return a temperature, as a floating point number.
 *         On failure, throws an exception or return YAPI_INVALID_DOUBLE.
 */
-(double) get_hardwareCalibrationTemperature
{
    NSString* hwcal;
    hwcal = [self get_hardwareCalibration];
    if (!([[hwcal substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"])) {
        return YAPI_INVALID_DOUBLE;
    }
    return [[hwcal substringWithRange:NSMakeRange(1, (int)[(hwcal) length])] intValue];
}

/**
 * Triggers a sensor calibration according to the current ambient temperature. That
 * calibration process needs no physical interaction with the sensor. It is performed
 * automatically at device startup, but it is recommended to start it again when the
 * temperature delta since the latest calibration exceeds 8°C.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) triggerTemperatureCalibration
{
    return [self set_command:@"T"];
}

/**
 * Triggers the photon detector hardware calibration.
 * This function is part of the calibration procedure to compensate for the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) triggerSpadCalibration
{
    return [self set_command:@"S"];
}

/**
 * Triggers the hardware offset calibration of the distance sensor.
 * This function is part of the calibration procedure to compensate for the the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @param targetDist : true distance of the calibration target, in mm or inches, depending
 *         on the unit selected in the device
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) triggerOffsetCalibration:(double)targetDist
{
    int distmm;
    if ([[self get_unit] isEqualToString:@"\""]) {
        distmm = (int) floor(targetDist * 25.4+0.5);
    } else {
        distmm = (int) floor(targetDist+0.5);
    }
    return [self set_command:[NSString stringWithFormat:@"O%d",distmm]];
}

/**
 * Triggers the hardware cross-talk calibration of the distance sensor.
 * This function is part of the calibration procedure to compensate for the effect
 * of a cover glass. Make sure to read the chapter about hardware calibration for details
 * on the calibration procedure for proper results.
 *
 * @param targetDist : true distance of the calibration target, in mm or inches, depending
 *         on the unit selected in the device
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) triggerXTalkCalibration:(double)targetDist
{
    int distmm;
    if ([[self get_unit] isEqualToString:@"\""]) {
        distmm = (int) floor(targetDist * 25.4+0.5);
    } else {
        distmm = (int) floor(targetDist+0.5);
    }
    return [self set_command:[NSString stringWithFormat:@"X%d",distmm]];
}

/**
 * Cancels the effect of previous hardware calibration procedures to compensate
 * for cover glass, and restores factory settings.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) cancelCoverGlassCalibrations
{
    return [self set_hardwareCalibration:@""];
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

//--- (YRangeFinder functions)

YRangeFinder *yFindRangeFinder(NSString* func)
{
    return [YRangeFinder FindRangeFinder:func];
}

YRangeFinder *yFirstRangeFinder(void)
{
    return [YRangeFinder FirstRangeFinder];
}

//--- (end of YRangeFinder functions)

