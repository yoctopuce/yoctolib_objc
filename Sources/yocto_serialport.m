/*********************************************************************
 *
 * $Id: yocto_serialport.m 19817 2015-03-23 16:49:57Z seb $
 *
 * Implements the high-level API for SerialPort functions
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


#import "yocto_serialport.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YSerialPort

// Constructor is protected, use yFindSerialPort factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SerialPort";
//--- (YSerialPort attributes initialization)
    _serialMode = Y_SERIALMODE_INVALID;
    _protocol = Y_PROTOCOL_INVALID;
    _voltageLevel = Y_VOLTAGELEVEL_INVALID;
    _rxCount = Y_RXCOUNT_INVALID;
    _txCount = Y_TXCOUNT_INVALID;
    _errCount = Y_ERRCOUNT_INVALID;
    _rxMsgCount = Y_RXMSGCOUNT_INVALID;
    _txMsgCount = Y_TXMSGCOUNT_INVALID;
    _lastMsg = Y_LASTMSG_INVALID;
    _currentJob = Y_CURRENTJOB_INVALID;
    _startupJob = Y_STARTUPJOB_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackSerialPort = NULL;
    _rxptr = 0;
//--- (end of YSerialPort attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (YSerialPort cleanup)
    ARC_release(_serialMode);
    _serialMode = nil;
    ARC_release(_protocol);
    _protocol = nil;
    ARC_release(_lastMsg);
    _lastMsg = nil;
    ARC_release(_currentJob);
    _currentJob = nil;
    ARC_release(_startupJob);
    _startupJob = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YSerialPort cleanup)
}
//--- (YSerialPort private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "serialMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_serialMode);
        _serialMode =  [self _parseString:j];
        ARC_retain(_serialMode);
        return 1;
    }
    if(!strcmp(j->token, "protocol")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_protocol);
        _protocol =  [self _parseString:j];
        ARC_retain(_protocol);
        return 1;
    }
    if(!strcmp(j->token, "voltageLevel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageLevel =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rxCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rxCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "txCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _txCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "errCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _errCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rxMsgCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rxMsgCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "txMsgCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _txMsgCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastMsg")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_lastMsg);
        _lastMsg =  [self _parseString:j];
        ARC_retain(_lastMsg);
        return 1;
    }
    if(!strcmp(j->token, "currentJob")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_currentJob);
        _currentJob =  [self _parseString:j];
        ARC_retain(_currentJob);
        return 1;
    }
    if(!strcmp(j->token, "startupJob")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_startupJob);
        _startupJob =  [self _parseString:j];
        ARC_retain(_startupJob);
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
//--- (end of YSerialPort private methods implementation)
//--- (YSerialPort public methods implementation)
/**
 * Returns the serial port communication parameters, as a string such as
 * "9600,8N1". The string includes the baud rate, the number of data bits,
 * the parity, and the number of stop bits. An optional suffix is included
 * if flow control is active: "CtsRts" for hardware handshake, "XOnXOff"
 * for logical flow control and "Simplex" for acquiring a shared bus using
 * the RTS line (as used by some RS485 adapters for instance).
 *
 * @return a string corresponding to the serial port communication parameters, as a string such as
 *         "9600,8N1"
 *
 * On failure, throws an exception or returns Y_SERIALMODE_INVALID.
 */
-(NSString*) get_serialMode
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SERIALMODE_INVALID;
        }
    }
    return _serialMode;
}


-(NSString*) serialMode
{
    return [self get_serialMode];
}

/**
 * Changes the serial port communication parameters, with a string such as
 * "9600,8N1". The string includes the baud rate, the number of data bits,
 * the parity, and the number of stop bits. An optional suffix can be added
 * to enable flow control: "CtsRts" for hardware handshake, "XOnXOff"
 * for logical flow control and "Simplex" for acquiring a shared bus using
 * the RTS line (as used by some RS485 adapters for instance).
 *
 * @param newval : a string corresponding to the serial port communication parameters, with a string such as
 *         "9600,8N1"
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_serialMode:(NSString*) newval
{
    return [self setSerialMode:newval];
}
-(int) setSerialMode:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"serialMode" :rest_val];
}
/**
 * Returns the type of protocol used over the serial line, as a string.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Modbus-ASCII" for MODBUS messages in ASCII mode,
 * "Modbus-RTU" for MODBUS messages in RTU mode,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 *
 * @return a string corresponding to the type of protocol used over the serial line, as a string
 *
 * On failure, throws an exception or returns Y_PROTOCOL_INVALID.
 */
-(NSString*) get_protocol
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PROTOCOL_INVALID;
        }
    }
    return _protocol;
}


-(NSString*) protocol
{
    return [self get_protocol];
}

/**
 * Changes the type of protocol used over the serial line.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Modbus-ASCII" for MODBUS messages in ASCII mode,
 * "Modbus-RTU" for MODBUS messages in RTU mode,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 * The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
 * is always at lest the specified number of milliseconds between each bytes sent.
 *
 * @param newval : a string corresponding to the type of protocol used over the serial line
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_protocol:(NSString*) newval
{
    return [self setProtocol:newval];
}
-(int) setProtocol:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"protocol" :rest_val];
}
/**
 * Returns the voltage level used on the serial line.
 *
 * @return a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232 and Y_VOLTAGELEVEL_RS485
 * corresponding to the voltage level used on the serial line
 *
 * On failure, throws an exception or returns Y_VOLTAGELEVEL_INVALID.
 */
-(Y_VOLTAGELEVEL_enum) get_voltageLevel
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGELEVEL_INVALID;
        }
    }
    return _voltageLevel;
}


-(Y_VOLTAGELEVEL_enum) voltageLevel
{
    return [self get_voltageLevel];
}

/**
 * Changes the voltage type used on the serial line. Valid
 * values  will depend on the Yoctopuce device model featuring
 * the serial port feature.  Check your device documentation
 * to find out which values are valid for that specific model.
 * Trying to set an invalid value will have no effect.
 *
 * @param newval : a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232 and Y_VOLTAGELEVEL_RS485
 * corresponding to the voltage type used on the serial line
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval
{
    return [self setVoltageLevel:newval];
}
-(int) setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"voltageLevel" :rest_val];
}
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns Y_RXCOUNT_INVALID.
 */
-(int) get_rxCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXCOUNT_INVALID;
        }
    }
    return _rxCount;
}


-(int) rxCount
{
    return [self get_rxCount];
}
/**
 * Returns the total number of bytes transmitted since last reset.
 *
 * @return an integer corresponding to the total number of bytes transmitted since last reset
 *
 * On failure, throws an exception or returns Y_TXCOUNT_INVALID.
 */
-(int) get_txCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXCOUNT_INVALID;
        }
    }
    return _txCount;
}


-(int) txCount
{
    return [self get_txCount];
}
/**
 * Returns the total number of communication errors detected since last reset.
 *
 * @return an integer corresponding to the total number of communication errors detected since last reset
 *
 * On failure, throws an exception or returns Y_ERRCOUNT_INVALID.
 */
-(int) get_errCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_ERRCOUNT_INVALID;
        }
    }
    return _errCount;
}


-(int) errCount
{
    return [self get_errCount];
}
/**
 * Returns the total number of messages received since last reset.
 *
 * @return an integer corresponding to the total number of messages received since last reset
 *
 * On failure, throws an exception or returns Y_RXMSGCOUNT_INVALID.
 */
-(int) get_rxMsgCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXMSGCOUNT_INVALID;
        }
    }
    return _rxMsgCount;
}


-(int) rxMsgCount
{
    return [self get_rxMsgCount];
}
/**
 * Returns the total number of messages send since last reset.
 *
 * @return an integer corresponding to the total number of messages send since last reset
 *
 * On failure, throws an exception or returns Y_TXMSGCOUNT_INVALID.
 */
-(int) get_txMsgCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXMSGCOUNT_INVALID;
        }
    }
    return _txMsgCount;
}


-(int) txMsgCount
{
    return [self get_txMsgCount];
}
/**
 * Returns the latest message fully received (for Line, Frame and Modbus protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line, Frame and Modbus protocols)
 *
 * On failure, throws an exception or returns Y_LASTMSG_INVALID.
 */
-(NSString*) get_lastMsg
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTMSG_INVALID;
        }
    }
    return _lastMsg;
}


-(NSString*) lastMsg
{
    return [self get_lastMsg];
}
/**
 * Returns the name of the job file currently in use.
 *
 * @return a string corresponding to the name of the job file currently in use
 *
 * On failure, throws an exception or returns Y_CURRENTJOB_INVALID.
 */
-(NSString*) get_currentJob
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTJOB_INVALID;
        }
    }
    return _currentJob;
}


-(NSString*) currentJob
{
    return [self get_currentJob];
}

/**
 * Changes the job to use when the device is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the job to use when the device is powered on
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_currentJob:(NSString*) newval
{
    return [self setCurrentJob:newval];
}
-(int) setCurrentJob:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"currentJob" :rest_val];
}
/**
 * Returns the job file to use when the device is powered on.
 *
 * @return a string corresponding to the job file to use when the device is powered on
 *
 * On failure, throws an exception or returns Y_STARTUPJOB_INVALID.
 */
-(NSString*) get_startupJob
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_STARTUPJOB_INVALID;
        }
    }
    return _startupJob;
}


-(NSString*) startupJob
{
    return [self get_startupJob];
}

/**
 * Changes the job to use when the device is powered on.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the job to use when the device is powered on
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_startupJob:(NSString*) newval
{
    return [self setStartupJob:newval];
}
-(int) setStartupJob:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"startupJob" :rest_val];
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
 * Use the method YSerialPort.isOnline() to test if $THEFUNCTION$ is
 * indeed online at a given time. In case of ambiguity when looking for
 * $AFUNCTION$ by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes $THEFUNCTION$
 *
 * @return a YSerialPort object allowing you to drive $THEFUNCTION$.
 */
+(YSerialPort*) FindSerialPort:(NSString*)func
{
    YSerialPort* obj;
    obj = (YSerialPort*) [YFunction _FindFromCache:@"SerialPort" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSerialPort alloc] initWith:func]);
        [YFunction _AddToCache:@"SerialPort" : func :obj];
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
-(int) registerValueCallback:(YSerialPortValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSerialPort = callback;
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
    if (_valueCallbackSerialPort != NULL) {
        _valueCallbackSerialPort(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)text
{
    return [self set_command:text];
}

/**
 * Clears the serial port buffer and resets counters to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    _rxptr = 0;
    // may throw an exception
    return [self sendCommand:@"Z"];
}

/**
 * Manually sets the state of the RTS line. This function has no effect when
 * hardware handshake is enabled, as the RTS line is driven automatically.
 *
 * @param val : 1 to turn RTS on, 0 to turn RTS off
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_RTS:(int)val
{
    return [self sendCommand:[NSString stringWithFormat:@"R%d",val]];
}

/**
 * Reads the level of the CTS line. The CTS line is usually driven by
 * the RTS signal of the connected serial device.
 *
 * @return 1 if the CTS line is high, 0 if the CTS line is low.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_CTS
{
    NSMutableData* buff;
    int res;
    // may throw an exception
    buff = [self _download:@"cts.txt"];
    if (!((int)[buff length] == 1)) {[self _throw: YAPI_IO_ERROR: @"invalid CTS reply"]; return YAPI_IO_ERROR;}
    res = (((u8*)([buff bytes]))[0]) - 48;
    return res;
}

/**
 * Sends a single byte to the serial port.
 *
 * @param code : the byte to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeByte:(int)code
{
    return [self sendCommand:[NSString stringWithFormat:@"$%02x",code]];
}

/**
 * Sends an ASCII string to the serial port, as is.
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeStr:(NSString*)text
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int ch;
    buff = [NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]];
    bufflen = (int)[buff length];
    if (bufflen < 100) {
        ch = 0x20;
        idx = 0;
        while ((idx < bufflen) && (ch != 0)) {
            ch = (((u8*)([buff bytes]))[idx]);
            if ((ch >= 0x20) && (ch < 0x7f)) {
                idx = idx + 1;
            } else {
                ch = 0;
            }
        }
        if (idx >= bufflen) {
            return [self sendCommand:[NSString stringWithFormat:@"+%@",text]];
        }
    }
    // send string using file upload
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a binary buffer to the serial port, as is.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeBin:(NSData*)buff
{
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a byte sequence (provided as a list of bytes) to the serial port.
 *
 * @param byteList : a list of byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeArray:(NSMutableArray*)byteList
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int hexb;
    int res;
    bufflen = (int)[byteList count];
    buff = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        hexb = [[byteList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ idx]) = hexb;
        idx = idx + 1;
    }
    // may throw an exception
    res = [self _upload:@"txdata" :buff];
    return res;
}

/**
 * Sends a byte sequence (provided as a hexadecimal string) to the serial port.
 *
 * @param hexString : a string of hexadecimal byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeHex:(NSString*)hexString
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int hexb;
    int res;
    bufflen = (int)[(hexString) length];
    if (bufflen < 100) {
        return [self sendCommand:[NSString stringWithFormat:@"$%@",hexString]];
    }
    bufflen = ((bufflen) >> (1));
    buff = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        hexb = (int)strtoul(STR_oc2y([hexString substringWithRange:NSMakeRange( 2 * idx, 2)]), NULL, 16);
        (((u8*)([buff mutableBytes]))[ idx]) = hexb;
        idx = idx + 1;
    }
    // may throw an exception
    res = [self _upload:@"txdata" :buff];
    return res;
}

/**
 * Sends an ASCII string to the serial port, followed by a line break (CR LF).
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeLine:(NSString*)text
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int ch;
    buff = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@\r\n",text] dataUsingEncoding:NSISOLatin1StringEncoding]];
    bufflen = (int)[buff length]-2;
    if (bufflen < 100) {
        ch = 0x20;
        idx = 0;
        while ((idx < bufflen) && (ch != 0)) {
            ch = (((u8*)([buff bytes]))[idx]);
            if ((ch >= 0x20) && (ch < 0x7f)) {
                idx = idx + 1;
            } else {
                ch = 0;
            }
        }
        if (idx >= bufflen) {
            return [self sendCommand:[NSString stringWithFormat:@"!%@",text]];
        }
    }
    // send string using file upload
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a MODBUS message (provided as a hexadecimal string) to the serial port.
 * The message must start with the slave address. The MODBUS CRC/LRC is
 * automatically added by the function. This function does not wait for a reply.
 *
 * @param hexString : a hexadecimal message string, including device address but no CRC/LRC
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeMODBUS:(NSString*)hexString
{
    return [self sendCommand:[NSString stringWithFormat:@":%@",hexString]];
}

/**
 * Reads one byte from the receive buffer, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer,
 * or if there is no data available yet, the function returns YAPI_NO_MORE_DATA.
 *
 * @return the next byte
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) readByte
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int res;
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=1",_rxptr]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    if (bufflen == 0) {
        return YAPI_NO_MORE_DATA;
    }
    res = (((u8*)([buff bytes]))[0]);
    return res;
}

/**
 * Reads data from the receive buffer as a string, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer, the
 * function performs a short read.
 *
 * @param nChars : the maximum number of characters to read
 *
 * @return a string with receive buffer contents
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSString*) readStr:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    NSString* res;
    if (nChars > 65535) {
        nChars = 65535;
    }
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = [ARC_sendAutorelease([[NSString alloc] initWithData:buff encoding:NSISOLatin1StringEncoding]) substringWithRange:NSMakeRange( 0, bufflen)];
    return res;
}

/**
 * Reads data from the receive buffer as a binary buffer, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer, the
 * function performs a short read.
 *
 * @param nChars : the maximum number of bytes to read
 *
 * @return a binary object with receive buffer contents
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSMutableData*) readBin:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int idx;
    NSMutableData* res;
    if (nChars > 65535) {
        nChars = 65535;
    }
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        (((u8*)([res mutableBytes]))[ idx]) = (((u8*)([buff bytes]))[idx]);
        idx = idx + 1;
    }
    return res;
}

/**
 * Reads data from the receive buffer as a list of bytes, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer, the
 * function performs a short read.
 *
 * @param nChars : the maximum number of bytes to read
 *
 * @return a sequence of bytes with receive buffer contents
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSMutableArray*) readArray:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int idx;
    int b;
    NSMutableArray* res = [NSMutableArray array];
    if (nChars > 65535) {
        nChars = 65535;
    }
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    [res removeAllObjects];
    idx = 0;
    while (idx < bufflen) {
        b = (((u8*)([buff bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:b]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Reads data from the receive buffer as a hexadecimal string, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer, the
 * function performs a short read.
 *
 * @param nBytes : the maximum number of bytes to read
 *
 * @return a string with receive buffer contents, encoded in hexadecimal
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSString*) readHex:(int)nBytes
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int ofs;
    NSString* res;
    if (nBytes > 65535) {
        nBytes = 65535;
    }
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nBytes]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = @"";
    ofs = 0;
    while (ofs + 3 < bufflen) {
        res = [NSString stringWithFormat:@"%@%02x%02x%02x%02x", res, (((u8*)([buff bytes]))[ofs]), (((u8*)([buff bytes]))[ofs + 1]), (((u8*)([buff bytes]))[ofs + 2]),(((u8*)([buff bytes]))[ofs + 3])];
        ofs = ofs + 4;
    }
    while (ofs < bufflen) {
        res = [NSString stringWithFormat:@"%@%02x", res,(((u8*)([buff bytes]))[ofs])];
        ofs = ofs + 1;
    }
    return res;
}

/**
 * Reads a single line (or message) from the receive buffer, starting at current stream position.
 * This function is intended to be used when the serial port is configured for a message protocol,
 * such as 'Line' mode or MODBUS protocols.
 *
 * If data at current stream position is not available anymore in the receive buffer,
 * the function returns the oldest available line and moves the stream position just after.
 * If no new full line is received, the function returns an empty line.
 *
 * @return a string with a single line of text
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(NSString*) readLine
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;
    // may throw an exception
    url = [NSString stringWithFormat:@"rxmsg.json?pos=%d&len=1&maxw=1",_rxptr];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return @"";
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    if (msglen == 0) {
        return @"";
    }
    res = [self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return res;
}

/**
 * Searches for incoming messages in the serial port receive buffer matching a given pattern,
 * starting at current position. This function will only compare and return printable characters
 * in the message strings. Binary protocols are handled as hexadecimal strings.
 *
 * The search returns all messages matching the expression provided as argument in the buffer.
 * If no matching message is found, the search waits for one up to the specified maximum timeout
 * (in milliseconds).
 *
 * @param pattern : a limited regular expression describing the expected message format,
 *         or an empty string if all messages should be returned (no filtering).
 *         When using binary protocols, the format applies to the hexadecimal
 *         representation of the message.
 * @param maxWait : the maximum number of milliseconds to wait for a message if none is found
 *         in the receive buffer.
 *
 * @return an array of strings containing the messages found, if any.
 *         Binary messages are converted to hexadecimal representation.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) readMessages:(NSString*)pattern :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    // may throw an exception
    url = [NSString stringWithFormat:@"rxmsg.json?pos=%d&maxw=%d&pat=%@", _rxptr, maxWait,pattern];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return res;
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    idx = 0;
    while (idx < msglen) {
        [res addObject:[self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:idx] dataUsingEncoding:NSISOLatin1StringEncoding]]]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Changes the current internal stream position to the specified value. This function
 * does not affect the device, it only changes the value stored in the YSerialPort object
 * for the next read operations.
 *
 * @param absPos : the absolute position index for next read operations.
 *
 * @return nothing.
 */
-(int) read_seek:(int)absPos
{
    _rxptr = absPos;
    return YAPI_SUCCESS;
}

/**
 * Returns the current absolute stream position pointer of the YSerialPort object.
 *
 * @return the absolute position index for next read operations.
 */
-(int) read_tell
{
    return _rxptr;
}

/**
 * Returns the number of bytes available to read in the input buffer starting from the
 * current absolute stream position pointer of the YSerialPort object.
 *
 * @return the number of bytes available to read
 */
-(int) read_avail
{
    NSMutableData* buff;
    int bufflen;
    int res;
    // may throw an exception
    buff = [self _download:[NSString stringWithFormat:@"rxcnt.bin?pos=%d",_rxptr]];
    bufflen = (int)[buff length] - 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        bufflen = bufflen - 1;
    }
    res = [[ARC_sendAutorelease([[NSString alloc] initWithData:buff encoding:NSISOLatin1StringEncoding]) substringWithRange:NSMakeRange( 0, bufflen)] intValue];
    return res;
}

/**
 * Sends a text line query to the serial port, and reads the reply, if any.
 * This function is intended to be used when the serial port is configured for 'Line' protocol.
 *
 * @param query : the line query to send (without CR/LF)
 * @param maxWait : the maximum number of milliseconds to wait for a reply.
 *
 * @return the next text line received after sending the text query, as a string.
 *         Additional lines can be obtained by calling readLine or readMessages.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSString*) queryLine:(NSString*)query :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;
    // may throw an exception
    url = [NSString stringWithFormat:@"rxmsg.json?len=1&maxw=%d&cmd=!%@", maxWait,query];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return @"";
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    if (msglen == 0) {
        return @"";
    }
    res = [self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return res;
}

/**
 * Sends a message to a specified MODBUS slave connected to the serial port, and reads the
 * reply, if any. The message is the PDU, provided as a vector of bytes.
 *
 * @param slaveNo : the address of the slave MODBUS device to query
 * @param pduBytes : the message to send (PDU), as a vector of bytes. The first byte of the
 *         PDU is the MODBUS function code.
 *
 * @return the received reply, as a vector of bytes.
 *
 * On failure, throws an exception or returns an empty array (or a MODBUS error reply).
 */
-(NSMutableArray*) queryMODBUS:(int)slaveNo :(NSMutableArray*)pduBytes
{
    int funCode;
    int nib;
    int i;
    NSString* cmd;
    NSString* url;
    NSString* pat;
    NSMutableData* msgs;
    NSMutableArray* reps = [NSMutableArray array];
    NSString* rep;
    NSMutableArray* res = [NSMutableArray array];
    int replen;
    int hexb;
    funCode = [[pduBytes objectAtIndex:0] intValue];
    nib = ((funCode) >> (4));
    pat = [NSString stringWithFormat:@"%02x[%x%x]%x.*", slaveNo, nib, (nib+8),((funCode) & (15))];
    cmd = [NSString stringWithFormat:@"%02x%02x", slaveNo,funCode];
    i = 1;
    while (i < (int)[pduBytes count]) {
        cmd = [NSString stringWithFormat:@"%@%02x", cmd,(([[pduBytes objectAtIndex:i] intValue]) & (0xff))];
        i = i + 1;
    }
    // may throw an exception
    url = [NSString stringWithFormat:@"rxmsg.json?cmd=:%@&pat=:%@", cmd,pat];
    msgs = [self _download:url];
    reps = [self _json_get_array:msgs];
    if (!((int)[reps count] > 1)) {[self _throw: YAPI_IO_ERROR: @"no reply from slave"]; return res;}
    if ((int)[reps count] > 1) {
        rep = [self _json_get_string:[NSMutableData dataWithData:[[reps objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
        replen = (((int)[(rep) length] - 3) >> (1));
        i = 0;
        while (i < replen) {
            hexb = (int)strtoul(STR_oc2y([rep substringWithRange:NSMakeRange(2 * i + 3, 2)]), NULL, 16);
            [res addObject:[NSNumber numberWithLong:hexb]];
            i = i + 1;
        }
        if ([[res objectAtIndex:0] intValue] != funCode) {
            i = [[res objectAtIndex:1] intValue];
            if (!(i > 1)) {[self _throw: YAPI_NOT_SUPPORTED: @"MODBUS error: unsupported function code"]; return res;}
            if (!(i > 2)) {[self _throw: YAPI_INVALID_ARGUMENT: @"MODBUS error: illegal data address"]; return res;}
            if (!(i > 3)) {[self _throw: YAPI_INVALID_ARGUMENT: @"MODBUS error: illegal data value"]; return res;}
            if (!(i > 4)) {[self _throw: YAPI_INVALID_ARGUMENT: @"MODBUS error: failed to execute function"]; return res;}
        }
    }
    return res;
}

/**
 * Reads one or more contiguous internal bits (or coil status) from a MODBUS serial device.
 * This method uses the MODBUS function code 0x01 (Read Coils).
 *
 * @param slaveNo : the address of the slave MODBUS device to query
 * @param pduAddr : the relative address of the first bit/coil to read (zero-based)
 * @param nBits : the number of bits/coils to read
 *
 * @return a vector of integers, each corresponding to one bit.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) modbusReadBits:(int)slaveNo :(int)pduAddr :(int)nBits
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    int bitpos;
    int idx;
    int val;
    int mask;
    [pdu addObject:[NSNumber numberWithLong:0x01]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) & (0xff))]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    bitpos = 0;
    idx = 2;
    val = [[reply objectAtIndex:idx] intValue];
    mask = 1;
    while (bitpos < nBits) {
        if (((val) & (mask)) == 0) {
            [res addObject:[NSNumber numberWithLong:0]];
        } else {
            [res addObject:[NSNumber numberWithLong:1]];
        }
        bitpos = bitpos + 1;
        if (mask == 0x80) {
            idx = idx + 1;
            val = [[reply objectAtIndex:idx] intValue];
            mask = 1;
        } else {
            mask = ((mask) << (1));
        }
    }
    return res;
}

/**
 * Reads one or more contiguous input bits (or discrete inputs) from a MODBUS serial device.
 * This method uses the MODBUS function code 0x02 (Read Discrete Inputs).
 *
 * @param slaveNo : the address of the slave MODBUS device to query
 * @param pduAddr : the relative address of the first bit/input to read (zero-based)
 * @param nBits : the number of bits/inputs to read
 *
 * @return a vector of integers, each corresponding to one bit.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) modbusReadInputBits:(int)slaveNo :(int)pduAddr :(int)nBits
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    int bitpos;
    int idx;
    int val;
    int mask;
    [pdu addObject:[NSNumber numberWithLong:0x02]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) & (0xff))]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    bitpos = 0;
    idx = 2;
    val = [[reply objectAtIndex:idx] intValue];
    mask = 1;
    while (bitpos < nBits) {
        if (((val) & (mask)) == 0) {
            [res addObject:[NSNumber numberWithLong:0]];
        } else {
            [res addObject:[NSNumber numberWithLong:1]];
        }
        bitpos = bitpos + 1;
        if (mask == 0x80) {
            idx = idx + 1;
            val = [[reply objectAtIndex:idx] intValue];
            mask = 1;
        } else {
            mask = ((mask) << (1));
        }
    }
    return res;
}

/**
 * Reads one or more contiguous internal registers (holding registers) from a MODBUS serial device.
 * This method uses the MODBUS function code 0x03 (Read Holding Registers).
 *
 * @param slaveNo : the address of the slave MODBUS device to query
 * @param pduAddr : the relative address of the first holding register to read (zero-based)
 * @param nWords : the number of holding registers to read
 *
 * @return a vector of integers, each corresponding to one 16-bit register value.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) modbusReadRegisters:(int)slaveNo :(int)pduAddr :(int)nWords
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    int regpos;
    int idx;
    int val;
    [pdu addObject:[NSNumber numberWithLong:0x03]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) & (0xff))]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    regpos = 0;
    idx = 2;
    while (regpos < nWords) {
        val = (([[reply objectAtIndex:idx] intValue]) << (8));
        idx = idx + 1;
        val = val + [[reply objectAtIndex:idx] intValue];
        idx = idx + 1;
        [res addObject:[NSNumber numberWithLong:val]];
        regpos = regpos + 1;
    }
    return res;
}

/**
 * Reads one or more contiguous input registers (read-only registers) from a MODBUS serial device.
 * This method uses the MODBUS function code 0x04 (Read Input Registers).
 *
 * @param slaveNo : the address of the slave MODBUS device to query
 * @param pduAddr : the relative address of the first input register to read (zero-based)
 * @param nWords : the number of input registers to read
 *
 * @return a vector of integers, each corresponding to one 16-bit input value.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) modbusReadInputRegisters:(int)slaveNo :(int)pduAddr :(int)nWords
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    int regpos;
    int idx;
    int val;
    [pdu addObject:[NSNumber numberWithLong:0x04]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) & (0xff))]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    regpos = 0;
    idx = 2;
    while (regpos < nWords) {
        val = (([[reply objectAtIndex:idx] intValue]) << (8));
        idx = idx + 1;
        val = val + [[reply objectAtIndex:idx] intValue];
        idx = idx + 1;
        [res addObject:[NSNumber numberWithLong:val]];
        regpos = regpos + 1;
    }
    return res;
}

/**
 * Sets a single internal bit (or coil) on a MODBUS serial device.
 * This method uses the MODBUS function code 0x05 (Write Single Coil).
 *
 * @param slaveNo : the address of the slave MODBUS device to drive
 * @param pduAddr : the relative address of the bit/coil to set (zero-based)
 * @param value : the value to set (0 for OFF state, non-zero for ON state)
 *
 * @return the number of bits/coils affected on the device (1)
 *
 * On failure, throws an exception or returns zero.
 */
-(int) modbusWriteBit:(int)slaveNo :(int)pduAddr :(int)value
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    int res;
    res = 0;
    if (value != 0) {
        value = 0xff;
    }
    [pdu addObject:[NSNumber numberWithLong:0x05]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:value]];
    [pdu addObject:[NSNumber numberWithLong:0x00]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    res = 1;
    return res;
}

/**
 * Sets several contiguous internal bits (or coils) on a MODBUS serial device.
 * This method uses the MODBUS function code 0x0f (Write Multiple Coils).
 *
 * @param slaveNo : the address of the slave MODBUS device to drive
 * @param pduAddr : the relative address of the first bit/coil to set (zero-based)
 * @param bits : the vector of bits to be set (one integer per bit)
 *
 * @return the number of bits/coils affected on the device
 *
 * On failure, throws an exception or returns zero.
 */
-(int) modbusWriteBits:(int)slaveNo :(int)pduAddr :(NSMutableArray*)bits
{
    int nBits;
    int nBytes;
    int bitpos;
    int val;
    int mask;
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    int res;
    res = 0;
    nBits = (int)[bits count];
    nBytes = (((nBits + 7)) >> (3));
    [pdu addObject:[NSNumber numberWithLong:0x0f]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nBits) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:nBytes]];
    bitpos = 0;
    val = 0;
    mask = 1;
    while (bitpos < nBits) {
        if ([[bits objectAtIndex:bitpos] intValue] != 0) {
            val = ((val) | (mask));
        }
        bitpos = bitpos + 1;
        if (mask == 0x80) {
            [pdu addObject:[NSNumber numberWithLong:val]];
            val = 0;
            mask = 1;
        } else {
            mask = ((mask) << (1));
        }
    }
    if (mask != 1) {
        [pdu addObject:[NSNumber numberWithLong:val]];
    }
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    res = (([[reply objectAtIndex:3] intValue]) << (8));
    res = res + [[reply objectAtIndex:4] intValue];
    return res;
}

/**
 * Sets a single internal register (or holding register) on a MODBUS serial device.
 * This method uses the MODBUS function code 0x06 (Write Single Register).
 *
 * @param slaveNo : the address of the slave MODBUS device to drive
 * @param pduAddr : the relative address of the register to set (zero-based)
 * @param value : the 16 bit value to set
 *
 * @return the number of registers affected on the device (1)
 *
 * On failure, throws an exception or returns zero.
 */
-(int) modbusWriteRegister:(int)slaveNo :(int)pduAddr :(int)value
{
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    int res;
    res = 0;
    if (value != 0) {
        value = 0xff;
    }
    [pdu addObject:[NSNumber numberWithLong:0x06]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((value) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((value) & (0xff))]];
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    res = 1;
    return res;
}

/**
 * Sets several contiguous internal registers (or holding registers) on a MODBUS serial device.
 * This method uses the MODBUS function code 0x10 (Write Multiple Registers).
 *
 * @param slaveNo : the address of the slave MODBUS device to drive
 * @param pduAddr : the relative address of the first internal register to set (zero-based)
 * @param values : the vector of 16 bit values to set
 *
 * @return the number of registers affected on the device
 *
 * On failure, throws an exception or returns zero.
 */
-(int) modbusWriteRegisters:(int)slaveNo :(int)pduAddr :(NSMutableArray*)values
{
    int nWords;
    int nBytes;
    int regpos;
    int val;
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    int res;
    res = 0;
    nWords = (int)[values count];
    nBytes = 2 * nWords;
    [pdu addObject:[NSNumber numberWithLong:0x10]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nWords) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:nBytes]];
    regpos = 0;
    while (regpos < nWords) {
        val = [[values objectAtIndex:regpos] intValue];
        [pdu addObject:[NSNumber numberWithLong:((val) >> (8))]];
        [pdu addObject:[NSNumber numberWithLong:((val) & (0xff))]];
        regpos = regpos + 1;
    }
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    res = (([[reply objectAtIndex:3] intValue]) << (8));
    res = res + [[reply objectAtIndex:4] intValue];
    return res;
}

/**
 * Sets several contiguous internal registers (holding registers) on a MODBUS serial device,
 * then performs a contiguous read of a set of (possibly different) internal registers.
 * This method uses the MODBUS function code 0x17 (Read/Write Multiple Registers).
 *
 * @param slaveNo : the address of the slave MODBUS device to drive
 * @param pduWriteAddr : the relative address of the first internal register to set (zero-based)
 * @param values : the vector of 16 bit values to set
 * @param pduReadAddr : the relative address of the first internal register to read (zero-based)
 * @param nReadWords : the number of 16 bit values to read
 *
 * @return a vector of integers, each corresponding to one 16-bit register value read.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) modbusWriteAndReadRegisters:(int)slaveNo :(int)pduWriteAddr :(NSMutableArray*)values :(int)pduReadAddr :(int)nReadWords
{
    int nWriteWords;
    int nBytes;
    int regpos;
    int val;
    int idx;
    NSMutableArray* pdu = [NSMutableArray array];
    NSMutableArray* reply = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    nWriteWords = (int)[values count];
    nBytes = 2 * nWriteWords;
    [pdu addObject:[NSNumber numberWithLong:0x17]];
    [pdu addObject:[NSNumber numberWithLong:((pduReadAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduReadAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nReadWords) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nReadWords) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((pduWriteAddr) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((pduWriteAddr) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:((nWriteWords) >> (8))]];
    [pdu addObject:[NSNumber numberWithLong:((nWriteWords) & (0xff))]];
    [pdu addObject:[NSNumber numberWithLong:nBytes]];
    regpos = 0;
    while (regpos < nWriteWords) {
        val = [[values objectAtIndex:regpos] intValue];
        [pdu addObject:[NSNumber numberWithLong:((val) >> (8))]];
        [pdu addObject:[NSNumber numberWithLong:((val) & (0xff))]];
        regpos = regpos + 1;
    }
    // may throw an exception
    reply = [self queryMODBUS:slaveNo :pdu];
    if ((int)[reply count] == 0) {
        return res;
    }
    if ([[reply objectAtIndex:0] intValue] != [[pdu objectAtIndex:0] intValue]) {
        return res;
    }
    regpos = 0;
    idx = 2;
    while (regpos < nReadWords) {
        val = (([[reply objectAtIndex:idx] intValue]) << (8));
        idx = idx + 1;
        val = val + [[reply objectAtIndex:idx] intValue];
        idx = idx + 1;
        [res addObject:[NSNumber numberWithLong:val]];
        regpos = regpos + 1;
    }
    return res;
}

/**
 * Saves the job definition string (JSON data) into a job file.
 * The job file can be later enabled using selectJob().
 *
 * @param jobfile : name of the job file to save on the device filesystem
 * @param jsonDef : a string containing a JSON definition of the job
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) uploadJob:(NSString*)jobfile :(NSString*)jsonDef
{
    [self _upload:jobfile :[NSMutableData dataWithData:[jsonDef dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return YAPI_SUCCESS;
}

/**
 * Load and start processing the specified job file. The file must have
 * been previously created using the user interface or uploaded on the
 * device filesystem using the uploadJob() function.
 *
 * @param jobfile : name of the job file (on the device filesystem)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) selectJob:(NSString*)jobfile
{
    return [self set_currentJob:jobfile];
}


-(YSerialPort*)   nextSerialPort
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSerialPort FindSerialPort:hwid];
}

+(YSerialPort *) FirstSerialPort
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SerialPort":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSerialPort FindSerialPort:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSerialPort public methods implementation)

@end
//--- (SerialPort functions)

YSerialPort *yFindSerialPort(NSString* func)
{
    return [YSerialPort FindSerialPort:func];
}

YSerialPort *yFirstSerialPort(void)
{
    return [YSerialPort FirstSerialPort];
}

//--- (end of SerialPort functions)
