/*********************************************************************
 *
 * $Id: yocto_gyro.m 19704 2015-03-13 06:10:37Z mvuilleu $
 *
 * Implements the high-level API for Gyro functions
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


#import "yocto_gyro.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YQt

// Constructor is protected, use yFindQt factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Qt";
//--- (generated code: YQt attributes initialization)
    _valueCallbackQt = NULL;
    _timedReportCallbackQt = NULL;
//--- (end of generated code: YQt attributes initialization)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (generated code: YQt cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YQt cleanup)
}
//--- (generated code: YQt private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    return [super _parseAttr:j];
}
//--- (end of generated code: YQt private methods implementation)
//--- (generated code: YQt public methods implementation)
/**
 * Retrieves a quaternion component for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quaternion component is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQt.isOnline() to test if the quaternion component is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quaternion component by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the quaternion component
 *
 * @return a YQt object allowing you to drive the quaternion component.
 */
+(YQt*) FindQt:(NSString*)func
{
    YQt* obj;
    obj = (YQt*) [YFunction _FindFromCache:@"Qt" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YQt alloc] initWith:func]);
        [YFunction _AddToCache:@"Qt" : func :obj];
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
-(int) registerValueCallback:(YQtValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackQt = callback;
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
    if (_valueCallbackQt != NULL) {
        _valueCallbackQt(self, value);
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
-(int) registerTimedReportCallback:(YQtTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackQt = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackQt != NULL) {
        _timedReportCallbackQt(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YQt*)   nextQt
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YQt FindQt:hwid];
}

+(YQt *) FirstQt
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Qt":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YQt FindQt:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YQt public methods implementation)

@end
//--- (generated code: Qt functions)

YQt *yFindQt(NSString* func)
{
    return [YQt FindQt:func];
}

YQt *yFirstQt(void)
{
    return [YQt FirstQt];
}

//--- (end of generated code: Qt functions)



static void yInternalGyroCallback(YQt *obj, NSString *value)
{
    YGyro *gyro = (YGyro*) [obj get_userData];
    if (gyro == NULL) {
        return;
    }
    NSString *tmp = [[obj get_functionId] substringFromIndex:2] ;
    int idx = [tmp intValue];
    double dbl_value = [value doubleValue];
    [gyro _invokeGyroCallbacks:idx :dbl_value];
}

@implementation YGyro

// Constructor is protected, use yFindGyro factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Gyro";
//--- (generated code: YGyro attributes initialization)
    _xValue = Y_XVALUE_INVALID;
    _yValue = Y_YVALUE_INVALID;
    _zValue = Y_ZVALUE_INVALID;
    _valueCallbackGyro = NULL;
    _timedReportCallbackGyro = NULL;
    _qt_stamp = 0;
    _w = 0;
    _x = 0;
    _y = 0;
    _z = 0;
    _angles_stamp = 0;
    _head = 0;
    _pitch = 0;
    _roll = 0;
    _quatCallback = NULL;
    _anglesCallback = NULL;
//--- (end of generated code: YGyro attributes initialization)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (generated code: YGyro cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YGyro cleanup)
}
//--- (generated code: YGyro private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "xValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _xValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "yValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _yValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "zValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _zValue =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YGyro private methods implementation)
//--- (generated code: YGyro public methods implementation)
/**
 * Returns the angular velocity around the X axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the X axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_XVALUE_INVALID.
 */
-(double) get_xValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_XVALUE_INVALID;
        }
    }
    return _xValue;
}


-(double) xValue
{
    return [self get_xValue];
}
/**
 * Returns the angular velocity around the Y axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the Y axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_YVALUE_INVALID.
 */
-(double) get_yValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_YVALUE_INVALID;
        }
    }
    return _yValue;
}


-(double) yValue
{
    return [self get_yValue];
}
/**
 * Returns the angular velocity around the Z axis of the device, as a floating point number.
 *
 * @return a floating point number corresponding to the angular velocity around the Z axis of the
 * device, as a floating point number
 *
 * On failure, throws an exception or returns Y_ZVALUE_INVALID.
 */
-(double) get_zValue
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ZVALUE_INVALID;
        }
    }
    return _zValue;
}


-(double) zValue
{
    return [self get_zValue];
}
/**
 * Retrieves a gyroscope for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the gyroscope is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGyro.isOnline() to test if the gyroscope is
 * indeed online at a given time. In case of ambiguity when looking for
 * a gyroscope by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the gyroscope
 *
 * @return a YGyro object allowing you to drive the gyroscope.
 */
+(YGyro*) FindGyro:(NSString*)func
{
    YGyro* obj;
    obj = (YGyro*) [YFunction _FindFromCache:@"Gyro" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YGyro alloc] initWith:func]);
        [YFunction _AddToCache:@"Gyro" : func :obj];
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
-(int) registerValueCallback:(YGyroValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackGyro = callback;
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
    if (_valueCallbackGyro != NULL) {
        _valueCallbackGyro(self, value);
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
-(int) registerTimedReportCallback:(YGyroTimedReportCallback)callback
{
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:self :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:self :NO];
    }
    _timedReportCallbackGyro = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackGyro != NULL) {
        _timedReportCallbackGyro(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}

-(int) _loadQuaternion
{
    int now_stamp;
    int age_ms;
    
    now_stamp = (int) (([YAPI GetTickCount]) & (0x7FFFFFFF));
    age_ms = (((now_stamp - _qt_stamp)) & (0x7FFFFFFF));
    if ((age_ms >= 10) || (_qt_stamp == 0)) {
        if ([self load:10] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        if (_qt_stamp == 0) {
            _qt_w = [YQt FindQt:[NSString stringWithFormat:@"%@.qt1",_serial]];
            _qt_x = [YQt FindQt:[NSString stringWithFormat:@"%@.qt2",_serial]];
            _qt_y = [YQt FindQt:[NSString stringWithFormat:@"%@.qt3",_serial]];
            _qt_z = [YQt FindQt:[NSString stringWithFormat:@"%@.qt4",_serial]];
        }
        if ([_qt_w load:9] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        if ([_qt_x load:9] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        if ([_qt_y load:9] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        if ([_qt_z load:9] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        _w = [_qt_w get_currentValue];
        _x = [_qt_x get_currentValue];
        _y = [_qt_y get_currentValue];
        _z = [_qt_z get_currentValue];
        _qt_stamp = now_stamp;
    }
    return YAPI_SUCCESS;
}

-(int) _loadAngles
{
    double sqw;
    double sqx;
    double sqy;
    double sqz;
    double norm;
    double delta;
    // may throw an exception
    if ([self _loadQuaternion] != YAPI_SUCCESS) {
        return YAPI_DEVICE_NOT_FOUND;
    }
    if (_angles_stamp != _qt_stamp) {
        sqw = _w * _w;
        sqx = _x * _x;
        sqy = _y * _y;
        sqz = _z * _z;
        norm = sqx + sqy + sqz + sqw;
        delta = _y * _w - _x * _z;
        if (delta > 0.499 * norm) {
            _pitch = 90.0;
            _head  = floor(2.0 * 1800.0/3.141592653589793238463 * atan2(_x,_w)+0.5) / 10.0;
        } else {
            if (delta < -0.499 * norm) {
                _pitch = -90.0;
                _head  = floor(-2.0 * 1800.0/3.141592653589793238463 * atan2(_x,_w)+0.5) / 10.0;
            } else {
                _roll  = floor(1800.0/3.141592653589793238463 * atan2(2.0 * (_w * _x + _y * _z),sqw - sqx - sqy + sqz)+0.5) / 10.0;
                _pitch = floor(1800.0/3.141592653589793238463 * asin(2.0 * delta / norm)+0.5) / 10.0;
                _head  = floor(1800.0/3.141592653589793238463 * atan2(2.0 * (_x * _y + _z * _w),sqw + sqx - sqy - sqz)+0.5) / 10.0;
            }
        }
        _angles_stamp = _qt_stamp;
    }
    return YAPI_SUCCESS;
}

/**
 * Returns the estimated roll angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the roll angle can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to roll angle
 *         in degrees, between -180 and +180.
 */
-(double) get_roll
{
    [self _loadAngles];
    return _roll;
}

/**
 * Returns the estimated pitch angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the pitch angle can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to pitch angle
 *         in degrees, between -90 and +90.
 */
-(double) get_pitch
{
    [self _loadAngles];
    return _pitch;
}

/**
 * Returns the estimated heading angle, based on the integration of
 * gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 * The axis corresponding to the heading can be mapped to any
 * of the device X, Y or Z physical directions using methods of
 * the class YRefFrame.
 *
 * @return a floating-point number corresponding to heading
 *         in degrees, between 0 and 360.
 */
-(double) get_heading
{
    [self _loadAngles];
    return _head;
}

/**
 * Returns the w component (real part) of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements.
 *
 * @return a floating-point number corresponding to the w
 *         component of the quaternion.
 */
-(double) get_quaternionW
{
    [self _loadQuaternion];
    return _w;
}

/**
 * Returns the x component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The x component is
 * mostly correlated with rotations on the roll axis.
 *
 * @return a floating-point number corresponding to the x
 *         component of the quaternion.
 */
-(double) get_quaternionX
{
    [self _loadQuaternion];
    return _x;
}

/**
 * Returns the y component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The y component is
 * mostly correlated with rotations on the pitch axis.
 *
 * @return a floating-point number corresponding to the y
 *         component of the quaternion.
 */
-(double) get_quaternionY
{
    [self _loadQuaternion];
    return _y;
}

/**
 * Returns the x component of the quaternion
 * describing the device estimated orientation, based on the
 * integration of gyroscopic measures combined with acceleration and
 * magnetic field measurements. The x component is
 * mostly correlated with changes of heading.
 *
 * @return a floating-point number corresponding to the z
 *         component of the quaternion.
 */
-(double) get_quaternionZ
{
    [self _loadQuaternion];
    return _z;
}

/**
 * Registers a callback function that will be invoked each time that the estimated
 * device orientation has changed. The call frequency is typically around 95Hz during a move.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered.
 * For good responsiveness, remember to call one of these two functions periodically.
 * To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to invoke, or a null pointer.
 *         The callback function should take five arguments:
 *         the YGyro object of the turning device, and the floating
 *         point values of the four components w, x, y and z
 *         (as floating-point numbers).
 * @noreturn
 */
-(int) registerQuaternionCallback:(YQuatCallback)callback
{
    _quatCallback = callback;
    if (callback != NULL) {
        if ([self _loadQuaternion] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        [_qt_w set_userData:self];
        [_qt_x set_userData:self];
        [_qt_y set_userData:self];
        [_qt_z set_userData:self];
        [_qt_w registerValueCallback:yInternalGyroCallback];
        [_qt_x registerValueCallback:yInternalGyroCallback];
        [_qt_y registerValueCallback:yInternalGyroCallback];
        [_qt_z registerValueCallback:yInternalGyroCallback];
    } else {
        if (!(_anglesCallback != NULL)) {
            [_qt_w registerValueCallback:(YQtValueCallback) nil];
            [_qt_x registerValueCallback:(YQtValueCallback) nil];
            [_qt_y registerValueCallback:(YQtValueCallback) nil];
            [_qt_z registerValueCallback:(YQtValueCallback) nil];
        }
    }
    return 0;
}

/**
 * Registers a callback function that will be invoked each time that the estimated
 * device orientation has changed. The call frequency is typically around 95Hz during a move.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered.
 * For good responsiveness, remember to call one of these two functions periodically.
 * To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to invoke, or a null pointer.
 *         The callback function should take four arguments:
 *         the YGyro object of the turning device, and the floating
 *         point values of the three angles roll, pitch and heading
 *         in degrees (as floating-point numbers).
 * @noreturn
 */
-(int) registerAnglesCallback:(YAnglesCallback)callback
{
    _anglesCallback = callback;
    if (callback != NULL) {
        if ([self _loadQuaternion] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
        [_qt_w set_userData:self];
        [_qt_x set_userData:self];
        [_qt_y set_userData:self];
        [_qt_z set_userData:self];
        [_qt_w registerValueCallback:yInternalGyroCallback];
        [_qt_x registerValueCallback:yInternalGyroCallback];
        [_qt_y registerValueCallback:yInternalGyroCallback];
        [_qt_z registerValueCallback:yInternalGyroCallback];
    } else {
        if (!(_quatCallback != NULL)) {
            [_qt_w registerValueCallback:(YQtValueCallback) nil];
            [_qt_x registerValueCallback:(YQtValueCallback) nil];
            [_qt_y registerValueCallback:(YQtValueCallback) nil];
            [_qt_z registerValueCallback:(YQtValueCallback) nil];
        }
    }
    return 0;
}

-(int) _invokeGyroCallbacks:(int)qtIndex :(double)qtValue
{
    switch(qtIndex - 1) {
    case 0:
        _w = qtValue;
        break;
    case 1:
        _x = qtValue;
        break;
    case 2:
        _y = qtValue;
        break;
    case 3:
        _z = qtValue;
        break;
    }
    if (qtIndex < 4) {
        return 0;
    }
    _qt_stamp = (int) (([YAPI GetTickCount]) & (0x7FFFFFFF));
    if (_quatCallback != NULL) {
        _quatCallback(self, _w, _x, _y, _z);
    }
    if (_anglesCallback != NULL) {
        [self _loadAngles];
        _anglesCallback(self, _roll, _pitch, _head);
    }
    return 0;
}


-(YGyro*)   nextGyro
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YGyro FindGyro:hwid];
}

+(YGyro *) FirstGyro
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Gyro":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YGyro FindGyro:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YGyro public methods implementation)

@end
//--- (generated code: Gyro functions)

YGyro *yFindGyro(NSString* func)
{
    return [YGyro FindGyro:func];
}

YGyro *yFirstGyro(void)
{
    return [YGyro FirstGyro];
}

//--- (end of generated code: Gyro functions)
