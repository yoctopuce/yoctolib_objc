/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindSpectralSensor(), the high-level API for SpectralSensor functions
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

@class YSpectralSensor;

//--- (YSpectralSensor globals)
typedef void (*YSpectralSensorValueCallback)(YSpectralSensor *func, NSString *functionValue);
#define Y_LEDCURRENT_INVALID            YAPI_INVALID_INT
#define Y_RESOLUTION_INVALID            YAPI_INVALID_DOUBLE
#define Y_INTEGRATIONTIME_INVALID       YAPI_INVALID_INT
#define Y_GAIN_INVALID                  YAPI_INVALID_INT
#define Y_SATURATION_INVALID            YAPI_INVALID_UINT
#define Y_ESTIMATEDRGB_INVALID          YAPI_INVALID_UINT
#define Y_ESTIMATEDHSL_INVALID          YAPI_INVALID_UINT
#define Y_ESTIMATEDXYZ_INVALID          YAPI_INVALID_STRING
#define Y_ESTIMATEDOKLAB_INVALID        YAPI_INVALID_STRING
#define Y_ESTIMATEDRAL_INVALID          YAPI_INVALID_STRING
#define Y_LEDCURRENTATPOWERON_INVALID   YAPI_INVALID_INT
#define Y_INTEGRATIONTIMEATPOWERON_INVALID YAPI_INVALID_INT
#define Y_GAINATPOWERON_INVALID         YAPI_INVALID_INT
//--- (end of YSpectralSensor globals)

//--- (YSpectralSensor class start)
/**
 * YSpectralSensor Class: spectral sensor control interface
 *
 * The YSpectralSensor class allows you to read and configure Yoctopuce spectral sensors.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YSpectralSensor : YFunction
//--- (end of YSpectralSensor class start)
{
@protected
//--- (YSpectralSensor attributes declaration)
    int             _ledCurrent;
    double          _resolution;
    int             _integrationTime;
    int             _gain;
    int             _saturation;
    int             _estimatedRGB;
    int             _estimatedHSL;
    NSString*       _estimatedXYZ;
    NSString*       _estimatedOkLab;
    NSString*       _estimatedRAL;
    int             _ledCurrentAtPowerOn;
    int             _integrationTimeAtPowerOn;
    int             _gainAtPowerOn;
    YSpectralSensorValueCallback _valueCallbackSpectralSensor;
//--- (end of YSpectralSensor attributes declaration)
}
// Constructor is protected, use yFindSpectralSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSpectralSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSpectralSensor private methods declaration)
//--- (YSpectralSensor yapiwrapper declaration)
//--- (end of YSpectralSensor yapiwrapper declaration)
//--- (YSpectralSensor public methods declaration)
/**
 * Returns the current value of the LED.
 * This method retrieves the current flowing through the LED
 * and returns it as an integer or an object.
 *
 * @return an integer corresponding to the current value of the LED
 *
 * On failure, throws an exception or returns YSpectralSensor.LEDCURRENT_INVALID.
 */
-(int)     get_ledCurrent;


-(int) ledCurrent;
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
-(int)     set_ledCurrent:(int) newval;
-(int)     setLedCurrent:(int) newval;

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
-(int)     set_resolution:(double) newval;
-(int)     setResolution:(double) newval;

/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the measures, which is not always the same as the actual precision of the sensor.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return a floating point number corresponding to the resolution of the measured values
 *
 * On failure, throws an exception or returns YSpectralSensor.RESOLUTION_INVALID.
 */
-(double)     get_resolution;


-(double) resolution;
/**
 * Returns the current integration time.
 * This method retrieves the integration time value
 * used for data processing and returns it as an integer or an object.
 *
 * @return an integer corresponding to the current integration time
 *
 * On failure, throws an exception or returns YSpectralSensor.INTEGRATIONTIME_INVALID.
 */
-(int)     get_integrationTime;


-(int) integrationTime;
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
-(int)     set_integrationTime:(int) newval;
-(int)     setIntegrationTime:(int) newval;

/**
 * Retrieves the current gain.
 * This method updates the gain value.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns YSpectralSensor.GAIN_INVALID.
 */
-(int)     get_gain;


-(int) gain;
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
-(int)     set_gain:(int) newval;
-(int)     setGain:(int) newval;

/**
 * Returns the current saturation of the sensor.
 * This function updates the sensor's saturation value.
 *
 * @return an integer corresponding to the current saturation of the sensor
 *
 * On failure, throws an exception or returns YSpectralSensor.SATURATION_INVALID.
 */
-(int)     get_saturation;


-(int) saturation;
/**
 * Returns the estimated color in RGB format.
 * This method retrieves the estimated color values
 * and returns them as an RGB object or structure.
 *
 * @return an integer corresponding to the estimated color in RGB format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDRGB_INVALID.
 */
-(int)     get_estimatedRGB;


-(int) estimatedRGB;
/**
 * Returns the estimated color in HSL format.
 * This method retrieves the estimated color values
 * and returns them as an HSL object or structure.
 *
 * @return an integer corresponding to the estimated color in HSL format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDHSL_INVALID.
 */
-(int)     get_estimatedHSL;


-(int) estimatedHSL;
/**
 * Returns the estimated color in XYZ format.
 * This method retrieves the estimated color values
 * and returns them as an XYZ object or structure.
 *
 * @return a string corresponding to the estimated color in XYZ format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDXYZ_INVALID.
 */
-(NSString*)     get_estimatedXYZ;


-(NSString*) estimatedXYZ;
/**
 * Returns the estimated color in OkLab format.
 * This method retrieves the estimated color values
 * and returns them as an OkLab object or structure.
 *
 * @return a string corresponding to the estimated color in OkLab format
 *
 * On failure, throws an exception or returns YSpectralSensor.ESTIMATEDOKLAB_INVALID.
 */
-(NSString*)     get_estimatedOkLab;


-(NSString*) estimatedOkLab;
-(NSString*)     get_estimatedRAL;


-(NSString*) estimatedRAL;
-(int)     get_ledCurrentAtPowerOn;


-(int) ledCurrentAtPowerOn;
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
-(int)     set_ledCurrentAtPowerOn:(int) newval;
-(int)     setLedCurrentAtPowerOn:(int) newval;

/**
 * Retrieves the integration time at power-on.
 * This method updates the power-on integration time value.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns YSpectralSensor.INTEGRATIONTIMEATPOWERON_INVALID.
 */
-(int)     get_integrationTimeAtPowerOn;


-(int) integrationTimeAtPowerOn;
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
-(int)     set_integrationTimeAtPowerOn:(int) newval;
-(int)     setIntegrationTimeAtPowerOn:(int) newval;

-(int)     get_gainAtPowerOn;


-(int) gainAtPowerOn;
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
-(int)     set_gainAtPowerOn:(int) newval;
-(int)     setGainAtPowerOn:(int) newval;

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
+(YSpectralSensor*)     FindSpectralSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YSpectralSensorValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of spectral sensors started using yFirstSpectralSensor().
 * Caution: You can't make any assumption about the returned spectral sensors order.
 * If you want to find a specific a spectral sensor, use SpectralSensor.findSpectralSensor()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSpectralSensor object, corresponding to
 *         a spectral sensor currently online, or a nil pointer
 *         if there are no more spectral sensors to enumerate.
 */
-(nullable YSpectralSensor*) nextSpectralSensor
NS_SWIFT_NAME(nextSpectralSensor());
/**
 * Starts the enumeration of spectral sensors currently accessible.
 * Use the method YSpectralSensor.nextSpectralSensor() to iterate on
 * next spectral sensors.
 *
 * @return a pointer to a YSpectralSensor object, corresponding to
 *         the first spectral sensor currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YSpectralSensor*) FirstSpectralSensor
NS_SWIFT_NAME(FirstSpectralSensor());
//--- (end of YSpectralSensor public methods declaration)

@end

//--- (YSpectralSensor functions declaration)
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
YSpectralSensor* yFindSpectralSensor(NSString* func);
/**
 * Starts the enumeration of spectral sensors currently accessible.
 * Use the method YSpectralSensor.nextSpectralSensor() to iterate on
 * next spectral sensors.
 *
 * @return a pointer to a YSpectralSensor object, corresponding to
 *         the first spectral sensor currently online, or a nil pointer
 *         if there are none.
 */
YSpectralSensor* yFirstSpectralSensor(void);

//--- (end of YSpectralSensor functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

