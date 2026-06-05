/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for Orientation functions
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


#import "yocto_orientation.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YOrientation
// Constructor is protected, use yFindOrientation factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Orientation";
//--- (YOrientation attributes initialization)
    _counterClockwise = Y_COUNTERCLOCKWISE_INVALID;
    _command = Y_COMMAND_INVALID;
    _zeroOffset = Y_ZEROOFFSET_INVALID;
    _valueCallbackOrientation = NULL;
    _timedReportCallbackOrientation = NULL;
//--- (end of YOrientation attributes initialization)
    return self;
}
//--- (YOrientation yapiwrapper)
//--- (end of YOrientation yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YOrientation cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YOrientation cleanup)
}
//--- (YOrientation private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "counterClockwise")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _counterClockwise =  (Y_COUNTERCLOCKWISE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    if(!strcmp(j->token, "zeroOffset")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _zeroOffset =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YOrientation private methods implementation)
//--- (YOrientation public methods implementation)
/**
 * Returns a value indicating whether the sensor is operating in a counterclockwise direction.
 *
 * @return either YOrientation.COUNTERCLOCKWISE_FALSE or YOrientation.COUNTERCLOCKWISE_TRUE, according
 * to a value indicating whether the sensor is operating in a counterclockwise direction
 *
 * On failure, throws an exception or returns YOrientation.COUNTERCLOCKWISE_INVALID.
 */
-(Y_COUNTERCLOCKWISE_enum) get_counterClockwise
{
    Y_COUNTERCLOCKWISE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COUNTERCLOCKWISE_INVALID;
        }
    }
    res = _counterClockwise;
    return res;
}


-(Y_COUNTERCLOCKWISE_enum) counterClockwise
{
    return [self get_counterClockwise];
}

/**
 * Defines the operating direction of the sensor.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either YOrientation.COUNTERCLOCKWISE_FALSE or YOrientation.COUNTERCLOCKWISE_TRUE
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_counterClockwise:(Y_COUNTERCLOCKWISE_enum) newval
{
    return [self setCounterClockwise:newval];
}
-(int) setCounterClockwise:(Y_COUNTERCLOCKWISE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"counterClockwise" :rest_val];
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
 * Sets an offset between the orientation reported by the sensor and the actual orientation. This
 * can typically be used  to compensate for mechanical offset. This offset can also be set
 * automatically using the zero() method.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a floating point number
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_zeroOffset:(double) newval
{
    return [self setZeroOffset:newval];
}
-(int) setZeroOffset:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"zeroOffset" :rest_val];
}
/**
 * Returns the Offset between the orientation reported by the sensor and the actual orientation.
 *
 * @return a floating point number corresponding to the Offset between the orientation reported by the
 * sensor and the actual orientation
 *
 * On failure, throws an exception or returns YOrientation.ZEROOFFSET_INVALID.
 */
-(double) get_zeroOffset
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ZEROOFFSET_INVALID;
        }
    }
    res = _zeroOffset;
    return res;
}


-(double) zeroOffset
{
    return [self get_zeroOffset];
}
/**
 * Retrieves an orientation sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the orientation sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YOrientation.isOnline() to test if the orientation sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * an orientation sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the orientation sensor, for instance
 *         MyDevice.orientation.
 *
 * @return a YOrientation object allowing you to drive the orientation sensor.
 */
+(YOrientation*) FindOrientation:(NSString*)func
{
    YOrientation* obj;
    obj = (YOrientation*) [YFunction _FindFromCache:@"Orientation" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YOrientation alloc] initWith:func]);
        [YFunction _AddToCache:@"Orientation" :func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is then invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness,
 * remember to call one of these two functions periodically. The callback is called once juste after beeing
 * registered, passing the current advertised value  of the function, provided that it is not an empty string.
 * To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YOrientationValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackOrientation = callback;
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
    if (_valueCallbackOrientation != NULL) {
        _valueCallbackOrientation(self, value);
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
-(int) registerTimedReportCallback:(YOrientationTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackOrientation = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackOrientation != NULL) {
        _timedReportCallbackOrientation(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)command
{
    return [self set_command:command];
}

/**
 * Reset the sensor's zero to current position by automatically setting a new offset.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) zero
{
    return [self sendCommand:@"Z"];
}

/**
 * Modifies the calibration of the MA600A sensor using an array of 32
 * values representing the offset in degrees between the true values and
 * those measured regularly every 11.25 degrees starting from zero. The calibration
 * is applied immediately and is stored permanently in the MA600A sensor.
 * Before calculating the offset values, remember to clear any previous
 * calibration using the clearCalibration function and set
 * the zero offset  to 0. After a calibration change, the sensor will stop
 * measurements for about one second.
 * Do not confuse this function with the generic calibrateFromPoints function,
 * which works at the YSensor level and is not necessarily well suited to
 * a sensor returning circular values.
 *
 * @param offsetValues : array of 32 floating point values in the [-11.25..+11.25] range
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_calibration:(NSMutableArray*)offsetValues
{
    NSString* res;
    int npt;
    int idx;
    int corr;
    npt = (int)[offsetValues count];
    if (npt != 32) {
        [self _throw:YAPI_INVALID_ARGUMENT :@"Invalid calibration parameters (32 expected)"];
        return YAPI_INVALID_ARGUMENT;
    }
    res = @"C";
    idx = 0;
    while (idx < npt) {
        corr = (int) floor([[offsetValues objectAtIndex:idx] doubleValue] * 128 / 11.25+0.5);
        if ((corr < -128) || (corr > 127)) {
            [self _throw:YAPI_INVALID_ARGUMENT :@"Calibration parameter exceeds permitted range (+/-11.25)"];
            return YAPI_INVALID_ARGUMENT;
        }
        if (corr < 0) {
            corr = corr + 256;
        }
        res = [NSString stringWithFormat:@"%@%02x",res,corr];
        idx = idx + 1;
    }
    return [self sendCommand:res];
}

/**
 * Retrieves offset correction data points previously entered using the method
 * set_calibration.
 *
 * @param offsetValues : array of 32 floating point numbers, that will be filled by the
 *         function with the offset values for the correction points.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_Calibration:(NSMutableArray*)offsetValues
{
    return 0;
}

/**
 * Cancels any calibration set with set_calibration. This function
 * is equivalent to calling set_calibration with only zeros.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) clearCalibration
{
    return [self sendCommand:@"-"];
}


-(YOrientation*)   nextOrientation
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YOrientation FindOrientation:hwid];
}

+(YOrientation *) FirstOrientation
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Orientation":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YOrientation FindOrientation:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YOrientation public methods implementation)
@end

//--- (YOrientation functions)

YOrientation *yFindOrientation(NSString* func)
{
    return [YOrientation FindOrientation:func];
}

YOrientation *yFirstOrientation(void)
{
    return [YOrientation FirstOrientation];
}

//--- (end of YOrientation functions)

