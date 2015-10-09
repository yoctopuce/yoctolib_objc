/*********************************************************************
 *
 * $Id: yocto_temperature.m 21576 2015-09-21 13:17:28Z seb $
 *
 * Implements the high-level API for Temperature functions
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
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Temperature";
//--- (YTemperature attributes initialization)
    _sensorType = Y_SENSORTYPE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackTemperature = NULL;
    _timedReportCallbackTemperature = NULL;
//--- (end of YTemperature attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YTemperature cleanup)
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
 * Returns the temperature sensor type.
 *
 * @return a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES,
 * Y_SENSORTYPE_PT100_2WIRES, Y_SENSORTYPE_RES_OHM, Y_SENSORTYPE_RES_NTC and Y_SENSORTYPE_RES_LINEAR
 * corresponding to the temperature sensor type
 *
 * On failure, throws an exception or returns Y_SENSORTYPE_INVALID.
 */
-(Y_SENSORTYPE_enum) get_sensorType
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SENSORTYPE_INVALID;
        }
    }
    return _sensorType;
}


-(Y_SENSORTYPE_enum) sensorType
{
    return [self get_sensorType];
}

/**
 * Modifies the temperature sensor type.  This function is used
 * to define the type of thermocouple (K,E...) used with the device.
 * It has no effect if module is using a digital sensor or a thermistor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_SENSORTYPE_DIGITAL, Y_SENSORTYPE_TYPE_K, Y_SENSORTYPE_TYPE_E,
 * Y_SENSORTYPE_TYPE_J, Y_SENSORTYPE_TYPE_N, Y_SENSORTYPE_TYPE_R, Y_SENSORTYPE_TYPE_S,
 * Y_SENSORTYPE_TYPE_T, Y_SENSORTYPE_PT100_4WIRES, Y_SENSORTYPE_PT100_3WIRES,
 * Y_SENSORTYPE_PT100_2WIRES, Y_SENSORTYPE_RES_OHM, Y_SENSORTYPE_RES_NTC and Y_SENSORTYPE_RES_LINEAR
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
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"sensorType" :rest_val];
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
 * Use the method YTemperature.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YTemperature object allowing you to drive $THEFUNCTION$.
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
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YTemperatureValueCallback)callback
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
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YTemperatureTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
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
 * Configure NTC thermistor parameters in order to properly compute the temperature from
 * the measured resistance. For increased precision, you can enter a complete mapping
 * table using set_thermistorResponseTable. This function can only be used with a
 * temperature sensor based on thermistors.
 *
 * @param res25 : thermistor resistance at 25 degrees Celsius
 * @param beta : Beta value
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
    t0 = 25.0+275.15;
    t1 = 100.0+275.15;
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
 *         temperatures (in degrees Celcius) for which the resistance of the
 *         thermistor is specified.
 * @param resValues : array of floating point numbers, corresponding to the resistance
 *         values (in Ohms) for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
    // may throw an exception
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
 *         with all temperatures (in degrees Celcius) for which the resistance
 *         of the thermistor is specified.
 * @param resValues : array of floating point numbers, that is filled by the function
 *         with the value (in Ohms) for each of the temperature included in the
 *         first argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
    // may throw an exception
    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange( 11, (int)[(id) length] - 11)];
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
