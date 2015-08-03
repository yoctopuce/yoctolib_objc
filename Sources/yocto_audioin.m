/*********************************************************************
 *
 * $Id: yocto_audioin.m 20797 2015-07-06 16:49:40Z mvuilleu $
 *
 * Implements the high-level API for AudioIn functions
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


#import "yocto_audioin.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YAudioIn

// Constructor is protected, use yFindAudioIn factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"AudioIn";
//--- (YAudioIn attributes initialization)
    _volume = Y_VOLUME_INVALID;
    _mute = Y_MUTE_INVALID;
    _volumeRange = Y_VOLUMERANGE_INVALID;
    _signal = Y_SIGNAL_INVALID;
    _noSignalFor = Y_NOSIGNALFOR_INVALID;
    _valueCallbackAudioIn = NULL;
//--- (end of YAudioIn attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YAudioIn cleanup)
    ARC_release(_volumeRange);
    _volumeRange = nil;
    ARC_dealloc(super);
//--- (end of YAudioIn cleanup)
}
//--- (YAudioIn private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "volume")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _volume =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "mute")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _mute =  (Y_MUTE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "volumeRange")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_volumeRange);
        _volumeRange =  [self _parseString:j];
        ARC_retain(_volumeRange);
        return 1;
    }
    if(!strcmp(j->token, "signal")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _signal =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "noSignalFor")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _noSignalFor =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YAudioIn private methods implementation)
//--- (YAudioIn public methods implementation)
/**
 * Returns audio input gain, in per cents.
 *
 * @return an integer corresponding to audio input gain, in per cents
 *
 * On failure, throws an exception or returns Y_VOLUME_INVALID.
 */
-(int) get_volume
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLUME_INVALID;
        }
    }
    return _volume;
}


-(int) volume
{
    return [self get_volume];
}

/**
 * Changes audio input gain, in per cents.
 *
 * @param newval : an integer corresponding to audio input gain, in per cents
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
 * Returns the state of the mute function.
 *
 * @return either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
 *
 * On failure, throws an exception or returns Y_MUTE_INVALID.
 */
-(Y_MUTE_enum) get_mute
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MUTE_INVALID;
        }
    }
    return _mute;
}


-(Y_MUTE_enum) mute
{
    return [self get_mute];
}

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
-(int) set_mute:(Y_MUTE_enum) newval
{
    return [self setMute:newval];
}
-(int) setMute:(Y_MUTE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"mute" :rest_val];
}
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
-(NSString*) get_volumeRange
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLUMERANGE_INVALID;
        }
    }
    return _volumeRange;
}


-(NSString*) volumeRange
{
    return [self get_volumeRange];
}
/**
 * Returns the detected input signal level.
 *
 * @return an integer corresponding to the detected input signal level
 *
 * On failure, throws an exception or returns Y_SIGNAL_INVALID.
 */
-(int) get_signal
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SIGNAL_INVALID;
        }
    }
    return _signal;
}


-(int) signal
{
    return [self get_signal];
}
/**
 * Returns the number of seconds elapsed without detecting a signal
 *
 * @return an integer corresponding to the number of seconds elapsed without detecting a signal
 *
 * On failure, throws an exception or returns Y_NOSIGNALFOR_INVALID.
 */
-(int) get_noSignalFor
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_NOSIGNALFOR_INVALID;
        }
    }
    return _noSignalFor;
}


-(int) noSignalFor
{
    return [self get_noSignalFor];
}
/**
 * Retrieves $AFUNCTION$ for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that $THEFUNCTION$ is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YAudioIn.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YAudioIn object allowing you to drive $THEFUNCTION$.
 */
+(YAudioIn*) FindAudioIn:(NSString*)func
{
    YAudioIn* obj;
    obj = (YAudioIn*) [YFunction _FindFromCache:@"AudioIn" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YAudioIn alloc] initWith:func]);
        [YFunction _AddToCache:@"AudioIn" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YAudioInValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackAudioIn = callback;
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
    if (_valueCallbackAudioIn != NULL) {
        _valueCallbackAudioIn(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YAudioIn*)   nextAudioIn
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YAudioIn FindAudioIn:hwid];
}

+(YAudioIn *) FirstAudioIn
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"AudioIn":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YAudioIn FindAudioIn:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YAudioIn public methods implementation)

@end
//--- (AudioIn functions)

YAudioIn *yFindAudioIn(NSString* func)
{
    return [YAudioIn FindAudioIn:func];
}

YAudioIn *yFirstAudioIn(void)
{
    return [YAudioIn FirstAudioIn];
}

//--- (end of AudioIn functions)
