/*********************************************************************
 *
 *  $Id: yocto_quadraturedecoder.m 43580 2021-01-26 17:46:01Z mvuilleu $
 *
 *  Implements the high-level API for QuadratureDecoder functions
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


#import "yocto_quadraturedecoder.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YQuadratureDecoder

// Constructor is protected, use yFindQuadratureDecoder factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"QuadratureDecoder";
//--- (YQuadratureDecoder attributes initialization)
    _speed = Y_SPEED_INVALID;
    _decoding = Y_DECODING_INVALID;
    _valueCallbackQuadratureDecoder = NULL;
    _timedReportCallbackQuadratureDecoder = NULL;
//--- (end of YQuadratureDecoder attributes initialization)
    return self;
}
//--- (YQuadratureDecoder yapiwrapper)
//--- (end of YQuadratureDecoder yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YQuadratureDecoder cleanup)
    ARC_dealloc(super);
//--- (end of YQuadratureDecoder cleanup)
}
//--- (YQuadratureDecoder private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "speed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _speed =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "decoding")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _decoding =  (Y_DECODING_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YQuadratureDecoder private methods implementation)
//--- (YQuadratureDecoder public methods implementation)

/**
 * Changes the current expected position of the quadrature decoder.
 * Invoking this function implicitly activates the quadrature decoder.
 *
 * @param newval : a floating point number corresponding to the current expected position of the quadrature decoder
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentValue:(double) newval
{
    return [self setCurrentValue:newval];
}
-(int) setCurrentValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"currentValue" :rest_val];
}
/**
 * Returns the increments frequency, in Hz.
 *
 * @return a floating point number corresponding to the increments frequency, in Hz
 *
 * On failure, throws an exception or returns YQuadratureDecoder.SPEED_INVALID.
 */
-(double) get_speed
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SPEED_INVALID;
        }
    }
    res = _speed;
    return res;
}


-(double) speed
{
    return [self get_speed];
}
/**
 * Returns the current activation state of the quadrature decoder.
 *
 * @return either YQuadratureDecoder.DECODING_OFF or YQuadratureDecoder.DECODING_ON, according to the
 * current activation state of the quadrature decoder
 *
 * On failure, throws an exception or returns YQuadratureDecoder.DECODING_INVALID.
 */
-(Y_DECODING_enum) get_decoding
{
    Y_DECODING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DECODING_INVALID;
        }
    }
    res = _decoding;
    return res;
}


-(Y_DECODING_enum) decoding
{
    return [self get_decoding];
}

/**
 * Changes the activation state of the quadrature decoder.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YQuadratureDecoder.DECODING_OFF or YQuadratureDecoder.DECODING_ON, according
 * to the activation state of the quadrature decoder
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_decoding:(Y_DECODING_enum) newval
{
    return [self setDecoding:newval];
}
-(int) setDecoding:(Y_DECODING_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"decoding" :rest_val];
}
/**
 * Retrieves a quadrature decoder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quadrature decoder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQuadratureDecoder.isOnline() to test if the quadrature decoder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quadrature decoder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the quadrature decoder, for instance
 *         YPWMRX01.quadratureDecoder.
 *
 * @return a YQuadratureDecoder object allowing you to drive the quadrature decoder.
 */
+(YQuadratureDecoder*) FindQuadratureDecoder:(NSString*)func
{
    YQuadratureDecoder* obj;
    obj = (YQuadratureDecoder*) [YFunction _FindFromCache:@"QuadratureDecoder" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YQuadratureDecoder alloc] initWith:func]);
        [YFunction _AddToCache:@"QuadratureDecoder" : func :obj];
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
-(int) registerValueCallback:(YQuadratureDecoderValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackQuadratureDecoder = callback;
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
    if (_valueCallbackQuadratureDecoder != NULL) {
        _valueCallbackQuadratureDecoder(self, value);
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
-(int) registerTimedReportCallback:(YQuadratureDecoderTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackQuadratureDecoder = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackQuadratureDecoder != NULL) {
        _timedReportCallbackQuadratureDecoder(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YQuadratureDecoder*)   nextQuadratureDecoder
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YQuadratureDecoder FindQuadratureDecoder:hwid];
}

+(YQuadratureDecoder *) FirstQuadratureDecoder
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"QuadratureDecoder":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YQuadratureDecoder FindQuadratureDecoder:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YQuadratureDecoder public methods implementation)

@end
//--- (YQuadratureDecoder functions)

YQuadratureDecoder *yFindQuadratureDecoder(NSString* func)
{
    return [YQuadratureDecoder FindQuadratureDecoder:func];
}

YQuadratureDecoder *yFirstQuadratureDecoder(void)
{
    return [YQuadratureDecoder FirstQuadratureDecoder];
}

//--- (end of YQuadratureDecoder functions)
