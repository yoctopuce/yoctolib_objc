/*********************************************************************
 *
 * $Id: yocto_datalogger.m 12326 2013-08-13 15:52:20Z mvuilleu $
 *
 * Implements yFindDataLogger(), the high-level API for DataLogger functions
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


#import "yocto_datalogger.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"
double _decimalToDouble(s16 val);



/**
 * YDataStream Class: Sequence of measured data, returned by the data logger
 * 
 * A data stream is a small collection of consecutive measures for a set
 * of sensors. A few properties are available directly from the object itself
 * (they are preloaded at instantiation time), while most other properties and
 * the actual data are loaded on demand when accessed for the first time.
 */
@implementation YDataStream


-(id) initWithDataLogger:(YDataLogger *)parrent :(unsigned int)run :(unsigned int)stamp :(unsigned int)utc :(unsigned int)itv
{
    self = [super init];
    if(self){
        _dataLogger     = parrent;
        _runIndex       = run;
        _startTime      = stamp;
        _startTimeUTC   = utc, 
        _interval       = itv;
        _columnNames    = [[NSMutableArray alloc ] init] ;
        _values         = [[NSMutableArray alloc ] init] ;
    }
    return self;
}

- (void)dealloc {
    ARC_release(_columnNames);
    ARC_release(_values);
    ARC_dealloc(super);
}


// Preload all values into the data stream object
-(int)  _loadStream
{
    NSString            *buffer;
    yJsonStateMachine   j;
    int                 res,p;
    NSMutableArray      *coldiv, *coltyp;
    NSMutableArray      *dat;
    NSMutableArray      *udat;
    NSMutableArray      *colscl;
    NSMutableArray      *colofs;
    NSMutableArray      *calhdl=nil;
    NSMutableArray      *caltyp=nil;
    NSMutableArray      *calpar=nil;
    NSMutableArray      *calraw=nil;
    NSMutableArray      *calref=nil;
  
    if((res = [_dataLogger _getData:_runIndex:_startTime:&buffer:&j]) != YAPI_SUCCESS) {
        return res;
    }
    coldiv = [[NSMutableArray alloc] init];
    coltyp = [[NSMutableArray alloc] init];
    colscl = [[NSMutableArray alloc] init];
    colofs = [[NSMutableArray alloc] init];
    
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
    fail:
        ARC_release(coldiv);
        ARC_release(coltyp);
        ARC_release(colscl);
        ARC_release(colofs);
        if (calhdl!=nil)
            ARC_release(calhdl);
        if (caltyp!=nil)
            ARC_release(caltyp);
        if (calpar!=nil)
            ARC_release(calpar);
        if (calraw!=nil)
            ARC_release(calraw);
        if (calref!=nil)
            ARC_release(calref);
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Unexpected JSON reply format");
        [_dataLogger _throw:error];
        return YAPI_IO_ERROR;
    }
    _nRows = _nCols = 0;
    [_columnNames removeAllObjects];
    [_values removeAllObjects];
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j.token, "time")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL) 
                goto fail;
            _startTime = atoi(j.token); 
        } else if(!strcmp(j.token, "UTC")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL) 
                goto fail;
            _startTimeUTC = atoi(j.token); 
        } else if(!strcmp(j.token, "interval")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL) 
                goto fail;
            _interval = atoi(j.token); 
        } else if(!strcmp(j.token, "nRows")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL) 
                goto fail;
            _nRows = atoi(j.token); 
        } else if(!strcmp(j.token, "keys")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) break;
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_STRING) {
                NSString *tmp = [_dataLogger _parseString:&j];
                [_columnNames addObject:tmp];
            }
            if(j.token[0] != ']') goto fail;
            if(_nCols == 0) {
                _nCols = (unsigned)[_columnNames count];
            } else if(_nCols != [_columnNames count]) {
                _nCols = 0; 
                goto fail;
            }
        } else if(!strcmp(j.token, "div")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) break;
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_NUM) {
                int tmp = atoi(j.token);
                NSNumber *n = [NSNumber numberWithInt:tmp];
                [coldiv addObject:n];
            }
            if(j.token[0] != ']') 
                goto fail;
            if(_nCols == 0) {
                _nCols = (unsigned)[coldiv count];
            } else if(_nCols != [coldiv count]) {
                _nCols = 0; 
                goto fail;
            }
        } else if(!strcmp(j.token, "type")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) break;
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_NUM) {
                NSNumber *n = [NSNumber numberWithInt:atoi(j.token)];
                [coltyp addObject:n];
            }
            if(j.token[0] != ']') goto fail;
            if(_nCols == 0) {
                _nCols = (unsigned)[coltyp count];
            } else if(_nCols != [coltyp count]) {
                _nCols = 0; 
                goto fail;
            }
        } else if(!strcmp(j.token, "scal")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) break;
            int c=0;
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_NUM) {
                double scal = (double)atoi(j.token) / 65536.0;
                NSNumber *n = [NSNumber numberWithDouble:scal];
                [colscl addObject:n];
                [colofs addObject:[NSNumber numberWithInt:([[coltyp objectAtIndex:c++] intValue]!= 0 ? -32767 : 0)]];
            }
            if(j.token[0] != ']') goto fail;
            if(_nCols == 0) {
                _nCols = (unsigned)[colscl count];
            } else if(_nCols != [colscl count]) {
                _nCols = 0; 
                goto fail;
            }
        }  else if(!strcmp(j.token, "cal")) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY)
                break;
            calhdl = [[NSMutableArray alloc] initWithCapacity:_nCols];
            caltyp = [[NSMutableArray alloc] initWithCapacity:_nCols];
            calpar = [[NSMutableArray alloc] initWithCapacity:_nCols];
            calraw = [[NSMutableArray alloc] initWithCapacity:_nCols];
            calref = [[NSMutableArray alloc] initWithCapacity:_nCols];
            int c = 0;
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_STRING) {
                NSString * calibration_str = [_dataLogger _parseString:&j];
                NSMutableArray * cur_calpar = [NSMutableArray array];
                NSMutableArray * cur_calraw = [NSMutableArray array];
                NSMutableArray * cur_calref = [NSMutableArray array];
                int calibType = [YAPI _decodeCalibrationPoints:calibration_str
                                                                   :cur_calpar
                                                                   :cur_calraw
                                                                   :cur_calref
                                                     withResolution:[[coldiv objectAtIndex:c] intValue]
                                                          andOffset:[[colscl objectAtIndex:c] intValue]];
                
                [caltyp addObject:[NSNumber numberWithInt:calibType]];
                [calpar addObject:cur_calraw];
                [calraw addObject:cur_calraw];
                [calref addObject:cur_calref];
                [calhdl addObject:[YAPI _getCalibrationHandler:calibType]];
                c++;
            }
            if(j.token[0] != ']') goto fail;
        }  else if(!strcmp(j.token, "data")) {
            if ([colscl count] == 0) {
                for (p =0; p< [coldiv count];p++) {
                    double pseudo_scal = 1.0 / (double)[[coldiv objectAtIndex:p] doubleValue];
                    NSNumber *n = [NSNumber numberWithDouble:pseudo_scal];
                    [colscl addObject:n];
                }
            }
            
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL ) break;
            udat = [NSMutableArray arrayWithCapacity:_nCols];
            
            if(j.st == YJSON_PARSE_STRING) {
                NSString* sdat = [_dataLogger _parseString:&j];
                for(p = 0; p < [sdat length];) {
                    NSNumber* val;
                    unsigned c = [sdat characterAtIndex:p++];
                    if(c >= 'a') {
                        int srcpos = (int) [udat count]-1-(c-'a');
                        if(srcpos < 0) goto fail;
                        val = [udat objectAtIndex:srcpos];
                    } else {
                        unsigned tval;
                        if(p+2 > [sdat length]) goto fail;
                        tval = (c - '0');
                        c = [sdat characterAtIndex:p++];
                        tval += (c - '0') << 5;
                        c = [sdat characterAtIndex:p++];
                        if(c == 'z') c = '\\';
                        tval += (c - '0') << 10;
                        val = [NSNumber numberWithUnsignedInt:tval];
                    }
                    [udat addObject:val];
                }

            } else if(j.st ==YJSON_PARSE_ARRAY)  {
                while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_NUM) {
                    unsigned val = atoi(j.token);
                    [udat addObject:[NSNumber numberWithUnsignedInt:val]];
                }       
                if(j.token[0] != ']' ) 
                    goto fail;
            } else {
                goto fail;
            }
            
            dat = [NSMutableArray arrayWithCapacity:_nCols];
            int c =0;
            for (NSNumber* val in udat) {
                double newval;
                if([[coltyp objectAtIndex:c] intValue] < 2) {
                    newval = ([val intValue] + [[colofs objectAtIndex:c] doubleValue]) * [[colscl objectAtIndex:c] doubleValue];
                } else {
                    newval = _decimalToDouble([val intValue]-32767);
                }

                [dat addObject:[NSNumber numberWithDouble:newval]];
                if(++c == _nCols) {
                    [_values addObject:dat];
                    dat = [NSMutableArray arrayWithCapacity:_nCols];
                    c=0;
                }
            }
            if( [dat count] > 0) goto fail;
        } else {
            // ignore unknown field
            yJsonSkip(&j, 1);
        }
    }
    ARC_release(coldiv);
    ARC_release(coltyp);
    ARC_release(colscl);
    ARC_release(colofs);

    return YAPI_SUCCESS;
}




/**
 * Returns the run index of the data stream. A run can be made of
 * multiple datastreams, for different time intervals.
 * 
 * This method does not cause any access to the device, as the value
 * is preloaded in the object at instantiation time.
 * 
 * @return an unsigned number corresponding to the run index.
 */
-(unsigned)                   get_runIndex
{
    return self.runIndex;
}
@synthesize runIndex = _runIndex;

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
-(unsigned)       get_startTime
{ return self.startTime;}
@synthesize startTime = _startTime;

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
-(time_t)    get_startTimeUTC
{
    return self.startTimeUTC;
}
@synthesize startTimeUTC = _startTimeUTC;

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
-(unsigned)        get_dataSamplesInterval
{
    return self.dataSamplesInterval;
}
@synthesize dataSamplesInterval =_interval;

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
-(unsigned)        get_rowCount
{
    return self.rowCount;
}

-(unsigned)        rowCount
{
    if(_nRows == 0) {
        [self _loadStream];
    }
    return _nRows;
}

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
-(unsigned)        get_columnCount
{
    return self.columnCount;
}
-(unsigned)        columnCount
{
    if(_nCols == 0) [self _loadStream];
    return _nCols;
}

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
-(NSArray*) get_columnNames
{
    return self.columnNames;
}
-(NSArray*) columnNames
{
    if([_columnNames count] == 0) [self _loadStream];
    return _columnNames;
}

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
-(NSArray*) get_dataRows
{
    return self.dataRows;
}
-(NSArray*) dataRows
{
    if([_values count] == 0) [self _loadStream];
    return _values;
}

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
-(NSNumber*) get_data:(unsigned)row  :(unsigned) col
{
    return [self data:row:col];
}
-(NSNumber*) data:(unsigned)row  :(unsigned) col
{
    if([_values count] == 0) [self _loadStream] ;
    if(row >= [_values count]) return nil;
    if(col >= [[_values objectAtIndex:row] count]) return nil;
    return [[_values objectAtIndex:row] objectAtIndex:col];
}


@end



@implementation YDataLogger

// Constructor is protected, use yFindDataLogger factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (generated code: YDataLogger attributes)
   if(!(self = [super initProtected:@"DataLogger":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _oldestRunIndex = Y_OLDESTRUNINDEX_INVALID;
    _currentRunIndex = Y_CURRENTRUNINDEX_INVALID;
    _samplingInterval = Y_SAMPLINGINTERVAL_INVALID;
    _timeUTC = Y_TIMEUTC_INVALID;
    _recording = Y_RECORDING_INVALID;
    _autoStart = Y_AUTOSTART_INVALID;
    _clearHistory = Y_CLEARHISTORY_INVALID;
//--- (end of generated code: YDataLogger attributes)
    _dataLoggerURL =  @"/logger.json";
    return self;
}



-(void) dealloc
{
    //--- (generated code: YDataLogger cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
//--- (end of generated code: YDataLogger cleanup)
    [super dealloc];
}

//--- (generated code: YDataLogger implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "oldestRunIndex")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _oldestRunIndex =  atoi(j->token);
        } else if(!strcmp(j->token, "currentRunIndex")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _currentRunIndex =  atoi(j->token);
        } else if(!strcmp(j->token, "samplingInterval")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _samplingInterval =  atoi(j->token);
        } else if(!strcmp(j->token, "timeUTC")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _timeUTC =  atoi(j->token);
        } else if(!strcmp(j->token, "recording")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _recording =  (Y_RECORDING_enum)atoi(j->token);
        } else if(!strcmp(j->token, "autoStart")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _autoStart =  (Y_AUTOSTART_enum)atoi(j->token);
        } else if(!strcmp(j->token, "clearHistory")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _clearHistory =  (Y_CLEARHISTORY_enum)atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the data logger.
 * 
 * @return a string corresponding to the logical name of the data logger
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

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
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the current value of the data logger (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the data logger (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the index of the oldest run for which the non-volatile memory still holds recorded data.
 * 
 * @return an integer corresponding to the index of the oldest run for which the non-volatile memory
 * still holds recorded data
 * 
 * On failure, throws an exception or returns Y_OLDESTRUNINDEX_INVALID.
 */
-(unsigned) get_oldestRunIndex
{
    return [self oldestRunIndex];
}
-(unsigned) oldestRunIndex
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_OLDESTRUNINDEX_INVALID;
    }
    return _oldestRunIndex;
}

/**
 * Returns the current run number, corresponding to the number of times the module was
 * powered on with the dataLogger enabled at some point.
 * 
 * @return an integer corresponding to the current run number, corresponding to the number of times the module was
 *         powered on with the dataLogger enabled at some point
 * 
 * On failure, throws an exception or returns Y_CURRENTRUNINDEX_INVALID.
 */
-(unsigned) get_currentRunIndex
{
    return [self currentRunIndex];
}
-(unsigned) currentRunIndex
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CURRENTRUNINDEX_INVALID;
    }
    return _currentRunIndex;
}

-(unsigned) get_samplingInterval
{
    return [self samplingInterval];
}
-(unsigned) samplingInterval
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SAMPLINGINTERVAL_INVALID;
    }
    return _samplingInterval;
}

-(int) set_samplingInterval:(unsigned) newval
{
    return [self setSamplingInterval:newval];
}
-(int) setSamplingInterval:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"samplingInterval" :rest_val];
}

/**
 * Returns the Unix timestamp for current UTC time, if known.
 * 
 * @return an integer corresponding to the Unix timestamp for current UTC time, if known
 * 
 * On failure, throws an exception or returns Y_TIMEUTC_INVALID.
 */
-(unsigned) get_timeUTC
{
    return [self timeUTC];
}
-(unsigned) timeUTC
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_TIMEUTC_INVALID;
    }
    return _timeUTC;
}

/**
 * Changes the current UTC time reference used for recorded data.
 * 
 * @param newval : an integer corresponding to the current UTC time reference used for recorded data
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_timeUTC:(unsigned) newval
{
    return [self setTimeUTC:newval];
}
-(int) setTimeUTC:(unsigned) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"timeUTC" :rest_val];
}

/**
 * Returns the current activation state of the data logger.
 * 
 * @return either Y_RECORDING_OFF or Y_RECORDING_ON, according to the current activation state of the data logger
 * 
 * On failure, throws an exception or returns Y_RECORDING_INVALID.
 */
-(Y_RECORDING_enum) get_recording
{
    return [self recording];
}
-(Y_RECORDING_enum) recording
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_RECORDING_INVALID;
    }
    return _recording;
}

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
-(int) set_recording:(Y_RECORDING_enum) newval
{
    return [self setRecording:newval];
}
-(int) setRecording:(Y_RECORDING_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"recording" :rest_val];
}

/**
 * Returns the default activation state of the data logger on power up.
 * 
 * @return either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the default activation state of the
 * data logger on power up
 * 
 * On failure, throws an exception or returns Y_AUTOSTART_INVALID.
 */
-(Y_AUTOSTART_enum) get_autoStart
{
    return [self autoStart];
}
-(Y_AUTOSTART_enum) autoStart
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_AUTOSTART_INVALID;
    }
    return _autoStart;
}

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
-(int) set_autoStart:(Y_AUTOSTART_enum) newval
{
    return [self setAutoStart:newval];
}
-(int) setAutoStart:(Y_AUTOSTART_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"autoStart" :rest_val];
}

-(Y_CLEARHISTORY_enum) get_clearHistory
{
    return [self clearHistory];
}
-(Y_CLEARHISTORY_enum) clearHistory
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_CLEARHISTORY_INVALID;
    }
    return _clearHistory;
}

-(int) set_clearHistory:(Y_CLEARHISTORY_enum) newval
{
    return [self setClearHistory:newval];
}
-(int) setClearHistory:(Y_CLEARHISTORY_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"clearHistory" :rest_val];
}

-(YDataLogger*)   nextDataLogger
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindDataLogger(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YDataLogger*) FindDataLogger:(NSString*) func
{
    YDataLogger * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YDataLogger"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YDataLogger"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YDataLogger"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YDataLogger"] objectForKey:func];
    } else {
        retVal = [[YDataLogger alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YDataLogger"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YDataLogger *) FirstDataLogger
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"DataLogger":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDataLogger FindDataLogger:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YDataLogger implementation)



// DataLogger-specific method to retrieve and pre-parse recorded data
//
-(int) _getData:(unsigned)runIdx  :(unsigned)timeIdx :(NSString**) buffer :(yJsonStateMachine*) j
{
    YDevice     *dev;
    NSData      *raw_buffer;
    NSString    *query;
    NSError     *error;
    int         res;
    
    // Resolve our reference to our device, load REST API
    res = [self _getDevice:&dev: &error ];
    if(YISERR(res)) {
        [self _throw:error];
        return res;
    }
    if(timeIdx) {
        query =[NSString stringWithFormat:@"GET %@?run=%u&time=%u HTTP/1.1\r\n\r\n",_dataLoggerURL, runIdx, timeIdx];
    } else {
        query =[NSString stringWithFormat:@"GET %@ HTTP/1.1\r\n\r\n",_dataLoggerURL];
    }
    res = [dev HTTPRequest:query :&raw_buffer: &error ];
    if(YISERR(res)) {
        // Check if an update of the device list does not solve the issue
        res = [YapiWrapper updateDeviceList:1:&error ];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }
        res = [dev HTTPRequest:query:&raw_buffer:&error];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }
    }
    *buffer = [[NSString alloc] initWithData:raw_buffer encoding:NSISOLatin1StringEncoding];
    ARC_autorelease(*buffer);
    // Parse HTTP header
    j->src = STR_oc2y(*buffer);
    j->end = j->src + strlen(j->src);
    j->st = YJSON_HTTP_START;
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_HTTP_READ_CODE) {
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Failed to parse HTTP header");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }
    if(![STR_y2oc(j->token) isEqualToString:@"200"]) {
        if([STR_y2oc(j->token) isEqualToString:@"400"] &&
           ![_dataLoggerURL isEqualToString:@"/dataLogger.json"]) {
            // retry using backward-compatible datalogger URL
            _dataLoggerURL =@"/dataLogger.json";
            return [self _getData:runIdx :timeIdx :buffer :j];
        }
        
        NSString *tmp = [[NSString alloc] initWithFormat:@"Unexpected HTTP return code: %s",j->token];
        NSError  *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,STR_oc2y(tmp));
        [self _throw:error];
        ARC_release(tmp);
        return YAPI_IO_ERROR;
    }
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_HTTP_READ_MSG) {
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Unexpected HTTP header format");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }
    
    return YAPI_SUCCESS;
}



/**
 * Clears the data logger memory and discards all recorded data streams.
 * This method also resets the current run index to zero.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)             forgetAllDataStreams
{
    return [self set_clearHistory:Y_CLEARHISTORY_TRUE];
}

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
-(int)             get_dataStreams:(NSArray**) v
{
    return [self dataStreams:v];
}

-(int)             dataStreams:(NSArray**) param
{
    NSString            *buffer;
    yJsonStateMachine   j;
    int                 i, res;
    unsigned            arr[4];
    NSMutableArray      *v;
    
    //v.clear();
    if((res = [self _getData:0: 0: &buffer: &j]) != YAPI_SUCCESS) {
        return res;
    }
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) {
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Unexpected JSON reply format");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }
    v = [[NSMutableArray alloc] init];
    // expect arrays in array
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.token[0] == '[') {
        // get four number
        for(i = 0; i < 4; i++) {
            if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_NUM) break;
            arr[i] = atoi(j.token);
        }
        if(i < 4) break;
        // skip any extra item in array
        while(yJsonParse(&j) != YJSON_PARSE_AVAIL && j.token[0] != ']');
        // instantiate a data stream
        YDataStream *stream =[[YDataStream alloc] initWithDataLogger:self :arr[0] :arr[1] :arr[2] :arr[3]];
        [v addObject:stream];
    }
    *param =v;
    return YAPI_SUCCESS;
 
    
}




@end

//--- (generated code: DataLogger functions)

YDataLogger *yFindDataLogger(NSString* func)
{
    return [YDataLogger FindDataLogger:func];
}

YDataLogger *yFirstDataLogger(void)
{
    return [YDataLogger FirstDataLogger];
}

//--- (end of generated code: DataLogger functions)
