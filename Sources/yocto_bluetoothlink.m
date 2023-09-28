/*********************************************************************
 *
 *  $Id: yocto_bluetoothlink.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for BluetoothLink functions
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


#import "yocto_bluetoothlink.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YBluetoothLink
// Constructor is protected, use yFindBluetoothLink factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"BluetoothLink";
//--- (YBluetoothLink attributes initialization)
    _ownAddress = Y_OWNADDRESS_INVALID;
    _pairingPin = Y_PAIRINGPIN_INVALID;
    _remoteAddress = Y_REMOTEADDRESS_INVALID;
    _remoteName = Y_REMOTENAME_INVALID;
    _mute = Y_MUTE_INVALID;
    _preAmplifier = Y_PREAMPLIFIER_INVALID;
    _volume = Y_VOLUME_INVALID;
    _linkState = Y_LINKSTATE_INVALID;
    _linkQuality = Y_LINKQUALITY_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackBluetoothLink = NULL;
//--- (end of YBluetoothLink attributes initialization)
    return self;
}
//--- (YBluetoothLink yapiwrapper)
//--- (end of YBluetoothLink yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YBluetoothLink cleanup)
    ARC_release(_ownAddress);
    _ownAddress = nil;
    ARC_release(_pairingPin);
    _pairingPin = nil;
    ARC_release(_remoteAddress);
    _remoteAddress = nil;
    ARC_release(_remoteName);
    _remoteName = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YBluetoothLink cleanup)
}
//--- (YBluetoothLink private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "ownAddress")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_ownAddress);
        _ownAddress =  [self _parseString:j];
        ARC_retain(_ownAddress);
        return 1;
    }
    if(!strcmp(j->token, "pairingPin")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_pairingPin);
        _pairingPin =  [self _parseString:j];
        ARC_retain(_pairingPin);
        return 1;
    }
    if(!strcmp(j->token, "remoteAddress")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_remoteAddress);
        _remoteAddress =  [self _parseString:j];
        ARC_retain(_remoteAddress);
        return 1;
    }
    if(!strcmp(j->token, "remoteName")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_remoteName);
        _remoteName =  [self _parseString:j];
        ARC_retain(_remoteName);
        return 1;
    }
    if(!strcmp(j->token, "mute")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _mute =  (Y_MUTE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "preAmplifier")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _preAmplifier =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "volume")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _volume =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "linkState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _linkState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "linkQuality")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _linkQuality =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YBluetoothLink private methods implementation)
//--- (YBluetoothLink public methods implementation)
/**
 * Returns the MAC-48 address of the bluetooth interface, which is unique on the bluetooth network.
 *
 * @return a string corresponding to the MAC-48 address of the bluetooth interface, which is unique on
 * the bluetooth network
 *
 * On failure, throws an exception or returns YBluetoothLink.OWNADDRESS_INVALID.
 */
-(NSString*) get_ownAddress
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_OWNADDRESS_INVALID;
        }
    }
    res = _ownAddress;
    return res;
}


-(NSString*) ownAddress
{
    return [self get_ownAddress];
}
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
-(NSString*) get_pairingPin
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PAIRINGPIN_INVALID;
        }
    }
    res = _pairingPin;
    return res;
}


-(NSString*) pairingPin
{
    return [self get_pairingPin];
}

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
-(int) set_pairingPin:(NSString*) newval
{
    return [self setPairingPin:newval];
}
-(int) setPairingPin:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"pairingPin" :rest_val];
}
/**
 * Returns the MAC-48 address of the remote device to connect to.
 *
 * @return a string corresponding to the MAC-48 address of the remote device to connect to
 *
 * On failure, throws an exception or returns YBluetoothLink.REMOTEADDRESS_INVALID.
 */
-(NSString*) get_remoteAddress
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REMOTEADDRESS_INVALID;
        }
    }
    res = _remoteAddress;
    return res;
}


-(NSString*) remoteAddress
{
    return [self get_remoteAddress];
}

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
-(int) set_remoteAddress:(NSString*) newval
{
    return [self setRemoteAddress:newval];
}
-(int) setRemoteAddress:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"remoteAddress" :rest_val];
}
/**
 * Returns the bluetooth name the remote device, if found on the bluetooth network.
 *
 * @return a string corresponding to the bluetooth name the remote device, if found on the bluetooth network
 *
 * On failure, throws an exception or returns YBluetoothLink.REMOTENAME_INVALID.
 */
-(NSString*) get_remoteName
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REMOTENAME_INVALID;
        }
    }
    res = _remoteName;
    return res;
}


-(NSString*) remoteName
{
    return [self get_remoteName];
}
/**
 * Returns the state of the mute function.
 *
 * @return either YBluetoothLink.MUTE_FALSE or YBluetoothLink.MUTE_TRUE, according to the state of the
 * mute function
 *
 * On failure, throws an exception or returns YBluetoothLink.MUTE_INVALID.
 */
-(Y_MUTE_enum) get_mute
{
    Y_MUTE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MUTE_INVALID;
        }
    }
    res = _mute;
    return res;
}


-(Y_MUTE_enum) mute
{
    return [self get_mute];
}

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
-(int) set_mute:(Y_MUTE_enum) newval
{
    return [self setMute:newval];
}
-(int) setMute:(Y_MUTE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"mute" :rest_val];
}
/**
 * Returns the audio pre-amplifier volume, in per cents.
 *
 * @return an integer corresponding to the audio pre-amplifier volume, in per cents
 *
 * On failure, throws an exception or returns YBluetoothLink.PREAMPLIFIER_INVALID.
 */
-(int) get_preAmplifier
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PREAMPLIFIER_INVALID;
        }
    }
    res = _preAmplifier;
    return res;
}


-(int) preAmplifier
{
    return [self get_preAmplifier];
}

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
-(int) set_preAmplifier:(int) newval
{
    return [self setPreAmplifier:newval];
}
-(int) setPreAmplifier:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"preAmplifier" :rest_val];
}
/**
 * Returns the connected headset volume, in per cents.
 *
 * @return an integer corresponding to the connected headset volume, in per cents
 *
 * On failure, throws an exception or returns YBluetoothLink.VOLUME_INVALID.
 */
-(int) get_volume
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLUME_INVALID;
        }
    }
    res = _volume;
    return res;
}


-(int) volume
{
    return [self get_volume];
}

/**
 * Changes the connected headset volume, in per cents.
 *
 * @param newval : an integer corresponding to the connected headset volume, in per cents
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_volume:(int) newval
{
    return [self setVolume:newval];
}
-(int) setVolume:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"volume" :rest_val];
}
/**
 * Returns the bluetooth link state.
 *
 * @return a value among YBluetoothLink.LINKSTATE_DOWN, YBluetoothLink.LINKSTATE_FREE,
 * YBluetoothLink.LINKSTATE_SEARCH, YBluetoothLink.LINKSTATE_EXISTS, YBluetoothLink.LINKSTATE_LINKED
 * and YBluetoothLink.LINKSTATE_PLAY corresponding to the bluetooth link state
 *
 * On failure, throws an exception or returns YBluetoothLink.LINKSTATE_INVALID.
 */
-(Y_LINKSTATE_enum) get_linkState
{
    Y_LINKSTATE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LINKSTATE_INVALID;
        }
    }
    res = _linkState;
    return res;
}


-(Y_LINKSTATE_enum) linkState
{
    return [self get_linkState];
}
/**
 * Returns the bluetooth receiver signal strength, in pourcents, or 0 if no connection is established.
 *
 * @return an integer corresponding to the bluetooth receiver signal strength, in pourcents, or 0 if
 * no connection is established
 *
 * On failure, throws an exception or returns YBluetoothLink.LINKQUALITY_INVALID.
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
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a Bluetooth sound controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
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
+(YBluetoothLink*) FindBluetoothLink:(NSString*)func
{
    YBluetoothLink* obj;
    obj = (YBluetoothLink*) [YFunction _FindFromCache:@"BluetoothLink" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YBluetoothLink alloc] initWith:func]);
        [YFunction _AddToCache:@"BluetoothLink" : func :obj];
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
-(int) registerValueCallback:(YBluetoothLinkValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackBluetoothLink = callback;
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
    if (_valueCallbackBluetoothLink != NULL) {
        _valueCallbackBluetoothLink(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Attempt to connect to the previously selected remote device.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) connect
{
    return [self set_command:@"C"];
}

/**
 * Disconnect from the previously selected remote device.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) disconnect
{
    return [self set_command:@"D"];
}


-(YBluetoothLink*)   nextBluetoothLink
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YBluetoothLink FindBluetoothLink:hwid];
}

+(YBluetoothLink *) FirstBluetoothLink
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"BluetoothLink":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YBluetoothLink FindBluetoothLink:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YBluetoothLink public methods implementation)
@end

//--- (YBluetoothLink functions)

YBluetoothLink *yFindBluetoothLink(NSString* func)
{
    return [YBluetoothLink FindBluetoothLink:func];
}

YBluetoothLink *yFirstBluetoothLink(void)
{
    return [YBluetoothLink FirstBluetoothLink];
}

//--- (end of YBluetoothLink functions)

