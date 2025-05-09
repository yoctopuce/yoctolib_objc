/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for ColorSensor functions
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


#import "yocto_colorsensor.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YColorSensor
// Constructor is protected, use yFindColorSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"ColorSensor";
//--- (YColorSensor attributes initialization)
    _estimationModel = Y_ESTIMATIONMODEL_INVALID;
    _workingMode = Y_WORKINGMODE_INVALID;
    _ledCurrent = Y_LEDCURRENT_INVALID;
    _ledCalibration = Y_LEDCALIBRATION_INVALID;
    _integrationTime = Y_INTEGRATIONTIME_INVALID;
    _gain = Y_GAIN_INVALID;
    _saturation = Y_SATURATION_INVALID;
    _estimatedRGB = Y_ESTIMATEDRGB_INVALID;
    _estimatedHSL = Y_ESTIMATEDHSL_INVALID;
    _estimatedXYZ = Y_ESTIMATEDXYZ_INVALID;
    _estimatedOkLab = Y_ESTIMATEDOKLAB_INVALID;
    _nearRAL1 = Y_NEARRAL1_INVALID;
    _nearRAL2 = Y_NEARRAL2_INVALID;
    _nearRAL3 = Y_NEARRAL3_INVALID;
    _nearHTMLColor = Y_NEARHTMLCOLOR_INVALID;
    _nearSimpleColorIndex = Y_NEARSIMPLECOLORINDEX_INVALID;
    _nearSimpleColor = Y_NEARSIMPLECOLOR_INVALID;
    _valueCallbackColorSensor = NULL;
//--- (end of YColorSensor attributes initialization)
    return self;
}
//--- (YColorSensor yapiwrapper)
//--- (end of YColorSensor yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YColorSensor cleanup)
    ARC_release(_estimatedXYZ);
    _estimatedXYZ = nil;
    ARC_release(_estimatedOkLab);
    _estimatedOkLab = nil;
    ARC_release(_nearRAL1);
    _nearRAL1 = nil;
    ARC_release(_nearRAL2);
    _nearRAL2 = nil;
    ARC_release(_nearRAL3);
    _nearRAL3 = nil;
    ARC_release(_nearHTMLColor);
    _nearHTMLColor = nil;
    ARC_release(_nearSimpleColor);
    _nearSimpleColor = nil;
    ARC_dealloc(super);
//--- (end of YColorSensor cleanup)
}
//--- (YColorSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "estimationModel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _estimationModel =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "workingMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _workingMode =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "ledCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ledCurrent =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "ledCalibration")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ledCalibration =  atoi(j->token);
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
    if(!strcmp(j->token, "nearRAL1")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_nearRAL1);
        _nearRAL1 =  [self _parseString:j];
        ARC_retain(_nearRAL1);
        return 1;
    }
    if(!strcmp(j->token, "nearRAL2")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_nearRAL2);
        _nearRAL2 =  [self _parseString:j];
        ARC_retain(_nearRAL2);
        return 1;
    }
    if(!strcmp(j->token, "nearRAL3")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_nearRAL3);
        _nearRAL3 =  [self _parseString:j];
        ARC_retain(_nearRAL3);
        return 1;
    }
    if(!strcmp(j->token, "nearHTMLColor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_nearHTMLColor);
        _nearHTMLColor =  [self _parseString:j];
        ARC_retain(_nearHTMLColor);
        return 1;
    }
    if(!strcmp(j->token, "nearSimpleColorIndex")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nearSimpleColorIndex =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "nearSimpleColor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_nearSimpleColor);
        _nearSimpleColor =  [self _parseString:j];
        ARC_retain(_nearSimpleColor);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YColorSensor private methods implementation)
//--- (YColorSensor public methods implementation)
/**
 * Returns the predictive model used for color estimation (reflective or emissive).
 *
 * @return either YColorSensor.ESTIMATIONMODEL_REFLECTION or YColorSensor.ESTIMATIONMODEL_EMISSION,
 * according to the predictive model used for color estimation (reflective or emissive)
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATIONMODEL_INVALID.
 */
-(Y_ESTIMATIONMODEL_enum) get_estimationModel
{
    Y_ESTIMATIONMODEL_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ESTIMATIONMODEL_INVALID;
        }
    }
    res = _estimationModel;
    return res;
}


-(Y_ESTIMATIONMODEL_enum) estimationModel
{
    return [self get_estimationModel];
}

/**
 * Changes the predictive model to be used for color estimation (reflective or emissive).
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : either YColorSensor.ESTIMATIONMODEL_REFLECTION or
 * YColorSensor.ESTIMATIONMODEL_EMISSION, according to the predictive model to be used for color
 * estimation (reflective or emissive)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_estimationModel:(Y_ESTIMATIONMODEL_enum) newval
{
    return [self setEstimationModel:newval];
}
-(int) setEstimationModel:(Y_ESTIMATIONMODEL_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"estimationModel" :rest_val];
}
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
-(Y_WORKINGMODE_enum) get_workingMode
{
    Y_WORKINGMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WORKINGMODE_INVALID;
        }
    }
    res = _workingMode;
    return res;
}


-(Y_WORKINGMODE_enum) workingMode
{
    return [self get_workingMode];
}

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
-(int) set_workingMode:(Y_WORKINGMODE_enum) newval
{
    return [self setWorkingMode:newval];
}
-(int) setWorkingMode:(Y_WORKINGMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"workingMode" :rest_val];
}
/**
 * Returns the amount of current sent to the illumination LEDs, for reflection measures.
 * The value is an integer ranging from 0 (LEDs off) to 254 (LEDs at maximum intensity).
 *
 * @return an integer corresponding to the amount of current sent to the illumination LEDs, for reflection measures
 *
 * On failure, throws an exception or returns YColorSensor.LEDCURRENT_INVALID.
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
 * Changes the amount of current sent to the illumination LEDs, for reflection measures.
 * The value is an integer ranging from 0 (LEDs off) to 254 (LEDs at maximum intensity).
 *
 * @param newval : an integer corresponding to the amount of current sent to the illumination LEDs,
 * for reflection measures
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
 * Returns the current sent to the illumination LEDs during the latest calibration.
 *
 * @return an integer corresponding to the current sent to the illumination LEDs during the latest calibration
 *
 * On failure, throws an exception or returns YColorSensor.LEDCALIBRATION_INVALID.
 */
-(int) get_ledCalibration
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LEDCALIBRATION_INVALID;
        }
    }
    res = _ledCalibration;
    return res;
}


-(int) ledCalibration
{
    return [self get_ledCalibration];
}

/**
 * Remember the LED current sent to the illumination LEDs during a calibration.
 * Thanks to this, the device is able to use the same current when taking measures.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ledCalibration:(int) newval
{
    return [self setLedCalibration:newval];
}
-(int) setLedCalibration:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"ledCalibration" :rest_val];
}
/**
 * Returns the current integration time for spectral measure, in milliseconds.
 * A longer integration time increase the sensitivity for low light conditions,
 * but reduces the measure taking rate and may lead to saturation for lighter colors.
 *
 * @return an integer corresponding to the current integration time for spectral measure, in milliseconds
 *
 * On failure, throws an exception or returns YColorSensor.INTEGRATIONTIME_INVALID.
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
 * Changes the integration time for spectral measure, in milliseconds.
 * A longer integration time increase the sensitivity for low light conditions,
 * but reduces the measure taking rate and may lead to saturation for lighter colors.
 * This method can only be used when the sensor is configured in expert mode;
 * when running in auto mode, the change is ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the integration time for spectral measure, in milliseconds
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
 * Returns the current spectral channel detector gain exponent.
 * For a value n ranging from 0 to 12, the applied gain is 2^(n-1).
 * 0 corresponds to a gain of 0.5, and 12 corresponds to a gain of 2048.
 *
 * @return an integer corresponding to the current spectral channel detector gain exponent
 *
 * On failure, throws an exception or returns YColorSensor.GAIN_INVALID.
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
 * Changes the spectral channel detector gain exponent.
 * For a value n ranging from 0 to 12, the applied gain is 2^(n-1).
 * 0 corresponds to a gain of 0.5, and 12 corresponds to a gain of 2048.
 * This method can only be used when the sensor is configured in expert mode;
 * when running in auto mode, the change is ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the spectral channel detector gain exponent
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
 * Returns the estimated color in RGB color model (0xRRGGBB).
 * The RGB color model describes each color using a combination of 3 components:
 * - Red (R): the intensity of red, in the 0...255 range
 * - Green (G): the intensity of green, in the 0...255 range
 * - Blue (B): the intensity of blue, in the 0...255 range
 *
 * @return an integer corresponding to the estimated color in RGB color model (0xRRGGBB)
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDRGB_INVALID.
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
 * Returns the estimated color according to the OkLab color model.
 * OkLab is a perceptual color model that aims to align human color perception with numerical
 * values, so that colors that are visually near are also numerically near. Colors are represented
 * using three components:
 * - L: lightness, a real number between 0 and 1
 * - a: color variations between green and red, between -0.5 and 0.5
 * - b: color variations between blue and yellow, between -0.5 and 0.5.
 *
 * @return a string corresponding to the estimated color according to the OkLab color model
 *
 * On failure, throws an exception or returns YColorSensor.ESTIMATEDOKLAB_INVALID.
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
/**
 * Returns the RAL Classic color closest to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the RAL Classic color closest to the estimated color, with a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL1_INVALID.
 */
-(NSString*) get_nearRAL1
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARRAL1_INVALID;
        }
    }
    res = _nearRAL1;
    return res;
}


-(NSString*) nearRAL1
{
    return [self get_nearRAL1];
}
/**
 * Returns the second closest RAL Classic color to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the second closest RAL Classic color to the estimated color, with
 * a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL2_INVALID.
 */
-(NSString*) get_nearRAL2
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARRAL2_INVALID;
        }
    }
    res = _nearRAL2;
    return res;
}


-(NSString*) nearRAL2
{
    return [self get_nearRAL2];
}
/**
 * Returns the third closest RAL Classic color to the estimated color, with a similarity ratio.
 *
 * @return a string corresponding to the third closest RAL Classic color to the estimated color, with
 * a similarity ratio
 *
 * On failure, throws an exception or returns YColorSensor.NEARRAL3_INVALID.
 */
-(NSString*) get_nearRAL3
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARRAL3_INVALID;
        }
    }
    res = _nearRAL3;
    return res;
}


-(NSString*) nearRAL3
{
    return [self get_nearRAL3];
}
/**
 * Returns the name of the HTML color closest to the estimated color.
 *
 * @return a string corresponding to the name of the HTML color closest to the estimated color
 *
 * On failure, throws an exception or returns YColorSensor.NEARHTMLCOLOR_INVALID.
 */
-(NSString*) get_nearHTMLColor
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARHTMLCOLOR_INVALID;
        }
    }
    res = _nearHTMLColor;
    return res;
}


-(NSString*) nearHTMLColor
{
    return [self get_nearHTMLColor];
}
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
-(Y_NEARSIMPLECOLORINDEX_enum) get_nearSimpleColorIndex
{
    Y_NEARSIMPLECOLORINDEX_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARSIMPLECOLORINDEX_INVALID;
        }
    }
    res = _nearSimpleColorIndex;
    return res;
}


-(Y_NEARSIMPLECOLORINDEX_enum) nearSimpleColorIndex
{
    return [self get_nearSimpleColorIndex];
}
/**
 * Returns the name of the basic color typically used to refer to the estimated color.
 *
 * @return a string corresponding to the name of the basic color typically used to refer to the estimated color
 *
 * On failure, throws an exception or returns YColorSensor.NEARSIMPLECOLOR_INVALID.
 */
-(NSString*) get_nearSimpleColor
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NEARSIMPLECOLOR_INVALID;
        }
    }
    res = _nearSimpleColor;
    return res;
}


-(NSString*) nearSimpleColor
{
    return [self get_nearSimpleColor];
}
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
+(YColorSensor*) FindColorSensor:(NSString*)func
{
    YColorSensor* obj;
    obj = (YColorSensor*) [YFunction _FindFromCache:@"ColorSensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YColorSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"ColorSensor" :func :obj];
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
-(int) registerValueCallback:(YColorSensorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackColorSensor = callback;
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
    if (_valueCallbackColorSensor != NULL) {
        _valueCallbackColorSensor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Turns on the built-in illumination LEDs using the same current as used during the latest calibration.
 * On failure, throws an exception or returns a negative error code.
 */
-(int) turnLedOn
{
    return [self set_ledCurrent:[self get_ledCalibration]];
}

/**
 * Turns off the built-in illumination LEDs.
 * On failure, throws an exception or returns a negative error code.
 */
-(int) turnLedOff
{
    return [self set_ledCurrent:0];
}


-(YColorSensor*)   nextColorSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YColorSensor FindColorSensor:hwid];
}

+(YColorSensor *) FirstColorSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"ColorSensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YColorSensor FindColorSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YColorSensor public methods implementation)
@end

//--- (YColorSensor functions)

YColorSensor *yFindColorSensor(NSString* func)
{
    return [YColorSensor FindColorSensor:func];
}

YColorSensor *yFirstColorSensor(void)
{
    return [YColorSensor FirstColorSensor];
}

//--- (end of YColorSensor functions)

