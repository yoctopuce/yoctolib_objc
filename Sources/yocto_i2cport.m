/*********************************************************************
 *
 *  $Id: yocto_i2cport.m 37168 2019-09-13 17:25:10Z mvuilleu $
 *
 *  Implements the high-level API for I2cPort functions
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


#import "yocto_i2cport.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YI2cPort

// Constructor is protected, use yFindI2cPort factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"I2cPort";
//--- (YI2cPort attributes initialization)
    _rxCount = Y_RXCOUNT_INVALID;
    _txCount = Y_TXCOUNT_INVALID;
    _errCount = Y_ERRCOUNT_INVALID;
    _rxMsgCount = Y_RXMSGCOUNT_INVALID;
    _txMsgCount = Y_TXMSGCOUNT_INVALID;
    _lastMsg = Y_LASTMSG_INVALID;
    _currentJob = Y_CURRENTJOB_INVALID;
    _startupJob = Y_STARTUPJOB_INVALID;
    _command = Y_COMMAND_INVALID;
    _protocol = Y_PROTOCOL_INVALID;
    _i2cVoltageLevel = Y_I2CVOLTAGELEVEL_INVALID;
    _i2cMode = Y_I2CMODE_INVALID;
    _valueCallbackI2cPort = NULL;
    _rxptr = 0;
    _rxbuffptr = 0;
//--- (end of YI2cPort attributes initialization)
    return self;
}
//--- (YI2cPort yapiwrapper)
//--- (end of YI2cPort yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YI2cPort cleanup)
    ARC_release(_lastMsg);
    _lastMsg = nil;
    ARC_release(_currentJob);
    _currentJob = nil;
    ARC_release(_startupJob);
    _startupJob = nil;
    ARC_release(_command);
    _command = nil;
    ARC_release(_protocol);
    _protocol = nil;
    ARC_release(_i2cMode);
    _i2cMode = nil;
    ARC_dealloc(super);
//--- (end of YI2cPort cleanup)
}
//--- (YI2cPort private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
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
    if(!strcmp(j->token, "protocol")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_protocol);
        _protocol =  [self _parseString:j];
        ARC_retain(_protocol);
        return 1;
    }
    if(!strcmp(j->token, "i2cVoltageLevel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _i2cVoltageLevel =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "i2cMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_i2cMode);
        _i2cMode =  [self _parseString:j];
        ARC_retain(_i2cMode);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YI2cPort private methods implementation)
//--- (YI2cPort public methods implementation)
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns Y_RXCOUNT_INVALID.
 */
-(int) get_rxCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXCOUNT_INVALID;
        }
    }
    res = _rxCount;
    return res;
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXCOUNT_INVALID;
        }
    }
    res = _txCount;
    return res;
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ERRCOUNT_INVALID;
        }
    }
    res = _errCount;
    return res;
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXMSGCOUNT_INVALID;
        }
    }
    res = _rxMsgCount;
    return res;
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
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXMSGCOUNT_INVALID;
        }
    }
    res = _txMsgCount;
    return res;
}


-(int) txMsgCount
{
    return [self get_txMsgCount];
}
/**
 * Returns the latest message fully received (for Line and Frame protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line and Frame protocols)
 *
 * On failure, throws an exception or returns Y_LASTMSG_INVALID.
 */
-(NSString*) get_lastMsg
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTMSG_INVALID;
        }
    }
    res = _lastMsg;
    return res;
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
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTJOB_INVALID;
        }
    }
    res = _currentJob;
    return res;
}


-(NSString*) currentJob
{
    return [self get_currentJob];
}

/**
 * Selects a job file to run immediately. If an empty string is
 * given as argument, stops running current job file.
 *
 * @param newval : a string
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
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_STARTUPJOB_INVALID;
        }
    }
    res = _startupJob;
    return res;
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
 * Returns the type of protocol used to send I2C messages, as a string.
 * Possible values are
 * "Line" for messages separated by LF or
 * "Char" for continuous stream of codes.
 *
 * @return a string corresponding to the type of protocol used to send I2C messages, as a string
 *
 * On failure, throws an exception or returns Y_PROTOCOL_INVALID.
 */
-(NSString*) get_protocol
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PROTOCOL_INVALID;
        }
    }
    res = _protocol;
    return res;
}


-(NSString*) protocol
{
    return [self get_protocol];
}

/**
 * Changes the type of protocol used to send I2C messages.
 * Possible values are
 * "Line" for messages separated by LF or
 * "Char" for continuous stream of codes.
 * The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
 * is always at lest the specified number of milliseconds between each message sent.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the type of protocol used to send I2C messages
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
 * Returns the voltage level used on the I2C bus.
 *
 * @return a value among Y_I2CVOLTAGELEVEL_OFF, Y_I2CVOLTAGELEVEL_3V3 and Y_I2CVOLTAGELEVEL_1V8
 * corresponding to the voltage level used on the I2C bus
 *
 * On failure, throws an exception or returns Y_I2CVOLTAGELEVEL_INVALID.
 */
-(Y_I2CVOLTAGELEVEL_enum) get_i2cVoltageLevel
{
    Y_I2CVOLTAGELEVEL_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_I2CVOLTAGELEVEL_INVALID;
        }
    }
    res = _i2cVoltageLevel;
    return res;
}


-(Y_I2CVOLTAGELEVEL_enum) i2cVoltageLevel
{
    return [self get_i2cVoltageLevel];
}

/**
 * Changes the voltage level used on the I2C bus.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_I2CVOLTAGELEVEL_OFF, Y_I2CVOLTAGELEVEL_3V3 and
 * Y_I2CVOLTAGELEVEL_1V8 corresponding to the voltage level used on the I2C bus
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_i2cVoltageLevel:(Y_I2CVOLTAGELEVEL_enum) newval
{
    return [self setI2cVoltageLevel:newval];
}
-(int) setI2cVoltageLevel:(Y_I2CVOLTAGELEVEL_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"i2cVoltageLevel" :rest_val];
}
/**
 * Returns the SPI port communication parameters, as a string such as
 * "400kbps,2000ms,NoRestart". The string includes the baud rate, the
 * recovery delay after communications errors, and if needed the option
 * NoRestart to use a Stop/Start sequence instead of the
 * Restart state when performing read on the I2C bus.
 *
 * @return a string corresponding to the SPI port communication parameters, as a string such as
 *         "400kbps,2000ms,NoRestart"
 *
 * On failure, throws an exception or returns Y_I2CMODE_INVALID.
 */
-(NSString*) get_i2cMode
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_I2CMODE_INVALID;
        }
    }
    res = _i2cMode;
    return res;
}


-(NSString*) i2cMode
{
    return [self get_i2cMode];
}

/**
 * Changes the SPI port communication parameters, with a string such as
 * "400kbps,2000ms". The string includes the baud rate, the
 * recovery delay after communications errors, and if needed the option
 * NoRestart to use a Stop/Start sequence instead of the
 * Restart state when performing read on the I2C bus.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the SPI port communication parameters, with a string such as
 *         "400kbps,2000ms"
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_i2cMode:(NSString*) newval
{
    return [self setI2cMode:newval];
}
-(int) setI2cMode:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"i2cMode" :rest_val];
}
/**
 * Retrieves an I2C port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the I2C port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YI2cPort.isOnline() to test if the I2C port is
 * indeed online at a given time. In case of ambiguity when looking for
 * an I2C port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the I2C port
 *
 * @return a YI2cPort object allowing you to drive the I2C port.
 */
+(YI2cPort*) FindI2cPort:(NSString*)func
{
    YI2cPort* obj;
    obj = (YI2cPort*) [YFunction _FindFromCache:@"I2cPort" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YI2cPort alloc] initWith:func]);
        [YFunction _AddToCache:@"I2cPort" : func :obj];
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
-(int) registerValueCallback:(YI2cPortValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackI2cPort = callback;
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
    if (_valueCallbackI2cPort != NULL) {
        _valueCallbackI2cPort(self, value);
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
 * Reads a single line (or message) from the receive buffer, starting at current stream position.
 * This function is intended to be used when the serial port is configured for a message protocol,
 * such as 'Line' mode or frame protocols.
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
 * does not affect the device, it only changes the value stored in the API object
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
 * Returns the current absolute stream position pointer of the API object.
 *
 * @return the absolute position index for next read operations.
 */
-(int) read_tell
{
    return _rxptr;
}

/**
 * Returns the number of bytes available to read in the input buffer starting from the
 * current absolute stream position pointer of the API object.
 *
 * @return the number of bytes available to read
 */
-(int) read_avail
{
    NSMutableData* buff;
    int bufflen;
    int res;

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
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*) queryLine:(NSString*)query :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;

    url = [NSString stringWithFormat:@"rxmsg.json?len=1&maxw=%d&cmd=!%@", maxWait,[self _escapeAttr:query]];
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
    _rxbuffptr = 0;
    _rxbuff = [NSMutableData dataWithLength:0];

    return [self sendCommand:@"Z"];
}

/**
 * Sends a one-way message (provided as a a binary buffer) to a device on the I2C bus.
 * This function checks and reports communication errors on the I2C bus.
 *
 * @param slaveAddr : the 7-bit address of the slave device (without the direction bit)
 * @param buff : the binary buffer to be sent
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) i2cSendBin:(int)slaveAddr :(NSData*)buff
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    NSString* reply;
    msg = [NSString stringWithFormat:@"@%02x:",slaveAddr];
    nBytes = (int)[buff length];
    idx = 0;
    while (idx < nBytes) {
        val = (((u8*)([buff bytes]))[idx]);
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }

    reply = [self queryLine:msg :1000];
    if (!((int)[(reply) length] > 0)) {[self _throw: YAPI_IO_ERROR: @"No response from I2C device"]; return YAPI_IO_ERROR;}
    idx = _ystrpos(reply, @"[N]!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"No I2C ACK received"]; return YAPI_IO_ERROR;}
    idx = _ystrpos(reply, @"!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"I2C protocol error"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Sends a one-way message (provided as a list of integer) to a device on the I2C bus.
 * This function checks and reports communication errors on the I2C bus.
 *
 * @param slaveAddr : the 7-bit address of the slave device (without the direction bit)
 * @param values : a list of data bytes to be sent
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) i2cSendArray:(int)slaveAddr :(NSMutableArray*)values
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    NSString* reply;
    msg = [NSString stringWithFormat:@"@%02x:",slaveAddr];
    nBytes = (int)[values count];
    idx = 0;
    while (idx < nBytes) {
        val = [[values objectAtIndex:idx] intValue];
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }

    reply = [self queryLine:msg :1000];
    if (!((int)[(reply) length] > 0)) {[self _throw: YAPI_IO_ERROR: @"No response from I2C device"]; return YAPI_IO_ERROR;}
    idx = _ystrpos(reply, @"[N]!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"No I2C ACK received"]; return YAPI_IO_ERROR;}
    idx = _ystrpos(reply, @"!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"I2C protocol error"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Sends a one-way message (provided as a a binary buffer) to a device on the I2C bus,
 * then read back the specified number of bytes from device.
 * This function checks and reports communication errors on the I2C bus.
 *
 * @param slaveAddr : the 7-bit address of the slave device (without the direction bit)
 * @param buff : the binary buffer to be sent
 * @param rcvCount : the number of bytes to receive once the data bytes are sent
 *
 * @return a list of bytes with the data received from slave device.
 *
 * On failure, throws an exception or returns an empty binary buffer.
 */
-(NSMutableData*) i2cSendAndReceiveBin:(int)slaveAddr :(NSData*)buff :(int)rcvCount
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    NSString* reply;
    NSMutableData* rcvbytes;
    msg = [NSString stringWithFormat:@"@%02x:",slaveAddr];
    nBytes = (int)[buff length];
    idx = 0;
    while (idx < nBytes) {
        val = (((u8*)([buff bytes]))[idx]);
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }
    idx = 0;
    while (idx < rcvCount) {
        msg = [NSString stringWithFormat:@"%@xx",msg];
        idx = idx + 1;
    }

    reply = [self queryLine:msg :1000];
    rcvbytes = [NSMutableData dataWithLength:0];
    if (!((int)[(reply) length] > 0)) {[self _throw: YAPI_IO_ERROR: @"No response from I2C device"]; return rcvbytes;}
    idx = _ystrpos(reply, @"[N]!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"No I2C ACK received"]; return rcvbytes;}
    idx = _ystrpos(reply, @"!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"I2C protocol error"]; return rcvbytes;}
    reply = [reply substringWithRange:NSMakeRange( (int)[(reply) length]-2*rcvCount, 2*rcvCount)];
    rcvbytes = [YAPI _hexStr2Bin:reply];
    return rcvbytes;
}

/**
 * Sends a one-way message (provided as a list of integer) to a device on the I2C bus,
 * then read back the specified number of bytes from device.
 * This function checks and reports communication errors on the I2C bus.
 *
 * @param slaveAddr : the 7-bit address of the slave device (without the direction bit)
 * @param values : a list of data bytes to be sent
 * @param rcvCount : the number of bytes to receive once the data bytes are sent
 *
 * @return a list of bytes with the data received from slave device.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) i2cSendAndReceiveArray:(int)slaveAddr :(NSMutableArray*)values :(int)rcvCount
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    NSString* reply;
    NSMutableData* rcvbytes;
    NSMutableArray* res = [NSMutableArray array];
    msg = [NSString stringWithFormat:@"@%02x:",slaveAddr];
    nBytes = (int)[values count];
    idx = 0;
    while (idx < nBytes) {
        val = [[values objectAtIndex:idx] intValue];
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }
    idx = 0;
    while (idx < rcvCount) {
        msg = [NSString stringWithFormat:@"%@xx",msg];
        idx = idx + 1;
    }

    reply = [self queryLine:msg :1000];
    if (!((int)[(reply) length] > 0)) {[self _throw: YAPI_IO_ERROR: @"No response from I2C device"]; return res;}
    idx = _ystrpos(reply, @"[N]!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"No I2C ACK received"]; return res;}
    idx = _ystrpos(reply, @"!");
    if (!(idx < 0)) {[self _throw: YAPI_IO_ERROR: @"I2C protocol error"]; return res;}
    reply = [reply substringWithRange:NSMakeRange( (int)[(reply) length]-2*rcvCount, 2*rcvCount)];
    rcvbytes = [YAPI _hexStr2Bin:reply];
    [res removeAllObjects];
    idx = 0;
    while (idx < rcvCount) {
        val = (((u8*)([rcvbytes bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:val]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Sends a text-encoded I2C code stream to the I2C bus, as is.
 * An I2C code stream is a string made of hexadecimal data bytes,
 * but that may also include the I2C state transitions code:
 * "{S}" to emit a start condition,
 * "{R}" for a repeated start condition,
 * "{P}" for a stop condition,
 * "xx" for receiving a data byte,
 * "{A}" to ack a data byte received and
 * "{N}" to nack a data byte received.
 * If a newline ("\n") is included in the stream, the message
 * will be terminated and a newline will also be added to the
 * receive stream.
 *
 * @param codes : the code stream to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeStr:(NSString*)codes
{
    int bufflen;
    NSMutableData* buff;
    int idx;
    int ch;
    buff = [NSMutableData dataWithData:[codes dataUsingEncoding:NSISOLatin1StringEncoding]];
    bufflen = (int)[buff length];
    if (bufflen < 100) {
        // if string is pure text, we can send it as a simple command (faster)
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
            return [self sendCommand:[NSString stringWithFormat:@"+%@",codes]];
        }
    }
    // send string using file upload
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a text-encoded I2C code stream to the I2C bus, and terminate
 * the message en relâchant le bus.
 * An I2C code stream is a string made of hexadecimal data bytes,
 * but that may also include the I2C state transitions code:
 * "{S}" to emit a start condition,
 * "{R}" for a repeated start condition,
 * "{P}" for a stop condition,
 * "xx" for receiving a data byte,
 * "{A}" to ack a data byte received and
 * "{N}" to nack a data byte received.
 * At the end of the stream, a stop condition is added if missing
 * and a newline is added to the receive buffer as well.
 *
 * @param codes : the code stream to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeLine:(NSString*)codes
{
    int bufflen;
    NSMutableData* buff;
    bufflen = (int)[(codes) length];
    if (bufflen < 100) {
        return [self sendCommand:[NSString stringWithFormat:@"!%@",codes]];
    }
    // send string using file upload
    buff = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@\n",codes] dataUsingEncoding:NSISOLatin1StringEncoding]];
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a single byte to the I2C bus. Depending on the I2C bus state, the byte
 * will be interpreted as an address byte or a data byte.
 *
 * @param code : the byte to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeByte:(int)code
{
    return [self sendCommand:[NSString stringWithFormat:@"+%02X",code]];
}

/**
 * Sends a byte sequence (provided as a hexadecimal string) to the I2C bus.
 * Depending on the I2C bus state, the first byte will be interpreted as an
 * address byte or a data byte.
 *
 * @param hexString : a string of hexadecimal byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeHex:(NSString*)hexString
{
    int bufflen;
    NSMutableData* buff;
    bufflen = (int)[(hexString) length];
    if (bufflen < 100) {
        return [self sendCommand:[NSString stringWithFormat:@"+%@",hexString]];
    }
    buff = [NSMutableData dataWithData:[hexString dataUsingEncoding:NSISOLatin1StringEncoding]];

    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a binary buffer to the I2C bus, as is.
 * Depending on the I2C bus state, the first byte will be interpreted
 * as an address byte or a data byte.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeBin:(NSData*)buff
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    msg = @"";
    nBytes = (int)[buff length];
    idx = 0;
    while (idx < nBytes) {
        val = (((u8*)([buff bytes]))[idx]);
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }

    return [self writeHex:msg];
}

/**
 * Sends a byte sequence (provided as a list of bytes) to the I2C bus.
 * Depending on the I2C bus state, the first byte will be interpreted as an
 * address byte or a data byte.
 *
 * @param byteList : a list of byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeArray:(NSMutableArray*)byteList
{
    int nBytes;
    int idx;
    int val;
    NSString* msg;
    msg = @"";
    nBytes = (int)[byteList count];
    idx = 0;
    while (idx < nBytes) {
        val = [[byteList objectAtIndex:idx] intValue];
        msg = [NSString stringWithFormat:@"%@%02x", msg,val];
        idx = idx + 1;
    }

    return [self writeHex:msg];
}


-(YI2cPort*)   nextI2cPort
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YI2cPort FindI2cPort:hwid];
}

+(YI2cPort *) FirstI2cPort
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"I2cPort":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YI2cPort FindI2cPort:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YI2cPort public methods implementation)

@end
//--- (YI2cPort functions)

YI2cPort *yFindI2cPort(NSString* func)
{
    return [YI2cPort FindI2cPort:func];
}

YI2cPort *yFirstI2cPort(void)
{
    return [YI2cPort FirstI2cPort];
}

//--- (end of YI2cPort functions)
