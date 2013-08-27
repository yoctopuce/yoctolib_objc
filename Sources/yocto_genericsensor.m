/*********************************************************************
 *
 * $Id: yocto_genericsensor.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindGenericSensor(), the high-level API for GenericSensor functions
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
-(id)              initWithFunction:(NSString*) func
{
//--- (YGenericSensor attributes)
   if(!(self = [super initProtected:@"GenericSensor":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _unit = Y_UNIT_INVALID;
    _currentValue = Y_CURRENTVALUE_INVALID;
    _lowestValue = Y_LOWESTVALUE_INVALID;
    _highestValue = Y_HIGHESTVALUE_INVALID;
    _currentRawValue = Y_CURRENTRAWVALUE_INVALID;
    _calibrationParam = Y_CALIBRATIONPARAM_INVALID;
    _signalValue = Y_SIGNALVALUE_INVALID;
    _signalUnit = Y_SIGNALUNIT_INVALID;
    _signalRange = Y_SIGNALRANGE_INVALID;
    _valueRange = Y_VALUERANGE_INVALID;
    _resolution = Y_RESOLUTION_INVALID;
    _calibrationOffset = 0;
//--- (end of YGenericSensor attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YGenericSensor cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_release(_unit);
    _unit = nil;
    ARC_release(_calibrationParam);
    _calibrationParam = nil;
    ARC_release(_signalUnit);
    _signalUnit = nil;
    ARC_release(_signalRange);
    _signalRange = nil;
    ARC_release(_valueRange);
    _valueRange = nil;
//--- (end of YGenericSensor cleanup)
    ARC_dealloc(super);
}
//--- (YGenericSensor implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "unit")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_unit);
            _unit =  [self _parseString:j];
            ARC_retain(_unit);
        } else if(!strcmp(j->token, "currentValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _currentValue =  floor(atof(j->token)/65.536+.5) / 1000;
        } else if(!strcmp(j->token, "lowestValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _lowestValue =  floor(atof(j->token)/65.536+.5) / 1000;
        } else if(!strcmp(j->token, "highestValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _highestValue =  floor(atof(j->token)/65.536+.5) / 1000;
        } else if(!strcmp(j->token, "currentRawValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _currentRawValue =  atof(j->token)/65536.0;
        } else if(!strcmp(j->token, "calibrationParam")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_calibrationParam);
            _calibrationParam =  [self _parseString:j];
            ARC_retain(_calibrationParam);
        } else if(!strcmp(j->token, "signalValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _signalValue =  floor(atof(j->token)/65.536+.5) / 1000;
        } else if(!strcmp(j->token, "signalUnit")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_signalUnit);
            _signalUnit =  [self _parseString:j];
            ARC_retain(_signalUnit);
        } else if(!strcmp(j->token, "signalRange")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_signalRange);
            _signalRange =  [self _parseString:j];
            ARC_retain(_signalRange);
        } else if(!strcmp(j->token, "valueRange")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_valueRange);
            _valueRange =  [self _parseString:j];
            ARC_retain(_valueRange);
        } else if(!strcmp(j->token, "resolution")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _resolution =  (atoi(j->token) > 100 ? 1.0 / floor(65536.0/atof(j->token)+.5) : 0.001 / floor(67.0/atof(j->token)+.5));
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the generic sensor.
 * 
 * @return a string corresponding to the logical name of the generic sensor
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * Changes the logical name of the generic sensor. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the generic sensor
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the generic sensor (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the generic sensor (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the measuring unit for the measured value.
 * 
 * @return a string corresponding to the measuring unit for the measured value
 * 
 * On failure, throws an exception or returns Y_UNIT_INVALID.
 */
-(NSString*) get_unit
{
    return [self unit];
}
-(NSString*) unit
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UNIT_INVALID;
    }
    return _unit;
}

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
 * Returns the current measured value.
 * 
 * @return a floating point number corresponding to the current measured value
 * 
 * On failure, throws an exception or returns Y_CURRENTVALUE_INVALID.
 */
-(double) get_currentValue
{
    return [self currentValue];
}
-(double) currentValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CURRENTVALUE_INVALID;
    }
    double res = [YAPI _applyCalibration:_currentRawValue: _calibrationParam: _calibrationOffset: _resolution];
    if(res != Y_CURRENTVALUE_INVALID) return res;
    return _currentValue;
}

/**
 * Changes the recorded minimal value observed.
 * 
 * @param newval : a floating point number corresponding to the recorded minimal value observed
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_lowestValue:(double) newval
{
    return [self setLowestValue:newval];
}
-(int) setLowestValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval*65536.0+0.5)];
    return [self _setAttr:@"lowestValue" :rest_val];
}

/**
 * Returns the minimal value observed.
 * 
 * @return a floating point number corresponding to the minimal value observed
 * 
 * On failure, throws an exception or returns Y_LOWESTVALUE_INVALID.
 */
-(double) get_lowestValue
{
    return [self lowestValue];
}
-(double) lowestValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOWESTVALUE_INVALID;
    }
    return _lowestValue;
}

/**
 * Changes the recorded maximal value observed.
 * 
 * @param newval : a floating point number corresponding to the recorded maximal value observed
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_highestValue:(double) newval
{
    return [self setHighestValue:newval];
}
-(int) setHighestValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval*65536.0+0.5)];
    return [self _setAttr:@"highestValue" :rest_val];
}

/**
 * Returns the maximal value observed.
 * 
 * @return a floating point number corresponding to the maximal value observed
 * 
 * On failure, throws an exception or returns Y_HIGHESTVALUE_INVALID.
 */
-(double) get_highestValue
{
    return [self highestValue];
}
-(double) highestValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_HIGHESTVALUE_INVALID;
    }
    return _highestValue;
}

/**
 * Returns the uncalibrated, unrounded raw value returned by the sensor.
 * 
 * @return a floating point number corresponding to the uncalibrated, unrounded raw value returned by the sensor
 * 
 * On failure, throws an exception or returns Y_CURRENTRAWVALUE_INVALID.
 */
-(double) get_currentRawValue
{
    return [self currentRawValue];
}
-(double) currentRawValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CURRENTRAWVALUE_INVALID;
    }
    return _currentRawValue;
}

-(NSString*) get_calibrationParam
{
    return [self calibrationParam];
}
-(NSString*) calibrationParam
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALIBRATIONPARAM_INVALID;
    }
    return _calibrationParam;
}

-(int) set_calibrationParam:(NSString*) newval
{
    return [self setCalibrationParam:newval];
}
-(int) setCalibrationParam:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"calibrationParam" :rest_val];
}

/**
 * Configures error correction data points, in particular to compensate for
 * a possible perturbation of the measure caused by an enclosure. It is possible
 * to configure up to five correction points. Correction points must be provided
 * in ascending order, and be in the range of the sensor. The device will automatically
 * perform a linear interpolation of the error correction between specified
 * points. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * For more information on advanced capabilities to refine the calibration of
 * sensors, please contact support@yoctopuce.com.
 * 
 * @param rawValues : array of floating point numbers, corresponding to the raw
 *         values returned by the sensor for the correction points.
 * @param refValues : array of floating point numbers, corresponding to the corrected
 *         values for the correction points.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) calibrateFromPoints :(NSMutableArray*)rawValues :(NSMutableArray*)refValues
{
    NSString* rest_val;
    rest_val = [YAPI _encodeCalibrationPoints:rawValues:refValues:_resolution:_calibrationOffset:_calibrationParam];
    return [self _setAttr:@"calibrationParam" :rest_val];
}

-(int) loadCalibrationPoints :(NSMutableArray*)rawValues :(NSMutableArray*)refValues
{
    if(_cacheExpiration <= [YAPI GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return (int)[_lastError code];
    }
    return [YAPI _decodeCalibrationPoints:_calibrationParam:nil:rawValues:refValues withResolution:_resolution andOffset:_calibrationOffset];
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
    return [self signalValue];
}
-(double) signalValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SIGNALVALUE_INVALID;
    }
    return _signalValue;
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
    return [self signalUnit];
}
-(NSString*) signalUnit
{
    if(_signalUnit == Y_SIGNALUNIT_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SIGNALUNIT_INVALID;
    }
    return _signalUnit;
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
    return [self signalRange];
}
-(NSString*) signalRange
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SIGNALRANGE_INVALID;
    }
    return _signalRange;
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
    return [self valueRange];
}
-(NSString*) valueRange
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_VALUERANGE_INVALID;
    }
    return _valueRange;
}

/**
 * Changes the physical value range measured by the sensor. The range change may have a side effect
 * on the display resolution, as it may be adapted automatically.
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
 * Changes the resolution of the measured physical values. The resolution corresponds to the numerical precision
 * when displaying value. It does not change the precision of the measure itself.
 * 
 * @param newval : a floating point number corresponding to the resolution of the measured physical values
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_resolution:(double) newval
{
    return [self setResolution:newval];
}
-(int) setResolution:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval*65536.0+0.5)];
    return [self _setAttr:@"resolution" :rest_val];
}

/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the values, which is not always the same as the actual precision of the sensor.
 * 
 * @return a floating point number corresponding to the resolution of the measured values
 * 
 * On failure, throws an exception or returns Y_RESOLUTION_INVALID.
 */
-(double) get_resolution
{
    return [self resolution];
}
-(double) resolution
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RESOLUTION_INVALID;
    }
    return _resolution;
}

-(YGenericSensor*)   nextGenericSensor
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindGenericSensor(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YGenericSensor*) FindGenericSensor:(NSString*) func
{
    YGenericSensor * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YGenericSensor"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YGenericSensor"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YGenericSensor"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YGenericSensor"] objectForKey:func];
    } else {
        retVal = [[YGenericSensor alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YGenericSensor"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of YGenericSensor implementation)

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
