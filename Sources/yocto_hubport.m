/*********************************************************************
 *
 *  $Id: yocto_hubport.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for HubPort functions
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


#import "yocto_hubport.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YHubPort
// Constructor is protected, use yFindHubPort factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"HubPort";
//--- (YHubPort attributes initialization)
    _enabled = Y_ENABLED_INVALID;
    _portState = Y_PORTSTATE_INVALID;
    _baudRate = Y_BAUDRATE_INVALID;
    _valueCallbackHubPort = NULL;
//--- (end of YHubPort attributes initialization)
    return self;
}
//--- (YHubPort yapiwrapper)
//--- (end of YHubPort yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YHubPort cleanup)
    ARC_dealloc(super);
//--- (end of YHubPort cleanup)
}
//--- (YHubPort private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "enabled")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enabled =  (Y_ENABLED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "baudRate")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _baudRate =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YHubPort private methods implementation)
//--- (YHubPort public methods implementation)
/**
 * Returns true if the YoctoHub port is powered, false otherwise.
 *
 * @return either YHubPort.ENABLED_FALSE or YHubPort.ENABLED_TRUE, according to true if the YoctoHub
 * port is powered, false otherwise
 *
 * On failure, throws an exception or returns YHubPort.ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    Y_ENABLED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLED_INVALID;
        }
    }
    res = _enabled;
    return res;
}


-(Y_ENABLED_enum) enabled
{
    return [self get_enabled];
}

/**
 * Changes the activation of the YoctoHub port. If the port is enabled, the
 * connected module is powered. Otherwise, port power is shut down.
 *
 * @param newval : either YHubPort.ENABLED_FALSE or YHubPort.ENABLED_TRUE, according to the activation
 * of the YoctoHub port
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enabled:(Y_ENABLED_enum) newval
{
    return [self setEnabled:newval];
}
-(int) setEnabled:(Y_ENABLED_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"enabled" :rest_val];
}
/**
 * Returns the current state of the YoctoHub port.
 *
 * @return a value among YHubPort.PORTSTATE_OFF, YHubPort.PORTSTATE_OVRLD, YHubPort.PORTSTATE_ON,
 * YHubPort.PORTSTATE_RUN and YHubPort.PORTSTATE_PROG corresponding to the current state of the YoctoHub port
 *
 * On failure, throws an exception or returns YHubPort.PORTSTATE_INVALID.
 */
-(Y_PORTSTATE_enum) get_portState
{
    Y_PORTSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTSTATE_INVALID;
        }
    }
    res = _portState;
    return res;
}


-(Y_PORTSTATE_enum) portState
{
    return [self get_portState];
}
/**
 * Returns the current baud rate used by this YoctoHub port, in kbps.
 * The default value is 1000 kbps, but a slower rate may be used if communication
 * problems are encountered.
 *
 * @return an integer corresponding to the current baud rate used by this YoctoHub port, in kbps
 *
 * On failure, throws an exception or returns YHubPort.BAUDRATE_INVALID.
 */
-(int) get_baudRate
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BAUDRATE_INVALID;
        }
    }
    res = _baudRate;
    return res;
}


-(int) baudRate
{
    return [self get_baudRate];
}
/**
 * Retrieves a YoctoHub slave port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the YoctoHub slave port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHubPort.isOnline() to test if the YoctoHub slave port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a YoctoHub slave port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the YoctoHub slave port, for instance
 *         YHUBETH1.hubPort1.
 *
 * @return a YHubPort object allowing you to drive the YoctoHub slave port.
 */
+(YHubPort*) FindHubPort:(NSString*)func
{
    YHubPort* obj;
    obj = (YHubPort*) [YFunction _FindFromCache:@"HubPort" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YHubPort alloc] initWith:func]);
        [YFunction _AddToCache:@"HubPort" : func :obj];
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
-(int) registerValueCallback:(YHubPortValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackHubPort = callback;
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
    if (_valueCallbackHubPort != NULL) {
        _valueCallbackHubPort(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YHubPort*)   nextHubPort
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YHubPort FindHubPort:hwid];
}

+(YHubPort *) FirstHubPort
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"HubPort":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YHubPort FindHubPort:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YHubPort public methods implementation)
@end

//--- (YHubPort functions)

YHubPort *yFindHubPort(NSString* func)
{
    return [YHubPort FindHubPort:func];
}

YHubPort *yFirstHubPort(void)
{
    return [YHubPort FirstHubPort];
}

//--- (end of YHubPort functions)

