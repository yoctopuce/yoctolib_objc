/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for SpectralSensor functions
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


#import "yocto_spectralsensor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YSpectralSensor
// Constructor is protected, use yFindSpectralSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SpectralSensor";
//--- (YSpectralSensor attributes initialization)
    _ledCurrent = Y_LEDCURRENT_INVALID;
    _resolution = Y_RESOLUTION_INVALID;
    _integrationTime = Y_INTEGRATIONTIME_INVALID;
    _gain = Y_GAIN_INVALID;
    _saturation = Y_SATURATION_INVALID;
    _estimatedRGB = Y_ESTIMATEDRGB_INVALID;
    _estimatedHSL = Y_ESTIMATEDHSL_INVALID;
    _estimatedXYZ = Y_ESTIMATEDXYZ_INVALID;
    _estimatedOkLab = Y_ESTIMATEDOKLAB_INVALID;
    _estimatedRAL = Y_ESTIMATEDRAL_INVALID;
    _ledCurrentAtPowerOn = Y_LEDCURRENTATPOWERON_INVALID;
    _integrationTimeAtPowerOn = Y_INTEGRATIONTIMEATPOWERON_INVALID;
    _gainAtPowerOn = Y_GAINATPOWERON_INVALID;
    _valueCallbackSpectralSensor = NULL;
//--- (end of YSpectralSensor attributes initialization)
    return self;
}
//--- (YSpectralSensor yapiwrapper)
//--- (end of YSpectralSensor yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YSpectralSensor cleanup)
    ARC_release(_estimatedXYZ);
    _estimatedXYZ = nil;
    ARC_release(_estimatedOkLab);
    _estimatedOkLab = nil;
    ARC_release(_estimatedRAL);
    _estimatedRAL = nil;
    ARC_dealloc(super);
//--- (end of YSpectralSensor cleanup)
}
//--- (YSpectralSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "ledCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ledCurrent =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "resolution")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _resolution =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "integrationTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _integrationTime =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "gain")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _gain =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "saturation")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _saturation =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "estimatedRGB")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _estimatedRGB =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "estimatedHSL")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _estimatedHSL =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "estimatedXYZ")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_estimatedXYZ);
        _estimatedXYZ =  [self _parseString:j];
        ARC_retain(_estimatedXYZ);
        return 1;
    }
    if(!strcmp(j->token, "estimatedOkLab")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_estimatedOkLab);
        _estimatedOkLab =  [self _parseString:j];
        ARC_retain(_estimatedOkLab);
        return 1;
    }
    if(!strcmp(j->token, "estimatedRAL")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_estimatedRAL);
        _estimatedRAL =  [self _parseString:j];
        ARC_retain(_estimatedRAL);
        return 1;
    }
    if(!strcmp(j->token, "ledCurrentAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ledCurrentAtPowerOn =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "integrationTimeAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _integrationTimeAtPowerOn =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "gainAtPowerOn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _gainAtPowerOn =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YSpectralSensor private methods implementation)
//--- (YSpectralSensor public methods implementation)
/**
 * Returns the current value of the LED.
 * This method retrieves the current flowing through the LED
 * and returns it as an integer or an object.
 *
 * @return an integer corresponding to the current value of the LED
 *
 * On failure, throws an exception or returns YSpectralSensor.LEDCURRENT_INVALID.
 */
-(int) get_ledCurrent
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LEDCURRENT_INVALID;
        }
    }
    res = _ledCurrent;
    return res;
}


-(int) ledCurrent
{
    return [self get_ledCurrent];
}

/**
 * Changes the luminosity of the module leds. The parameter is a
 * value between 0 and 100.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the luminosity of the module leds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ledCurrent:(int) newval
{
    return [self setLedCurrent:newval];
}
-(int) setLedCurrent:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"ledCurrent" :rest_val];
}

/**
 * Changes the resolution of the measured physical values. The resolution corresponds to the numerical precision
 * when displaying value. It does not change the precision of the measure itself.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the resolution of the measured physical values
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_resolution:(double) newval
{
    return [self setResolution:newval];
}
-(int) setResolution:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"resolution" :rest_val];
}
/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the measures, which is not always the same as the actual precision of the sensor.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return a floating point number corresponding to the resolution of the measured values
 *
 * On failure, throws an exception or returns YSpectralSensor.RESOLUTION_INVALID.
 */
-(double) get_resolution
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RESOLUTION_INVALID;
        }
    }
    res = _resolution;
    return res;
}


-(double) resolution
{
    return [self get_resolution];
}
/**
 * Returns the current integration time.
 * This method retrieves the integration time value
 * used for data processing and returns it as an integer or an object.
 *
 * @return an integer corresponding to the current integration time
 *
 * On failure, throws an exception or returns YSpectralSensor.INTEGRATIONTIME_INVALID.
 */
-(int) get_integrationTime
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_INTEGRATIONTIME_INVALID;
        }
    }
    res = _integrationTime;
    return res;
}


-(int) integrationTime
{
    return [self get_integrationTime];
}

/**
 * Sets the integration time for data processing.
 * This method takes a parameter `val` and assigns it
 * as the new integration time. This affects the duration
 * for which data is integrated before being processed.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_integrationTime:(int) newval
{
    return [self setIntegrationTime:newval];
}
-(int) setIntegrationTime:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"integrationTime" :rest_val];
}
/**
 * Retrieves the current gain.
 * This method updates the gain value.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns YSpectralSensor.GAIN_INVALID.
 */
-(int) get_gain
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_GAIN_INVALID;
        }
    }
    res = _gain;
    return res;
}


-(int) gain
{
    return [self get_gain];
}

/**
 * Sets the gain for signal processing.
 * This method takes a parameter `val` and assigns it
 * as the new gain. This affects the sensitivity and
 * intensity of the processed signal.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_gain:(int) newval
{
    return [self setGain:newval];
}
-(int) setGain:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"gain" :rest_val];
}
/**
 * Returns the current saturation of the sensor.
 * This function updates the sensor's saturation value.
 *
 * @return an integer corresponding to the current saturation of the sensor
 *
 * On failure, throws an exception or returns YSpectralSensor.SATURATION_INVALID.
 */
-(int) get_saturation
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SATURATION_INVALID;
        }
    }
    res = _saturation;
    return res;
}


-(int) saturation
{
    return [self get_saturation];
}
/**
 * Returns the estimated color in RGB format.
 * This method retrieves the estimated color values
 * and returns them as an RGB object or structure.
 *
 * @return an integer corresponding to the estimated color in RGB format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDRGB_INVALID.
 */
-(int) get_estimatedRGB
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATEDRGB_INVALID;
        }
    }
    res = _estimatedRGB;
    return res;
}


-(int) estimatedRGB
{
    return [self get_estimatedRGB];
}
/**
 * Returns the estimated color in HSL format.
 * This method retrieves the estimated color values
 * and returns them as an HSL object or structure.
 *
 * @return an integer corresponding to the estimated color in HSL format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDHSL_INVALID.
 */
-(int) get_estimatedHSL
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATEDHSL_INVALID;
        }
    }
    res = _estimatedHSL;
    return res;
}


-(int) estimatedHSL
{
    return [self get_estimatedHSL];
}
/**
 * Returns the estimated color in XYZ format.
 * This method retrieves the estimated color values
 * and returns them as an XYZ object or structure.
 *
 * @return a string corresponding to the estimated color in XYZ format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDXYZ_INVALID.
 */
-(NSString*) get_estimatedXYZ
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATEDXYZ_INVALID;
        }
    }
    res = _estimatedXYZ;
    return res;
}


-(NSString*) estimatedXYZ
{
    return [self get_estimatedXYZ];
}
/**
 * Returns the estimated color in OkLab format.
 * This method retrieves the estimated color values
 * and returns them as an OkLab object or structure.
 *
 * @return a string corresponding to the estimated color in OkLab format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDOKLAB_INVALID.
 */
-(NSString*) get_estimatedOkLab
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATEDOKLAB_INVALID;
        }
    }
    res = _estimatedOkLab;
    return res;
}


-(NSString*) estimatedOkLab
{
    return [self get_estimatedOkLab];
}
-(NSString*) get_estimatedRAL
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATEDRAL_INVALID;
        }
    }
    res = _estimatedRAL;
    return res;
}


-(NSString*) estimatedRAL
{
    return [self get_estimatedRAL];
}
-(int) get_ledCurrentAtPowerOn
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LEDCURRENTATPOWERON_INVALID;
        }
    }
    res = _ledCurrentAtPowerOn;
    return res;
}


-(int) ledCurrentAtPowerOn
{
    return [self get_ledCurrentAtPowerOn];
}

/**
 * Sets the LED current at power-on.
 * This method takes a parameter `val` and assigns it to startupLumin, representing the LED current defined
 * at startup.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ledCurrentAtPowerOn:(int) newval
{
    return [self setLedCurrentAtPowerOn:newval];
}
-(int) setLedCurrentAtPowerOn:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"ledCurrentAtPowerOn" :rest_val];
}
/**
 * Retrieves the integration time at power-on.
 * This method updates the power-on integration time value.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns YSpectralSensor.INTEGRATIONTIMEATPOWERON_INVALID.
 */
-(int) get_integrationTimeAtPowerOn
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_INTEGRATIONTIMEATPOWERON_INVALID;
        }
    }
    res = _integrationTimeAtPowerOn;
    return res;
}


-(int) integrationTimeAtPowerOn
{
    return [self get_integrationTimeAtPowerOn];
}

/**
 * Sets the integration time at power-on.
 * This method takes a parameter `val` and assigns it to startupIntegTime, representing the integration time
 * defined at startup.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_integrationTimeAtPowerOn:(int) newval
{
    return [self setIntegrationTimeAtPowerOn:newval];
}
-(int) setIntegrationTimeAtPowerOn:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"integrationTimeAtPowerOn" :rest_val];
}
-(int) get_gainAtPowerOn
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_GAINATPOWERON_INVALID;
        }
    }
    res = _gainAtPowerOn;
    return res;
}


-(int) gainAtPowerOn
{
    return [self get_gainAtPowerOn];
}

/**
 * Sets the gain at power-on.
 * This method takes a parameter `val` and assigns it to startupGain, representing the gain defined at startup.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_gainAtPowerOn:(int) newval
{
    return [self setGainAtPowerOn:newval];
}
-(int) setGainAtPowerOn:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"gainAtPowerOn" :rest_val];
}
/**
 * Retrieves a spectral sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the spectral sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSpectralSensor.isOnline() to test if the spectral sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a spectral sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the spectral sensor, for instance
 *         MyDevice.spectralSensor.
 *
 * @return a YSpectralSensor object allowing you to drive the spectral sensor.
 */
+(YSpectralSensor*) FindSpectralSensor:(NSString*)func
{
    YSpectralSensor* obj;
    obj = (YSpectralSensor*) [YFunction _FindFromCache:@"SpectralSensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSpectralSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"SpectralSensor" :func :obj];
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
-(int) registerValueCallback:(YSpectralSensorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSpectralSensor = callback;
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
    if (_valueCallbackSpectralSensor != NULL) {
        _valueCallbackSpectralSensor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YSpectralSensor*)   nextSpectralSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSpectralSensor FindSpectralSensor:hwid];
}

+(YSpectralSensor *) FirstSpectralSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SpectralSensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSpectralSensor FindSpectralSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSpectralSensor public methods implementation)
@end

//--- (YSpectralSensor functions)

YSpectralSensor *yFindSpectralSensor(NSString* func)
{
    return [YSpectralSensor FindSpectralSensor:func];
}

YSpectralSensor *yFirstSpectralSensor(void)
{
    return [YSpectralSensor FirstSpectralSensor];
}

//--- (end of YSpectralSensor functions)

