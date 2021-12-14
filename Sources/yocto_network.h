/*********************************************************************
 *
 *  $Id: yocto_network.h 47630 2021-12-10 17:04:48Z mvuilleu $
 *
 *  Declares yFindNetwork(), the high-level API for Network functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN

@class YNetwork;

//--- (YNetwork globals)
typedef void (*YNetworkValueCallback)(YNetwork *func, NSString *functionValue);
#ifndef _Y_READINESS_ENUM
#define _Y_READINESS_ENUM
typedef enum {
    Y_READINESS_DOWN = 0,
    Y_READINESS_EXISTS = 1,
    Y_READINESS_LINKED = 2,
    Y_READINESS_LAN_OK = 3,
    Y_READINESS_WWW_OK = 4,
    Y_READINESS_INVALID = -1,
} Y_READINESS_enum;
#endif
#ifndef _Y_DISCOVERABLE_ENUM
#define _Y_DISCOVERABLE_ENUM
typedef enum {
    Y_DISCOVERABLE_FALSE = 0,
    Y_DISCOVERABLE_TRUE = 1,
    Y_DISCOVERABLE_INVALID = -1,
} Y_DISCOVERABLE_enum;
#endif
#ifndef _Y_CALLBACKMETHOD_ENUM
#define _Y_CALLBACKMETHOD_ENUM
typedef enum {
    Y_CALLBACKMETHOD_POST = 0,
    Y_CALLBACKMETHOD_GET = 1,
    Y_CALLBACKMETHOD_PUT = 2,
    Y_CALLBACKMETHOD_INVALID = -1,
} Y_CALLBACKMETHOD_enum;
#endif
#ifndef _Y_CALLBACKENCODING_ENUM
#define _Y_CALLBACKENCODING_ENUM
typedef enum {
    Y_CALLBACKENCODING_FORM = 0,
    Y_CALLBACKENCODING_JSON = 1,
    Y_CALLBACKENCODING_JSON_ARRAY = 2,
    Y_CALLBACKENCODING_CSV = 3,
    Y_CALLBACKENCODING_YOCTO_API = 4,
    Y_CALLBACKENCODING_JSON_NUM = 5,
    Y_CALLBACKENCODING_EMONCMS = 6,
    Y_CALLBACKENCODING_AZURE = 7,
    Y_CALLBACKENCODING_INFLUXDB = 8,
    Y_CALLBACKENCODING_MQTT = 9,
    Y_CALLBACKENCODING_YOCTO_API_JZON = 10,
    Y_CALLBACKENCODING_PRTG = 11,
    Y_CALLBACKENCODING_INFLUXDB_V2 = 12,
    Y_CALLBACKENCODING_INVALID = -1,
} Y_CALLBACKENCODING_enum;
#endif
#define Y_MACADDRESS_INVALID            YAPI_INVALID_STRING
#define Y_IPADDRESS_INVALID             YAPI_INVALID_STRING
#define Y_SUBNETMASK_INVALID            YAPI_INVALID_STRING
#define Y_ROUTER_INVALID                YAPI_INVALID_STRING
#define Y_IPCONFIG_INVALID              YAPI_INVALID_STRING
#define Y_PRIMARYDNS_INVALID            YAPI_INVALID_STRING
#define Y_SECONDARYDNS_INVALID          YAPI_INVALID_STRING
#define Y_NTPSERVER_INVALID             YAPI_INVALID_STRING
#define Y_USERPASSWORD_INVALID          YAPI_INVALID_STRING
#define Y_ADMINPASSWORD_INVALID         YAPI_INVALID_STRING
#define Y_HTTPPORT_INVALID              YAPI_INVALID_UINT
#define Y_DEFAULTPAGE_INVALID           YAPI_INVALID_STRING
#define Y_WWWWATCHDOGDELAY_INVALID      YAPI_INVALID_UINT
#define Y_CALLBACKURL_INVALID           YAPI_INVALID_STRING
#define Y_CALLBACKCREDENTIALS_INVALID   YAPI_INVALID_STRING
#define Y_CALLBACKINITIALDELAY_INVALID  YAPI_INVALID_UINT
#define Y_CALLBACKSCHEDULE_INVALID      YAPI_INVALID_STRING
#define Y_CALLBACKMINDELAY_INVALID      YAPI_INVALID_UINT
#define Y_CALLBACKMAXDELAY_INVALID      YAPI_INVALID_UINT
#define Y_POECURRENT_INVALID            YAPI_INVALID_UINT
//--- (end of YNetwork globals)

//--- (YNetwork class start)
/**
 * YNetwork Class: network interface control interface, available for instance in the
 * YoctoHub-Ethernet, the YoctoHub-GSM-2G, the YoctoHub-GSM-4G or the YoctoHub-Wireless-n
 *
 * YNetwork objects provide access to TCP/IP parameters of Yoctopuce
 * devices that include a built-in network interface.
 */
@interface YNetwork : YFunction
//--- (end of YNetwork class start)
{
@protected
//--- (YNetwork attributes declaration)
    Y_READINESS_enum _readiness;
    NSString*       _macAddress;
    NSString*       _ipAddress;
    NSString*       _subnetMask;
    NSString*       _router;
    NSString*       _ipConfig;
    NSString*       _primaryDNS;
    NSString*       _secondaryDNS;
    NSString*       _ntpServer;
    NSString*       _userPassword;
    NSString*       _adminPassword;
    int             _httpPort;
    NSString*       _defaultPage;
    Y_DISCOVERABLE_enum _discoverable;
    int             _wwwWatchdogDelay;
    NSString*       _callbackUrl;
    Y_CALLBACKMETHOD_enum _callbackMethod;
    Y_CALLBACKENCODING_enum _callbackEncoding;
    NSString*       _callbackCredentials;
    int             _callbackInitialDelay;
    NSString*       _callbackSchedule;
    int             _callbackMinDelay;
    int             _callbackMaxDelay;
    int             _poeCurrent;
    YNetworkValueCallback _valueCallbackNetwork;
//--- (end of YNetwork attributes declaration)
}
// Constructor is protected, use yFindNetwork factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YNetwork private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YNetwork private methods declaration)
//--- (YNetwork yapiwrapper declaration)
//--- (end of YNetwork yapiwrapper declaration)
//--- (YNetwork public methods declaration)
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
 * @return a value among YNetwork.READINESS_DOWN, YNetwork.READINESS_EXISTS,
 * YNetwork.READINESS_LINKED, YNetwork.READINESS_LAN_OK and YNetwork.READINESS_WWW_OK corresponding to
 * the current established working mode of the network interface
 *
 * On failure, throws an exception or returns YNetwork.READINESS_INVALID.
 */
-(Y_READINESS_enum)     get_readiness;


-(Y_READINESS_enum) readiness;
/**
 * Returns the MAC address of the network interface. The MAC address is also available on a sticker
 * on the module, in both numeric and barcode forms.
 *
 * @return a string corresponding to the MAC address of the network interface
 *
 * On failure, throws an exception or returns YNetwork.MACADDRESS_INVALID.
 */
-(NSString*)     get_macAddress;


-(NSString*) macAddress;
/**
 * Returns the IP address currently in use by the device. The address may have been configured
 * statically, or provided by a DHCP server.
 *
 * @return a string corresponding to the IP address currently in use by the device
 *
 * On failure, throws an exception or returns YNetwork.IPADDRESS_INVALID.
 */
-(NSString*)     get_ipAddress;


-(NSString*) ipAddress;
/**
 * Returns the subnet mask currently used by the device.
 *
 * @return a string corresponding to the subnet mask currently used by the device
 *
 * On failure, throws an exception or returns YNetwork.SUBNETMASK_INVALID.
 */
-(NSString*)     get_subnetMask;


-(NSString*) subnetMask;
/**
 * Returns the IP address of the router on the device subnet (default gateway).
 *
 * @return a string corresponding to the IP address of the router on the device subnet (default gateway)
 *
 * On failure, throws an exception or returns YNetwork.ROUTER_INVALID.
 */
-(NSString*)     get_router;


-(NSString*) router;
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
 * On failure, throws an exception or returns YNetwork.IPCONFIG_INVALID.
 */
-(NSString*)     get_ipConfig;


-(NSString*) ipConfig;
-(int)     set_ipConfig:(NSString*) newval;
-(int)     setIpConfig:(NSString*) newval;

/**
 * Returns the IP address of the primary name server to be used by the module.
 *
 * @return a string corresponding to the IP address of the primary name server to be used by the module
 *
 * On failure, throws an exception or returns YNetwork.PRIMARYDNS_INVALID.
 */
-(NSString*)     get_primaryDNS;


-(NSString*) primaryDNS;
/**
 * Changes the IP address of the primary name server to be used by the module.
 * When using DHCP, if a value is specified, it overrides the value received from the DHCP server.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the primary name server to be used by the module
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_primaryDNS:(NSString*) newval;
-(int)     setPrimaryDNS:(NSString*) newval;

/**
 * Returns the IP address of the secondary name server to be used by the module.
 *
 * @return a string corresponding to the IP address of the secondary name server to be used by the module
 *
 * On failure, throws an exception or returns YNetwork.SECONDARYDNS_INVALID.
 */
-(NSString*)     get_secondaryDNS;


-(NSString*) secondaryDNS;
/**
 * Changes the IP address of the secondary name server to be used by the module.
 * When using DHCP, if a value is specified, it overrides the value received from the DHCP server.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the secondary name server to be used by the module
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_secondaryDNS:(NSString*) newval;
-(int)     setSecondaryDNS:(NSString*) newval;

/**
 * Returns the IP address of the NTP server to be used by the device.
 *
 * @return a string corresponding to the IP address of the NTP server to be used by the device
 *
 * On failure, throws an exception or returns YNetwork.NTPSERVER_INVALID.
 */
-(NSString*)     get_ntpServer;


-(NSString*) ntpServer;
/**
 * Changes the IP address of the NTP server to be used by the module. Use an empty
 * string to restore the factory set  address.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param newval : a string corresponding to the IP address of the NTP server to be used by the module
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_ntpServer:(NSString*) newval;
-(int)     setNtpServer:(NSString*) newval;

/**
 * Returns a hash string if a password has been set for "user" user,
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hash string if a password has been set for "user" user,
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns YNetwork.USERPASSWORD_INVALID.
 */
-(NSString*)     get_userPassword;


-(NSString*) userPassword;
/**
 * Changes the password for the "user" user. This password becomes instantly required
 * to perform any use of the module. If the specified value is an
 * empty string, a password is not required anymore.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the password for the "user" user
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_userPassword:(NSString*) newval;
-(int)     setUserPassword:(NSString*) newval;

/**
 * Returns a hash string if a password has been set for user "admin",
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hash string if a password has been set for user "admin",
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns YNetwork.ADMINPASSWORD_INVALID.
 */
-(NSString*)     get_adminPassword;


-(NSString*) adminPassword;
/**
 * Changes the password for the "admin" user. This password becomes instantly required
 * to perform any change of the module state. If the specified value is an
 * empty string, a password is not required anymore.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the password for the "admin" user
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_adminPassword:(NSString*) newval;
-(int)     setAdminPassword:(NSString*) newval;

/**
 * Returns the TCP port used to serve the hub web UI.
 *
 * @return an integer corresponding to the TCP port used to serve the hub web UI
 *
 * On failure, throws an exception or returns YNetwork.HTTPPORT_INVALID.
 */
-(int)     get_httpPort;


-(int) httpPort;
/**
 * Changes the the TCP port used to serve the hub web UI. The default value is port 80,
 * which is the default for all Web servers. Regardless of the value set here,
 * the hub will always reply on port 4444, which is used by default by Yoctopuce
 * API library. When you change this parameter, remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the the TCP port used to serve the hub web UI
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_httpPort:(int) newval;
-(int)     setHttpPort:(int) newval;

/**
 * Returns the HTML page to serve for the URL "/"" of the hub.
 *
 * @return a string corresponding to the HTML page to serve for the URL "/"" of the hub
 *
 * On failure, throws an exception or returns YNetwork.DEFAULTPAGE_INVALID.
 */
-(NSString*)     get_defaultPage;


-(NSString*) defaultPage;
/**
 * Changes the default HTML page returned by the hub. If not value are set the hub return
 * "index.html" which is the web interface of the hub. It is possible to change this page
 * for file that has been uploaded on the hub. The maximum filename size is 15 characters.
 * When you change this parameter, remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the default HTML page returned by the hub
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_defaultPage:(NSString*) newval;
-(int)     setDefaultPage:(NSString*) newval;

/**
 * Returns the activation state of the multicast announce protocols to allow easy
 * discovery of the module in the network neighborhood (uPnP/Bonjour protocol).
 *
 * @return either YNetwork.DISCOVERABLE_FALSE or YNetwork.DISCOVERABLE_TRUE, according to the
 * activation state of the multicast announce protocols to allow easy
 *         discovery of the module in the network neighborhood (uPnP/Bonjour protocol)
 *
 * On failure, throws an exception or returns YNetwork.DISCOVERABLE_INVALID.
 */
-(Y_DISCOVERABLE_enum)     get_discoverable;


-(Y_DISCOVERABLE_enum) discoverable;
/**
 * Changes the activation state of the multicast announce protocols to allow easy
 * discovery of the module in the network neighborhood (uPnP/Bonjour protocol).
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YNetwork.DISCOVERABLE_FALSE or YNetwork.DISCOVERABLE_TRUE, according to the
 * activation state of the multicast announce protocols to allow easy
 *         discovery of the module in the network neighborhood (uPnP/Bonjour protocol)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_discoverable:(Y_DISCOVERABLE_enum) newval;
-(int)     setDiscoverable:(Y_DISCOVERABLE_enum) newval;

/**
 * Returns the allowed downtime of the WWW link (in seconds) before triggering an automated
 * reboot to try to recover Internet connectivity. A zero value disables automated reboot
 * in case of Internet connectivity loss.
 *
 * @return an integer corresponding to the allowed downtime of the WWW link (in seconds) before
 * triggering an automated
 *         reboot to try to recover Internet connectivity
 *
 * On failure, throws an exception or returns YNetwork.WWWWATCHDOGDELAY_INVALID.
 */
-(int)     get_wwwWatchdogDelay;


-(int) wwwWatchdogDelay;
/**
 * Changes the allowed downtime of the WWW link (in seconds) before triggering an automated
 * reboot to try to recover Internet connectivity. A zero value disables automated reboot
 * in case of Internet connectivity loss. The smallest valid non-zero timeout is
 * 90 seconds. Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the allowed downtime of the WWW link (in seconds)
 * before triggering an automated
 *         reboot to try to recover Internet connectivity
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_wwwWatchdogDelay:(int) newval;
-(int)     setWwwWatchdogDelay:(int) newval;

/**
 * Returns the callback URL to notify of significant state changes.
 *
 * @return a string corresponding to the callback URL to notify of significant state changes
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKURL_INVALID.
 */
-(NSString*)     get_callbackUrl;


-(NSString*) callbackUrl;
/**
 * Changes the callback URL to notify significant state changes. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the callback URL to notify significant state changes
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackUrl:(NSString*) newval;
-(int)     setCallbackUrl:(NSString*) newval;

/**
 * Returns the HTTP method used to notify callbacks for significant state changes.
 *
 * @return a value among YNetwork.CALLBACKMETHOD_POST, YNetwork.CALLBACKMETHOD_GET and
 * YNetwork.CALLBACKMETHOD_PUT corresponding to the HTTP method used to notify callbacks for
 * significant state changes
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKMETHOD_INVALID.
 */
-(Y_CALLBACKMETHOD_enum)     get_callbackMethod;


-(Y_CALLBACKMETHOD_enum) callbackMethod;
/**
 * Changes the HTTP method used to notify callbacks for significant state changes.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YNetwork.CALLBACKMETHOD_POST, YNetwork.CALLBACKMETHOD_GET and
 * YNetwork.CALLBACKMETHOD_PUT corresponding to the HTTP method used to notify callbacks for
 * significant state changes
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackMethod:(Y_CALLBACKMETHOD_enum) newval;
-(int)     setCallbackMethod:(Y_CALLBACKMETHOD_enum) newval;

/**
 * Returns the encoding standard to use for representing notification values.
 *
 * @return a value among YNetwork.CALLBACKENCODING_FORM, YNetwork.CALLBACKENCODING_JSON,
 * YNetwork.CALLBACKENCODING_JSON_ARRAY, YNetwork.CALLBACKENCODING_CSV,
 * YNetwork.CALLBACKENCODING_YOCTO_API, YNetwork.CALLBACKENCODING_JSON_NUM,
 * YNetwork.CALLBACKENCODING_EMONCMS, YNetwork.CALLBACKENCODING_AZURE,
 * YNetwork.CALLBACKENCODING_INFLUXDB, YNetwork.CALLBACKENCODING_MQTT,
 * YNetwork.CALLBACKENCODING_YOCTO_API_JZON, YNetwork.CALLBACKENCODING_PRTG and
 * YNetwork.CALLBACKENCODING_INFLUXDB_V2 corresponding to the encoding standard to use for
 * representing notification values
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKENCODING_INVALID.
 */
-(Y_CALLBACKENCODING_enum)     get_callbackEncoding;


-(Y_CALLBACKENCODING_enum) callbackEncoding;
/**
 * Changes the encoding standard to use for representing notification values.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YNetwork.CALLBACKENCODING_FORM, YNetwork.CALLBACKENCODING_JSON,
 * YNetwork.CALLBACKENCODING_JSON_ARRAY, YNetwork.CALLBACKENCODING_CSV,
 * YNetwork.CALLBACKENCODING_YOCTO_API, YNetwork.CALLBACKENCODING_JSON_NUM,
 * YNetwork.CALLBACKENCODING_EMONCMS, YNetwork.CALLBACKENCODING_AZURE,
 * YNetwork.CALLBACKENCODING_INFLUXDB, YNetwork.CALLBACKENCODING_MQTT,
 * YNetwork.CALLBACKENCODING_YOCTO_API_JZON, YNetwork.CALLBACKENCODING_PRTG and
 * YNetwork.CALLBACKENCODING_INFLUXDB_V2 corresponding to the encoding standard to use for
 * representing notification values
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackEncoding:(Y_CALLBACKENCODING_enum) newval;
-(int)     setCallbackEncoding:(Y_CALLBACKENCODING_enum) newval;

/**
 * Returns a hashed version of the notification callback credentials if set,
 * or an empty string otherwise.
 *
 * @return a string corresponding to a hashed version of the notification callback credentials if set,
 *         or an empty string otherwise
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKCREDENTIALS_INVALID.
 */
-(NSString*)     get_callbackCredentials;


-(NSString*) callbackCredentials;
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackCredentials:(NSString*) newval;
-(int)     setCallbackCredentials:(NSString*) newval;

/**
 * Connects to the notification callback and saves the credentials required to
 * log into it. The password is not stored into the module, only a hashed
 * copy of the credentials are saved. Remember to call the
 * saveToFlash() method of the module if the modification must be kept.
 *
 * @param username : username required to log to the callback
 * @param password : password required to log to the callback
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     callbackLogin:(NSString*)username :(NSString*)password;

/**
 * Returns the initial waiting time before first callback notifications, in seconds.
 *
 * @return an integer corresponding to the initial waiting time before first callback notifications, in seconds
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKINITIALDELAY_INVALID.
 */
-(int)     get_callbackInitialDelay;


-(int) callbackInitialDelay;
/**
 * Changes the initial waiting time before first callback notifications, in seconds.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the initial waiting time before first callback
 * notifications, in seconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackInitialDelay:(int) newval;
-(int)     setCallbackInitialDelay:(int) newval;

/**
 * Returns the HTTP callback schedule strategy, as a text string.
 *
 * @return a string corresponding to the HTTP callback schedule strategy, as a text string
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKSCHEDULE_INVALID.
 */
-(NSString*)     get_callbackSchedule;


-(NSString*) callbackSchedule;
/**
 * Changes the HTTP callback schedule strategy, as a text string.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the HTTP callback schedule strategy, as a text string
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackSchedule:(NSString*) newval;
-(int)     setCallbackSchedule:(NSString*) newval;

/**
 * Returns the minimum waiting time between two HTTP callbacks, in seconds.
 *
 * @return an integer corresponding to the minimum waiting time between two HTTP callbacks, in seconds
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKMINDELAY_INVALID.
 */
-(int)     get_callbackMinDelay;


-(int) callbackMinDelay;
/**
 * Changes the minimum waiting time between two HTTP callbacks, in seconds.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the minimum waiting time between two HTTP callbacks, in seconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackMinDelay:(int) newval;
-(int)     setCallbackMinDelay:(int) newval;

/**
 * Returns the waiting time between two HTTP callbacks when there is nothing new.
 *
 * @return an integer corresponding to the waiting time between two HTTP callbacks when there is nothing new
 *
 * On failure, throws an exception or returns YNetwork.CALLBACKMAXDELAY_INVALID.
 */
-(int)     get_callbackMaxDelay;


-(int) callbackMaxDelay;
/**
 * Changes the waiting time between two HTTP callbacks when there is nothing new.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the waiting time between two HTTP callbacks when there
 * is nothing new
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_callbackMaxDelay:(int) newval;
-(int)     setCallbackMaxDelay:(int) newval;

/**
 * Returns the current consumed by the module from Power-over-Ethernet (PoE), in milliamps.
 * The current consumption is measured after converting PoE source to 5 Volt, and should
 * never exceed 1800 mA.
 *
 * @return an integer corresponding to the current consumed by the module from Power-over-Ethernet
 * (PoE), in milliamps
 *
 * On failure, throws an exception or returns YNetwork.POECURRENT_INVALID.
 */
-(int)     get_poeCurrent;


-(int) poeCurrent;
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
 * @param func : a string that uniquely characterizes the network interface, for instance
 *         YHUBETH1.network.
 *
 * @return a YNetwork object allowing you to drive the network interface.
 */
+(YNetwork*)     FindNetwork:(NSString*)func;

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
-(int)     registerValueCallback:(YNetworkValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Changes the configuration of the network interface to enable the use of an
 * IP address received from a DHCP server. Until an address is received from a DHCP
 * server, the module uses the IP parameters specified to this function.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param fallbackIpAddr : fallback IP address, to be used when no DHCP reply is received
 * @param fallbackSubnetMaskLen : fallback subnet mask length when no DHCP reply is received, as an
 *         integer (e.g. 24 means 255.255.255.0)
 * @param fallbackRouter : fallback router IP address, to be used when no DHCP reply is received
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     useDHCP:(NSString*)fallbackIpAddr :(int)fallbackSubnetMaskLen :(NSString*)fallbackRouter;

/**
 * Changes the configuration of the network interface to enable the use of an
 * IP address received from a DHCP server. Until an address is received from a DHCP
 * server, the module uses an IP of the network 169.254.0.0/16 (APIPA).
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     useDHCPauto;

/**
 * Changes the configuration of the network interface to use a static IP address.
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param ipAddress : device IP address
 * @param subnetMaskLen : subnet mask length, as an integer (e.g. 24 means 255.255.255.0)
 * @param router : router IP address (default gateway)
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     useStaticIP:(NSString*)ipAddress :(int)subnetMaskLen :(NSString*)router;

/**
 * Pings host to test the network connectivity. Sends four ICMP ECHO_REQUEST requests from the
 * module to the target host. This method returns a string with the result of the
 * 4 ICMP ECHO_REQUEST requests.
 *
 * @param host : the hostname or the IP address of the target
 *
 * @return a string with the result of the ping.
 */
-(NSString*)     ping:(NSString*)host;

/**
 * Trigger an HTTP callback quickly. This function can even be called within
 * an HTTP callback, in which case the next callback will be triggered 5 seconds
 * after the end of the current callback, regardless if the minimum time between
 * callbacks configured in the device.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerCallback;

/**
 * Setup periodic HTTP callbacks (simplified function).
 *
 * @param interval : a string representing the callback periodicity, expressed in
 *         seconds, minutes or hours, eg. "60s", "5m", "1h", "48h".
 * @param offset : an integer representing the time offset relative to the period
 *         when the callback should occur. For instance, if the periodicity is
 *         24h, an offset of 7 will make the callback occur each day at 7AM.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_periodicCallbackSchedule:(NSString*)interval :(int)offset;


/**
 * Continues the enumeration of network interfaces started using yFirstNetwork().
 * Caution: You can't make any assumption about the returned network interfaces order.
 * If you want to find a specific a network interface, use Network.findNetwork()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YNetwork object, corresponding to
 *         a network interface currently online, or a nil pointer
 *         if there are no more network interfaces to enumerate.
 */
-(nullable YNetwork*) nextNetwork
NS_SWIFT_NAME(nextNetwork());
/**
 * Starts the enumeration of network interfaces currently accessible.
 * Use the method YNetwork.nextNetwork() to iterate on
 * next network interfaces.
 *
 * @return a pointer to a YNetwork object, corresponding to
 *         the first network interface currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YNetwork*) FirstNetwork
NS_SWIFT_NAME(FirstNetwork());
//--- (end of YNetwork public methods declaration)

@end

//--- (YNetwork functions declaration)
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
 * @param func : a string that uniquely characterizes the network interface, for instance
 *         YHUBETH1.network.
 *
 * @return a YNetwork object allowing you to drive the network interface.
 */
YNetwork* yFindNetwork(NSString* func);
/**
 * Starts the enumeration of network interfaces currently accessible.
 * Use the method YNetwork.nextNetwork() to iterate on
 * next network interfaces.
 *
 * @return a pointer to a YNetwork object, corresponding to
 *         the first network interface currently online, or a nil pointer
 *         if there are none.
 */
YNetwork* yFirstNetwork(void);

//--- (end of YNetwork functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

