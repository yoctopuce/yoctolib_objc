/*********************************************************************
 *
 * $Id: yocto_audioout.h 31436 2018-08-07 15:28:18Z seb $
 *
 * Declares yFindAudioOut(), the high-level API for AudioOut functions
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

@class YAudioOut;

//--- (YAudioOut globals)
typedef void (*YAudioOutValueCallback)(YAudioOut *func, NSString *functionValue);
#ifndef _Y_MUTE_ENUM
#define _Y_MUTE_ENUM
typedef enum {
    Y_MUTE_FALSE = 0,
    Y_MUTE_TRUE = 1,
    Y_MUTE_INVALID = -1,
} Y_MUTE_enum;
#endif
#define Y_VOLUME_INVALID                YAPI_INVALID_UINT
#define Y_VOLUMERANGE_INVALID           YAPI_INVALID_STRING
#define Y_SIGNAL_INVALID                YAPI_INVALID_INT
#define Y_NOSIGNALFOR_INVALID           YAPI_INVALID_INT
//--- (end of YAudioOut globals)

//--- (YAudioOut class start)
/**
 * YAudioOut Class: AudioOut function interface
 *
 * The Yoctopuce application programming interface allows you to configure the volume of the outout.
 */
@interface YAudioOut : YFunction
//--- (end of YAudioOut class start)
{
@protected
//--- (YAudioOut attributes declaration)
    int             _volume;
    Y_MUTE_enum     _mute;
    NSString*       _volumeRange;
    int             _signal;
    int             _noSignalFor;
    YAudioOutValueCallback _valueCallbackAudioOut;
//--- (end of YAudioOut attributes declaration)
}
// Constructor is protected, use yFindAudioOut factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YAudioOut private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YAudioOut private methods declaration)
//--- (YAudioOut yapiwrapper declaration)
//--- (end of YAudioOut yapiwrapper declaration)
//--- (YAudioOut public methods declaration)
/**
 * Returns audio output volume, in per cents.
 *
 * @return an integer corresponding to audio output volume, in per cents
 *
 * On failure, throws an exception or returns Y_VOLUME_INVALID.
 */
-(int)     get_volume;


-(int) volume;
/**
 * Changes audio output volume, in per cents.
 *
 * @param newval : an integer corresponding to audio output volume, in per cents
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_volume:(int) newval;
-(int)     setVolume:(int) newval;

/**
 * Returns the state of the mute function.
 *
 * @return either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
 *
 * On failure, throws an exception or returns Y_MUTE_INVALID.
 */
-(Y_MUTE_enum)     get_mute;


-(Y_MUTE_enum) mute;
/**
 * Changes the state of the mute function. Remember to call the matching module
 * saveToFlash() method to save the setting permanently.
 *
 * @param newval : either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_mute:(Y_MUTE_enum) newval;
-(int)     setMute:(Y_MUTE_enum) newval;

/**
 * Returns the supported volume range. The low value of the
 * range corresponds to the minimal audible value. To
 * completely mute the sound, use set_mute()
 * instead of the set_volume().
 *
 * @return a string corresponding to the supported volume range
 *
 * On failure, throws an exception or returns Y_VOLUMERANGE_INVALID.
 */
-(NSString*)     get_volumeRange;


-(NSString*) volumeRange;
/**
 * Returns the detected output current level.
 *
 * @return an integer corresponding to the detected output current level
 *
 * On failure, throws an exception or returns Y_SIGNAL_INVALID.
 */
-(int)     get_signal;


-(int) signal;
/**
 * Returns the number of seconds elapsed without detecting a signal.
 *
 * @return an integer corresponding to the number of seconds elapsed without detecting a signal
 *
 * On failure, throws an exception or returns Y_NOSIGNALFOR_INVALID.
 */
-(int)     get_noSignalFor;


-(int) noSignalFor;
/**
 * Retrieves an audio output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the audio output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAudioOut.isOnline() to test if the audio output is
 * indeed online at a given time. In case of ambiguity when looking for
 * an audio output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the audio output
 *
 * @return a YAudioOut object allowing you to drive the audio output.
 */
+(YAudioOut*)     FindAudioOut:(NSString*)func;

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
-(int)     registerValueCallback:(YAudioOutValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of audio outputs started using yFirstAudioOut().
 *
 * @return a pointer to a YAudioOut object, corresponding to
 *         an audio output currently online, or a nil pointer
 *         if there are no more audio outputs to enumerate.
 */
-(YAudioOut*) nextAudioOut;
/**
 * Starts the enumeration of audio outputs currently accessible.
 * Use the method YAudioOut.nextAudioOut() to iterate on
 * next audio outputs.
 *
 * @return a pointer to a YAudioOut object, corresponding to
 *         the first audio output currently online, or a nil pointer
 *         if there are none.
 */
+(YAudioOut*) FirstAudioOut;
//--- (end of YAudioOut public methods declaration)

@end

//--- (YAudioOut functions declaration)
/**
 * Retrieves an audio output for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the audio output is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAudioOut.isOnline() to test if the audio output is
 * indeed online at a given time. In case of ambiguity when looking for
 * an audio output by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the audio output
 *
 * @return a YAudioOut object allowing you to drive the audio output.
 */
YAudioOut* yFindAudioOut(NSString* func);
/**
 * Starts the enumeration of audio outputs currently accessible.
 * Use the method YAudioOut.nextAudioOut() to iterate on
 * next audio outputs.
 *
 * @return a pointer to a YAudioOut object, corresponding to
 *         the first audio output currently online, or a nil pointer
 *         if there are none.
 */
YAudioOut* yFirstAudioOut(void);

//--- (end of YAudioOut functions declaration)
CF_EXTERN_C_END

