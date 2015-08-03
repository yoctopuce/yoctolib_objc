/*********************************************************************
 *
 * $Id: yocto_wireless.m 19608 2015-03-05 10:37:24Z seb $
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


-(id)   initWith:(NSString *)json_str
{
    yJsonStateMachine j;
    if(!(self = [super init]))
        return nil;
//--- (generated code: YWlanRecord attributes initialization)
    _channel = 0;
    _rssi = 0;
//--- (end of generated code: YWlanRecord attributes initialization)
    
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


// destructor
-(void)  dealloc
{
//--- (generated code: YWlanRecord cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YWlanRecord cleanup)
}

//--- (generated code: YWlanRecord private methods implementation)

//--- (end of generated code: YWlanRecord private methods implementation)

//--- (generated code: YWlanRecord public methods implementation)
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

//--- (end of generated code: YWlanRecord public methods implementation)

@end
//--- (generated code: WlanRecord functions)
//--- (end of generated code: WlanRecord functions)





@implementation YWireless

// Constructor is protected, use yFindWireless factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"Wireless";
//--- (generated code: YWireless attributes initialization)
    _linkQuality = Y_LINKQUALITY_INVALID;
    _ssid = Y_SSID_INVALID;
    _channel = Y_CHANNEL_INVALID;
    _security = Y_SECURITY_INVALID;
    _message = Y_MESSAGE_INVALID;
    _wlanConfig = Y_WLANCONFIG_INVALID;
    _valueCallbackWireless = NULL;
//--- (end of generated code: YWireless attributes initialization)
    return self;
}

// destructor 
-(void)  dealloc
{
//--- (generated code: YWireless cleanup)
    ARC_release(_ssid);
    _ssid = nil;
    ARC_release(_message);
    _message = nil;
    ARC_release(_wlanConfig);
    _wlanConfig = nil;
    ARC_dealloc(super);
//--- (end of generated code: YWireless cleanup)
}

///--- (generated code: YWireless private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "linkQuality")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _linkQuality =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "ssid")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_ssid);
        _ssid =  [self _parseString:j];
        ARC_retain(_ssid);
        return 1;
    }
    if(!strcmp(j->token, "channel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _channel =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "security")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _security =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "message")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_message);
        _message =  [self _parseString:j];
        ARC_retain(_message);
        return 1;
    }
    if(!strcmp(j->token, "wlanConfig")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_wlanConfig);
        _wlanConfig =  [self _parseString:j];
        ARC_retain(_wlanConfig);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YWireless private methods implementation)

//--- (generated code: YWireless public methods implementation)
/**
 * Returns the link quality, expressed in percent.
 *
 * @return an integer corresponding to the link quality, expressed in percent
 *
 * On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
 */
-(int) get_linkQuality
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LINKQUALITY_INVALID;
        }
    }
    return _linkQuality;
}


-(int) linkQuality
{
    return [self get_linkQuality];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SSID_INVALID;
        }
    }
    return _ssid;
}


-(NSString*) ssid
{
    return [self get_ssid];
}
/**
 * Returns the 802.11 channel currently used, or 0 when the selected network has not been found.
 *
 * @return an integer corresponding to the 802.11 channel currently used, or 0 when the selected
 * network has not been found
 *
 * On failure, throws an exception or returns Y_CHANNEL_INVALID.
 */
-(int) get_channel
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CHANNEL_INVALID;
        }
    }
    return _channel;
}


-(int) channel
{
    return [self get_channel];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SECURITY_INVALID;
        }
    }
    return _security;
}


-(Y_SECURITY_enum) security
{
    return [self get_security];
}
/**
 * Returns the latest status message from the wireless interface.
 *
 * @return a string corresponding to the latest status message from the wireless interface
 *
 * On failure, throws an exception or returns Y_MESSAGE_INVALID.
 */
-(NSString*) get_message
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MESSAGE_INVALID;
        }
    }
    return _message;
}


-(NSString*) message
{
    return [self get_message];
}
-(NSString*) get_wlanConfig
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_WLANCONFIG_INVALID;
        }
    }
    return _wlanConfig;
}


-(NSString*) wlanConfig
{
    return [self get_wlanConfig];
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
 * Retrieves a wireless lan interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the wireless lan interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWireless.isOnline() to test if the wireless lan interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wireless lan interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the wireless lan interface
 *
 * @return a YWireless object allowing you to drive the wireless lan interface.
 */
+(YWireless*) FindWireless:(NSString*)func
{
    YWireless* obj;
    obj = (YWireless*) [YFunction _FindFromCache:@"Wireless" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YWireless alloc] initWith:func]);
        [YFunction _AddToCache:@"Wireless" : func :obj];
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
-(int) registerValueCallback:(YWirelessValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackWireless = callback;
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
    if (_valueCallbackWireless != NULL) {
        _valueCallbackWireless(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Changes the configuration of the wireless lan interface to connect to an existing
 * access point (infrastructure mode).
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) joinNetwork:(NSString*)ssid :(NSString*)securityKey
{
    return [self set_wlanConfig:[NSString stringWithFormat:@"INFRA:%@\\%@", ssid,securityKey]];
}

/**
 * Changes the configuration of the wireless lan interface to create an ad-hoc
 * wireless network, without using an access point. On the YoctoHub-Wireless-g,
 * it is best to use softAPNetworkInstead(), which emulates an access point
 * (Soft AP) which is more efficient and more widely supported than ad-hoc networks.
 *
 * When a security key is specified for an ad-hoc network, the network is protected
 * by a WEP40 key (5 characters or 10 hexadecimal digits) or WEP128 key (13 characters
 * or 26 hexadecimal digits). It is recommended to use a well-randomized WEP128 key
 * using 26 hexadecimal digits to maximize security.
 * Remember to call the saveToFlash() method and then to reboot the module
 * to apply this setting.
 *
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) adhocNetwork:(NSString*)ssid :(NSString*)securityKey
{
    return [self set_wlanConfig:[NSString stringWithFormat:@"ADHOC:%@\\%@", ssid,securityKey]];
}

/**
 * Changes the configuration of the wireless lan interface to create a new wireless
 * network by emulating a WiFi access point (Soft AP). This function can only be
 * used with the YoctoHub-Wireless-g.
 *
 * When a security key is specified for a SoftAP network, the network is protected
 * by a WEP40 key (5 characters or 10 hexadecimal digits) or WEP128 key (13 characters
 * or 26 hexadecimal digits). It is recommended to use a well-randomized WEP128 key
 * using 26 hexadecimal digits to maximize security.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) softAPNetwork:(NSString*)ssid :(NSString*)securityKey
{
    return [self set_wlanConfig:[NSString stringWithFormat:@"SOFTAP:%@\\%@", ssid,securityKey]];
}

/**
 * Returns a list of YWlanRecord objects that describe detected Wireless networks.
 * This list is not updated when the module is already connected to an acces point (infrastructure mode).
 * To force an update of this list, adhocNetwork() must be called to disconnect
 * the module from the current network. The returned list must be unallocated by the caller.
 *
 * @return a list of YWlanRecord objects, containing the SSID, channel,
 *         link quality and the type of security of the wireless network.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_detectedWlans
{
    NSMutableData* json;
    NSMutableArray* wlanlist = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    // may throw an exception
    json = [self _download:@"wlan.json?by=name"];
    wlanlist = [self _json_get_array:json];
    [res removeAllObjects];
    for (NSString* _each  in wlanlist) {
        [res addObject:ARC_sendAutorelease([[YWlanRecord alloc] initWith:_each])];
    }
    return res;
}


-(YWireless*)   nextWireless
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YWireless FindWireless:hwid];
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

//--- (end of generated code: YWireless public methods implementation)

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
