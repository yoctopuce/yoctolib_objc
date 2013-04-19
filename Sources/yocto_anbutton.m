/*********************************************************************
 *
 * $Id: yocto_anbutton.m 9489 2013-01-22 11:03:40Z seb $
 *
 * Implements yFindAnButton(), the high-level API for AnButton functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/


#import "yocto_anbutton.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


static NSMutableDictionary* _AnButtonCache = nil;

@implementation YAnButton

// Constructor is protected, use yFindAnButton factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YAnButton attributes)
   if(!(self = [super initProtected:@"AnButton":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
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
//--- (end of YAnButton attributes)
    return self;
}
//--- (YAnButton implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "calibratedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _calibratedValue =  atoi(j->token);
        } else if(!strcmp(j->token, "rawValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _rawValue =  atoi(j->token);
        } else if(!strcmp(j->token, "analogCalibration")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _analogCalibration =  (Y_ANALOGCALIBRATION_enum)atoi(j->token);
        } else if(!strcmp(j->token, "calibrationMax")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _calibrationMax =  atoi(j->token);
        } else if(!strcmp(j->token, "calibrationMin")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _calibrationMin =  atoi(j->token);
        } else if(!strcmp(j->token, "sensitivity")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _sensitivity =  atoi(j->token);
        } else if(!strcmp(j->token, "isPressed")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _isPressed =  (Y_ISPRESSED_enum)atoi(j->token);
        } else if(!strcmp(j->token, "lastTimePressed")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _lastTimePressed =  atoi(j->token);
        } else if(!strcmp(j->token, "lastTimeReleased")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _lastTimeReleased =  atoi(j->token);
        } else if(!strcmp(j->token, "pulseCounter")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _pulseCounter =  atoi(j->token);
        } else if(!strcmp(j->token, "pulseTimer")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _pulseTimer =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the analog input.
 * 
 * @return a string corresponding to the logical name of the analog input
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * Changes the logical name of the analog input. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the analog input
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the analog input (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the analog input (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the current calibrated input value (between 0 and 1000, included).
 * 
 * @return an integer corresponding to the current calibrated input value (between 0 and 1000, included)
 * 
 * On failure, throws an exception or returns Y_CALIBRATEDVALUE_INVALID.
 */
-(unsigned) get_calibratedValue
{
    return [self calibratedValue];
}
-(unsigned) calibratedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALIBRATEDVALUE_INVALID;
    }
    return _calibratedValue;
}

/**
 * Returns the current measured input value as-is (between 0 and 4095, included).
 * 
 * @return an integer corresponding to the current measured input value as-is (between 0 and 4095, included)
 * 
 * On failure, throws an exception or returns Y_RAWVALUE_INVALID.
 */
-(unsigned) get_rawValue
{
    return [self rawValue];
}
-(unsigned) rawValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RAWVALUE_INVALID;
    }
    return _rawValue;
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
    return [self analogCalibration];
}
-(Y_ANALOGCALIBRATION_enum) analogCalibration
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ANALOGCALIBRATION_INVALID;
    }
    return _analogCalibration;
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
-(unsigned) get_calibrationMax
{
    return [self calibrationMax];
}
-(unsigned) calibrationMax
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALIBRATIONMAX_INVALID;
    }
    return _calibrationMax;
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
-(int) set_calibrationMax:(unsigned) newval
{
    return [self setCalibrationMax:newval];
}
-(int) setCalibrationMax:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
-(unsigned) get_calibrationMin
{
    return [self calibrationMin];
}
-(unsigned) calibrationMin
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALIBRATIONMIN_INVALID;
    }
    return _calibrationMin;
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
-(int) set_calibrationMin:(unsigned) newval
{
    return [self setCalibrationMin:newval];
}
-(int) setCalibrationMin:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"calibrationMin" :rest_val];
}

/**
 * Returns the sensibility for the input (between 1 and 255, included) for triggering user callbacks.
 * 
 * @return an integer corresponding to the sensibility for the input (between 1 and 255, included) for
 * triggering user callbacks
 * 
 * On failure, throws an exception or returns Y_SENSITIVITY_INVALID.
 */
-(unsigned) get_sensitivity
{
    return [self sensitivity];
}
-(unsigned) sensitivity
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SENSITIVITY_INVALID;
    }
    return _sensitivity;
}

/**
 * Changes the sensibility for the input (between 1 and 255, included) for triggering user callbacks.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * 
 * @param newval : an integer corresponding to the sensibility for the input (between 1 and 255,
 * included) for triggering user callbacks
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_sensitivity:(unsigned) newval
{
    return [self setSensitivity:newval];
}
-(int) setSensitivity:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
    return [self isPressed];
}
-(Y_ISPRESSED_enum) isPressed
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ISPRESSED_INVALID;
    }
    return _isPressed;
}

/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was pressed (the input contact transitionned from open to closed).
 * 
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was pressed (the input contact transitionned from open to closed)
 * 
 * On failure, throws an exception or returns Y_LASTTIMEPRESSED_INVALID.
 */
-(unsigned) get_lastTimePressed
{
    return [self lastTimePressed];
}
-(unsigned) lastTimePressed
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LASTTIMEPRESSED_INVALID;
    }
    return _lastTimePressed;
}

/**
 * Returns the number of elapsed milliseconds between the module power on and the last time
 * the input button was released (the input contact transitionned from closed to open).
 * 
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 * and the last time
 *         the input button was released (the input contact transitionned from closed to open)
 * 
 * On failure, throws an exception or returns Y_LASTTIMERELEASED_INVALID.
 */
-(unsigned) get_lastTimeReleased
{
    return [self lastTimeReleased];
}
-(unsigned) lastTimeReleased
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LASTTIMERELEASED_INVALID;
    }
    return _lastTimeReleased;
}

/**
 * Returns the pulse counter value
 * 
 * @return an integer corresponding to the pulse counter value
 * 
 * On failure, throws an exception or returns Y_PULSECOUNTER_INVALID.
 */
-(unsigned) get_pulseCounter
{
    return [self pulseCounter];
}
-(unsigned) pulseCounter
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PULSECOUNTER_INVALID;
    }
    return _pulseCounter;
}

-(int) set_pulseCounter:(unsigned) newval
{
    return [self setPulseCounter:newval];
}
-(int) setPulseCounter:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"pulseCounter" :rest_val];
}

/**
 * Returns the pulse counter value as well as his timer
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetCounter
{
    NSString* rest_val;
    rest_val = @"0";
    return [self _setAttr:@"pulseCounter" :rest_val];
}

/**
 * Returns the timer of the pulses counter (ms)
 * 
 * @return an integer corresponding to the timer of the pulses counter (ms)
 * 
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(unsigned) get_pulseTimer
{
    return [self pulseTimer];
}
-(unsigned) pulseTimer
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PULSETIMER_INVALID;
    }
    return _pulseTimer;
}

-(YAnButton*)   nextAnButton
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindAnButton(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YAnButton*) FindAnButton:(NSString*) func
{
    YAnButton * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    {
        if (_AnButtonCache == nil){
            _AnButtonCache = [[NSMutableDictionary alloc] init];
        }
        if(nil != [_AnButtonCache objectForKey:func]){
            retVal = [_AnButtonCache objectForKey:func];
       } else {
           YAnButton *newAnButton = [[YAnButton alloc] initWithFunction:func];
           [_AnButtonCache setObject:newAnButton forKey:func];
           retVal = newAnButton;
           ARC_autorelease(retVal);
       }
   }
   return retVal;
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

//--- (end of YAnButton implementation)

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
