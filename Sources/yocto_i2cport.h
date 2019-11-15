/*********************************************************************
 *
 *  $Id: yocto_i2cport.h 37827 2019-10-25 13:07:48Z mvuilleu $
 *
 *  Declares yFindI2cPort(), the high-level API for I2cPort functions
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

@class YI2cPort;

//--- (YI2cPort globals)
typedef void (*YI2cPortValueCallback)(YI2cPort *func, NSString *functionValue);
#ifndef _Y_I2CVOLTAGELEVEL_ENUM
#define _Y_I2CVOLTAGELEVEL_ENUM
typedef enum {
    Y_I2CVOLTAGELEVEL_OFF = 0,
    Y_I2CVOLTAGELEVEL_3V3 = 1,
    Y_I2CVOLTAGELEVEL_1V8 = 2,
    Y_I2CVOLTAGELEVEL_INVALID = -1,
} Y_I2CVOLTAGELEVEL_enum;
#endif
#define Y_RXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_TXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_ERRCOUNT_INVALID              YAPI_INVALID_UINT
#define Y_RXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_TXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_LASTMSG_INVALID               YAPI_INVALID_STRING
#define Y_CURRENTJOB_INVALID            YAPI_INVALID_STRING
#define Y_STARTUPJOB_INVALID            YAPI_INVALID_STRING
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
#define Y_PROTOCOL_INVALID              YAPI_INVALID_STRING
#define Y_I2CMODE_INVALID               YAPI_INVALID_STRING
//--- (end of YI2cPort globals)

//--- (YI2cPort class start)
/**
 * YI2cPort Class: I2C Port function interface
 *
 * The YI2cPort classe allows you to fully drive a Yoctopuce I2C port, for instance using a Yocto-I2C.
 * It can be used to send and receive data, and to configure communication
 * parameters (baud rate, etc).
 * Note that Yoctopuce I2C ports are not exposed as virtual COM ports.
 * They are meant to be used in the same way as all Yoctopuce devices.
 */
@interface YI2cPort : YFunction
//--- (end of YI2cPort class start)
{
@protected
//--- (YI2cPort attributes declaration)
    int             _rxCount;
    int             _txCount;
    int             _errCount;
    int             _rxMsgCount;
    int             _txMsgCount;
    NSString*       _lastMsg;
    NSString*       _currentJob;
    NSString*       _startupJob;
    NSString*       _command;
    NSString*       _protocol;
    Y_I2CVOLTAGELEVEL_enum _i2cVoltageLevel;
    NSString*       _i2cMode;
    YI2cPortValueCallback _valueCallbackI2cPort;
    int             _rxptr;
    NSMutableData*  _rxbuff;
    int             _rxbuffptr;
//--- (end of YI2cPort attributes declaration)
}
// Constructor is protected, use yFindI2cPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YI2cPort private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YI2cPort private methods declaration)
//--- (YI2cPort yapiwrapper declaration)
//--- (end of YI2cPort yapiwrapper declaration)
//--- (YI2cPort public methods declaration)
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns Y_RXCOUNT_INVALID.
 */
-(int)     get_rxCount;


-(int) rxCount;
/**
 * Returns the total number of bytes transmitted since last reset.
 *
 * @return an integer corresponding to the total number of bytes transmitted since last reset
 *
 * On failure, throws an exception or returns Y_TXCOUNT_INVALID.
 */
-(int)     get_txCount;


-(int) txCount;
/**
 * Returns the total number of communication errors detected since last reset.
 *
 * @return an integer corresponding to the total number of communication errors detected since last reset
 *
 * On failure, throws an exception or returns Y_ERRCOUNT_INVALID.
 */
-(int)     get_errCount;


-(int) errCount;
/**
 * Returns the total number of messages received since last reset.
 *
 * @return an integer corresponding to the total number of messages received since last reset
 *
 * On failure, throws an exception or returns Y_RXMSGCOUNT_INVALID.
 */
-(int)     get_rxMsgCount;


-(int) rxMsgCount;
/**
 * Returns the total number of messages send since last reset.
 *
 * @return an integer corresponding to the total number of messages send since last reset
 *
 * On failure, throws an exception or returns Y_TXMSGCOUNT_INVALID.
 */
-(int)     get_txMsgCount;


-(int) txMsgCount;
/**
 * Returns the latest message fully received (for Line and Frame protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line and Frame protocols)
 *
 * On failure, throws an exception or returns Y_LASTMSG_INVALID.
 */
-(NSString*)     get_lastMsg;


-(NSString*) lastMsg;
/**
 * Returns the name of the job file currently in use.
 *
 * @return a string corresponding to the name of the job file currently in use
 *
 * On failure, throws an exception or returns Y_CURRENTJOB_INVALID.
 */
-(NSString*)     get_currentJob;


-(NSString*) currentJob;
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
-(int)     set_currentJob:(NSString*) newval;
-(int)     setCurrentJob:(NSString*) newval;

/**
 * Returns the job file to use when the device is powered on.
 *
 * @return a string corresponding to the job file to use when the device is powered on
 *
 * On failure, throws an exception or returns Y_STARTUPJOB_INVALID.
 */
-(NSString*)     get_startupJob;


-(NSString*) startupJob;
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
-(int)     set_startupJob:(NSString*) newval;
-(int)     setStartupJob:(NSString*) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

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
-(NSString*)     get_protocol;


-(NSString*) protocol;
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
-(int)     set_protocol:(NSString*) newval;
-(int)     setProtocol:(NSString*) newval;

/**
 * Returns the voltage level used on the I2C bus.
 *
 * @return a value among Y_I2CVOLTAGELEVEL_OFF, Y_I2CVOLTAGELEVEL_3V3 and Y_I2CVOLTAGELEVEL_1V8
 * corresponding to the voltage level used on the I2C bus
 *
 * On failure, throws an exception or returns Y_I2CVOLTAGELEVEL_INVALID.
 */
-(Y_I2CVOLTAGELEVEL_enum)     get_i2cVoltageLevel;


-(Y_I2CVOLTAGELEVEL_enum) i2cVoltageLevel;
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
-(int)     set_i2cVoltageLevel:(Y_I2CVOLTAGELEVEL_enum) newval;
-(int)     setI2cVoltageLevel:(Y_I2CVOLTAGELEVEL_enum) newval;

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
-(NSString*)     get_i2cMode;


-(NSString*) i2cMode;
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
-(int)     set_i2cMode:(NSString*) newval;
-(int)     setI2cMode:(NSString*) newval;

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
 * @param func : a string that uniquely characterizes the I2C port, for instance
 *         YI2CMK01.i2cPort.
 *
 * @return a YI2cPort object allowing you to drive the I2C port.
 */
+(YI2cPort*)     FindI2cPort:(NSString*)func;

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
-(int)     registerValueCallback:(YI2cPortValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)text;

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
-(NSString*)     readLine;

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
-(NSMutableArray*)     readMessages:(NSString*)pattern :(int)maxWait;

/**
 * Changes the current internal stream position to the specified value. This function
 * does not affect the device, it only changes the value stored in the API object
 * for the next read operations.
 *
 * @param absPos : the absolute position index for next read operations.
 *
 * @return nothing.
 */
-(int)     read_seek:(int)absPos;

/**
 * Returns the current absolute stream position pointer of the API object.
 *
 * @return the absolute position index for next read operations.
 */
-(int)     read_tell;

/**
 * Returns the number of bytes available to read in the input buffer starting from the
 * current absolute stream position pointer of the API object.
 *
 * @return the number of bytes available to read
 */
-(int)     read_avail;

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
-(NSString*)     queryLine:(NSString*)query :(int)maxWait;

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
-(int)     uploadJob:(NSString*)jobfile :(NSString*)jsonDef;

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
-(int)     selectJob:(NSString*)jobfile;

/**
 * Clears the serial port buffer and resets counters to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

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
-(int)     i2cSendBin:(int)slaveAddr :(NSData*)buff;

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
-(int)     i2cSendArray:(int)slaveAddr :(NSMutableArray*)values;

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
-(NSMutableData*)     i2cSendAndReceiveBin:(int)slaveAddr :(NSData*)buff :(int)rcvCount;

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
-(NSMutableArray*)     i2cSendAndReceiveArray:(int)slaveAddr :(NSMutableArray*)values :(int)rcvCount;

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
-(int)     writeStr:(NSString*)codes;

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
-(int)     writeLine:(NSString*)codes;

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
-(int)     writeByte:(int)code;

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
-(int)     writeHex:(NSString*)hexString;

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
-(int)     writeBin:(NSData*)buff;

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
-(int)     writeArray:(NSMutableArray*)byteList;


/**
 * Continues the enumeration of I2C ports started using yFirstI2cPort().
 * Caution: You can't make any assumption about the returned I2C ports order.
 * If you want to find a specific an I2C port, use I2cPort.findI2cPort()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YI2cPort object, corresponding to
 *         an I2C port currently online, or a nil pointer
 *         if there are no more I2C ports to enumerate.
 */
-(YI2cPort*) nextI2cPort;
/**
 * Starts the enumeration of I2C ports currently accessible.
 * Use the method YI2cPort.nextI2cPort() to iterate on
 * next I2C ports.
 *
 * @return a pointer to a YI2cPort object, corresponding to
 *         the first I2C port currently online, or a nil pointer
 *         if there are none.
 */
+(YI2cPort*) FirstI2cPort;
//--- (end of YI2cPort public methods declaration)

@end

//--- (YI2cPort functions declaration)
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
 * @param func : a string that uniquely characterizes the I2C port, for instance
 *         YI2CMK01.i2cPort.
 *
 * @return a YI2cPort object allowing you to drive the I2C port.
 */
YI2cPort* yFindI2cPort(NSString* func);
/**
 * Starts the enumeration of I2C ports currently accessible.
 * Use the method YI2cPort.nextI2cPort() to iterate on
 * next I2C ports.
 *
 * @return a pointer to a YI2cPort object, corresponding to
 *         the first I2C port currently online, or a nil pointer
 *         if there are none.
 */
YI2cPort* yFirstI2cPort(void);

//--- (end of YI2cPort functions declaration)
CF_EXTERN_C_END

