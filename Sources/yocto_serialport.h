/*********************************************************************
 *
 * $Id: yocto_serialport.h 49903 2022-05-25 14:18:36Z mvuilleu $
 *
 * Declares yFindSerialPort(), the high-level API for SerialPort functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN
@class YSerialPort;
@class YSnoopingRecord;

//--- (generated code: YSerialPort globals)
typedef void (*YSerialPortValueCallback)(YSerialPort *func, NSString *functionValue);
typedef void (*YSnoopingCallback)(YSerialPort *serialPort, YSnoopingRecord *rec);
#ifndef _Y_VOLTAGELEVEL_ENUM
#define _Y_VOLTAGELEVEL_ENUM
typedef enum {
    Y_VOLTAGELEVEL_OFF = 0,
    Y_VOLTAGELEVEL_TTL3V = 1,
    Y_VOLTAGELEVEL_TTL3VR = 2,
    Y_VOLTAGELEVEL_TTL5V = 3,
    Y_VOLTAGELEVEL_TTL5VR = 4,
    Y_VOLTAGELEVEL_RS232 = 5,
    Y_VOLTAGELEVEL_RS485 = 6,
    Y_VOLTAGELEVEL_TTL1V8 = 7,
    Y_VOLTAGELEVEL_SDI12 = 8,
    Y_VOLTAGELEVEL_INVALID = -1,
} Y_VOLTAGELEVEL_enum;
#endif
#define Y_RXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_TXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_ERRCOUNT_INVALID              YAPI_INVALID_UINT
#define Y_RXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_TXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_LASTMSG_INVALID               YAPI_INVALID_STRING
#define Y_CURRENTJOB_INVALID            YAPI_INVALID_STRING
#define Y_STARTUPJOB_INVALID            YAPI_INVALID_STRING
#define Y_JOBMAXTASK_INVALID            YAPI_INVALID_UINT
#define Y_JOBMAXSIZE_INVALID            YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
#define Y_PROTOCOL_INVALID              YAPI_INVALID_STRING
#define Y_SERIALMODE_INVALID            YAPI_INVALID_STRING
//--- (end of generated code: YSerialPort globals)


//--- (generated code: YSnoopingRecord globals)
//--- (end of generated code: YSnoopingRecord globals)




//--- (generated code: YSnoopingRecord class start)
/**
 * YSnoopingRecord Class: Intercepted serial message description, returned by serialPort.snoopMessages method
 *
 *
 */
@interface YSnoopingRecord : NSObject
//--- (end of generated code: YSnoopingRecord class start)
{
@protected
//--- (generated code: YSnoopingRecord attributes declaration)
    int             _tim;
    int             _dir;
    NSString*       _msg;
//--- (end of generated code: YSnoopingRecord attributes declaration)
}

-(id)   initWith:(NSString *)json_str;

//--- (generated code: YSnoopingRecord private methods declaration)
//--- (end of generated code: YSnoopingRecord private methods declaration)
//--- (generated code: YSnoopingRecord public methods declaration)
/**
 * Returns the elapsed time, in ms, since the beginning of the preceding message.
 *
 * @return the elapsed time, in ms, since the beginning of the preceding message.
 */
-(int)     get_time;

/**
 * Returns the message direction (RX=0, TX=1).
 *
 * @return the message direction (RX=0, TX=1).
 */
-(int)     get_direction;

/**
 * Returns the message content.
 *
 * @return the message content.
 */
-(NSString*)     get_message;


//--- (end of generated code: YSnoopingRecord public methods declaration)

@end

//--- (generated code: YSnoopingRecord functions declaration)
//--- (end of generated code: YSnoopingRecord functions declaration)


//--- (generated code: YSerialPort class start)
/**
 * YSerialPort Class: serial port control interface, available for instance in the Yocto-RS232, the
 * Yocto-RS485-V2 or the Yocto-Serial
 *
 * The YSerialPort class allows you to fully drive a Yoctopuce serial port.
 * It can be used to send and receive data, and to configure communication
 * parameters (baud rate, bit count, parity, flow control and protocol).
 * Note that Yoctopuce serial ports are not exposed as virtual COM ports.
 * They are meant to be used in the same way as all Yoctopuce devices.
 */
@interface YSerialPort : YFunction
//--- (end of generated code: YSerialPort class start)
{
@protected
//--- (generated code: YSerialPort attributes declaration)
    int             _rxCount;
    int             _txCount;
    int             _errCount;
    int             _rxMsgCount;
    int             _txMsgCount;
    NSString*       _lastMsg;
    NSString*       _currentJob;
    NSString*       _startupJob;
    int             _jobMaxTask;
    int             _jobMaxSize;
    NSString*       _command;
    NSString*       _protocol;
    Y_VOLTAGELEVEL_enum _voltageLevel;
    NSString*       _serialMode;
    YSerialPortValueCallback _valueCallbackSerialPort;
    int             _rxptr;
    NSMutableData*  _rxbuff;
    int             _rxbuffptr;
    int             _eventPos;
    YSnoopingCallback _eventCallback;
//--- (end of generated code: YSerialPort attributes declaration)
}
// Constructor is protected, use yFindSerialPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YSerialPort private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YSerialPort private methods declaration)
//--- (generated code: YSerialPort public methods declaration)
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns YSerialPort.RXCOUNT_INVALID.
 */
-(int)     get_rxCount;


-(int) rxCount;
/**
 * Returns the total number of bytes transmitted since last reset.
 *
 * @return an integer corresponding to the total number of bytes transmitted since last reset
 *
 * On failure, throws an exception or returns YSerialPort.TXCOUNT_INVALID.
 */
-(int)     get_txCount;


-(int) txCount;
/**
 * Returns the total number of communication errors detected since last reset.
 *
 * @return an integer corresponding to the total number of communication errors detected since last reset
 *
 * On failure, throws an exception or returns YSerialPort.ERRCOUNT_INVALID.
 */
-(int)     get_errCount;


-(int) errCount;
/**
 * Returns the total number of messages received since last reset.
 *
 * @return an integer corresponding to the total number of messages received since last reset
 *
 * On failure, throws an exception or returns YSerialPort.RXMSGCOUNT_INVALID.
 */
-(int)     get_rxMsgCount;


-(int) rxMsgCount;
/**
 * Returns the total number of messages send since last reset.
 *
 * @return an integer corresponding to the total number of messages send since last reset
 *
 * On failure, throws an exception or returns YSerialPort.TXMSGCOUNT_INVALID.
 */
-(int)     get_txMsgCount;


-(int) txMsgCount;
/**
 * Returns the latest message fully received (for Line, Frame and Modbus protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line, Frame and Modbus protocols)
 *
 * On failure, throws an exception or returns YSerialPort.LASTMSG_INVALID.
 */
-(NSString*)     get_lastMsg;


-(NSString*) lastMsg;
/**
 * Returns the name of the job file currently in use.
 *
 * @return a string corresponding to the name of the job file currently in use
 *
 * On failure, throws an exception or returns YSerialPort.CURRENTJOB_INVALID.
 */
-(NSString*)     get_currentJob;


-(NSString*) currentJob;
/**
 * Selects a job file to run immediately. If an empty string is
 * given as argument, stops running current job file.
 *
 * @param newval : a string
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns YSerialPort.STARTUPJOB_INVALID.
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_startupJob:(NSString*) newval;
-(int)     setStartupJob:(NSString*) newval;

/**
 * Returns the maximum number of tasks in a job that the device can handle.
 *
 * @return an integer corresponding to the maximum number of tasks in a job that the device can handle
 *
 * On failure, throws an exception or returns YSerialPort.JOBMAXTASK_INVALID.
 */
-(int)     get_jobMaxTask;


-(int) jobMaxTask;
/**
 * Returns maximum size allowed for job files.
 *
 * @return an integer corresponding to maximum size allowed for job files
 *
 * On failure, throws an exception or returns YSerialPort.JOBMAXSIZE_INVALID.
 */
-(int)     get_jobMaxSize;


-(int) jobMaxSize;
-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Returns the type of protocol used over the serial line, as a string.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "StxEtx" for ASCII messages delimited by STX/ETX codes,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Modbus-ASCII" for MODBUS messages in ASCII mode,
 * "Modbus-RTU" for MODBUS messages in RTU mode,
 * "Wiegand-ASCII" for Wiegand messages in ASCII mode,
 * "Wiegand-26","Wiegand-34", etc for Wiegand messages in byte mode,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 *
 * @return a string corresponding to the type of protocol used over the serial line, as a string
 *
 * On failure, throws an exception or returns YSerialPort.PROTOCOL_INVALID.
 */
-(NSString*)     get_protocol;


-(NSString*) protocol;
/**
 * Changes the type of protocol used over the serial line.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "StxEtx" for ASCII messages delimited by STX/ETX codes,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Modbus-ASCII" for MODBUS messages in ASCII mode,
 * "Modbus-RTU" for MODBUS messages in RTU mode,
 * "Wiegand-ASCII" for Wiegand messages in ASCII mode,
 * "Wiegand-26","Wiegand-34", etc for Wiegand messages in byte mode,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 * The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
 * is always at lest the specified number of milliseconds between each bytes sent.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the type of protocol used over the serial line
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_protocol:(NSString*) newval;
-(int)     setProtocol:(NSString*) newval;

/**
 * Returns the voltage level used on the serial line.
 *
 * @return a value among YSerialPort.VOLTAGELEVEL_OFF, YSerialPort.VOLTAGELEVEL_TTL3V,
 * YSerialPort.VOLTAGELEVEL_TTL3VR, YSerialPort.VOLTAGELEVEL_TTL5V, YSerialPort.VOLTAGELEVEL_TTL5VR,
 * YSerialPort.VOLTAGELEVEL_RS232, YSerialPort.VOLTAGELEVEL_RS485, YSerialPort.VOLTAGELEVEL_TTL1V8 and
 * YSerialPort.VOLTAGELEVEL_SDI12 corresponding to the voltage level used on the serial line
 *
 * On failure, throws an exception or returns YSerialPort.VOLTAGELEVEL_INVALID.
 */
-(Y_VOLTAGELEVEL_enum)     get_voltageLevel;


-(Y_VOLTAGELEVEL_enum) voltageLevel;
/**
 * Changes the voltage type used on the serial line. Valid
 * values  will depend on the Yoctopuce device model featuring
 * the serial port feature.  Check your device documentation
 * to find out which values are valid for that specific model.
 * Trying to set an invalid value will have no effect.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among YSerialPort.VOLTAGELEVEL_OFF, YSerialPort.VOLTAGELEVEL_TTL3V,
 * YSerialPort.VOLTAGELEVEL_TTL3VR, YSerialPort.VOLTAGELEVEL_TTL5V, YSerialPort.VOLTAGELEVEL_TTL5VR,
 * YSerialPort.VOLTAGELEVEL_RS232, YSerialPort.VOLTAGELEVEL_RS485, YSerialPort.VOLTAGELEVEL_TTL1V8 and
 * YSerialPort.VOLTAGELEVEL_SDI12 corresponding to the voltage type used on the serial line
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval;
-(int)     setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval;

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
 * On failure, throws an exception or returns YSerialPort.SERIALMODE_INVALID.
 */
-(NSString*)     get_serialMode;


-(NSString*) serialMode;
/**
 * Changes the serial port communication parameters, with a string such as
 * "9600,8N1". The string includes the baud rate, the number of data bits,
 * the parity, and the number of stop bits. An optional suffix can be added
 * to enable flow control: "CtsRts" for hardware handshake, "XOnXOff"
 * for logical flow control and "Simplex" for acquiring a shared bus using
 * the RTS line (as used by some RS485 adapters for instance).
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the serial port communication parameters, with a string such as
 *         "9600,8N1"
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_serialMode:(NSString*) newval;
-(int)     setSerialMode:(NSString*) newval;

/**
 * Retrieves a serial port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the serial port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSerialPort.isOnline() to test if the serial port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a serial port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the serial port, for instance
 *         RS232MK1.serialPort.
 *
 * @return a YSerialPort object allowing you to drive the serial port.
 */
+(YSerialPort*)     FindSerialPort:(NSString*)func;

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
-(int)     registerValueCallback:(YSerialPortValueCallback _Nullable)callback;

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
 * Sends a binary message to the serial port, and reads the reply, if any.
 * This function is intended to be used when the serial port is configured for
 * Frame-based protocol.
 *
 * @param hexString : the message to send, coded in hexadecimal
 * @param maxWait : the maximum number of milliseconds to wait for a reply.
 *
 * @return the next frame received after sending the message, as a hex string.
 *         Additional frames can be obtained by calling readHex or readMessages.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*)     queryHex:(NSString*)hexString :(int)maxWait;

/**
 * Saves the job definition string (JSON data) into a job file.
 * The job file can be later enabled using selectJob().
 *
 * @param jobfile : name of the job file to save on the device filesystem
 * @param jsonDef : a string containing a JSON definition of the job
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     selectJob:(NSString*)jobfile;

/**
 * Clears the serial port buffer and resets counters to zero.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

/**
 * Sends a single byte to the serial port.
 *
 * @param code : the byte to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeByte:(int)code;

/**
 * Sends an ASCII string to the serial port, as is.
 *
 * @param text : the text string to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeStr:(NSString*)text;

/**
 * Sends a binary buffer to the serial port, as is.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeBin:(NSData*)buff;

/**
 * Sends a byte sequence (provided as a list of bytes) to the serial port.
 *
 * @param byteList : a list of byte codes
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeArray:(NSMutableArray*)byteList;

/**
 * Sends a byte sequence (provided as a hexadecimal string) to the serial port.
 *
 * @param hexString : a string of hexadecimal byte codes
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeHex:(NSString*)hexString;

/**
 * Sends an ASCII string to the serial port, followed by a line break (CR LF).
 *
 * @param text : the text string to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeLine:(NSString*)text;

/**
 * Reads one byte from the receive buffer, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer,
 * or if there is no data available yet, the function returns YAPI_NO_MORE_DATA.
 *
 * @return the next byte
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     readByte;

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
-(NSString*)     readStr:(int)nChars;

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
-(NSMutableData*)     readBin:(int)nChars;

/**
 * Reads data from the receive buffer as a list of bytes, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer, the
 * function performs a short read.
 *
 * @param nChars : the maximum number of bytes to read
 *
 * @return a sequence of bytes with receive buffer contents
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     readArray:(int)nChars;

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
-(NSString*)     readHex:(int)nBytes;

/**
 * Emits a BREAK condition on the serial interface. When the specified
 * duration is 0, the BREAK signal will be exactly one character wide.
 * When the duration is between 1 and 100, the BREAK condition will
 * be hold for the specified number of milliseconds.
 *
 * @param duration : 0 for a standard BREAK, or duration between 1 and 100 ms
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sendBreak:(int)duration;

/**
 * Manually sets the state of the RTS line. This function has no effect when
 * hardware handshake is enabled, as the RTS line is driven automatically.
 *
 * @param val : 1 to turn RTS on, 0 to turn RTS off
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_RTS:(int)val;

/**
 * Reads the level of the CTS line. The CTS line is usually driven by
 * the RTS signal of the connected serial device.
 *
 * @return 1 if the CTS line is high, 0 if the CTS line is low.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     get_CTS;

/**
 * Retrieves messages (both direction) in the serial port buffer, starting at current position.
 * This function will only compare and return printable characters in the message strings.
 * Binary protocols are handled as hexadecimal strings.
 *
 * If no message is found, the search waits for one up to the specified maximum timeout
 * (in milliseconds).
 *
 * @param maxWait : the maximum number of milliseconds to wait for a message if none is found
 *         in the receive buffer.
 *
 * @return an array of YSnoopingRecord objects containing the messages found, if any.
 *         Binary messages are converted to hexadecimal representation.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     snoopMessages:(int)maxWait;

/**
 * Registers a callback function to be called each time that a message is sent or
 * received by the serial port. The callback is invoked only during the execution of
 * ySleep or yHandleEvents. This provides control over the time when
 * the callback is triggered. For good responsiveness, remember to call one of these
 * two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer.
 *         The callback function should take four arguments:
 *         the YSerialPort object that emitted the event, and
 *         the YSnoopingRecord object that describes the message
 *         sent or received.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     registerSnoopingCallback:(YSnoopingCallback _Nullable)callback;

-(int)     _internalEventHandler:(NSString*)advstr;

/**
 * Sends an ASCII string to the serial port, preceeded with an STX code and
 * followed by an ETX code.
 *
 * @param text : the text string to send
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeStxEtx:(NSString*)text;

/**
 * Sends a MODBUS message (provided as a hexadecimal string) to the serial port.
 * The message must start with the slave address. The MODBUS CRC/LRC is
 * automatically added by the function. This function does not wait for a reply.
 *
 * @param hexString : a hexadecimal message string, including device address but no CRC/LRC
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeMODBUS:(NSString*)hexString;

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
-(NSMutableArray*)     queryMODBUS:(int)slaveNo :(NSMutableArray*)pduBytes;

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
-(NSMutableArray*)     modbusReadBits:(int)slaveNo :(int)pduAddr :(int)nBits;

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
-(NSMutableArray*)     modbusReadInputBits:(int)slaveNo :(int)pduAddr :(int)nBits;

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
-(NSMutableArray*)     modbusReadRegisters:(int)slaveNo :(int)pduAddr :(int)nWords;

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
-(NSMutableArray*)     modbusReadInputRegisters:(int)slaveNo :(int)pduAddr :(int)nWords;

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
-(int)     modbusWriteBit:(int)slaveNo :(int)pduAddr :(int)value;

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
-(int)     modbusWriteBits:(int)slaveNo :(int)pduAddr :(NSMutableArray*)bits;

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
-(int)     modbusWriteRegister:(int)slaveNo :(int)pduAddr :(int)value;

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
-(int)     modbusWriteRegisters:(int)slaveNo :(int)pduAddr :(NSMutableArray*)values;

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
-(NSMutableArray*)     modbusWriteAndReadRegisters:(int)slaveNo :(int)pduWriteAddr :(NSMutableArray*)values :(int)pduReadAddr :(int)nReadWords;


/**
 * Continues the enumeration of serial ports started using yFirstSerialPort().
 * Caution: You can't make any assumption about the returned serial ports order.
 * If you want to find a specific a serial port, use SerialPort.findSerialPort()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSerialPort object, corresponding to
 *         a serial port currently online, or a nil pointer
 *         if there are no more serial ports to enumerate.
 */
-(nullable YSerialPort*) nextSerialPort
NS_SWIFT_NAME(nextSerialPort());
/**
 * Starts the enumeration of serial ports currently accessible.
 * Use the method YSerialPort.nextSerialPort() to iterate on
 * next serial ports.
 *
 * @return a pointer to a YSerialPort object, corresponding to
 *         the first serial port currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YSerialPort*) FirstSerialPort
NS_SWIFT_NAME(FirstSerialPort());
//--- (end of generated code: YSerialPort public methods declaration)

@end

//--- (generated code: YSerialPort functions declaration)
/**
 * Retrieves a serial port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the serial port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSerialPort.isOnline() to test if the serial port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a serial port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the serial port, for instance
 *         RS232MK1.serialPort.
 *
 * @return a YSerialPort object allowing you to drive the serial port.
 */
YSerialPort* yFindSerialPort(NSString* func);
/**
 * Starts the enumeration of serial ports currently accessible.
 * Use the method YSerialPort.nextSerialPort() to iterate on
 * next serial ports.
 *
 * @return a pointer to a YSerialPort object, corresponding to
 *         the first serial port currently online, or a nil pointer
 *         if there are none.
 */
YSerialPort* yFirstSerialPort(void);

//--- (end of generated code: YSerialPort functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

