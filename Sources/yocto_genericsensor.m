/*********************************************************************
 *
 * $Id: yocto_genericsensor.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for GenericSensor functions
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
    _valueCallbackGenericSensor = NULL;
    _timedReportCallbackGenericSensor = NULL;
//--- (end of YGenericSensor attributes initialization)
    return self;
}
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
        _signalValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
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
        _signalBias =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "signalSampling")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signalSampling =  atoi(j->token);
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
 * Returns the measured value of the electrical signal used by the sensor.
 *
 * @return a floating point number corresponding to the measured value of the electrical signal used by the sensor
 *
 * On failure, throws an exception or returns Y_SIGNALVALUE_INVALID.
 */
-(double) get_signalValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALVALUE_INVALID;
        }
    }
    return floor(_signalValue * 1000+0.5) / 1000;
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
 * On failure, throws an exception or returns Y_SIGNALUNIT_INVALID.
 */
-(NSString*) get_signalUnit
{
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALUNIT_INVALID;
        }
    }
    return _signalUnit;
}


-(NSString*) signalUnit
{
    return [self get_signalUnit];
}
/**
 * Returns the electric signal range used by the sensor.
 *
 * @return a string corresponding to the electric signal range used by the sensor
 *
 * On failure, throws an exception or returns Y_SIGNALRANGE_INVALID.
 */
-(NSString*) get_signalRange
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALRANGE_INVALID;
        }
    }
    return _signalRange;
}


-(NSString*) signalRange
{
    return [self get_signalRange];
}

/**
 * Changes the electric signal range used by the sensor.
 *
 * @param newval : a string corresponding to the electric signal range used by the sensor
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_VALUERANGE_INVALID.
 */
-(NSString*) get_valueRange
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VALUERANGE_INVALID;
        }
    }
    return _valueRange;
}


-(NSString*) valueRange
{
    return [self get_valueRange];
}

/**
 * Changes the physical value range measured by the sensor. As a side effect, the range modification may
 * automatically modify the display resolution.
 *
 * @param newval : a string corresponding to the physical value range measured by the sensor
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * If your electric signal reads positif when it should be zero, setup
 * a positive signalBias of the same value to fix the zero shift.
 *
 * @param newval : a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"signalBias" :rest_val];
}
/**
 * Returns the electric signal bias for zero shift adjustment.
 * A positive bias means that the signal is over-reporting the measure,
 * while a negative bias means that the signal is underreporting the measure.
 *
 * @return a floating point number corresponding to the electric signal bias for zero shift adjustment
 *
 * On failure, throws an exception or returns Y_SIGNALBIAS_INVALID.
 */
-(double) get_signalBias
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALBIAS_INVALID;
        }
    }
    return _signalBias;
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
 * @return a value among Y_SIGNALSAMPLING_HIGH_RATE, Y_SIGNALSAMPLING_HIGH_RATE_FILTERED,
 * Y_SIGNALSAMPLING_LOW_NOISE and Y_SIGNALSAMPLING_LOW_NOISE_FILTERED corresponding to the electric
 * signal sampling method to use
 *
 * On failure, throws an exception or returns Y_SIGNALSAMPLING_INVALID.
 */
-(Y_SIGNALSAMPLING_enum) get_signalSampling
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNALSAMPLING_INVALID;
        }
    }
    return _signalSampling;
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
 *
 * @param newval : a value among Y_SIGNALSAMPLING_HIGH_RATE, Y_SIGNALSAMPLING_HIGH_RATE_FILTERED,
 * Y_SIGNALSAMPLING_LOW_NOISE and Y_SIGNALSAMPLING_LOW_NOISE_FILTERED corresponding to the electric
 * signal sampling method to use
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Use the method YGenericSensor.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YGenericSensor object allowing you to drive $THEFUNCTION$.
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
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YGenericSensorValueCallback)callback
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
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YGenericSensorTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
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
 * precisely as zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
//--- (GenericSensor functions)

YGenericSensor *yFindGenericSensor(NSString* func)
{
    return [YGenericSensor FindGenericSensor:func];
}

YGenericSensor *yFirstGenericSensor(void)
{
    return [YGenericSensor FirstGenericSensor];
}

//--- (end of GenericSensor functions)
