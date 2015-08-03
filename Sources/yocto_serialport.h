/*********************************************************************
 *
 * $Id: yocto_serialport.h 19811 2015-03-23 13:55:45Z mvuilleu $
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

@class YSerialPort;

//--- (YSerialPort globals)
typedef void (*YSerialPortValueCallback)(YSerialPort *func, NSString *functionValue);
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
    Y_VOLTAGELEVEL_INVALID = -1,
} Y_VOLTAGELEVEL_enum;
#endif
#define Y_SERIALMODE_INVALID            YAPI_INVALID_STRING
#define Y_PROTOCOL_INVALID              YAPI_INVALID_STRING
#define Y_RXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_TXCOUNT_INVALID               YAPI_INVALID_UINT
#define Y_ERRCOUNT_INVALID              YAPI_INVALID_UINT
#define Y_RXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_TXMSGCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_LASTMSG_INVALID               YAPI_INVALID_STRING
#define Y_CURRENTJOB_INVALID            YAPI_INVALID_STRING
#define Y_STARTUPJOB_INVALID            YAPI_INVALID_STRING
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YSerialPort globals)

//--- (YSerialPort class start)
/**
 * YSerialPort Class: SerialPort function interface
 *
 * The SerialPort function interface allows you to fully drive a Yoctopuce
 * serial port, to send and receive data, and to configure communication
 * parameters (baud rate, bit count, parity, flow control and protocol).
 * Note that Yoctopuce serial ports are not exposed as virtual COM ports.
 * They are meant to be used in the same way as all Yoctopuce devices.
 */
@interface YSerialPort : YFunction
//--- (end of YSerialPort class start)
{
@protected
//--- (YSerialPort attributes declaration)
    NSString*       _serialMode;
    NSString*       _protocol;
    Y_VOLTAGELEVEL_enum _voltageLevel;
    int             _rxCount;
    int             _txCount;
    int             _errCount;
    int             _rxMsgCount;
    int             _txMsgCount;
    NSString*       _lastMsg;
    NSString*       _currentJob;
    NSString*       _startupJob;
    NSString*       _command;
    YSerialPortValueCallback _valueCallbackSerialPort;
    int             _rxptr;
//--- (end of YSerialPort attributes declaration)
}
// Constructor is protected, use yFindSerialPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSerialPort private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSerialPort private methods declaration)
//--- (YSerialPort public methods declaration)
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
-(NSString*)     get_serialMode;


-(NSString*) serialMode;
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
-(int)     set_serialMode:(NSString*) newval;
-(int)     setSerialMode:(NSString*) newval;

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
-(NSString*)     get_protocol;


-(NSString*) protocol;
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
-(int)     set_protocol:(NSString*) newval;
-(int)     setProtocol:(NSString*) newval;

/**
 * Returns the voltage level used on the serial line.
 *
 * @return a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232 and Y_VOLTAGELEVEL_RS485
 * corresponding to the voltage level used on the serial line
 *
 * On failure, throws an exception or returns Y_VOLTAGELEVEL_INVALID.
 */
-(Y_VOLTAGELEVEL_enum)     get_voltageLevel;


-(Y_VOLTAGELEVEL_enum) voltageLevel;
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
-(int)     set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval;
-(int)     setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval;

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
 * Returns the latest message fully received (for Line, Frame and Modbus protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line, Frame and Modbus protocols)
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
 * @param func : a string that uniquely characterizes the serial port
 *
 * @return a YSerialPort object allowing you to drive the serial port.
 */
+(YSerialPort*)     FindSerialPort:(NSString*)func;

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
-(int)     registerValueCallback:(YSerialPortValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     sendCommand:(NSString*)text;

/**
 * Clears the serial port buffer and resets counters to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reset;

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
 * Sends a single byte to the serial port.
 *
 * @param code : the byte to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeByte:(int)code;

/**
 * Sends an ASCII string to the serial port, as is.
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeStr:(NSString*)text;

/**
 * Sends a binary buffer to the serial port, as is.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeBin:(NSData*)buff;

/**
 * Sends a byte sequence (provided as a list of bytes) to the serial port.
 *
 * @param byteList : a list of byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeArray:(NSMutableArray*)byteList;

/**
 * Sends a byte sequence (provided as a hexadecimal string) to the serial port.
 *
 * @param hexString : a string of hexadecimal byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeHex:(NSString*)hexString;

/**
 * Sends an ASCII string to the serial port, followed by a line break (CR LF).
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     writeLine:(NSString*)text;

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
-(int)     writeMODBUS:(NSString*)hexString;

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
 * On failure, throws an exception or returns a negative error code.
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
 * does not affect the device, it only changes the value stored in the YSerialPort object
 * for the next read operations.
 *
 * @param absPos : the absolute position index for next read operations.
 *
 * @return nothing.
 */
-(int)     read_seek:(int)absPos;

/**
 * Returns the current absolute stream position pointer of the YSerialPort object.
 *
 * @return the absolute position index for next read operations.
 */
-(int)     read_tell;

/**
 * Returns the number of bytes available to read in the input buffer starting from the
 * current absolute stream position pointer of the YSerialPort object.
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
 * On failure, throws an exception or returns an empty array.
 */
-(NSString*)     queryLine:(NSString*)query :(int)maxWait;

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
 * Continues the enumeration of serial ports started using yFirstSerialPort().
 *
 * @return a pointer to a YSerialPort object, corresponding to
 *         a serial port currently online, or a null pointer
 *         if there are no more serial ports to enumerate.
 */
-(YSerialPort*) nextSerialPort;
/**
 * Starts the enumeration of serial ports currently accessible.
 * Use the method YSerialPort.nextSerialPort() to iterate on
 * next serial ports.
 *
 * @return a pointer to a YSerialPort object, corresponding to
 *         the first serial port currently online, or a null pointer
 *         if there are none.
 */
+(YSerialPort*) FirstSerialPort;
//--- (end of YSerialPort public methods declaration)

@end

//--- (SerialPort functions declaration)
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
 * @param func : a string that uniquely characterizes the serial port
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
 *         the first serial port currently online, or a null pointer
 *         if there are none.
 */
YSerialPort* yFirstSerialPort(void);

//--- (end of SerialPort functions declaration)
CF_EXTERN_C_END

