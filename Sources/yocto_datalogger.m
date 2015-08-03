/*********************************************************************
 *
 * $Id: yocto_datalogger.m 20704 2015-06-20 19:43:34Z mvuilleu $
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

/**
 * YDataStream Class: Sequence of measured data, returned by the data logger
 *
 * A data stream is a small collection of consecutive measures for a set
 * of sensors. A few properties are available directly from the object itself
 * (they are preloaded at instantiation time), while most other properties and
 * the actual data are loaded on demand when accessed for the first time.
 */
@implementation YOldDataStream


-(id) initWithDataLogger:(YDataLogger *)parrent :(unsigned int)run :(unsigned int)stamp :(unsigned int)utc :(unsigned int)itv
{
    self = [super init];
    if(self){
        _dataLogger     = parrent;
        _runNo       = run;
        _startTime      = stamp;
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

    if((res = [_dataLogger _getData:_runNo:_startTime:&buffer:&j]) != YAPI_SUCCESS) {
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
            _utcStamp = atoi(j.token);
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
                NSMutableArray * cur_calraw = [NSMutableArray array];
                NSMutableArray * cur_calref = [NSMutableArray array];
                int calibType = 0;
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
                    newval = [YAPI _decimalToDouble:[val intValue]-32767];
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
-(unsigned)       get_startTime
{ return self.startTime;}
@synthesize startTime = _startTime;

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

@end



@implementation YDataLogger

// Constructor is protected, use yFindDataLogger factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"DataLogger";
//--- (generated code: YDataLogger attributes initialization)
    _currentRunIndex = Y_CURRENTRUNINDEX_INVALID;
    _timeUTC = Y_TIMEUTC_INVALID;
    _recording = Y_RECORDING_INVALID;
    _autoStart = Y_AUTOSTART_INVALID;
    _beaconDriven = Y_BEACONDRIVEN_INVALID;
    _clearHistory = Y_CLEARHISTORY_INVALID;
    _valueCallbackDataLogger = NULL;
//--- (end of generated code: YDataLogger attributes initialization)
    _dataLoggerURL =  @"/logger.json";
    return self;
}



-(void) dealloc
{
//--- (generated code: YDataLogger cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YDataLogger cleanup)
}
//--- (generated code: YDataLogger private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "currentRunIndex")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentRunIndex =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "timeUTC")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _timeUTC =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "recording")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _recording =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "autoStart")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _autoStart =  (Y_AUTOSTART_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "beaconDriven")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _beaconDriven =  (Y_BEACONDRIVEN_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "clearHistory")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _clearHistory =  (Y_CLEARHISTORY_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YDataLogger private methods implementation)

// DataLogger-specific method to retrieve and pre-parse recorded data
//
-(int) _getData:(unsigned)runIdx  :(unsigned)timeIdx :(NSString**) buffer :(yJsonStateMachine*) j
{
    YDevice     *dev;
    NSMutableData      *raw_buffer;
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
        if([STR_y2oc(j->token) isEqualToString:@"404"] &&
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
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL) {
        if (j.token[0] == '[') {
            // get four number
            for(i = 0; i < 4; i++) {
                if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_NUM) break;
                arr[i] = atoi(j.token);
            }
            if(i < 4) break;
            // skip any extra item in array
            while(yJsonParse(&j) != YJSON_PARSE_AVAIL && j.token[0] != ']');
            // instantiate a data stream
            YDataStream *stream =[[YOldDataStream alloc] initWithDataLogger:self :arr[0] :arr[1] :arr[2] :arr[3]];
            [v addObject:stream];
        }else if(j.token[0] == '{') {
            // new datalogger format: {"id":"...","unit":"...","streams":["...",...]}
            NSRange range = [buffer rangeOfString:@"\r\n\r\n"];
            buffer = [buffer substringFromIndex:NSMaxRange(range)];
            NSData* buffer_bin = [buffer dataUsingEncoding:NSISOLatin1StringEncoding];
            NSMutableArray* sets = [self parse_dataSets:buffer_bin];
            for (i=0; i < [sets count]; i++) {
                YDataSet *dset = [sets objectAtIndex:i];
                NSMutableArray* ds = [dset get_privateDataStreams];
                for (int si=0; si < [ds count]; si++) {
                    [v addObject:[ds objectAtIndex:si]];
                }
            }
            break;
        } else break;
    }
    *param =v;
    return YAPI_SUCCESS;


}

//--- (generated code: YDataLogger public methods implementation)
/**
 * Returns the current run number, corresponding to the number of times the module was
 * powered on with the dataLogger enabled at some point.
 *
 * @return an integer corresponding to the current run number, corresponding to the number of times the module was
 *         powered on with the dataLogger enabled at some point
 *
 * On failure, throws an exception or returns Y_CURRENTRUNINDEX_INVALID.
 */
-(int) get_currentRunIndex
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTRUNINDEX_INVALID;
        }
    }
    return _currentRunIndex;
}


-(int) currentRunIndex
{
    return [self get_currentRunIndex];
}
/**
 * Returns the Unix timestamp for current UTC time, if known.
 *
 * @return an integer corresponding to the Unix timestamp for current UTC time, if known
 *
 * On failure, throws an exception or returns Y_TIMEUTC_INVALID.
 */
-(s64) get_timeUTC
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_TIMEUTC_INVALID;
        }
    }
    return _timeUTC;
}


-(s64) timeUTC
{
    return [self get_timeUTC];
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
-(int) set_timeUTC:(s64) newval
{
    return [self setTimeUTC:newval];
}
-(int) setTimeUTC:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"timeUTC" :rest_val];
}
/**
 * Returns the current activation state of the data logger.
 *
 * @return a value among Y_RECORDING_OFF, Y_RECORDING_ON and Y_RECORDING_PENDING corresponding to the
 * current activation state of the data logger
 *
 * On failure, throws an exception or returns Y_RECORDING_INVALID.
 */
-(Y_RECORDING_enum) get_recording
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_RECORDING_INVALID;
        }
    }
    return _recording;
}


-(Y_RECORDING_enum) recording
{
    return [self get_recording];
}

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
-(int) set_recording:(Y_RECORDING_enum) newval
{
    return [self setRecording:newval];
}
-(int) setRecording:(Y_RECORDING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
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
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUTOSTART_INVALID;
        }
    }
    return _autoStart;
}


-(Y_AUTOSTART_enum) autoStart
{
    return [self get_autoStart];
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
/**
 * Return true if the data logger is synchronised with the localization beacon.
 *
 * @return either Y_BEACONDRIVEN_OFF or Y_BEACONDRIVEN_ON
 *
 * On failure, throws an exception or returns Y_BEACONDRIVEN_INVALID.
 */
-(Y_BEACONDRIVEN_enum) get_beaconDriven
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_BEACONDRIVEN_INVALID;
        }
    }
    return _beaconDriven;
}


-(Y_BEACONDRIVEN_enum) beaconDriven
{
    return [self get_beaconDriven];
}

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
-(int) set_beaconDriven:(Y_BEACONDRIVEN_enum) newval
{
    return [self setBeaconDriven:newval];
}
-(int) setBeaconDriven:(Y_BEACONDRIVEN_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"beaconDriven" :rest_val];
}
-(Y_CLEARHISTORY_enum) get_clearHistory
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_CLEARHISTORY_INVALID;
        }
    }
    return _clearHistory;
}


-(Y_CLEARHISTORY_enum) clearHistory
{
    return [self get_clearHistory];
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
+(YDataLogger*) FindDataLogger:(NSString*)func
{
    YDataLogger* obj;
    obj = (YDataLogger*) [YFunction _FindFromCache:@"DataLogger" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDataLogger alloc] initWith:func]);
        [YFunction _AddToCache:@"DataLogger" : func :obj];
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
-(int) registerValueCallback:(YDataLoggerValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDataLogger = callback;
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
    if (_valueCallbackDataLogger != NULL) {
        _valueCallbackDataLogger(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Clears the data logger memory and discards all recorded data streams.
 * This method also resets the current run index to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) forgetAllDataStreams
{
    return [self set_clearHistory:Y_CLEARHISTORY_TRUE];
}

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
-(NSMutableArray*) get_dataSets
{
    return [self parse_dataSets:[self _download:@"logger.json"]];
}

-(NSMutableArray*) parse_dataSets:(NSData*)json
{
    NSMutableArray* dslist = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    // may throw an exception
    dslist = [self _json_get_array:json];
    [res removeAllObjects];
    for (NSString* _each  in dslist) {
        [res addObject:ARC_sendAutorelease([[YDataSet alloc] initWith:self :_each])];
    }
    return res;
}


-(YDataLogger*)   nextDataLogger
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDataLogger FindDataLogger:hwid];
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

//--- (end of generated code: YDataLogger public methods implementation)

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
