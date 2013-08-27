/*********************************************************************
 *
 * $Id: yocto_network.m 12337 2013-08-14 15:22:22Z mvuilleu $
 *
 * Implements yFindNetwork(), the high-level API for Network functions
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
-(id)              initWithFunction:(NSString*) func
{
//--- (YNetwork attributes)
   if(!(self = [super initProtected:@"Network":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _readiness = Y_READINESS_INVALID;
    _macAddress = Y_MACADDRESS_INVALID;
    _ipAddress = Y_IPADDRESS_INVALID;
    _subnetMask = Y_SUBNETMASK_INVALID;
    _router = Y_ROUTER_INVALID;
    _ipConfig = Y_IPCONFIG_INVALID;
    _primaryDNS = Y_PRIMARYDNS_INVALID;
    _secondaryDNS = Y_SECONDARYDNS_INVALID;
    _userPassword = Y_USERPASSWORD_INVALID;
    _adminPassword = Y_ADMINPASSWORD_INVALID;
    _discoverable = Y_DISCOVERABLE_INVALID;
    _wwwWatchdogDelay = Y_WWWWATCHDOGDELAY_INVALID;
    _callbackUrl = Y_CALLBACKURL_INVALID;
    _callbackMethod = Y_CALLBACKMETHOD_INVALID;
    _callbackEncoding = Y_CALLBACKENCODING_INVALID;
    _callbackCredentials = Y_CALLBACKCREDENTIALS_INVALID;
    _callbackMinDelay = Y_CALLBACKMINDELAY_INVALID;
    _callbackMaxDelay = Y_CALLBACKMAXDELAY_INVALID;
    _poeCurrent = Y_POECURRENT_INVALID;
//--- (end of YNetwork attributes)
    return self;
}
// destructor 
-(void)  dealloc
{
//--- (YNetwork cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
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
    ARC_release(_userPassword);
    _userPassword = nil;
    ARC_release(_adminPassword);
    _adminPassword = nil;
    ARC_release(_callbackUrl);
    _callbackUrl = nil;
    ARC_release(_callbackCredentials);
    _callbackCredentials = nil;
//--- (end of YNetwork cleanup)
    ARC_dealloc(super);
}
//--- (YNetwork implementation)

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
        } else if(!strcmp(j->token, "readiness")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _readiness =  atoi(j->token);
        } else if(!strcmp(j->token, "macAddress")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_macAddress);
            _macAddress =  [self _parseString:j];
            ARC_retain(_macAddress);
        } else if(!strcmp(j->token, "ipAddress")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_ipAddress);
            _ipAddress =  [self _parseString:j];
            ARC_retain(_ipAddress);
        } else if(!strcmp(j->token, "subnetMask")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_subnetMask);
            _subnetMask =  [self _parseString:j];
            ARC_retain(_subnetMask);
        } else if(!strcmp(j->token, "router")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_router);
            _router =  [self _parseString:j];
            ARC_retain(_router);
        } else if(!strcmp(j->token, "ipConfig")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_ipConfig);
            _ipConfig =  [self _parseString:j];
            ARC_retain(_ipConfig);
        } else if(!strcmp(j->token, "primaryDNS")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_primaryDNS);
            _primaryDNS =  [self _parseString:j];
            ARC_retain(_primaryDNS);
        } else if(!strcmp(j->token, "secondaryDNS")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_secondaryDNS);
            _secondaryDNS =  [self _parseString:j];
            ARC_retain(_secondaryDNS);
        } else if(!strcmp(j->token, "userPassword")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_userPassword);
            _userPassword =  [self _parseString:j];
            ARC_retain(_userPassword);
        } else if(!strcmp(j->token, "adminPassword")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_adminPassword);
            _adminPassword =  [self _parseString:j];
            ARC_retain(_adminPassword);
        } else if(!strcmp(j->token, "discoverable")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _discoverable =  (Y_DISCOVERABLE_enum)atoi(j->token);
        } else if(!strcmp(j->token, "wwwWatchdogDelay")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _wwwWatchdogDelay =  atoi(j->token);
        } else if(!strcmp(j->token, "callbackUrl")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_callbackUrl);
            _callbackUrl =  [self _parseString:j];
            ARC_retain(_callbackUrl);
        } else if(!strcmp(j->token, "callbackMethod")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _callbackMethod =  atoi(j->token);
        } else if(!strcmp(j->token, "callbackEncoding")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _callbackEncoding =  atoi(j->token);
        } else if(!strcmp(j->token, "callbackCredentials")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_callbackCredentials);
            _callbackCredentials =  [self _parseString:j];
            ARC_retain(_callbackCredentials);
        } else if(!strcmp(j->token, "callbackMinDelay")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _callbackMinDelay =  atoi(j->token);
        } else if(!strcmp(j->token, "callbackMaxDelay")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _callbackMaxDelay =  atoi(j->token);
        } else if(!strcmp(j->token, "poeCurrent")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _poeCurrent =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the network interface, corresponding to the network name of the module.
 * 
 * @return a string corresponding to the logical name of the network interface, corresponding to the
 * network name of the module
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
 * Changes the logical name of the network interface, corresponding to the network name of the module.
 * You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the network interface, corresponding
 * to the network name of the module
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
 * Returns the current value of the network interface (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the network interface (no more than 6 characters)
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
 * Returns the current established working mode of the network interface.
 * Level zero (DOWN_0) means that no hardware link has been detected. Either there is no signal
 * on the network cable, or the selected wireless access point cannot be detected.
 * Level 1 (LIVE_1) is reached when the network is detected, but is not yet connected,
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
    return [self readiness];
}
-(Y_READINESS_enum) readiness
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_READINESS_INVALID;
    }
    return _readiness;
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
    return [self macAddress];
}
-(NSString*) macAddress
{
    if(_macAddress == Y_MACADDRESS_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_MACADDRESS_INVALID;
    }
    return _macAddress;
}

/**
 * Returns the IP address currently in use by the device. The adress may have been configured
 * statically, or provided by a DHCP server.
 * 
 * @return a string corresponding to the IP address currently in use by the device
 * 
 * On failure, throws an exception or returns Y_IPADDRESS_INVALID.
 */
-(NSString*) get_ipAddress
{
    return [self ipAddress];
}
-(NSString*) ipAddress
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_IPADDRESS_INVALID;
    }
    return _ipAddress;
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
    return [self subnetMask];
}
-(NSString*) subnetMask
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SUBNETMASK_INVALID;
    }
    return _subnetMask;
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
    return [self router];
}
-(NSString*) router
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ROUTER_INVALID;
    }
    return _router;
}

-(NSString*) get_ipConfig
{
    return [self ipConfig];
}
-(NSString*) ipConfig
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_IPCONFIG_INVALID;
    }
    return _ipConfig;
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
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) useDHCP :(NSString*)fallbackIpAddr :(int)fallbackSubnetMaskLen :(NSString*)fallbackRouter
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"DHCP:%@/%d/%@",fallbackIpAddr,fallbackSubnetMaskLen,fallbackRouter];
    return [self _setAttr:@"ipConfig" :rest_val];
}

/**
 * Changes the configuration of the network interface to use a static IP address.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 * 
 * @param ipAddress : device IP address
 * @param subnetMaskLen : subnet mask length, as an integer (eg. 24 means 255.255.255.0)
 * @param router : router IP address (default gateway)
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) useStaticIP :(NSString*)ipAddress :(int)subnetMaskLen :(NSString*)router
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"STATIC:%@/%d/%@",ipAddress,subnetMaskLen,router];
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
    return [self primaryDNS];
}
-(NSString*) primaryDNS
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PRIMARYDNS_INVALID;
    }
    return _primaryDNS;
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
    return [self secondaryDNS];
}
-(NSString*) secondaryDNS
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SECONDARYDNS_INVALID;
    }
    return _secondaryDNS;
}

/**
 * Changes the IP address of the secondarz name server to be used by the module.
 * When using DHCP, if a value is specified, it overrides the value received from the DHCP server.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 * 
 * @param newval : a string corresponding to the IP address of the secondarz name server to be used by the module
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
    return [self userPassword];
}
-(NSString*) userPassword
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_USERPASSWORD_INVALID;
    }
    return _userPassword;
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
    return [self adminPassword];
}
-(NSString*) adminPassword
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADMINPASSWORD_INVALID;
    }
    return _adminPassword;
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
    rest_val = newval;
    return [self _setAttr:@"adminPassword" :rest_val];
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
    return [self discoverable];
}
-(Y_DISCOVERABLE_enum) discoverable
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_DISCOVERABLE_INVALID;
    }
    return _discoverable;
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
-(unsigned) get_wwwWatchdogDelay
{
    return [self wwwWatchdogDelay];
}
-(unsigned) wwwWatchdogDelay
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_WWWWATCHDOGDELAY_INVALID;
    }
    return _wwwWatchdogDelay;
}

/**
 * Changes the allowed downtime of the WWW link (in seconds) before triggering an automated
 * reboot to try to recover Internet connectivity. A zero value disable automated reboot
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
-(int) set_wwwWatchdogDelay:(unsigned) newval
{
    return [self setWwwWatchdogDelay:newval];
}
-(int) setWwwWatchdogDelay:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
    return [self callbackUrl];
}
-(NSString*) callbackUrl
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKURL_INVALID;
    }
    return _callbackUrl;
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
    return [self callbackMethod];
}
-(Y_CALLBACKMETHOD_enum) callbackMethod
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKMETHOD_INVALID;
    }
    return _callbackMethod;
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"callbackMethod" :rest_val];
}

/**
 * Returns the encoding standard to use for representing notification values.
 * 
 * @return a value among Y_CALLBACKENCODING_FORM, Y_CALLBACKENCODING_JSON,
 * Y_CALLBACKENCODING_JSON_ARRAY, Y_CALLBACKENCODING_CSV and Y_CALLBACKENCODING_YOCTO_API
 * corresponding to the encoding standard to use for representing notification values
 * 
 * On failure, throws an exception or returns Y_CALLBACKENCODING_INVALID.
 */
-(Y_CALLBACKENCODING_enum) get_callbackEncoding
{
    return [self callbackEncoding];
}
-(Y_CALLBACKENCODING_enum) callbackEncoding
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKENCODING_INVALID;
    }
    return _callbackEncoding;
}

/**
 * Changes the encoding standard to use for representing notification values.
 * 
 * @param newval : a value among Y_CALLBACKENCODING_FORM, Y_CALLBACKENCODING_JSON,
 * Y_CALLBACKENCODING_JSON_ARRAY, Y_CALLBACKENCODING_CSV and Y_CALLBACKENCODING_YOCTO_API
 * corresponding to the encoding standard to use for representing notification values
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
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
    return [self callbackCredentials];
}
-(NSString*) callbackCredentials
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKCREDENTIALS_INVALID;
    }
    return _callbackCredentials;
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
-(int) callbackLogin :(NSString*)username :(NSString*)password
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%@:%@",username,password];
    return [self _setAttr:@"callbackCredentials" :rest_val];
}

/**
 * Returns the minimum waiting time between two callback notifications, in seconds.
 * 
 * @return an integer corresponding to the minimum waiting time between two callback notifications, in seconds
 * 
 * On failure, throws an exception or returns Y_CALLBACKMINDELAY_INVALID.
 */
-(unsigned) get_callbackMinDelay
{
    return [self callbackMinDelay];
}
-(unsigned) callbackMinDelay
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKMINDELAY_INVALID;
    }
    return _callbackMinDelay;
}

/**
 * Changes the minimum waiting time between two callback notifications, in seconds.
 * 
 * @param newval : an integer corresponding to the minimum waiting time between two callback
 * notifications, in seconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackMinDelay:(unsigned) newval
{
    return [self setCallbackMinDelay:newval];
}
-(int) setCallbackMinDelay:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"callbackMinDelay" :rest_val];
}

/**
 * Returns the maximum waiting time between two callback notifications, in seconds.
 * 
 * @return an integer corresponding to the maximum waiting time between two callback notifications, in seconds
 * 
 * On failure, throws an exception or returns Y_CALLBACKMAXDELAY_INVALID.
 */
-(unsigned) get_callbackMaxDelay
{
    return [self callbackMaxDelay];
}
-(unsigned) callbackMaxDelay
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CALLBACKMAXDELAY_INVALID;
    }
    return _callbackMaxDelay;
}

/**
 * Changes the maximum waiting time between two callback notifications, in seconds.
 * 
 * @param newval : an integer corresponding to the maximum waiting time between two callback
 * notifications, in seconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_callbackMaxDelay:(unsigned) newval
{
    return [self setCallbackMaxDelay:newval];
}
-(int) setCallbackMaxDelay:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
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
-(unsigned) get_poeCurrent
{
    return [self poeCurrent];
}
-(unsigned) poeCurrent
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_POECURRENT_INVALID;
    }
    return _poeCurrent;
}
/**
 * Pings str_host to test the network connectivity. Sends four requests ICMP ECHO_REQUEST from the
 * module to the target str_host. This method returns a string with the result of the
 * 4 ICMP ECHO_REQUEST result.
 * 
 * @param host : the hostname or the IP address of the target
 * 
 * @return a string with the result of the ping.
 */
-(NSString*) ping :(NSString*)host
{
    NSData* content;
    content = [self _download:[NSString stringWithFormat:@"ping.txt?host=%@",host]];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSASCIIStringEncoding]);
    
}


-(YNetwork*)   nextNetwork
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindNetwork(hwid);
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

+(YNetwork*) FindNetwork:(NSString*) func
{
    YNetwork * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YNetwork"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YNetwork"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YNetwork"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YNetwork"] objectForKey:func];
    } else {
        retVal = [[YNetwork alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YNetwork"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
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

//--- (end of YNetwork implementation)

@end
//--- (Network functions)

YNetwork *yFindNetwork(NSString* func)
{
    return [YNetwork FindNetwork:func];
}

YNetwork *yFirstNetwork(void)
{
    return [YNetwork FirstNetwork];
}

//--- (end of Network functions)
