/*********************************************************************
 *
 *  $Id: yocto_soundlevel.h Fri, 23 Oct 2026 10:30:39 +0000 generated $
 *
 *  Declares yFindSoundLevel(), the high-level API for SoundLevel functions
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

@class YSoundLevel;

//--- (YSoundLevel globals)
typedef void (*YSoundLevelValueCallback)(YSoundLevel *func, NSString *functionValue);
typedef void (*YSoundLevelTimedReportCallback)(YSoundLevel *func, YMeasure *measure);
#define Y_LABEL_INVALID                 YAPI_INVALID_STRING
#define Y_INTEGRATIONTIME_INVALID       YAPI_INVALID_UINT
//--- (end of YSoundLevel globals)

//--- (YSoundLevel class start)
/**
 * YSoundLevel Class: sound pressure level meter control interface
 *
 * The YSoundLevel class allows you to read and configure Yoctopuce sound pressure level meters.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YSoundLevel : YSensor
//--- (end of YSoundLevel class start)
{
@protected
//--- (YSoundLevel attributes declaration)
    NSString*       _label;
    int             _integrationTime;
    YSoundLevelValueCallback _valueCallbackSoundLevel;
    YSoundLevelTimedReportCallback _timedReportCallbackSoundLevel;
//--- (end of YSoundLevel attributes declaration)
}
// Constructor is protected, use yFindSoundLevel factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSoundLevel private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSoundLevel private methods declaration)
//--- (YSoundLevel yapiwrapper declaration)
//--- (end of YSoundLevel yapiwrapper declaration)
//--- (YSoundLevel public methods declaration)
/**
 * Changes the measuring unit for the sound pressure level (dBA, dBC or dBZ).
 * That unit will directly determine frequency weighting to be used to compute
 * the measured value. Remember to call the saveToFlash() method of the
 * module if the modification must be kept.
 *
 * @param newval : a string corresponding to the measuring unit for the sound pressure level (dBA, dBC or dBZ)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_unit:(NSString*) newval;
-(int)     setUnit:(NSString*) newval;

/**
 * Returns the label for the sound pressure level measurement, as per
 * IEC standard 61672-1:2013.
 *
 * @return a string corresponding to the label for the sound pressure level measurement, as per
 *         IEC standard 61672-1:2013
 *
 * On failure, throws an exception or returns YSoundLevel.LABEL_INVALID.
 */
-(NSString*)     get_label;


-(NSString*) label;
/**
 * Returns the integration time in milliseconds for measuring the sound pressure level.
 *
 * @return an integer corresponding to the integration time in milliseconds for measuring the sound pressure level
 *
 * On failure, throws an exception or returns YSoundLevel.INTEGRATIONTIME_INVALID.
 */
-(int)     get_integrationTime;


-(int) integrationTime;
/**
 * Retrieves a sound pressure level meter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the sound pressure level meter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSoundLevel.isOnline() to test if the sound pressure level meter is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sound pressure level meter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the sound pressure level meter, for instance
 *         MyDevice.soundLevel1.
 *
 * @return a YSoundLevel object allowing you to drive the sound pressure level meter.
 */
+(YSoundLevel*)     FindSoundLevel:(NSString*)func;

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is then invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness,
 * remember to call one of these two functions periodically. The callback is called once juste after beeing
 * registered, passing the current advertised value  of the function, provided that it is not an empty string.
 * To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerValueCallback:(YSoundLevelValueCallback _Nullable)callback;

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
-(int)     registerTimedReportCallback:(YSoundLevelTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of sound pressure level meters started using yFirstSoundLevel().
 * Caution: You can't make any assumption about the returned sound pressure level meters order.
 * If you want to find a specific a sound pressure level meter, use SoundLevel.findSoundLevel()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSoundLevel object, corresponding to
 *         a sound pressure level meter currently online, or a nil pointer
 *         if there are no more sound pressure level meters to enumerate.
 */
-(nullable YSoundLevel*) nextSoundLevel
NS_SWIFT_NAME(nextSoundLevel());
/**
 * Starts the enumeration of sound pressure level meters currently accessible.
 * Use the method YSoundLevel.nextSoundLevel() to iterate on
 * next sound pressure level meters.
 *
 * @return a pointer to a YSoundLevel object, corresponding to
 *         the first sound pressure level meter currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YSoundLevel*) FirstSoundLevel
NS_SWIFT_NAME(FirstSoundLevel());
//--- (end of YSoundLevel public methods declaration)

@end

//--- (YSoundLevel functions declaration)
/**
 * Retrieves a sound pressure level meter for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the sound pressure level meter is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSoundLevel.isOnline() to test if the sound pressure level meter is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sound pressure level meter by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the sound pressure level meter, for instance
 *         MyDevice.soundLevel1.
 *
 * @return a YSoundLevel object allowing you to drive the sound pressure level meter.
 */
YSoundLevel* yFindSoundLevel(NSString* func);
/**
 * Starts the enumeration of sound pressure level meters currently accessible.
 * Use the method YSoundLevel.nextSoundLevel() to iterate on
 * next sound pressure level meters.
 *
 * @return a pointer to a YSoundLevel object, corresponding to
 *         the first sound pressure level meter currently online, or a nil pointer
 *         if there are none.
 */
YSoundLevel* yFirstSoundLevel(void);

//--- (end of YSoundLevel functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

