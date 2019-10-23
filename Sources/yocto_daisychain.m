/*********************************************************************
 *
 *  $Id: yocto_daisychain.m 37619 2019-10-11 11:52:42Z mvuilleu $
 *
 *  Implements the high-level API for DaisyChain functions
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


#import "yocto_daisychain.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YDaisyChain

// Constructor is protected, use yFindDaisyChain factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"DaisyChain";
//--- (YDaisyChain attributes initialization)
    _daisyState = Y_DAISYSTATE_INVALID;
    _childCount = Y_CHILDCOUNT_INVALID;
    _requiredChildCount = Y_REQUIREDCHILDCOUNT_INVALID;
    _valueCallbackDaisyChain = NULL;
//--- (end of YDaisyChain attributes initialization)
    return self;
}
//--- (YDaisyChain yapiwrapper)
//--- (end of YDaisyChain yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YDaisyChain cleanup)
    ARC_dealloc(super);
//--- (end of YDaisyChain cleanup)
}
//--- (YDaisyChain private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "daisyState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _daisyState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "childCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _childCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "requiredChildCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _requiredChildCount =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YDaisyChain private methods implementation)
//--- (YDaisyChain public methods implementation)
/**
 * Returns the state of the daisy-link between modules.
 *
 * @return a value among Y_DAISYSTATE_READY, Y_DAISYSTATE_IS_CHILD, Y_DAISYSTATE_FIRMWARE_MISMATCH,
 * Y_DAISYSTATE_CHILD_MISSING and Y_DAISYSTATE_CHILD_LOST corresponding to the state of the daisy-link
 * between modules
 *
 * On failure, throws an exception or returns Y_DAISYSTATE_INVALID.
 */
-(Y_DAISYSTATE_enum) get_daisyState
{
    Y_DAISYSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DAISYSTATE_INVALID;
        }
    }
    res = _daisyState;
    return res;
}


-(Y_DAISYSTATE_enum) daisyState
{
    return [self get_daisyState];
}
/**
 * Returns the number of child nodes currently detected.
 *
 * @return an integer corresponding to the number of child nodes currently detected
 *
 * On failure, throws an exception or returns Y_CHILDCOUNT_INVALID.
 */
-(int) get_childCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CHILDCOUNT_INVALID;
        }
    }
    res = _childCount;
    return res;
}


-(int) childCount
{
    return [self get_childCount];
}
/**
 * Returns the number of child nodes expected in normal conditions.
 *
 * @return an integer corresponding to the number of child nodes expected in normal conditions
 *
 * On failure, throws an exception or returns Y_REQUIREDCHILDCOUNT_INVALID.
 */
-(int) get_requiredChildCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REQUIREDCHILDCOUNT_INVALID;
        }
    }
    res = _requiredChildCount;
    return res;
}


-(int) requiredChildCount
{
    return [self get_requiredChildCount];
}

/**
 * Changes the number of child nodes expected in normal conditions.
 * If the value is zero, no check is performed. If it is non-zero, the number
 * child nodes is checked on startup and the status will change to error if
 * the count does not match. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the number of child nodes expected in normal conditions
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_requiredChildCount:(int) newval
{
    return [self setRequiredChildCount:newval];
}
-(int) setRequiredChildCount:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"requiredChildCount" :rest_val];
}
/**
 * Retrieves a module chain for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the module chain is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDaisyChain.isOnline() to test if the module chain is
 * indeed online at a given time. In case of ambiguity when looking for
 * a module chain by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the module chain
 *
 * @return a YDaisyChain object allowing you to drive the module chain.
 */
+(YDaisyChain*) FindDaisyChain:(NSString*)func
{
    YDaisyChain* obj;
    obj = (YDaisyChain*) [YFunction _FindFromCache:@"DaisyChain" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDaisyChain alloc] initWith:func]);
        [YFunction _AddToCache:@"DaisyChain" : func :obj];
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
-(int) registerValueCallback:(YDaisyChainValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDaisyChain = callback;
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
    if (_valueCallbackDaisyChain != NULL) {
        _valueCallbackDaisyChain(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YDaisyChain*)   nextDaisyChain
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDaisyChain FindDaisyChain:hwid];
}

+(YDaisyChain *) FirstDaisyChain
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"DaisyChain":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDaisyChain FindDaisyChain:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YDaisyChain public methods implementation)

@end
//--- (YDaisyChain functions)

YDaisyChain *yFindDaisyChain(NSString* func)
{
    return [YDaisyChain FindDaisyChain:func];
}

YDaisyChain *yFirstDaisyChain(void)
{
    return [YDaisyChain FirstDaisyChain];
}

//--- (end of YDaisyChain functions)
