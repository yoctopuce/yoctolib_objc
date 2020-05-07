/*********************************************************************
 *
 *  $Id: yocto_spiport.m 40298 2020-05-05 08:37:49Z seb $
 *
 *  Implements the high-level API for SpiPort functions
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


#import "yocto_spiport.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YSpiPort

// Constructor is protected, use yFindSpiPort factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"SpiPort";
//--- (YSpiPort attributes initialization)
    _rxCount = Y_RXCOUNT_INVALID;
    _txCount = Y_TXCOUNT_INVALID;
    _errCount = Y_ERRCOUNT_INVALID;
    _rxMsgCount = Y_RXMSGCOUNT_INVALID;
    _txMsgCount = Y_TXMSGCOUNT_INVALID;
    _lastMsg = Y_LASTMSG_INVALID;
    _currentJob = Y_CURRENTJOB_INVALID;
    _startupJob = Y_STARTUPJOB_INVALID;
    _jobMaxTask = Y_JOBMAXTASK_INVALID;
    _jobMaxSize = Y_JOBMAXSIZE_INVALID;
    _command = Y_COMMAND_INVALID;
    _protocol = Y_PROTOCOL_INVALID;
    _voltageLevel = Y_VOLTAGELEVEL_INVALID;
    _spiMode = Y_SPIMODE_INVALID;
    _ssPolarity = Y_SSPOLARITY_INVALID;
    _shiftSampling = Y_SHIFTSAMPLING_INVALID;
    _valueCallbackSpiPort = NULL;
    _rxptr = 0;
    _rxbuffptr = 0;
//--- (end of YSpiPort attributes initialization)
    return self;
}
//--- (YSpiPort yapiwrapper)
//--- (end of YSpiPort yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YSpiPort cleanup)
    ARC_release(_lastMsg);
    _lastMsg = nil;
    ARC_release(_currentJob);
    _currentJob = nil;
    ARC_release(_startupJob);
    _startupJob = nil;
    ARC_release(_command);
    _command = nil;
    ARC_release(_protocol);
    _protocol = nil;
    ARC_release(_spiMode);
    _spiMode = nil;
    ARC_dealloc(super);
//--- (end of YSpiPort cleanup)
}
//--- (YSpiPort private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "rxCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rxCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "txCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _txCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "errCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _errCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rxMsgCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rxMsgCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "txMsgCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _txMsgCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastMsg")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_lastMsg);
        _lastMsg =  [self _parseString:j];
        ARC_retain(_lastMsg);
        return 1;
    }
    if(!strcmp(j->token, "currentJob")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_currentJob);
        _currentJob =  [self _parseString:j];
        ARC_retain(_currentJob);
        return 1;
    }
    if(!strcmp(j->token, "startupJob")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_startupJob);
        _startupJob =  [self _parseString:j];
        ARC_retain(_startupJob);
        return 1;
    }
    if(!strcmp(j->token, "jobMaxTask")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _jobMaxTask =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "jobMaxSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _jobMaxSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    if(!strcmp(j->token, "protocol")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_protocol);
        _protocol =  [self _parseString:j];
        ARC_retain(_protocol);
        return 1;
    }
    if(!strcmp(j->token, "voltageLevel")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _voltageLevel =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "spiMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_spiMode);
        _spiMode =  [self _parseString:j];
        ARC_retain(_spiMode);
        return 1;
    }
    if(!strcmp(j->token, "ssPolarity")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _ssPolarity =  (Y_SSPOLARITY_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "shiftSampling")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _shiftSampling =  (Y_SHIFTSAMPLING_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YSpiPort private methods implementation)
//--- (YSpiPort public methods implementation)
/**
 * Returns the total number of bytes received since last reset.
 *
 * @return an integer corresponding to the total number of bytes received since last reset
 *
 * On failure, throws an exception or returns Y_RXCOUNT_INVALID.
 */
-(int) get_rxCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXCOUNT_INVALID;
        }
    }
    res = _rxCount;
    return res;
}


-(int) rxCount
{
    return [self get_rxCount];
}
/**
 * Returns the total number of bytes transmitted since last reset.
 *
 * @return an integer corresponding to the total number of bytes transmitted since last reset
 *
 * On failure, throws an exception or returns Y_TXCOUNT_INVALID.
 */
-(int) get_txCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXCOUNT_INVALID;
        }
    }
    res = _txCount;
    return res;
}


-(int) txCount
{
    return [self get_txCount];
}
/**
 * Returns the total number of communication errors detected since last reset.
 *
 * @return an integer corresponding to the total number of communication errors detected since last reset
 *
 * On failure, throws an exception or returns Y_ERRCOUNT_INVALID.
 */
-(int) get_errCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ERRCOUNT_INVALID;
        }
    }
    res = _errCount;
    return res;
}


-(int) errCount
{
    return [self get_errCount];
}
/**
 * Returns the total number of messages received since last reset.
 *
 * @return an integer corresponding to the total number of messages received since last reset
 *
 * On failure, throws an exception or returns Y_RXMSGCOUNT_INVALID.
 */
-(int) get_rxMsgCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RXMSGCOUNT_INVALID;
        }
    }
    res = _rxMsgCount;
    return res;
}


-(int) rxMsgCount
{
    return [self get_rxMsgCount];
}
/**
 * Returns the total number of messages send since last reset.
 *
 * @return an integer corresponding to the total number of messages send since last reset
 *
 * On failure, throws an exception or returns Y_TXMSGCOUNT_INVALID.
 */
-(int) get_txMsgCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TXMSGCOUNT_INVALID;
        }
    }
    res = _txMsgCount;
    return res;
}


-(int) txMsgCount
{
    return [self get_txMsgCount];
}
/**
 * Returns the latest message fully received (for Line and Frame protocols).
 *
 * @return a string corresponding to the latest message fully received (for Line and Frame protocols)
 *
 * On failure, throws an exception or returns Y_LASTMSG_INVALID.
 */
-(NSString*) get_lastMsg
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTMSG_INVALID;
        }
    }
    res = _lastMsg;
    return res;
}


-(NSString*) lastMsg
{
    return [self get_lastMsg];
}
/**
 * Returns the name of the job file currently in use.
 *
 * @return a string corresponding to the name of the job file currently in use
 *
 * On failure, throws an exception or returns Y_CURRENTJOB_INVALID.
 */
-(NSString*) get_currentJob
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTJOB_INVALID;
        }
    }
    res = _currentJob;
    return res;
}


-(NSString*) currentJob
{
    return [self get_currentJob];
}

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
-(int) set_currentJob:(NSString*) newval
{
    return [self setCurrentJob:newval];
}
-(int) setCurrentJob:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"currentJob" :rest_val];
}
/**
 * Returns the job file to use when the device is powered on.
 *
 * @return a string corresponding to the job file to use when the device is powered on
 *
 * On failure, throws an exception or returns Y_STARTUPJOB_INVALID.
 */
-(NSString*) get_startupJob
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_STARTUPJOB_INVALID;
        }
    }
    res = _startupJob;
    return res;
}


-(NSString*) startupJob
{
    return [self get_startupJob];
}

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
-(int) set_startupJob:(NSString*) newval
{
    return [self setStartupJob:newval];
}
-(int) setStartupJob:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"startupJob" :rest_val];
}
/**
 * Returns the maximum number of tasks in a job that the device can handle.
 *
 * @return an integer corresponding to the maximum number of tasks in a job that the device can handle
 *
 * On failure, throws an exception or returns Y_JOBMAXTASK_INVALID.
 */
-(int) get_jobMaxTask
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_JOBMAXTASK_INVALID;
        }
    }
    res = _jobMaxTask;
    return res;
}


-(int) jobMaxTask
{
    return [self get_jobMaxTask];
}
/**
 * Returns maximum size allowed for job files.
 *
 * @return an integer corresponding to maximum size allowed for job files
 *
 * On failure, throws an exception or returns Y_JOBMAXSIZE_INVALID.
 */
-(int) get_jobMaxSize
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_JOBMAXSIZE_INVALID;
        }
    }
    res = _jobMaxSize;
    return res;
}


-(int) jobMaxSize
{
    return [self get_jobMaxSize];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
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
-(NSString*) get_protocol
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PROTOCOL_INVALID;
        }
    }
    res = _protocol;
    return res;
}


-(NSString*) protocol
{
    return [self get_protocol];
}

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
-(int) set_protocol:(NSString*) newval
{
    return [self setProtocol:newval];
}
-(int) setProtocol:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"protocol" :rest_val];
}
/**
 * Returns the voltage level used on the serial line.
 *
 * @return a value among Y_VOLTAGELEVEL_OFF, Y_VOLTAGELEVEL_TTL3V, Y_VOLTAGELEVEL_TTL3VR,
 * Y_VOLTAGELEVEL_TTL5V, Y_VOLTAGELEVEL_TTL5VR, Y_VOLTAGELEVEL_RS232, Y_VOLTAGELEVEL_RS485 and
 * Y_VOLTAGELEVEL_TTL1V8 corresponding to the voltage level used on the serial line
 *
 * On failure, throws an exception or returns Y_VOLTAGELEVEL_INVALID.
 */
-(Y_VOLTAGELEVEL_enum) get_voltageLevel
{
    Y_VOLTAGELEVEL_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_VOLTAGELEVEL_INVALID;
        }
    }
    res = _voltageLevel;
    return res;
}


-(Y_VOLTAGELEVEL_enum) voltageLevel
{
    return [self get_voltageLevel];
}

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
-(int) set_voltageLevel:(Y_VOLTAGELEVEL_enum) newval
{
    return [self setVoltageLevel:newval];
}
-(int) setVoltageLevel:(Y_VOLTAGELEVEL_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"voltageLevel" :rest_val];
}
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
-(NSString*) get_spiMode
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SPIMODE_INVALID;
        }
    }
    res = _spiMode;
    return res;
}


-(NSString*) spiMode
{
    return [self get_spiMode];
}

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
-(int) set_spiMode:(NSString*) newval
{
    return [self setSpiMode:newval];
}
-(int) setSpiMode:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"spiMode" :rest_val];
}
/**
 * Returns the SS line polarity.
 *
 * @return either Y_SSPOLARITY_ACTIVE_LOW or Y_SSPOLARITY_ACTIVE_HIGH, according to the SS line polarity
 *
 * On failure, throws an exception or returns Y_SSPOLARITY_INVALID.
 */
-(Y_SSPOLARITY_enum) get_ssPolarity
{
    Y_SSPOLARITY_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SSPOLARITY_INVALID;
        }
    }
    res = _ssPolarity;
    return res;
}


-(Y_SSPOLARITY_enum) ssPolarity
{
    return [self get_ssPolarity];
}

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
-(int) set_ssPolarity:(Y_SSPOLARITY_enum) newval
{
    return [self setSsPolarity:newval];
}
-(int) setSsPolarity:(Y_SSPOLARITY_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"ssPolarity" :rest_val];
}
/**
 * Returns true when the SDI line phase is shifted with regards to the SDO line.
 *
 * @return either Y_SHIFTSAMPLING_OFF or Y_SHIFTSAMPLING_ON, according to true when the SDI line phase
 * is shifted with regards to the SDO line
 *
 * On failure, throws an exception or returns Y_SHIFTSAMPLING_INVALID.
 */
-(Y_SHIFTSAMPLING_enum) get_shiftSampling
{
    Y_SHIFTSAMPLING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SHIFTSAMPLING_INVALID;
        }
    }
    res = _shiftSampling;
    return res;
}


-(Y_SHIFTSAMPLING_enum) shiftSampling
{
    return [self get_shiftSampling];
}

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
-(int) set_shiftSampling:(Y_SHIFTSAMPLING_enum) newval
{
    return [self setShiftSampling:newval];
}
-(int) setShiftSampling:(Y_SHIFTSAMPLING_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"shiftSampling" :rest_val];
}
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
 * @param func : a string that uniquely characterizes the SPI port, for instance
 *         YSPIMK01.spiPort.
 *
 * @return a YSpiPort object allowing you to drive the SPI port.
 */
+(YSpiPort*) FindSpiPort:(NSString*)func
{
    YSpiPort* obj;
    obj = (YSpiPort*) [YFunction _FindFromCache:@"SpiPort" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSpiPort alloc] initWith:func]);
        [YFunction _AddToCache:@"SpiPort" : func :obj];
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
-(int) registerValueCallback:(YSpiPortValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSpiPort = callback;
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
    if (_valueCallbackSpiPort != NULL) {
        _valueCallbackSpiPort(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) sendCommand:(NSString*)text
{
    return [self set_command:text];
}

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
-(NSString*) readLine
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;

    url = [NSString stringWithFormat:@"rxmsg.json?pos=%d&len=1&maxw=1",_rxptr];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return @"";
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    if (msglen == 0) {
        return @"";
    }
    res = [self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return res;
}

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
-(NSMutableArray*) readMessages:(NSString*)pattern :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSMutableArray* res = [NSMutableArray array];
    int idx;

    url = [NSString stringWithFormat:@"rxmsg.json?pos=%d&maxw=%d&pat=%@", _rxptr, maxWait,pattern];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return res;
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    idx = 0;
    while (idx < msglen) {
        [res addObject:[self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:idx] dataUsingEncoding:NSISOLatin1StringEncoding]]]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Changes the current internal stream position to the specified value. This function
 * does not affect the device, it only changes the value stored in the API object
 * for the next read operations.
 *
 * @param absPos : the absolute position index for next read operations.
 *
 * @return nothing.
 */
-(int) read_seek:(int)absPos
{
    _rxptr = absPos;
    return YAPI_SUCCESS;
}

/**
 * Returns the current absolute stream position pointer of the API object.
 *
 * @return the absolute position index for next read operations.
 */
-(int) read_tell
{
    return _rxptr;
}

/**
 * Returns the number of bytes available to read in the input buffer starting from the
 * current absolute stream position pointer of the API object.
 *
 * @return the number of bytes available to read
 */
-(int) read_avail
{
    NSMutableData* buff;
    int bufflen;
    int res;

    buff = [self _download:[NSString stringWithFormat:@"rxcnt.bin?pos=%d",_rxptr]];
    bufflen = (int)[buff length] - 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        bufflen = bufflen - 1;
    }
    res = [[ARC_sendAutorelease([[NSString alloc] initWithData:buff encoding:NSISOLatin1StringEncoding]) substringWithRange:NSMakeRange( 0, bufflen)] intValue];
    return res;
}

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
-(NSString*) queryLine:(NSString*)query :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;

    url = [NSString stringWithFormat:@"rxmsg.json?len=1&maxw=%d&cmd=!%@", maxWait,[self _escapeAttr:query]];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return @"";
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    if (msglen == 0) {
        return @"";
    }
    res = [self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return res;
}

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
-(NSString*) queryHex:(NSString*)hexString :(int)maxWait
{
    NSString* url;
    NSMutableData* msgbin;
    NSMutableArray* msgarr = [NSMutableArray array];
    int msglen;
    NSString* res;

    url = [NSString stringWithFormat:@"rxmsg.json?len=1&maxw=%d&cmd=$%@", maxWait,hexString];
    msgbin = [self _download:url];
    msgarr = [self _json_get_array:msgbin];
    msglen = (int)[msgarr count];
    if (msglen == 0) {
        return @"";
    }
    // last element of array is the new position
    msglen = msglen - 1;
    _rxptr = [[msgarr objectAtIndex:msglen] intValue];
    if (msglen == 0) {
        return @"";
    }
    res = [self _json_get_string:[NSMutableData dataWithData:[[msgarr objectAtIndex:0] dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return res;
}

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
-(int) uploadJob:(NSString*)jobfile :(NSString*)jsonDef
{
    [self _upload:jobfile :[NSMutableData dataWithData:[jsonDef dataUsingEncoding:NSISOLatin1StringEncoding]]];
    return YAPI_SUCCESS;
}

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
-(int) selectJob:(NSString*)jobfile
{
    return [self set_currentJob:jobfile];
}

/**
 * Clears the serial port buffer and resets counters to zero.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reset
{
    _rxptr = 0;
    _rxbuffptr = 0;
    _rxbuff = [NSMutableData dataWithLength:0];

    return [self sendCommand:@"Z"];
}

/**
 * Sends a single byte to the serial port.
 *
 * @param code : the byte to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeByte:(int)code
{
    return [self sendCommand:[NSString stringWithFormat:@"$%02X",code]];
}

/**
 * Sends an ASCII string to the serial port, as is.
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeStr:(NSString*)text
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int ch;
    buff = [NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]];
    bufflen = (int)[buff length];
    if (bufflen < 100) {
        // if string is pure text, we can send it as a simple command (faster)
        ch = 0x20;
        idx = 0;
        while ((idx < bufflen) && (ch != 0)) {
            ch = (((u8*)([buff bytes]))[idx]);
            if ((ch >= 0x20) && (ch < 0x7f)) {
                idx = idx + 1;
            } else {
                ch = 0;
            }
        }
        if (idx >= bufflen) {
            return [self sendCommand:[NSString stringWithFormat:@"+%@",text]];
        }
    }
    // send string using file upload
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a binary buffer to the serial port, as is.
 *
 * @param buff : the binary buffer to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeBin:(NSData*)buff
{
    return [self _upload:@"txdata" :buff];
}

/**
 * Sends a byte sequence (provided as a list of bytes) to the serial port.
 *
 * @param byteList : a list of byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeArray:(NSMutableArray*)byteList
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int hexb;
    int res;
    bufflen = (int)[byteList count];
    buff = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        hexb = [[byteList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ idx]) = hexb;
        idx = idx + 1;
    }

    res = [self _upload:@"txdata" :buff];
    return res;
}

/**
 * Sends a byte sequence (provided as a hexadecimal string) to the serial port.
 *
 * @param hexString : a string of hexadecimal byte codes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeHex:(NSString*)hexString
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int hexb;
    int res;
    bufflen = (int)[(hexString) length];
    if (bufflen < 100) {
        return [self sendCommand:[NSString stringWithFormat:@"$%@",hexString]];
    }
    bufflen = ((bufflen) >> (1));
    buff = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        hexb = (int)strtoul(STR_oc2y([hexString substringWithRange:NSMakeRange( 2 * idx, 2)]), NULL, 16);
        (((u8*)([buff mutableBytes]))[ idx]) = hexb;
        idx = idx + 1;
    }

    res = [self _upload:@"txdata" :buff];
    return res;
}

/**
 * Sends an ASCII string to the serial port, followed by a line break (CR LF).
 *
 * @param text : the text string to send
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) writeLine:(NSString*)text
{
    NSMutableData* buff;
    int bufflen;
    int idx;
    int ch;
    buff = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@\r\n",text] dataUsingEncoding:NSISOLatin1StringEncoding]];
    bufflen = (int)[buff length]-2;
    if (bufflen < 100) {
        // if string is pure text, we can send it as a simple command (faster)
        ch = 0x20;
        idx = 0;
        while ((idx < bufflen) && (ch != 0)) {
            ch = (((u8*)([buff bytes]))[idx]);
            if ((ch >= 0x20) && (ch < 0x7f)) {
                idx = idx + 1;
            } else {
                ch = 0;
            }
        }
        if (idx >= bufflen) {
            return [self sendCommand:[NSString stringWithFormat:@"!%@",text]];
        }
    }
    // send string using file upload
    return [self _upload:@"txdata" :buff];
}

/**
 * Reads one byte from the receive buffer, starting at current stream position.
 * If data at current stream position is not available anymore in the receive buffer,
 * or if there is no data available yet, the function returns YAPI_NO_MORE_DATA.
 *
 * @return the next byte
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) readByte
{
    int currpos;
    int reqlen;
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int res;
    // first check if we have the requested character in the look-ahead buffer
    bufflen = (int)[_rxbuff length];
    if ((_rxptr >= _rxbuffptr) && (_rxptr < _rxbuffptr+bufflen)) {
        res = (((u8*)([_rxbuff bytes]))[_rxptr-_rxbuffptr]);
        _rxptr = _rxptr + 1;
        return res;
    }
    // try to preload more than one byte to speed-up byte-per-byte access
    currpos = _rxptr;
    reqlen = 1024;
    buff = [self readBin:reqlen];
    bufflen = (int)[buff length];
    if (_rxptr == currpos+bufflen) {
        res = (((u8*)([buff bytes]))[0]);
        _rxptr = currpos+1;
        _rxbuffptr = currpos;
        _rxbuff = buff;
        return res;
    }
    // mixed bidirectional data, retry with a smaller block
    _rxptr = currpos;
    reqlen = 16;
    buff = [self readBin:reqlen];
    bufflen = (int)[buff length];
    if (_rxptr == currpos+bufflen) {
        res = (((u8*)([buff bytes]))[0]);
        _rxptr = currpos+1;
        _rxbuffptr = currpos;
        _rxbuff = buff;
        return res;
    }
    // still mixed, need to process character by character
    _rxptr = currpos;

    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=1",_rxptr]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    if (bufflen == 0) {
        return YAPI_NO_MORE_DATA;
    }
    res = (((u8*)([buff bytes]))[0]);
    return res;
}

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
-(NSString*) readStr:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    NSString* res;
    if (nChars > 65535) {
        nChars = 65535;
    }

    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = [ARC_sendAutorelease([[NSString alloc] initWithData:buff encoding:NSISOLatin1StringEncoding]) substringWithRange:NSMakeRange( 0, bufflen)];
    return res;
}

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
-(NSMutableData*) readBin:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int idx;
    NSMutableData* res;
    if (nChars > 65535) {
        nChars = 65535;
    }

    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        (((u8*)([res mutableBytes]))[ idx]) = (((u8*)([buff bytes]))[idx]);
        idx = idx + 1;
    }
    return res;
}

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
-(NSMutableArray*) readArray:(int)nChars
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int idx;
    int b;
    NSMutableArray* res = [NSMutableArray array];
    if (nChars > 65535) {
        nChars = 65535;
    }

    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nChars]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    [res removeAllObjects];
    idx = 0;
    while (idx < bufflen) {
        b = (((u8*)([buff bytes]))[idx]);
        [res addObject:[NSNumber numberWithLong:b]];
        idx = idx + 1;
    }
    return res;
}

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
-(NSString*) readHex:(int)nBytes
{
    NSMutableData* buff;
    int bufflen;
    int mult;
    int endpos;
    int ofs;
    NSString* res;
    if (nBytes > 65535) {
        nBytes = 65535;
    }

    buff = [self _download:[NSString stringWithFormat:@"rxdata.bin?pos=%d&len=%d", _rxptr,nBytes]];
    bufflen = (int)[buff length] - 1;
    endpos = 0;
    mult = 1;
    while ((bufflen > 0) && ((((u8*)([buff bytes]))[bufflen]) != 64)) {
        endpos = endpos + mult * ((((u8*)([buff bytes]))[bufflen]) - 48);
        mult = mult * 10;
        bufflen = bufflen - 1;
    }
    _rxptr = endpos;
    res = @"";
    ofs = 0;
    while (ofs + 3 < bufflen) {
        res = [NSString stringWithFormat:@"%@%02X%02X%02X%02X", res, (((u8*)([buff bytes]))[ofs]), (((u8*)([buff bytes]))[ofs + 1]), (((u8*)([buff bytes]))[ofs + 2]),(((u8*)([buff bytes]))[ofs + 3])];
        ofs = ofs + 4;
    }
    while (ofs < bufflen) {
        res = [NSString stringWithFormat:@"%@%02X", res,(((u8*)([buff bytes]))[ofs])];
        ofs = ofs + 1;
    }
    return res;
}

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
-(int) set_SS:(int)val
{
    return [self sendCommand:[NSString stringWithFormat:@"S%d",val]];
}


-(YSpiPort*)   nextSpiPort
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSpiPort FindSpiPort:hwid];
}

+(YSpiPort *) FirstSpiPort
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"SpiPort":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSpiPort FindSpiPort:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YSpiPort public methods implementation)

@end
//--- (YSpiPort functions)

YSpiPort *yFindSpiPort(NSString* func)
{
    return [YSpiPort FindSpiPort:func];
}

YSpiPort *yFirstSpiPort(void)
{
    return [YSpiPort FirstSpiPort];
}

//--- (end of YSpiPort functions)
