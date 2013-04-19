/*********************************************************************
 *
 * $Id: yocto_datalogger.h 9945 2013-02-20 21:46:06Z seb $
 *
 * Declares yFindDataLogger(), the high-level API for DataLogger functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/


#include "yocto_api.h"

CF_EXTERN_C_BEGIN
//--- (generated code: YDataLogger definitions)
typedef enum {
    Y_RECORDING_OFF = 0,
    Y_RECORDING_ON = 1,
    Y_RECORDING_INVALID = -1
} Y_RECORDING_enum;

typedef enum {
    Y_AUTOSTART_OFF = 0,
    Y_AUTOSTART_ON = 1,
    Y_AUTOSTART_INVALID = -1
} Y_AUTOSTART_enum;

typedef enum {
    Y_CLEARHISTORY_FALSE = 0,
    Y_CLEARHISTORY_TRUE = 1,
    Y_CLEARHISTORY_INVALID = -1
} Y_CLEARHISTORY_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_OLDESTRUNINDEX_INVALID        (0xffffffff)
#define Y_CURRENTRUNINDEX_INVALID       (0xffffffff)
#define Y_SAMPLINGINTERVAL_INVALID      (0xffffffff)
#define Y_TIMEUTC_INVALID               (0xffffffff)
//--- (end of generated code: YDataLogger definitions)

#define Y_DATA_INVALID                  (-DBL_MAX)


// Forward-declaration
@class YDataLogger;

/**
 * YDataStream Class: Sequence of measured data, returned by the data logger
 * 
 * A data stream is a small collection of consecutive measures for a set
 * of sensors. A few properties are available directly from the object itself
 * (they are preloaded at instantiation time), while most other properties and
 * the actual data are loaded on demand when accessed for the first time.
 */
@interface YDataStream : NSObject
{
    // Data preloaded on object instantiation
    YDataLogger     *_dataLogger;
    unsigned        _runIndex, _startTime, _interval;
    time_t          _startTimeUTC;
    
    // Data loaded using a specific connection
    unsigned        _nRows, _nCols;
    NSMutableArray*        _columnNames;
    NSMutableArray*        _values;
}
   
-(id)   initWithDataLogger:(YDataLogger *)parrent :(unsigned)run :(unsigned) stamp :(unsigned)utc :(unsigned)itv;

-(int)  _loadStream;


/**
 * Returns the run index of the data stream. A run can be made of
 * multiple datastreams, for different time intervals.
 * 
 * This method does not cause any access to the device, as the value
 * is preloaded in the object at instantiation time.
 * 
 * @return an unsigned number corresponding to the run index.
 */
-(unsigned)                   get_runIndex;
@property (readonly)    unsigned runIndex;
    
/**
 * Returns the start time of the data stream, relative to the beginning
 * of the run. If you need an absolute time, use get_startTimeUTC().
 * 
 * This method does not cause any access to the device, as the value
 * is preloaded in the object at instantiation time.
 * 
 * @return an unsigned number corresponding to the number of seconds
 *         between the start of the run and the beginning of this data
 *         stream.
 */
-(unsigned)       get_startTime;
@property (readonly)    unsigned startTime;

/**
 * Returns the start time of the data stream, relative to the Jan 1, 1970.
 * If the UTC time was not set in the datalogger at the time of the recording
 * of this data stream, this method returns 0.
 * 
 * This method does not cause any access to the device, as the value
 * is preloaded in the object at instantiation time.
 * 
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         stream (i.e. Unix time representation of the absolute time).
 */
-(time_t)    get_startTimeUTC;
@property (readonly) time_t  startTimeUTC;

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

/**
 * Returns the number of data rows present in this stream.
 * 
 * This method fetches the whole data stream from the device,
 * if not yet done.
 * 
 * @return an unsigned number corresponding to the number of rows.
 * 
 * On failure, throws an exception or returns zero.
 */
-(unsigned)        get_rowCount;
@property (readonly)    unsigned rowCount;


/**
 * Returns the number of data columns present in this stream.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 * 
 * This method fetches the whole data stream from the device,
 * if not yet done.
 * 
 * @return an unsigned number corresponding to the number of rows.
 * 
 * On failure, throws an exception or returns zero.
 */
-(unsigned)        get_columnCount;
@property (readonly)    unsigned columnCount;

/**
 * Returns the title (or meaning) of each data column present in this stream.
 * In most case, the title of the data column is the hardware identifier
 * of the sensor that produced the data. For archived streams created by
 * summarizing a high-resolution data stream, there can be a suffix appended
 * to the sensor identifier, such as _min for the minimum value, _avg for the
 * average value and _max for the maximal value.
 * 
 * This method fetches the whole data stream from the device,
 * if not yet done.
 * 
 * @return a list containing as many strings as there are columns in the
 *         data stream.
 * 
 * On failure, throws an exception or returns an empty array.
 */
-(NSArray*) get_columnNames;
@property (readonly, copy) NSArray* columnNames;

/**
 * Returns the whole data set contained in the stream, as a bidimensional
 * table of numbers.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 * 
 * This method fetches the whole data stream from the device,
 * if not yet done.
 * 
 * @return a list containing as many elements as there are rows in the
 *         data stream. Each row itself is a list of floating-point
 *         numbers.
 * 
 * On failure, throws an exception or returns an empty array.
 */
-(NSArray*) get_dataRows;
@property (readonly, copy) NSArray* dataRows;





/**
 * Returns a single measure from the data stream, specified by its
 * row and column index.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 * 
 * This method fetches the whole data stream from the device,
 * if not yet done.
 * 
 * @param row : row index
 * @param col : column index
 * 
 * @return a floating-point number
 * 
 * On failure, throws an exception or returns Y_DATA_INVALID.
 */
-(NSNumber*) get_data:(unsigned)row  :(unsigned) col;
-(NSNumber*) data:(unsigned)row  :(unsigned) col;


@end







/**
 * YDataLogger Class: DataLogger function interface
 * 
 * Yoctopuce sensors include a non-volatile memory capable of storing ongoing measured
 * data automatically, without requiring a permanent connection to a computer.
 * The Yoctopuce application programming interface includes functions to control
 * how this internal data logger works.
 * Beacause the sensors do not include a battery, they do not have an absolute time
 * reference. Therefore, measures are simply indexed by the absolute run number
 * and time relative to the start of the run. Every new power up starts a new run.
 * It is however possible to setup an absolute UTC time by software at a given time,
 * so that the data logger keeps track of it until it is powered off next.
 */
@interface YDataLogger : YFunction
{
@protected

    //--- (generated code: YDataLogger attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    unsigned        _oldestRunIndex;
    unsigned        _currentRunIndex;
    unsigned        _samplingInterval;
    unsigned        _timeUTC;
    Y_RECORDING_enum _recording;
    Y_AUTOSTART_enum _autoStart;
    Y_CLEARHISTORY_enum _clearHistory;
//--- (end of generated code: YDataLogger attributes)
    NSString*       _dataLoggerURL;
}
//--- (generated code: YDataLogger declaration)
// Constructor is protected, use yFindDataLogger factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

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
-(void)     registerValueCallback:(YFunctionUpdateCallback) callback;   
/**
 * comment from .yc definition
 */
-(void)     set_objectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object :(SEL)selector;
-(void)     setObjectCallback:(id) object withSelector:(SEL)selector;

//--- (end of generated code: YDataLogger declaration)
//--- (generated code: YDataLogger accessors declaration)

/**
 * Continues the enumeration of data loggers started using yFirstDataLogger().
 * 
 * @return a pointer to a YDataLogger object, corresponding to
 *         a data logger currently online, or a null pointer
 *         if there are no more data loggers to enumerate.
 */
-(YDataLogger*) nextDataLogger;
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
+(YDataLogger*) FindDataLogger:(NSString*) func;
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

/**
 * Returns the logical name of the data logger.
 * 
 * @return a string corresponding to the logical name of the data logger
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the data logger. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the data logger
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the data logger (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the data logger (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the index of the oldest run for which the non-volatile memory still holds recorded data.
 * 
 * @return an integer corresponding to the index of the oldest run for which the non-volatile memory
 * still holds recorded data
 * 
 * On failure, throws an exception or returns Y_OLDESTRUNINDEX_INVALID.
 */
-(unsigned) get_oldestRunIndex;
-(unsigned) oldestRunIndex;

/**
 * Returns the current run number, corresponding to the number of times the module was
 * powered on with the dataLogger enabled at some point.
 * 
 * @return an integer corresponding to the current run number, corresponding to the number of times the module was
 *         powered on with the dataLogger enabled at some point
 * 
 * On failure, throws an exception or returns Y_CURRENTRUNINDEX_INVALID.
 */
-(unsigned) get_currentRunIndex;
-(unsigned) currentRunIndex;

-(unsigned) get_samplingInterval;
-(unsigned) samplingInterval;

-(int)     set_samplingInterval:(unsigned) newval;
-(int)     setSamplingInterval:(unsigned) newval;

/**
 * Returns the Unix timestamp for current UTC time, if known.
 * 
 * @return an integer corresponding to the Unix timestamp for current UTC time, if known
 * 
 * On failure, throws an exception or returns Y_TIMEUTC_INVALID.
 */
-(unsigned) get_timeUTC;
-(unsigned) timeUTC;

/**
 * Changes the current UTC time reference used for recorded data.
 * 
 * @param newval : an integer corresponding to the current UTC time reference used for recorded data
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_timeUTC:(unsigned) newval;
-(int)     setTimeUTC:(unsigned) newval;

/**
 * Returns the current activation state of the data logger.
 * 
 * @return either Y_RECORDING_OFF or Y_RECORDING_ON, according to the current activation state of the data logger
 * 
 * On failure, throws an exception or returns Y_RECORDING_INVALID.
 */
-(Y_RECORDING_enum) get_recording;
-(Y_RECORDING_enum) recording;

/**
 * Changes the activation state of the data logger to start/stop recording data.
 * 
 * @param newval : either Y_RECORDING_OFF or Y_RECORDING_ON, according to the activation state of the
 * data logger to start/stop recording data
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
-(Y_AUTOSTART_enum) get_autoStart;
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

-(Y_CLEARHISTORY_enum) get_clearHistory;
-(Y_CLEARHISTORY_enum) clearHistory;

-(int)     set_clearHistory:(Y_CLEARHISTORY_enum) newval;
-(int)     setClearHistory:(Y_CLEARHISTORY_enum) newval;


//--- (end of generated code: YDataLogger accessors declaration)



-(int) _getData:(unsigned)runIdx  :(unsigned)timeIdx :(NSString**) buffer :(yJsonStateMachine*) j;

/**
 * Clears the data logger memory and discards all recorded data streams.
 * This method also resets the current run index to zero.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)             forgetAllDataStreams;

/**
 * Builds a list of all data streams hold by the data logger.
 * The caller must pass by reference an empty array to hold YDataStream
 * objects, and the function fills it with objects describing available
 * data sequences.
 * 
 * @param v : an array of YDataStream objects to be filled in
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)             get_dataStreams:(NSArray**)v;
-(int)             dataStreams:(NSArray**)v;


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
