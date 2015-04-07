/*********************************************************************
 *
 * $Id: yocto_wireless.h 19608 2015-03-05 10:37:24Z seb $
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
 * YWlanRecord Class: Description of a wireless network
 *
 *
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
-(NSString*)     get_ssid;

-(int)     get_channel;

-(NSString*)     get_security;

-(int)     get_linkQuality;


//--- (end of generated code: YWlanRecord public methods declaration)

@end

//--- (generated code: WlanRecord functions declaration)
//--- (end of generated code: WlanRecord functions declaration)


//--- (generated code: YWireless class start)
/**
 * YWireless Class: Wireless function interface
 *
 * YWireless functions provides control over wireless network parameters
 * and status for devices that are wireless-enabled.
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
 * On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
 */
-(int)     get_linkQuality;


-(int) linkQuality;
/**
 * Returns the wireless network name (SSID).
 *
 * @return a string corresponding to the wireless network name (SSID)
 *
 * On failure, throws an exception or returns Y_SSID_INVALID.
 */
-(NSString*)     get_ssid;


-(NSString*) ssid;
/**
 * Returns the 802.11 channel currently used, or 0 when the selected network has not been found.
 *
 * @return an integer corresponding to the 802.11 channel currently used, or 0 when the selected
 * network has not been found
 *
 * On failure, throws an exception or returns Y_CHANNEL_INVALID.
 */
-(int)     get_channel;


-(int) channel;
/**
 * Returns the security algorithm used by the selected wireless network.
 *
 * @return a value among Y_SECURITY_UNKNOWN, Y_SECURITY_OPEN, Y_SECURITY_WEP, Y_SECURITY_WPA and
 * Y_SECURITY_WPA2 corresponding to the security algorithm used by the selected wireless network
 *
 * On failure, throws an exception or returns Y_SECURITY_INVALID.
 */
-(Y_SECURITY_enum)     get_security;


-(Y_SECURITY_enum) security;
/**
 * Returns the latest status message from the wireless interface.
 *
 * @return a string corresponding to the latest status message from the wireless interface
 *
 * On failure, throws an exception or returns Y_MESSAGE_INVALID.
 */
-(NSString*)     get_message;


-(NSString*) message;
-(NSString*)     get_wlanConfig;


-(NSString*) wlanConfig;
-(int)     set_wlanConfig:(NSString*) newval;
-(int)     setWlanConfig:(NSString*) newval;

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
+(YWireless*)     FindWireless:(NSString*)func;

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
-(int)     registerValueCallback:(YWirelessValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     joinNetwork:(NSString*)ssid :(NSString*)securityKey;

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
-(int)     adhocNetwork:(NSString*)ssid :(NSString*)securityKey;

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
-(int)     softAPNetwork:(NSString*)ssid :(NSString*)securityKey;

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
-(NSMutableArray*)     get_detectedWlans;


/**
 * Continues the enumeration of wireless lan interfaces started using yFirstWireless().
 *
 * @return a pointer to a YWireless object, corresponding to
 *         a wireless lan interface currently online, or a null pointer
 *         if there are no more wireless lan interfaces to enumerate.
 */
-(YWireless*) nextWireless;
/**
 * Starts the enumeration of wireless lan interfaces currently accessible.
 * Use the method YWireless.nextWireless() to iterate on
 * next wireless lan interfaces.
 *
 * @return a pointer to a YWireless object, corresponding to
 *         the first wireless lan interface currently online, or a null pointer
 *         if there are none.
 */
+(YWireless*) FirstWireless;
//--- (end of generated code: YWireless public methods declaration)

@end

//--- (generated code: Wireless functions declaration)
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
YWireless* yFindWireless(NSString* func);
/**
 * Starts the enumeration of wireless lan interfaces currently accessible.
 * Use the method YWireless.nextWireless() to iterate on
 * next wireless lan interfaces.
 *
 * @return a pointer to a YWireless object, corresponding to
 *         the first wireless lan interface currently online, or a null pointer
 *         if there are none.
 */
YWireless* yFirstWireless(void);

//--- (end of generated code: Wireless functions declaration)
CF_EXTERN_C_END

