/*********************************************************************
 *
 *  $Id: yocto_colorledcluster.m 43619 2021-01-29 09:14:45Z mvuilleu $
 *
 *  Implements the high-level API for ColorLedCluster functions
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


#import "yocto_colorledcluster.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YColorLedCluster

// Constructor is protected, use yFindColorLedCluster factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"ColorLedCluster";
//--- (YColorLedCluster attributes initialization)
    _activeLedCount = Y_ACTIVELEDCOUNT_INVALID;
    _ledType = Y_LEDTYPE_INVALID;
    _maxLedCount = Y_MAXLEDCOUNT_INVALID;
    _blinkSeqMaxCount = Y_BLINKSEQMAXCOUNT_INVALID;
    _blinkSeqMaxSize = Y_BLINKSEQMAXSIZE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackColorLedCluster = NULL;
//--- (end of YColorLedCluster attributes initialization)
    return self;
}
//--- (YColorLedCluster yapiwrapper)
//--- (end of YColorLedCluster yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YColorLedCluster cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YColorLedCluster cleanup)
}
//--- (YColorLedCluster private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "activeLedCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _activeLedCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "ledType")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ledType =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "maxLedCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxLedCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinkSeqMaxCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinkSeqMaxCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "blinkSeqMaxSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _blinkSeqMaxSize =  atoi(j->token);
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
//--- (end of YColorLedCluster private methods implementation)
//--- (YColorLedCluster public methods implementation)
/**
 * Returns the number of LEDs currently handled by the device.
 *
 * @return an integer corresponding to the number of LEDs currently handled by the device
 *
 * On failure, throws an exception or returns YColorLedCluster.ACTIVELEDCOUNT_INVALID.
 */
-(int) get_activeLedCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ACTIVELEDCOUNT_INVALID;
        }
    }
    res = _activeLedCount;
    return res;
}


-(int) activeLedCount
{
    return [self get_activeLedCount];
}

/**
 * Changes the number of LEDs currently handled by the device.
 * Remember to call the matching module
 * saveToFlash() method to save the setting permanently.
 *
 * @param newval : an integer corresponding to the number of LEDs currently handled by the device
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_activeLedCount:(int) newval
{
    return [self setActiveLedCount:newval];
}
-(int) setActiveLedCount:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"activeLedCount" :rest_val];
}
/**
 * Returns the RGB LED type currently handled by the device.
 *
 * @return either YColorLedCluster.LEDTYPE_RGB or YColorLedCluster.LEDTYPE_RGBW, according to the RGB
 * LED type currently handled by the device
 *
 * On failure, throws an exception or returns YColorLedCluster.LEDTYPE_INVALID.
 */
-(Y_LEDTYPE_enum) get_ledType
{
    Y_LEDTYPE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LEDTYPE_INVALID;
        }
    }
    res = _ledType;
    return res;
}


-(Y_LEDTYPE_enum) ledType
{
    return [self get_ledType];
}

/**
 * Changes the RGB LED type currently handled by the device.
 * Remember to call the matching module
 * saveToFlash() method to save the setting permanently.
 *
 * @param newval : either YColorLedCluster.LEDTYPE_RGB or YColorLedCluster.LEDTYPE_RGBW, according to
 * the RGB LED type currently handled by the device
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ledType:(Y_LEDTYPE_enum) newval
{
    return [self setLedType:newval];
}
-(int) setLedType:(Y_LEDTYPE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"ledType" :rest_val];
}
/**
 * Returns the maximum number of LEDs that the device can handle.
 *
 * @return an integer corresponding to the maximum number of LEDs that the device can handle
 *
 * On failure, throws an exception or returns YColorLedCluster.MAXLEDCOUNT_INVALID.
 */
-(int) get_maxLedCount
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXLEDCOUNT_INVALID;
        }
    }
    res = _maxLedCount;
    return res;
}


-(int) maxLedCount
{
    return [self get_maxLedCount];
}
/**
 * Returns the maximum number of sequences that the device can handle.
 *
 * @return an integer corresponding to the maximum number of sequences that the device can handle
 *
 * On failure, throws an exception or returns YColorLedCluster.BLINKSEQMAXCOUNT_INVALID.
 */
-(int) get_blinkSeqMaxCount
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKSEQMAXCOUNT_INVALID;
        }
    }
    res = _blinkSeqMaxCount;
    return res;
}


-(int) blinkSeqMaxCount
{
    return [self get_blinkSeqMaxCount];
}
/**
 * Returns the maximum length of sequences.
 *
 * @return an integer corresponding to the maximum length of sequences
 *
 * On failure, throws an exception or returns YColorLedCluster.BLINKSEQMAXSIZE_INVALID.
 */
-(int) get_blinkSeqMaxSize
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BLINKSEQMAXSIZE_INVALID;
        }
    }
    res = _blinkSeqMaxSize;
    return res;
}


-(int) blinkSeqMaxSize
{
    return [self get_blinkSeqMaxSize];
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
 * Retrieves a RGB LED cluster for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RGB LED cluster is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YColorLedCluster.isOnline() to test if the RGB LED cluster is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RGB LED cluster by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RGB LED cluster, for instance
 *         YRGBLED2.colorLedCluster.
 *
 * @return a YColorLedCluster object allowing you to drive the RGB LED cluster.
 */
+(YColorLedCluster*) FindColorLedCluster:(NSString*)func
{
    YColorLedCluster* obj;
    obj = (YColorLedCluster*) [YFunction _FindFromCache:@"ColorLedCluster" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YColorLedCluster alloc] initWith:func]);
        [YFunction _AddToCache:@"ColorLedCluster" : func :obj];
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
-(int) registerValueCallback:(YColorLedClusterValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackColorLedCluster = callback;
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
    if (_valueCallbackColorLedCluster != NULL) {
        _valueCallbackColorLedCluster(self, value);
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
 * Changes the current color of consecutive LEDs in the cluster, using a RGB color. Encoding is done
 * as follows: 0xRRGGBB.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColor:(int)ledIndex :(int)count :(int)rgbValue
{
    return [self sendCommand:[NSString stringWithFormat:@"SR%d,%d,%x",ledIndex,count,rgbValue]];
}

/**
 * Changes the  color at device startup of consecutive LEDs in the cluster, using a RGB color.
 * Encoding is done as follows: 0xRRGGBB. Don't forget to call saveLedsConfigAtPowerOn()
 * to make sure the modification is saved in the device flash memory.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColorAtPowerOn:(int)ledIndex :(int)count :(int)rgbValue
{
    return [self sendCommand:[NSString stringWithFormat:@"SC%d,%d,%x",ledIndex,count,rgbValue]];
}

/**
 * Changes the  color at device startup of consecutive LEDs in the cluster, using a HSL color.
 * Encoding is done as follows: 0xHHSSLL. Don't forget to call saveLedsConfigAtPowerOn()
 * to make sure the modification is saved in the device flash memory.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param hslValue :  new color.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColorAtPowerOn:(int)ledIndex :(int)count :(int)hslValue
{
    int rgbValue;
    rgbValue = [self hsl2rgb:hslValue];
    return [self sendCommand:[NSString stringWithFormat:@"SC%d,%d,%x",ledIndex,count,rgbValue]];
}

/**
 * Changes the current color of consecutive LEDs in the cluster, using a HSL color. Encoding is done
 * as follows: 0xHHSSLL.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param hslValue :  new color.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColor:(int)ledIndex :(int)count :(int)hslValue
{
    return [self sendCommand:[NSString stringWithFormat:@"SH%d,%d,%x",ledIndex,count,hslValue]];
}

/**
 * Allows you to modify the current color of a group of adjacent LEDs to another color, in a seamless and
 * autonomous manner. The transition is performed in the RGB space.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param rgbValue :  new color (0xRRGGBB).
 * @param delay    :  transition duration in ms
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) rgb_move:(int)ledIndex :(int)count :(int)rgbValue :(int)delay
{
    return [self sendCommand:[NSString stringWithFormat:@"MR%d,%d,%x,%d",ledIndex,count,rgbValue,delay]];
}

/**
 * Allows you to modify the current color of a group of adjacent LEDs  to another color, in a seamless and
 * autonomous manner. The transition is performed in the HSL space. In HSL, hue is a circular
 * value (0..360°). There are always two paths to perform the transition: by increasing
 * or by decreasing the hue. The module selects the shortest transition.
 * If the difference is exactly 180°, the module selects the transition which increases
 * the hue.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param hslValue :  new color (0xHHSSLL).
 * @param delay    :  transition duration in ms
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) hsl_move:(int)ledIndex :(int)count :(int)hslValue :(int)delay
{
    return [self sendCommand:[NSString stringWithFormat:@"MH%d,%d,%x,%d",ledIndex,count,hslValue,delay]];
}

/**
 * Adds an RGB transition to a sequence. A sequence is a transition list, which can
 * be executed in loop by a group of LEDs.  Sequences are persistent and are saved
 * in the device flash memory as soon as the saveBlinkSeq() method is called.
 *
 * @param seqIndex :  sequence index.
 * @param rgbValue :  target color (0xRRGGBB)
 * @param delay    :  transition duration in ms
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) addRgbMoveToBlinkSeq:(int)seqIndex :(int)rgbValue :(int)delay
{
    return [self sendCommand:[NSString stringWithFormat:@"AR%d,%x,%d",seqIndex,rgbValue,delay]];
}

/**
 * Adds an HSL transition to a sequence. A sequence is a transition list, which can
 * be executed in loop by an group of LEDs.  Sequences are persistent and are saved
 * in the device flash memory as soon as the saveBlinkSeq() method is called.
 *
 * @param seqIndex : sequence index.
 * @param hslValue : target color (0xHHSSLL)
 * @param delay    : transition duration in ms
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) addHslMoveToBlinkSeq:(int)seqIndex :(int)hslValue :(int)delay
{
    return [self sendCommand:[NSString stringWithFormat:@"AH%d,%x,%d",seqIndex,hslValue,delay]];
}

/**
 * Adds a mirror ending to a sequence. When the sequence will reach the end of the last
 * transition, its running speed will automatically be reversed so that the sequence plays
 * in the reverse direction, like in a mirror. After the first transition of the sequence
 * is played at the end of the reverse execution, the sequence starts again in
 * the initial direction.
 *
 * @param seqIndex : sequence index.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) addMirrorToBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"AC%d,0,0",seqIndex]];
}

/**
 * Adds to a sequence a jump to another sequence. When a pixel will reach this jump,
 * it will be automatically relinked to the new sequence, and will run it starting
 * from the beginning.
 *
 * @param seqIndex : sequence index.
 * @param linkSeqIndex : index of the sequence to chain.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) addJumpToBlinkSeq:(int)seqIndex :(int)linkSeqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"AC%d,100,%d,1000",seqIndex,linkSeqIndex]];
}

/**
 * Adds a to a sequence a hard stop code. When a pixel will reach this stop code,
 * instead of restarting the sequence in a loop it will automatically be unlinked
 * from the sequence.
 *
 * @param seqIndex : sequence index.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) addUnlinkToBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"AC%d,100,-1,1000",seqIndex]];
}

/**
 * Links adjacent LEDs to a specific sequence. These LEDs start to execute
 * the sequence as soon as  startBlinkSeq is called. It is possible to add an offset
 * in the execution: that way we  can have several groups of LED executing the same
 * sequence, with a  temporal offset. A LED cannot be linked to more than one sequence.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param offset   :  execution offset in ms.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) linkLedToBlinkSeq:(int)ledIndex :(int)count :(int)seqIndex :(int)offset
{
    return [self sendCommand:[NSString stringWithFormat:@"LS%d,%d,%d,%d",ledIndex,count,seqIndex,offset]];
}

/**
 * Links adjacent LEDs to a specific sequence at device power-on. Don't forget to configure
 * the sequence auto start flag as well and call saveLedsConfigAtPowerOn(). It is possible to add an offset
 * in the execution: that way we  can have several groups of LEDs executing the same
 * sequence, with a  temporal offset. A LED cannot be linked to more than one sequence.
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param offset   :  execution offset in ms.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) linkLedToBlinkSeqAtPowerOn:(int)ledIndex :(int)count :(int)seqIndex :(int)offset
{
    return [self sendCommand:[NSString stringWithFormat:@"LO%d,%d,%d,%d",ledIndex,count,seqIndex,offset]];
}

/**
 * Links adjacent LEDs to a specific sequence. These LED start to execute
 * the sequence as soon as  startBlinkSeq is called. This function automatically
 * introduces a shift between LEDs so that the specified number of sequence periods
 * appears on the group of LEDs (wave effect).
 *
 * @param ledIndex :  index of the first affected LED.
 * @param count    :  affected LED count.
 * @param seqIndex :  sequence index.
 * @param periods  :  number of periods to show on LEDs.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) linkLedToPeriodicBlinkSeq:(int)ledIndex :(int)count :(int)seqIndex :(int)periods
{
    return [self sendCommand:[NSString stringWithFormat:@"LP%d,%d,%d,%d",ledIndex,count,seqIndex,periods]];
}

/**
 * Unlinks adjacent LEDs from a  sequence.
 *
 * @param ledIndex  :  index of the first affected LED.
 * @param count     :  affected LED count.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) unlinkLedFromBlinkSeq:(int)ledIndex :(int)count
{
    return [self sendCommand:[NSString stringWithFormat:@"US%d,%d",ledIndex,count]];
}

/**
 * Starts a sequence execution: every LED linked to that sequence starts to
 * run it in a loop. Note that a sequence with a zero duration can't be started.
 *
 * @param seqIndex :  index of the sequence to start.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) startBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"SS%d",seqIndex]];
}

/**
 * Stops a sequence execution. If started again, the execution
 * restarts from the beginning.
 *
 * @param seqIndex :  index of the sequence to stop.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) stopBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"XS%d",seqIndex]];
}

/**
 * Stops a sequence execution and resets its contents. LEDs linked to this
 * sequence are not automatically updated anymore.
 *
 * @param seqIndex :  index of the sequence to reset
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"ZS%d",seqIndex]];
}

/**
 * Configures a sequence to make it start automatically at device
 * startup. Note that a sequence with a zero duration can't be started.
 * Don't forget to call saveBlinkSeq() to make sure the
 * modification is saved in the device flash memory.
 *
 * @param seqIndex :  index of the sequence to reset.
 * @param autostart : 0 to keep the sequence turned off and 1 to start it automatically.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_blinkSeqStateAtPowerOn:(int)seqIndex :(int)autostart
{
    return [self sendCommand:[NSString stringWithFormat:@"AS%d,%d",seqIndex,autostart]];
}

/**
 * Changes the execution speed of a sequence. The natural execution speed is 1000 per
 * thousand. If you configure a slower speed, you can play the sequence in slow-motion.
 * If you set a negative speed, you can play the sequence in reverse direction.
 *
 * @param seqIndex :  index of the sequence to start.
 * @param speed :     sequence running speed (-1000...1000).
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_blinkSeqSpeed:(int)seqIndex :(int)speed
{
    return [self sendCommand:[NSString stringWithFormat:@"CS%d,%d",seqIndex,speed]];
}

/**
 * Saves the LEDs power-on configuration. This includes the start-up color or
 * sequence binding for all LEDs. Warning: if some LEDs are linked to a sequence, the
 * method saveBlinkSeq() must also be called to save the sequence definition.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) saveLedsConfigAtPowerOn
{
    return [self sendCommand:@"WL"];
}

-(int) saveLedsState
{
    return [self sendCommand:@"WL"];
}

/**
 * Saves the definition of a sequence. Warning: only sequence steps and flags are saved.
 * to save the LEDs startup bindings, the method saveLedsConfigAtPowerOn()
 * must be called.
 *
 * @param seqIndex :  index of the sequence to start.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) saveBlinkSeq:(int)seqIndex
{
    return [self sendCommand:[NSString stringWithFormat:@"WS%d",seqIndex]];
}

/**
 * Sends a binary buffer to the LED RGB buffer, as is.
 * First three bytes are RGB components for LED specified as parameter, the
 * next three bytes for the next LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param buff : the binary buffer to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColorBuffer:(int)ledIndex :(NSData*)buff
{
    return [self _upload:[NSString stringWithFormat:@"rgb:0:%d",ledIndex] :buff];
}

/**
 * Sends 24bit RGB colors (provided as a list of integers) to the LED RGB buffer, as is.
 * The first number represents the RGB value of the LED specified as parameter, the second
 * number represents the RGB value of the next LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param rgbList : a list of 24bit RGB codes, in the form 0xRRGGBB
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_rgbColorArray:(int)ledIndex :(NSMutableArray*)rgbList
{
    int listlen;
    NSMutableData* buff;
    int idx;
    int rgb;
    int res;
    listlen = (int)[rgbList count];
    buff = [NSMutableData dataWithLength:3*listlen];
    idx = 0;
    while (idx < listlen) {
        rgb = [[rgbList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ 3*idx]) = ((((rgb) >> (16))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+1]) = ((((rgb) >> (8))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+2]) = ((rgb) & (255));
        idx = idx + 1;
    }

    res = [self _upload:[NSString stringWithFormat:@"rgb:0:%d",ledIndex] :buff];
    return res;
}

/**
 * Sets up a smooth RGB color transition to the specified pixel-by-pixel list of RGB
 * color codes. The first color code represents the target RGB value of the first LED,
 * the next color code represents the target value of the next LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param rgbList : a list of target 24bit RGB codes, in the form 0xRRGGBB
 * @param delay   : transition duration in ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) rgbArrayOfs_move:(int)ledIndex :(NSMutableArray*)rgbList :(int)delay
{
    int listlen;
    NSMutableData* buff;
    int idx;
    int rgb;
    int res;
    listlen = (int)[rgbList count];
    buff = [NSMutableData dataWithLength:3*listlen];
    idx = 0;
    while (idx < listlen) {
        rgb = [[rgbList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ 3*idx]) = ((((rgb) >> (16))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+1]) = ((((rgb) >> (8))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+2]) = ((rgb) & (255));
        idx = idx + 1;
    }

    res = [self _upload:[NSString stringWithFormat:@"rgb:%d:%d",delay,ledIndex] :buff];
    return res;
}

/**
 * Sets up a smooth RGB color transition to the specified pixel-by-pixel list of RGB
 * color codes. The first color code represents the target RGB value of the first LED,
 * the next color code represents the target value of the next LED, etc.
 *
 * @param rgbList : a list of target 24bit RGB codes, in the form 0xRRGGBB
 * @param delay   : transition duration in ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) rgbArray_move:(NSMutableArray*)rgbList :(int)delay
{
    int res;

    res = [self rgbArrayOfs_move:0 :rgbList :delay];
    return res;
}

/**
 * Sends a binary buffer to the LED HSL buffer, as is.
 * First three bytes are HSL components for the LED specified as parameter, the
 * next three bytes for the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param buff : the binary buffer to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColorBuffer:(int)ledIndex :(NSData*)buff
{
    return [self _upload:[NSString stringWithFormat:@"hsl:0:%d",ledIndex] :buff];
}

/**
 * Sends 24bit HSL colors (provided as a list of integers) to the LED HSL buffer, as is.
 * The first number represents the HSL value of the LED specified as parameter, the second number represents
 * the HSL value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param hslList : a list of 24bit HSL codes, in the form 0xHHSSLL
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_hslColorArray:(int)ledIndex :(NSMutableArray*)hslList
{
    int listlen;
    NSMutableData* buff;
    int idx;
    int hsl;
    int res;
    listlen = (int)[hslList count];
    buff = [NSMutableData dataWithLength:3*listlen];
    idx = 0;
    while (idx < listlen) {
        hsl = [[hslList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ 3*idx]) = ((((hsl) >> (16))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+1]) = ((((hsl) >> (8))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+2]) = ((hsl) & (255));
        idx = idx + 1;
    }

    res = [self _upload:[NSString stringWithFormat:@"hsl:0:%d",ledIndex] :buff];
    return res;
}

/**
 * Sets up a smooth HSL color transition to the specified pixel-by-pixel list of HSL
 * color codes. The first color code represents the target HSL value of the first LED,
 * the second color code represents the target value of the second LED, etc.
 *
 * @param hslList : a list of target 24bit HSL codes, in the form 0xHHSSLL
 * @param delay   : transition duration in ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) hslArray_move:(NSMutableArray*)hslList :(int)delay
{
    int res;

    res = [self hslArrayOfs_move:0 :hslList :delay];
    return res;
}

/**
 * Sets up a smooth HSL color transition to the specified pixel-by-pixel list of HSL
 * color codes. The first color code represents the target HSL value of the first LED,
 * the second color code represents the target value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be updated
 * @param hslList : a list of target 24bit HSL codes, in the form 0xHHSSLL
 * @param delay   : transition duration in ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) hslArrayOfs_move:(int)ledIndex :(NSMutableArray*)hslList :(int)delay
{
    int listlen;
    NSMutableData* buff;
    int idx;
    int hsl;
    int res;
    listlen = (int)[hslList count];
    buff = [NSMutableData dataWithLength:3*listlen];
    idx = 0;
    while (idx < listlen) {
        hsl = [[hslList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ 3*idx]) = ((((hsl) >> (16))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+1]) = ((((hsl) >> (8))) & (255));
        (((u8*)([buff mutableBytes]))[ 3*idx+2]) = ((hsl) & (255));
        idx = idx + 1;
    }

    res = [self _upload:[NSString stringWithFormat:@"hsl:%d:%d",delay,ledIndex] :buff];
    return res;
}

/**
 * Returns a binary buffer with content from the LED RGB buffer, as is.
 * First three bytes are RGB components for the first LED in the interval,
 * the next three bytes for the second LED in the interval, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a binary buffer with RGB components of selected LEDs.
 *
 * On failure, throws an exception or returns an empty binary buffer.
 */
-(NSMutableData*) get_rgbColorBuffer:(int)ledIndex :(int)count
{
    return [self _download:[NSString stringWithFormat:@"rgb.bin?typ=0&pos=%d&len=%d",3*ledIndex,3*count]];
}

/**
 * Returns a list on 24bit RGB color values with the current colors displayed on
 * the RGB LEDs. The first number represents the RGB value of the first LED,
 * the second number represents the RGB value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of 24bit color codes with RGB components of selected LEDs, as 0xRRGGBB.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_rgbColorArray:(int)ledIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int r;
    int g;
    int b;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=0&pos=%d&len=%d",3*ledIndex,3*count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        r = (((u8*)([buff bytes]))[3*idx]);
        g = (((u8*)([buff bytes]))[3*idx+1]);
        b = (((u8*)([buff bytes]))[3*idx+2]);
        [res addObject:[NSNumber numberWithLong:r*65536+g*256+b]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list on 24bit RGB color values with the RGB LEDs startup colors.
 * The first number represents the startup RGB value of the first LED,
 * the second number represents the RGB value of the second LED, etc.
 *
 * @param ledIndex : index of the first LED  which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of 24bit color codes with RGB components of selected LEDs, as 0xRRGGBB.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_rgbColorArrayAtPowerOn:(int)ledIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int r;
    int g;
    int b;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=4&pos=%d&len=%d",3*ledIndex,3*count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        r = (((u8*)([buff bytes]))[3*idx]);
        g = (((u8*)([buff bytes]))[3*idx+1]);
        b = (((u8*)([buff bytes]))[3*idx+2]);
        [res addObject:[NSNumber numberWithLong:r*65536+g*256+b]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list on sequence index for each RGB LED. The first number represents the
 * sequence index for the the first LED, the second number represents the sequence
 * index for the second LED, etc.
 *
 * @param ledIndex : index of the first LED which should be returned
 * @param count    : number of LEDs which should be returned
 *
 * @return a list of integers with sequence index
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_linkedSeqArray:(int)ledIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int seq;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=1&pos=%d&len=%d",ledIndex,count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        seq = (((u8*)([buff bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:seq]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list on 32 bit signatures for specified blinking sequences.
 * Since blinking sequences cannot be read from the device, this can be used
 * to detect if a specific blinking sequence is already programmed.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of 32 bit integer signatures
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_blinkSeqSignatures:(int)seqIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int hh;
    int hl;
    int lh;
    int ll;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=2&pos=%d&len=%d",4*seqIndex,4*count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        hh = (((u8*)([buff bytes]))[4*idx]);
        hl = (((u8*)([buff bytes]))[4*idx+1]);
        lh = (((u8*)([buff bytes]))[4*idx+2]);
        ll = (((u8*)([buff bytes]))[4*idx+3]);
        [res addObject:[NSNumber numberWithLong:((hh) << (24))+((hl) << (16))+((lh) << (8))+ll]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list of integers with the current speed for specified blinking sequences.
 *
 * @param seqIndex : index of the first sequence speed which should be returned
 * @param count    : number of sequence speeds which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_blinkSeqStateSpeed:(int)seqIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int lh;
    int ll;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=6&pos=%d&len=%d",seqIndex,count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        lh = (((u8*)([buff bytes]))[2*idx]);
        ll = (((u8*)([buff bytes]))[2*idx+1]);
        [res addObject:[NSNumber numberWithLong:((lh) << (8))+ll]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list of integers with the "auto-start at power on" flag state for specified blinking sequences.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_blinkSeqStateAtPowerOn:(int)seqIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int started;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=5&pos=%d&len=%d",seqIndex,count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        started = (((u8*)([buff bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:started]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Returns a list of integers with the started state for specified blinking sequences.
 *
 * @param seqIndex : index of the first blinking sequence which should be returned
 * @param count    : number of blinking sequences which should be returned
 *
 * @return a list of integers, 0 for sequences turned off and 1 for sequences running
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_blinkSeqState:(int)seqIndex :(int)count
{
    NSMutableData* buff;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int started;

    buff = [self _download:[NSString stringWithFormat:@"rgb.bin?typ=3&pos=%d&len=%d",seqIndex,count]];
    [res removeAllObjects];
    idx = 0;
    while (idx < count) {
        started = (((u8*)([buff bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:started]];
        idx = idx + 1;
    }
    return res;
}

-(int) hsl2rgbInt:(int)temp1 :(int)temp2 :(int)temp3
{
    if (temp3 >= 170) {
        return (((temp1 + 127)) / (255));
    }
    if (temp3 > 42) {
        if (temp3 <= 127) {
            return (((temp2 + 127)) / (255));
        }
        temp3 = 170 - temp3;
    }
    return (((temp1*255 + (temp2-temp1) * (6 * temp3) + 32512)) / (65025));
}

-(int) hsl2rgb:(int)hslValue
{
    int R;
    int G;
    int B;
    int H;
    int S;
    int L;
    int temp1;
    int temp2;
    int temp3;
    int res;
    L = ((hslValue) & (0xff));
    S = ((((hslValue) >> (8))) & (0xff));
    H = ((((hslValue) >> (16))) & (0xff));
    if (S==0) {
        res = ((L) << (16))+((L) << (8))+L;
        return res;
    }
    if (L<=127) {
        temp2 = L * (255 + S);
    } else {
        temp2 = (L+S) * 255 - L*S;
    }
    temp1 = 510 * L - temp2;
    // R
    temp3 = (H + 85);
    if (temp3 > 255) {
        temp3 = temp3-255;
    }
    R = [self hsl2rgbInt:temp1 : temp2 :temp3];
    // G
    temp3 = H;
    if (temp3 > 255) {
        temp3 = temp3-255;
    }
    G = [self hsl2rgbInt:temp1 : temp2 :temp3];
    // B
    if (H >= 85) {
        temp3 = H - 85 ;
    } else {
        temp3 = H + 170;
    }
    B = [self hsl2rgbInt:temp1 : temp2 :temp3];
    // just in case
    if (R>255) {
        R=255;
    }
    if (G>255) {
        G=255;
    }
    if (B>255) {
        B=255;
    }
    res = ((R) << (16))+((G) << (8))+B;
    return res;
}


-(YColorLedCluster*)   nextColorLedCluster
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YColorLedCluster FindColorLedCluster:hwid];
}

+(YColorLedCluster *) FirstColorLedCluster
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"ColorLedCluster":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YColorLedCluster FindColorLedCluster:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YColorLedCluster public methods implementation)

@end
//--- (YColorLedCluster functions)

YColorLedCluster *yFindColorLedCluster(NSString* func)
{
    return [YColorLedCluster FindColorLedCluster:func];
}

YColorLedCluster *yFirstColorLedCluster(void)
{
    return [YColorLedCluster FirstColorLedCluster];
}

//--- (end of YColorLedCluster functions)
