/*********************************************************************
 *
 * $Id: yocto_lightsensor.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for LightSensor functions
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


#import "yocto_lightsensor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YLightSensor

// Constructor is protected, use yFindLightSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"LightSensor";
//--- (YLightSensor attributes initialization)
    _measureType = Y_MEASURETYPE_INVALID;
    _valueCallbackLightSensor = NULL;
    _timedReportCallbackLightSensor = NULL;
//--- (end of YLightSensor attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YLightSensor cleanup)
    ARC_dealloc(super);
//--- (end of YLightSensor cleanup)
}
//--- (YLightSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "measureType")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _measureType =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YLightSensor private methods implementation)
//--- (YLightSensor public methods implementation)

-(int) set_currentValue:(double) newval
{
    return [self setCurrentValue:newval];
}
-(int) setCurrentValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentValue" :rest_val];
}

/**
 * Changes the sensor-specific calibration parameter so that the current value
 * matches a desired target (linear scaling).
 *
 * @param calibratedVal : the desired target value.
 *
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) calibrate:(double)calibratedVal
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d",(int)floor(calibratedVal * 65536.0 + 0.5)];
    return [self _setAttr:@"currentValue" :rest_val];
}
/**
 * Returns the type of light measure.
 *
 * @return a value among Y_MEASURETYPE_HUMAN_EYE, Y_MEASURETYPE_WIDE_SPECTRUM, Y_MEASURETYPE_INFRARED,
 * Y_MEASURETYPE_HIGH_RATE and Y_MEASURETYPE_HIGH_ENERGY corresponding to the type of light measure
 *
 * On failure, throws an exception or returns Y_MEASURETYPE_INVALID.
 */
-(Y_MEASURETYPE_enum) get_measureType
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MEASURETYPE_INVALID;
        }
    }
    return _measureType;
}


-(Y_MEASURETYPE_enum) measureType
{
    return [self get_measureType];
}

/**
 * Modify the light sensor type used in the device. The measure can either
 * approximate the response of the human eye, focus on a specific light
 * spectrum, depending on the capabilities of the light-sensitive cell.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_MEASURETYPE_HUMAN_EYE, Y_MEASURETYPE_WIDE_SPECTRUM,
 * Y_MEASURETYPE_INFRARED, Y_MEASURETYPE_HIGH_RATE and Y_MEASURETYPE_HIGH_ENERGY
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_measureType:(Y_MEASURETYPE_enum) newval
{
    return [self setMeasureType:newval];
}
-(int) setMeasureType:(Y_MEASURETYPE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"measureType" :rest_val];
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
 * Use the method YLightSensor.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YLightSensor object allowing you to drive $THEFUNCTION$.
 */
+(YLightSensor*) FindLightSensor:(NSString*)func
{
    YLightSensor* obj;
    obj = (YLightSensor*) [YFunction _FindFromCache:@"LightSensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YLightSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"LightSensor" : func :obj];
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
-(int) registerValueCallback:(YLightSensorValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackLightSensor = callback;
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
    if (_valueCallbackLightSensor != NULL) {
        _valueCallbackLightSensor(self, value);
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
-(int) registerTimedReportCallback:(YLightSensorTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackLightSensor = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackLightSensor != NULL) {
        _timedReportCallbackLightSensor(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YLightSensor*)   nextLightSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YLightSensor FindLightSensor:hwid];
}

+(YLightSensor *) FirstLightSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"LightSensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YLightSensor FindLightSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YLightSensor public methods implementation)

@end
//--- (LightSensor functions)

YLightSensor *yFindLightSensor(NSString* func)
{
    return [YLightSensor FindLightSensor:func];
}

YLightSensor *yFirstLightSensor(void)
{
    return [YLightSensor FirstLightSensor];
}

//--- (end of LightSensor functions)
