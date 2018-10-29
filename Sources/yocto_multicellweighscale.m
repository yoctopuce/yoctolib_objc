/*********************************************************************
 *
 *  $Id: yocto_multicellweighscale.m 32610 2018-10-10 06:52:20Z seb $
 *
 *  Implements the high-level API for MultiCellWeighScale functions
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


#import "yocto_multicellweighscale.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YMultiCellWeighScale

// Constructor is protected, use yFindMultiCellWeighScale factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"MultiCellWeighScale";
//--- (YMultiCellWeighScale attributes initialization)
    _cellCount = Y_CELLCOUNT_INVALID;
    _excitation = Y_EXCITATION_INVALID;
    _tempAvgAdaptRatio = Y_TEMPAVGADAPTRATIO_INVALID;
    _tempChgAdaptRatio = Y_TEMPCHGADAPTRATIO_INVALID;
    _compTempAvg = Y_COMPTEMPAVG_INVALID;
    _compTempChg = Y_COMPTEMPCHG_INVALID;
    _compensation = Y_COMPENSATION_INVALID;
    _zeroTracking = Y_ZEROTRACKING_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackMultiCellWeighScale = NULL;
    _timedReportCallbackMultiCellWeighScale = NULL;
//--- (end of YMultiCellWeighScale attributes initialization)
    return self;
}
//--- (YMultiCellWeighScale yapiwrapper)
//--- (end of YMultiCellWeighScale yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YMultiCellWeighScale cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YMultiCellWeighScale cleanup)
}
//--- (YMultiCellWeighScale private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "cellCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _cellCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "excitation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _excitation =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "tempAvgAdaptRatio")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _tempAvgAdaptRatio =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "tempChgAdaptRatio")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _tempChgAdaptRatio =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "compTempAvg")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _compTempAvg =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "compTempChg")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _compTempChg =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
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
//--- (end of YMultiCellWeighScale private methods implementation)
//--- (YMultiCellWeighScale public methods implementation)

/**
 * Changes the measuring unit for the weight.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the weight
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
 * Returns the number of load cells in use.
 *
 * @return an integer corresponding to the number of load cells in use
 *
 * On failure, throws an exception or returns Y_CELLCOUNT_INVALID.
 */
-(int) get_cellCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CELLCOUNT_INVALID;
        }
    }
    res = _cellCount;
    return res;
}


-(int) cellCount
{
    return [self get_cellCount];
}

/**
 * Changes the number of load cells in use.
 *
 * @param newval : an integer corresponding to the number of load cells in use
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_cellCount:(int) newval
{
    return [self setCellCount:newval];
}
-(int) setCellCount:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"cellCount" :rest_val];
}
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
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
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
 * Changes the averaged temperature update rate, in per mille.
 * The purpose of this adaptation ratio is to model the thermal inertia of the load cell.
 * The averaged temperature is updated every 10 seconds, by applying this adaptation rate
 * to the difference between the measures ambiant temperature and the current compensation
 * temperature. The standard rate is 0.2 per mille, and the maximal rate is 65 per mille.
 *
 * @param newval : a floating point number corresponding to the averaged temperature update rate, in per mille
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_tempAvgAdaptRatio:(double) newval
{
    return [self setTempAvgAdaptRatio:newval];
}
-(int) setTempAvgAdaptRatio:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"tempAvgAdaptRatio" :rest_val];
}
/**
 * Returns the averaged temperature update rate, in per mille.
 * The purpose of this adaptation ratio is to model the thermal inertia of the load cell.
 * The averaged temperature is updated every 10 seconds, by applying this adaptation rate
 * to the difference between the measures ambiant temperature and the current compensation
 * temperature. The standard rate is 0.2 per mille, and the maximal rate is 65 per mille.
 *
 * @return a floating point number corresponding to the averaged temperature update rate, in per mille
 *
 * On failure, throws an exception or returns Y_TEMPAVGADAPTRATIO_INVALID.
 */
-(double) get_tempAvgAdaptRatio
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TEMPAVGADAPTRATIO_INVALID;
        }
    }
    res = _tempAvgAdaptRatio;
    return res;
}


-(double) tempAvgAdaptRatio
{
    return [self get_tempAvgAdaptRatio];
}

/**
 * Changes the temperature change update rate, in per mille.
 * The temperature change is updated every 10 seconds, by applying this adaptation rate
 * to the difference between the measures ambiant temperature and the current temperature used for
 * change compensation. The standard rate is 0.6 per mille, and the maximal rate is 65 pour mille.
 *
 * @param newval : a floating point number corresponding to the temperature change update rate, in per mille
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_tempChgAdaptRatio:(double) newval
{
    return [self setTempChgAdaptRatio:newval];
}
-(int) setTempChgAdaptRatio:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"tempChgAdaptRatio" :rest_val];
}
/**
 * Returns the temperature change update rate, in per mille.
 * The temperature change is updated every 10 seconds, by applying this adaptation rate
 * to the difference between the measures ambiant temperature and the current temperature used for
 * change compensation. The standard rate is 0.6 per mille, and the maximal rate is 65 pour mille.
 *
 * @return a floating point number corresponding to the temperature change update rate, in per mille
 *
 * On failure, throws an exception or returns Y_TEMPCHGADAPTRATIO_INVALID.
 */
-(double) get_tempChgAdaptRatio
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TEMPCHGADAPTRATIO_INVALID;
        }
    }
    res = _tempChgAdaptRatio;
    return res;
}


-(double) tempChgAdaptRatio
{
    return [self get_tempChgAdaptRatio];
}
/**
 * Returns the current averaged temperature, used for thermal compensation.
 *
 * @return a floating point number corresponding to the current averaged temperature, used for thermal compensation
 *
 * On failure, throws an exception or returns Y_COMPTEMPAVG_INVALID.
 */
-(double) get_compTempAvg
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMPTEMPAVG_INVALID;
        }
    }
    res = _compTempAvg;
    return res;
}


-(double) compTempAvg
{
    return [self get_compTempAvg];
}
/**
 * Returns the current temperature variation, used for thermal compensation.
 *
 * @return a floating point number corresponding to the current temperature variation, used for
 * thermal compensation
 *
 * On failure, throws an exception or returns Y_COMPTEMPCHG_INVALID.
 */
-(double) get_compTempChg
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMPTEMPCHG_INVALID;
        }
    }
    res = _compTempChg;
    return res;
}


-(double) compTempChg
{
    return [self get_compTempChg];
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
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
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
 * Changes the zero tracking threshold value. When this threshold is larger than
 * zero, any measure under the threshold will automatically be ignored and the
 * zero compensation will be updated.
 *
 * @param newval : a floating point number corresponding to the zero tracking threshold value
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
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
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
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
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
 * Retrieves a multi-cell weighing scale sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-cell weighing scale sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiCellWeighScale.isOnline() to test if the multi-cell weighing scale sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-cell weighing scale sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-cell weighing scale sensor
 *
 * @return a YMultiCellWeighScale object allowing you to drive the multi-cell weighing scale sensor.
 */
+(YMultiCellWeighScale*) FindMultiCellWeighScale:(NSString*)func
{
    YMultiCellWeighScale* obj;
    obj = (YMultiCellWeighScale*) [YFunction _FindFromCache:@"MultiCellWeighScale" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YMultiCellWeighScale alloc] initWith:func]);
        [YFunction _AddToCache:@"MultiCellWeighScale" : func :obj];
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
-(int) registerValueCallback:(YMultiCellWeighScaleValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackMultiCellWeighScale = callback;
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
    if (_valueCallbackMultiCellWeighScale != NULL) {
        _valueCallbackMultiCellWeighScale(self, value);
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
-(int) registerTimedReportCallback:(YMultiCellWeighScaleTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackMultiCellWeighScale = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackMultiCellWeighScale != NULL) {
        _timedReportCallbackMultiCellWeighScale(self, value);
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
 * Configures the load cells span parameters (stored in the corresponding genericSensors)
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


-(YMultiCellWeighScale*)   nextMultiCellWeighScale
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YMultiCellWeighScale FindMultiCellWeighScale:hwid];
}

+(YMultiCellWeighScale *) FirstMultiCellWeighScale
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"MultiCellWeighScale":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YMultiCellWeighScale FindMultiCellWeighScale:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YMultiCellWeighScale public methods implementation)

@end
//--- (YMultiCellWeighScale functions)

YMultiCellWeighScale *yFindMultiCellWeighScale(NSString* func)
{
    return [YMultiCellWeighScale FindMultiCellWeighScale:func];
}

YMultiCellWeighScale *yFirstMultiCellWeighScale(void)
{
    return [YMultiCellWeighScale FirstMultiCellWeighScale];
}

//--- (end of YMultiCellWeighScale functions)
