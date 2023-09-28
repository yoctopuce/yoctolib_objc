/*********************************************************************
 *
 *  $Id: yocto_genericsensor.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for GenericSensor functions
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


#import "yocto_genericsensor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YGenericSensor
// Constructor is protected, use yFindGenericSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"GenericSensor";
//--- (YGenericSensor attributes initialization)
    _signalValue = Y_SIGNALVALUE_INVALID;
    _signalUnit = Y_SIGNALUNIT_INVALID;
    _signalRange = Y_SIGNALRANGE_INVALID;
    _valueRange = Y_VALUERANGE_INVALID;
    _signalBias = Y_SIGNALBIAS_INVALID;
    _signalSampling = Y_SIGNALSAMPLING_INVALID;
    _enabled = Y_ENABLED_INVALID;
    _valueCallbackGenericSensor = NULL;
    _timedReportCallbackGenericSensor = NULL;
//--- (end of YGenericSensor attributes initialization)
    return self;
}
//--- (YGenericSensor yapiwrapper)
//--- (end of YGenericSensor yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YGenericSensor cleanup)
    ARC_release(_signalUnit);
    _signalUnit = nil;
    ARC_release(_signalRange);
    _signalRange = nil;
    ARC_release(_valueRange);
    _valueRange = nil;
    ARC_dealloc(super);
//--- (end of YGenericSensor cleanup)
}
//--- (YGenericSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "signalValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signalValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "signalUnit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_signalUnit);
        _signalUnit =  [self _parseString:j];
        ARC_retain(_signalUnit);
        return 1;
    }
    if(!strcmp(j->token, "signalRange")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_signalRange);
        _signalRange =  [self _parseString:j];
        ARC_retain(_signalRange);
        return 1;
    }
    if(!strcmp(j->token, "valueRange")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_valueRange);
        _valueRange =  [self _parseString:j];
        ARC_retain(_valueRange);
        return 1;
    }
    if(!strcmp(j->token, "signalBias")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signalBias =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "signalSampling")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signalSampling =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YGenericSensor private methods implementation)
//--- (YGenericSensor public methods implementation)

/**
 * Changes the measuring unit for the measured value.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the measured value
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
 * Returns the current value of the electrical signal measured by the sensor.
 *
 * @return a floating point number corresponding to the current value of the electrical signal
 * measured by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALVALUE_INVALID.
 */
-(double) get_signalValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALVALUE_INVALID;
        }
    }
    res = floor(_signalValue * 1000+0.5) / 1000;
    return res;
}


-(double) signalValue
{
    return [self get_signalValue];
}
/**
 * Returns the measuring unit of the electrical signal used by the sensor.
 *
 * @return a string corresponding to the measuring unit of the electrical signal used by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALUNIT_INVALID.
 */
-(NSString*) get_signalUnit
{
    NSString* res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALUNIT_INVALID;
        }
    }
    res = _signalUnit;
    return res;
}


-(NSString*) signalUnit
{
    return [self get_signalUnit];
}
/**
 * Returns the input signal range used by the sensor.
 *
 * @return a string corresponding to the input signal range used by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALRANGE_INVALID.
 */
-(NSString*) get_signalRange
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALRANGE_INVALID;
        }
    }
    res = _signalRange;
    return res;
}


-(NSString*) signalRange
{
    return [self get_signalRange];
}

/**
 * Changes the input signal range used by the sensor.
 * When the input signal gets out of the planned range, the output value
 * will be set to an arbitrary large value, whose sign indicates the direction
 * of the range overrun.
 *
 * For a 4-20mA sensor, the default input signal range is "4...20".
 * For a 0-10V sensor, the default input signal range is "0.1...10".
 * For numeric communication interfaces, the default input signal range is
 * "-999999.999...999999.999".
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the input signal range used by the sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_signalRange:(NSString*) newval
{
    return [self setSignalRange:newval];
}
-(int) setSignalRange:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"signalRange" :rest_val];
}
/**
 * Returns the physical value range measured by the sensor.
 *
 * @return a string corresponding to the physical value range measured by the sensor
 *
 * On failure, throws an exception or returns YGenericSensor.VALUERANGE_INVALID.
 */
-(NSString*) get_valueRange
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VALUERANGE_INVALID;
        }
    }
    res = _valueRange;
    return res;
}


-(NSString*) valueRange
{
    return [self get_valueRange];
}

/**
 * Changes the output value range, corresponding to the physical value measured
 * by the sensor. The default output value range is the same as the input signal
 * range (1:1 mapping), but you can change it so that the function automatically
 * computes the physical value encoded by the input signal. Be aware that, as a
 * side effect, the range modification may automatically modify the display resolution.
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the output value range, corresponding to the physical value measured
 *         by the sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_valueRange:(NSString*) newval
{
    return [self setValueRange:newval];
}
-(int) setValueRange:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"valueRange" :rest_val];
}

/**
 * Changes the electric signal bias for zero shift adjustment.
 * If your electric signal reads positive when it should be zero, setup
 * a positive signalBias of the same value to fix the zero shift.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_signalBias:(double) newval
{
    return [self setSignalBias:newval];
}
-(int) setSignalBias:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"signalBias" :rest_val];
}
/**
 * Returns the electric signal bias for zero shift adjustment.
 * A positive bias means that the signal is over-reporting the measure,
 * while a negative bias means that the signal is under-reporting the measure.
 *
 * @return a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALBIAS_INVALID.
 */
-(double) get_signalBias
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALBIAS_INVALID;
        }
    }
    res = _signalBias;
    return res;
}


-(double) signalBias
{
    return [self get_signalBias];
}
/**
 * Returns the electric signal sampling method to use.
 * The HIGH_RATE method uses the highest sampling frequency, without any filtering.
 * The HIGH_RATE_FILTERED method adds a windowed 7-sample median filter.
 * The LOW_NOISE method uses a reduced acquisition frequency to reduce noise.
 * The LOW_NOISE_FILTERED method combines a reduced frequency with the median filter
 * to get measures as stable as possible when working on a noisy signal.
 *
 * @return a value among YGenericSensor.SIGNALSAMPLING_HIGH_RATE,
 * YGenericSensor.SIGNALSAMPLING_HIGH_RATE_FILTERED, YGenericSensor.SIGNALSAMPLING_LOW_NOISE,
 * YGenericSensor.SIGNALSAMPLING_LOW_NOISE_FILTERED, YGenericSensor.SIGNALSAMPLING_HIGHEST_RATE and
 * YGenericSensor.SIGNALSAMPLING_AC corresponding to the electric signal sampling method to use
 *
 * On failure, throws an exception or returns YGenericSensor.SIGNALSAMPLING_INVALID.
 */
-(Y_SIGNALSAMPLING_enum) get_signalSampling
{
    Y_SIGNALSAMPLING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALSAMPLING_INVALID;
        }
    }
    res = _signalSampling;
    return res;
}


-(Y_SIGNALSAMPLING_enum) signalSampling
{
    return [self get_signalSampling];
}

/**
 * Changes the electric signal sampling method to use.
 * The HIGH_RATE method uses the highest sampling frequency, without any filtering.
 * The HIGH_RATE_FILTERED method adds a windowed 7-sample median filter.
 * The LOW_NOISE method uses a reduced acquisition frequency to reduce noise.
 * The LOW_NOISE_FILTERED method combines a reduced frequency with the median filter
 * to get measures as stable as possible when working on a noisy signal.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a value among YGenericSensor.SIGNALSAMPLING_HIGH_RATE,
 * YGenericSensor.SIGNALSAMPLING_HIGH_RATE_FILTERED, YGenericSensor.SIGNALSAMPLING_LOW_NOISE,
 * YGenericSensor.SIGNALSAMPLING_LOW_NOISE_FILTERED, YGenericSensor.SIGNALSAMPLING_HIGHEST_RATE and
 * YGenericSensor.SIGNALSAMPLING_AC corresponding to the electric signal sampling method to use
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_signalSampling:(Y_SIGNALSAMPLING_enum) newval
{
    return [self setSignalSampling:newval];
}
-(int) setSignalSampling:(Y_SIGNALSAMPLING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"signalSampling" :rest_val];
}
/**
 * Returns the activation state of this input.
 *
 * @return either YGenericSensor.ENABLED_FALSE or YGenericSensor.ENABLED_TRUE, according to the
 * activation state of this input
 *
 * On failure, throws an exception or returns YGenericSensor.ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    Y_ENABLED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLED_INVALID;
        }
    }
    res = _enabled;
    return res;
}


-(Y_ENABLED_enum) enabled
{
    return [self get_enabled];
}

/**
 * Changes the activation state of this input. When an input is disabled,
 * its value is no more updated. On some devices, disabling an input can
 * improve the refresh rate of the other active inputs.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YGenericSensor.ENABLED_FALSE or YGenericSensor.ENABLED_TRUE, according to
 * the activation state of this input
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabled:(Y_ENABLED_enum) newval
{
    return [self setEnabled:newval];
}
-(int) setEnabled:(Y_ENABLED_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabled" :rest_val];
}
/**
 * Retrieves a generic sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the generic sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGenericSensor.isOnline() to test if the generic sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a generic sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the generic sensor, for instance
 *         RX010V01.genericSensor1.
 *
 * @return a YGenericSensor object allowing you to drive the generic sensor.
 */
+(YGenericSensor*) FindGenericSensor:(NSString*)func
{
    YGenericSensor* obj;
    obj = (YGenericSensor*) [YFunction _FindFromCache:@"GenericSensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YGenericSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"GenericSensor" : func :obj];
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
-(int) registerValueCallback:(YGenericSensorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackGenericSensor = callback;
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
    if (_valueCallbackGenericSensor != NULL) {
        _valueCallbackGenericSensor(self, value);
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
-(int) registerTimedReportCallback:(YGenericSensorTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackGenericSensor = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackGenericSensor != NULL) {
        _timedReportCallbackGenericSensor(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Adjusts the signal bias so that the current signal value is need
 * precisely as zero. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) zeroAdjust
{
    double currSignal;
    double currBias;
    currSignal = [self get_signalValue];
    currBias = [self get_signalBias];
    return [self set_signalBias:currSignal + currBias];
}


-(YGenericSensor*)   nextGenericSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YGenericSensor FindGenericSensor:hwid];
}

+(YGenericSensor *) FirstGenericSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"GenericSensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YGenericSensor FindGenericSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YGenericSensor public methods implementation)
@end

//--- (YGenericSensor functions)

YGenericSensor *yFindGenericSensor(NSString* func)
{
    return [YGenericSensor FindGenericSensor:func];
}

YGenericSensor *yFirstGenericSensor(void)
{
    return [YGenericSensor FirstGenericSensor];
}

//--- (end of YGenericSensor functions)

