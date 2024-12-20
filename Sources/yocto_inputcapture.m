/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for InputCaptureData functions
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



#import "yocto_inputcapture.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"

@implementation YInputCaptureData


-(id)   initWith:(YFunction *)yfun :(NSData*)sdata
{
//--- (generated code: YInputCaptureData attributes initialization)
    _fmt = 0;
    _var1size = 0;
    _var2size = 0;
    _var3size = 0;
    _nVars = 0;
    _recOfs = 0;
    _nRecs = 0;
    _samplesPerSec = 0;
    _trigType = 0;
    _trigVal = 0;
    _trigPos = 0;
    _trigUTC = 0;
    _var1samples = [NSMutableArray array];
    _var2samples = [NSMutableArray array];
    _var3samples = [NSMutableArray array];
//--- (end of generated code: YInputCaptureData attributes initialization)
    [self _decodeSnapBin:sdata];
    return self;
}

// Method used to throw exceptions or save error type/message
-(void) _throw:(YRETCODE) errType withMsg:(const char*) errMsg
{
    NSError *error=nil;
    yFormatRetVal(&error, errType, errMsg);
    [self _throw:error];
}

// Method used to throw exceptions or save error type/message
-(void)        _throw:(YRETCODE) errType :(NSString*) errMsg
{
    NSError *error;
    // Make and return custom domain error.
    NSArray *objArray = [NSArray arrayWithObjects:errMsg,  nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
    error = [NSError errorWithDomain:@"com.yoctopuce"
                                         code:errType
                                     userInfo:eDict];
    [self _throw:error];
}

// Method used to throw exceptions or save error type/message
-(void)        _throw:(NSError*) error
{

    ARC_retain(error);
    // Method used to throw exceptions or save error type/message
    if(![YAPI ExceptionsDisabled]) {
        NSNumber     *n   = [NSNumber numberWithInteger:[error code]];
        NSDictionary *dic =[NSDictionary dictionaryWithObject:n forKey:@"errType"];
        NSException  *e   =[NSException exceptionWithName:@"YAPI_Exception"
                                                   reason:[error localizedDescription]
                                                 userInfo:dic];
        @throw e;
    }
}

// destructor
-(void)  dealloc
{
//--- (generated code: YInputCaptureData cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YInputCaptureData cleanup)
}

//--- (generated code: YInputCaptureData private methods implementation)

//--- (end of generated code: YInputCaptureData private methods implementation)

//--- (generated code: YInputCaptureData public methods implementation)
-(int) _decodeU16:(NSData*)sdata :(int)ofs
{
    int v;
    v = (((u8*)([sdata bytes]))[ofs]);
    v = v + 256 * (((u8*)([sdata bytes]))[ofs+1]);
    return v;
}

-(double) _decodeU32:(NSData*)sdata :(int)ofs
{
    double v;
    v = [self _decodeU16:sdata :ofs];
    v = v + 65536.0 * [self _decodeU16:sdata :ofs+2];
    return v;
}

-(double) _decodeVal:(NSData*)sdata :(int)ofs :(int)len
{
    double v;
    double b;
    v = [self _decodeU16:sdata :ofs];
    b = 65536.0;
    ofs = ofs + 2;
    len = len - 2;
    while (len > 0) {
        v = v + b * (((u8*)([sdata bytes]))[ofs]);
        b = b * 256;
        ofs = ofs + 1;
        len = len - 1;
    }
    if (v > (b/2)) {
        // negative number
        v = v - b;
    }
    return v;
}

-(int) _decodeSnapBin:(NSData*)sdata
{
    int buffSize;
    int recOfs;
    int ms;
    int recSize;
    int count;
    int mult1;
    int mult2;
    int mult3;
    double v;

    buffSize = (int)[sdata length];
    if (!(buffSize >= 24)) {[self _throw:YAPI_INVALID_ARGUMENT:@"Invalid snapshot data (too short)"]; return YAPI_INVALID_ARGUMENT;}
    _fmt = (((u8*)([sdata bytes]))[0]);
    _var1size = (((u8*)([sdata bytes]))[1]) - 48;
    _var2size = (((u8*)([sdata bytes]))[2]) - 48;
    _var3size = (((u8*)([sdata bytes]))[3]) - 48;
    if (!(_fmt == 83)) {[self _throw:YAPI_INVALID_ARGUMENT:@"Unsupported snapshot format"]; return YAPI_INVALID_ARGUMENT;}
    if (!((_var1size >= 2) && (_var1size <= 4))) {[self _throw:YAPI_INVALID_ARGUMENT:@"Invalid sample size"]; return YAPI_INVALID_ARGUMENT;}
    if (!((_var2size >= 0) && (_var1size <= 4))) {[self _throw:YAPI_INVALID_ARGUMENT:@"Invalid sample size"]; return YAPI_INVALID_ARGUMENT;}
    if (!((_var3size >= 0) && (_var1size <= 4))) {[self _throw:YAPI_INVALID_ARGUMENT:@"Invalid sample size"]; return YAPI_INVALID_ARGUMENT;}
    if (_var2size == 0) {
        _nVars = 1;
    } else {
        if (_var3size == 0) {
            _nVars = 2;
        } else {
            _nVars = 3;
        }
    }
    recSize = _var1size + _var2size + _var3size;
    _recOfs = [self _decodeU16:sdata :4];
    _nRecs = [self _decodeU16:sdata :6];
    _samplesPerSec = [self _decodeU16:sdata :8];
    _trigType = [self _decodeU16:sdata :10];
    _trigVal = [self _decodeVal:sdata :12 :4] / 1000;
    _trigPos = [self _decodeU16:sdata :16];
    ms = [self _decodeU16:sdata :18];
    _trigUTC = [self _decodeVal:sdata :20 :4];
    _trigUTC = _trigUTC + (ms / 1000.0);
    recOfs = 24;
    while ((((u8*)([sdata bytes]))[recOfs]) >= 32) {
        _var1unit = [NSString stringWithFormat:@"%@%c",_var1unit,(((u8*)([sdata bytes]))[recOfs])];
        recOfs = recOfs + 1;
    }
    if (_var2size > 0) {
        recOfs = recOfs + 1;
        while ((((u8*)([sdata bytes]))[recOfs]) >= 32) {
            _var2unit = [NSString stringWithFormat:@"%@%c",_var2unit,(((u8*)([sdata bytes]))[recOfs])];
            recOfs = recOfs + 1;
        }
    }
    if (_var3size > 0) {
        recOfs = recOfs + 1;
        while ((((u8*)([sdata bytes]))[recOfs]) >= 32) {
            _var3unit = [NSString stringWithFormat:@"%@%c",_var3unit,(((u8*)([sdata bytes]))[recOfs])];
            recOfs = recOfs + 1;
        }
    }
    if ((recOfs & 1) == 1) {
        // align to next word
        recOfs = recOfs + 1;
    }
    mult1 = 1;
    mult2 = 1;
    mult3 = 1;
    if (recOfs < _recOfs) {
        // load optional value multiplier
        mult1 = [self _decodeU16:sdata :recOfs];
        recOfs = recOfs + 2;
        if (_var2size > 0) {
            mult2 = [self _decodeU16:sdata :recOfs];
            recOfs = recOfs + 2;
        }
        if (_var3size > 0) {
            mult3 = [self _decodeU16:sdata :recOfs];
            recOfs = recOfs + 2;
        }
    }
    recOfs = _recOfs;
    count = _nRecs;
    while ((count > 0) && (recOfs + _var1size <= buffSize)) {
        v = [self _decodeVal:sdata :recOfs :_var1size] / 1000.0;
        [_var1samples addObject:[NSNumber numberWithDouble:v*mult1]];
        recOfs = recOfs + recSize;
    }
    if (_var2size > 0) {
        recOfs = _recOfs + _var1size;
        count = _nRecs;
        while ((count > 0) && (recOfs + _var2size <= buffSize)) {
            v = [self _decodeVal:sdata :recOfs :_var2size] / 1000.0;
            [_var2samples addObject:[NSNumber numberWithDouble:v*mult2]];
            recOfs = recOfs + recSize;
        }
    }
    if (_var3size > 0) {
        recOfs = _recOfs + _var1size + _var2size;
        count = _nRecs;
        while ((count > 0) && (recOfs + _var3size <= buffSize)) {
            v = [self _decodeVal:sdata :recOfs :_var3size] / 1000.0;
            [_var3samples addObject:[NSNumber numberWithDouble:v*mult3]];
            recOfs = recOfs + recSize;
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Returns the number of series available in the capture.
 *
 * @return an integer corresponding to the number of
 *         simultaneous data series available.
 */
-(int) get_serieCount
{
    return _nVars;
}

/**
 * Returns the number of records captured (in a serie).
 * In the exceptional case where it was not possible
 * to transfer all data in time, the number of records
 * actually present in the series might be lower than
 * the number of records captured
 *
 * @return an integer corresponding to the number of
 *         records expected in each serie.
 */
-(int) get_recordCount
{
    return _nRecs;
}

/**
 * Returns the effective sampling rate of the device.
 *
 * @return an integer corresponding to the number of
 *         samples taken each second.
 */
-(int) get_samplingRate
{
    return _samplesPerSec;
}

/**
 * Returns the type of automatic conditional capture
 * that triggered the capture of this data sequence.
 *
 * @return the type of conditional capture.
 */
-(Y_CAPTURETYPEALL_enum) get_captureType
{
    return (Y_CAPTURETYPEALL_enum) _trigType;
}

/**
 * Returns the threshold value that triggered
 * this automatic conditional capture, if it was
 * not an instant captured triggered manually.
 *
 * @return the conditional threshold value
 *         at the time of capture.
 */
-(double) get_triggerValue
{
    return _trigVal;
}

/**
 * Returns the index in the series of the sample
 * corresponding to the exact time when the capture
 * was triggered. In case of trigger based on average
 * or RMS value, the trigger index corresponds to
 * the end of the averaging period.
 *
 * @return an integer corresponding to a position
 *         in the data serie.
 */
-(int) get_triggerPosition
{
    return _trigPos;
}

/**
 * Returns the absolute time when the capture was
 * triggered, as a Unix timestamp. Milliseconds are
 * included in this timestamp (floating-point number).
 *
 * @return a floating-point number corresponding to
 *         the number of seconds between the Jan 1,
 *         1970 and the moment where the capture
 *         was triggered.
 */
-(double) get_triggerRealTimeUTC
{
    return _trigUTC;
}

/**
 * Returns the unit of measurement for data points in
 * the first serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*) get_serie1Unit
{
    return _var1unit;
}

/**
 * Returns the unit of measurement for data points in
 * the second serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*) get_serie2Unit
{
    if (!(_nVars >= 2)) {[self _throw:YAPI_INVALID_ARGUMENT:@"There is no serie 2 in self capture data"]; return @"";}
    return _var2unit;
}

/**
 * Returns the unit of measurement for data points in
 * the third serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*) get_serie3Unit
{
    if (!(_nVars >= 3)) {[self _throw:YAPI_INVALID_ARGUMENT:@"There is no serie 3 in self capture data"]; return @"";}
    return _var3unit;
}

/**
 * Returns the sampled data corresponding to the first serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie1Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 1.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_serie1Values
{
    return _var1samples;
}

/**
 * Returns the sampled data corresponding to the second serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie2Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 2.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_serie2Values
{
    if (!(_nVars >= 2)) {[self _throw:YAPI_INVALID_ARGUMENT:@"There is no serie 2 in self capture data"]; return _var2samples;}
    return _var2samples;
}

/**
 * Returns the sampled data corresponding to the third serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie3Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 3.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*) get_serie3Values
{
    if (!(_nVars >= 3)) {[self _throw:YAPI_INVALID_ARGUMENT:@"There is no serie 3 in self capture data"]; return _var3samples;}
    return _var3samples;
}

//--- (end of generated code: YInputCaptureData public methods implementation)

@end
//--- (generated code: YInputCaptureData functions)
//--- (end of generated code: YInputCaptureData functions)



@implementation YInputCapture

// Constructor is protected, use yFindI2cPort factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"I2cPort";
//--- (generated code: YInputCapture attributes initialization)
    _lastCaptureTime = Y_LASTCAPTURETIME_INVALID;
    _nSamples = Y_NSAMPLES_INVALID;
    _samplingRate = Y_SAMPLINGRATE_INVALID;
    _captureType = Y_CAPTURETYPE_INVALID;
    _condValue = Y_CONDVALUE_INVALID;
    _condAlign = Y_CONDALIGN_INVALID;
    _captureTypeAtStartup = Y_CAPTURETYPEATSTARTUP_INVALID;
    _condValueAtStartup = Y_CONDVALUEATSTARTUP_INVALID;
    _valueCallbackInputCapture = NULL;
//--- (end of generated code: YInputCapture attributes initialization)
    return self;
}
//--- (generated code: YInputCapture yapiwrapper)
//--- (end of generated code: YInputCapture yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (generated code: YInputCapture cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YInputCapture cleanup)
}
//--- (generated code: YInputCapture private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "lastCaptureTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastCaptureTime =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "nSamples")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nSamples =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "samplingRate")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _samplingRate =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "captureType")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _captureType =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "condValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _condValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "condAlign")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _condAlign =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "captureTypeAtStartup")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _captureTypeAtStartup =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "condValueAtStartup")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _condValueAtStartup =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YInputCapture private methods implementation)
//--- (generated code: YInputCapture public methods implementation)
/**
 * Returns the number of elapsed milliseconds between the module power on
 * and the last capture (time of trigger), or zero if no capture has been done.
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 *         and the last capture (time of trigger), or zero if no capture has been done
 *
 * On failure, throws an exception or returns YInputCapture.LASTCAPTURETIME_INVALID.
 */
-(s64) get_lastCaptureTime
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTCAPTURETIME_INVALID;
        }
    }
    res = _lastCaptureTime;
    return res;
}


-(s64) lastCaptureTime
{
    return [self get_lastCaptureTime];
}
/**
 * Returns the number of samples that will be captured.
 *
 * @return an integer corresponding to the number of samples that will be captured
 *
 * On failure, throws an exception or returns YInputCapture.NSAMPLES_INVALID.
 */
-(int) get_nSamples
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NSAMPLES_INVALID;
        }
    }
    res = _nSamples;
    return res;
}


-(int) nSamples
{
    return [self get_nSamples];
}

/**
 * Changes the type of automatic conditional capture.
 * The maximum number of samples depends on the device memory.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : an integer corresponding to the type of automatic conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_nSamples:(int) newval
{
    return [self setNSamples:newval];
}
-(int) setNSamples:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"nSamples" :rest_val];
}
/**
 * Returns the sampling frequency, in Hz.
 *
 * @return an integer corresponding to the sampling frequency, in Hz
 *
 * On failure, throws an exception or returns YInputCapture.SAMPLINGRATE_INVALID.
 */
-(int) get_samplingRate
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SAMPLINGRATE_INVALID;
        }
    }
    res = _samplingRate;
    return res;
}


-(int) samplingRate
{
    return [self get_samplingRate];
}
/**
 * Returns the type of automatic conditional capture.
 *
 * @return a value among YInputCapture.CAPTURETYPE_NONE, YInputCapture.CAPTURETYPE_TIMED,
 * YInputCapture.CAPTURETYPE_V_MAX, YInputCapture.CAPTURETYPE_V_MIN, YInputCapture.CAPTURETYPE_I_MAX,
 * YInputCapture.CAPTURETYPE_I_MIN, YInputCapture.CAPTURETYPE_P_MAX, YInputCapture.CAPTURETYPE_P_MIN,
 * YInputCapture.CAPTURETYPE_V_AVG_MAX, YInputCapture.CAPTURETYPE_V_AVG_MIN,
 * YInputCapture.CAPTURETYPE_V_RMS_MAX, YInputCapture.CAPTURETYPE_V_RMS_MIN,
 * YInputCapture.CAPTURETYPE_I_AVG_MAX, YInputCapture.CAPTURETYPE_I_AVG_MIN,
 * YInputCapture.CAPTURETYPE_I_RMS_MAX, YInputCapture.CAPTURETYPE_I_RMS_MIN,
 * YInputCapture.CAPTURETYPE_P_AVG_MAX, YInputCapture.CAPTURETYPE_P_AVG_MIN,
 * YInputCapture.CAPTURETYPE_PF_MIN and YInputCapture.CAPTURETYPE_DPF_MIN corresponding to the type of
 * automatic conditional capture
 *
 * On failure, throws an exception or returns YInputCapture.CAPTURETYPE_INVALID.
 */
-(Y_CAPTURETYPE_enum) get_captureType
{
    Y_CAPTURETYPE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CAPTURETYPE_INVALID;
        }
    }
    res = _captureType;
    return res;
}


-(Y_CAPTURETYPE_enum) captureType
{
    return [self get_captureType];
}

/**
 * Changes the type of automatic conditional capture.
 *
 * @param newval : a value among YInputCapture.CAPTURETYPE_NONE, YInputCapture.CAPTURETYPE_TIMED,
 * YInputCapture.CAPTURETYPE_V_MAX, YInputCapture.CAPTURETYPE_V_MIN, YInputCapture.CAPTURETYPE_I_MAX,
 * YInputCapture.CAPTURETYPE_I_MIN, YInputCapture.CAPTURETYPE_P_MAX, YInputCapture.CAPTURETYPE_P_MIN,
 * YInputCapture.CAPTURETYPE_V_AVG_MAX, YInputCapture.CAPTURETYPE_V_AVG_MIN,
 * YInputCapture.CAPTURETYPE_V_RMS_MAX, YInputCapture.CAPTURETYPE_V_RMS_MIN,
 * YInputCapture.CAPTURETYPE_I_AVG_MAX, YInputCapture.CAPTURETYPE_I_AVG_MIN,
 * YInputCapture.CAPTURETYPE_I_RMS_MAX, YInputCapture.CAPTURETYPE_I_RMS_MIN,
 * YInputCapture.CAPTURETYPE_P_AVG_MAX, YInputCapture.CAPTURETYPE_P_AVG_MIN,
 * YInputCapture.CAPTURETYPE_PF_MIN and YInputCapture.CAPTURETYPE_DPF_MIN corresponding to the type of
 * automatic conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_captureType:(Y_CAPTURETYPE_enum) newval
{
    return [self setCaptureType:newval];
}
-(int) setCaptureType:(Y_CAPTURETYPE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"captureType" :rest_val];
}

/**
 * Changes current threshold value for automatic conditional capture.
 *
 * @param newval : a floating point number corresponding to current threshold value for automatic
 * conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_condValue:(double) newval
{
    return [self setCondValue:newval];
}
-(int) setCondValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"condValue" :rest_val];
}
/**
 * Returns current threshold value for automatic conditional capture.
 *
 * @return a floating point number corresponding to current threshold value for automatic conditional capture
 *
 * On failure, throws an exception or returns YInputCapture.CONDVALUE_INVALID.
 */
-(double) get_condValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CONDVALUE_INVALID;
        }
    }
    res = _condValue;
    return res;
}


-(double) condValue
{
    return [self get_condValue];
}
/**
 * Returns the relative position of the trigger event within the capture window.
 * When the value is 50%, the capture is centered on the event.
 *
 * @return an integer corresponding to the relative position of the trigger event within the capture window
 *
 * On failure, throws an exception or returns YInputCapture.CONDALIGN_INVALID.
 */
-(int) get_condAlign
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CONDALIGN_INVALID;
        }
    }
    res = _condAlign;
    return res;
}


-(int) condAlign
{
    return [self get_condAlign];
}

/**
 * Changes the relative position of the trigger event within the capture window.
 * The new value must be between 10% (on the left) and 90% (on the right).
 * When the value is 50%, the capture is centered on the event.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : an integer corresponding to the relative position of the trigger event within the capture window
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_condAlign:(int) newval
{
    return [self setCondAlign:newval];
}
-(int) setCondAlign:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"condAlign" :rest_val];
}
/**
 * Returns the type of automatic conditional capture
 * applied at device power on.
 *
 * @return a value among YInputCapture.CAPTURETYPEATSTARTUP_NONE,
 * YInputCapture.CAPTURETYPEATSTARTUP_TIMED, YInputCapture.CAPTURETYPEATSTARTUP_V_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_PF_MIN and
 * YInputCapture.CAPTURETYPEATSTARTUP_DPF_MIN corresponding to the type of automatic conditional capture
 *         applied at device power on
 *
 * On failure, throws an exception or returns YInputCapture.CAPTURETYPEATSTARTUP_INVALID.
 */
-(Y_CAPTURETYPEATSTARTUP_enum) get_captureTypeAtStartup
{
    Y_CAPTURETYPEATSTARTUP_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CAPTURETYPEATSTARTUP_INVALID;
        }
    }
    res = _captureTypeAtStartup;
    return res;
}


-(Y_CAPTURETYPEATSTARTUP_enum) captureTypeAtStartup
{
    return [self get_captureTypeAtStartup];
}

/**
 * Changes the type of automatic conditional capture
 * applied at device power on.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : a value among YInputCapture.CAPTURETYPEATSTARTUP_NONE,
 * YInputCapture.CAPTURETYPEATSTARTUP_TIMED, YInputCapture.CAPTURETYPEATSTARTUP_V_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_PF_MIN and
 * YInputCapture.CAPTURETYPEATSTARTUP_DPF_MIN corresponding to the type of automatic conditional capture
 *         applied at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_captureTypeAtStartup:(Y_CAPTURETYPEATSTARTUP_enum) newval
{
    return [self setCaptureTypeAtStartup:newval];
}
-(int) setCaptureTypeAtStartup:(Y_CAPTURETYPEATSTARTUP_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"captureTypeAtStartup" :rest_val];
}

/**
 * Changes current threshold value for automatic conditional
 * capture applied at device power on.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : a floating point number corresponding to current threshold value for automatic conditional
 *         capture applied at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_condValueAtStartup:(double) newval
{
    return [self setCondValueAtStartup:newval];
}
-(int) setCondValueAtStartup:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"condValueAtStartup" :rest_val];
}
/**
 * Returns the threshold value for automatic conditional
 * capture applied at device power on.
 *
 * @return a floating point number corresponding to the threshold value for automatic conditional
 *         capture applied at device power on
 *
 * On failure, throws an exception or returns YInputCapture.CONDVALUEATSTARTUP_INVALID.
 */
-(double) get_condValueAtStartup
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CONDVALUEATSTARTUP_INVALID;
        }
    }
    res = _condValueAtStartup;
    return res;
}


-(double) condValueAtStartup
{
    return [self get_condValueAtStartup];
}
/**
 * Retrieves an instant snapshot trigger for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the instant snapshot trigger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YInputCapture.isOnline() to test if the instant snapshot trigger is
 * indeed online at a given time. In case of ambiguity when looking for
 * an instant snapshot trigger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the instant snapshot trigger, for instance
 *         MyDevice.inputCapture.
 *
 * @return a YInputCapture object allowing you to drive the instant snapshot trigger.
 */
+(YInputCapture*) FindInputCapture:(NSString*)func
{
    YInputCapture* obj;
    obj = (YInputCapture*) [YFunction _FindFromCache:@"InputCapture" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YInputCapture alloc] initWith:func]);
        [YFunction _AddToCache:@"InputCapture" :func :obj];
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
-(int) registerValueCallback:(YInputCaptureValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackInputCapture = callback;
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
    if (_valueCallbackInputCapture != NULL) {
        _valueCallbackInputCapture(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Returns all details about the last automatic input capture.
 *
 * @return an YInputCaptureData object including
 *         data series and all related meta-information.
 *         On failure, throws an exception or returns an capture object.
 */
-(YInputCaptureData*) get_lastCapture
{
    NSMutableData* snapData;

    snapData = [self _download:@"snap.bin"];
    return ARC_sendAutorelease([[YInputCaptureData alloc] initWith:self :snapData]);
}

/**
 * Returns a new immediate capture of the device inputs.
 *
 * @param msDuration : duration of the capture window,
 *         in milliseconds (eg. between 20 and 1000).
 *
 * @return an YInputCaptureData object including
 *         data series for the specified duration.
 *         On failure, throws an exception or returns an capture object.
 */
-(YInputCaptureData*) get_immediateCapture:(int)msDuration
{
    NSString* snapUrl;
    NSMutableData* snapData;
    int snapStart;
    if (msDuration < 1) {
        msDuration = 20;
    }
    if (msDuration > 1000) {
        msDuration = 1000;
    }
    snapStart = ((-msDuration) / 2);
    snapUrl = [NSString stringWithFormat:@"snap.bin?t=%d&d=%d",snapStart,msDuration];

    snapData = [self _download:snapUrl];
    return ARC_sendAutorelease([[YInputCaptureData alloc] initWith:self :snapData]);
}


-(YInputCapture*)   nextInputCapture
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YInputCapture FindInputCapture:hwid];
}

+(YInputCapture *) FirstInputCapture
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"InputCapture":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YInputCapture FindInputCapture:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YInputCapture public methods implementation)

@end
//--- (generated code: YInputCapture functions)

YInputCapture *yFindInputCapture(NSString* func)
{
    return [YInputCapture FindInputCapture:func];
}

YInputCapture *yFirstInputCapture(void)
{
    return [YInputCapture FirstInputCapture];
}

//--- (end of generated code: YInputCapture functions)
