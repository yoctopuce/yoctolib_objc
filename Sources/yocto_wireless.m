/*********************************************************************
 *
 * $Id: yocto_wireless.m 38899 2019-12-20 17:21:03Z mvuilleu $
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
/**
 * Returns the name of the wireless network (SSID).
 *
 * @return a string with the name of the wireless network (SSID).
 */
-(NSString*) get_ssid
{
    return _ssid;
}

/**
 * Returns the 802.11 b/g/n channel number used by this network.
 *
 * @return an integer corresponding to the channel.
 */
-(int) get_channel
{
    return _channel;
}

/**
 * Returns the security algorithm used by the wireless network.
 * If the network implements to security, the value is "OPEN".
 *
 * @return a string with the security algorithm.
 */
-(NSString*) get_security
{
    return _sec;
}

/**
 * Returns the quality of the wireless network link, in per cents.
 *
 * @return an integer between 0 and 100 corresponding to the signal quality.
 */
-(int) get_linkQuality
{
    return _rssi;
}

//--- (end of generated code: YWlanRecord public methods implementation)

@end
//--- (generated code: YWlanRecord functions)
//--- (end of generated code: YWlanRecord functions)





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
    _wlanState = Y_WLANSTATE_INVALID;
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
    if(!strcmp(j->token, "wlanState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _wlanState =  atoi(j->token);
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LINKQUALITY_INVALID;
        }
    }
    res = _linkQuality;
    return res;
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
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SSID_INVALID;
        }
    }
    res = _ssid;
    return res;
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CHANNEL_INVALID;
        }
    }
    res = _channel;
    return res;
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
    Y_SECURITY_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SECURITY_INVALID;
        }
    }
    res = _security;
    return res;
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
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MESSAGE_INVALID;
        }
    }
    res = _message;
    return res;
}


-(NSString*) message
{
    return [self get_message];
}
-(NSString*) get_wlanConfig
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WLANCONFIG_INVALID;
        }
    }
    res = _wlanConfig;
    return res;
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
 * Returns the current state of the wireless interface. The state Y_WLANSTATE_DOWN means that the
 * network interface is
 * not connected to a network. The state Y_WLANSTATE_SCANNING means that the network interface is
 * scanning available
 * frequencies. During this stage, the device is not reachable, and the network settings are not yet
 * applied. The state
 * Y_WLANSTATE_CONNECTED means that the network settings have been successfully applied ant that the
 * device is reachable
 * from the wireless network. If the device is configured to use ad-hoc or Soft AP mode, it means that
 * the wireless network
 * is up and that other devices can join the network. The state Y_WLANSTATE_REJECTED means that the
 * network interface has
 * not been able to join the requested network. The description of the error can be obtain with the
 * get_message() method.
 *
 * @return a value among Y_WLANSTATE_DOWN, Y_WLANSTATE_SCANNING, Y_WLANSTATE_CONNECTED and
 * Y_WLANSTATE_REJECTED corresponding to the current state of the wireless interface
 *
 * On failure, throws an exception or returns Y_WLANSTATE_INVALID.
 */
-(Y_WLANSTATE_enum) get_wlanState
{
    Y_WLANSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WLANSTATE_INVALID;
        }
    }
    res = _wlanState;
    return res;
}


-(Y_WLANSTATE_enum) wlanState
{
    return [self get_wlanState];
}
/**
 * Retrieves a wireless LAN interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the wireless LAN interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YWireless.isOnline() to test if the wireless LAN interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a wireless LAN interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the wireless LAN interface, for instance
 *         YHUBWLN1.wireless.
 *
 * @return a YWireless object allowing you to drive the wireless LAN interface.
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
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
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
 * Triggers a scan of the wireless frequency and builds the list of available networks.
 * The scan forces a disconnection from the current network. At then end of the process, the
 * the network interface attempts to reconnect to the previous network. During the scan, the wlanState
 * switches to Y_WLANSTATE_DOWN, then to Y_WLANSTATE_SCANNING. When the scan is completed,
 * get_wlanState() returns either Y_WLANSTATE_DOWN or Y_WLANSTATE_SCANNING. At this
 * point, the list of detected network can be retrieved with the get_detectedWlans() method.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) startWlanScan
{
    NSString* config;
    config = [self get_wlanConfig];
    // a full scan is triggered when a config is applied
    return [self set_wlanConfig:config];
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
 * wireless network, without using an access point. On the YoctoHub-Wireless-g
 * and YoctoHub-Wireless-n,
 * you should use softAPNetwork() instead, which emulates an access point
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
 * used with the YoctoHub-Wireless-g and the YoctoHub-Wireless-n.
 *
 * On the YoctoHub-Wireless-g, when a security key is specified for a SoftAP network,
 * the network is protected by a WEP40 key (5 characters or 10 hexadecimal digits) or
 * WEP128 key (13 characters or 26 hexadecimal digits). It is recommended to use a
 * well-randomized WEP128 key using 26 hexadecimal digits to maximize security.
 *
 * On the YoctoHub-Wireless-n, when a security key is specified for a SoftAP network,
 * the network will be protected by WPA2.
 *
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
 * This list is not updated when the module is already connected to an access point (infrastructure mode).
 * To force an update of this list, startWlanScan() must be called.
 * Note that an languages without garbage collections, the returned list must be freed by the caller.
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
//--- (generated code: YWireless functions)

YWireless *yFindWireless(NSString* func)
{
    return [YWireless FindWireless:func];
}

YWireless *yFirstWireless(void)
{
    return [YWireless FirstWireless];
}

//--- (end of generated code: YWireless functions)
