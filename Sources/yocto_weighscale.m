/*********************************************************************
 *
 * $Id: yocto_weighscale.m 28231 2017-07-31 16:37:33Z mvuilleu $
 *
 * Implements the high-level API for WeighScale functions
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


#import "yocto_weighscale.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YWeighScale

// Constructor is protected, use yFindWeighScale factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"WeighScale";
//--- (YWeighScale attributes initialization)
    _excitation = Y_EXCITATION_INVALID;
    _adaptRatio = Y_ADAPTRATIO_INVALID;
    _compTemperature = Y_COMPTEMPERATURE_INVALID;
    _compensation = Y_COMPENSATION_INVALID;
    _zeroTracking = Y_ZEROTRACKING_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackWeighScale = NULL;
    _timedReportCallbackWeighScale = NULL;
//--- (end of YWeighScale attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YWeighScale cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YWeighScale cleanup)
}
//--- (YWeighScale private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "excitation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _excitation =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "adaptRatio")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _adaptRatio =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "compTemperature")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _compTemperature =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "compensation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _compensation =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "zeroTracking")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _zeroTracking =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
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
//--- (end of YWeighScale private methods implementation)
//--- (YWeighScale public methods implementation)
/**
 * Returns the current load cell bridge excitation method.
 *
 * @return a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding to the
 * current load cell bridge excitation method
 *
 * On failure, throws an exception or returns Y_EXCITATION_INVALID.
 */
-(Y_EXCITATION_enum) get_excitation
{
    Y_EXCITATION_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_EXCITATION_INVALID;
        }
    }
    res = _excitation;
    return res;
}


-(Y_EXCITATION_enum) excitation
{
    return [self get_excitation];
}

/**
 * Changes the current load cell bridge excitation method.
 *
 * @param newval : a value among Y_EXCITATION_OFF, Y_EXCITATION_DC and Y_EXCITATION_AC corresponding
 * to the current load cell bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_excitation:(Y_EXCITATION_enum) newval
{
    return [self setExcitation:newval];
}
-(int) setExcitation:(Y_EXCITATION_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"excitation" :rest_val];
}

/**
 * Changes the compensation temperature update rate, in percents.
 *
 * @param newval : a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_adaptRatio:(double) newval
{
    return [self setAdaptRatio:newval];
}
-(int) setAdaptRatio:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"adaptRatio" :rest_val];
}
/**
 * Returns the compensation temperature update rate, in percents.
 * the maximal value is 65 percents.
 *
 * @return a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * On failure, throws an exception or returns Y_ADAPTRATIO_INVALID.
 */
-(double) get_adaptRatio
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADAPTRATIO_INVALID;
        }
    }
    res = _adaptRatio;
    return res;
}


-(double) adaptRatio
{
    return [self get_adaptRatio];
}
/**
 * Returns the current compensation temperature.
 *
 * @return a floating point number corresponding to the current compensation temperature
 *
 * On failure, throws an exception or returns Y_COMPTEMPERATURE_INVALID.
 */
-(double) get_compTemperature
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMPTEMPERATURE_INVALID;
        }
    }
    res = _compTemperature;
    return res;
}


-(double) compTemperature
{
    return [self get_compTemperature];
}
/**
 * Returns the current current thermal compensation value.
 *
 * @return a floating point number corresponding to the current current thermal compensation value
 *
 * On failure, throws an exception or returns Y_COMPENSATION_INVALID.
 */
-(double) get_compensation
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMPENSATION_INVALID;
        }
    }
    res = _compensation;
    return res;
}


-(double) compensation
{
    return [self get_compensation];
}

/**
 * Changes the compensation temperature update rate, in percents.
 *
 * @param newval : a floating point number corresponding to the compensation temperature update rate, in percents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_zeroTracking:(double) newval
{
    return [self setZeroTracking:newval];
}
-(int) setZeroTracking:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"zeroTracking" :rest_val];
}
/**
 * Returns the zero tracking threshold value. When this threshold is larger than
 * zero, any measure under the threshold will automatically be ignored and the
 * zero compensation will be updated.
 *
 * @return a floating point number corresponding to the zero tracking threshold value
 *
 * On failure, throws an exception or returns Y_ZEROTRACKING_INVALID.
 */
-(double) get_zeroTracking
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ZEROTRACKING_INVALID;
        }
    }
    res = _zeroTracking;
    return res;
}


-(double) zeroTracking
{
    return [self get_zeroTracking];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
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
 * Retrieves a weighing scale sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the weighing scale sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWeighScale.isOnline() to test if the weighing scale sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a weighing scale sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the weighing scale sensor
 *
 * @return a YWeighScale object allowing you to drive the weighing scale sensor.
 */
+(YWeighScale*) FindWeighScale:(NSString*)func
{
    YWeighScale* obj;
    obj = (YWeighScale*) [YFunction _FindFromCache:@"WeighScale" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YWeighScale alloc] initWith:func]);
        [YFunction _AddToCache:@"WeighScale" : func :obj];
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
-(int) registerValueCallback:(YWeighScaleValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackWeighScale = callback;
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
    if (_valueCallbackWeighScale != NULL) {
        _valueCallbackWeighScale(self, value);
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
-(int) registerTimedReportCallback:(YWeighScaleTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackWeighScale = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackWeighScale != NULL) {
        _timedReportCallbackWeighScale(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Adapts the load cell signal bias (stored in the corresponding genericSensor)
 * so that the current signal corresponds to a zero weight.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) tare
{
    return [self set_command:@"T"];
}

/**
 * Configures the load cell span parameters (stored in the corresponding genericSensor)
 * so that the current signal corresponds to the specified reference weight.
 *
 * @param currWeight : reference weight presently on the load cell.
 * @param maxWeight : maximum weight to be expectect on the load cell.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) setupSpan:(double)currWeight :(double)maxWeight
{
    return [self set_command:[NSString stringWithFormat:@"S%d:%d", (int) floor(1000*currWeight+0.5),(int) floor(1000*maxWeight+0.5)]];
}

/**
 * Records a weight offset thermal compensation table, in order to automatically correct the
 * measured weight based on the compensation temperature.
 * The weight correction will be applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, corresponding to all
 *         temperatures for which an offset correction is specified.
 * @param compValues : array of floating point numbers, corresponding to the offset correction
 *         to apply for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_offsetCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues
{
    int siz;
    int res;
    int idx;
    int found;
    double prev;
    double curr;
    double currComp;
    double idxTemp;
    siz = (int)[tempValues count];
    if (!(siz != 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"thermal compensation table must have at least two points"]; return YAPI_INVALID_ARGUMENT;}
    if (!(siz == (int)[compValues count])) {[self _throw: YAPI_INVALID_ARGUMENT: @"table sizes mismatch"]; return YAPI_INVALID_ARGUMENT;}

    res = [self set_command:@"2Z"];
    if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to reset thermal compensation table"]; return YAPI_IO_ERROR;}
    // add records in growing temperature value
    found = 1;
    prev = -999999.0;
    while (found > 0) {
        found = 0;
        curr = 99999999.0;
        currComp = -999999.0;
        idx = 0;
        while (idx < siz) {
            idxTemp = [[tempValues objectAtIndex:idx] doubleValue];
            if ((idxTemp > prev) && (idxTemp < curr)) {
                curr = idxTemp;
                currComp = [[compValues objectAtIndex:idx] doubleValue];
                found = 1;
            }
            idx = idx + 1;
        }
        if (found > 0) {
            res = [self set_command:[NSString stringWithFormat:@"2m%d:%d", (int) floor(1000*curr+0.5),(int) floor(1000*currComp+0.5)]];
            if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to set thermal compensation table"]; return YAPI_IO_ERROR;}
            prev = curr;
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Retrieves the weight offset thermal compensation table previously configured using the
 * set_offsetCompensationTable function.
 * The weight correction is applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, that is filled by the function
 *         with all temperatures for which an offset correction is specified.
 * @param compValues : array of floating point numbers, that is filled by the function
 *         with the offset correction applied for each of the temperature
 *         included in the first argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadOffsetCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues
{
    NSString* id;
    NSMutableData* bin_json;
    NSMutableArray* paramlist = [NSMutableArray array];
    int siz;
    int idx;
    double temp;
    double comp;

    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange( 11, (int)[(id) length] - 11)];
    bin_json = [self _download:@"extra.json?page=2"];
    paramlist = [self _json_get_array:bin_json];
    // convert all values to float and append records
    siz = (((int)[paramlist count]) >> (1));
    [tempValues removeAllObjects];
    [compValues removeAllObjects];
    idx = 0;
    while (idx < siz) {
        temp = [[paramlist objectAtIndex:2*idx] doubleValue]/1000.0;
        comp = [[paramlist objectAtIndex:2*idx+1] doubleValue]/1000.0;
        [tempValues addObject:[NSNumber numberWithDouble:temp]];
        [compValues addObject:[NSNumber numberWithDouble:comp]];
        idx = idx + 1;
    }
    return YAPI_SUCCESS;
}

/**
 * Records a weight span thermal compensation table, in order to automatically correct the
 * measured weight based on the compensation temperature.
 * The weight correction will be applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, corresponding to all
 *         temperatures for which a span correction is specified.
 * @param compValues : array of floating point numbers, corresponding to the span correction
 *         (in percents) to apply for each of the temperature included in the first
 *         argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_spanCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues
{
    int siz;
    int res;
    int idx;
    int found;
    double prev;
    double curr;
    double currComp;
    double idxTemp;
    siz = (int)[tempValues count];
    if (!(siz != 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"thermal compensation table must have at least two points"]; return YAPI_INVALID_ARGUMENT;}
    if (!(siz == (int)[compValues count])) {[self _throw: YAPI_INVALID_ARGUMENT: @"table sizes mismatch"]; return YAPI_INVALID_ARGUMENT;}

    res = [self set_command:@"3Z"];
    if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to reset thermal compensation table"]; return YAPI_IO_ERROR;}
    // add records in growing temperature value
    found = 1;
    prev = -999999.0;
    while (found > 0) {
        found = 0;
        curr = 99999999.0;
        currComp = -999999.0;
        idx = 0;
        while (idx < siz) {
            idxTemp = [[tempValues objectAtIndex:idx] doubleValue];
            if ((idxTemp > prev) && (idxTemp < curr)) {
                curr = idxTemp;
                currComp = [[compValues objectAtIndex:idx] doubleValue];
                found = 1;
            }
            idx = idx + 1;
        }
        if (found > 0) {
            res = [self set_command:[NSString stringWithFormat:@"3m%d:%d", (int) floor(1000*curr+0.5),(int) floor(1000*currComp+0.5)]];
            if (!(res==YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to set thermal compensation table"]; return YAPI_IO_ERROR;}
            prev = curr;
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Retrieves the weight span thermal compensation table previously configured using the
 * set_spanCompensationTable function.
 * The weight correction is applied by linear interpolation between specified points.
 *
 * @param tempValues : array of floating point numbers, that is filled by the function
 *         with all temperatures for which an span correction is specified.
 * @param compValues : array of floating point numbers, that is filled by the function
 *         with the span correction applied for each of the temperature
 *         included in the first argument, index by index.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadSpanCompensationTable:(NSMutableArray*)tempValues :(NSMutableArray*)compValues
{
    NSString* id;
    NSMutableData* bin_json;
    NSMutableArray* paramlist = [NSMutableArray array];
    int siz;
    int idx;
    double temp;
    double comp;

    id = [self get_functionId];
    id = [id substringWithRange:NSMakeRange( 11, (int)[(id) length] - 11)];
    bin_json = [self _download:@"extra.json?page=3"];
    paramlist = [self _json_get_array:bin_json];
    // convert all values to float and append records
    siz = (((int)[paramlist count]) >> (1));
    [tempValues removeAllObjects];
    [compValues removeAllObjects];
    idx = 0;
    while (idx < siz) {
        temp = [[paramlist objectAtIndex:2*idx] doubleValue]/1000.0;
        comp = [[paramlist objectAtIndex:2*idx+1] doubleValue]/1000.0;
        [tempValues addObject:[NSNumber numberWithDouble:temp]];
        [compValues addObject:[NSNumber numberWithDouble:comp]];
        idx = idx + 1;
    }
    return YAPI_SUCCESS;
}


-(YWeighScale*)   nextWeighScale
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YWeighScale FindWeighScale:hwid];
}

+(YWeighScale *) FirstWeighScale
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"WeighScale":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YWeighScale FindWeighScale:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YWeighScale public methods implementation)

@end
//--- (WeighScale functions)

YWeighScale *yFindWeighScale(NSString* func)
{
    return [YWeighScale FindWeighScale:func];
}

YWeighScale *yFirstWeighScale(void)
{
    return [YWeighScale FirstWeighScale];
}

//--- (end of WeighScale functions)
