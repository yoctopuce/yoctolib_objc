/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Compass functions
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


#import "yocto_compass.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YCompass
// Constructor is protected, use yFindCompass factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Compass";
//--- (YCompass attributes initialization)
    _bandwidth = Y_BANDWIDTH_INVALID;
    _axis = Y_AXIS_INVALID;
    _magneticHeading = Y_MAGNETICHEADING_INVALID;
    _valueCallbackCompass = NULL;
    _timedReportCallbackCompass = NULL;
//--- (end of YCompass attributes initialization)
    return self;
}
//--- (YCompass yapiwrapper)
//--- (end of YCompass yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YCompass cleanup)
    ARC_dealloc(super);
//--- (end of YCompass cleanup)
}
//--- (YCompass private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "bandwidth")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _bandwidth =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "axis")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _axis =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "magneticHeading")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _magneticHeading =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YCompass private methods implementation)
//--- (YCompass public methods implementation)
/**
 * Returns the measure update frequency, measured in Hz.
 *
 * @return an integer corresponding to the measure update frequency, measured in Hz
 *
 * On failure, throws an exception or returns YCompass.BANDWIDTH_INVALID.
 */
-(int) get_bandwidth
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BANDWIDTH_INVALID;
        }
    }
    res = _bandwidth;
    return res;
}


-(int) bandwidth
{
    return [self get_bandwidth];
}

/**
 * Changes the measure update frequency, measured in Hz. When the
 * frequency is lower, the device performs averaging.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the measure update frequency, measured in Hz
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bandwidth:(int) newval
{
    return [self setBandwidth:newval];
}
-(int) setBandwidth:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"bandwidth" :rest_val];
}
-(Y_AXIS_enum) get_axis
{
    Y_AXIS_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_AXIS_INVALID;
        }
    }
    res = _axis;
    return res;
}


-(Y_AXIS_enum) axis
{
    return [self get_axis];
}
/**
 * Returns the magnetic heading, regardless of the configured bearing.
 *
 * @return a floating point number corresponding to the magnetic heading, regardless of the configured bearing
 *
 * On failure, throws an exception or returns YCompass.MAGNETICHEADING_INVALID.
 */
-(double) get_magneticHeading
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAGNETICHEADING_INVALID;
        }
    }
    res = _magneticHeading;
    return res;
}


-(double) magneticHeading
{
    return [self get_magneticHeading];
}
/**
 * Retrieves a compass function for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the compass function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCompass.isOnline() to test if the compass function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a compass function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the compass function, for instance
 *         Y3DMK002.compass.
 *
 * @return a YCompass object allowing you to drive the compass function.
 */
+(YCompass*) FindCompass:(NSString*)func
{
    YCompass* obj;
    obj = (YCompass*) [YFunction _FindFromCache:@"Compass" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YCompass alloc] initWith:func]);
        [YFunction _AddToCache:@"Compass" :func :obj];
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
-(int) registerValueCallback:(YCompassValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackCompass = callback;
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
    if (_valueCallbackCompass != NULL) {
        _valueCallbackCompass(self, value);
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
-(int) registerTimedReportCallback:(YCompassTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackCompass = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackCompass != NULL) {
        _timedReportCallbackCompass(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YCompass*)   nextCompass
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YCompass FindCompass:hwid];
}

+(YCompass *) FirstCompass
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Compass":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YCompass FindCompass:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YCompass public methods implementation)
@end

//--- (YCompass functions)

YCompass *yFindCompass(NSString* func)
{
    return [YCompass FindCompass:func];
}

YCompass *yFirstCompass(void)
{
    return [YCompass FirstCompass];
}

//--- (end of YCompass functions)

