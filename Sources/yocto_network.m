/*********************************************************************
 *
 * $Id: yocto_network.m 31436 2018-08-07 15:28:18Z seb $
 *
 * Implements the high-level API for Network functions
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


#import "yocto_network.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YNetwork

// Constructor is protected, use yFindNetwork factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Network";
//--- (YNetwork attributes initialization)
    _readiness = Y_READINESS_INVALID;
    _macAddress = Y_MACADDRESS_INVALID;
    _ipAddress = Y_IPADDRESS_INVALID;
    _subnetMask = Y_SUBNETMASK_INVALID;
    _router = Y_ROUTER_INVALID;
    _ipConfig = Y_IPCONFIG_INVALID;
    _primaryDNS = Y_PRIMARYDNS_INVALID;
    _secondaryDNS = Y_SECONDARYDNS_INVALID;
    _ntpServer = Y_NTPSERVER_INVALID;
    _userPassword = Y_USERPASSWORD_INVALID;
    _adminPassword = Y_ADMINPASSWORD_INVALID;
    _httpPort = Y_HTTPPORT_INVALID;
    _defaultPage = Y_DEFAULTPAGE_INVALID;
    _discoverable = Y_DISCOVERABLE_INVALID;
    _wwwWatchdogDelay = Y_WWWWATCHDOGDELAY_INVALID;
    _callbackUrl = Y_CALLBACKURL_INVALID;
    _callbackMethod = Y_CALLBACKMETHOD_INVALID;
    _callbackEncoding = Y_CALLBACKENCODING_INVALID;
    _callbackCredentials = Y_CALLBACKCREDENTIALS_INVALID;
    _callbackInitialDelay = Y_CALLBACKINITIALDELAY_INVALID;
    _callbackSchedule = Y_CALLBACKSCHEDULE_INVALID;
    _callbackMinDelay = Y_CALLBACKMINDELAY_INVALID;
    _callbackMaxDelay = Y_CALLBACKMAXDELAY_INVALID;
    _poeCurrent = Y_POECURRENT_INVALID;
    _valueCallbackNetwork = NULL;
//--- (end of YNetwork attributes initialization)
    return self;
}
//--- (YNetwork yapiwrapper)
//--- (end of YNetwork yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YNetwork cleanup)
    ARC_release(_macAddress);
    _macAddress = nil;
    ARC_release(_ipAddress);
    _ipAddress = nil;
    ARC_release(_subnetMask);
    _subnetMask = nil;
    ARC_release(_router);
    _router = nil;
    ARC_release(_ipConfig);
    _ipConfig = nil;
    ARC_release(_primaryDNS);
    _primaryDNS = nil;
    ARC_release(_secondaryDNS);
    _secondaryDNS = nil;
    ARC_release(_ntpServer);
    _ntpServer = nil;
    ARC_release(_userPassword);
    _userPassword = nil;
    ARC_release(_adminPassword);
    _adminPassword = nil;
    ARC_release(_defaultPage);
    _defaultPage = nil;
    ARC_release(_callbackUrl);
    _callbackUrl = nil;
    ARC_release(_callbackCredentials);
    _callbackCredentials = nil;
    ARC_release(_callbackSchedule);
    _callbackSchedule = nil;
    ARC_dealloc(super);
//--- (end of YNetwork cleanup)
}
//--- (YNetwork private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "readiness")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _readiness =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "macAddress")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_macAddress);
        _macAddress =  [self _parseString:j];
        ARC_retain(_macAddress);
        return 1;
    }
    if(!strcmp(j->token, "ipAddress")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_ipAddress);
        _ipAddress =  [self _parseString:j];
        ARC_retain(_ipAddress);
        return 1;
    }
    if(!strcmp(j->token, "subnetMask")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_subnetMask);
        _subnetMask =  [self _parseString:j];
        ARC_retain(_subnetMask);
        return 1;
    }
    if(!strcmp(j->token, "router")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_router);
        _router =  [self _parseString:j];
        ARC_retain(_router);
        return 1;
    }
    if(!strcmp(j->token, "ipConfig")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_ipConfig);
        _ipConfig =  [self _parseString:j];
        ARC_retain(_ipConfig);
        return 1;
    }
    if(!strcmp(j->token, "primaryDNS")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_primaryDNS);
        _primaryDNS =  [self _parseString:j];
        ARC_retain(_primaryDNS);
        return 1;
    }
    if(!strcmp(j->token, "secondaryDNS")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_secondaryDNS);
        _secondaryDNS =  [self _parseString:j];
        ARC_retain(_secondaryDNS);
        return 1;
    }
    if(!strcmp(j->token, "ntpServer")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_ntpServer);
        _ntpServer =  [self _parseString:j];
        ARC_retain(_ntpServer);
        return 1;
    }
    if(!strcmp(j->token, "userPassword")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_userPassword);
        _userPassword =  [self _parseString:j];
        ARC_retain(_userPassword);
        return 1;
    }
    if(!strcmp(j->token, "adminPassword")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_adminPassword);
        _adminPassword =  [self _parseString:j];
        ARC_retain(_adminPassword);
        return 1;
    }
    if(!strcmp(j->token, "httpPort")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _httpPort =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "defaultPage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_defaultPage);
        _defaultPage =  [self _parseString:j];
        ARC_retain(_defaultPage);
        return 1;
    }
    if(!strcmp(j->token, "discoverable")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _discoverable =  (Y_DISCOVERABLE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "wwwWatchdogDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _wwwWatchdogDelay =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "callbackUrl")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_callbackUrl);
        _callbackUrl =  [self _parseString:j];
        ARC_retain(_callbackUrl);
        return 1;
    }
    if(!strcmp(j->token, "callbackMethod")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _callbackMethod =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "callbackEncoding")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _callbackEncoding =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "callbackCredentials")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_callbackCredentials);
        _callbackCredentials =  [self _parseString:j];
        ARC_retain(_callbackCredentials);
        return 1;
    }
    if(!strcmp(j->token, "callbackInitialDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _callbackInitialDelay =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "callbackSchedule")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_callbackSchedule);
        _callbackSchedule =  [self _parseString:j];
        ARC_retain(_callbackSchedule);
        return 1;
    }
    if(!strcmp(j->token, "callbackMinDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _callbackMinDelay =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "callbackMaxDelay")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _callbackMaxDelay =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "poeCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _poeCurrent =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YNetwork private methods implementation)
//--- (YNetwork public methods implementation)
/**
 * Returns the current established working mode of the network interface.
 * Level zero (DOWN_0) means that no hardware link has been detected. Either there is no signal
 * on the network cable, or the selected wireless access point cannot be detected.
 * Level 1 (LIVE_1) is reached when the network is detected, but is not yet connected.
 * For a wireless network, this shows that the requested SSID is present.
 * Level 2 (LINK_2) is reached when the hardware connection is established.
 * For a wired network connection, level 2 means that the cable is attached at both ends.
 * For a connection to a wireless access point, it shows that the security parameters
 * are properly configured. For an ad-hoc wireless connection, it means that there is
 * at least one other device connected on the ad-hoc network.
 * Level 3 (DHCP_3) is reached when an IP address has been obtained using DHCP.
 * Level 4 (DNS_4) is reached when the DNS server is reachable on the network.
 * Level 5 (WWW_5) is reached when global connectivity is demonstrated by properly loading the
 * current time from an NTP server.
 *
 * @return a value among Y_READINESS_DOWN, Y_READINESS_EXISTS, Y_READINESS_LINKED, Y_READINESS_LAN_OK
 * and Y_READINESS_WWW_OK corresponding to the current established working mode of the network interface
 *
 * On failure, throws an exception or returns Y_READINESS_INVALID.
 */
-(Y_READINESS_enum) get_readiness
{
    Y_READINESS_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_READINESS_INVALID;
        }
    }
    res = _readiness;
    return res;
}


-(Y_READINESS_enum) readiness
{
    return [self get_readiness];
}
/**
 * Returns the MAC address of the network interface. The MAC address is also available on a sticker
 * on the module, in both numeric and barcode forms.
 *
 * @return a string corresponding to the MAC address of the network interface
 *
 * On failure, throws an exception or returns Y_MACADDRESS_INVALID.
 */
-(NSString*) get_macAddress
{
    NSString* res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MACADDRESS_INVALID;
        }
    }
    res = _macAddress;
    return res;
}


-(NSString*) macAddress
{
    return [self get_macAddress];
}
/**
 * Returns the IP address currently in use by the device. The address may have been configured
 * statically, or provided by a DHCP server.
 *
 * @return a string corresponding to the IP address currently in use by the device
 *
 * On failure, throws an exception or returns Y_IPADDRESS_INVALID.
 */
-(NSString*) get_ipAddress
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_IPADDRESS_INVALID;
        }
    }
    res = _ipAddress;
    return res;
}


-(NSString*) ipAddress
{
    return [self get_ipAddress];
}
/**
 * Returns the subnet mask currently used by the device.
 *
 * @return a string corresponding to the subnet mask currently used by the device
 *
 * On failure, throws an exception or returns Y_SUBNETMASK_INVALID.
 */
-(NSString*) get_subnetMask
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SUBNETMASK_INVALID;
        }
    }
    res = _subnetMask;
    return res;
}


-(NSString*) subnetMask
{
    return [self get_subnetMask];
}
/**
 * Returns the IP address of the router on the device subnet (default gateway).
 *
 * @return a string corresponding to the IP address of the router on the device subnet (default gateway)
 *
 * On failure, throws an exception or returns Y_ROUTER_INVALID.
 */
-(NSString*) get_router
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ROUTER_INVALID;
        }
    }
    res = _router;
    return res;
}


-(NSString*) router
{
    return [self get_router];
}
/**
 * Returns the IP configuration of the network interface.
 *
 * If the network interface is setup to use a static IP address, the string starts with "STATIC:" and
 * is followed by three
 * parameters, separated by "/". The first is the device IP address, followed by the subnet mask
 * length, and finally the
 * router IP address (default gateway). For instance: "STATIC:192.168.1.14/16/192.168.1.1"
 *
 * If the network interface is configured to receive its IP from a DHCP server, the string start with
 * "DHCP:" and is followed by
 * three parameters separated by "/". The first is the fallback IP address, then the fallback subnet
 * mask length and finally the
 * fallback router IP address. These three parameters are used when no DHCP reply is received.
 *
 * @return a string corresponding to the IP configuration of the network interface
 *
 * On failure, throws an exception or returns Y_IPCONFIG_INVALID.
 */
-(NSString*) get_ipConfig
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_IPCONFIG_INVALID;
        }
    }
    res = _ipConfig;
    return res;
}


-(NSString*) ipConfig
{
    return [self get_ipConfig];
}

-(int) set_ipConfig:(NSString*) newval
{
    return [self setIpConfig:newval];
}
-(int) setIpConfig:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"ipConfig" :rest_val];
}
/**
 * Returns the IP address of the primary name server to be used by the module.
 *
 * @return a string corresponding to the IP address of the primary name server to be used by the module
 *
 * On failure, throws an exception or returns Y_PRIMARYDNS_INVALID.
 */
-(NSString*) get_primaryDNS
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PRIMARYDNS_INVALID;
        }
    }
    res = _primaryDNS;
    return res;
}


-(NSString*) primaryDNS
{
    return [self get_primaryDNS];
}

/**
 * Changes the IP address of the primary name server to be used by the module.
 * When using DHCP, if a value is specified, it overrides the value received from the DHCP server.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the primary name server to be used by the module
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_primaryDNS:(NSString*) newval
{
    return [self setPrimaryDNS:newval];
}
-(int) setPrimaryDNS:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"primaryDNS" :rest_val];
}
/**
 * Returns the IP address of the secondary name server to be used by the module.
 *
 * @return a string corresponding to the IP address of the secondary name server to be used by the module
 *
 * On failure, throws an exception or returns Y_SECONDARYDNS_INVALID.
 */
-(NSString*) get_secondaryDNS
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SECONDARYDNS_INVALID;
        }
    }
    res = _secondaryDNS;
    return res;
}


-(NSString*) secondaryDNS
{
    return [self get_secondaryDNS];
}

/**
 * Changes the IP address of the secondary name server to be used by the module.
 * When using DHCP, if a value is specified, it overrides the value received from the DHCP server.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the secondary name server to be used by the module
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_secondaryDNS:(NSString*) newval
{
    return [self setSecondaryDNS:newval];
}
-(int) setSecondaryDNS:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"secondaryDNS" :rest_val];
}
/**
 * Returns the IP address of the NTP server to be used by the device.
 *
 * @return a string corresponding to the IP address of the NTP server to be used by the device
 *
 * On failure, throws an exception or returns Y_NTPSERVER_INVALID.
 */
-(NSString*) get_ntpServer
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NTPSERVER_INVALID;
        }
    }
    res = _ntpServer;
    return res;
}


-(NSString*) ntpServer
{
    return [self get_ntpServer];
}

/**
 * Changes the IP address of the NTP server to be used by the module.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the NTP server to be used by the module
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_ntpServer:(NSString*) newval
{
    return [self setNtpServer:newval];
}
-(int) setNtpServer:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"ntpServer" :rest_val];
}
/**
 * Returns a hash string if a password has been set for "user" user,
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hash string if a password has been set for "user" user,
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns Y_USERPASSWORD_INVALID.
 */
-(NSString*) get_userPassword
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_USERPASSWORD_INVALID;
        }
    }
    res = _userPassword;
    return res;
}


-(NSString*) userPassword
{
    return [self get_userPassword];
}

/**
 * Changes the password for the "user" user. This password becomes instantly required
 * to perform any use of the module. If the specified value is an
 * empty string, a password is not required anymore.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the password for the "user" user
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_userPassword:(NSString*) newval
{
    return [self setUserPassword:newval];
}
-(int) setUserPassword:(NSString*) newval
{
    NSString* rest_val;
        if ([newval length] > YAPI_HASH_BUF_SIZE) {
            [self _throw:YAPI_INVALID_ARGUMENT :[@"Password is too long :" stringByAppendingString:newval]];
            return YAPI_INVALID_ARGUMENT;
        }
    rest_val = newval;
    return [self _setAttr:@"userPassword" :rest_val];
}
/**
 * Returns a hash string if a password has been set for user "admin",
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hash string if a password has been set for user "admin",
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns Y_ADMINPASSWORD_INVALID.
 */
-(NSString*) get_adminPassword
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADMINPASSWORD_INVALID;
        }
    }
    res = _adminPassword;
    return res;
}


-(NSString*) adminPassword
{
    return [self get_adminPassword];
}

/**
 * Changes the password for the "admin" user. This password becomes instantly required
 * to perform any change of the module state. If the specified value is an
 * empty string, a password is not required anymore.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the password for the "admin" user
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_adminPassword:(NSString*) newval
{
    return [self setAdminPassword:newval];
}
-(int) setAdminPassword:(NSString*) newval
{
    NSString* rest_val;
        if ([newval length] > YAPI_HASH_BUF_SIZE) {
            [self _throw:YAPI_INVALID_ARGUMENT :[@"Password is too long :" stringByAppendingString:newval]];
            return YAPI_INVALID_ARGUMENT;
        }
    rest_val = newval;
    return [self _setAttr:@"adminPassword" :rest_val];
}
/**
 * Returns the HTML page to serve for the URL "/"" of the hub.
 *
 * @return an integer corresponding to the HTML page to serve for the URL "/"" of the hub
 *
 * On failure, throws an exception or returns Y_HTTPPORT_INVALID.
 */
-(int) get_httpPort
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_HTTPPORT_INVALID;
        }
    }
    res = _httpPort;
    return res;
}


-(int) httpPort
{
    return [self get_httpPort];
}

/**
 * Changes the default HTML page returned by the hub. If not value are set the hub return
 * "index.html" which is the web interface of the hub. It is possible de change this page
 * for file that has been uploaded on the hub.
 *
 * @param newval : an integer corresponding to the default HTML page returned by the hub
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_httpPort:(int) newval
{
    return [self setHttpPort:newval];
}
-(int) setHttpPort:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"httpPort" :rest_val];
}
/**
 * Returns the HTML page to serve for the URL "/"" of the hub.
 *
 * @return a string corresponding to the HTML page to serve for the URL "/"" of the hub
 *
 * On failure, throws an exception or returns Y_DEFAULTPAGE_INVALID.
 */
-(NSString*) get_defaultPage
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DEFAULTPAGE_INVALID;
        }
    }
    res = _defaultPage;
    return res;
}


-(NSString*) defaultPage
{
    return [self get_defaultPage];
}

/**
 * Changes the default HTML page returned by the hub. If not value are set the hub return
 * "index.html" which is the web interface of the hub. It is possible de change this page
 * for file that has been uploaded on the hub.
 *
 * @param newval : a string corresponding to the default HTML page returned by the hub
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_defaultPage:(NSString*) newval
{
    return [self setDefaultPage:newval];
}
-(int) setDefaultPage:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"defaultPage" :rest_val];
}
/**
 * Returns the activation state of the multicast announce protocols to allow easy
 * discovery of the module in the network neighborhood (uPnP/Bonjour protocol).
 *
 * @return either Y_DISCOVERABLE_FALSE or Y_DISCOVERABLE_TRUE, according to the activation state of
 * the multicast announce protocols to allow easy
 *         discovery of the module in the network neighborhood (uPnP/Bonjour protocol)
 *
 * On failure, throws an exception or returns Y_DISCOVERABLE_INVALID.
 */
-(Y_DISCOVERABLE_enum) get_discoverable
{
    Y_DISCOVERABLE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DISCOVERABLE_INVALID;
        }
    }
    res = _discoverable;
    return res;
}


-(Y_DISCOVERABLE_enum) discoverable
{
    return [self get_discoverable];
}

/**
 * Changes the activation state of the multicast announce protocols to allow easy
 * discovery of the module in the network neighborhood (uPnP/Bonjour protocol).
 *
 * @param newval : either Y_DISCOVERABLE_FALSE or Y_DISCOVERABLE_TRUE, according to the activation
 * state of the multicast announce protocols to allow easy
 *         discovery of the module in the network neighborhood (uPnP/Bonjour protocol)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_discoverable:(Y_DISCOVERABLE_enum) newval
{
    return [self setDiscoverable:newval];
}
-(int) setDiscoverable:(Y_DISCOVERABLE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"discoverable" :rest_val];
}
/**
 * Returns the allowed downtime of the WWW link (in seconds) before triggering an automated
 * reboot to try to recover Internet connectivity. A zero value disables automated reboot
 * in case of Internet connectivity loss.
 *
 * @return an integer corresponding to the allowed downtime of the WWW link (in seconds) before
 * triggering an automated
 *         reboot to try to recover Internet connectivity
 *
 * On failure, throws an exception or returns Y_WWWWATCHDOGDELAY_INVALID.
 */
-(int) get_wwwWatchdogDelay
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WWWWATCHDOGDELAY_INVALID;
        }
    }
    res = _wwwWatchdogDelay;
    return res;
}


-(int) wwwWatchdogDelay
{
    return [self get_wwwWatchdogDelay];
}

/**
 * Changes the allowed downtime of the WWW link (in seconds) before triggering an automated
 * reboot to try to recover Internet connectivity. A zero value disables automated reboot
 * in case of Internet connectivity loss. The smallest valid non-zero timeout is
 * 90 seconds.
 *
 * @param newval : an integer corresponding to the allowed downtime of the WWW link (in seconds)
 * before triggering an automated
 *         reboot to try to recover Internet connectivity
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_wwwWatchdogDelay:(int) newval
{
    return [self setWwwWatchdogDelay:newval];
}
-(int) setWwwWatchdogDelay:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"wwwWatchdogDelay" :rest_val];
}
/**
 * Returns the callback URL to notify of significant state changes.
 *
 * @return a string corresponding to the callback URL to notify of significant state changes
 *
 * On failure, throws an exception or returns Y_CALLBACKURL_INVALID.
 */
-(NSString*) get_callbackUrl
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKURL_INVALID;
        }
    }
    res = _callbackUrl;
    return res;
}


-(NSString*) callbackUrl
{
    return [self get_callbackUrl];
}

/**
 * Changes the callback URL to notify significant state changes. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the callback URL to notify significant state changes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackUrl:(NSString*) newval
{
    return [self setCallbackUrl:newval];
}
-(int) setCallbackUrl:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"callbackUrl" :rest_val];
}
/**
 * Returns the HTTP method used to notify callbacks for significant state changes.
 *
 * @return a value among Y_CALLBACKMETHOD_POST, Y_CALLBACKMETHOD_GET and Y_CALLBACKMETHOD_PUT
 * corresponding to the HTTP method used to notify callbacks for significant state changes
 *
 * On failure, throws an exception or returns Y_CALLBACKMETHOD_INVALID.
 */
-(Y_CALLBACKMETHOD_enum) get_callbackMethod
{
    Y_CALLBACKMETHOD_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKMETHOD_INVALID;
        }
    }
    res = _callbackMethod;
    return res;
}


-(Y_CALLBACKMETHOD_enum) callbackMethod
{
    return [self get_callbackMethod];
}

/**
 * Changes the HTTP method used to notify callbacks for significant state changes.
 *
 * @param newval : a value among Y_CALLBACKMETHOD_POST, Y_CALLBACKMETHOD_GET and Y_CALLBACKMETHOD_PUT
 * corresponding to the HTTP method used to notify callbacks for significant state changes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackMethod:(Y_CALLBACKMETHOD_enum) newval
{
    return [self setCallbackMethod:newval];
}
-(int) setCallbackMethod:(Y_CALLBACKMETHOD_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"callbackMethod" :rest_val];
}
/**
 * Returns the encoding standard to use for representing notification values.
 *
 * @return a value among Y_CALLBACKENCODING_FORM, Y_CALLBACKENCODING_JSON,
 * Y_CALLBACKENCODING_JSON_ARRAY, Y_CALLBACKENCODING_CSV, Y_CALLBACKENCODING_YOCTO_API,
 * Y_CALLBACKENCODING_JSON_NUM, Y_CALLBACKENCODING_EMONCMS, Y_CALLBACKENCODING_AZURE,
 * Y_CALLBACKENCODING_INFLUXDB, Y_CALLBACKENCODING_MQTT, Y_CALLBACKENCODING_YOCTO_API_JZON and
 * Y_CALLBACKENCODING_PRTG corresponding to the encoding standard to use for representing notification values
 *
 * On failure, throws an exception or returns Y_CALLBACKENCODING_INVALID.
 */
-(Y_CALLBACKENCODING_enum) get_callbackEncoding
{
    Y_CALLBACKENCODING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKENCODING_INVALID;
        }
    }
    res = _callbackEncoding;
    return res;
}


-(Y_CALLBACKENCODING_enum) callbackEncoding
{
    return [self get_callbackEncoding];
}

/**
 * Changes the encoding standard to use for representing notification values.
 *
 * @param newval : a value among Y_CALLBACKENCODING_FORM, Y_CALLBACKENCODING_JSON,
 * Y_CALLBACKENCODING_JSON_ARRAY, Y_CALLBACKENCODING_CSV, Y_CALLBACKENCODING_YOCTO_API,
 * Y_CALLBACKENCODING_JSON_NUM, Y_CALLBACKENCODING_EMONCMS, Y_CALLBACKENCODING_AZURE,
 * Y_CALLBACKENCODING_INFLUXDB, Y_CALLBACKENCODING_MQTT, Y_CALLBACKENCODING_YOCTO_API_JZON and
 * Y_CALLBACKENCODING_PRTG corresponding to the encoding standard to use for representing notification values
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackEncoding:(Y_CALLBACKENCODING_enum) newval
{
    return [self setCallbackEncoding:newval];
}
-(int) setCallbackEncoding:(Y_CALLBACKENCODING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"callbackEncoding" :rest_val];
}
/**
 * Returns a hashed version of the notification callback credentials if set,
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hashed version of the notification callback credentials if set,
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns Y_CALLBACKCREDENTIALS_INVALID.
 */
-(NSString*) get_callbackCredentials
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKCREDENTIALS_INVALID;
        }
    }
    res = _callbackCredentials;
    return res;
}


-(NSString*) callbackCredentials
{
    return [self get_callbackCredentials];
}

/**
 * Changes the credentials required to connect to the callback address. The credentials
 * must be provided as returned by function get_callbackCredentials,
 * in the form username:hash. The method used to compute the hash varies according
 * to the the authentication scheme implemented by the callback, For Basic authentication,
 * the hash is the MD5 of the string username:password. For Digest authentication,
 * the hash is the MD5 of the string username:realm:password. For a simpler
 * way to configure callback credentials, use function callbackLogin instead.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the credentials required to connect to the callback address
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackCredentials:(NSString*) newval
{
    return [self setCallbackCredentials:newval];
}
-(int) setCallbackCredentials:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"callbackCredentials" :rest_val];
}

/**
 * Connects to the notification callback and saves the credentials required to
 * log into it. The password is not stored into the module, only a hashed
 * copy of the credentials are saved. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param username : username required to log to the callback
 * @param password : password required to log to the callback
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) callbackLogin:(NSString*)username :(NSString*)password
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%@:%@",username,password];
    return [self _setAttr:@"callbackCredentials" :rest_val];
}
/**
 * Returns the initial waiting time before first callback notifications, in seconds.
 *
 * @return an integer corresponding to the initial waiting time before first callback notifications, in seconds
 *
 * On failure, throws an exception or returns Y_CALLBACKINITIALDELAY_INVALID.
 */
-(int) get_callbackInitialDelay
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKINITIALDELAY_INVALID;
        }
    }
    res = _callbackInitialDelay;
    return res;
}


-(int) callbackInitialDelay
{
    return [self get_callbackInitialDelay];
}

/**
 * Changes the initial waiting time before first callback notifications, in seconds.
 *
 * @param newval : an integer corresponding to the initial waiting time before first callback
 * notifications, in seconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackInitialDelay:(int) newval
{
    return [self setCallbackInitialDelay:newval];
}
-(int) setCallbackInitialDelay:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"callbackInitialDelay" :rest_val];
}
/**
 * Returns the HTTP callback schedule strategy, as a text string.
 *
 * @return a string corresponding to the HTTP callback schedule strategy, as a text string
 *
 * On failure, throws an exception or returns Y_CALLBACKSCHEDULE_INVALID.
 */
-(NSString*) get_callbackSchedule
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKSCHEDULE_INVALID;
        }
    }
    res = _callbackSchedule;
    return res;
}


-(NSString*) callbackSchedule
{
    return [self get_callbackSchedule];
}

/**
 * Changes the HTTP callback schedule strategy, as a text string.
 *
 * @param newval : a string corresponding to the HTTP callback schedule strategy, as a text string
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackSchedule:(NSString*) newval
{
    return [self setCallbackSchedule:newval];
}
-(int) setCallbackSchedule:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"callbackSchedule" :rest_val];
}
/**
 * Returns the minimum waiting time between two HTTP callbacks, in seconds.
 *
 * @return an integer corresponding to the minimum waiting time between two HTTP callbacks, in seconds
 *
 * On failure, throws an exception or returns Y_CALLBACKMINDELAY_INVALID.
 */
-(int) get_callbackMinDelay
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKMINDELAY_INVALID;
        }
    }
    res = _callbackMinDelay;
    return res;
}


-(int) callbackMinDelay
{
    return [self get_callbackMinDelay];
}

/**
 * Changes the minimum waiting time between two HTTP callbacks, in seconds.
 *
 * @param newval : an integer corresponding to the minimum waiting time between two HTTP callbacks, in seconds
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackMinDelay:(int) newval
{
    return [self setCallbackMinDelay:newval];
}
-(int) setCallbackMinDelay:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"callbackMinDelay" :rest_val];
}
/**
 * Returns the waiting time between two HTTP callbacks when there is nothing new.
 *
 * @return an integer corresponding to the waiting time between two HTTP callbacks when there is nothing new
 *
 * On failure, throws an exception or returns Y_CALLBACKMAXDELAY_INVALID.
 */
-(int) get_callbackMaxDelay
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALLBACKMAXDELAY_INVALID;
        }
    }
    res = _callbackMaxDelay;
    return res;
}


-(int) callbackMaxDelay
{
    return [self get_callbackMaxDelay];
}

/**
 * Changes the waiting time between two HTTP callbacks when there is nothing new.
 *
 * @param newval : an integer corresponding to the waiting time between two HTTP callbacks when there
 * is nothing new
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackMaxDelay:(int) newval
{
    return [self setCallbackMaxDelay:newval];
}
-(int) setCallbackMaxDelay:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"callbackMaxDelay" :rest_val];
}
/**
 * Returns the current consumed by the module from Power-over-Ethernet (PoE), in milli-amps.
 * The current consumption is measured after converting PoE source to 5 Volt, and should
 * never exceed 1800 mA.
 *
 * @return an integer corresponding to the current consumed by the module from Power-over-Ethernet
 * (PoE), in milli-amps
 *
 * On failure, throws an exception or returns Y_POECURRENT_INVALID.
 */
-(int) get_poeCurrent
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_POECURRENT_INVALID;
        }
    }
    res = _poeCurrent;
    return res;
}


-(int) poeCurrent
{
    return [self get_poeCurrent];
}
/**
 * Retrieves a network interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the network interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YNetwork.isOnline() to test if the network interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a network interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the network interface
 *
 * @return a YNetwork object allowing you to drive the network interface.
 */
+(YNetwork*) FindNetwork:(NSString*)func
{
    YNetwork* obj;
    obj = (YNetwork*) [YFunction _FindFromCache:@"Network" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YNetwork alloc] initWith:func]);
        [YFunction _AddToCache:@"Network" : func :obj];
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
-(int) registerValueCallback:(YNetworkValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackNetwork = callback;
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
    if (_valueCallbackNetwork != NULL) {
        _valueCallbackNetwork(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Changes the configuration of the network interface to enable the use of an
 * IP address received from a DHCP server. Until an address is received from a DHCP
 * server, the module uses the IP parameters specified to this function.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param fallbackIpAddr : fallback IP address, to be used when no DHCP reply is received
 * @param fallbackSubnetMaskLen : fallback subnet mask length when no DHCP reply is received, as an
 *         integer (eg. 24 means 255.255.255.0)
 * @param fallbackRouter : fallback router IP address, to be used when no DHCP reply is received
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) useDHCP:(NSString*)fallbackIpAddr :(int)fallbackSubnetMaskLen :(NSString*)fallbackRouter
{
    return [self set_ipConfig:[NSString stringWithFormat:@"DHCP:%@/%d/%@", fallbackIpAddr, fallbackSubnetMaskLen,fallbackRouter]];
}

/**
 * Changes the configuration of the network interface to enable the use of an
 * IP address received from a DHCP server. Until an address is received from a DHCP
 * server, the module uses an IP of the network 169.254.0.0/16 (APIPA).
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) useDHCPauto
{
    return [self set_ipConfig:@"DHCP:"];
}

/**
 * Changes the configuration of the network interface to use a static IP address.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param ipAddress : device IP address
 * @param subnetMaskLen : subnet mask length, as an integer (eg. 24 means 255.255.255.0)
 * @param router : router IP address (default gateway)
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) useStaticIP:(NSString*)ipAddress :(int)subnetMaskLen :(NSString*)router
{
    return [self set_ipConfig:[NSString stringWithFormat:@"STATIC:%@/%d/%@", ipAddress, subnetMaskLen,router]];
}

/**
 * Pings host to test the network connectivity. Sends four ICMP ECHO_REQUEST requests from the
 * module to the target host. This method returns a string with the result of the
 * 4 ICMP ECHO_REQUEST requests.
 *
 * @param host : the hostname or the IP address of the target
 *
 * @return a string with the result of the ping.
 */
-(NSString*) ping:(NSString*)host
{
    NSMutableData* content;

    content = [self _download:[NSString stringWithFormat:@"ping.txt?host=%@",host]];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
}

/**
 * Trigger an HTTP callback quickly. This function can even be called within
 * an HTTP callback, in which case the next callback will be triggered 5 seconds
 * after the end of the current callback, regardless if the minimum time between
 * callbacks configured in the device.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerCallback
{
    return [self set_callbackMethod:[self get_callbackMethod]];
}

/**
 * Setup periodic HTTP callbacks (simplifed function).
 *
 * @param interval : a string representing the callback periodicity, expressed in
 *         seconds, minutes or hours, eg. "60s", "5m", "1h", "48h".
 * @param offset : an integer representing the time offset relative to the period
 *         when the callback should occur. For instance, if the periodicity is
 *         24h, an offset of 7 will make the callback occur each day at 7AM.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_periodicCallbackSchedule:(NSString*)interval :(int)offset
{
    return [self set_callbackSchedule:[NSString stringWithFormat:@"every %@+%d",interval,offset]];
}


-(YNetwork*)   nextNetwork
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YNetwork FindNetwork:hwid];
}

+(YNetwork *) FirstNetwork
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Network":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YNetwork FindNetwork:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YNetwork public methods implementation)

@end
//--- (YNetwork functions)

YNetwork *yFindNetwork(NSString* func)
{
    return [YNetwork FindNetwork:func];
}

YNetwork *yFirstNetwork(void)
{
    return [YNetwork FirstNetwork];
}

//--- (end of YNetwork functions)
