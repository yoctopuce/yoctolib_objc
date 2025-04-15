/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindColorSensor(), the high-level API for ColorSensor functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN

@class YColorSensor;

//--- (YColorSensor globals)
typedef void (*YColorSensorValueCallback)(YColorSensor *func, NSString *functionValue);
#ifndef _Y_ESTIMATIONMODEL_ENUM
#define _Y_ESTIMATIONMODEL_ENUM
typedef enum {
    Y_ESTIMATIONMODEL_REFLECTION = 0,
    Y_ESTIMATIONMODEL_EMISSION = 1,
    Y_ESTIMATIONMODEL_INVALID = -1,
} Y_ESTIMATIONMODEL_enum;
#endif
#ifndef _Y_WORKINGMODE_ENUM
#define _Y_WORKINGMODE_ENUM
typedef enum {
    Y_WORKINGMODE_AUTO = 0,
    Y_WORKINGMODE_EXPERT = 1,
    Y_WORKINGMODE_INVALID = -1,
} Y_WORKINGMODE_enum;
#endif
#ifndef _Y_NEARSIMPLECOLORINDEX_ENUM
#define _Y_NEARSIMPLECOLORINDEX_ENUM
typedef enum {
    Y_NEARSIMPLECOLORINDEX_BROWN = 0,
    Y_NEARSIMPLECOLORINDEX_RED = 1,
    Y_NEARSIMPLECOLORINDEX_ORANGE = 2,
    Y_NEARSIMPLECOLORINDEX_YELLOW = 3,
    Y_NEARSIMPLECOLORINDEX_WHITE = 4,
    Y_NEARSIMPLECOLORINDEX_GRAY = 5,
    Y_NEARSIMPLECOLORINDEX_BLACK = 6,
    Y_NEARSIMPLECOLORINDEX_GREEN = 7,
    Y_NEARSIMPLECOLORINDEX_BLUE = 8,
    Y_NEARSIMPLECOLORINDEX_PURPLE = 9,
    Y_NEARSIMPLECOLORINDEX_PINK = 10,
    Y_NEARSIMPLECOLORINDEX_INVALID = -1,
} Y_NEARSIMPLECOLORINDEX_enum;
#endif
#define Y_LEDCURRENT_INVALID            YAPI_INVALID_UINT
#define Y_LEDCALIBRATION_INVALID        YAPI_INVALID_UINT
#define Y_INTEGRATIONTIME_INVALID       YAPI_INVALID_UINT
#define Y_GAIN_INVALID                  YAPI_INVALID_UINT
#define Y_SATURATION_INVALID            YAPI_INVALID_UINT
#define Y_ESTIMATEDRGB_INVALID          YAPI_INVALID_UINT
#define Y_ESTIMATEDHSL_INVALID          YAPI_INVALID_UINT
#define Y_ESTIMATEDXYZ_INVALID          YAPI_INVALID_STRING
#define Y_ESTIMATEDOKLAB_INVALID        YAPI_INVALID_STRING
#define Y_NEARRAL1_INVALID              YAPI_INVALID_STRING
#define Y_NEARRAL2_INVALID              YAPI_INVALID_STRING
#define Y_NEARRAL3_INVALID              YAPI_INVALID_STRING
#define Y_NEARHTMLCOLOR_INVALID         YAPI_INVALID_STRING
#define Y_NEARSIMPLECOLOR_INVALID       YAPI_INVALID_STRING
//--- (end of YColorSensor globals)

//--- (YColorSensor class start)
/**
 * YColorSensor Class: color sensor control interface
 *
 * The YColorSensor class allows you to read and configure Yoctopuce color sensors.
 */
@interface YColorSensor : YFunction
//--- (end of YColorSensor class start)
{
@protected
//--- (YColorSensor attributes declaration)
    Y_ESTIMATIONMODEL_enum _estimationModel;
    Y_WORKINGMODE_enum _workingMode;
    int             _ledCurrent;
    int             _ledCalibration;
    int             _integrationTime;
    int             _gain;
    int             _saturation;
    int             _estimatedRGB;
    int             _estimatedHSL;
    NSString*       _estimatedXYZ;
    NSString*       _estimatedOkLab;
    NSString*       _nearRAL1;
    NSString*       _nearRAL2;
    NSString*       _nearRAL3;
    NSString*       _nearHTMLColor;
    Y_NEARSIMPLECOLORINDEX_enum _nearSimpleColorIndex;
    NSString*       _nearSimpleColor;
    YColorSensorValueCallback _valueCallbackColorSensor;
//--- (end of YColorSensor attributes declaration)
}
// Constructor is protected, use yFindColorSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YColorSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YColorSensor private methods declaration)
//--- (YColorSensor yapiwrapper declaration)
//--- (end of YColorSensor yapiwrapper declaration)
//--- (YColorSensor public methods declaration)
/**
 * Returns the predictive model used for color estimation (reflective or emissive).
 *
 * @return either YColorSensor.ESTIMATIONMODEL_REFLECTION or YColorSensor.ESTIMATIONMODEL_EMISSION,
 * according to the predictive model used for color estimation (reflective or emissive)
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATIONMODEL_INVALID.
 */
-(Y_ESTIMATIONMODEL_enum)     get_estimationModel;


-(Y_ESTIMATIONMODEL_enum) estimationModel;
/**
 * Changes the mpredictive model to be used for color estimation (reflective or emissive).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YColorSensor.ESTIMATIONMODEL_REFLECTION or
 * YColorSensor.ESTIMATIONMODEL_EMISSION, according to the mpredictive model to be used for color
 * estimation (reflective or emissive)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_estimationModel:(Y_ESTIMATIONMODEL_enum) newval;
-(int)     setEstimationModel:(Y_ESTIMATIONMODEL_enum) newval;

/**
 * Returns the sensor working mode.
 * In Auto mode, sensor parameters are automatically set based on the selected estimation model.
 * In Expert mode, sensor parameters such as gain and integration time are configured manually.
 *
 * @return either YColorSensor.WORKINGMODE_AUTO or YColorSensor.WORKINGMODE_EXPERT, according to the
 * sensor working mode
 *
 * On failure, throws an exception or returns YColorSensor.WORKINGMODE_INVALID.
 */
-(Y_WORKINGMODE_enum)     get_workingMode;


-(Y_WORKINGMODE_enum) workingMode;
/**
 * Changes the sensor working mode.
 * In Auto mode, sensor parameters are automatically set based on the selected estimation model.
 * In Expert mode, sensor parameters such as gain and integration time are configured manually.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YColorSensor.WORKINGMODE_AUTO or YColorSensor.WORKINGMODE_EXPERT, according
 * to the sensor working mode
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_workingMode:(Y_WORKINGMODE_enum) newval;
-(int)     setWorkingMode:(Y_WORKINGMODE_enum) newval;

/**
 * Returns the amount of current sent to the illumination LEDs, for reflection measurements.
 * The value is an integer ranging from 0 (LEDs off) to 254 (LEDs at maximum intensity).
 *
 * @return an integer corresponding to the amount of current sent to the illumination LEDs, for
 * reflection measurements
 *
 * On failure, throws an exception or returns YColorSensor.LEDCURRENT_INVALID.
 */
-(int)     get_ledCurrent;


-(int) ledCurrent;
/**
 * Changes the amount of current sent to the illumination LEDs, for reflection measurements.
 * The value is an integer ranging from 0 (LEDs off) to 254 (LEDs at maximum intensity).
 *
 * @param newval : an integer corresponding to the amount of current sent to the illumination LEDs,
 * for reflection measurements
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_ledCurrent:(int) newval;
-(int)     setLedCurrent:(int) newval;

/**
 * Returns the current sent to the illumination LEDs during the last calibration.
 *
 * @return an integer corresponding to the current sent to the illumination LEDs during the last calibration
 *
 * On failure, throws an exception or returns YColorSensor.LEDCALIBRATION_INVALID.
 */
-(int)     get_ledCalibration;


-(int) ledCalibration;
/**
 * Remember the LED current sent to the illumination LEDs during a calibration.
 * Thanks to this, the device will be able to use the same current during measurements.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_ledCalibration:(int) newval;
-(int)     setLedCalibration:(int) newval;

/**
 * Returns the current integration time for spectral measurement, in milliseconds.
 * A longer integration time increase the sensitivity for low light conditions,
 * but reduces the measurement rate and may lead to saturation for lighter colors.
 *
 * @return an integer corresponding to the current integration time for spectral measurement, in milliseconds
 *
 * On failure, throws an exception or returns YColorSensor.INTEGRATIONTIME_INVALID.
 */
-(int)     get_integrationTime;


-(int) integrationTime;
/**
 * Changes the integration time for spectral measurement, in milliseconds.
 * A longer integration time increase the sensitivity for low light conditions,
 * but reduces the measurement rate and may lead to saturation for lighter colors.
 * This method can only be used when the sensor is configured in expert mode;
 * when running in auto mode, the change will be ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the integration time for spectral measurement, in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_integrationTime:(int) newval;
-(int)     setIntegrationTime:(int) newval;

/**
 * Returns the current spectral channel detector gain exponent.
 * For a value n ranging from 0 to 12, the applied gain is 2^(n-1).
 * 0 corresponds to a gain of 0.5, and 12 corresponds to a gain of 2048.
 *
 * @return an integer corresponding to the current spectral channel detector gain exponent
 *
 * On failure, throws an exception or returns YColorSensor.GAIN_INVALID.
 */
-(int)     get_gain;


-(int) gain;
/**
 * Changes the spectral channel detector gain exponent.
 * For a value n ranging from 0 to 12, the applied gain is 2^(n-1).
 * 0 corresponds to a gain of 0.5, and 12 corresponds to a gain of 2048.
 * This method can only be used when the sensor is configured in expert mode;
 * when running in auto mode, the change will be ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the spectral channel detector gain exponent
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_gain:(int) newval;
-(int)     setGain:(int) newval;

/**
 * Returns the current saturation state of the sensor, as an integer.
 * Bit 0 indicates saturation of the analog sensor, which can only
 * be corrected by reducing the gain parameters or the luminosity.
 * Bit 1 indicates saturation of the digital interface, which can
 * be corrected by reducing the integration time or the gain.
 *
 * @return an integer corresponding to the current saturation state of the sensor, as an integer
 *
 * On failure, throws an exception or returns YColorSensor.SATURATION_INVALID.
 */
-(int)     get_saturation;


-(int) saturation;
/**
 * Returns the estimated color in RGB color model (0xRRGGBB).
 * The RGB color model describes each color using a combination of 3 components:
 * - Red (R): the intensity of red, in thee range 0...255
 * - Green (G): the intensity of green, in thee range 0...255
 * - Blue (B): the intensity of blue, in thee range 0...255
 *
 * @return an integer corresponding to the estimated color in RGB color model (0xRRGGBB)
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDRGB_INVALID.
 */
-(int)     get_estimatedRGB;


-(int) estimatedRGB;
/**
 * Returns the estimated color in HSL color model (0xHHSSLL).
 * The HSL color model describes each color using a combination of 3 components:
 * - Hue (H): the angle on the color wheel (0-360 degrees), mapped to 0...255
 * - Saturation (S): the intensity of the color (0-100%), mapped to 0...255
 * - Lightness (L): the brightness of the color (0-100%), mapped to 0...255
 *
 * @return an integer corresponding to the estimated color in HSL color model (0xHHSSLL)
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDHSL_INVALID.
 */
-(int)     get_estimatedHSL;


-(int) estimatedHSL;
/**
 * Returns the estimated color according to the CIE XYZ color model.
 * This color model is based on human vision and light perception, with three components
 * represented by real numbers between 0 and 1:
 * - X: corresponds to a component mixing sensitivity to red and green
 * - Y: represents luminance (perceived brightness)
 * - Z: corresponds to sensitivity to blue
 *
 * @return a string corresponding to the estimated color according to the CIE XYZ color model
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDXYZ_INVALID.
 */
-(NSString*)     get_estimatedXYZ;


-(NSString*) estimatedXYZ;
/**
 * Returns the estimated color according to the OkLab color model.
 * OkLab is a perceptual color model that aims to align human color perception with numerical
 * values, so that visually near colors are also numerically near. Colors are represented using three components:
 * - L: lightness, a real number between 0 and 1-
 * - a: color variations between green and red, between -0.5 and 0.5-
 * - b: color variations between blue and yellow, between -0.5 and 0.5.
 *
 * @return a string corresponding to the estimated color according to the OkLab color model
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDOKLAB_INVALID.
 */
-(NSString*)     get_estimatedOkLab;


-(NSString*) estimatedOkLab;
/**
 * Returns the RAL Classic color closest to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the RAL Classic color closest to the estimated color, with a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL1_INVALID.
 */
-(NSString*)     get_nearRAL1;


-(NSString*) nearRAL1;
/**
 * Returns the second closest RAL Classic color to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the second closest RAL Classic color to the estimated color, with
 * a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL2_INVALID.
 */
-(NSString*)     get_nearRAL2;


-(NSString*) nearRAL2;
/**
 * Returns the third closest RAL Classic color to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the third closest RAL Classic color to the estimated color, with
 * a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL3_INVALID.
 */
-(NSString*)     get_nearRAL3;


-(NSString*) nearRAL3;
/**
 * Returns the name of the HTML color closest to the estimated color.
 *
 * @return a string corresponding to the name of the HTML color closest to the estimated color
 *
 * On failure, throws an exception or returns YColorSensor.NEARHTMLCOLOR_INVALID.
 */
-(NSString*)     get_nearHTMLColor;


-(NSString*) nearHTMLColor;
/**
 * Returns the index of the basic color typically used to refer to the estimated color (enumerated value).
 * The list of basic colors recognized is:
 * - 0 - Brown
 * - 1 - Red
 * - 2 - Orange
 * - 3 - Yellow
 * - 4 - White
 * - 5 - Gray
 * - 6 - Black
 * - 7 - Green
 * - 8 - Blue
 * - 9 - Purple
 * - 10 - Pink
 *
 * @return a value among YColorSensor.NEARSIMPLECOLORINDEX_BROWN,
 * YColorSensor.NEARSIMPLECOLORINDEX_RED, YColorSensor.NEARSIMPLECOLORINDEX_ORANGE,
 * YColorSensor.NEARSIMPLECOLORINDEX_YELLOW, YColorSensor.NEARSIMPLECOLORINDEX_WHITE,
 * YColorSensor.NEARSIMPLECOLORINDEX_GRAY, YColorSensor.NEARSIMPLECOLORINDEX_BLACK,
 * YColorSensor.NEARSIMPLECOLORINDEX_GREEN, YColorSensor.NEARSIMPLECOLORINDEX_BLUE,
 * YColorSensor.NEARSIMPLECOLORINDEX_PURPLE and YColorSensor.NEARSIMPLECOLORINDEX_PINK corresponding
 * to the index of the basic color typically used to refer to the estimated color (enumerated value)
 *
 * On failure, throws an exception or returns YColorSensor.NEARSIMPLECOLORINDEX_INVALID.
 */
-(Y_NEARSIMPLECOLORINDEX_enum)     get_nearSimpleColorIndex;


-(Y_NEARSIMPLECOLORINDEX_enum) nearSimpleColorIndex;
/**
 * Returns the name of the basic color typically used to refer to the estimated color.
 *
 * @return a string corresponding to the name of the basic color typically used to refer to the estimated color
 *
 * On failure, throws an exception or returns YColorSensor.NEARSIMPLECOLOR_INVALID.
 */
-(NSString*)     get_nearSimpleColor;


-(NSString*) nearSimpleColor;
/**
 * Retrieves a color sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the color sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorSensor.isOnline() to test if the color sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a color sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the color sensor, for instance
 *         MyDevice.colorSensor.
 *
 * @return a YColorSensor object allowing you to drive the color sensor.
 */
+(YColorSensor*)     FindColorSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YColorSensorValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Turns on the built-in illumination LEDs using the same current as used during last calibration.
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     turnLedOn;

/**
 * Turns off the built-in illumination LEDs.
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     turnLedOff;


/**
 * Continues the enumeration of color sensors started using yFirstColorSensor().
 * Caution: You can't make any assumption about the returned color sensors order.
 * If you want to find a specific a color sensor, use ColorSensor.findColorSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YColorSensor object, corresponding to
 *         a color sensor currently online, or a nil pointer
 *         if there are no more color sensors to enumerate.
 */
-(nullable YColorSensor*) nextColorSensor
NS_SWIFT_NAME(nextColorSensor());
/**
 * Starts the enumeration of color sensors currently accessible.
 * Use the method YColorSensor.nextColorSensor() to iterate on
 * next color sensors.
 *
 * @return a pointer to a YColorSensor object, corresponding to
 *         the first color sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YColorSensor*) FirstColorSensor
NS_SWIFT_NAME(FirstColorSensor());
//--- (end of YColorSensor public methods declaration)

@end

//--- (YColorSensor functions declaration)
/**
 * Retrieves a color sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the color sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorSensor.isOnline() to test if the color sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a color sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the color sensor, for instance
 *         MyDevice.colorSensor.
 *
 * @return a YColorSensor object allowing you to drive the color sensor.
 */
YColorSensor* yFindColorSensor(NSString* func);
/**
 * Starts the enumeration of color sensors currently accessible.
 * Use the method YColorSensor.nextColorSensor() to iterate on
 * next color sensors.
 *
 * @return a pointer to a YColorSensor object, corresponding to
 *         the first color sensor currently online, or a nil pointer
 *         if there are none.
 */
YColorSensor* yFirstColorSensor(void);

//--- (end of YColorSensor functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

