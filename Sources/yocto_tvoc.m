/*********************************************************************
 *
 *  $Id: yocto_tvoc.m 37827 2019-10-25 13:07:48Z mvuilleu $
 *
 *  Implements the high-level API for Tvoc functions
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


#import "yocto_tvoc.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YTvoc

// Constructor is protected, use yFindTvoc factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Tvoc";
//--- (YTvoc attributes initialization)
    _valueCallbackTvoc = NULL;
    _timedReportCallbackTvoc = NULL;
//--- (end of YTvoc attributes initialization)
    return self;
}
//--- (YTvoc yapiwrapper)
//--- (end of YTvoc yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YTvoc cleanup)
    ARC_dealloc(super);
//--- (end of YTvoc cleanup)
}
//--- (YTvoc private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    return [super _parseAttr:j];
}
//--- (end of YTvoc private methods implementation)
//--- (YTvoc public methods implementation)
/**
 * Retrieves a Total  Volatile Organic Compound sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Total  Volatile Organic Compound sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YTvoc.isOnline() to test if the Total  Volatile Organic Compound sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Total  Volatile Organic Compound sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Total  Volatile Organic Compound sensor, for instance
 *         YVOCMK03.tvoc.
 *
 * @return a YTvoc object allowing you to drive the Total  Volatile Organic Compound sensor.
 */
+(YTvoc*) FindTvoc:(NSString*)func
{
    YTvoc* obj;
    obj = (YTvoc*) [YFunction _FindFromCache:@"Tvoc" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YTvoc alloc] initWith:func]);
        [YFunction _AddToCache:@"Tvoc" : func :obj];
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
-(int) registerValueCallback:(YTvocValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackTvoc = callback;
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
    if (_valueCallbackTvoc != NULL) {
        _valueCallbackTvoc(self, value);
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
-(int) registerTimedReportCallback:(YTvocTimedReportCallback)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackTvoc = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackTvoc != NULL) {
        _timedReportCallbackTvoc(self, value);
    } else {
        [super _invokeTimedReportCallback:value];
    }
    return 0;
}


-(YTvoc*)   nextTvoc
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YTvoc FindTvoc:hwid];
}

+(YTvoc *) FirstTvoc
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Tvoc":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YTvoc FindTvoc:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YTvoc public methods implementation)

@end
//--- (YTvoc functions)

YTvoc *yFindTvoc(NSString* func)
{
    return [YTvoc FindTvoc:func];
}

YTvoc *yFirstTvoc(void)
{
    return [YTvoc FirstTvoc];
}

//--- (end of YTvoc functions)
