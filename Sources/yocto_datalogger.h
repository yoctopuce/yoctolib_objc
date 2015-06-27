/*********************************************************************
 *
 * $Id: yocto_datalogger.h 20704 2015-06-20 19:43:34Z mvuilleu $
 *
 * Declares yFindDataLogger(), the high-level API for DataLogger functions
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
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
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

//--- (generated code: YDataLogger globals)
typedef void (*YDataLoggerValueCallback)(YDataLogger *func, NSString *functionValue);
#ifndef _Y_RECORDING_ENUM
#define _Y_RECORDING_ENUM
typedef enum {
    Y_RECORDING_OFF = 0,
    Y_RECORDING_ON = 1,
    Y_RECORDING_PENDING = 2,
    Y_RECORDING_INVALID = -1,
} Y_RECORDING_enum;
#endif
#ifndef _Y_AUTOSTART_ENUM
#define _Y_AUTOSTART_ENUM
typedef enum {
    Y_AUTOSTART_OFF = 0,
    Y_AUTOSTART_ON = 1,
    Y_AUTOSTART_INVALID = -1,
} Y_AUTOSTART_enum;
#endif
#ifndef _Y_BEACONDRIVEN_ENUM
#define _Y_BEACONDRIVEN_ENUM
typedef enum {
    Y_BEACONDRIVEN_OFF = 0,
    Y_BEACONDRIVEN_ON = 1,
    Y_BEACONDRIVEN_INVALID = -1,
} Y_BEACONDRIVEN_enum;
#endif
#ifndef _Y_CLEARHISTORY_ENUM
#define _Y_CLEARHISTORY_ENUM
typedef enum {
    Y_CLEARHISTORY_FALSE = 0,
    Y_CLEARHISTORY_TRUE = 1,
    Y_CLEARHISTORY_INVALID = -1,
} Y_CLEARHISTORY_enum;
#endif
#define Y_CURRENTRUNINDEX_INVALID       YAPI_INVALID_UINT
#define Y_TIMEUTC_INVALID               YAPI_INVALID_LONG
//--- (end of generated code: YDataLogger globals)


#define Y_DATA_INVALID                  (-DBL_MAX)


// Forward-declaration
@class YDataLogger;

/**
 * YOldDataStream Class: Sequence of measured data, returned by the data logger
 *  
 * A data stream is a small collection of consecutive measures for a set
 * of sensors. A few properties are available directly from the object itself
 * (they are preloaded at instantiation time), while most other properties and
 * the actual data are loaded on demand when accessed for the first time.
 *
 * This is the old version of the YDataStream class, used for backward-compatibility
 * with devices with firmware < 13000
 */
@interface YOldDataStream : YDataStream
{
    // Data preloaded on object instantiation
    YDataLogger     *_dataLogger;
    unsigned        _timeStamp;
    unsigned        _interval;
}
   
-(id)   initWithDataLogger:(YDataLogger *)parrent :(unsigned)run :(unsigned) stamp :(unsigned)utc :(unsigned)itv;

// override new version with backward-compatible code
-(int)  _loadStream;

 
/**
 * Returns the relative start time of the data stream, measured in seconds.
 * For recent firmwares, the value is relative to the present time,
 * which means the value is always negative.
 * If the device uses a firmware older than version 13000, value is
 * relative to the start of the time the device was powered on, and
 * is always positive.
 * If you need an absolute UTC timestamp, use get_startTimeUTC().
 * 
 * @return an unsigned number corresponding to the number of seconds
 *         between the start of the run and the beginning of this data
 *         stream.
 */
-(unsigned)       get_startTime;
@property (readonly)    unsigned startTime;

/**
 * Returns the number of seconds elapsed between  two consecutive
 * rows of this data stream. By default, the data logger records one row
 * per second, but there might be alternative streams at lower resolution
 * created by summarizing the original stream for archiving purposes.
 * 
 * This method does not cause any access to the device, as the value
 * is preloaded in the object at instantiation time.
 * 
 * @return an unsigned number corresponding to a number of seconds.
 */
-(unsigned)        get_dataSamplesInterval;
@property (readonly)    unsigned dataSamplesInterval;

@end




//--- (generated code: YDataLogger class start)
/**
 * YDataLogger Class: DataLogger function interface
 *
 * Yoctopuce sensors include a non-volatile memory capable of storing ongoing measured
 * data automatically, without requiring a permanent connection to a computer.
 * The DataLogger function controls the global parameters of the internal data
 * logger.
 */
@interface YDataLogger : YFunction
//--- (end of generated code: YDataLogger class start)
{
@protected
//--- (generated code: YDataLogger attributes declaration)
    int             _currentRunIndex;
    s64             _timeUTC;
    Y_RECORDING_enum _recording;
    Y_AUTOSTART_enum _autoStart;
    Y_BEACONDRIVEN_enum _beaconDriven;
    Y_CLEARHISTORY_enum _clearHistory;
    YDataLoggerValueCallback _valueCallbackDataLogger;
//--- (end of generated code: YDataLogger attributes declaration)
    NSString*       _dataLoggerURL;
}
// Constructor is protected, use yFindDataLogger factory function to instantiate
-(id)    initWith:(NSString*) func;

-(int) _getData:(unsigned)runIdx  :(unsigned)timeIdx :(NSString**) buffer :(yJsonStateMachine*) j;

//--- (generated code: YDataLogger private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YDataLogger private methods declaration)


/**
 * Builds a list of all data streams hold by the data logger (legacy method).
 * The caller must pass by reference an empty array to hold YDataStream
 * objects, and the function fills it with objects describing available
 * data sequences.
 *
 * This is the old way to retrieve data from the DataLogger.
 * For new applications, you should rather use get_dataSets()
 * method, or call directly get_recordedData() on the
 * sensor object.
 *
 * @param v : an array of YDataStream objects to be filled in
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)             get_dataStreams:(NSArray**) v;
-(int)             dataStreams:(NSArray**) param;

//--- (generated code: YDataLogger public methods declaration)
/**
 * Returns the current run number, corresponding to the number of times the module was
 * powered on with the dataLogger enabled at some point.
 *
 * @return an integer corresponding to the current run number, corresponding to the number of times the module was
 *         powered on with the dataLogger enabled at some point
 *
 * On failure, throws an exception or returns Y_CURRENTRUNINDEX_INVALID.
 */
-(int)     get_currentRunIndex;


-(int) currentRunIndex;
/**
 * Returns the Unix timestamp for current UTC time, if known.
 *
 * @return an integer corresponding to the Unix timestamp for current UTC time, if known
 *
 * On failure, throws an exception or returns Y_TIMEUTC_INVALID.
 */
-(s64)     get_timeUTC;


-(s64) timeUTC;
/**
 * Changes the current UTC time reference used for recorded data.
 *
 * @param newval : an integer corresponding to the current UTC time reference used for recorded data
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_timeUTC:(s64) newval;
-(int)     setTimeUTC:(s64) newval;

/**
 * Returns the current activation state of the data logger.
 *
 * @return a value among Y_RECORDING_OFF, Y_RECORDING_ON and Y_RECORDING_PENDING corresponding to the
 * current activation state of the data logger
 *
 * On failure, throws an exception or returns Y_RECORDING_INVALID.
 */
-(Y_RECORDING_enum)     get_recording;


-(Y_RECORDING_enum) recording;
/**
 * Changes the activation state of the data logger to start/stop recording data.
 *
 * @param newval : a value among Y_RECORDING_OFF, Y_RECORDING_ON and Y_RECORDING_PENDING corresponding
 * to the activation state of the data logger to start/stop recording data
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_recording:(Y_RECORDING_enum) newval;
-(int)     setRecording:(Y_RECORDING_enum) newval;

/**
 * Returns the default activation state of the data logger on power up.
 *
 * @return either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the default activation state of the
 * data logger on power up
 *
 * On failure, throws an exception or returns Y_AUTOSTART_INVALID.
 */
-(Y_AUTOSTART_enum)     get_autoStart;


-(Y_AUTOSTART_enum) autoStart;
/**
 * Changes the default activation state of the data logger on power up.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the default activation state
 * of the data logger on power up
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_autoStart:(Y_AUTOSTART_enum) newval;
-(int)     setAutoStart:(Y_AUTOSTART_enum) newval;

/**
 * Return true if the data logger is synchronised with the localization beacon.
 *
 * @return either Y_BEACONDRIVEN_OFF or Y_BEACONDRIVEN_ON
 *
 * On failure, throws an exception or returns Y_BEACONDRIVEN_INVALID.
 */
-(Y_BEACONDRIVEN_enum)     get_beaconDriven;


-(Y_BEACONDRIVEN_enum) beaconDriven;
/**
 * Changes the type of synchronisation of the data logger.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either Y_BEACONDRIVEN_OFF or Y_BEACONDRIVEN_ON, according to the type of
 * synchronisation of the data logger
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_beaconDriven:(Y_BEACONDRIVEN_enum) newval;
-(int)     setBeaconDriven:(Y_BEACONDRIVEN_enum) newval;

-(Y_CLEARHISTORY_enum)     get_clearHistory;


-(Y_CLEARHISTORY_enum) clearHistory;
-(int)     set_clearHistory:(Y_CLEARHISTORY_enum) newval;
-(int)     setClearHistory:(Y_CLEARHISTORY_enum) newval;

/**
 * Retrieves a data logger for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the data logger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDataLogger.isOnline() to test if the data logger is
 * indeed online at a given time. In case of ambiguity when looking for
 * a data logger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the data logger
 *
 * @return a YDataLogger object allowing you to drive the data logger.
 */
+(YDataLogger*)     FindDataLogger:(NSString*)func;

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
-(int)     registerValueCallback:(YDataLoggerValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Clears the data logger memory and discards all recorded data streams.
 * This method also resets the current run index to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     forgetAllDataStreams;

/**
 * Returns a list of YDataSet objects that can be used to retrieve
 * all measures stored by the data logger.
 *
 * This function only works if the device uses a recent firmware,
 * as YDataSet objects are not supported by firmwares older than
 * version 13000.
 *
 * @return a list of YDataSet object.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*)     get_dataSets;

-(NSMutableArray*)     parse_dataSets:(NSData*)json;


/**
 * Continues the enumeration of data loggers started using yFirstDataLogger().
 *
 * @return a pointer to a YDataLogger object, corresponding to
 *         a data logger currently online, or a null pointer
 *         if there are no more data loggers to enumerate.
 */
-(YDataLogger*) nextDataLogger;
/**
 * Starts the enumeration of data loggers currently accessible.
 * Use the method YDataLogger.nextDataLogger() to iterate on
 * next data loggers.
 *
 * @return a pointer to a YDataLogger object, corresponding to
 *         the first data logger currently online, or a null pointer
 *         if there are none.
 */
+(YDataLogger*) FirstDataLogger;
//--- (end of generated code: YDataLogger public methods declaration)

@end

//--- (generated code: DataLogger functions declaration)
/**
 * Retrieves a data logger for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the data logger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDataLogger.isOnline() to test if the data logger is
 * indeed online at a given time. In case of ambiguity when looking for
 * a data logger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the data logger
 *
 * @return a YDataLogger object allowing you to drive the data logger.
 */
YDataLogger* yFindDataLogger(NSString* func);
/**
 * Starts the enumeration of data loggers currently accessible.
 * Use the method YDataLogger.nextDataLogger() to iterate on
 * next data loggers.
 *
 * @return a pointer to a YDataLogger object, corresponding to
 *         the first data logger currently online, or a null pointer
 *         if there are none.
 */
YDataLogger* yFirstDataLogger(void);

//--- (end of generated code: DataLogger functions declaration)
CF_EXTERN_C_END
