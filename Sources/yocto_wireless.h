/*********************************************************************
 *
 * $Id: yocto_wireless.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 * Declares yFindWireless(), the high-level API for Wireless functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN
@class YWireless;
//--- (generated code: YWireless globals)
typedef void (*YWirelessValueCallback)(YWireless *func, NSString *functionValue);
#ifndef _Y_SECURITY_ENUM
#define _Y_SECURITY_ENUM
typedef enum {
    Y_SECURITY_UNKNOWN = 0,
    Y_SECURITY_OPEN = 1,
    Y_SECURITY_WEP = 2,
    Y_SECURITY_WPA = 3,
    Y_SECURITY_WPA2 = 4,
    Y_SECURITY_INVALID = -1,
} Y_SECURITY_enum;
#endif
#ifndef _Y_WLANSTATE_ENUM
#define _Y_WLANSTATE_ENUM
typedef enum {
    Y_WLANSTATE_DOWN = 0,
    Y_WLANSTATE_SCANNING = 1,
    Y_WLANSTATE_CONNECTED = 2,
    Y_WLANSTATE_REJECTED = 3,
    Y_WLANSTATE_INVALID = -1,
} Y_WLANSTATE_enum;
#endif
#define Y_LINKQUALITY_INVALID           YAPI_INVALID_UINT
#define Y_SSID_INVALID                  YAPI_INVALID_STRING
#define Y_CHANNEL_INVALID               YAPI_INVALID_UINT
#define Y_MESSAGE_INVALID               YAPI_INVALID_STRING
#define Y_WLANCONFIG_INVALID            YAPI_INVALID_STRING
//--- (end of generated code: YWireless globals)

//--- (generated code: YWlanRecord globals)
//--- (end of generated code: YWlanRecord globals)




//--- (generated code: YWlanRecord class start)
/**
 * YWlanRecord Class: Wireless network description, returned by wireless.get_detectedWlans method
 *
 * YWlanRecord objects are used to describe a wireless network.
 * These objects are  used in particular in conjunction with the
 * YWireless class.
 */
@interface YWlanRecord : NSObject
//--- (end of generated code: YWlanRecord class start)
{
@protected
//--- (generated code: YWlanRecord attributes declaration)
    NSString*       _ssid;
    int             _channel;
    NSString*       _sec;
    int             _rssi;
//--- (end of generated code: YWlanRecord attributes declaration)
}

-(id)   initWith:(NSString *)json_str;

//--- (generated code: YWlanRecord private methods declaration)
//--- (end of generated code: YWlanRecord private methods declaration)
//--- (generated code: YWlanRecord public methods declaration)
/**
 * Returns the name of the wireless network (SSID).
 *
 * @return a string with the name of the wireless network (SSID).
 */
-(NSString*)     get_ssid;

/**
 * Returns the 802.11 b/g/n channel number used by this network.
 *
 * @return an integer corresponding to the channel.
 */
-(int)     get_channel;

/**
 * Returns the security algorithm used by the wireless network.
 * If the network implements to security, the value is "OPEN".
 *
 * @return a string with the security algorithm.
 */
-(NSString*)     get_security;

/**
 * Returns the quality of the wireless network link, in per cents.
 *
 * @return an integer between 0 and 100 corresponding to the signal quality.
 */
-(int)     get_linkQuality;


//--- (end of generated code: YWlanRecord public methods declaration)

@end

//--- (generated code: YWlanRecord functions declaration)
//--- (end of generated code: YWlanRecord functions declaration)


//--- (generated code: YWireless class start)
/**
 * YWireless Class: wireless LAN interface control interface, available for instance in the
 * YoctoHub-Wireless, the YoctoHub-Wireless-SR, the YoctoHub-Wireless-g or the YoctoHub-Wireless-n
 *
 * The YWireless class provides control over wireless network parameters
 * and status for devices that are wireless-enabled.
 * Note that TCP/IP parameters are configured separately, using class YNetwork.
 */
@interface YWireless : YFunction
//--- (end of generated code: YWireless class start)
{
@protected
//--- (generated code: YWireless attributes declaration)
    int             _linkQuality;
    NSString*       _ssid;
    int             _channel;
    Y_SECURITY_enum _security;
    NSString*       _message;
    NSString*       _wlanConfig;
    Y_WLANSTATE_enum _wlanState;
    YWirelessValueCallback _valueCallbackWireless;
//--- (end of generated code: YWireless attributes declaration)
}
// Constructor is protected, use yFindWireless factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YWireless private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YWireless private methods declaration)
//--- (generated code: YWireless public methods declaration)
/**
 * Returns the link quality, expressed in percent.
 *
 * @return an integer corresponding to the link quality, expressed in percent
 *
 * On failure, throws an exception or returns YWireless.LINKQUALITY_INVALID.
 */
-(int)     get_linkQuality;


-(int) linkQuality;
/**
 * Returns the wireless network name (SSID).
 *
 * @return a string corresponding to the wireless network name (SSID)
 *
 * On failure, throws an exception or returns YWireless.SSID_INVALID.
 */
-(NSString*)     get_ssid;


-(NSString*) ssid;
/**
 * Returns the 802.11 channel currently used, or 0 when the selected network has not been found.
 *
 * @return an integer corresponding to the 802.11 channel currently used, or 0 when the selected
 * network has not been found
 *
 * On failure, throws an exception or returns YWireless.CHANNEL_INVALID.
 */
-(int)     get_channel;


-(int) channel;
/**
 * Returns the security algorithm used by the selected wireless network.
 *
 * @return a value among YWireless.SECURITY_UNKNOWN, YWireless.SECURITY_OPEN, YWireless.SECURITY_WEP,
 * YWireless.SECURITY_WPA and YWireless.SECURITY_WPA2 corresponding to the security algorithm used by
 * the selected wireless network
 *
 * On failure, throws an exception or returns YWireless.SECURITY_INVALID.
 */
-(Y_SECURITY_enum)     get_security;


-(Y_SECURITY_enum) security;
/**
 * Returns the latest status message from the wireless interface.
 *
 * @return a string corresponding to the latest status message from the wireless interface
 *
 * On failure, throws an exception or returns YWireless.MESSAGE_INVALID.
 */
-(NSString*)     get_message;


-(NSString*) message;
-(NSString*)     get_wlanConfig;


-(NSString*) wlanConfig;
-(int)     set_wlanConfig:(NSString*) newval;
-(int)     setWlanConfig:(NSString*) newval;

/**
 * Returns the current state of the wireless interface. The state YWireless.WLANSTATE_DOWN means that
 * the network interface is
 * not connected to a network. The state YWireless.WLANSTATE_SCANNING means that the network interface
 * is scanning available
 * frequencies. During this stage, the device is not reachable, and the network settings are not yet
 * applied. The state
 * YWireless.WLANSTATE_CONNECTED means that the network settings have been successfully applied ant
 * that the device is reachable
 * from the wireless network. If the device is configured to use ad-hoc or Soft AP mode, it means that
 * the wireless network
 * is up and that other devices can join the network. The state YWireless.WLANSTATE_REJECTED means
 * that the network interface has
 * not been able to join the requested network. The description of the error can be obtain with the
 * get_message() method.
 *
 * @return a value among YWireless.WLANSTATE_DOWN, YWireless.WLANSTATE_SCANNING,
 * YWireless.WLANSTATE_CONNECTED and YWireless.WLANSTATE_REJECTED corresponding to the current state
 * of the wireless interface
 *
 * On failure, throws an exception or returns YWireless.WLANSTATE_INVALID.
 */
-(Y_WLANSTATE_enum)     get_wlanState;


-(Y_WLANSTATE_enum) wlanState;
/**
 * Retrieves a wireless LAN interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
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
+(YWireless*)     FindWireless:(NSString*)func;

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
-(int)     registerValueCallback:(YWirelessValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Triggers a scan of the wireless frequency and builds the list of available networks.
 * The scan forces a disconnection from the current network. At then end of the process, the
 * the network interface attempts to reconnect to the previous network. During the scan, the wlanState
 * switches to YWireless.WLANSTATE_DOWN, then to YWireless.WLANSTATE_SCANNING. When the scan is completed,
 * get_wlanState() returns either YWireless.WLANSTATE_DOWN or YWireless.WLANSTATE_SCANNING. At this
 * point, the list of detected network can be retrieved with the get_detectedWlans() method.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     startWlanScan;

/**
 * Changes the configuration of the wireless lan interface to connect to an existing
 * access point (infrastructure mode).
 * Remember to call the saveToFlash() method and then to reboot the module to apply this setting.
 *
 * @param ssid : the name of the network to connect to
 * @param securityKey : the network key, as a character string
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     joinNetwork:(NSString*)ssid :(NSString*)securityKey;

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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     adhocNetwork:(NSString*)ssid :(NSString*)securityKey;

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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     softAPNetwork:(NSString*)ssid :(NSString*)securityKey;

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
-(NSMutableArray*)     get_detectedWlans;


/**
 * Continues the enumeration of wireless LAN interfaces started using yFirstWireless().
 * Caution: You can't make any assumption about the returned wireless LAN interfaces order.
 * If you want to find a specific a wireless LAN interface, use Wireless.findWireless()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YWireless object, corresponding to
 *         a wireless LAN interface currently online, or a nil pointer
 *         if there are no more wireless LAN interfaces to enumerate.
 */
-(nullable YWireless*) nextWireless
NS_SWIFT_NAME(nextWireless());
/**
 * Starts the enumeration of wireless LAN interfaces currently accessible.
 * Use the method YWireless.nextWireless() to iterate on
 * next wireless LAN interfaces.
 *
 * @return a pointer to a YWireless object, corresponding to
 *         the first wireless LAN interface currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YWireless*) FirstWireless
NS_SWIFT_NAME(FirstWireless());
//--- (end of generated code: YWireless public methods declaration)

@end

//--- (generated code: YWireless functions declaration)
/**
 * Retrieves a wireless LAN interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
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
YWireless* yFindWireless(NSString* func);
/**
 * Starts the enumeration of wireless LAN interfaces currently accessible.
 * Use the method YWireless.nextWireless() to iterate on
 * next wireless LAN interfaces.
 *
 * @return a pointer to a YWireless object, corresponding to
 *         the first wireless LAN interface currently online, or a nil pointer
 *         if there are none.
 */
YWireless* yFirstWireless(void);

//--- (end of generated code: YWireless functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

