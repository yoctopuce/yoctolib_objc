/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for RefFrame functions
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


#import "yocto_refframe.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YRefFrame
// Constructor is protected, use yFindRefFrame factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"RefFrame";
//--- (YRefFrame attributes initialization)
    _mountPos = Y_MOUNTPOS_INVALID;
    _bearing = Y_BEARING_INVALID;
    _calibrationParam = Y_CALIBRATIONPARAM_INVALID;
    _fusionMode = Y_FUSIONMODE_INVALID;
    _valueCallbackRefFrame = NULL;
    _calibStage = 0;
    _calibStageProgress = 0;
    _calibProgress = 0;
    _calibCount = 0;
    _calibInternalPos = 0;
    _calibPrevTick = 0;
    _calibOrient = [NSMutableArray array];
    _calibDataAccX = [NSMutableArray array];
    _calibDataAccY = [NSMutableArray array];
    _calibDataAccZ = [NSMutableArray array];
    _calibDataAcc = [NSMutableArray array];
    _calibAccXOfs = 0;
    _calibAccYOfs = 0;
    _calibAccZOfs = 0;
    _calibAccXScale = 0;
    _calibAccYScale = 0;
    _calibAccZScale = 0;
//--- (end of YRefFrame attributes initialization)
    return self;
}
//--- (YRefFrame yapiwrapper)
//--- (end of YRefFrame yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YRefFrame cleanup)
    ARC_release(_calibrationParam);
    _calibrationParam = nil;
    ARC_dealloc(super);
//--- (end of YRefFrame cleanup)
}
//--- (YRefFrame private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "mountPos")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _mountPos =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "bearing")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _bearing =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "calibrationParam")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_calibrationParam);
        _calibrationParam =  [self _parseString:j];
        ARC_retain(_calibrationParam);
        return 1;
    }
    if(!strcmp(j->token, "fusionMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _fusionMode =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YRefFrame private methods implementation)
//--- (YRefFrame public methods implementation)
-(int) get_mountPos
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MOUNTPOS_INVALID;
        }
    }
    res = _mountPos;
    return res;
}


-(int) mountPos
{
    return [self get_mountPos];
}

-(int) set_mountPos:(int) newval
{
    return [self setMountPos:newval];
}
-(int) setMountPos:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"mountPos" :rest_val];
}

/**
 * Changes the reference bearing used by the compass. The relative bearing
 * indicated by the compass is the difference between the measured magnetic
 * heading and the reference bearing indicated here.
 *
 * For instance, if you set up as reference bearing the value of the earth
 * magnetic declination, the compass will provide the orientation relative
 * to the geographic North.
 *
 * Similarly, when the sensor is not mounted along the standard directions
 * because it has an additional yaw angle, you can set this angle in the reference
 * bearing so that the compass provides the expected natural direction.
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the reference bearing used by the compass
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bearing:(double) newval
{
    return [self setBearing:newval];
}
-(int) setBearing:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"bearing" :rest_val];
}
/**
 * Returns the reference bearing used by the compass. The relative bearing
 * indicated by the compass is the difference between the measured magnetic
 * heading and the reference bearing indicated here.
 *
 * @return a floating point number corresponding to the reference bearing used by the compass
 *
 * On failure, throws an exception or returns YRefFrame.BEARING_INVALID.
 */
-(double) get_bearing
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BEARING_INVALID;
        }
    }
    res = _bearing;
    return res;
}


-(double) bearing
{
    return [self get_bearing];
}
-(NSString*) get_calibrationParam
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALIBRATIONPARAM_INVALID;
        }
    }
    res = _calibrationParam;
    return res;
}


-(NSString*) calibrationParam
{
    return [self get_calibrationParam];
}

-(int) set_calibrationParam:(NSString*) newval
{
    return [self setCalibrationParam:newval];
}
-(int) setCalibrationParam:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"calibrationParam" :rest_val];
}
/**
 * Returns the sensor fusion mode. Note that available sensor fusion modes depend on the sensor type.
 *
 * @return a value among YRefFrame.FUSIONMODE_NDOF, YRefFrame.FUSIONMODE_NDOF_FMC_OFF,
 * YRefFrame.FUSIONMODE_M4G, YRefFrame.FUSIONMODE_COMPASS, YRefFrame.FUSIONMODE_IMU,
 * YRefFrame.FUSIONMODE_INCLIN_90DEG_1G8, YRefFrame.FUSIONMODE_INCLIN_90DEG_3G6 and
 * YRefFrame.FUSIONMODE_INCLIN_10DEG corresponding to the sensor fusion mode
 *
 * On failure, throws an exception or returns YRefFrame.FUSIONMODE_INVALID.
 */
-(Y_FUSIONMODE_enum) get_fusionMode
{
    Y_FUSIONMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_FUSIONMODE_INVALID;
        }
    }
    res = _fusionMode;
    return res;
}


-(Y_FUSIONMODE_enum) fusionMode
{
    return [self get_fusionMode];
}

/**
 * Change the sensor fusion mode. Note that available sensor fusion modes depend on the sensor type.
 * Remember to call the matching module saveToFlash() method to save the setting permanently.
 *
 * @param newval : a value among YRefFrame.FUSIONMODE_NDOF, YRefFrame.FUSIONMODE_NDOF_FMC_OFF,
 * YRefFrame.FUSIONMODE_M4G, YRefFrame.FUSIONMODE_COMPASS, YRefFrame.FUSIONMODE_IMU,
 * YRefFrame.FUSIONMODE_INCLIN_90DEG_1G8, YRefFrame.FUSIONMODE_INCLIN_90DEG_3G6 and
 * YRefFrame.FUSIONMODE_INCLIN_10DEG
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_fusionMode:(Y_FUSIONMODE_enum) newval
{
    return [self setFusionMode:newval];
}
-(int) setFusionMode:(Y_FUSIONMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"fusionMode" :rest_val];
}
/**
 * Retrieves a reference frame for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the reference frame is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRefFrame.isOnline() to test if the reference frame is
 * indeed online at a given time. In case of ambiguity when looking for
 * a reference frame by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the reference frame, for instance
 *         Y3DMK002.refFrame.
 *
 * @return a YRefFrame object allowing you to drive the reference frame.
 */
+(YRefFrame*) FindRefFrame:(NSString*)func
{
    YRefFrame* obj;
    obj = (YRefFrame*) [YFunction _FindFromCache:@"RefFrame" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YRefFrame alloc] initWith:func]);
        [YFunction _AddToCache:@"RefFrame" :func :obj];
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
-(int) registerValueCallback:(YRefFrameValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackRefFrame = callback;
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
    if (_valueCallbackRefFrame != NULL) {
        _valueCallbackRefFrame(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Returns the installation position of the device, as configured
 * in order to define the reference frame for the compass and the
 * pitch/roll tilt sensors.
 *
 * @return a value among the YRefFrame.MOUNTPOSITION enumeration
 *         (YRefFrame.MOUNTPOSITION_BOTTOM,  YRefFrame.MOUNTPOSITION_TOP,
 *         YRefFrame.MOUNTPOSITION_FRONT,    YRefFrame.MOUNTPOSITION_RIGHT,
 *         YRefFrame.MOUNTPOSITION_REAR,     YRefFrame.MOUNTPOSITION_LEFT),
 *         corresponding to the installation in a box, on one of the six faces.
 *
 * On failure, throws an exception or returns Y_MOUNTPOSITION_INVALID.
 */
-(Y_MOUNTPOSITION) get_mountPosition
{
    int position;
    position = [self get_mountPos];
    if (position < 0) {
        return Y_MOUNTPOSITION_INVALID;
    }
    return (Y_MOUNTPOSITION) (position >> 2);
}

/**
 * Returns the installation orientation of the device, as configured
 * in order to define the reference frame for the compass and the
 * pitch/roll tilt sensors.
 *
 * @return a value among the enumeration YRefFrame.MOUNTORIENTATION
 *         (YRefFrame.MOUNTORIENTATION_TWELVE, YRefFrame.MOUNTORIENTATION_THREE,
 *         YRefFrame.MOUNTORIENTATION_SIX,     YRefFrame.MOUNTORIENTATION_NINE)
 *         corresponding to the orientation of the "X" arrow on the device,
 *         as on a clock dial seen from an observer in the center of the box.
 *         On the bottom face, the 12H orientation points to the front, while
 *         on the top face, the 12H orientation points to the rear.
 *
 * On failure, throws an exception or returns Y_MOUNTORIENTATION_INVALID.
 */
-(Y_MOUNTORIENTATION) get_mountOrientation
{
    int position;
    position = [self get_mountPos];
    if (position < 0) {
        return Y_MOUNTORIENTATION_INVALID;
    }
    return (Y_MOUNTORIENTATION) (position & 3);
}

/**
 * Changes the compass and tilt sensor frame of reference. The magnetic compass
 * and the tilt sensors (pitch and roll) naturally work in the plane
 * parallel to the earth surface. In case the device is not installed upright
 * and horizontally, you must select its reference orientation (parallel to
 * the earth surface) so that the measures are made relative to this position.
 *
 * @param position : a value among the YRefFrame.MOUNTPOSITION enumeration
 *         (YRefFrame.MOUNTPOSITION_BOTTOM,  YRefFrame.MOUNTPOSITION_TOP,
 *         YRefFrame.MOUNTPOSITION_FRONT,    YRefFrame.MOUNTPOSITION_RIGHT,
 *         YRefFrame.MOUNTPOSITION_REAR,     YRefFrame.MOUNTPOSITION_LEFT),
 *         corresponding to the installation in a box, on one of the six faces.
 * @param orientation : a value among the enumeration YRefFrame.MOUNTORIENTATION
 *         (YRefFrame.MOUNTORIENTATION_TWELVE, YRefFrame.MOUNTORIENTATION_THREE,
 *         YRefFrame.MOUNTORIENTATION_SIX,     YRefFrame.MOUNTORIENTATION_NINE)
 *         corresponding to the orientation of the "X" arrow on the device,
 *         as on a clock dial seen from an observer in the center of the box.
 *         On the bottom face, the 12H orientation points to the front, while
 *         on the top face, the 12H orientation points to the rear.
 *
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_mountPosition:(Y_MOUNTPOSITION)position :(Y_MOUNTORIENTATION)orientation
{
    int mixedPos;
    mixedPos = (position << 2) + orientation;
    return [self set_mountPos:mixedPos];
}

/**
 * Returns the 3D sensor calibration state (Yocto-3D-V2 only). This function returns
 * an integer representing the calibration state of the 3 inertial sensors of
 * the BNO055 chip, found in the Yocto-3D-V2. Hundredths show the calibration state
 * of the accelerometer, tenths show the calibration state of the magnetometer while
 * units show the calibration state of the gyroscope. For each sensor, the value 0
 * means no calibration and the value 3 means full calibration.
 *
 * @return an integer representing the calibration state of Yocto-3D-V2:
 *         333 when fully calibrated, 0 when not calibrated at all.
 *
 * On failure, throws an exception or returns a negative error code.
 * For the Yocto-3D (V1), this function always return -3 (unsupported function).
 */
-(int) get_calibrationState
{
    NSString* calibParam;
    NSMutableArray* iCalib = [NSMutableArray array];
    int caltyp;
    int res;

    calibParam = [self get_calibrationParam];
    iCalib = [YAPI _decodeFloats:calibParam];
    caltyp = (([[iCalib objectAtIndex:0] intValue]) / 1000);
    if (caltyp != 33) {
        return YAPI_NOT_SUPPORTED;
    }
    res = (([[iCalib objectAtIndex:1] intValue]) / 1000);
    return res;
}

/**
 * Returns estimated quality of the orientation (Yocto-3D-V2 only). This function returns
 * an integer between 0 and 3 representing the degree of confidence of the position
 * estimate. When the value is 3, the estimation is reliable. Below 3, one should
 * expect sudden corrections, in particular for heading (compass function).
 * The most frequent causes for values below 3 are magnetic interferences, and
 * accelerations or rotations beyond the sensor range.
 *
 * @return an integer between 0 and 3 (3 when the measure is reliable)
 *
 * On failure, throws an exception or returns a negative error code.
 * For the Yocto-3D (V1), this function always return -3 (unsupported function).
 */
-(int) get_measureQuality
{
    NSString* calibParam;
    NSMutableArray* iCalib = [NSMutableArray array];
    int caltyp;
    int res;

    calibParam = [self get_calibrationParam];
    iCalib = [YAPI _decodeFloats:calibParam];
    caltyp = (([[iCalib objectAtIndex:0] intValue]) / 1000);
    if (caltyp != 33) {
        return YAPI_NOT_SUPPORTED;
    }
    res = (([[iCalib objectAtIndex:2] intValue]) / 1000);
    return res;
}

-(int) _calibSort:(int)start :(int)stopidx
{
    int idx;
    int changed;
    double a;
    double b;
    double xa;
    double xb;
    // bubble sort is good since we will re-sort again after offset adjustment
    changed = 1;
    while (changed > 0) {
        changed = 0;
        a = [[_calibDataAcc objectAtIndex:start] doubleValue];
        idx = start + 1;
        while (idx < stopidx) {
            b = [[_calibDataAcc objectAtIndex:idx] doubleValue];
            if (a > b) {
                [_calibDataAcc replaceObjectAtIndex:idx-1 withObject:[NSNumber numberWithDouble:b]];
                [_calibDataAcc replaceObjectAtIndex:idx withObject:[NSNumber numberWithDouble:a]];
                xa = [[_calibDataAccX objectAtIndex:idx-1] doubleValue];
                xb = [[_calibDataAccX objectAtIndex:idx] doubleValue];
                [_calibDataAccX replaceObjectAtIndex:idx-1 withObject:[NSNumber numberWithDouble:xb]];
                [_calibDataAccX replaceObjectAtIndex:idx withObject:[NSNumber numberWithDouble:xa]];
                xa = [[_calibDataAccY objectAtIndex:idx-1] doubleValue];
                xb = [[_calibDataAccY objectAtIndex:idx] doubleValue];
                [_calibDataAccY replaceObjectAtIndex:idx-1 withObject:[NSNumber numberWithDouble:xb]];
                [_calibDataAccY replaceObjectAtIndex:idx withObject:[NSNumber numberWithDouble:xa]];
                xa = [[_calibDataAccZ objectAtIndex:idx-1] doubleValue];
                xb = [[_calibDataAccZ objectAtIndex:idx] doubleValue];
                [_calibDataAccZ replaceObjectAtIndex:idx-1 withObject:[NSNumber numberWithDouble:xb]];
                [_calibDataAccZ replaceObjectAtIndex:idx withObject:[NSNumber numberWithDouble:xa]];
                changed = changed + 1;
            } else {
                a = b;
            }
            idx = idx + 1;
        }
    }
    return 0;
}

/**
 * Initiates the sensors tridimensional calibration process.
 * This calibration is used at low level for inertial position estimation
 * and to enhance the precision of the tilt sensors.
 *
 * After calling this method, the device should be moved according to the
 * instructions provided by method get_3DCalibrationHint,
 * and more3DCalibration should be invoked about 5 times per second.
 * The calibration procedure is completed when the method
 * get_3DCalibrationProgress returns 100. At this point,
 * the computed calibration parameters can be applied using method
 * save3DCalibration. The calibration process can be cancelled
 * at any time using method cancel3DCalibration.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) start3DCalibration
{
    if (!([self isOnline])) {
        return YAPI_DEVICE_NOT_FOUND;
    }
    if (_calibStage != 0) {
        [self cancel3DCalibration];
    }
    _calibSavedParams = [self get_calibrationParam];
    _calibV2 = ([_calibSavedParams intValue] == 33);
    [self set_calibrationParam:@"0"];
    _calibCount = 50;
    _calibStage = 1;
    _calibStageHint = @"Set down the device on a steady horizontal surface";
    _calibStageProgress = 0;
    _calibProgress = 1;
    _calibInternalPos = 0;
    _calibPrevTick = (int) (([YAPI GetTickCount]) & 0x7FFFFFFF);
    [_calibOrient removeAllObjects];
    [_calibDataAccX removeAllObjects];
    [_calibDataAccY removeAllObjects];
    [_calibDataAccZ removeAllObjects];
    [_calibDataAcc removeAllObjects];
    return YAPI_SUCCESS;
}

/**
 * Continues the sensors tridimensional calibration process previously
 * initiated using method start3DCalibration.
 * This method should be called approximately 5 times per second, while
 * positioning the device according to the instructions provided by method
 * get_3DCalibrationHint. Note that the instructions change during
 * the calibration process.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) more3DCalibration
{
    if (_calibV2) {
        return [self more3DCalibrationV2];
    }
    return [self more3DCalibrationV1];
}

-(int) more3DCalibrationV1
{
    int currTick;
    NSMutableData* jsonData;
    double xVal;
    double yVal;
    double zVal;
    double xSq;
    double ySq;
    double zSq;
    double norm;
    int orient;
    int idx;
    int intpos;
    int err;
    // make sure calibration has been started
    if (_calibStage == 0) {
        return YAPI_INVALID_ARGUMENT;
    }
    if (_calibProgress == 100) {
        return YAPI_SUCCESS;
    }
    // make sure we leave at least 160 ms between samples
    currTick =  (int) (([YAPI GetTickCount]) & 0x7FFFFFFF);
    if (((currTick - _calibPrevTick) & 0x7FFFFFFF) < 160) {
        return YAPI_SUCCESS;
    }
    // load current accelerometer values, make sure we are on a straight angle
    // (default timeout to 0,5 sec without reading measure when out of range)
    _calibStageHint = @"Set down the device on a steady horizontal surface";
    _calibPrevTick = ((currTick + 500) & 0x7FFFFFFF);
    jsonData = [self _download:@"api/accelerometer.json"];
    xVal = [[self _json_get_key:jsonData :@"xValue"] intValue] / 65536.0;
    yVal = [[self _json_get_key:jsonData :@"yValue"] intValue] / 65536.0;
    zVal = [[self _json_get_key:jsonData :@"zValue"] intValue] / 65536.0;
    xSq = xVal * xVal;
    if (xSq >= 0.04 && xSq < 0.64) {
        return YAPI_SUCCESS;
    }
    if (xSq >= 1.44) {
        return YAPI_SUCCESS;
    }
    ySq = yVal * yVal;
    if (ySq >= 0.04 && ySq < 0.64) {
        return YAPI_SUCCESS;
    }
    if (ySq >= 1.44) {
        return YAPI_SUCCESS;
    }
    zSq = zVal * zVal;
    if (zSq >= 0.04 && zSq < 0.64) {
        return YAPI_SUCCESS;
    }
    if (zSq >= 1.44) {
        return YAPI_SUCCESS;
    }
    norm = sqrt(xSq + ySq + zSq);
    if (norm < 0.8 || norm > 1.2) {
        return YAPI_SUCCESS;
    }
    _calibPrevTick = currTick;
    // Determine the device orientation index
    orient = 0;
    if (zSq > 0.5) {
        if (zVal > 0) {
            orient = 0;
        } else {
            orient = 1;
        }
    }
    if (xSq > 0.5) {
        if (xVal > 0) {
            orient = 2;
        } else {
            orient = 3;
        }
    }
    if (ySq > 0.5) {
        if (yVal > 0) {
            orient = 4;
        } else {
            orient = 5;
        }
    }
    // Discard measures that are not in the proper orientation
    if (_calibStageProgress == 0) {
        // New stage, check that self orientation is not yet done
        idx = 0;
        err = 0;
        while (idx + 1 < _calibStage) {
            if ([[_calibOrient objectAtIndex:idx] intValue] == orient) {
                err = 1;
            }
            idx = idx + 1;
        }
        if (err != 0) {
            _calibStageHint = @"Turn the device on another face";
            return YAPI_SUCCESS;
        }
        [_calibOrient addObject:[NSNumber numberWithLong:orient]];
    } else {
        // Make sure device is not turned before stage is completed
        if (orient != [[_calibOrient objectAtIndex:_calibStage-1] intValue]) {
            _calibStageHint = @"Not yet done, please move back to the previous face";
            return YAPI_SUCCESS;
        }
    }
    // Save measure
    _calibStageHint = @"calibrating...";
    [_calibDataAccX addObject:[NSNumber numberWithDouble:xVal]];
    [_calibDataAccY addObject:[NSNumber numberWithDouble:yVal]];
    [_calibDataAccZ addObject:[NSNumber numberWithDouble:zVal]];
    [_calibDataAcc addObject:[NSNumber numberWithDouble:norm]];
    _calibInternalPos = _calibInternalPos + 1;
    _calibProgress = 1 + 16 * (_calibStage - 1) + ((16 * _calibInternalPos) / _calibCount);
    if (_calibInternalPos < _calibCount) {
        _calibStageProgress = 1 + ((99 * _calibInternalPos) / _calibCount);
        return YAPI_SUCCESS;
    }
    // Stage done, compute preliminary result
    intpos = (_calibStage - 1) * _calibCount;
    [self _calibSort:intpos :intpos + _calibCount];
    intpos = intpos + (_calibCount / 2);
    _calibLogMsg = [NSString stringWithFormat:@"Stage %d: median is %d,%d,%d",_calibStage,(int) floor(1000*[[_calibDataAccX objectAtIndex:intpos] doubleValue]+0.5),(int) floor(1000*[[_calibDataAccY objectAtIndex:intpos] doubleValue]+0.5),(int) floor(1000*[[_calibDataAccZ objectAtIndex:intpos] doubleValue]+0.5)];
    // move to next stage
    _calibStage = _calibStage + 1;
    if (_calibStage < 7) {
        _calibStageHint = @"Turn the device on another face";
        _calibPrevTick = ((currTick + 500) & 0x7FFFFFFF);
        _calibStageProgress = 0;
        _calibInternalPos = 0;
        return YAPI_SUCCESS;
    }
    // Data collection completed, compute accelerometer shift
    xVal = 0;
    yVal = 0;
    zVal = 0;
    idx = 0;
    while (idx < 6) {
        intpos = idx * _calibCount + (_calibCount / 2);
        orient = [[_calibOrient objectAtIndex:idx] intValue];
        if (orient == 0 || orient == 1) {
            zVal = zVal + [[_calibDataAccZ objectAtIndex:intpos] doubleValue];
        }
        if (orient == 2 || orient == 3) {
            xVal = xVal + [[_calibDataAccX objectAtIndex:intpos] doubleValue];
        }
        if (orient == 4 || orient == 5) {
            yVal = yVal + [[_calibDataAccY objectAtIndex:intpos] doubleValue];
        }
        idx = idx + 1;
    }
    _calibAccXOfs = xVal / 2.0;
    _calibAccYOfs = yVal / 2.0;
    _calibAccZOfs = zVal / 2.0;
    // Recompute all norms, taking into account the computed shift, and re-sort
    intpos = 0;
    while (intpos < (int)[_calibDataAcc count]) {
        xVal = [[_calibDataAccX objectAtIndex:intpos] doubleValue] - _calibAccXOfs;
        yVal = [[_calibDataAccY objectAtIndex:intpos] doubleValue] - _calibAccYOfs;
        zVal = [[_calibDataAccZ objectAtIndex:intpos] doubleValue] - _calibAccZOfs;
        norm = sqrt(xVal * xVal + yVal * yVal + zVal * zVal);
        [_calibDataAcc replaceObjectAtIndex:intpos withObject:[NSNumber numberWithDouble:norm]];
        intpos = intpos + 1;
    }
    idx = 0;
    while (idx < 6) {
        intpos = idx * _calibCount;
        [self _calibSort:intpos :intpos + _calibCount];
        idx = idx + 1;
    }
    // Compute the scaling factor for each axis
    xVal = 0;
    yVal = 0;
    zVal = 0;
    idx = 0;
    while (idx < 6) {
        intpos = idx * _calibCount + (_calibCount / 2);
        orient = [[_calibOrient objectAtIndex:idx] intValue];
        if (orient == 0 || orient == 1) {
            zVal = zVal + [[_calibDataAcc objectAtIndex:intpos] doubleValue];
        }
        if (orient == 2 || orient == 3) {
            xVal = xVal + [[_calibDataAcc objectAtIndex:intpos] doubleValue];
        }
        if (orient == 4 || orient == 5) {
            yVal = yVal + [[_calibDataAcc objectAtIndex:intpos] doubleValue];
        }
        idx = idx + 1;
    }
    _calibAccXScale = xVal / 2.0;
    _calibAccYScale = yVal / 2.0;
    _calibAccZScale = zVal / 2.0;
    // Report completion
    _calibProgress = 100;
    _calibStageHint = @"Calibration data ready for saving";
    return YAPI_SUCCESS;
}

-(int) more3DCalibrationV2
{
    int currTick;
    NSMutableData* calibParam;
    NSMutableArray* iCalib = [NSMutableArray array];
    int cal3;
    int calAcc;
    int calMag;
    int calGyr;
    // make sure calibration has been started
    if (_calibStage == 0) {
        return YAPI_INVALID_ARGUMENT;
    }
    if (_calibProgress == 100) {
        return YAPI_SUCCESS;
    }
    // make sure we don't start before previous calibration is cleared
    if (_calibStage == 1) {
        currTick = (int) (([YAPI GetTickCount]) & 0x7FFFFFFF);
        currTick = ((currTick - _calibPrevTick) & 0x7FFFFFFF);
        if (currTick < 1600) {
            _calibStageHint = @"Set down the device on a steady horizontal surface";
            _calibStageProgress = (currTick / 40);
            _calibProgress = 1;
            return YAPI_SUCCESS;
        }
    }

    calibParam = [self _download:@"api/refFrame/calibrationParam.txt"];
    iCalib = [YAPI _decodeFloats:ARC_sendAutorelease([[NSString alloc] initWithData:calibParam encoding:NSISOLatin1StringEncoding])];
    cal3 = (([[iCalib objectAtIndex:1] intValue]) / 1000);
    calAcc = (cal3 / 100);
    calMag = (cal3 / 10) - 10*calAcc;
    calGyr = ((cal3) % (10));
    if (calGyr < 3) {
        _calibStageHint = @"Set down the device on a steady horizontal surface";
        _calibStageProgress = 40 + calGyr*20;
        _calibProgress = 4 + calGyr*2;
    } else {
        _calibStage = 2;
        if (calMag < 3) {
            _calibStageHint = @"Slowly draw '8' shapes along the 3 axis";
            _calibStageProgress = 1 + calMag*33;
            _calibProgress = 10 + calMag*5;
        } else {
            _calibStage = 3;
            if (calAcc < 3) {
                _calibStageHint = @"Slowly turn the device, stopping at each 90 degrees";
                _calibStageProgress = 1 + calAcc*33;
                _calibProgress = 25 + calAcc*25;
            } else {
                _calibStageProgress = 99;
                _calibProgress = 100;
            }
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Returns instructions to proceed to the tridimensional calibration initiated with
 * method start3DCalibration.
 *
 * @return a character string.
 */
-(NSString*) get_3DCalibrationHint
{
    return _calibStageHint;
}

/**
 * Returns the global process indicator for the tridimensional calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer between 0 (not started) and 100 (stage completed).
 */
-(int) get_3DCalibrationProgress
{
    return _calibProgress;
}

/**
 * Returns index of the current stage of the calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer, growing each time a calibration stage is completed.
 */
-(int) get_3DCalibrationStage
{
    return _calibStage;
}

/**
 * Returns the process indicator for the current stage of the calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer between 0 (not started) and 100 (stage completed).
 */
-(int) get_3DCalibrationStageProgress
{
    return _calibStageProgress;
}

/**
 * Returns the latest log message from the calibration process.
 * When no new message is available, returns an empty string.
 *
 * @return a character string.
 */
-(NSString*) get_3DCalibrationLogMsg
{
    NSString* msg;
    msg = _calibLogMsg;
    _calibLogMsg = @"";
    return msg;
}

/**
 * Applies the sensors tridimensional calibration parameters that have just been computed.
 * Remember to call the saveToFlash()  method of the module if the changes
 * must be kept when the device is restarted.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) save3DCalibration
{
    if (_calibV2) {
        return [self save3DCalibrationV2];
    }
    return [self save3DCalibrationV1];
}

-(int) save3DCalibrationV1
{
    int shiftX;
    int shiftY;
    int shiftZ;
    int scaleExp;
    int scaleX;
    int scaleY;
    int scaleZ;
    int scaleLo;
    int scaleHi;
    NSString* newcalib;
    if (_calibProgress != 100) {
        return YAPI_INVALID_ARGUMENT;
    }
    // Compute integer values (correction unit is 732ug/count)
    shiftX = -(int) floor(_calibAccXOfs / 0.000732+0.5);
    if (shiftX < 0) {
        shiftX = shiftX + 65536;
    }
    shiftY = -(int) floor(_calibAccYOfs / 0.000732+0.5);
    if (shiftY < 0) {
        shiftY = shiftY + 65536;
    }
    shiftZ = -(int) floor(_calibAccZOfs / 0.000732+0.5);
    if (shiftZ < 0) {
        shiftZ = shiftZ + 65536;
    }
    scaleX = (int) floor(2048.0 / _calibAccXScale+0.5) - 2048;
    scaleY = (int) floor(2048.0 / _calibAccYScale+0.5) - 2048;
    scaleZ = (int) floor(2048.0 / _calibAccZScale+0.5) - 2048;
    if (scaleX < -2048 || scaleX >= 2048 || scaleY < -2048 || scaleY >= 2048 || scaleZ < -2048 || scaleZ >= 2048) {
        scaleExp = 3;
    } else {
        if (scaleX < -1024 || scaleX >= 1024 || scaleY < -1024 || scaleY >= 1024 || scaleZ < -1024 || scaleZ >= 1024) {
            scaleExp = 2;
        } else {
            if (scaleX < -512 || scaleX >= 512 || scaleY < -512 || scaleY >= 512 || scaleZ < -512 || scaleZ >= 512) {
                scaleExp = 1;
            } else {
                scaleExp = 0;
            }
        }
    }
    if (scaleExp > 0) {
        scaleX = (scaleX >> scaleExp);
        scaleY = (scaleY >> scaleExp);
        scaleZ = (scaleZ >> scaleExp);
    }
    if (scaleX < 0) {
        scaleX = scaleX + 1024;
    }
    if (scaleY < 0) {
        scaleY = scaleY + 1024;
    }
    if (scaleZ < 0) {
        scaleZ = scaleZ + 1024;
    }
    scaleLo = ((scaleY & 15) << 12) + (scaleX << 2) + scaleExp;
    scaleHi = (scaleZ << 6) + (scaleY >> 4);
    // Save calibration parameters
    newcalib = [NSString stringWithFormat:@"5,%d,%d,%d,%d,%d",shiftX,shiftY,shiftZ,scaleLo,scaleHi];
    _calibStage = 0;
    return [self set_calibrationParam:newcalib];
}

-(int) save3DCalibrationV2
{
    return [self set_calibrationParam:@"5,5,5,5,5,5"];
}

/**
 * Aborts the sensors tridimensional calibration process et restores normal settings.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) cancel3DCalibration
{
    if (_calibStage == 0) {
        return YAPI_SUCCESS;
    }

    _calibStage = 0;
    return [self set_calibrationParam:_calibSavedParams];
}


-(YRefFrame*)   nextRefFrame
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YRefFrame FindRefFrame:hwid];
}

+(YRefFrame *) FirstRefFrame
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"RefFrame":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRefFrame FindRefFrame:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YRefFrame public methods implementation)
@end

//--- (YRefFrame functions)

YRefFrame *yFindRefFrame(NSString* func)
{
    return [YRefFrame FindRefFrame:func];
}

YRefFrame *yFirstRefFrame(void)
{
    return [YRefFrame FirstRefFrame];
}

//--- (end of YRefFrame functions)

