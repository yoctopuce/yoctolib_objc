/*********************************************************************
 *
 * $Id: yocto_voc.h 12324 2013-08-13 15:10:31Z mvuilleu $
 *
 * Declares yFindVoc(), the high-level API for Voc functions
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

//--- (YVoc definitions)
#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_UNIT_INVALID                  [YAPI  INVALID_STRING]
#define Y_CURRENTVALUE_INVALID          (-DBL_MAX)
#define Y_LOWESTVALUE_INVALID           (-DBL_MAX)
#define Y_HIGHESTVALUE_INVALID          (-DBL_MAX)
#define Y_CURRENTRAWVALUE_INVALID       (-DBL_MAX)
#define Y_CALIBRATIONPARAM_INVALID      [YAPI  INVALID_STRING]
#define Y_RESOLUTION_INVALID            (-DBL_MAX)
//--- (end of YVoc definitions)

/**
 * YVoc Class: Voc function interface
 * 
 * The Yoctopuce application programming interface allows you to read an instant
 * measure of the sensor, as well as the minimal and maximal values observed.
 */
@interface YVoc : YFunction
{
@protected

// Attributes (function value cache)
//--- (YVoc attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    NSString*       _unit;
    double          _currentValue;
    double          _lowestValue;
    double          _highestValue;
    double          _currentRawValue;
    NSString*       _calibrationParam;
    double          _resolution;
    int             _calibrationOffset;
//--- (end of YVoc attributes)
}
//--- (YVoc declaration)
// Constructor is protected, use yFindVoc factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

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
-(void)     registerValueCallback:(YFunctionUpdateCallback) callback;   
/**
 * comment from .yc definition
 */
-(void)     set_objectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object withSelector:(SEL)selector;

//--- (end of YVoc declaration)
//--- (YVoc accessors declaration)

/**
 * Continues the enumeration of Volatile Organic Compound sensors started using yFirstVoc().
 * 
 * @return a pointer to a YVoc object, corresponding to
 *         a Volatile Organic Compound sensor currently online, or a null pointer
 *         if there are no more Volatile Organic Compound sensors to enumerate.
 */
-(YVoc*) nextVoc;
/**
 * Retrieves a Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoc.isOnline() to test if the Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the Volatile Organic Compound sensor
 * 
 * @return a YVoc object allowing you to drive the Volatile Organic Compound sensor.
 */
+(YVoc*) FindVoc:(NSString*) func;
/**
 * Starts the enumeration of Volatile Organic Compound sensors currently accessible.
 * Use the method YVoc.nextVoc() to iterate on
 * next Volatile Organic Compound sensors.
 * 
 * @return a pointer to a YVoc object, corresponding to
 *         the first Volatile Organic Compound sensor currently online, or a null pointer
 *         if there are none.
 */
+(YVoc*) FirstVoc;

/**
 * Returns the logical name of the Volatile Organic Compound sensor.
 * 
 * @return a string corresponding to the logical name of the Volatile Organic Compound sensor
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the Volatile Organic Compound sensor. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the Volatile Organic Compound sensor
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the Volatile Organic Compound sensor (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the Volatile Organic Compound sensor (no
 * more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the measuring unit for the measured value.
 * 
 * @return a string corresponding to the measuring unit for the measured value
 * 
 * On failure, throws an exception or returns Y_UNIT_INVALID.
 */
-(NSString*) get_unit;
-(NSString*) unit;

/**
 * Returns the current measured value.
 * 
 * @return a floating point number corresponding to the current measured value
 * 
 * On failure, throws an exception or returns Y_CURRENTVALUE_INVALID.
 */
-(double) get_currentValue;
-(double) currentValue;

/**
 * Changes the recorded minimal value observed.
 * 
 * @param newval : a floating point number corresponding to the recorded minimal value observed
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_lowestValue:(double) newval;
-(int)     setLowestValue:(double) newval;

/**
 * Returns the minimal value observed.
 * 
 * @return a floating point number corresponding to the minimal value observed
 * 
 * On failure, throws an exception or returns Y_LOWESTVALUE_INVALID.
 */
-(double) get_lowestValue;
-(double) lowestValue;

/**
 * Changes the recorded maximal value observed.
 * 
 * @param newval : a floating point number corresponding to the recorded maximal value observed
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_highestValue:(double) newval;
-(int)     setHighestValue:(double) newval;

/**
 * Returns the maximal value observed.
 * 
 * @return a floating point number corresponding to the maximal value observed
 * 
 * On failure, throws an exception or returns Y_HIGHESTVALUE_INVALID.
 */
-(double) get_highestValue;
-(double) highestValue;

/**
 * Returns the unrounded and uncalibrated raw value returned by the sensor.
 * 
 * @return a floating point number corresponding to the unrounded and uncalibrated raw value returned by the sensor
 * 
 * On failure, throws an exception or returns Y_CURRENTRAWVALUE_INVALID.
 */
-(double) get_currentRawValue;
-(double) currentRawValue;

-(NSString*) get_calibrationParam;
-(NSString*) calibrationParam;

-(int)     set_calibrationParam:(NSString*) newval;
-(int)     setCalibrationParam:(NSString*) newval;

/**
 * Configures error correction data points, in particular to compensate for
 * a possible perturbation of the measure caused by an enclosure. It is possible
 * to configure up to five correction points. Correction points must be provided
 * in ascending order, and be in the range of the sensor. The device will automatically
 * perform a linear interpolation of the error correction between specified
 * points. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * For more information on advanced capabilities to refine the calibration of
 * sensors, please contact support@yoctopuce.com.
 * 
 * @param rawValues : array of floating point numbers, corresponding to the raw
 *         values returned by the sensor for the correction points.
 * @param refValues : array of floating point numbers, corresponding to the corrected
 *         values for the correction points.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     calibrateFromPoints :(NSMutableArray*)rawValues :(NSMutableArray*)refValues;

-(int)     loadCalibrationPoints :(NSMutableArray*)rawValues :(NSMutableArray*)refValues;

/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the values, which is not always the same as the actual precision of the sensor.
 * 
 * @return a floating point number corresponding to the resolution of the measured values
 * 
 * On failure, throws an exception or returns Y_RESOLUTION_INVALID.
 */
-(double) get_resolution;
-(double) resolution;


//--- (end of YVoc accessors declaration)
@end

//--- (Voc functions declaration)

/**
 * Retrieves a Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVoc.isOnline() to test if the Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the Volatile Organic Compound sensor
 * 
 * @return a YVoc object allowing you to drive the Volatile Organic Compound sensor.
 */
YVoc* yFindVoc(NSString* func);
/**
 * Starts the enumeration of Volatile Organic Compound sensors currently accessible.
 * Use the method YVoc.nextVoc() to iterate on
 * next Volatile Organic Compound sensors.
 * 
 * @return a pointer to a YVoc object, corresponding to
 *         the first Volatile Organic Compound sensor currently online, or a null pointer
 *         if there are none.
 */
YVoc* yFirstVoc(void);

//--- (end of Voc functions declaration)
CF_EXTERN_C_END

