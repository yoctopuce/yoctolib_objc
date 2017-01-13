/*********************************************************************
 *
 * $Id: yocto_rangefinder.h 26329 2017-01-11 14:04:39Z mvuilleu $
 *
 * Declares yFindRangeFinder(), the high-level API for RangeFinder functions
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

@class YRangeFinder;

//--- (YRangeFinder globals)
typedef void (*YRangeFinderValueCallback)(YRangeFinder *func, NSString *functionValue);
typedef void (*YRangeFinderTimedReportCallback)(YRangeFinder *func, YMeasure *measure);
#ifndef _Y_RANGEFINDERMODE_ENUM
#define _Y_RANGEFINDERMODE_ENUM
typedef enum {
    Y_RANGEFINDERMODE_DEFAULT = 0,
    Y_RANGEFINDERMODE_LONG_RANGE = 1,
    Y_RANGEFINDERMODE_HIGH_ACCURACY = 2,
    Y_RANGEFINDERMODE_HIGH_SPEED = 3,
    Y_RANGEFINDERMODE_INVALID = -1,
} Y_RANGEFINDERMODE_enum;
#endif
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YRangeFinder globals)

//--- (YRangeFinder class start)
/**
 * YRangeFinder Class: RangeFinder function interface
 *
 * The Yoctopuce class YRangeFinder allows you to use and configure Yoctopuce range finders
 * sensors. It inherits from YSensor class the core functions to read measurements,
 * register callback functions, access to the autonomous datalogger.
 * This class adds the ability to easily perform a one-point linear calibration
 * to compensate the effect of a glass or filter placed in front of the sensor.
 */
@interface YRangeFinder : YSensor
//--- (end of YRangeFinder class start)
{
@protected
//--- (YRangeFinder attributes declaration)
    Y_RANGEFINDERMODE_enum _rangeFinderMode;
    NSString*       _command;
    YRangeFinderValueCallback _valueCallbackRangeFinder;
    YRangeFinderTimedReportCallback _timedReportCallbackRangeFinder;
//--- (end of YRangeFinder attributes declaration)
}
// Constructor is protected, use yFindRangeFinder factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YRangeFinder private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YRangeFinder private methods declaration)
//--- (YRangeFinder public methods declaration)
/**
 * Changes the measuring unit for the measured temperature. That unit is a string.
 * String value can be " or mm. Any other value will be ignored.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 * WARNING: if a specific calibration is defined for the rangeFinder function, a
 * unit system change will probably break it.
 *
 * @param newval : a string corresponding to the measuring unit for the measured temperature
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the rangefinder running mode. The rangefinder running mode
 * allows to put priority on precision, speed or maximum range.
 *
 * @return a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder running mode
 *
 * On failure, throws an exception or returns Y_RANGEFINDERMODE_INVALID.
 */
-(Y_RANGEFINDERMODE_enum)     get_rangeFinderMode;


-(Y_RANGEFINDERMODE_enum) rangeFinderMode;
/**
 * Changes the rangefinder running mode, allowing to put priority on
 * precision, speed or maximum range.
 *
 * @param newval : a value among Y_RANGEFINDERMODE_DEFAULT, Y_RANGEFINDERMODE_LONG_RANGE,
 * Y_RANGEFINDERMODE_HIGH_ACCURACY and Y_RANGEFINDERMODE_HIGH_SPEED corresponding to the rangefinder
 * running mode, allowing to put priority on
 *         precision, speed or maximum range
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_rangeFinderMode:(Y_RANGEFINDERMODE_enum) newval;
-(int)     setRangeFinderMode:(Y_RANGEFINDERMODE_enum) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a range finder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the range finder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRangeFinder.isOnline() to test if the range finder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a range finder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the range finder
 *
 * @return a YRangeFinder object allowing you to drive the range finder.
 */
+(YRangeFinder*)     FindRangeFinder:(NSString*)func;

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
-(int)     registerValueCallback:(YRangeFinderValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerTimedReportCallback:(YRangeFinderTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Triggers a sensor calibration according to the current ambient temperature. That
 * calibration process needs no physical interaction with the sensor. It is performed
 * automatically at device startup, but it is recommended to start it again when the
 * temperature delta since last calibration exceeds 8°C.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerTempCalibration;


/**
 * Continues the enumeration of range finders started using yFirstRangeFinder().
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         a range finder currently online, or a nil pointer
 *         if there are no more range finders to enumerate.
 */
-(YRangeFinder*) nextRangeFinder;
/**
 * Starts the enumeration of range finders currently accessible.
 * Use the method YRangeFinder.nextRangeFinder() to iterate on
 * next range finders.
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         the first range finder currently online, or a nil pointer
 *         if there are none.
 */
+(YRangeFinder*) FirstRangeFinder;
//--- (end of YRangeFinder public methods declaration)

@end

//--- (RangeFinder functions declaration)
/**
 * Retrieves a range finder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the range finder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRangeFinder.isOnline() to test if the range finder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a range finder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the range finder
 *
 * @return a YRangeFinder object allowing you to drive the range finder.
 */
YRangeFinder* yFindRangeFinder(NSString* func);
/**
 * Starts the enumeration of range finders currently accessible.
 * Use the method YRangeFinder.nextRangeFinder() to iterate on
 * next range finders.
 *
 * @return a pointer to a YRangeFinder object, corresponding to
 *         the first range finder currently online, or a nil pointer
 *         if there are none.
 */
YRangeFinder* yFirstRangeFinder(void);

//--- (end of RangeFinder functions declaration)
CF_EXTERN_C_END

