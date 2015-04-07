/*********************************************************************
 *
 * $Id: yocto_anbutton.m 19608 2015-03-05 10:37:24Z seb $
 *
 * Implements the high-level API for AnButton functions
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


#import "yocto_anbutton.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YAnButton

// Constructor is protected, use yFindAnButton factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"AnButton";
//--- (YAnButton attributes initialization)
    _calibratedValue = Y_CALIBRATEDVALUE_INVALID;
    _rawValue = Y_RAWVALUE_INVALID;
    _analogCalibration = Y_ANALOGCALIBRATION_INVALID;
    _calibrationMax = Y_CALIBRATIONMAX_INVALID;
    _calibrationMin = Y_CALIBRATIONMIN_INVALID;
    _sensitivity = Y_SENSITIVITY_INVALID;
    _isPressed = Y_ISPRESSED_INVALID;
    _lastTimePressed = Y_LASTTIMEPRESSED_INVALID;
    _lastTimeReleased = Y_LASTTIMERELEASED_INVALID;
    _pulseCounter = Y_PULSECOUNTER_INVALID;
    _pulseTimer = Y_PULSETIMER_INVALID;
    _valueCallbackAnButton = NULL;
//--- (end of YAnButton attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YAnButton cleanup)
    ARC_dealloc(super);
//--- (end of YAnButton cleanup)
}
//--- (YAnButton private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "calibratedValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _calibratedValue =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rawValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rawValue =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "analogCalibration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _analogCalibration =  (Y_ANALOGCALIBRATION_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "calibrationMax")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _calibrationMax =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "calibrationMin")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _calibrationMin =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "sensitivity")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _sensitivity =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "isPressed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _isPressed =  (Y_ISPRESSED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastTimePressed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastTimePressed =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastTimeReleased")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastTimeReleased =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pulseCounter")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseCounter =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pulseTimer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pulseTimer =  atol(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YAnButton private methods implementation)
//--- (YAnButton public methods implementation)
/**
 * Returns the current calibrated input value (between 0 and 1000, included).
 *
 * @return an integer corresponding to the current calibrated input value (between 0 and 1000, included)
 *
 * On failure, throws an exception or returns Y_CALIBRATEDVALUE_INVALID.
 */
-(int) get_calibratedValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALIBRATEDVALUE_INVALID;
        }
    }
    return _calibratedValue;
}


-(int) calibratedValue
{
    return [self get_calibratedValue];
}
/**
 * Returns the current measured input value as-is (between 0 and 4095, included).
 *
 * @return an integer corresponding to the current measured input value as-is (between 0 and 4095, included)
 *
 * On failure, throws an exception or returns Y_RAWVALUE_INVALID.
 */
-(int) get_rawValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RAWVALUE_INVALID;
        }
    }
    return _rawValue;
}


-(int) rawValue
{
    return [self get_rawValue];
}
/**
 * Tells if a calibration process is currently ongoing.
 *
 * @return either Y_ANALOGCALIBRATION_OFF or Y_ANALOGCALIBRATION_ON
 *
 * On failure, throws an exception or returns Y_ANALOGCALIBRATION_INVALID.
 */
-(Y_ANALOGCALIBRATION_enum) get_analogCalibration
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ANALOGCALIBRATION_INVALID;
        }
    }
    return _analogCalibration;
}


-(Y_ANALOGCALIBRATION_enum) analogCalibration
{
    return [self get_analogCalibration];
}

/**
 * Starts or stops the calibration process. Remember to call the saveToFlash()
 * method of the module at the end of the calibration if the modification must be kept.
 *
 * @param newval : either Y_ANALOGCALIBRATION_OFF or Y_ANALOGCALIBRATION_ON
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_analogCalibration:(Y_ANALOGCALIBRATION_enum) newval
{
    return [self setAnalogCalibration:newval];
}
-(int) setAnalogCalibration:(Y_ANALOGCALIBRATION_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"analogCalibration" :rest_val];
}
/**
 * Returns the maximal value measured during the calibration (between 0 and 4095, included).
 *
 * @return an integer corresponding to the maximal value measured during the calibration (between 0
 * and 4095, included)
 *
 * On failure, throws an exception or returns Y_CALIBRATIONMAX_INVALID.
 */
-(int) get_calibrationMax
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALIBRATIONMAX_INVALID;
        }
    }
    return _calibrationMax;
}


-(int) calibrationMax
{
    return [self get_calibrationMax];
}

/**
 * Changes the maximal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the maximal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_calibrationMax:(int) newval
{
    return [self setCalibrationMax:newval];
}
-(int) setCalibrationMax:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"calibrationMax" :rest_val];
}
/**
 * Returns the minimal value measured during the calibration (between 0 and 4095, included).
 *
 * @return an integer corresponding to the minimal value measured during the calibration (between 0
 * and 4095, included)
 *
 * On failure, throws an exception or returns Y_CALIBRATIONMIN_INVALID.
 */
-(int) get_calibrationMin
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALIBRATIONMIN_INVALID;
        }
    }
    return _calibrationMin;
}


-(int) calibrationMin
{
    return [self get_calibrationMin];
}

/**
 * Changes the minimal calibration value for the input (between 0 and 4095, included), without actually
 * starting the automated calibration.  Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the minimal calibration value for the input (between 0
 * and 4095, included), without actually
 *         starting the automated calibration
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_calibrationMin:(int) newval
{
    return [self setCalibrationMin:newval];
}
-(int) setCalibrationMin:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"calibrationMin" :rest_val];
}
/**
 * Returns the sensibility for the input (between 1 and 1000) for triggering user callbacks.
 *
 * @return an integer corresponding to the sensibility for the input (between 1 and 1000) for
 * triggering user callbacks
 *
 * On failure, throws an exception or returns Y_SENSITIVITY_INVALID.
 */
-(int) get_sensitivity
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SENSITIVITY_INVALID;
        }
    }
    return _sensitivity;
}


-(int) sensitivity
{
    return [self get_sensitivity];
}

/**
 * Changes the sensibility for the input (between 1 and 1000) for triggering user callbacks.
 * The sensibility is used to filter variations around a fixed value, but does not preclude the
 * transmission of events when the input value evolves constantly in the same direction.
 * Special case: when the value 1000 is used, the callback will only be thrown when the logical state
 * of the input switches from pressed to released and back.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the sensibility for the input (between 1 and 1000) for
 * triggering user callbacks
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_sensitivity:(int) newval
{
    return [self setSensitivity:newval];
}
-(int) setSensitivity:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"sensitivity" :rest_val];
}
/**
 * Returns true if the input (considered as binary) is active (closed contact), and false otherwise.
 *
 * @return either Y_ISPRESSED_FALSE or Y_ISPRESSED_TRUE, according to true if the input (considered as
 * binary) is active (closed contact), and false otherwise
 *
 * On failure, throws an exception or returns Y_ISPRESSED_INVALID.
 */
-(Y_ISPRESSED_enum) get_isPressed
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ISPRESSED_INVALID;
        }
    }
    return _isPressed;
}


-(Y_ISPRESSED_enum) isPressed
{
    return [self get_isPressed];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was pressed (the input contact transitioned from open to closed).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was pressed (the input contact transitioned from open to closed)
 *
 * On failure, throws an exception or returns Y_LASTTIMEPRESSED_INVALID.
 */
-(s64) get_lastTimePressed
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMEPRESSED_INVALID;
        }
    }
    return _lastTimePressed;
}


-(s64) lastTimePressed
{
    return [self get_lastTimePressed];
}
/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was released (the input contact transitioned from closed to open).
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was released (the input contact transitioned from closed to open)
 *
 * On failure, throws an exception or returns Y_LASTTIMERELEASED_INVALID.
 */
-(s64) get_lastTimeReleased
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTTIMERELEASED_INVALID;
        }
    }
    return _lastTimeReleased;
}


-(s64) lastTimeReleased
{
    return [self get_lastTimeReleased];
}
/**
 * Returns the pulse counter value
 *
 * @return an integer corresponding to the pulse counter value
 *
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(s64) get_pulseCounter
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSECOUNTER_INVALID;
        }
    }
    return _pulseCounter;
}


-(s64) pulseCounter
{
    return [self get_pulseCounter];
}

-(int) set_pulseCounter:(s64) newval
{
    return [self setPulseCounter:newval];
}
-(int) setPulseCounter:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"pulseCounter" :rest_val];
}
/**
 * Returns the timer of the pulses counter (ms)
 *
 * @return an integer corresponding to the timer of the pulses counter (ms)
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(s64) get_pulseTimer
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PULSETIMER_INVALID;
        }
    }
    return _pulseTimer;
}


-(s64) pulseTimer
{
    return [self get_pulseTimer];
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
 * Use the method YAnButton.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YAnButton object allowing you to drive $THEFUNCTION$.
 */
+(YAnButton*) FindAnButton:(NSString*)func
{
    YAnButton* obj;
    obj = (YAnButton*) [YFunction _FindFromCache:@"AnButton" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YAnButton alloc] initWith:func]);
        [YFunction _AddToCache:@"AnButton" : func :obj];
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
-(int) registerValueCallback:(YAnButtonValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackAnButton = callback;
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
    if (_valueCallbackAnButton != NULL) {
        _valueCallbackAnButton(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Returns the pulse counter value as well as its timer.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetCounter
{
    return [self set_pulseCounter:0];
}


-(YAnButton*)   nextAnButton
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YAnButton FindAnButton:hwid];
}

+(YAnButton *) FirstAnButton
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"AnButton":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YAnButton FindAnButton:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YAnButton public methods implementation)

@end
//--- (AnButton functions)

YAnButton *yFindAnButton(NSString* func)
{
    return [YAnButton FindAnButton:func];
}

YAnButton *yFirstAnButton(void)
{
    return [YAnButton FirstAnButton];
}

//--- (end of AnButton functions)
