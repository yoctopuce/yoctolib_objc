/*********************************************************************
 *
 *  $Id: yocto_soundspectrum.h Fri, 23 Oct 2026 10:30:39 +0000 generated $
 *
 *  Declares yFindSoundSpectrum(), the high-level API for SoundSpectrum functions
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

@class YSoundSpectrum;

//--- (YSoundSpectrum globals)
typedef void (*YSoundSpectrumValueCallback)(YSoundSpectrum *func, NSString *functionValue);
#define Y_INTEGRATIONTIME_INVALID       YAPI_INVALID_UINT
#define Y_SPECTRUMDATA_INVALID          YAPI_INVALID_STRING
//--- (end of YSoundSpectrum globals)

//--- (YSoundSpectrum class start)
/**
 * YSoundSpectrum Class: sound spectrum analyzer control interface
 *
 * The YSoundSpectrum class allows you to read and configure Yoctopuce sound spectrum analyzers.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YSoundSpectrum : YFunction
//--- (end of YSoundSpectrum class start)
{
@protected
//--- (YSoundSpectrum attributes declaration)
    int             _integrationTime;
    NSString*       _spectrumData;
    YSoundSpectrumValueCallback _valueCallbackSoundSpectrum;
//--- (end of YSoundSpectrum attributes declaration)
}
// Constructor is protected, use yFindSoundSpectrum factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSoundSpectrum private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSoundSpectrum private methods declaration)
//--- (YSoundSpectrum yapiwrapper declaration)
//--- (end of YSoundSpectrum yapiwrapper declaration)
//--- (YSoundSpectrum public methods declaration)
/**
 * Returns the integration time in milliseconds for calculating time
 * weighted spectrum data.
 *
 * @return an integer corresponding to the integration time in milliseconds for calculating time
 *         weighted spectrum data
 *
 * On failure, throws an exception or returns YSoundSpectrum.INTEGRATIONTIME_INVALID.
 */
-(int)     get_integrationTime;


-(int) integrationTime;
/**
 * Changes the integration time in milliseconds for computing time weighted
 * spectrum data. Be aware that on some devices, changing the integration
 * time for time-weighted spectrum data may also affect the integration
 * period for one or more sound pressure level measurements.
 * Remember to call the saveToFlash() method of the
 * module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the integration time in milliseconds for computing time weighted
 *         spectrum data
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_integrationTime:(int) newval;
-(int)     setIntegrationTime:(int) newval;

-(NSString*)     get_spectrumData;


-(NSString*) spectrumData;
/**
 * Retrieves a sound spectrum analyzer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the sound spectrum analyzer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSoundSpectrum.isOnline() to test if the sound spectrum analyzer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sound spectrum analyzer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the sound spectrum analyzer, for instance
 *         MyDevice.soundSpectrum.
 *
 * @return a YSoundSpectrum object allowing you to drive the sound spectrum analyzer.
 */
+(YSoundSpectrum*)     FindSoundSpectrum:(NSString*)func;

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
-(int)     registerValueCallback:(YSoundSpectrumValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * comment from .yc definition
 */
-(nullable YSoundSpectrum*) nextSoundSpectrum
NS_SWIFT_NAME(nextSoundSpectrum());
/**
 * comment from .yc definition
 */
+(nullable YSoundSpectrum*) FirstSoundSpectrum
NS_SWIFT_NAME(FirstSoundSpectrum());
//--- (end of YSoundSpectrum public methods declaration)

@end

//--- (YSoundSpectrum functions declaration)
/**
 * Retrieves a sound spectrum analyzer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the sound spectrum analyzer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSoundSpectrum.isOnline() to test if the sound spectrum analyzer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sound spectrum analyzer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the sound spectrum analyzer, for instance
 *         MyDevice.soundSpectrum.
 *
 * @return a YSoundSpectrum object allowing you to drive the sound spectrum analyzer.
 */
YSoundSpectrum* yFindSoundSpectrum(NSString* func);
/**
 * comment from .yc definition
 */
YSoundSpectrum* yFirstSoundSpectrum(void);

//--- (end of YSoundSpectrum functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

