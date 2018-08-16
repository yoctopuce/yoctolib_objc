/*********************************************************************
 *
 * $Id: yocto_refframe.h 31436 2018-08-07 15:28:18Z seb $
 *
 * Declares yFindRefFrame(), the high-level API for RefFrame functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN

@class YRefFrame;

//--- (YRefFrame globals)
typedef void (*YRefFrameValueCallback)(YRefFrame *func, NSString *functionValue);
#ifndef _Y_FUSIONMODE_ENUM
#define _Y_FUSIONMODE_ENUM
typedef enum {
    Y_FUSIONMODE_NDOF = 0,
    Y_FUSIONMODE_NDOF_FMC_OFF = 1,
    Y_FUSIONMODE_M4G = 2,
    Y_FUSIONMODE_COMPASS = 3,
    Y_FUSIONMODE_IMU = 4,
    Y_FUSIONMODE_INVALID = -1,
} Y_FUSIONMODE_enum;
#endif
#ifndef _Y_Y_MOUNTPOSITION
#define _Y_Y_MOUNTPOSITION
typedef enum {
    Y_MOUNTPOSITION_BOTTOM = 0 ,
    Y_MOUNTPOSITION_TOP = 1 ,
    Y_MOUNTPOSITION_FRONT = 2 ,
    Y_MOUNTPOSITION_REAR = 3 ,
    Y_MOUNTPOSITION_RIGHT = 4 ,
    Y_MOUNTPOSITION_LEFT = 5 ,
    Y_MOUNTPOSITION_INVALID = 6
} Y_MOUNTPOSITION;

#endif
#ifndef _Y_Y_MOUNTORIENTATION
#define _Y_Y_MOUNTORIENTATION
typedef enum {
    Y_MOUNTORIENTATION_TWELVE = 0 ,
    Y_MOUNTORIENTATION_THREE = 1 ,
    Y_MOUNTORIENTATION_SIX = 2 ,
    Y_MOUNTORIENTATION_NINE = 3 ,
    Y_MOUNTORIENTATION_INVALID = 4
} Y_MOUNTORIENTATION;

#endif
#define Y_MOUNTPOS_INVALID              YAPI_INVALID_UINT
#define Y_BEARING_INVALID               YAPI_INVALID_DOUBLE
#define Y_CALIBRATIONPARAM_INVALID      YAPI_INVALID_STRING
//--- (end of YRefFrame globals)

//--- (YRefFrame class start)
/**
 * YRefFrame Class: Reference frame configuration
 *
 * This class is used to setup the base orientation of the Yocto-3D, so that
 * the orientation functions, relative to the earth surface plane, use
 * the proper reference frame. The class also implements a tridimensional
 * sensor calibration process, which can compensate for local variations
 * of standard gravity and improve the precision of the tilt sensors.
 */
@interface YRefFrame : YFunction
//--- (end of YRefFrame class start)
{
@protected
//--- (YRefFrame attributes declaration)
    int             _mountPos;
    double          _bearing;
    NSString*       _calibrationParam;
    Y_FUSIONMODE_enum _fusionMode;
    YRefFrameValueCallback _valueCallbackRefFrame;
    bool            _calibV2;
    int             _calibStage;
    NSString*       _calibStageHint;
    int             _calibStageProgress;
    int             _calibProgress;
    NSString*       _calibLogMsg;
    NSString*       _calibSavedParams;
    int             _calibCount;
    int             _calibInternalPos;
    int             _calibPrevTick;
    NSMutableArray* _calibOrient;
    NSMutableArray* _calibDataAccX;
    NSMutableArray* _calibDataAccY;
    NSMutableArray* _calibDataAccZ;
    NSMutableArray* _calibDataAcc;
    double          _calibAccXOfs;
    double          _calibAccYOfs;
    double          _calibAccZOfs;
    double          _calibAccXScale;
    double          _calibAccYScale;
    double          _calibAccZScale;
//--- (end of YRefFrame attributes declaration)
}
// Constructor is protected, use yFindRefFrame factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YRefFrame private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YRefFrame private methods declaration)
//--- (YRefFrame yapiwrapper declaration)
//--- (end of YRefFrame yapiwrapper declaration)
//--- (YRefFrame public methods declaration)
-(int)     get_mountPos;


-(int) mountPos;
-(int)     set_mountPos:(int) newval;
-(int)     setMountPos:(int) newval;

/**
 * Changes the reference bearing used by the compass. The relative bearing
 * indicated by the compass is the difference between the measured magnetic
 * heading and the reference bearing indicated here.
 *
 * For instance, if you setup as reference bearing the value of the earth
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
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bearing:(double) newval;
-(int)     setBearing:(double) newval;

/**
 * Returns the reference bearing used by the compass. The relative bearing
 * indicated by the compass is the difference between the measured magnetic
 * heading and the reference bearing indicated here.
 *
 * @return a floating point number corresponding to the reference bearing used by the compass
 *
 * On failure, throws an exception or returns Y_BEARING_INVALID.
 */
-(double)     get_bearing;


-(double) bearing;
-(NSString*)     get_calibrationParam;


-(NSString*) calibrationParam;
-(int)     set_calibrationParam:(NSString*) newval;
-(int)     setCalibrationParam:(NSString*) newval;

-(Y_FUSIONMODE_enum)     get_fusionMode;


-(Y_FUSIONMODE_enum) fusionMode;
-(int)     set_fusionMode:(Y_FUSIONMODE_enum) newval;
-(int)     setFusionMode:(Y_FUSIONMODE_enum) newval;

/**
 * Retrieves a reference frame for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
 * @param func : a string that uniquely characterizes the reference frame
 *
 * @return a YRefFrame object allowing you to drive the reference frame.
 */
+(YRefFrame*)     FindRefFrame:(NSString*)func;

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
-(int)     registerValueCallback:(YRefFrameValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Returns the installation position of the device, as configured
 * in order to define the reference frame for the compass and the
 * pitch/roll tilt sensors.
 *
 * @return a value among the Y_MOUNTPOSITION enumeration
 *         (Y_MOUNTPOSITION_BOTTOM,   Y_MOUNTPOSITION_TOP,
 *         Y_MOUNTPOSITION_FRONT,    Y_MOUNTPOSITION_RIGHT,
 *         Y_MOUNTPOSITION_REAR,     Y_MOUNTPOSITION_LEFT),
 *         corresponding to the installation in a box, on one of the six faces.
 *
 * On failure, throws an exception or returns Y_MOUNTPOSITION_INVALID.
 */
-(Y_MOUNTPOSITION)     get_mountPosition;

/**
 * Returns the installation orientation of the device, as configured
 * in order to define the reference frame for the compass and the
 * pitch/roll tilt sensors.
 *
 * @return a value among the enumeration Y_MOUNTORIENTATION
 *         (Y_MOUNTORIENTATION_TWELVE, Y_MOUNTORIENTATION_THREE,
 *         Y_MOUNTORIENTATION_SIX,     Y_MOUNTORIENTATION_NINE)
 *         corresponding to the orientation of the "X" arrow on the device,
 *         as on a clock dial seen from an observer in the center of the box.
 *         On the bottom face, the 12H orientation points to the front, while
 *         on the top face, the 12H orientation points to the rear.
 *
 * On failure, throws an exception or returns Y_MOUNTORIENTATION_INVALID.
 */
-(Y_MOUNTORIENTATION)     get_mountOrientation;

/**
 * Changes the compass and tilt sensor frame of reference. The magnetic compass
 * and the tilt sensors (pitch and roll) naturally work in the plane
 * parallel to the earth surface. In case the device is not installed upright
 * and horizontally, you must select its reference orientation (parallel to
 * the earth surface) so that the measures are made relative to this position.
 *
 * @param position : a value among the Y_MOUNTPOSITION enumeration
 *         (Y_MOUNTPOSITION_BOTTOM,   Y_MOUNTPOSITION_TOP,
 *         Y_MOUNTPOSITION_FRONT,    Y_MOUNTPOSITION_RIGHT,
 *         Y_MOUNTPOSITION_REAR,     Y_MOUNTPOSITION_LEFT),
 *         corresponding to the installation in a box, on one of the six faces.
 * @param orientation : a value among the enumeration Y_MOUNTORIENTATION
 *         (Y_MOUNTORIENTATION_TWELVE, Y_MOUNTORIENTATION_THREE,
 *         Y_MOUNTORIENTATION_SIX,     Y_MOUNTORIENTATION_NINE)
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
-(int)     set_mountPosition:(Y_MOUNTPOSITION)position :(Y_MOUNTORIENTATION)orientation;

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
-(int)     get_calibrationState;

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
-(int)     get_measureQuality;

-(int)     _calibSort:(int)start :(int)stopidx;

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
 * save3DCalibration. The calibration process can be canceled
 * at any time using method cancel3DCalibration.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     start3DCalibration;

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
-(int)     more3DCalibration;

-(int)     more3DCalibrationV1;

-(int)     more3DCalibrationV2;

/**
 * Returns instructions to proceed to the tridimensional calibration initiated with
 * method start3DCalibration.
 *
 * @return a character string.
 */
-(NSString*)     get_3DCalibrationHint;

/**
 * Returns the global process indicator for the tridimensional calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer between 0 (not started) and 100 (stage completed).
 */
-(int)     get_3DCalibrationProgress;

/**
 * Returns index of the current stage of the calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer, growing each time a calibration stage is completed.
 */
-(int)     get_3DCalibrationStage;

/**
 * Returns the process indicator for the current stage of the calibration
 * initiated with method start3DCalibration.
 *
 * @return an integer between 0 (not started) and 100 (stage completed).
 */
-(int)     get_3DCalibrationStageProgress;

/**
 * Returns the latest log message from the calibration process.
 * When no new message is available, returns an empty string.
 *
 * @return a character string.
 */
-(NSString*)     get_3DCalibrationLogMsg;

/**
 * Applies the sensors tridimensional calibration parameters that have just been computed.
 * Remember to call the saveToFlash()  method of the module if the changes
 * must be kept when the device is restarted.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     save3DCalibration;

-(int)     save3DCalibrationV1;

-(int)     save3DCalibrationV2;

/**
 * Aborts the sensors tridimensional calibration process et restores normal settings.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     cancel3DCalibration;


/**
 * Continues the enumeration of reference frames started using yFirstRefFrame().
 *
 * @return a pointer to a YRefFrame object, corresponding to
 *         a reference frame currently online, or a nil pointer
 *         if there are no more reference frames to enumerate.
 */
-(YRefFrame*) nextRefFrame;
/**
 * Starts the enumeration of reference frames currently accessible.
 * Use the method YRefFrame.nextRefFrame() to iterate on
 * next reference frames.
 *
 * @return a pointer to a YRefFrame object, corresponding to
 *         the first reference frame currently online, or a nil pointer
 *         if there are none.
 */
+(YRefFrame*) FirstRefFrame;
//--- (end of YRefFrame public methods declaration)

@end

//--- (YRefFrame functions declaration)
/**
 * Retrieves a reference frame for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
 * @param func : a string that uniquely characterizes the reference frame
 *
 * @return a YRefFrame object allowing you to drive the reference frame.
 */
YRefFrame* yFindRefFrame(NSString* func);
/**
 * Starts the enumeration of reference frames currently accessible.
 * Use the method YRefFrame.nextRefFrame() to iterate on
 * next reference frames.
 *
 * @return a pointer to a YRefFrame object, corresponding to
 *         the first reference frame currently online, or a nil pointer
 *         if there are none.
 */
YRefFrame* yFirstRefFrame(void);

//--- (end of YRefFrame functions declaration)
CF_EXTERN_C_END

