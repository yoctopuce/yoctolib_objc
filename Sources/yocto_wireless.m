/*********************************************************************
 *
 * $Id: yocto_wireless.m 12337 2013-08-14 15:22:22Z mvuilleu $
 *
 * Implements yFindWireless(), the high-level API for Wireless functions
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
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
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


#import "yocto_wireless.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YWlanRecord

//--- (generated code: YWlanRecord attributes)
//--- (end of generated code: YWlanRecord attributes)

-(id)   initWith:(NSString *)json_str
{
    yJsonStateMachine j;
    if(!(self = [super init]))
        return nil;
    
    // Parse JSON data 
    j.src = STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        return self;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if (!strcmp(j.token, "ssid")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _ssid = STR_y2oc(j.token);
            while(j.next == YJSON_PARSE_STRINGCONT && yJsonParse(&j) == YJSON_PARSE_AVAIL) {
                _ssid =[_ssid stringByAppendingString: STR_y2oc(j.token)];
                ARC_retain(_ssid);
            }
        } else if (!strcmp(j.token, "sec")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _sec = STR_y2oc(j.token);
            while(j.next == YJSON_PARSE_STRINGCONT && yJsonParse(&j) == YJSON_PARSE_AVAIL) {
                _sec =[_sec stringByAppendingString: STR_y2oc(j.token)];
                ARC_retain(_sec);
            }
        } else if(!strcmp(j.token, "channel")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _channel = atoi(j.token);;
        } else if(!strcmp(j.token, "rssi")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _rssi = atoi(j.token);;
        } else {
            yJsonSkip(&j, 1);
        }
    }
    return self;
}




//--- (generated code: YWlanRecord implementation)

-(NSString*) get_ssid
{
    return _ssid;
}

-(int) get_channel
{
    return _channel;
}

-(NSString*) get_security
{
    return _sec;
}

-(int) get_linkQuality
{
    return _rssi;
}

//--- (end of generated code: YWlanRecord implementation)

@end
//--- (generated code: WlanRecord functions)
//--- (end of generated code: WlanRecord functions)





@implementation YWireless

// Constructor is protected, use yFindWireless factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (generated code: YWireless attributes)
   if(!(self = [super initProtected:@"Wireless":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _linkQuality = Y_LINKQUALITY_INVALID;
    _ssid = Y_SSID_INVALID;
    _channel = Y_CHANNEL_INVALID;
    _security = Y_SECURITY_INVALID;
    _message = Y_MESSAGE_INVALID;
    _wlanConfig = Y_WLANCONFIG_INVALID;
//--- (end of generated code: YWireless attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (generated code: YWireless cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_release(_ssid);
    _ssid = nil;
    ARC_release(_message);
    _message = nil;
    ARC_release(_wlanConfig);
    _wlanConfig = nil;
//--- (end of generated code: YWireless cleanup)
    ARC_dealloc(super);
}
//--- (generated code: YWireless implementation)

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
        } else if(!strcmp(j->token, "linkQuality")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _linkQuality =  atoi(j->token);
        } else if(!strcmp(j->token, "ssid")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_ssid);
            _ssid =  [self _parseString:j];
            ARC_retain(_ssid);
        } else if(!strcmp(j->token, "channel")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _channel =  atoi(j->token);
        } else if(!strcmp(j->token, "security")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _security =  atoi(j->token);
        } else if(!strcmp(j->token, "message")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_message);
            _message =  [self _parseString:j];
            ARC_retain(_message);
        } else if(!strcmp(j->token, "wlanConfig")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_wlanConfig);
            _wlanConfig =  [self _parseString:j];
            ARC_retain(_wlanConfig);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the wireless lan interface.
 * 
 * @return a string corresponding to the logical name of the wireless lan interface
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
 * Changes the logical name of the wireless lan interface. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the wireless lan interface
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
 * Returns the current value of the wireless lan interface (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the wireless lan interface (no more than 6 characters)
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
 * Returns the link quality, expressed in per cents.
 * 
 * @return an integer corresponding to the link quality, expressed in per cents
 * 
 * On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
 */
-(int) get_linkQuality
{
    return [self linkQuality];
}
-(int) linkQuality
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LINKQUALITY_INVALID;
    }
    return _linkQuality;
}

/**
 * Returns the wireless network name (SSID).
 * 
 * @return a string corresponding to the wireless network name (SSID)
 * 
 * On failure, throws an exception or returns Y_SSID_INVALID.
 */
-(NSString*) get_ssid
{
    return [self ssid];
}
-(NSString*) ssid
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SSID_INVALID;
    }
    return _ssid;
}

/**
 * Returns the 802.11 channel currently used, or 0 when the selected network has not been found.
 * 
 * @return an integer corresponding to the 802
 * 
 * On failure, throws an exception or returns Y_CHANNEL_INVALID.
 */
-(unsigned) get_channel
{
    return [self channel];
}
-(unsigned) channel
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CHANNEL_INVALID;
    }
    return _channel;
}

/**
 * Returns the security algorithm used by the selected wireless network.
 * 
 * @return a value among Y_SECURITY_UNKNOWN, Y_SECURITY_OPEN, Y_SECURITY_WEP, Y_SECURITY_WPA and
 * Y_SECURITY_WPA2 corresponding to the security algorithm used by the selected wireless network
 * 
 * On failure, throws an exception or returns Y_SECURITY_INVALID.
 */
-(Y_SECURITY_enum) get_security
{
    return [self security];
}
-(Y_SECURITY_enum) security
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SECURITY_INVALID;
    }
    return _security;
}

/**
 * Returns the last status message from the wireless interface.
 * 
 * @return a string corresponding to the last status message from the wireless interface
 * 
 * On failure, throws an exception or returns Y_MESSAGE_INVALID.
 */
-(NSString*) get_message
{
    return [self message];
}
-(NSString*) message
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MESSAGE_INVALID;
    }
    return _message;
}

-(NSString*) get_wlanConfig
{
    return [self wlanConfig];
}
-(NSString*) wlanConfig
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_WLANCONFIG_INVALID;
    }
    return _wlanConfig;
}

-(int) set_wlanConfig:(NSString*) newval
{
    return [self setWlanConfig:newval];
}
-(int) setWlanConfig:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"wlanConfig" :rest_val];
}

/**
 * Changes the configuration of the wireless lan interface to connect to an existing
 * access point (infrastructure mode).
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 * 
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) joinNetwork :(NSString*)ssid :(NSString*)securityKey
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"INFRA:%@\\%@",ssid,securityKey];
    return [self _setAttr:@"wlanConfig" :rest_val];
}

/**
 * Changes the configuration of the wireless lan interface to create an ad-hoc
 * wireless network, without using an access point. If a security key is specified,
 * the network is protected by WEP128, since WPA is not standardized for
 * ad-hoc networks.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 * 
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) adhocNetwork :(NSString*)ssid :(NSString*)securityKey
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"ADHOC:%@\\%@",ssid,securityKey];
    return [self _setAttr:@"wlanConfig" :rest_val];
}
/**
 * Returns a list of YWlanRecord objects which describe detected Wireless networks.
 * This list is not updated when the module is already connected to an acces point (infrastructure mode).
 * To force an update of this list, adhocNetwork() must be called to disconnect
 * the module from the current network. The returned list must be unallocated by caller,
 * 
 * @return a list of YWlanRecord objects, containing the SSID, channel,
 *         link quality and the type of security of the wireless network.
 * 
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_detectedWlans
{
    NSData* json;
    NSMutableArray* list = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    json = [self _download:@"wlan.json?by=name"];
    list = [self _json_get_array:json];
    for (NSString* _each  in list) { [res addObject:ARC_sendAutorelease([[YWlanRecord alloc] initWith:_each])];};
    return res;
    
}


-(YWireless*)   nextWireless
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindWireless(hwid);
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

+(YWireless*) FindWireless:(NSString*) func
{
    YWireless * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YWireless"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YWireless"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YWireless"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YWireless"] objectForKey:func];
    } else {
        retVal = [[YWireless alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YWireless"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YWireless *) FirstWireless
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Wireless":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YWireless FindWireless:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YWireless implementation)

@end
//--- (generated code: Wireless functions)

YWireless *yFindWireless(NSString* func)
{
    return [YWireless FindWireless:func];
}

YWireless *yFirstWireless(void)
{
    return [YWireless FirstWireless];
}

//--- (end of generated code: Wireless functions)
