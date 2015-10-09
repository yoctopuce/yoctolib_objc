/*********************************************************************
 *
 * $Id: yocto_cellular.m 21511 2015-09-14 16:25:19Z seb $
 *
 * Implements the high-level API for Cellular functions
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


#import "yocto_cellular.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"

@implementation YCellRecord

// Constructor is protected, use yFindCellRecord factory function to instantiate
-(id)              initWith:(int)mcc :(int)mnc :(int)lac :(int)cellId :(int)dbm :(int)tad :(NSString *)oper
{
   if(!(self = [super init]))
          return nil;
//--- (generated code: YCellRecord attributes initialization)
    _mcc = 0;
    _mnc = 0;
    _lac = 0;
    _cid = 0;
    _dbm = 0;
    _tad = 0;
//--- (end of generated code: YCellRecord attributes initialization)
    _oper = oper;
    _mcc = mcc;
    _mnc = mnc;
    _lac = lac;
    _cid = cellId;
    _dbm = dbm;
    _tad = tad;
    return self;
}
// destructor
-(void)  dealloc
{
//--- (generated code: YCellRecord cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YCellRecord cleanup)
}
//--- (generated code: YCellRecord private methods implementation)

//--- (end of generated code: YCellRecord private methods implementation)
//--- (generated code: YCellRecord public methods implementation)
-(NSString*) get_cellOperator
{
    return _oper;
}

-(int) get_mobileCountryCode
{
    return _mcc;
}

-(int) get_mobileNetworkCode
{
    return _mnc;
}

-(int) get_locationAreaCode
{
    return _lac;
}

-(int) get_cellId
{
    return _cid;
}

-(int) get_signalStrength
{
    return _dbm;
}

-(int) get_timingAdvance
{
    return _tad;
}

//--- (end of generated code: YCellRecord public methods implementation)

@end
//--- (generated code: CellRecord functions)
//--- (end of generated code: CellRecord functions)



@implementation YCellular

// Constructor is protected, use yFindCellular factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Cellular";
//--- (generated code: YCellular attributes initialization)
    _linkQuality = Y_LINKQUALITY_INVALID;
    _cellOperator = Y_CELLOPERATOR_INVALID;
    _cellIdentifier = Y_CELLIDENTIFIER_INVALID;
    _imsi = Y_IMSI_INVALID;
    _message = Y_MESSAGE_INVALID;
    _pin = Y_PIN_INVALID;
    _lockedOperator = Y_LOCKEDOPERATOR_INVALID;
    _enableData = Y_ENABLEDATA_INVALID;
    _apn = Y_APN_INVALID;
    _apnSecret = Y_APNSECRET_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackCellular = NULL;
//--- (end of generated code: YCellular attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (generated code: YCellular cleanup)
    ARC_release(_cellOperator);
    _cellOperator = nil;
    ARC_release(_cellIdentifier);
    _cellIdentifier = nil;
    ARC_release(_imsi);
    _imsi = nil;
    ARC_release(_message);
    _message = nil;
    ARC_release(_pin);
    _pin = nil;
    ARC_release(_lockedOperator);
    _lockedOperator = nil;
    ARC_release(_apn);
    _apn = nil;
    ARC_release(_apnSecret);
    _apnSecret = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of generated code: YCellular cleanup)
}
//--- (generated code: YCellular private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "linkQuality")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _linkQuality =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "cellOperator")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_cellOperator);
        _cellOperator =  [self _parseString:j];
        ARC_retain(_cellOperator);
        return 1;
    }
    if(!strcmp(j->token, "cellIdentifier")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_cellIdentifier);
        _cellIdentifier =  [self _parseString:j];
        ARC_retain(_cellIdentifier);
        return 1;
    }
    if(!strcmp(j->token, "imsi")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_imsi);
        _imsi =  [self _parseString:j];
        ARC_retain(_imsi);
        return 1;
    }
    if(!strcmp(j->token, "message")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_message);
        _message =  [self _parseString:j];
        ARC_retain(_message);
        return 1;
    }
    if(!strcmp(j->token, "pin")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_pin);
        _pin =  [self _parseString:j];
        ARC_retain(_pin);
        return 1;
    }
    if(!strcmp(j->token, "lockedOperator")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_lockedOperator);
        _lockedOperator =  [self _parseString:j];
        ARC_retain(_lockedOperator);
        return 1;
    }
    if(!strcmp(j->token, "enableData")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _enableData =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "apn")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_apn);
        _apn =  [self _parseString:j];
        ARC_retain(_apn);
        return 1;
    }
    if(!strcmp(j->token, "apnSecret")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_apnSecret);
        _apnSecret =  [self _parseString:j];
        ARC_retain(_apnSecret);
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
//--- (end of generated code: YCellular private methods implementation)
//--- (generated code: YCellular public methods implementation)
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
 * Returns the name of the cell operator currently in use.
 *
 * @return a string corresponding to the name of the cell operator currently in use
 *
 * On failure, throws an exception or returns Y_CELLOPERATOR_INVALID.
 */
-(NSString*) get_cellOperator
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CELLOPERATOR_INVALID;
        }
    }
    return _cellOperator;
}


-(NSString*) cellOperator
{
    return [self get_cellOperator];
}
/**
 * Returns the unique identifier of the cellular antenna in use: MCC, MNC, LAC and Cell ID.
 *
 * @return a string corresponding to the unique identifier of the cellular antenna in use: MCC, MNC,
 * LAC and Cell ID
 *
 * On failure, throws an exception or returns Y_CELLIDENTIFIER_INVALID.
 */
-(NSString*) get_cellIdentifier
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CELLIDENTIFIER_INVALID;
        }
    }
    return _cellIdentifier;
}


-(NSString*) cellIdentifier
{
    return [self get_cellIdentifier];
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
 * On failure, throws an exception or returns Y_IMSI_INVALID.
 */
-(NSString*) get_imsi
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_IMSI_INVALID;
        }
    }
    return _imsi;
}


-(NSString*) imsi
{
    return [self get_imsi];
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
/**
 * Returns an opaque string if a PIN code has been configured in the device to access
 * the SIM card, or an empty string if none has been configured or if the code provided
 * was rejected by the SIM card.
 *
 * @return a string corresponding to an opaque string if a PIN code has been configured in the device to access
 *         the SIM card, or an empty string if none has been configured or if the code provided
 *         was rejected by the SIM card
 *
 * On failure, throws an exception or returns Y_PIN_INVALID.
 */
-(NSString*) get_pin
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PIN_INVALID;
        }
    }
    return _pin;
}


-(NSString*) pin
{
    return [self get_pin];
}

/**
 * Changes the PIN code used by the module to access the SIM card.
 * This function does not change the code on the SIM card itself, but only changes
 * the parameter used by the device to try to get access to it. If the SIM code
 * does not work immediately on first try, it will be automatically forgotten
 * and the message will be set to "Enter SIM PIN". The method should then be
 * invoked again with right correct PIN code. After three failed attempts in a row,
 * the message is changed to "Enter SIM PUK" and the SIM card PUK code must be
 * provided using method sendPUK.
 *
 * Remember to call the saveToFlash() method of the module to save the
 * new value in the device flash.
 *
 * @param newval : a string corresponding to the PIN code used by the module to access the SIM card
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pin:(NSString*) newval
{
    return [self setPin:newval];
}
-(int) setPin:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"pin" :rest_val];
}
/**
 * Returns the name of the only cell operator to use if automatic choice is disabled,
 * or an empty string if the SIM card will automatically choose among available
 * cell operators.
 *
 * @return a string corresponding to the name of the only cell operator to use if automatic choice is disabled,
 *         or an empty string if the SIM card will automatically choose among available
 *         cell operators
 *
 * On failure, throws an exception or returns Y_LOCKEDOPERATOR_INVALID.
 */
-(NSString*) get_lockedOperator
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOCKEDOPERATOR_INVALID;
        }
    }
    return _lockedOperator;
}


-(NSString*) lockedOperator
{
    return [self get_lockedOperator];
}

/**
 * Changes the name of the cell operator to be used. If the name is an empty
 * string, the choice will be made automatically based on the SIM card. Otherwise,
 * the selected operator is the only one that will be used.
 *
 * @param newval : a string corresponding to the name of the cell operator to be used
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_lockedOperator:(NSString*) newval
{
    return [self setLockedOperator:newval];
}
-(int) setLockedOperator:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"lockedOperator" :rest_val];
}
/**
 * Returns the condition for enabling IP data services (GPRS).
 * When data services are disabled, SMS are the only mean of communication.
 *
 * @return a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER
 * corresponding to the condition for enabling IP data services (GPRS)
 *
 * On failure, throws an exception or returns Y_ENABLEDATA_INVALID.
 */
-(Y_ENABLEDATA_enum) get_enableData
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ENABLEDATA_INVALID;
        }
    }
    return _enableData;
}


-(Y_ENABLEDATA_enum) enableData
{
    return [self get_enableData];
}

/**
 * Changes the condition for enabling IP data services (GPRS).
 * The service can be either fully deactivated, or limited to the SIM home network,
 * or enabled for all partner networks (roaming). Caution: enabling data services
 * on roaming networks may cause prohibitive communication costs !
 *
 * When data services are disabled, SMS are the only mean of communication.
 *
 * @param newval : a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER
 * corresponding to the condition for enabling IP data services (GPRS)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_enableData:(Y_ENABLEDATA_enum) newval
{
    return [self setEnableData:newval];
}
-(int) setEnableData:(Y_ENABLEDATA_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"enableData" :rest_val];
}
/**
 * Returns the Access Point Name (APN) to be used, if needed.
 * When left blank, the APN suggested by the cell operator will be used.
 *
 * @return a string corresponding to the Access Point Name (APN) to be used, if needed
 *
 * On failure, throws an exception or returns Y_APN_INVALID.
 */
-(NSString*) get_apn
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_APN_INVALID;
        }
    }
    return _apn;
}


-(NSString*) apn
{
    return [self get_apn];
}

/**
 * Returns the Access Point Name (APN) to be used, if needed.
 * When left blank, the APN suggested by the cell operator will be used.
 *
 * @param newval : a string
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_apn:(NSString*) newval
{
    return [self setApn:newval];
}
-(int) setApn:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"apn" :rest_val];
}
/**
 * Returns an opaque string if APN authentication parameters have been configured
 * in the device, or an empty string otherwise.
 * To configure these parameters, use set_apnAuth().
 *
 * @return a string corresponding to an opaque string if APN authentication parameters have been configured
 *         in the device, or an empty string otherwise
 *
 * On failure, throws an exception or returns Y_APNSECRET_INVALID.
 */
-(NSString*) get_apnSecret
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_APNSECRET_INVALID;
        }
    }
    return _apnSecret;
}


-(NSString*) apnSecret
{
    return [self get_apnSecret];
}

-(int) set_apnSecret:(NSString*) newval
{
    return [self setApnSecret:newval];
}
-(int) setApnSecret:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"apnSecret" :rest_val];
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
 * Retrieves a cellular interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the cellular interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCellular.isOnline() to test if the cellular interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a cellular interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the cellular interface
 *
 * @return a YCellular object allowing you to drive the cellular interface.
 */
+(YCellular*) FindCellular:(NSString*)func
{
    YCellular* obj;
    obj = (YCellular*) [YFunction _FindFromCache:@"Cellular" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YCellular alloc] initWith:func]);
        [YFunction _AddToCache:@"Cellular" : func :obj];
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
-(int) registerValueCallback:(YCellularValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackCellular = callback;
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
    if (_valueCallbackCellular != NULL) {
        _valueCallbackCellular(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Sends a PUK code to unlock the SIM card after three failed PIN code attempts, and
 * setup a new PIN into the SIM card. Only ten consecutives tentatives are permitted:
 * after that, the SIM card will be blocked permanently without any mean of recovery
 * to use it again. Note that after calling this method, you have usually to invoke
 * method set_pin() to tell the YoctoHub which PIN to use in the future.
 *
 * @param puk : the SIM PUK code
 * @param newPin : new PIN code to configure into the SIM card
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sendPUK:(NSString*)puk :(NSString*)newPin
{
    NSString* gsmMsg;
    gsmMsg = [self get_message];
    if (!([gsmMsg isEqualToString:@"Enter SIM PUK"])) {[self _throw:YAPI_INVALID_ARGUMENT: @"PUK not expected at self time"]; return YAPI_INVALID_ARGUMENT;}
    if ([newPin isEqualToString:@""]) {
        return [self set_command:[NSString stringWithFormat:@"AT+CPIN=%@,0000;+CLCK=SC,0,0000",puk]];
    }
    return [self set_command:[NSString stringWithFormat:@"AT+CPIN=%@,%@",puk,newPin]];
}

/**
 * Configure authentication parameters to connect to the APN. Both
 * PAP and CHAP authentication are supported.
 *
 * @param username : APN username
 * @param password : APN password
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_apnAuth:(NSString*)username :(NSString*)password
{
    return [self set_apnSecret:[NSString stringWithFormat:@"%@,%@",username,password]];
}

/**
 * Sends an AT command to the GSM module and returns the command output.
 * The command will only execute when the GSM module is in standard
 * command state, and should leave it in the exact same state.
 * Use this function with great care !
 *
 * @param cmd : the AT command to execute, like for instance: "+CCLK?".
 *
 * @return a string with the result of the commands. Empty lines are
 *         automatically removed from the output.
 */
-(NSString*) _AT:(NSString*)cmd
{
    int chrPos;
    int cmdLen;
    int waitMore;
    NSString* res;
    NSMutableData* buff;
    int bufflen;
    NSString* buffstr;
    int buffstrlen;
    int idx;
    int suffixlen;
    // quote dangerous characters used in AT commands
    cmdLen = (int)[(cmd) length];
    chrPos = _ystrpos(cmd, @"#");
    while (chrPos >= 0) {
        cmd = [NSString stringWithFormat:@"%@%c23%@", [cmd substringWithRange:NSMakeRange( 0, chrPos)], 37,[cmd substringWithRange:NSMakeRange( chrPos+1, cmdLen-chrPos-1)]];
        cmdLen = cmdLen + 2;
        chrPos = _ystrpos(cmd, @"#");
    }
    chrPos = _ystrpos(cmd, @"+");
    while (chrPos >= 0) {
        cmd = [NSString stringWithFormat:@"%@%c2B%@", [cmd substringWithRange:NSMakeRange( 0, chrPos)], 37,[cmd substringWithRange:NSMakeRange( chrPos+1, cmdLen-chrPos-1)]];
        cmdLen = cmdLen + 2;
        chrPos = _ystrpos(cmd, @"+");
    }
    chrPos = _ystrpos(cmd, @"=");
    while (chrPos >= 0) {
        cmd = [NSString stringWithFormat:@"%@%c3D%@", [cmd substringWithRange:NSMakeRange( 0, chrPos)], 37,[cmd substringWithRange:NSMakeRange( chrPos+1, cmdLen-chrPos-1)]];
        cmdLen = cmdLen + 2;
        chrPos = _ystrpos(cmd, @"=");
    }
    cmd = [NSString stringWithFormat:@"at.txt?cmd=%@",cmd];
    res = [NSString stringWithFormat:@""];
    // max 2 minutes (each iteration may take up to 5 seconds if waiting)
    waitMore = 24;
    while (waitMore > 0) {
        buff = [self _download:cmd];
        bufflen = (int)[buff length];
        buffstr = ARC_sendAutorelease([[NSString alloc] initWithData:buff encoding:NSISOLatin1StringEncoding]);
        buffstrlen = (int)[(buffstr) length];
        idx = bufflen - 1;
        while ((idx > 0) && ((((u8*)([buff bytes]))[idx]) != 64) && ((((u8*)([buff bytes]))[idx]) != 10) && ((((u8*)([buff bytes]))[idx]) != 13)) {
            idx = idx - 1;
        }
        if ((((u8*)([buff bytes]))[idx]) == 64) {
            suffixlen = bufflen - idx;
            cmd = [NSString stringWithFormat:@"at.txt?cmd=%@",[buffstr substringWithRange:NSMakeRange( buffstrlen - suffixlen, suffixlen)]];
            buffstr = [buffstr substringWithRange:NSMakeRange( 0, buffstrlen - suffixlen)];
            waitMore = waitMore - 1;
        } else {
            waitMore = 0;
        }
        res = [NSString stringWithFormat:@"%@%@", res,buffstr];
    }
    return res;
}

/**
 * Returns the list detected cell operators in the neighborhood.
 * This function will typically take between 30 seconds to 1 minute to
 * return. Note that any SIM card can usually only connect to specific
 * operators. All networks returned by this function might therefore
 * not be available for connection.
 *
 * @return a list of string (cell operator names).
 */
-(NSMutableArray*) get_availableOperators
{
    NSString* cops;
    int idx;
    int slen;
    NSMutableArray* res = [NSMutableArray array];
    // may throw an exception
    cops = [self _AT:@"+COPS=?"];
    slen = (int)[(cops) length];
    [res removeAllObjects];
    idx = _ystrpos(cops, @"(");
    while (idx >= 0) {
        slen = slen - (idx+1);
        cops = [cops substringWithRange:NSMakeRange( idx+1, slen)];
        idx = _ystrpos(cops, @"\"");
        if (idx > 0) {
            slen = slen - (idx+1);
            cops = [cops substringWithRange:NSMakeRange( idx+1, slen)];
            idx = _ystrpos(cops, @"\"");
            if (idx > 0) {
                [res addObject:[cops substringWithRange:NSMakeRange( 0, idx)]];
            }
        }
        idx = _ystrpos(cops, @"(");
    }
    return res;
}

/**
 * Returns a list of nearby cellular antennas, as required for quick
 * geolocation of the device. The first cell listed is the serving
 * cell, and the next ones are the neighboor cells reported by the
 * serving cell.
 *
 * @return a list of YCellRecords.
 */
-(NSMutableArray*) quickCellSurvey
{
    NSString* moni;
    NSMutableArray* recs = [NSMutableArray array];
    int llen;
    NSString* mccs;
    int mcc;
    NSString* mncs;
    int mnc;
    int lac;
    int cellId;
    NSString* dbms;
    int dbm;
    NSString* tads;
    int tad;
    NSString* oper;
    NSMutableArray* res = [NSMutableArray array];
    // may throw an exception
    moni = [self _AT:@"+CCED=0;#MONI=7;#MONI"];
    mccs = [moni substringWithRange:NSMakeRange(7, 3)];
    if ([[mccs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        mccs = [mccs substringWithRange:NSMakeRange(1, 2)];
    }
    if ([[mccs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        mccs = [mccs substringWithRange:NSMakeRange(1, 1)];
    }
    mcc = [mccs intValue];
    mncs = [moni substringWithRange:NSMakeRange(11, 3)];
    if ([[mncs substringWithRange:NSMakeRange(2, 1)] isEqualToString:@","]) {
        mncs = [mncs substringWithRange:NSMakeRange(0, 2)];
    }
    if ([[mncs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        mncs = [mncs substringWithRange:NSMakeRange(1, (int)[(mncs) length]-1)];
    }
    mnc = [mncs intValue];
    recs = [NSMutableArray arrayWithArray:[moni componentsSeparatedByString:@"@'#"]];
    // process each line in turn
    [res removeAllObjects];
    for (NSString* _each  in recs) {
        llen = (int)[(_each) length] - 2;
        if (llen >= 44) {
            if ([[_each substringWithRange:NSMakeRange(41, 3)] isEqualToString:@"dbm"]) {
                lac = (int)strtoul(STR_oc2y([_each substringWithRange:NSMakeRange(16, 4)]), NULL, 16);
                cellId = (int)strtoul(STR_oc2y([_each substringWithRange:NSMakeRange(23, 4)]), NULL, 16);
                dbms = [_each substringWithRange:NSMakeRange(37, 4)];
                if ([[dbms substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
                    dbms = [dbms substringWithRange:NSMakeRange(1, 3)];
                }
                dbm = [dbms intValue];
                if (llen > 66) {
                    tads = [_each substringWithRange:NSMakeRange(54, 2)];
                    if ([[tads substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
                        tads = [tads substringWithRange:NSMakeRange(1, 3)];
                    }
                    tad = [tads intValue];
                    oper = [_each substringWithRange:NSMakeRange(66, llen-66)];
                } else {
                    tad = -1;
                    oper = @"";
                }
                if (lac < 65535) {
                    [res addObject:ARC_sendAutorelease([[YCellRecord alloc] initWith:mcc :mnc :lac :cellId :dbm :tad :oper])];
                }
            }
        }
        ;;
    }
    return res;
}


-(YCellular*)   nextCellular
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YCellular FindCellular:hwid];
}

+(YCellular *) FirstCellular
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Cellular":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YCellular FindCellular:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YCellular public methods implementation)

@end
//--- (generated code: Cellular functions)

YCellular *yFindCellular(NSString* func)
{
    return [YCellular FindCellular:func];
}

YCellular *yFirstCellular(void)
{
    return [YCellular FirstCellular];
}

//--- (end of generated code: Cellular functions)
