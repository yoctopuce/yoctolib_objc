/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for InputChain functions
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


#import "yocto_inputchain.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YInputChain
// Constructor is protected, use yFindInputChain factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"InputChain";
//--- (YInputChain attributes initialization)
    _expectedNodes = Y_EXPECTEDNODES_INVALID;
    _detectedNodes = Y_DETECTEDNODES_INVALID;
    _loopbackTest = Y_LOOPBACKTEST_INVALID;
    _refreshRate = Y_REFRESHRATE_INVALID;
    _bitChain1 = Y_BITCHAIN1_INVALID;
    _bitChain2 = Y_BITCHAIN2_INVALID;
    _bitChain3 = Y_BITCHAIN3_INVALID;
    _bitChain4 = Y_BITCHAIN4_INVALID;
    _bitChain5 = Y_BITCHAIN5_INVALID;
    _bitChain6 = Y_BITCHAIN6_INVALID;
    _bitChain7 = Y_BITCHAIN7_INVALID;
    _watchdogPeriod = Y_WATCHDOGPERIOD_INVALID;
    _chainDiags = Y_CHAINDIAGS_INVALID;
    _valueCallbackInputChain = NULL;
    _stateChangeCallback = NULL;
    _prevPos = 0;
    _eventPos = 0;
    _eventStamp = 0;
    _eventChains = [NSMutableArray array];
//--- (end of YInputChain attributes initialization)
    return self;
}
//--- (YInputChain yapiwrapper)
static void yInternalEventCallback(YInputChain *obj, NSString *value)
{
    [obj _internalEventHandler:value];
}
//--- (end of YInputChain yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YInputChain cleanup)
    ARC_release(_bitChain1);
    _bitChain1 = nil;
    ARC_release(_bitChain2);
    _bitChain2 = nil;
    ARC_release(_bitChain3);
    _bitChain3 = nil;
    ARC_release(_bitChain4);
    _bitChain4 = nil;
    ARC_release(_bitChain5);
    _bitChain5 = nil;
    ARC_release(_bitChain6);
    _bitChain6 = nil;
    ARC_release(_bitChain7);
    _bitChain7 = nil;
    ARC_dealloc(super);
//--- (end of YInputChain cleanup)
}
//--- (YInputChain private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "expectedNodes")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _expectedNodes =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "detectedNodes")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _detectedNodes =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "loopbackTest")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _loopbackTest =  (Y_LOOPBACKTEST_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "refreshRate")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _refreshRate =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "bitChain1")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain1);
        _bitChain1 =  [self _parseString:j];
        ARC_retain(_bitChain1);
        return 1;
    }
    if(!strcmp(j->token, "bitChain2")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain2);
        _bitChain2 =  [self _parseString:j];
        ARC_retain(_bitChain2);
        return 1;
    }
    if(!strcmp(j->token, "bitChain3")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain3);
        _bitChain3 =  [self _parseString:j];
        ARC_retain(_bitChain3);
        return 1;
    }
    if(!strcmp(j->token, "bitChain4")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain4);
        _bitChain4 =  [self _parseString:j];
        ARC_retain(_bitChain4);
        return 1;
    }
    if(!strcmp(j->token, "bitChain5")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain5);
        _bitChain5 =  [self _parseString:j];
        ARC_retain(_bitChain5);
        return 1;
    }
    if(!strcmp(j->token, "bitChain6")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain6);
        _bitChain6 =  [self _parseString:j];
        ARC_retain(_bitChain6);
        return 1;
    }
    if(!strcmp(j->token, "bitChain7")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_bitChain7);
        _bitChain7 =  [self _parseString:j];
        ARC_retain(_bitChain7);
        return 1;
    }
    if(!strcmp(j->token, "watchdogPeriod")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _watchdogPeriod =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "chainDiags")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _chainDiags =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YInputChain private methods implementation)
//--- (YInputChain public methods implementation)
/**
 * Returns the number of nodes expected in the chain.
 *
 * @return an integer corresponding to the number of nodes expected in the chain
 *
 * On failure, throws an exception or returns YInputChain.EXPECTEDNODES_INVALID.
 */
-(int) get_expectedNodes
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_EXPECTEDNODES_INVALID;
        }
    }
    res = _expectedNodes;
    return res;
}


-(int) expectedNodes
{
    return [self get_expectedNodes];
}

/**
 * Changes the number of nodes expected in the chain.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the number of nodes expected in the chain
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_expectedNodes:(int) newval
{
    return [self setExpectedNodes:newval];
}
-(int) setExpectedNodes:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"expectedNodes" :rest_val];
}
/**
 * Returns the number of nodes detected in the chain.
 *
 * @return an integer corresponding to the number of nodes detected in the chain
 *
 * On failure, throws an exception or returns YInputChain.DETECTEDNODES_INVALID.
 */
-(int) get_detectedNodes
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DETECTEDNODES_INVALID;
        }
    }
    res = _detectedNodes;
    return res;
}


-(int) detectedNodes
{
    return [self get_detectedNodes];
}
/**
 * Returns the activation state of the exhaustive chain connectivity test.
 * The connectivity test requires a cable connecting the end of the chain
 * to the loopback test connector.
 *
 * @return either YInputChain.LOOPBACKTEST_OFF or YInputChain.LOOPBACKTEST_ON, according to the
 * activation state of the exhaustive chain connectivity test
 *
 * On failure, throws an exception or returns YInputChain.LOOPBACKTEST_INVALID.
 */
-(Y_LOOPBACKTEST_enum) get_loopbackTest
{
    Y_LOOPBACKTEST_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOOPBACKTEST_INVALID;
        }
    }
    res = _loopbackTest;
    return res;
}


-(Y_LOOPBACKTEST_enum) loopbackTest
{
    return [self get_loopbackTest];
}

/**
 * Changes the activation state of the exhaustive chain connectivity test.
 * The connectivity test requires a cable connecting the end of the chain
 * to the loopback test connector.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : either YInputChain.LOOPBACKTEST_OFF or YInputChain.LOOPBACKTEST_ON, according to
 * the activation state of the exhaustive chain connectivity test
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_loopbackTest:(Y_LOOPBACKTEST_enum) newval
{
    return [self setLoopbackTest:newval];
}
-(int) setLoopbackTest:(Y_LOOPBACKTEST_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"loopbackTest" :rest_val];
}
/**
 * Returns the desired refresh rate, measured in Hz.
 * The higher the refresh rate is set, the higher the
 * communication speed on the chain will be.
 *
 * @return an integer corresponding to the desired refresh rate, measured in Hz
 *
 * On failure, throws an exception or returns YInputChain.REFRESHRATE_INVALID.
 */
-(int) get_refreshRate
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REFRESHRATE_INVALID;
        }
    }
    res = _refreshRate;
    return res;
}


-(int) refreshRate
{
    return [self get_refreshRate];
}

/**
 * Changes the desired refresh rate, measured in Hz.
 * The higher the refresh rate is set, the higher the
 * communication speed on the chain will be.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the desired refresh rate, measured in Hz
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_refreshRate:(int) newval
{
    return [self setRefreshRate:newval];
}
-(int) setRefreshRate:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"refreshRate" :rest_val];
}
/**
 * Returns the state of input 1 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 1 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN1_INVALID.
 */
-(NSString*) get_bitChain1
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN1_INVALID;
        }
    }
    res = _bitChain1;
    return res;
}


-(NSString*) bitChain1
{
    return [self get_bitChain1];
}
/**
 * Returns the state of input 2 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 2 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN2_INVALID.
 */
-(NSString*) get_bitChain2
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN2_INVALID;
        }
    }
    res = _bitChain2;
    return res;
}


-(NSString*) bitChain2
{
    return [self get_bitChain2];
}
/**
 * Returns the state of input 3 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 3 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN3_INVALID.
 */
-(NSString*) get_bitChain3
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN3_INVALID;
        }
    }
    res = _bitChain3;
    return res;
}


-(NSString*) bitChain3
{
    return [self get_bitChain3];
}
/**
 * Returns the state of input 4 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 4 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN4_INVALID.
 */
-(NSString*) get_bitChain4
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN4_INVALID;
        }
    }
    res = _bitChain4;
    return res;
}


-(NSString*) bitChain4
{
    return [self get_bitChain4];
}
/**
 * Returns the state of input 5 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 5 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN5_INVALID.
 */
-(NSString*) get_bitChain5
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN5_INVALID;
        }
    }
    res = _bitChain5;
    return res;
}


-(NSString*) bitChain5
{
    return [self get_bitChain5];
}
/**
 * Returns the state of input 6 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 6 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN6_INVALID.
 */
-(NSString*) get_bitChain6
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN6_INVALID;
        }
    }
    res = _bitChain6;
    return res;
}


-(NSString*) bitChain6
{
    return [self get_bitChain6];
}
/**
 * Returns the state of input 7 for all nodes of the input chain,
 * as a hexadecimal string. The node nearest to the controller
 * is the lowest bit of the result.
 *
 * @return a string corresponding to the state of input 7 for all nodes of the input chain,
 *         as a hexadecimal string
 *
 * On failure, throws an exception or returns YInputChain.BITCHAIN7_INVALID.
 */
-(NSString*) get_bitChain7
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BITCHAIN7_INVALID;
        }
    }
    res = _bitChain7;
    return res;
}


-(NSString*) bitChain7
{
    return [self get_bitChain7];
}
/**
 * Returns the wait time in seconds before triggering an inactivity
 * timeout error.
 *
 * @return an integer corresponding to the wait time in seconds before triggering an inactivity
 *         timeout error
 *
 * On failure, throws an exception or returns YInputChain.WATCHDOGPERIOD_INVALID.
 */
-(int) get_watchdogPeriod
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_WATCHDOGPERIOD_INVALID;
        }
    }
    res = _watchdogPeriod;
    return res;
}


-(int) watchdogPeriod
{
    return [self get_watchdogPeriod];
}

/**
 * Changes the wait time in seconds before triggering an inactivity
 * timeout error. Remember to call the saveToFlash() method
 * of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the wait time in seconds before triggering an inactivity
 *         timeout error
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_watchdogPeriod:(int) newval
{
    return [self setWatchdogPeriod:newval];
}
-(int) setWatchdogPeriod:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"watchdogPeriod" :rest_val];
}
/**
 * Returns the controller state diagnostics. Bit 0 indicates a chain length
 * error, bit 1 indicates an inactivity timeout and bit 2 indicates
 * a loopback test failure.
 *
 * @return an integer corresponding to the controller state diagnostics
 *
 * On failure, throws an exception or returns YInputChain.CHAINDIAGS_INVALID.
 */
-(int) get_chainDiags
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CHAINDIAGS_INVALID;
        }
    }
    res = _chainDiags;
    return res;
}


-(int) chainDiags
{
    return [self get_chainDiags];
}
/**
 * Retrieves a digital input chain for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the digital input chain is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YInputChain.isOnline() to test if the digital input chain is
 * indeed online at a given time. In case of ambiguity when looking for
 * a digital input chain by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the digital input chain, for instance
 *         MyDevice.inputChain.
 *
 * @return a YInputChain object allowing you to drive the digital input chain.
 */
+(YInputChain*) FindInputChain:(NSString*)func
{
    YInputChain* obj;
    obj = (YInputChain*) [YFunction _FindFromCache:@"InputChain" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YInputChain alloc] initWith:func]);
        [YFunction _AddToCache:@"InputChain" : func :obj];
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
-(int) registerValueCallback:(YInputChainValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackInputChain = callback;
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
    if (_valueCallbackInputChain != NULL) {
        _valueCallbackInputChain(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Resets the application watchdog countdown.
 * If you have setup a non-zero watchdogPeriod, you should
 * call this function on a regular basis to prevent the application
 * inactivity error to be triggered.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) resetWatchdog
{
    return [self set_watchdogPeriod:-1];
}

/**
 * Returns a string with last events observed on the digital input chain.
 * This method return only events that are still buffered in the device memory.
 *
 * @return a string with last events observed (one per line).
 *
 * On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSString*) get_lastEvents
{
    NSMutableData* content;

    content = [self _download:@"events.txt"];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
}

/**
 * Registers a callback function to be called each time that an event is detected on the
 * input chain.The callback is invoked only during the execution of
 * ySleep or yHandleEvents. This provides control over the time when
 * the callback is triggered. For good responsiveness, remember to call one of these
 * two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer.
 *         The callback function should take four arguments:
 *         the YInputChain object that emitted the event, the
 *         UTC timestamp of the event, a character string describing
 *         the type of event and a character string with the event data.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) registerStateChangeCallback:(YStateChangeCallback _Nullable)callback
{
    if (callback != NULL) {
        [self registerValueCallback:yInternalEventCallback];
    } else {
        [self registerValueCallback:(YInputChainValueCallback) nil];
    }
    // register user callback AFTER the internal pseudo-event,
    // to make sure we start with future events only
    _stateChangeCallback = callback;
    return 0;
}

-(int) _internalEventHandler:(NSString*)cbpos
{
    int newPos;
    NSString* url;
    NSMutableData* content;
    NSString* contentStr;
    NSMutableArray* eventArr = [NSMutableArray array];
    int arrLen;
    NSString* lenStr;
    int arrPos;
    NSString* eventStr;
    int eventLen;
    NSString* hexStamp;
    int typePos;
    int dataPos;
    int evtStamp;
    NSString* evtType;
    NSString* evtData;
    NSString* evtChange;
    int chainIdx;
    newPos = [cbpos intValue];
    if (newPos < _prevPos) {
        _eventPos = 0;
    }
    _prevPos = newPos;
    if (newPos < _eventPos) {
        return YAPI_SUCCESS;
    }
    if (!(_stateChangeCallback != NULL)) {
        // first simulated event, use it to initialize reference values
        _eventPos = newPos;
        [_eventChains removeAllObjects];
        [_eventChains addObject:[self get_bitChain1]];
        [_eventChains addObject:[self get_bitChain2]];
        [_eventChains addObject:[self get_bitChain3]];
        [_eventChains addObject:[self get_bitChain4]];
        [_eventChains addObject:[self get_bitChain5]];
        [_eventChains addObject:[self get_bitChain6]];
        [_eventChains addObject:[self get_bitChain7]];
        return YAPI_SUCCESS;
    }
    url = [NSString stringWithFormat:@"events.txt?pos=%d",_eventPos];

    content = [self _download:url];
    contentStr = ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
    eventArr = [NSMutableArray arrayWithArray:[contentStr componentsSeparatedByString:@"\n"]];
    arrLen = (int)[eventArr count];
    if (!(arrLen > 0)) {[self _throw: YAPI_IO_ERROR: @"fail to download events"]; return YAPI_IO_ERROR;}
    // last element of array is the new position preceeded by '@'
    arrLen = arrLen - 1;
    lenStr = [eventArr objectAtIndex:arrLen];
    lenStr = [lenStr substringWithRange:NSMakeRange( 1, (int)[(lenStr) length]-1)];
    // update processed event position pointer
    _eventPos = [lenStr intValue];
    // now generate callbacks for each event received
    arrPos = 0;
    while (arrPos < arrLen) {
        eventStr = [eventArr objectAtIndex:arrPos];
        eventLen = (int)[(eventStr) length];
        if (eventLen >= 1) {
            hexStamp = [eventStr substringWithRange:NSMakeRange( 0, 8)];
            evtStamp = (int)strtoul(STR_oc2y(hexStamp), NULL, 16);
            typePos = _ystrpos(eventStr, @":")+1;
            if ((evtStamp >= _eventStamp) && (typePos > 8)) {
                _eventStamp = evtStamp;
                dataPos = _ystrpos(eventStr, @"=")+1;
                evtType = [eventStr substringWithRange:NSMakeRange( typePos, 1)];
                evtData = @"";
                evtChange = @"";
                if (dataPos > 10) {
                    evtData = [eventStr substringWithRange:NSMakeRange( dataPos, (int)[(eventStr) length]-dataPos)];
                    if (_ystrpos(@"1234567", evtType) >= 0) {
                        chainIdx = [evtType intValue] - 1;
                        evtChange = [self _strXor:evtData :[_eventChains objectAtIndex:chainIdx]];
                        [_eventChains replaceObjectAtIndex: chainIdx withObject:evtData];
                    }
                }
                _stateChangeCallback(self, evtStamp, evtType, evtData, evtChange);
            }
        }
        arrPos = arrPos + 1;
    }
    return YAPI_SUCCESS;
}

-(NSString*) _strXor:(NSString*)a :(NSString*)b
{
    int lenA;
    int lenB;
    NSString* res;
    int idx;
    int digitA;
    int digitB;
    // make sure the result has the same length as first argument
    lenA = (int)[(a) length];
    lenB = (int)[(b) length];
    if (lenA > lenB) {
        res = [a substringWithRange:NSMakeRange( 0, lenA-lenB)];
        a = [a substringWithRange:NSMakeRange( lenA-lenB, lenB)];
        lenA = lenB;
    } else {
        res = @"";
        b = [b substringWithRange:NSMakeRange( lenA-lenB, lenA)];
    }
    // scan strings and compare digit by digit
    idx = 0;
    while (idx < lenA) {
        digitA = (int)strtoul(STR_oc2y([a substringWithRange:NSMakeRange( idx, 1)]), NULL, 16);
        digitB = (int)strtoul(STR_oc2y([b substringWithRange:NSMakeRange( idx, 1)]), NULL, 16);
        res = [NSString stringWithFormat:@"%@%x", res,((digitA) ^ (digitB))];
        idx = idx + 1;
    }
    return res;
}

-(NSMutableArray*) hex2array:(NSString*)hexstr
{
    int hexlen;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int digit;
    hexlen = (int)[(hexstr) length];
    [res removeAllObjects];
    idx = hexlen;
    while (idx > 0) {
        idx = idx - 1;
        digit = (int)strtoul(STR_oc2y([hexstr substringWithRange:NSMakeRange( idx, 1)]), NULL, 16);
        [res addObject:[NSNumber numberWithLong:((digit) & (1))]];
        [res addObject:[NSNumber numberWithLong:((((digit) >> (1))) & (1))]];
        [res addObject:[NSNumber numberWithLong:((((digit) >> (2))) & (1))]];
        [res addObject:[NSNumber numberWithLong:((((digit) >> (3))) & (1))]];
    }
    return res;
}


-(YInputChain*)   nextInputChain
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YInputChain FindInputChain:hwid];
}

+(YInputChain *) FirstInputChain
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"InputChain":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YInputChain FindInputChain:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YInputChain public methods implementation)
@end

//--- (YInputChain functions)

YInputChain *yFindInputChain(NSString* func)
{
    return [YInputChain FindInputChain:func];
}

YInputChain *yFirstInputChain(void)
{
    return [YInputChain FirstInputChain];
}

//--- (end of YInputChain functions)

