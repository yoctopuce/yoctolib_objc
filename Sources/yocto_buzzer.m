/*********************************************************************
 *
 *  $Id: yocto_buzzer.m 32610 2018-10-10 06:52:20Z seb $
 *
 *  Implements the high-level API for Buzzer functions
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


#import "yocto_buzzer.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YBuzzer

// Constructor is protected, use yFindBuzzer factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Buzzer";
//--- (YBuzzer attributes initialization)
    _frequency = Y_FREQUENCY_INVALID;
    _volume = Y_VOLUME_INVALID;
    _playSeqSize = Y_PLAYSEQSIZE_INVALID;
    _playSeqMaxSize = Y_PLAYSEQMAXSIZE_INVALID;
    _playSeqSignature = Y_PLAYSEQSIGNATURE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackBuzzer = NULL;
//--- (end of YBuzzer attributes initialization)
    return self;
}
//--- (YBuzzer yapiwrapper)
//--- (end of YBuzzer yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YBuzzer cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YBuzzer cleanup)
}
//--- (YBuzzer private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "frequency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _frequency =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "volume")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _volume =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "playSeqSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _playSeqSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "playSeqMaxSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _playSeqMaxSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "playSeqSignature")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _playSeqSignature =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YBuzzer private methods implementation)
//--- (YBuzzer public methods implementation)

/**
 * Changes the frequency of the signal sent to the buzzer. A zero value stops the buzzer.
 *
 * @param newval : a floating point number corresponding to the frequency of the signal sent to the buzzer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_frequency:(double) newval
{
    return [self setFrequency:newval];
}
-(int) setFrequency:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"frequency" :rest_val];
}
/**
 * Returns the  frequency of the signal sent to the buzzer/speaker.
 *
 * @return a floating point number corresponding to the  frequency of the signal sent to the buzzer/speaker
 *
 * On failure, throws an exception or returns Y_FREQUENCY_INVALID.
 */
-(double) get_frequency
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_FREQUENCY_INVALID;
        }
    }
    res = _frequency;
    return res;
}


-(double) frequency
{
    return [self get_frequency];
}
/**
 * Returns the volume of the signal sent to the buzzer/speaker.
 *
 * @return an integer corresponding to the volume of the signal sent to the buzzer/speaker
 *
 * On failure, throws an exception or returns Y_VOLUME_INVALID.
 */
-(int) get_volume
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLUME_INVALID;
        }
    }
    res = _volume;
    return res;
}


-(int) volume
{
    return [self get_volume];
}

/**
 * Changes the volume of the signal sent to the buzzer/speaker.
 *
 * @param newval : an integer corresponding to the volume of the signal sent to the buzzer/speaker
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_volume:(int) newval
{
    return [self setVolume:newval];
}
-(int) setVolume:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"volume" :rest_val];
}
/**
 * Returns the current length of the playing sequence.
 *
 * @return an integer corresponding to the current length of the playing sequence
 *
 * On failure, throws an exception or returns Y_PLAYSEQSIZE_INVALID.
 */
-(int) get_playSeqSize
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PLAYSEQSIZE_INVALID;
        }
    }
    res = _playSeqSize;
    return res;
}


-(int) playSeqSize
{
    return [self get_playSeqSize];
}
/**
 * Returns the maximum length of the playing sequence.
 *
 * @return an integer corresponding to the maximum length of the playing sequence
 *
 * On failure, throws an exception or returns Y_PLAYSEQMAXSIZE_INVALID.
 */
-(int) get_playSeqMaxSize
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PLAYSEQMAXSIZE_INVALID;
        }
    }
    res = _playSeqMaxSize;
    return res;
}


-(int) playSeqMaxSize
{
    return [self get_playSeqMaxSize];
}
/**
 * Returns the playing sequence signature. As playing
 * sequences cannot be read from the device, this can be used
 * to detect if a specific playing sequence is already
 * programmed.
 *
 * @return an integer corresponding to the playing sequence signature
 *
 * On failure, throws an exception or returns Y_PLAYSEQSIGNATURE_INVALID.
 */
-(int) get_playSeqSignature
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PLAYSEQSIGNATURE_INVALID;
        }
    }
    res = _playSeqSignature;
    return res;
}


-(int) playSeqSignature
{
    return [self get_playSeqSignature];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a buzzer for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
 * @param func : a string that uniquely characterizes the buzzer
 *
 * @return a YBuzzer object allowing you to drive the buzzer.
 */
+(YBuzzer*) FindBuzzer:(NSString*)func
{
    YBuzzer* obj;
    obj = (YBuzzer*) [YFunction _FindFromCache:@"Buzzer" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YBuzzer alloc] initWith:func]);
        [YFunction _AddToCache:@"Buzzer" : func :obj];
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
-(int) registerValueCallback:(YBuzzerValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackBuzzer = callback;
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
    if (_valueCallbackBuzzer != NULL) {
        _valueCallbackBuzzer(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)command
{
    return [self set_command:command];
}

/**
 * Adds a new frequency transition to the playing sequence.
 *
 * @param freq    : desired frequency when the transition is completed, in Hz
 * @param msDelay : duration of the frequency transition, in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addFreqMoveToPlaySeq:(int)freq :(int)msDelay
{
    return [self sendCommand:[NSString stringWithFormat:@"A%d,%d",freq,msDelay]];
}

/**
 * Adds a pulse to the playing sequence.
 *
 * @param freq : pulse frequency, in Hz
 * @param msDuration : pulse duration, in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addPulseToPlaySeq:(int)freq :(int)msDuration
{
    return [self sendCommand:[NSString stringWithFormat:@"B%d,%d",freq,msDuration]];
}

/**
 * Adds a new volume transition to the playing sequence. Frequency stays untouched:
 * if frequency is at zero, the transition has no effect.
 *
 * @param volume    : desired volume when the transition is completed, as a percentage.
 * @param msDuration : duration of the volume transition, in milliseconds.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addVolMoveToPlaySeq:(int)volume :(int)msDuration
{
    return [self sendCommand:[NSString stringWithFormat:@"C%d,%d",volume,msDuration]];
}

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
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) addNotesToPlaySeq:(NSString*)notes
{
    int tempo;
    int prevPitch;
    int prevDuration;
    int prevFreq;
    int note;
    int num;
    int typ;
    NSMutableData* ascNotes;
    int notesLen;
    int i;
    int ch;
    int dNote;
    int pitch;
    int freq;
    int ms;
    int ms16;
    int rest;
    tempo = 100;
    prevPitch = 3;
    prevDuration = 4;
    prevFreq = 110;
    note = -99;
    num = 0;
    typ = 3;
    ascNotes = [NSMutableData dataWithData:[notes dataUsingEncoding:NSISOLatin1StringEncoding]];
    notesLen = (int)[ascNotes length];
    i = 0;
    while (i < notesLen) {
        ch = (((u8*)([ascNotes bytes]))[i]);
        // A (note))
        if (ch == 65) {
            note = 0;
        }
        // B (note)
        if (ch == 66) {
            note = 2;
        }
        // C (note)
        if (ch == 67) {
            note = 3;
        }
        // D (note)
        if (ch == 68) {
            note = 5;
        }
        // E (note)
        if (ch == 69) {
            note = 7;
        }
        // F (note)
        if (ch == 70) {
            note = 8;
        }
        // G (note)
        if (ch == 71) {
            note = 10;
        }
        // '#' (sharp modifier)
        if (ch == 35) {
            note = note + 1;
        }
        // 'b' (flat modifier)
        if (ch == 98) {
            note = note - 1;
        }
        // ' (octave up)
        if (ch == 39) {
            prevPitch = prevPitch + 12;
        }
        // , (octave down)
        if (ch == 44) {
            prevPitch = prevPitch - 12;
        }
        // R (rest)
        if (ch == 82) {
            typ = 0;
        }
        // ! (staccato modifier)
        if (ch == 33) {
            typ = 1;
        }
        // ^ (short modifier)
        if (ch == 94) {
            typ = 2;
        }
        // _ (legato modifier)
        if (ch == 95) {
            typ = 4;
        }
        // - (glissando modifier)
        if (ch == 45) {
            typ = 5;
        }
        // % (tempo change)
        if ((ch == 37) && (num > 0)) {
            tempo = num;
            num = 0;
        }
        if ((ch >= 48) && (ch <= 57)) {
            // 0-9 (number)
            num = (num * 10) + (ch - 48);
        }
        if (ch == 46) {
            // . (duration modifier)
            num = ((num * 2) / (3));
        }
        if (((ch == 32) || (i+1 == notesLen)) && ((note > -99) || (typ != 3))) {
            if (num == 0) {
                num = prevDuration;
            } else {
                prevDuration = num;
            }
            ms = (int) floor(320000.0 / (tempo * num)+0.5);
            if (typ == 0) {
                [self addPulseToPlaySeq:0 :ms];
            } else {
                dNote = note - (((prevPitch) % (12)));
                if (dNote > 6) {
                    dNote = dNote - 12;
                }
                if (dNote <= -6) {
                    dNote = dNote + 12;
                }
                pitch = prevPitch + dNote;
                freq = (int) floor(440 * exp(pitch * 0.05776226504666)+0.5);
                ms16 = ((ms) >> (4));
                rest = 0;
                if (typ == 3) {
                    rest = 2 * ms16;
                }
                if (typ == 2) {
                    rest = 8 * ms16;
                }
                if (typ == 1) {
                    rest = 12 * ms16;
                }
                if (typ == 5) {
                    [self addPulseToPlaySeq:prevFreq :ms16];
                    [self addFreqMoveToPlaySeq:freq :8 * ms16];
                    [self addPulseToPlaySeq:freq :ms - 9 * ms16];
                } else {
                    [self addPulseToPlaySeq:freq :ms - rest];
                    if (rest > 0) {
                        [self addPulseToPlaySeq:0 :rest];
                    }
                }
                prevFreq = freq;
                prevPitch = pitch;
            }
            note = -99;
            num = 0;
            typ = 3;
        }
        i = i + 1;
    }
    return YAPI_SUCCESS;
}

/**
 * Starts the preprogrammed playing sequence. The sequence
 * runs in loop until it is stopped by stopPlaySeq or an explicit
 * change. To play the sequence only once, use oncePlaySeq().
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) startPlaySeq
{
    return [self sendCommand:@"S"];
}

/**
 * Stops the preprogrammed playing sequence and sets the frequency to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) stopPlaySeq
{
    return [self sendCommand:@"X"];
}

/**
 * Resets the preprogrammed playing sequence and sets the frequency to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) resetPlaySeq
{
    return [self sendCommand:@"Z"];
}

/**
 * Starts the preprogrammed playing sequence and run it once only.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) oncePlaySeq
{
    return [self sendCommand:@"s"];
}

/**
 * Activates the buzzer for a short duration.
 *
 * @param frequency : pulse frequency, in hertz
 * @param duration : pulse duration in millseconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulse:(int)frequency :(int)duration
{
    return [self set_command:[NSString stringWithFormat:@"P%d,%d",frequency,duration]];
}

/**
 * Makes the buzzer frequency change over a period of time.
 *
 * @param frequency : frequency to reach, in hertz. A frequency under 25Hz stops the buzzer.
 * @param duration :  pulse duration in millseconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) freqMove:(int)frequency :(int)duration
{
    return [self set_command:[NSString stringWithFormat:@"F%d,%d",frequency,duration]];
}

/**
 * Makes the buzzer volume change over a period of time, frequency  stays untouched.
 *
 * @param volume : volume to reach in %
 * @param duration : change duration in millseconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) volumeMove:(int)volume :(int)duration
{
    return [self set_command:[NSString stringWithFormat:@"V%d,%d",volume,duration]];
}

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
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) playNotes:(NSString*)notes
{
    [self resetPlaySeq];
    [self addNotesToPlaySeq:notes];
    return [self oncePlaySeq];
}


-(YBuzzer*)   nextBuzzer
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YBuzzer FindBuzzer:hwid];
}

+(YBuzzer *) FirstBuzzer
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Buzzer":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YBuzzer FindBuzzer:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YBuzzer public methods implementation)

@end
//--- (YBuzzer functions)

YBuzzer *yFindBuzzer(NSString* func)
{
    return [YBuzzer FindBuzzer:func];
}

YBuzzer *yFirstBuzzer(void)
{
    return [YBuzzer FirstBuzzer];
}

//--- (end of YBuzzer functions)
