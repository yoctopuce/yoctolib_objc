/*********************************************************************
 *
 *  $Id: yocto_sdi12port.h 52848 2023-01-20 15:49:48Z mvuilleu $
 *
 *  Declares yFindSdi12Port(), the high-level API for Sdi12Port functions
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

@class YSdi12Port;

//--- (generated code: YSdi12Port globals)
typedef void (*YSdi12PortValueCallback)(YSdi12Port *func, NSString *functionValue);
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
//--- (end of generated code: YSdi12Port globals)

//--- (generated code: YSdi12SnoopingRecord globals)
//--- (end of generated code: YSdi12SnoopingRecord globals)




//--- (generated code: YSdi12SnoopingRecord class start)
/**
 * YSdi12SnoopingRecord Class: Intercepted SDI12 message description, returned by sdi12Port.snoopMessages method
 *
 *
 */
@interface YSdi12SnoopingRecord : NSObject
//--- (end of generated code: YSdi12SnoopingRecord class start)
{
@protected
//--- (generated code: YSdi12SnoopingRecord attributes declaration)
    int             _tim;
    int             _pos;
    int             _dir;
    NSString*       _msg;
//--- (end of generated code: YSdi12SnoopingRecord attributes declaration)
}

-(id)   initWith:(NSString *)json_str;

//--- (generated code: YSdi12SnoopingRecord private methods declaration)
//--- (end of generated code: YSdi12SnoopingRecord private methods declaration)
//--- (generated code: YSdi12SnoopingRecord public methods declaration)
/**
 * Returns the elapsed time, in ms, since the beginning of the preceding message.
 *
 * @return the elapsed time, in ms, since the beginning of the preceding message.
 */
-(int)     get_time;

/**
 * Returns the absolute position of the message end.
 *
 * @return the absolute position of the message end.
 */
-(int)     get_pos;

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


//--- (end of generated code: YSdi12SnoopingRecord public methods declaration)

@end

//--- (generated code: YSdi12SnoopingRecord functions declaration)
//--- (end of generated code: YSdi12SnoopingRecord functions declaration)

//--- (generated code: YSdi12Sensor class start)
/**
 * YSdi12Sensor Class: Description of a discovered SDI12 sensor, returned by
 * sdi12Port.discoverSingleSensor and sdi12Port.discoverAllSensors methods
 *
 *
 */
@interface YSdi12Sensor : NSObject
//--- (end of generated code: YSdi12Sensor class start)
{
@protected
//--- (generated code: YSdi12Sensor attributes declaration)
    YSdi12Port*     _sdi12Port;
    NSString*       _addr;
    NSString*       _proto;
    NSString*       _mfg;
    NSString*       _model;
    NSString*       _ver;
    NSString*       _sn;
    NSMutableArray* _valuesDesc;
//--- (end of generated code: YSdi12Sensor attributes declaration)
}

-(id)    initWith:(YSdi12Port*)sdi12Port :(NSString*) json_str;

//--- (generated code: YSdi12Sensor private methods declaration)
//--- (end of generated code: YSdi12Sensor private methods declaration)
//--- (generated code: YSdi12Sensor public methods declaration)
/**
 * Returns the sensor address.
 *
 * @return the sensor address.
 */
-(NSString*)     get_sensorAddress;

/**
 * Returns the compatible SDI-12 version of the sensor.
 *
 * @return the compatible SDI-12 version of the sensor.
 */
-(NSString*)     get_sensorProtocol;

/**
 * Returns the sensor vendor identification.
 *
 * @return the sensor vendor identification.
 */
-(NSString*)     get_sensorVendor;

/**
 * Returns the sensor model number.
 *
 * @return the sensor model number.
 */
-(NSString*)     get_sensorModel;

/**
 * Returns the sensor version.
 *
 * @return the sensor version.
 */
-(NSString*)     get_sensorVersion;

/**
 * Returns the sensor serial number.
 *
 * @return the sensor serial number.
 */
-(NSString*)     get_sensorSerial;

/**
 * Returns the number of sensor measurements.
 *
 * @return the number of sensor measurements.
 */
-(int)     get_measureCount;

/**
 * Returns the sensor measurement command.
 *
 * @param measureIndex : measurement index
 *
 * @return the sensor measurement command.
 */
-(NSString*)     get_measureCommand:(int)measureIndex;

/**
 * Returns sensor measurement position.
 *
 * @param measureIndex : measurement index
 *
 * @return the sensor measurement command.
 */
-(int)     get_measurePosition:(int)measureIndex;

/**
 * Returns the measured value symbol.
 *
 * @param measureIndex : measurement index
 *
 * @return the sensor measurement command.
 */
-(NSString*)     get_measureSymbol:(int)measureIndex;

/**
 * Returns the unit of the measured value.
 *
 * @param measureIndex : measurement index
 *
 * @return the sensor measurement command.
 */
-(NSString*)     get_measureUnit:(int)measureIndex;

/**
 * Returns the description of the measured value.
 *
 * @param measureIndex : measurement index
 *
 * @return the sensor measurement command.
 */
-(NSString*)     get_measureDescription:(int)measureIndex;

-(NSMutableArray*)     get_typeMeasure;

-(void)     _parseInfoStr:(NSString*)infoStr;

-(void)     _queryValueInfo;


//--- (end of generated code: YSdi12Sensor public methods declaration)

@end

//--- (generated code: YSdi12Sensor functions declaration)
//--- (end of generated code: YSdi12Sensor functions declaration)


//--- (generated code: YSdi12Port class start)
/**
 * YSdi12Port Class: SDI12 port control interface
 *
 * The YSdi12Port class allows you to fully drive a Yoctopuce SDI12 port.
 * It can be used to send and receive data, and to configure communication
 * parameters (baud rate, bit count, parity, flow control and protocol).
 * Note that Yoctopuce SDI12 ports are not exposed as virtual COM ports.
 * They are meant to be used in the same way as all Yoctopuce devices.
 */
@interface YSdi12Port : YFunction
//--- (end of generated code: YSdi12Port class start)
{
@protected
//--- (generated code: YSdi12Port attributes declaration)
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
    YSdi12PortValueCallback _valueCallbackSdi12Port;
    int             _rxptr;
    NSMutableData*  _rxbuff;
    int             _rxbuffptr;
    int             _eventPos;
//--- (end of generated code: YSdi12Port attributes declaration)
}
// Constructor is protected, use yFindSdi12Port factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YSdi12Port private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YSdi12Port private methods declaration)
//--- (generated code: YSdi12Port yapiwrapper declaration)
//--- (end of generated code: YSdi12Port yapiwrapper declaration)
//--- (generated code: YSdi12Port public methods declaration)
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns YSdi12Port.RXCOUNT_INVALID.
 */
-(int)     get_rxCount;


-(int) rxCount;
/**
 * Returns the total number of bytes transmitted since last reset.
 *
 * @return an integer corresponding to the total number of bytes transmitted since last reset
 *
 * On failure, throws an exception or returns YSdi12Port.TXCOUNT_INVALID.
 */
-(int)     get_txCount;


-(int) txCount;
/**
 * Returns the total number of communication errors detected since last reset.
 *
 * @return an integer corresponding to the total number of communication errors detected since last reset
 *
 * On failure, throws an exception or returns YSdi12Port.ERRCOUNT_INVALID.
 */
-(int)     get_errCount;


-(int) errCount;
/**
 * Returns the total number of messages received since last reset.
 *
 * @return an integer corresponding to the total number of messages received since last reset
 *
 * On failure, throws an exception or returns YSdi12Port.RXMSGCOUNT_INVALID.
 */
-(int)     get_rxMsgCount;


-(int) rxMsgCount;
/**
 * Returns the total number of messages send since last reset.
 *
 * @return an integer corresponding to the total number of messages send since last reset
 *
 * On failure, throws an exception or returns YSdi12Port.TXMSGCOUNT_INVALID.
 */
-(int)     get_txMsgCount;


-(int) txMsgCount;
/**
 * Returns the latest message fully received.
 *
 * @return a string corresponding to the latest message fully received
 *
 * On failure, throws an exception or returns YSdi12Port.LASTMSG_INVALID.
 */
-(NSString*)     get_lastMsg;


-(NSString*) lastMsg;
/**
 * Returns the name of the job file currently in use.
 *
 * @return a string corresponding to the name of the job file currently in use
 *
 * On failure, throws an exception or returns YSdi12Port.CURRENTJOB_INVALID.
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
 * On failure, throws an exception or returns YSdi12Port.STARTUPJOB_INVALID.
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
 * On failure, throws an exception or returns YSdi12Port.JOBMAXTASK_INVALID.
 */
-(int)     get_jobMaxTask;


-(int) jobMaxTask;
/**
 * Returns maximum size allowed for job files.
 *
 * @return an integer corresponding to maximum size allowed for job files
 *
 * On failure, throws an exception or returns YSdi12Port.JOBMAXSIZE_INVALID.
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
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 *
 * @return a string corresponding to the type of protocol used over the serial line, as a string
 *
 * On failure, throws an exception or returns YSdi12Port.PROTOCOL_INVALID.
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_protocol:(NSString*) newval;
-(int)     setProtocol:(NSString*) newval;

/**
 * Returns the voltage level used on the serial line.
 *
 * @return a value among YSdi12Port.VOLTAGELEVEL_OFF, YSdi12Port.VOLTAGELEVEL_TTL3V,
 * YSdi12Port.VOLTAGELEVEL_TTL3VR, YSdi12Port.VOLTAGELEVEL_TTL5V, YSdi12Port.VOLTAGELEVEL_TTL5VR,
 * YSdi12Port.VOLTAGELEVEL_RS232, YSdi12Port.VOLTAGELEVEL_RS485, YSdi12Port.VOLTAGELEVEL_TTL1V8 and
 * YSdi12Port.VOLTAGELEVEL_SDI12 corresponding to the voltage level used on the serial line
 *
 * On failure, throws an exception or returns YSdi12Port.VOLTAGELEVEL_INVALID.
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
 * @param newval : a value among YSdi12Port.VOLTAGELEVEL_OFF, YSdi12Port.VOLTAGELEVEL_TTL3V,
 * YSdi12Port.VOLTAGELEVEL_TTL3VR, YSdi12Port.VOLTAGELEVEL_TTL5V, YSdi12Port.VOLTAGELEVEL_TTL5VR,
 * YSdi12Port.VOLTAGELEVEL_RS232, YSdi12Port.VOLTAGELEVEL_RS485, YSdi12Port.VOLTAGELEVEL_TTL1V8 and
 * YSdi12Port.VOLTAGELEVEL_SDI12 corresponding to the voltage type used on the serial line
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval;
-(int)     setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval;

/**
 * Returns the serial port communication parameters, as a string such as
 * "1200,7E1,Simplex". The string includes the baud rate, the number of data bits,
 * the parity, and the number of stop bits. The suffix "Simplex" denotes
 * the fact that transmission in both directions is multiplexed on the
 * same transmission line.
 *
 * @return a string corresponding to the serial port communication parameters, as a string such as
 *         "1200,7E1,Simplex"
 *
 * On failure, throws an exception or returns YSdi12Port.SERIALMODE_INVALID.
 */
-(NSString*)     get_serialMode;


-(NSString*) serialMode;
/**
 * Changes the serial port communication parameters, with a string such as
 * "1200,7E1,Simplex". The string includes the baud rate, the number of data bits,
 * the parity, and the number of stop bits. The suffix "Simplex" denotes
 * the fact that transmission in both directions is multiplexed on the
 * same transmission line.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the serial port communication parameters, with a string such as
 *         "1200,7E1,Simplex"
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_serialMode:(NSString*) newval;
-(int)     setSerialMode:(NSString*) newval;

/**
 * Retrieves a SDI12 port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the SDI12 port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSdi12Port.isOnline() to test if the SDI12 port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SDI12 port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SDI12 port, for instance
 *         MyDevice.sdi12Port.
 *
 * @return a YSdi12Port object allowing you to drive the SDI12 port.
 */
+(YSdi12Port*)     FindSdi12Port:(NSString*)func;

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
-(int)     registerValueCallback:(YSdi12PortValueCallback _Nullable)callback;

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

-(int)     end_tell;

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
 * Sends a SDI-12 query to the bus, and reads the sensor immediate reply.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param sensorAddr : the sensor address, as a string
 * @param cmd : the SDI12 query to send (without address and exclamation point)
 * @param maxWait : the maximum timeout to wait for a reply from sensor, in millisecond
 *
 * @return the reply returned by the sensor, without newline, as a string.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*)     querySdi12:(NSString*)sensorAddr :(NSString*)cmd :(int)maxWait;

/**
 * Sends a discovery command to the bus, and reads the sensor information reply.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 * This function work when only one sensor is connected.
 *
 * @return the reply returned by the sensor, as a YSdi12Sensor object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(YSdi12Sensor*)     discoverSingleSensor;

/**
 * Sends a discovery command to the bus, and reads all sensors information reply.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @return all the information from every connected sensor, as an array of YSdi12Sensor object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSMutableArray*)     discoverAllSensors;

/**
 * Sends a mesurement command to the SDI-12 bus, and reads the sensor immediate reply.
 * The supported commands are:
 * M: Measurement start control
 * M1...M9: Additional measurement start command
 * D: Measurement reading control
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param sensorAddr : the sensor address, as a string
 * @param measCmd : the SDI12 query to send (without address and exclamation point)
 * @param maxWait : the maximum timeout to wait for a reply from sensor, in millisecond
 *
 * @return the reply returned by the sensor, without newline, as a list of float.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSMutableArray*)     readSensor:(NSString*)sensorAddr :(NSString*)measCmd :(int)maxWait;

/**
 * Changes the address of the selected sensor, and returns the sensor information with the new address.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param oldAddress : Actual sensor address, as a string
 * @param newAddress : New sensor address, as a string
 *
 * @return the sensor address and information , as a YSdi12Sensor object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(YSdi12Sensor*)     changeAddress:(NSString*)oldAddress :(NSString*)newAddress;

/**
 * Sends a information command to the bus, and reads sensors information selected.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param sensorAddr : Sensor address, as a string
 *
 * @return the reply returned by the sensor, as a YSdi12Port object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(YSdi12Sensor*)     getSensorInformation:(NSString*)sensorAddr;

/**
 * Sends a information command to the bus, and reads sensors information selected.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param sensorAddr : Sensor address, as a string
 *
 * @return the reply returned by the sensor, as a YSdi12Port object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSMutableArray*)     readConcurrentMeasurements:(NSString*)sensorAddr;

/**
 * Sends a information command to the bus, and reads sensors information selected.
 * This function is intended to be used when the serial port is configured for 'SDI-12' protocol.
 *
 * @param sensorAddr : Sensor address, as a string
 *
 * @return the reply returned by the sensor, as a YSdi12Port object.
 *
 * On failure, throws an exception or returns an empty string.
 */
-(int)     requestConcurrentMeasurements:(NSString*)sensorAddr;

/**
 * Retrieves messages (both direction) in the SDI12 port buffer, starting at current position.
 *
 * If no message is found, the search waits for one up to the specified maximum timeout
 * (in milliseconds).
 *
 * @param maxWait : the maximum number of milliseconds to wait for a message if none is found
 *         in the receive buffer.
 *
 * @return an array of YSdi12SnoopingRecord objects containing the messages found, if any.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     snoopMessages:(int)maxWait;


/**
 * Continues the enumeration of SDI12 ports started using yFirstSdi12Port().
 * Caution: You can't make any assumption about the returned SDI12 ports order.
 * If you want to find a specific a SDI12 port, use Sdi12Port.findSdi12Port()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSdi12Port object, corresponding to
 *         a SDI12 port currently online, or a nil pointer
 *         if there are no more SDI12 ports to enumerate.
 */
-(nullable YSdi12Port*) nextSdi12Port
NS_SWIFT_NAME(nextSdi12Port());
/**
 * Starts the enumeration of SDI12 ports currently accessible.
 * Use the method YSdi12Port.nextSdi12Port() to iterate on
 * next SDI12 ports.
 *
 * @return a pointer to a YSdi12Port object, corresponding to
 *         the first SDI12 port currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YSdi12Port*) FirstSdi12Port
NS_SWIFT_NAME(FirstSdi12Port());
//--- (end of generated code: YSdi12Port public methods declaration)

@end

//--- (generated code: YSdi12Port functions declaration)
/**
 * Retrieves a SDI12 port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the SDI12 port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSdi12Port.isOnline() to test if the SDI12 port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SDI12 port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SDI12 port, for instance
 *         MyDevice.sdi12Port.
 *
 * @return a YSdi12Port object allowing you to drive the SDI12 port.
 */
YSdi12Port* yFindSdi12Port(NSString* func);
/**
 * Starts the enumeration of SDI12 ports currently accessible.
 * Use the method YSdi12Port.nextSdi12Port() to iterate on
 * next SDI12 ports.
 *
 * @return a pointer to a YSdi12Port object, corresponding to
 *         the first SDI12 port currently online, or a nil pointer
 *         if there are none.
 */
YSdi12Port* yFirstSdi12Port(void);

//--- (end of generated code: YSdi12Port functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

