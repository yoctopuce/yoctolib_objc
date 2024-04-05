/*********************************************************************
 *
 *  $Id: yocto_temperature.m 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Implements the high-level API for Temperature functions
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


#import "yocto_temperature.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YTemperature
// Constructor is protected, use yFindTemperature factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Temperature";
//--- (YTemperature attributes initialization)
    _sensorType = Y_SENSORTYPE_INVALID;
    _signalValue = Y_SIGNALVALUE_INVALID;
    _signalUnit = Y_SIGNALUNIT_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackTemperature = NULL;
    _timedReportCallbackTemperature = NULL;
//--- (end of YTemperature attributes initialization)
    return self;
}
//--- (YTemperature yapiwrapper)
//--- (end of YTemperature yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YTemperature cleanup)
    ARC_release(_signalUnit);
    _signalUnit = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YTemperature cleanup)
}
//--- (YTemperature private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "sensorType")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _sensorType =  atoi(j->token);
        return 1;
    }
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
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YTemperature private methods implementation)
//--- (YTemperature public methods implementation)

/**
 * Changes the measuring unit for the measured temperature. That unit is a string.
 * If that strings end with the letter F all temperatures values will returned in
 * Fahrenheit degrees. If that String ends with the letter K all values will be
 * returned in Kelvin degrees. If that string ends with the letter C all values will be
 * returned in Celsius degrees.  If the string ends with any other character the
 * change will be ignored. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 * WARNING: if a specific calibration is defined for the temperature function, a
 * unit system change will probably break it.
 *
 * @param newval : a string corresponding to the measuring unit for the measured temperature
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
 * Returns the temperature sensor type.
 *
 * @return a value among YTemperature.SENSORTYPE_DIGITAL, YTemperature.SENSORTYPE_TYPE_K,
 * YTemperature.SENSORTYPE_TYPE_E, YTemperature.SENSORTYPE_TYPE_J, YTemperature.SENSORTYPE_TYPE_N,
 * YTemperature.SENSORTYPE_TYPE_R, YTemperature.SENSORTYPE_TYPE_S, YTemperature.SENSORTYPE_TYPE_T,
 * YTemperature.SENSORTYPE_PT100_4WIRES, YTemperature.SENSORTYPE_PT100_3WIRES,
 * YTemperature.SENSORTYPE_PT100_2WIRES, YTemperature.SENSORTYPE_RES_OHM,
 * YTemperature.SENSORTYPE_RES_NTC, YTemperature.SENSORTYPE_RES_LINEAR,
 * YTemperature.SENSORTYPE_RES_INTERNAL, YTemperature.SENSORTYPE_IR,
 * YTemperature.SENSORTYPE_RES_PT1000 and YTemperature.SENSORTYPE_CHANNEL_OFF corresponding to the
 * temperature sensor type
 *
 * On failure, throws an exception or returns YTemperature.SENSORTYPE_INVALID.
 */
-(Y_SENSORTYPE_enum) get_sensorType
{
    Y_SENSORTYPE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SENSORTYPE_INVALID;
        }
    }
    res = _sensorType;
    return res;
}


-(Y_SENSORTYPE_enum) sensorType
{
    return [self get_sensorType];
}

/**
 * Changes the temperature sensor type.  This function is used
 * to define the type of thermocouple (K,E...) used with the device.
 * It has no effect if module is using a digital sensor or a thermistor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YTemperature.SENSORTYPE_DIGITAL, YTemperature.SENSORTYPE_TYPE_K,
 * YTemperature.SENSORTYPE_TYPE_E, YTemperature.SENSORTYPE_TYPE_J, YTemperature.SENSORTYPE_TYPE_N,
 * YTemperature.SENSORTYPE_TYPE_R, YTemperature.SENSORTYPE_TYPE_S, YTemperature.SENSORTYPE_TYPE_T,
 * YTemperature.SENSORTYPE_PT100_4WIRES, YTemperature.SENSORTYPE_PT100_3WIRES,
 * YTemperature.SENSORTYPE_PT100_2WIRES, YTemperature.SENSORTYPE_RES_OHM,
 * YTemperature.SENSORTYPE_RES_NTC, YTemperature.SENSORTYPE_RES_LINEAR,
 * YTemperature.SENSORTYPE_RES_INTERNAL, YTemperature.SENSORTYPE_IR,
 * YTemperature.SENSORTYPE_RES_PT1000 and YTemperature.SENSORTYPE_CHANNEL_OFF corresponding to the
 * temperature sensor type
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"sensorType" :rest_val];
}
/**
 * Returns the current value of the electrical signal measured by the sensor.
 *
 * @return a floating point number corresponding to the current value of the electrical signal
 * measured by the sensor
 *
 * On failure, throws an exception or returns YTemperature.SIGNALVALUE_INVALID.
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
 * On failure, throws an exception or returns YTemperature.SIGNALUNIT_INVALID.
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
 * Retrieves a temperature sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the temperature sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTemperature.isOnline() to test if the temperature sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a temperature sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the temperature sensor, for instance
 *         METEOMK2.temperature.
 *
 * @return a YTemperature object allowing you to drive the temperature sensor.
 */
+(YTemperature*) FindTemperature:(NSString*)func
{
    YTemperature* obj;
    obj = (YTemperature*) [YFunction _FindFromCache:@"Temperature" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YTemperature alloc] initWith:func]);
        [YFunction _AddToCache:@"Temperature" : func :obj];
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
-(int) registerValueCallback:(YTemperatureValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackTemperature = callback;
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
    if (_valueCallbackTemperature != NULL) {
        _valueCallbackTemperature(self, value);
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
-(int) registerTimedReportCallback:(YTemperatureTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackTemperature = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackTemperature != NULL) {
        _timedReportCallbackTemperature(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Configures NTC thermistor parameters in order to properly compute the temperature from
 * the measured resistance. For increased precision, you can enter a complete mapping
 * table using set_thermistorResponseTable. This function can only be used with a
 * temperature sensor based on thermistors.
 *
 * @param res25 : thermistor resistance at 25 degrees Celsius
 * @param beta : Beta value
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ntcParameters:(double)res25 :(double)beta
{
    double t0;
    double t1;
    double res100;
    NSMutableArray* tempValues = [NSMutableArray array];
    NSMutableArray* resValues = [NSMutableArray array];
    t0 = 25.0+273.15;
    t1 = 100.0+273.15;
    res100 = res25 * exp(beta*(1.0/t1 - 1.0/t0));
    [tempValues removeAllObjects];
    [resValues removeAllObjects];
    [tempValues addObject:[NSNumber numberWithDouble:25.0]];
    [resValues addObject:[NSNumber numberWithDouble:res25]];
    [tempValues addObject:[NSNumber numberWithDouble:100.0]];
    [resValues addObject:[NSNumber numberWithDouble:res100]];
    return [self set_thermistorResponseTable:tempValues :resValues];
}

/**
 * Records a thermistor response table, in order to interpolate the temperature from
 * the measured resistance. This function can only be used with a temperature
 * sensor based on thermistors.
 *
 * @param tempValues : array of floating point numbers, corresponding to all
 *         temperatures (in degrees Celsius) for which the resistance of the
 *         thermistor is specified.
 * @param resValues : array of floating point numbers, corresponding to the resistance
 *         values (in Ohms) for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_thermistorResponseTable:(NSMutableArray*)tempValues :(NSMutableArray*)resValues
{
    int siz;
    int res;
    int idx;
    int found;
    double prev;
    double curr;
    double currTemp;
    double idxres;
    siz = (int)[tempValues count];
    if (!(siz >= 2)) {[self _throw: YAPI_INVALID_ARGUMENT: @"thermistor response table must have at least two points"]; return YAPI_INVALID_ARGUMENT;}
    if (!(siz == (int)[resValues count])) {[self _throw: YAPI_INVALID_ARGUMENT: @"table sizes mismatch"]; return YAPI_INVALID_ARGUMENT;}

    res = [self set_command:@"Z"];
    if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to reset thermistor parameters"]; return YAPI_IO_ERROR;}
    // add records in growing resistance value
    found = 1;
    prev = 0.0;
    while (found > 0) {
        found = 0;
        curr = 99999999.0;
        currTemp = -999999.0;
        idx = 0;
        while (idx < siz) {
            idxres = [[resValues objectAtIndex:idx] doubleValue];
            if ((idxres > prev) && (idxres < curr)) {
                curr = idxres;
                currTemp = [[tempValues objectAtIndex:idx] doubleValue];
                found = 1;
            }
            idx = idx + 1;
        }
        if (found > 0) {
            res = [self set_command:[NSString stringWithFormat:@"m%d:%d", (int) floor(1000*curr+0.5),(int) floor(1000*currTemp+0.5)]];
            if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to reset thermistor parameters"]; return YAPI_IO_ERROR;}
            prev = curr;
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Retrieves the thermistor response table previously configured using the
 * set_thermistorResponseTable function. This function can only be used with a
 * temperature sensor based on thermistors.
 *
 * @param tempValues : array of floating point numbers, that is filled by the function
 *         with all temperatures (in degrees Celsius) for which the resistance
 *         of the thermistor is specified.
 * @param resValues : array of floating point numbers, that is filled by the function
 *         with the value (in Ohms) for each of the temperature included in the
 *         first argument, index by index.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadThermistorResponseTable:(NSMutableArray*)tempValues :(NSMutableArray*)resValues
{
    NSString* id;
    NSMutableData* bin_json;
    NSMutableArray* paramlist = [NSMutableArray array];
    NSMutableArray* templist = [NSMutableArray array];
    int siz;
    int idx;
    double temp;
    int found;
    double prev;
    double curr;
    double currRes;
    [tempValues removeAllObjects];
    [resValues removeAllObjects];

    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange( 11, (int)[(id) length] - 11)];
    if ([id isEqualToString:@""]) {
        id = @"1";
    }
    bin_json = [self _download:[NSString stringWithFormat:@"extra.json?page=%@",id]];
    paramlist = [self _json_get_array:bin_json];
    // first convert all temperatures to float
    siz = (((int)[paramlist count]) >> (1));
    [templist removeAllObjects];
    idx = 0;
    while (idx < siz) {
        temp = [[paramlist objectAtIndex:2*idx+1] doubleValue]/1000.0;
        [templist addObject:[NSNumber numberWithDouble:temp]];
        idx = idx + 1;
    }
    // then add records in growing temperature value
    [tempValues removeAllObjects];
    [resValues removeAllObjects];
    found = 1;
    prev = -999999.0;
    while (found > 0) {
        found = 0;
        curr = 999999.0;
        currRes = -999999.0;
        idx = 0;
        while (idx < siz) {
            temp = [[templist objectAtIndex:idx] doubleValue];
            if ((temp > prev) && (temp < curr)) {
                curr = temp;
                currRes = [[paramlist objectAtIndex:2*idx] doubleValue]/1000.0;
                found = 1;
            }
            idx = idx + 1;
        }
        if (found > 0) {
            [tempValues addObject:[NSNumber numberWithDouble:curr]];
            [resValues addObject:[NSNumber numberWithDouble:currRes]];
            prev = curr;
        }
    }
    return YAPI_SUCCESS;
}


-(YTemperature*)   nextTemperature
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YTemperature FindTemperature:hwid];
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

//--- (end of YTemperature public methods implementation)
@end

//--- (YTemperature functions)

YTemperature *yFindTemperature(NSString* func)
{
    return [YTemperature FindTemperature:func];
}

YTemperature *yFirstTemperature(void)
{
    return [YTemperature FirstTemperature];
}

//--- (end of YTemperature functions)

