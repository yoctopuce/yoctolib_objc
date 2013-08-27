/*********************************************************************
 *
 * $Id: yocto_temperature.m 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Implements yFindTemperature(), the high-level API for Temperature functions
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


#import "yocto_temperature.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YTemperature

// Constructor is protected, use yFindTemperature factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YTemperature attributes)
   if(!(self = [super initProtected:@"Temperature":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _unit = Y_UNIT_INVALID;
    _currentValue = Y_CURRENTVALUE_INVALID;
    _lowestValue = Y_LOWESTVALUE_INVALID;
    _highestValue = Y_HIGHESTVALUE_INVALID;
    _currentRawValue = Y_CURRENTRAWVALUE_INVALID;
    _calibrationParam = Y_CALIBRATIONPARAM_INVALID;
    _resolution = Y_RESOLUTION_INVALID;
    _sensorType = Y_SENSORTYPE_INVALID;
    _calibrationOffset = -32767;
//--- (end of YTemperature attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YTemperature cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_release(_unit);
    _unit = nil;
    ARC_release(_calibrationParam);
    _calibrationParam = nil;
//--- (end of YTemperature cleanup)
    ARC_dealloc(super);
}
//--- (YTemperature implementation)

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
            _currentValue =  floor(atof(j->token)/6553.6+.5) / 10;
        } else if(!strcmp(j->token, "lowestValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _lowestValue =  floor(atof(j->token)/6553.6+.5) / 10;
        } else if(!strcmp(j->token, "highestValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _highestValue =  floor(atof(j->token)/6553.6+.5) / 10;
        } else if(!strcmp(j->token, "currentRawValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _currentRawValue =  atof(j->token)/65536.0;
        } else if(!strcmp(j->token, "calibrationParam")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_calibrationParam);
            _calibrationParam =  [self _parseString:j];
            ARC_retain(_calibrationParam);
        } else if(!strcmp(j->token, "resolution")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _resolution =  (atoi(j->token) > 100 ? 1.0 / floor(65536.0/atof(j->token)+.5) : 0.001 / floor(67.0/atof(j->token)+.5));
        } else if(!strcmp(j->token, "sensorType")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _sensorType =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the temperature sensor.
 * 
 * @return a string corresponding to the logical name of the temperature sensor
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
 * Changes the logical name of the temperature sensor. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the temperature sensor
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
 * Returns the current value of the temperature sensor (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the temperature sensor (no more than 6 characters)
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
    if(_unit == Y_UNIT_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UNIT_INVALID;
    }
    return _unit;
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

/**
 * Returns the temperature sensor type.
 * 
 * @return a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES and
 * Y_SENSORTYPE_PT100_2WIRES corresponding to the temperature sensor type
 * 
 * On failure, throws an exception or returns Y_SENSORTYPE_INVALID.
 */
-(Y_SENSORTYPE_enum) get_sensorType
{
    return [self sensorType];
}
-(Y_SENSORTYPE_enum) sensorType
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SENSORTYPE_INVALID;
    }
    return _sensorType;
}

/**
 * Modify the temperature sensor type.  This function is used to
 * to define the type of thermocouple (K,E...) used with the device.
 * This will have no effect if module is using a digital sensor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES and Y_SENSORTYPE_PT100_2WIRES
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_sensorType:(Y_SENSORTYPE_enum) newval
{
    return [self setSensorType:newval];
}
-(int) setSensorType:(Y_SENSORTYPE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"sensorType" :rest_val];
}

-(YTemperature*)   nextTemperature
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindTemperature(hwid);
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

+(YTemperature*) FindTemperature:(NSString*) func
{
    YTemperature * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YTemperature"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YTemperature"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YTemperature"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YTemperature"] objectForKey:func];
    } else {
        retVal = [[YTemperature alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YTemperature"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YTemperature *) FirstTemperature
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Temperature":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YTemperature FindTemperature:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YTemperature implementation)

@end
//--- (Temperature functions)

YTemperature *yFindTemperature(NSString* func)
{
    return [YTemperature FindTemperature:func];
}

YTemperature *yFirstTemperature(void)
{
    return [YTemperature FirstTemperature];
}

//--- (end of Temperature functions)
