/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Threshold functions
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


#import "yocto_threshold.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YThreshold
// Constructor is protected, use yFindThreshold factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Threshold";
//--- (YThreshold attributes initialization)
    _thresholdState = Y_THRESHOLDSTATE_INVALID;
    _targetSensor = Y_TARGETSENSOR_INVALID;
    _alertLevel = Y_ALERTLEVEL_INVALID;
    _safeLevel = Y_SAFELEVEL_INVALID;
    _valueCallbackThreshold = NULL;
//--- (end of YThreshold attributes initialization)
    return self;
}
//--- (YThreshold yapiwrapper)
//--- (end of YThreshold yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YThreshold cleanup)
    ARC_release(_targetSensor);
    _targetSensor = nil;
    ARC_dealloc(super);
//--- (end of YThreshold cleanup)
}
//--- (YThreshold private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "thresholdState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _thresholdState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "targetSensor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_targetSensor);
        _targetSensor =  [self _parseString:j];
        ARC_retain(_targetSensor);
        return 1;
    }
    if(!strcmp(j->token, "alertLevel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _alertLevel =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "safeLevel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _safeLevel =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YThreshold private methods implementation)
//--- (YThreshold public methods implementation)
/**
 * Returns current state of the threshold function.
 *
 * @return either YThreshold.THRESHOLDSTATE_SAFE or YThreshold.THRESHOLDSTATE_ALERT, according to
 * current state of the threshold function
 *
 * On failure, throws an exception or returns YThreshold.THRESHOLDSTATE_INVALID.
 */
-(Y_THRESHOLDSTATE_enum) get_thresholdState
{
    Y_THRESHOLDSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_THRESHOLDSTATE_INVALID;
        }
    }
    res = _thresholdState;
    return res;
}


-(Y_THRESHOLDSTATE_enum) thresholdState
{
    return [self get_thresholdState];
}
/**
 * Returns the name of the sensor monitored by the threshold function.
 *
 * @return a string corresponding to the name of the sensor monitored by the threshold function
 *
 * On failure, throws an exception or returns YThreshold.TARGETSENSOR_INVALID.
 */
-(NSString*) get_targetSensor
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TARGETSENSOR_INVALID;
        }
    }
    res = _targetSensor;
    return res;
}


-(NSString*) targetSensor
{
    return [self get_targetSensor];
}

/**
 * Changes the sensor alert level triggering the threshold function.
 * Remember to call the matching module saveToFlash()
 * method if you want to preserve the setting after reboot.
 *
 * @param newval : a floating point number corresponding to the sensor alert level triggering the
 * threshold function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_alertLevel:(double) newval
{
    return [self setAlertLevel:newval];
}
-(int) setAlertLevel:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"alertLevel" :rest_val];
}
/**
 * Returns the sensor alert level, triggering the threshold function.
 *
 * @return a floating point number corresponding to the sensor alert level, triggering the threshold function
 *
 * On failure, throws an exception or returns YThreshold.ALERTLEVEL_INVALID.
 */
-(double) get_alertLevel
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ALERTLEVEL_INVALID;
        }
    }
    res = _alertLevel;
    return res;
}


-(double) alertLevel
{
    return [self get_alertLevel];
}

/**
 * Changes the sensor acceptable level for disabling the threshold function.
 * Remember to call the matching module saveToFlash()
 * method if you want to preserve the setting after reboot.
 *
 * @param newval : a floating point number corresponding to the sensor acceptable level for disabling
 * the threshold function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_safeLevel:(double) newval
{
    return [self setSafeLevel:newval];
}
-(int) setSafeLevel:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"safeLevel" :rest_val];
}
/**
 * Returns the sensor acceptable level for disabling the threshold function.
 *
 * @return a floating point number corresponding to the sensor acceptable level for disabling the
 * threshold function
 *
 * On failure, throws an exception or returns YThreshold.SAFELEVEL_INVALID.
 */
-(double) get_safeLevel
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SAFELEVEL_INVALID;
        }
    }
    res = _safeLevel;
    return res;
}


-(double) safeLevel
{
    return [self get_safeLevel];
}
/**
 * Retrieves a threshold function for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the threshold function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YThreshold.isOnline() to test if the threshold function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a threshold function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the threshold function, for instance
 *         MyDevice.threshold1.
 *
 * @return a YThreshold object allowing you to drive the threshold function.
 */
+(YThreshold*) FindThreshold:(NSString*)func
{
    YThreshold* obj;
    obj = (YThreshold*) [YFunction _FindFromCache:@"Threshold" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YThreshold alloc] initWith:func]);
        [YFunction _AddToCache:@"Threshold" : func :obj];
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
-(int) registerValueCallback:(YThresholdValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackThreshold = callback;
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
    if (_valueCallbackThreshold != NULL) {
        _valueCallbackThreshold(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YThreshold*)   nextThreshold
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YThreshold FindThreshold:hwid];
}

+(YThreshold *) FirstThreshold
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Threshold":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YThreshold FindThreshold:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YThreshold public methods implementation)
@end

//--- (YThreshold functions)

YThreshold *yFindThreshold(NSString* func)
{
    return [YThreshold FindThreshold:func];
}

YThreshold *yFirstThreshold(void)
{
    return [YThreshold FirstThreshold];
}

//--- (end of YThreshold functions)

