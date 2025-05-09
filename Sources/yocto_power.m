/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Power functions
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


#import "yocto_power.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YPower
// Constructor is protected, use yFindPower factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Power";
//--- (YPower attributes initialization)
    _powerFactor = Y_POWERFACTOR_INVALID;
    _cosPhi = Y_COSPHI_INVALID;
    _meter = Y_METER_INVALID;
    _deliveredEnergyMeter = Y_DELIVEREDENERGYMETER_INVALID;
    _receivedEnergyMeter = Y_RECEIVEDENERGYMETER_INVALID;
    _meterTimer = Y_METERTIMER_INVALID;
    _valueCallbackPower = NULL;
    _timedReportCallbackPower = NULL;
//--- (end of YPower attributes initialization)
    return self;
}
//--- (YPower yapiwrapper)
//--- (end of YPower yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YPower cleanup)
    ARC_dealloc(super);
//--- (end of YPower cleanup)
}
//--- (YPower private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "powerFactor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _powerFactor =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "cosPhi")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _cosPhi =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "meter")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _meter =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "deliveredEnergyMeter")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _deliveredEnergyMeter =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "receivedEnergyMeter")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _receivedEnergyMeter =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "meterTimer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _meterTimer =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YPower private methods implementation)
//--- (YPower public methods implementation)
/**
 * Returns the power factor (PF), i.e. ratio between the active power consumed (in W)
 * and the apparent power provided (VA).
 *
 * @return a floating point number corresponding to the power factor (PF), i.e
 *
 * On failure, throws an exception or returns YPower.POWERFACTOR_INVALID.
 */
-(double) get_powerFactor
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POWERFACTOR_INVALID;
        }
    }
    res = _powerFactor;
    if (res == Y_POWERFACTOR_INVALID) {
        res = _cosPhi;
    }
    res = floor(res * 1000+0.5) / 1000;
    return res;
}


-(double) powerFactor
{
    return [self get_powerFactor];
}
/**
 * Returns the Displacement Power factor (DPF), i.e. cosine of the phase shift between
 * the voltage and current fundamentals.
 * On the Yocto-Watt (V1), the value returned by this method correponds to the
 * power factor as this device is cannot estimate the true DPF.
 *
 * @return a floating point number corresponding to the Displacement Power factor (DPF), i.e
 *
 * On failure, throws an exception or returns YPower.COSPHI_INVALID.
 */
-(double) get_cosPhi
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COSPHI_INVALID;
        }
    }
    res = _cosPhi;
    return res;
}


-(double) cosPhi
{
    return [self get_cosPhi];
}

-(int) set_meter:(double) newval
{
    return [self setMeter:newval];
}
-(int) setMeter:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"meter" :rest_val];
}
/**
 * Returns the energy counter, maintained by the wattmeter by integrating the
 * power consumption over time. This is the sum of forward and backwad energy transfers,
 * if you are insterested in only one direction, use  get_receivedEnergyMeter() or
 * get_deliveredEnergyMeter(). Note that this counter is reset at each start of the device.
 *
 * @return a floating point number corresponding to the energy counter, maintained by the wattmeter by
 * integrating the
 *         power consumption over time
 *
 * On failure, throws an exception or returns YPower.METER_INVALID.
 */
-(double) get_meter
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_METER_INVALID;
        }
    }
    res = _meter;
    return res;
}


-(double) meter
{
    return [self get_meter];
}
/**
 * Returns the energy counter, maintained by the wattmeter by integrating the power consumption over time,
 * but only when positive. Note that this counter is reset at each start of the device.
 *
 * @return a floating point number corresponding to the energy counter, maintained by the wattmeter by
 * integrating the power consumption over time,
 *         but only when positive
 *
 * On failure, throws an exception or returns YPower.DELIVEREDENERGYMETER_INVALID.
 */
-(double) get_deliveredEnergyMeter
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DELIVEREDENERGYMETER_INVALID;
        }
    }
    res = _deliveredEnergyMeter;
    return res;
}


-(double) deliveredEnergyMeter
{
    return [self get_deliveredEnergyMeter];
}
/**
 * Returns the energy counter, maintained by the wattmeter by integrating the power consumption over time,
 * but only when negative. Note that this counter is reset at each start of the device.
 *
 * @return a floating point number corresponding to the energy counter, maintained by the wattmeter by
 * integrating the power consumption over time,
 *         but only when negative
 *
 * On failure, throws an exception or returns YPower.RECEIVEDENERGYMETER_INVALID.
 */
-(double) get_receivedEnergyMeter
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RECEIVEDENERGYMETER_INVALID;
        }
    }
    res = _receivedEnergyMeter;
    return res;
}


-(double) receivedEnergyMeter
{
    return [self get_receivedEnergyMeter];
}
/**
 * Returns the elapsed time since last energy counter reset, in seconds.
 *
 * @return an integer corresponding to the elapsed time since last energy counter reset, in seconds
 *
 * On failure, throws an exception or returns YPower.METERTIMER_INVALID.
 */
-(int) get_meterTimer
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_METERTIMER_INVALID;
        }
    }
    res = _meterTimer;
    return res;
}


-(int) meterTimer
{
    return [self get_meterTimer];
}
/**
 * Retrieves a electrical power sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the electrical power sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YPower.isOnline() to test if the electrical power sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a electrical power sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the electrical power sensor, for instance
 *         YWATTMK1.power.
 *
 * @return a YPower object allowing you to drive the electrical power sensor.
 */
+(YPower*) FindPower:(NSString*)func
{
    YPower* obj;
    obj = (YPower*) [YFunction _FindFromCache:@"Power" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YPower alloc] initWith:func]);
        [YFunction _AddToCache:@"Power" :func :obj];
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
-(int) registerValueCallback:(YPowerValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackPower = callback;
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
    if (_valueCallbackPower != NULL) {
        _valueCallbackPower(self, value);
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
-(int) registerTimedReportCallback:(YPowerTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackPower = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackPower != NULL) {
        _timedReportCallbackPower(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

/**
 * Resets the energy counters.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    return [self set_meter:0];
}


-(YPower*)   nextPower
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YPower FindPower:hwid];
}

+(YPower *) FirstPower
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Power":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YPower FindPower:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YPower public methods implementation)
@end

//--- (YPower functions)

YPower *yFindPower(NSString* func)
{
    return [YPower FindPower:func];
}

YPower *yFirstPower(void)
{
    return [YPower FirstPower];
}

//--- (end of YPower functions)

