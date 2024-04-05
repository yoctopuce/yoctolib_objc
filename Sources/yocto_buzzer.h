/*********************************************************************
 *
 *  $Id: yocto_buzzer.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Declares yFindBuzzer(), the high-level API for Buzzer functions
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

@class YBuzzer;

//--- (YBuzzer globals)
typedef void (*YBuzzerValueCallback)(YBuzzer *func, NSString *functionValue);
#define Y_FREQUENCY_INVALID             YAPI_INVALID_DOUBLE
#define Y_VOLUME_INVALID                YAPI_INVALID_UINT
#define Y_PLAYSEQSIZE_INVALID           YAPI_INVALID_UINT
#define Y_PLAYSEQMAXSIZE_INVALID        YAPI_INVALID_UINT
#define Y_PLAYSEQSIGNATURE_INVALID      YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YBuzzer globals)

//--- (YBuzzer class start)
/**
 * YBuzzer Class: buzzer control interface, available for instance in the Yocto-Buzzer, the
 * Yocto-MaxiBuzzer or the Yocto-MaxiKnob
 *
 * The YBuzzer class allows you to drive a buzzer. You can
 * choose the frequency and the volume at which the buzzer must sound.
 * You can also pre-program a play sequence.
 */
@interface YBuzzer : YFunction
//--- (end of YBuzzer class start)
{
@protected
//--- (YBuzzer attributes declaration)
    double          _frequency;
    int             _volume;
    int             _playSeqSize;
    int             _playSeqMaxSize;
    int             _playSeqSignature;
    NSString*       _command;
    YBuzzerValueCallback _valueCallbackBuzzer;
//--- (end of YBuzzer attributes declaration)
}
// Constructor is protected, use yFindBuzzer factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YBuzzer private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YBuzzer private methods declaration)
//--- (YBuzzer yapiwrapper declaration)
//--- (end of YBuzzer yapiwrapper declaration)
//--- (YBuzzer public methods declaration)
/**
 * Changes the frequency of the signal sent to the buzzer. A zero value stops the buzzer.
 *
 * @param newval : a floating point number corresponding to the frequency of the signal sent to the buzzer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_frequency:(double) newval;
-(int)     setFrequency:(double) newval;

/**
 * Returns the  frequency of the signal sent to the buzzer/speaker.
 *
 * @return a floating point number corresponding to the  frequency of the signal sent to the buzzer/speaker
 *
 * On failure, throws an exception or returns YBuzzer.FREQUENCY_INVALID.
 */
-(double)     get_frequency;


-(double) frequency;
/**
 * Returns the volume of the signal sent to the buzzer/speaker.
 *
 * @return an integer corresponding to the volume of the signal sent to the buzzer/speaker
 *
 * On failure, throws an exception or returns YBuzzer.VOLUME_INVALID.
 */
-(int)     get_volume;


-(int) volume;
/**
 * Changes the volume of the signal sent to the buzzer/speaker. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the volume of the signal sent to the buzzer/speaker
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_volume:(int) newval;
-(int)     setVolume:(int) newval;

/**
 * Returns the current length of the playing sequence.
 *
 * @return an integer corresponding to the current length of the playing sequence
 *
 * On failure, throws an exception or returns YBuzzer.PLAYSEQSIZE_INVALID.
 */
-(int)     get_playSeqSize;


-(int) playSeqSize;
/**
 * Returns the maximum length of the playing sequence.
 *
 * @return an integer corresponding to the maximum length of the playing sequence
 *
 * On failure, throws an exception or returns YBuzzer.PLAYSEQMAXSIZE_INVALID.
 */
-(int)     get_playSeqMaxSize;


-(int) playSeqMaxSize;
/**
 * Returns the playing sequence signature. As playing
 * sequences cannot be read from the device, this can be used
 * to detect if a specific playing sequence is already
 * programmed.
 *
 * @return an integer corresponding to the playing sequence signature
 *
 * On failure, throws an exception or returns YBuzzer.PLAYSEQSIGNATURE_INVALID.
 */
-(int)     get_playSeqSignature;


-(int) playSeqSignature;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a buzzer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the buzzer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBuzzer.isOnline() to test if the buzzer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a buzzer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the buzzer, for instance
 *         YBUZZER2.buzzer.
 *
 * @return a YBuzzer object allowing you to drive the buzzer.
 */
+(YBuzzer*)     FindBuzzer:(NSString*)func;

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
-(int)     registerValueCallback:(YBuzzerValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)command;

/**
 * Adds a new frequency transition to the playing sequence.
 *
 * @param freq    : desired frequency when the transition is completed, in Hz
 * @param msDelay : duration of the frequency transition, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addFreqMoveToPlaySeq:(int)freq :(int)msDelay;

/**
 * Adds a pulse to the playing sequence.
 *
 * @param freq : pulse frequency, in Hz
 * @param msDuration : pulse duration, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addPulseToPlaySeq:(int)freq :(int)msDuration;

/**
 * Adds a new volume transition to the playing sequence. Frequency stays untouched:
 * if frequency is at zero, the transition has no effect.
 *
 * @param volume    : desired volume when the transition is completed, as a percentage.
 * @param msDuration : duration of the volume transition, in milliseconds.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addVolMoveToPlaySeq:(int)volume :(int)msDuration;

/**
 * Adds notes to the playing sequence. Notes are provided as text words, separated by
 * spaces. The pitch is specified using the usual letter from A to G. The duration is
 * specified as the divisor of a whole note: 4 for a fourth, 8 for an eight note, etc.
 * Some modifiers are supported: # and b to alter a note pitch,
 * ' and , to move to the upper/lower octave, . to enlarge
 * the note duration.
 *
 * @param notes : notes to be played, as a text string.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     addNotesToPlaySeq:(NSString*)notes;

/**
 * Starts the preprogrammed playing sequence. The sequence
 * runs in loop until it is stopped by stopPlaySeq or an explicit
 * change. To play the sequence only once, use oncePlaySeq().
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     startPlaySeq;

/**
 * Stops the preprogrammed playing sequence and sets the frequency to zero.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     stopPlaySeq;

/**
 * Resets the preprogrammed playing sequence and sets the frequency to zero.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     resetPlaySeq;

/**
 * Starts the preprogrammed playing sequence and run it once only.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     oncePlaySeq;

/**
 * Saves the preprogrammed playing sequence to flash memory.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     savePlaySeq;

/**
 * Reloads the preprogrammed playing sequence from the flash memory.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     reloadPlaySeq;

/**
 * Activates the buzzer for a short duration.
 *
 * @param frequency : pulse frequency, in hertz
 * @param duration : pulse duration in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     pulse:(int)frequency :(int)duration;

/**
 * Makes the buzzer frequency change over a period of time.
 *
 * @param frequency : frequency to reach, in hertz. A frequency under 25Hz stops the buzzer.
 * @param duration :  pulse duration in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     freqMove:(int)frequency :(int)duration;

/**
 * Makes the buzzer volume change over a period of time, frequency  stays untouched.
 *
 * @param volume : volume to reach in %
 * @param duration : change duration in milliseconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     volumeMove:(int)volume :(int)duration;

/**
 * Immediately play a note sequence. Notes are provided as text words, separated by
 * spaces. The pitch is specified using the usual letter from A to G. The duration is
 * specified as the divisor of a whole note: 4 for a fourth, 8 for an eight note, etc.
 * Some modifiers are supported: # and b to alter a note pitch,
 * ' and , to move to the upper/lower octave, . to enlarge
 * the note duration.
 *
 * @param notes : notes to be played, as a text string.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     playNotes:(NSString*)notes;


/**
 * Continues the enumeration of buzzers started using yFirstBuzzer().
 * Caution: You can't make any assumption about the returned buzzers order.
 * If you want to find a specific a buzzer, use Buzzer.findBuzzer()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YBuzzer object, corresponding to
 *         a buzzer currently online, or a nil pointer
 *         if there are no more buzzers to enumerate.
 */
-(nullable YBuzzer*) nextBuzzer
NS_SWIFT_NAME(nextBuzzer());
/**
 * Starts the enumeration of buzzers currently accessible.
 * Use the method YBuzzer.nextBuzzer() to iterate on
 * next buzzers.
 *
 * @return a pointer to a YBuzzer object, corresponding to
 *         the first buzzer currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YBuzzer*) FirstBuzzer
NS_SWIFT_NAME(FirstBuzzer());
//--- (end of YBuzzer public methods declaration)

@end

//--- (YBuzzer functions declaration)
/**
 * Retrieves a buzzer for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the buzzer is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBuzzer.isOnline() to test if the buzzer is
 * indeed online at a given time. In case of ambiguity when looking for
 * a buzzer by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the buzzer, for instance
 *         YBUZZER2.buzzer.
 *
 * @return a YBuzzer object allowing you to drive the buzzer.
 */
YBuzzer* yFindBuzzer(NSString* func);
/**
 * Starts the enumeration of buzzers currently accessible.
 * Use the method YBuzzer.nextBuzzer() to iterate on
 * next buzzers.
 *
 * @return a pointer to a YBuzzer object, corresponding to
 *         the first buzzer currently online, or a nil pointer
 *         if there are none.
 */
YBuzzer* yFirstBuzzer(void);

//--- (end of YBuzzer functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

