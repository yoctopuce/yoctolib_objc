/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for SoundLevel functions
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


#import "yocto_soundlevel.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YSoundLevel
// Constructor is protected, use yFindSoundLevel factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SoundLevel";
//--- (YSoundLevel attributes initialization)
    _label = Y_LABEL_INVALID;
    _integrationTime = Y_INTEGRATIONTIME_INVALID;
    _valueCallbackSoundLevel = NULL;
    _timedReportCallbackSoundLevel = NULL;
//--- (end of YSoundLevel attributes initialization)
    return self;
}
//--- (YSoundLevel yapiwrapper)
//--- (end of YSoundLevel yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YSoundLevel cleanup)
    ARC_release(_label);
    _label = nil;
    ARC_dealloc(super);
//--- (end of YSoundLevel cleanup)
}
//--- (YSoundLevel private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "label")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_label);
        _label =  [self _parseString:j];
        ARC_retain(_label);
        return 1;
    }
    if(!strcmp(j->token, "integrationTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _integrationTime =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YSoundLevel private methods implementation)
//--- (YSoundLevel public methods implementation)

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
-(int) set_unit:(NSString*) newval
{
    return [self setUnit:newval];
}
-(int) setUnit:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"unit" :rest_val];
}
/**
 * Returns the label for the sound pressure level measurement, as per
 * IEC standard 61672-1:2013.
 *
 * @return a string corresponding to the label for the sound pressure level measurement, as per
 *         IEC standard 61672-1:2013
 *
 * On failure, throws an exception or returns YSoundLevel.LABEL_INVALID.
 */
-(NSString*) get_label
{
    NSString* res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LABEL_INVALID;
        }
    }
    res = _label;
    return res;
}


-(NSString*) label
{
    return [self get_label];
}
/**
 * Returns the integration time in milliseconds for measuring the sound pressure level.
 *
 * @return an integer corresponding to the integration time in milliseconds for measuring the sound pressure level
 *
 * On failure, throws an exception or returns YSoundLevel.INTEGRATIONTIME_INVALID.
 */
-(int) get_integrationTime
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_INTEGRATIONTIME_INVALID;
        }
    }
    res = _integrationTime;
    return res;
}


-(int) integrationTime
{
    return [self get_integrationTime];
}
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
+(YSoundLevel*) FindSoundLevel:(NSString*)func
{
    YSoundLevel* obj;
    obj = (YSoundLevel*) [YFunction _FindFromCache:@"SoundLevel" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSoundLevel alloc] initWith:func]);
        [YFunction _AddToCache:@"SoundLevel" :func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YSoundLevelValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSoundLevel = callback;
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
    if (_valueCallbackSoundLevel != NULL) {
        _valueCallbackSoundLevel(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

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
-(int) registerTimedReportCallback:(YSoundLevelTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackSoundLevel = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackSoundLevel != NULL) {
        _timedReportCallbackSoundLevel(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YSoundLevel*)   nextSoundLevel
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSoundLevel FindSoundLevel:hwid];
}

+(YSoundLevel *) FirstSoundLevel
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SoundLevel":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSoundLevel FindSoundLevel:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSoundLevel public methods implementation)
@end

//--- (YSoundLevel functions)

YSoundLevel *yFindSoundLevel(NSString* func)
{
    return [YSoundLevel FindSoundLevel:func];
}

YSoundLevel *yFirstSoundLevel(void)
{
    return [YSoundLevel FirstSoundLevel];
}

//--- (end of YSoundLevel functions)

