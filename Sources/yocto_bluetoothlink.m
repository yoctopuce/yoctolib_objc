/*********************************************************************
 *
 * $Id: yocto_bluetoothlink.m 20644 2015-06-12 16:04:33Z seb $
 *
 * Implements the high-level API for BluetoothLink functions
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
 * On failure, throws an exception or returns Y_OWNADDRESS_INVALID.
 */
-(NSString*) get_ownAddress
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_OWNADDRESS_INVALID;
        }
    }
    return _ownAddress;
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
 * On failure, throws an exception or returns Y_PAIRINGPIN_INVALID.
 */
-(NSString*) get_pairingPin
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PAIRINGPIN_INVALID;
        }
    }
    return _pairingPin;
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
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_REMOTEADDRESS_INVALID.
 */
-(NSString*) get_remoteAddress
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_REMOTEADDRESS_INVALID;
        }
    }
    return _remoteAddress;
}


-(NSString*) remoteAddress
{
    return [self get_remoteAddress];
}

/**
 * Changes the MAC-48 address defining which remote device to connect to.
 *
 * @param newval : a string corresponding to the MAC-48 address defining which remote device to connect to
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_REMOTENAME_INVALID.
 */
-(NSString*) get_remoteName
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_REMOTENAME_INVALID;
        }
    }
    return _remoteName;
}


-(NSString*) remoteName
{
    return [self get_remoteName];
}
/**
 * Returns the state of the mute function.
 *
 * @return either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
 *
 * On failure, throws an exception or returns Y_MUTE_INVALID.
 */
-(Y_MUTE_enum) get_mute
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_MUTE_INVALID;
        }
    }
    return _mute;
}


-(Y_MUTE_enum) mute
{
    return [self get_mute];
}

/**
 * Changes the state of the mute function. Remember to call the matching module
 * saveToFlash() method to save the setting permanently.
 *
 * @param newval : either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_PREAMPLIFIER_INVALID.
 */
-(int) get_preAmplifier
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PREAMPLIFIER_INVALID;
        }
    }
    return _preAmplifier;
}


-(int) preAmplifier
{
    return [self get_preAmplifier];
}

/**
 * Changes the audio pre-amplifier volume, in per cents.
 *
 * @param newval : an integer corresponding to the audio pre-amplifier volume, in per cents
 *
 * @return YAPI_SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns Y_VOLUME_INVALID.
 */
-(int) get_volume
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLUME_INVALID;
        }
    }
    return _volume;
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
 * @return YAPI_SUCCESS if the call succeeds.
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
 * @return a value among Y_LINKSTATE_DOWN, Y_LINKSTATE_FREE, Y_LINKSTATE_SEARCH, Y_LINKSTATE_EXISTS,
 * Y_LINKSTATE_LINKED and Y_LINKSTATE_PLAY corresponding to the bluetooth link state
 *
 * On failure, throws an exception or returns Y_LINKSTATE_INVALID.
 */
-(Y_LINKSTATE_enum) get_linkState
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LINKSTATE_INVALID;
        }
    }
    return _linkState;
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
-(NSString*) get_command
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    return _command;
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
 * Retrieves $AFUNCTION$ for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that $THEFUNCTION$ is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBluetoothLink.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YBluetoothLink object allowing you to drive $THEFUNCTION$.
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
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YBluetoothLinkValueCallback)callback
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
 * @return YAPI_SUCCESS when the call succeeds.
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
 * @return YAPI_SUCCESS when the call succeeds.
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
//--- (BluetoothLink functions)

YBluetoothLink *yFindBluetoothLink(NSString* func)
{
    return [YBluetoothLink FindBluetoothLink:func];
}

YBluetoothLink *yFirstBluetoothLink(void)
{
    return [YBluetoothLink FirstBluetoothLink];
}

//--- (end of BluetoothLink functions)
