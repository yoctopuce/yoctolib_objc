/*********************************************************************
 *
 * $Id: yocto_hubport.m 9489 2013-01-22 11:03:40Z seb $
 *
 * Implements yFindHubPort(), the high-level API for HubPort functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/


#import "yocto_hubport.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


static NSMutableDictionary* _HubPortCache = nil;

@implementation YHubPort

// Constructor is protected, use yFindHubPort factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (YHubPort attributes)
   if(!(self = [super initProtected:@"HubPort":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _enabled = Y_ENABLED_INVALID;
    _portState = Y_PORTSTATE_INVALID;
    _baudRate = Y_BAUDRATE_INVALID;
//--- (end of YHubPort attributes)
    return self;
}
//--- (YHubPort implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "enabled")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _enabled =  (Y_ENABLED_enum)atoi(j->token);
        } else if(!strcmp(j->token, "portState")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _portState =  atoi(j->token);
        } else if(!strcmp(j->token, "baudRate")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _baudRate =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the Yocto-hub port, which is always the serial number of the
 * connected module.
 * 
 * @return a string corresponding to the logical name of the Yocto-hub port, which is always the
 * serial number of the
 *         connected module
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

/**
 * It is not possible to configure the logical name of a Yocto-hub port. The logical
 * name is automatically set to the serial number of the connected module.
 * 
 * @param newval : a string
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the Yocto-hub port (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the Yocto-hub port (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns true if the Yocto-hub port is powered, false otherwise.
 * 
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to true if the Yocto-hub port is
 * powered, false otherwise
 * 
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled
{
    return [self enabled];
}
-(Y_ENABLED_enum) enabled
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ENABLED_INVALID;
    }
    return _enabled;
}

/**
 * Changes the activation of the Yocto-hub port. If the port is enabled, the
 * *      connected module will be powered. Otherwise, port power will be shut down.
 * 
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the activation of the Yocto-hub port
 * 
 * @return YAPI_SUCCESS if the call succeeds.
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
 * Returns the current state of the Yocto-hub port.
 * 
 * @return a value among Y_PORTSTATE_OFF, Y_PORTSTATE_ON and Y_PORTSTATE_RUN corresponding to the
 * current state of the Yocto-hub port
 * 
 * On failure, throws an exception or returns Y_PORTSTATE_INVALID.
 */
-(Y_PORTSTATE_enum) get_portState
{
    return [self portState];
}
-(Y_PORTSTATE_enum) portState
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PORTSTATE_INVALID;
    }
    return _portState;
}

/**
 * Returns the current baud rate used by this Yocto-hub port, in kbps.
 * The default value is 1000 kbps, but a slower rate may be used if communication
 * problems are hit.
 * 
 * @return an integer corresponding to the current baud rate used by this Yocto-hub port, in kbps
 * 
 * On failure, throws an exception or returns Y_BAUDRATE_INVALID.
 */
-(int) get_baudRate
{
    return [self baudRate];
}
-(int) baudRate
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_BAUDRATE_INVALID;
    }
    return _baudRate;
}

-(YHubPort*)   nextHubPort
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindHubPort(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YHubPort*) FindHubPort:(NSString*) func
{
    YHubPort * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    {
        if (_HubPortCache == nil){
            _HubPortCache = [[NSMutableDictionary alloc] init];
        }
        if(nil != [_HubPortCache objectForKey:func]){
            retVal = [_HubPortCache objectForKey:func];
       } else {
           YHubPort *newHubPort = [[YHubPort alloc] initWithFunction:func];
           [_HubPortCache setObject:newHubPort forKey:func];
           retVal = newHubPort;
           ARC_autorelease(retVal);
       }
   }
   return retVal;
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

//--- (end of YHubPort implementation)

@end
//--- (HubPort functions)

YHubPort *yFindHubPort(NSString* func)
{
    return [YHubPort FindHubPort:func];
}

YHubPort *yFirstHubPort(void)
{
    return [YHubPort FirstHubPort];
}

//--- (end of HubPort functions)
