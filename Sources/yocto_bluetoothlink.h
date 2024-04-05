/*********************************************************************
 *
 *  $Id: yocto_bluetoothlink.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Declares yFindBluetoothLink(), the high-level API for BluetoothLink functions
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

@class YBluetoothLink;

//--- (YBluetoothLink globals)
typedef void (*YBluetoothLinkValueCallback)(YBluetoothLink *func, NSString *functionValue);
#ifndef _Y_MUTE_ENUM
#define _Y_MUTE_ENUM
typedef enum {
    Y_MUTE_FALSE = 0,
    Y_MUTE_TRUE = 1,
    Y_MUTE_INVALID = -1,
} Y_MUTE_enum;
#endif
#ifndef _Y_LINKSTATE_ENUM
#define _Y_LINKSTATE_ENUM
typedef enum {
    Y_LINKSTATE_DOWN = 0,
    Y_LINKSTATE_FREE = 1,
    Y_LINKSTATE_SEARCH = 2,
    Y_LINKSTATE_EXISTS = 3,
    Y_LINKSTATE_LINKED = 4,
    Y_LINKSTATE_PLAY = 5,
    Y_LINKSTATE_INVALID = -1,
} Y_LINKSTATE_enum;
#endif
#define Y_OWNADDRESS_INVALID            YAPI_INVALID_STRING
#define Y_PAIRINGPIN_INVALID            YAPI_INVALID_STRING
#define Y_REMOTEADDRESS_INVALID         YAPI_INVALID_STRING
#define Y_REMOTENAME_INVALID            YAPI_INVALID_STRING
#define Y_PREAMPLIFIER_INVALID          YAPI_INVALID_UINT
#define Y_VOLUME_INVALID                YAPI_INVALID_UINT
#define Y_LINKQUALITY_INVALID           YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YBluetoothLink globals)

//--- (YBluetoothLink class start)
/**
 * YBluetoothLink Class: Bluetooth sound controller control interface
 *
 * BluetoothLink function provides control over Bluetooth link
 * and status for devices that are Bluetooth-enabled.
 */
@interface YBluetoothLink : YFunction
//--- (end of YBluetoothLink class start)
{
@protected
//--- (YBluetoothLink attributes declaration)
    NSString*       _ownAddress;
    NSString*       _pairingPin;
    NSString*       _remoteAddress;
    NSString*       _remoteName;
    Y_MUTE_enum     _mute;
    int             _preAmplifier;
    int             _volume;
    Y_LINKSTATE_enum _linkState;
    int             _linkQuality;
    NSString*       _command;
    YBluetoothLinkValueCallback _valueCallbackBluetoothLink;
//--- (end of YBluetoothLink attributes declaration)
}
// Constructor is protected, use yFindBluetoothLink factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YBluetoothLink private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YBluetoothLink private methods declaration)
//--- (YBluetoothLink yapiwrapper declaration)
//--- (end of YBluetoothLink yapiwrapper declaration)
//--- (YBluetoothLink public methods declaration)
/**
 * Returns the MAC-48 address of the bluetooth interface, which is unique on the bluetooth network.
 *
 * @return a string corresponding to the MAC-48 address of the bluetooth interface, which is unique on
 * the bluetooth network
 *
 * On failure, throws an exception or returns YBluetoothLink.OWNADDRESS_INVALID.
 */
-(NSString*)     get_ownAddress;


-(NSString*) ownAddress;
/**
 * Returns an opaque string if a PIN code has been configured in the device to access
 * the SIM card, or an empty string if none has been configured or if the code provided
 * was rejected by the SIM card.
 *
 * @return a string corresponding to an opaque string if a PIN code has been configured in the device to access
 *         the SIM card, or an empty string if none has been configured or if the code provided
 *         was rejected by the SIM card
 *
 * On failure, throws an exception or returns YBluetoothLink.PAIRINGPIN_INVALID.
 */
-(NSString*)     get_pairingPin;


-(NSString*) pairingPin;
/**
 * Changes the PIN code used by the module for bluetooth pairing.
 * Remember to call the saveToFlash() method of the module to save the
 * new value in the device flash.
 *
 * @param newval : a string corresponding to the PIN code used by the module for bluetooth pairing
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pairingPin:(NSString*) newval;
-(int)     setPairingPin:(NSString*) newval;

/**
 * Returns the MAC-48 address of the remote device to connect to.
 *
 * @return a string corresponding to the MAC-48 address of the remote device to connect to
 *
 * On failure, throws an exception or returns YBluetoothLink.REMOTEADDRESS_INVALID.
 */
-(NSString*)     get_remoteAddress;


-(NSString*) remoteAddress;
/**
 * Changes the MAC-48 address defining which remote device to connect to.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the MAC-48 address defining which remote device to connect to
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_remoteAddress:(NSString*) newval;
-(int)     setRemoteAddress:(NSString*) newval;

/**
 * Returns the bluetooth name the remote device, if found on the bluetooth network.
 *
 * @return a string corresponding to the bluetooth name the remote device, if found on the bluetooth network
 *
 * On failure, throws an exception or returns YBluetoothLink.REMOTENAME_INVALID.
 */
-(NSString*)     get_remoteName;


-(NSString*) remoteName;
/**
 * Returns the state of the mute function.
 *
 * @return either YBluetoothLink.MUTE_FALSE or YBluetoothLink.MUTE_TRUE, according to the state of the
 * mute function
 *
 * On failure, throws an exception or returns YBluetoothLink.MUTE_INVALID.
 */
-(Y_MUTE_enum)     get_mute;


-(Y_MUTE_enum) mute;
/**
 * Changes the state of the mute function. Remember to call the matching module
 * saveToFlash() method to save the setting permanently.
 *
 * @param newval : either YBluetoothLink.MUTE_FALSE or YBluetoothLink.MUTE_TRUE, according to the
 * state of the mute function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_mute:(Y_MUTE_enum) newval;
-(int)     setMute:(Y_MUTE_enum) newval;

/**
 * Returns the audio pre-amplifier volume, in per cents.
 *
 * @return an integer corresponding to the audio pre-amplifier volume, in per cents
 *
 * On failure, throws an exception or returns YBluetoothLink.PREAMPLIFIER_INVALID.
 */
-(int)     get_preAmplifier;


-(int) preAmplifier;
/**
 * Changes the audio pre-amplifier volume, in per cents.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the audio pre-amplifier volume, in per cents
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_preAmplifier:(int) newval;
-(int)     setPreAmplifier:(int) newval;

/**
 * Returns the connected headset volume, in per cents.
 *
 * @return an integer corresponding to the connected headset volume, in per cents
 *
 * On failure, throws an exception or returns YBluetoothLink.VOLUME_INVALID.
 */
-(int)     get_volume;


-(int) volume;
/**
 * Changes the connected headset volume, in per cents.
 *
 * @param newval : an integer corresponding to the connected headset volume, in per cents
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_volume:(int) newval;
-(int)     setVolume:(int) newval;

/**
 * Returns the bluetooth link state.
 *
 * @return a value among YBluetoothLink.LINKSTATE_DOWN, YBluetoothLink.LINKSTATE_FREE,
 * YBluetoothLink.LINKSTATE_SEARCH, YBluetoothLink.LINKSTATE_EXISTS, YBluetoothLink.LINKSTATE_LINKED
 * and YBluetoothLink.LINKSTATE_PLAY corresponding to the bluetooth link state
 *
 * On failure, throws an exception or returns YBluetoothLink.LINKSTATE_INVALID.
 */
-(Y_LINKSTATE_enum)     get_linkState;


-(Y_LINKSTATE_enum) linkState;
/**
 * Returns the bluetooth receiver signal strength, in pourcents, or 0 if no connection is established.
 *
 * @return an integer corresponding to the bluetooth receiver signal strength, in pourcents, or 0 if
 * no connection is established
 *
 * On failure, throws an exception or returns YBluetoothLink.LINKQUALITY_INVALID.
 */
-(int)     get_linkQuality;


-(int) linkQuality;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a Bluetooth sound controller for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the Bluetooth sound controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBluetoothLink.isOnline() to test if the Bluetooth sound controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Bluetooth sound controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Bluetooth sound controller, for instance
 *         MyDevice.bluetoothLink1.
 *
 * @return a YBluetoothLink object allowing you to drive the Bluetooth sound controller.
 */
+(YBluetoothLink*)     FindBluetoothLink:(NSString*)func;

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
-(int)     registerValueCallback:(YBluetoothLinkValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Attempt to connect to the previously selected remote device.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     connect;

/**
 * Disconnect from the previously selected remote device.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     disconnect;


/**
 * Continues the enumeration of Bluetooth sound controllers started using yFirstBluetoothLink().
 * Caution: You can't make any assumption about the returned Bluetooth sound controllers order.
 * If you want to find a specific a Bluetooth sound controller, use BluetoothLink.findBluetoothLink()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YBluetoothLink object, corresponding to
 *         a Bluetooth sound controller currently online, or a nil pointer
 *         if there are no more Bluetooth sound controllers to enumerate.
 */
-(nullable YBluetoothLink*) nextBluetoothLink
NS_SWIFT_NAME(nextBluetoothLink());
/**
 * Starts the enumeration of Bluetooth sound controllers currently accessible.
 * Use the method YBluetoothLink.nextBluetoothLink() to iterate on
 * next Bluetooth sound controllers.
 *
 * @return a pointer to a YBluetoothLink object, corresponding to
 *         the first Bluetooth sound controller currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YBluetoothLink*) FirstBluetoothLink
NS_SWIFT_NAME(FirstBluetoothLink());
//--- (end of YBluetoothLink public methods declaration)

@end

//--- (YBluetoothLink functions declaration)
/**
 * Retrieves a Bluetooth sound controller for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the Bluetooth sound controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBluetoothLink.isOnline() to test if the Bluetooth sound controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Bluetooth sound controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the Bluetooth sound controller, for instance
 *         MyDevice.bluetoothLink1.
 *
 * @return a YBluetoothLink object allowing you to drive the Bluetooth sound controller.
 */
YBluetoothLink* yFindBluetoothLink(NSString* func);
/**
 * Starts the enumeration of Bluetooth sound controllers currently accessible.
 * Use the method YBluetoothLink.nextBluetoothLink() to iterate on
 * next Bluetooth sound controllers.
 *
 * @return a pointer to a YBluetoothLink object, corresponding to
 *         the first Bluetooth sound controller currently online, or a nil pointer
 *         if there are none.
 */
YBluetoothLink* yFirstBluetoothLink(void);

//--- (end of YBluetoothLink functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

