/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for GroundSpeed functions
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


#import "yocto_groundspeed.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YGroundSpeed
// Constructor is protected, use yFindGroundSpeed factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"GroundSpeed";
//--- (YGroundSpeed attributes initialization)
    _valueCallbackGroundSpeed = NULL;
    _timedReportCallbackGroundSpeed = NULL;
//--- (end of YGroundSpeed attributes initialization)
    return self;
}
//--- (YGroundSpeed yapiwrapper)
//--- (end of YGroundSpeed yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YGroundSpeed cleanup)
    ARC_dealloc(super);
//--- (end of YGroundSpeed cleanup)
}
//--- (YGroundSpeed private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    return [super _parseAttr:j];
}
//--- (end of YGroundSpeed private methods implementation)
//--- (YGroundSpeed public methods implementation)
/**
 * Retrieves a ground speed sensor for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the ground speed sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGroundSpeed.isOnline() to test if the ground speed sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a ground speed sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the ground speed sensor, for instance
 *         YGNSSMK2.groundSpeed.
 *
 * @return a YGroundSpeed object allowing you to drive the ground speed sensor.
 */
+(YGroundSpeed*) FindGroundSpeed:(NSString*)func
{
    YGroundSpeed* obj;
    obj = (YGroundSpeed*) [YFunction _FindFromCache:@"GroundSpeed" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YGroundSpeed alloc] initWith:func]);
        [YFunction _AddToCache:@"GroundSpeed" :func :obj];
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
-(int) registerValueCallback:(YGroundSpeedValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackGroundSpeed = callback;
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
    if (_valueCallbackGroundSpeed != NULL) {
        _valueCallbackGroundSpeed(self, value);
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
-(int) registerTimedReportCallback:(YGroundSpeedTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackGroundSpeed = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackGroundSpeed != NULL) {
        _timedReportCallbackGroundSpeed(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YGroundSpeed*)   nextGroundSpeed
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YGroundSpeed FindGroundSpeed:hwid];
}

+(YGroundSpeed *) FirstGroundSpeed
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"GroundSpeed":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YGroundSpeed FindGroundSpeed:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YGroundSpeed public methods implementation)
@end

//--- (YGroundSpeed functions)

YGroundSpeed *yFindGroundSpeed(NSString* func)
{
    return [YGroundSpeed FindGroundSpeed:func];
}

YGroundSpeed *yFirstGroundSpeed(void)
{
    return [YGroundSpeed FirstGroundSpeed];
}

//--- (end of YGroundSpeed functions)

