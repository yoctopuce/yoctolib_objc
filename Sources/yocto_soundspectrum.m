/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for SoundSpectrum functions
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


#import "yocto_soundspectrum.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YSoundSpectrum
// Constructor is protected, use yFindSoundSpectrum factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SoundSpectrum";
//--- (YSoundSpectrum attributes initialization)
    _integrationTime = Y_INTEGRATIONTIME_INVALID;
    _spectrumData = Y_SPECTRUMDATA_INVALID;
    _valueCallbackSoundSpectrum = NULL;
//--- (end of YSoundSpectrum attributes initialization)
    return self;
}
//--- (YSoundSpectrum yapiwrapper)
//--- (end of YSoundSpectrum yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YSoundSpectrum cleanup)
    ARC_release(_spectrumData);
    _spectrumData = nil;
    ARC_dealloc(super);
//--- (end of YSoundSpectrum cleanup)
}
//--- (YSoundSpectrum private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "integrationTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _integrationTime =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "spectrumData")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_spectrumData);
        _spectrumData =  [self _parseString:j];
        ARC_retain(_spectrumData);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YSoundSpectrum private methods implementation)
//--- (YSoundSpectrum public methods implementation)
/**
 * Returns the integration time in milliseconds for calculating time
 * weighted spectrum data.
 *
 * @return an integer corresponding to the integration time in milliseconds for calculating time
 *         weighted spectrum data
 *
 * On failure, throws an exception or returns YSoundSpectrum.INTEGRATIONTIME_INVALID.
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
-(int) set_integrationTime:(int) newval
{
    return [self setIntegrationTime:newval];
}
-(int) setIntegrationTime:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"integrationTime" :rest_val];
}
-(NSString*) get_spectrumData
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SPECTRUMDATA_INVALID;
        }
    }
    res = _spectrumData;
    return res;
}


-(NSString*) spectrumData
{
    return [self get_spectrumData];
}
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
+(YSoundSpectrum*) FindSoundSpectrum:(NSString*)func
{
    YSoundSpectrum* obj;
    obj = (YSoundSpectrum*) [YFunction _FindFromCache:@"SoundSpectrum" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSoundSpectrum alloc] initWith:func]);
        [YFunction _AddToCache:@"SoundSpectrum" :func :obj];
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
-(int) registerValueCallback:(YSoundSpectrumValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSoundSpectrum = callback;
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
    if (_valueCallbackSoundSpectrum != NULL) {
        _valueCallbackSoundSpectrum(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YSoundSpectrum*)   nextSoundSpectrum
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSoundSpectrum FindSoundSpectrum:hwid];
}

+(YSoundSpectrum *) FirstSoundSpectrum
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SoundSpectrum":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSoundSpectrum FindSoundSpectrum:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSoundSpectrum public methods implementation)
@end

//--- (YSoundSpectrum functions)

YSoundSpectrum *yFindSoundSpectrum(NSString* func)
{
    return [YSoundSpectrum FindSoundSpectrum:func];
}

YSoundSpectrum *yFirstSoundSpectrum(void)
{
    return [YSoundSpectrum FirstSoundSpectrum];
}

//--- (end of YSoundSpectrum functions)

