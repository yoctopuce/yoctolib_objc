/*********************************************************************
 *
 *  $Id: yocto_spiport.h 37141 2019-09-12 12:37:10Z mvuilleu $
 *
 *  Declares yFindSpiPort(), the high-level API for SpiPort functions
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

@class YSpiPort;

//--- (YSpiPort globals)
typedef void (*YSpiPortValueCallback)(YSpiPort *func, NSString *functionValue);
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
    Y_VOLTAGELEVEL_INVALID = -1,
} Y_VOLTAGELEVEL_enum;
#endif
#ifndef _Y_SSPOLARITY_ENUM
#define _Y_SSPOLARITY_ENUM
typedef enum {
    Y_SSPOLARITY_ACTIVE_LOW = 0,
    Y_SSPOLARITY_ACTIVE_HIGH = 1,
    Y_SSPOLARITY_INVALID = -1,
} Y_SSPOLARITY_enum;
#endif
#ifndef _Y_SHIFTSAMPLING_ENUM
#define _Y_SHIFTSAMPLING_ENUM
typedef enum {
    Y_SHIFTSAMPLING_OFF = 0,
    Y_SHIFTSAMPLING_ON = 1,
    Y_SHIFTSAMPLING_INVALID = -1,
} Y_SHIFTSAMPLING_enum;
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
#define Y_SPIMODE_INVALID               YAPI_INVALID_STRING
//--- (end of YSpiPort globals)

//--- (YSpiPort class start)
/**
 * YSpiPort Class: SPI Port function interface
 *
 * The SpiPort function interface allows you to fully drive a Yoctopuce
 * SPI port, to send and receive data, and to configure communication
 * parameters (baud rate, bit count, parity, flow control and protocol).
 * Note that Yoctopuce SPI ports are not exposed as virtual COM ports.
 * They are meant to be used in the same way as all Yoctopuce devices.
 */
@interface YSpiPort : YFunction
//--- (end of YSpiPort class start)
{
@protected
//--- (YSpiPort attributes declaration)
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
    Y_VOLTAGELEVEL_enum _voltageLevel;
    NSString*       _spiMode;
    Y_SSPOLARITY_enum _ssPolarity;
    Y_SHIFTSAMPLING_enum _shiftSampling;
    YSpiPortValueCallback _valueCallbackSpiPort;
    int             _rxptr;
    NSMutableData*  _rxbuff;
    int             _rxbuffptr;
//--- (end of YSpiPort attributes declaration)
}
// Constructor is protected, use yFindSpiPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSpiPort private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSpiPort private methods declaration)
//--- (YSpiPort yapiwrapper declaration)
//--- (end of YSpiPort yapiwrapper declaration)
//--- (YSpiPort public methods declaration)
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
 * Returns the type of protocol used over the serial line, as a string.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
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
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 * The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
 * is always at lest the specified number of milliseconds between each bytes sent.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
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
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232, Y_VOLTAGELEVEL_RS485 and
 * Y_VOLTAGELEVEL_TTL1V8 corresponding to the voltage level used on the serial line
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
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232, Y_VOLTAGELEVEL_RS485 and
 * Y_VOLTAGELEVEL_TTL1V8 corresponding to the voltage type used on the serial line
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval;
-(int)     setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval;

/**
 * Returns the SPI port communication parameters, as a string such as
 * "125000,0,msb". The string includes the baud rate, the SPI mode (between
 * 0 and 3) and the bit order.
 *
 * @return a string corresponding to the SPI port communication parameters, as a string such as
 *         "125000,0,msb"
 *
 * On failure, throws an exception or returns Y_SPIMODE_INVALID.
 */
-(NSString*)     get_spiMode;


-(NSString*) spiMode;
/**
 * Changes the SPI port communication parameters, with a string such as
 * "125000,0,msb". The string includes the baud rate, the SPI mode (between
 * 0 and 3) and the bit order.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the SPI port communication parameters, with a string such as
 *         "125000,0,msb"
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_spiMode:(NSString*) newval;
-(int)     setSpiMode:(NSString*) newval;

/**
 * Returns the SS line polarity.
 *
 * @return either Y_SSPOLARITY_ACTIVE_LOW or Y_SSPOLARITY_ACTIVE_HIGH, according to the SS line polarity
 *
 * On failure, throws an exception or returns Y_SSPOLARITY_INVALID.
 */
-(Y_SSPOLARITY_enum)     get_ssPolarity;


-(Y_SSPOLARITY_enum) ssPolarity;
/**
 * Changes the SS line polarity.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either Y_SSPOLARITY_ACTIVE_LOW or Y_SSPOLARITY_ACTIVE_HIGH, according to the SS line polarity
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_ssPolarity:(Y_SSPOLARITY_enum) newval;
-(int)     setSsPolarity:(Y_SSPOLARITY_enum) newval;

/**
 * Returns true when the SDI line phase is shifted with regards to the SDO line.
 *
 * @return either Y_SHIFTSAMPLING_OFF or Y_SHIFTSAMPLING_ON, according to true when the SDI line phase
 * is shifted with regards to the SDO line
 *
 * On failure, throws an exception or returns Y_SHIFTSAMPLING_INVALID.
 */
-(Y_SHIFTSAMPLING_enum)     get_shiftSampling;


-(Y_SHIFTSAMPLING_enum) shiftSampling;
/**
 * Changes the SDI line sampling shift. When disabled, SDI line is
 * sampled in the middle of data output time. When enabled, SDI line is
 * samples at the end of data output time.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either Y_SHIFTSAMPLING_OFF or Y_SHIFTSAMPLING_ON, according to the SDI line sampling shift
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_shiftSampling:(Y_SHIFTSAMPLING_enum) newval;
-(int)     setShiftSampling:(Y_SHIFTSAMPLING_enum) newval;

/**
 * Retrieves a SPI port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the SPI port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSpiPort.isOnline() to test if the SPI port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SPI port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SPI port
 *
 * @return a YSpiPort object allowing you to drive the SPI port.
 */
+(YSpiPort*)     FindSpiPort:(NSString*)func;

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
-(int)     registerValueCallback:(YSpiPortValueCallback)callback;

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
 * Manually sets the state of the SS line. This function has no effect when
 * the SS line is handled automatically.
 *
 * @param val : 1 to turn SS active, 0 to release SS.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_SS:(int)val;


/**
 * Continues the enumeration of SPI ports started using yFirstSpiPort().
 * Caution: You can't make any assumption about the returned SPI ports order.
 * If you want to find a specific a SPI port, use SpiPort.findSpiPort()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSpiPort object, corresponding to
 *         a SPI port currently online, or a nil pointer
 *         if there are no more SPI ports to enumerate.
 */
-(YSpiPort*) nextSpiPort;
/**
 * Starts the enumeration of SPI ports currently accessible.
 * Use the method YSpiPort.nextSpiPort() to iterate on
 * next SPI ports.
 *
 * @return a pointer to a YSpiPort object, corresponding to
 *         the first SPI port currently online, or a nil pointer
 *         if there are none.
 */
+(YSpiPort*) FirstSpiPort;
//--- (end of YSpiPort public methods declaration)

@end

//--- (YSpiPort functions declaration)
/**
 * Retrieves a SPI port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the SPI port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSpiPort.isOnline() to test if the SPI port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SPI port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SPI port
 *
 * @return a YSpiPort object allowing you to drive the SPI port.
 */
YSpiPort* yFindSpiPort(NSString* func);
/**
 * Starts the enumeration of SPI ports currently accessible.
 * Use the method YSpiPort.nextSpiPort() to iterate on
 * next SPI ports.
 *
 * @return a pointer to a YSpiPort object, corresponding to
 *         the first SPI port currently online, or a nil pointer
 *         if there are none.
 */
YSpiPort* yFirstSpiPort(void);

//--- (end of YSpiPort functions declaration)
CF_EXTERN_C_END

