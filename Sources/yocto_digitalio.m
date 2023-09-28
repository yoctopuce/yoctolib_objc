/*********************************************************************
 *
 *  $Id: yocto_digitalio.m 56091 2023-08-16 06:32:54Z mvuilleu $
 *
 *  Implements the high-level API for DigitalIO functions
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


#import "yocto_digitalio.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YDigitalIO
// Constructor is protected, use yFindDigitalIO factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"DigitalIO";
//--- (YDigitalIO attributes initialization)
    _portState = Y_PORTSTATE_INVALID;
    _portDirection = Y_PORTDIRECTION_INVALID;
    _portOpenDrain = Y_PORTOPENDRAIN_INVALID;
    _portPolarity = Y_PORTPOLARITY_INVALID;
    _portDiags = Y_PORTDIAGS_INVALID;
    _portSize = Y_PORTSIZE_INVALID;
    _outputVoltage = Y_OUTPUTVOLTAGE_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackDigitalIO = NULL;
//--- (end of YDigitalIO attributes initialization)
    return self;
}
//--- (YDigitalIO yapiwrapper)
//--- (end of YDigitalIO yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YDigitalIO cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YDigitalIO cleanup)
}
//--- (YDigitalIO private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "portState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portState =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portDirection")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portDirection =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portOpenDrain")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portOpenDrain =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portPolarity")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portPolarity =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portDiags")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portDiags =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "portSize")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _portSize =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "outputVoltage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _outputVoltage =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YDigitalIO private methods implementation)
//--- (YDigitalIO public methods implementation)
/**
 * Returns the digital IO port state as an integer with each bit
 * representing a channel.
 * value 0 = 0b00000000 -> all channels are OFF
 * value 1 = 0b00000001 -> channel #0 is ON
 * value 2 = 0b00000010 -> channel #1 is ON
 * value 3 = 0b00000011 -> channels #0 and #1 are ON
 * value 4 = 0b00000100 -> channel #2 is ON
 * and so on...
 *
 * @return an integer corresponding to the digital IO port state as an integer with each bit
 *         representing a channel
 *
 * On failure, throws an exception or returns YDigitalIO.PORTSTATE_INVALID.
 */
-(int) get_portState
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTSTATE_INVALID;
        }
    }
    res = _portState;
    return res;
}


-(int) portState
{
    return [self get_portState];
}

/**
 * Changes the state of all digital IO port's channels at once: the parameter
 * is an integer where each bit represents a channel, with bit 0 matching channel #0.
 * To set all channels to  0 -> 0b00000000 -> parameter = 0
 * To set channel #0 to 1 -> 0b00000001 -> parameter =  1
 * To set channel #1 to  1 -> 0b00000010 -> parameter = 2
 * To set channel #0 and #1 -> 0b00000011 -> parameter =  3
 * To set channel #2 to 1 -> 0b00000100 -> parameter =  4
 * an so on....
 * Only channels configured as outputs will be affecter, according to the value
 * configured using set_portDirection.
 *
 * @param newval : an integer corresponding to the state of all digital IO port's channels at once: the parameter
 *         is an integer where each bit represents a channel, with bit 0 matching channel #0
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_portState:(int) newval
{
    return [self setPortState:newval];
}
-(int) setPortState:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"portState" :rest_val];
}
/**
 * Returns the I/O direction of all channels of the port (bitmap): 0 makes a bit an input, 1 makes it an output.
 *
 * @return an integer corresponding to the I/O direction of all channels of the port (bitmap): 0 makes
 * a bit an input, 1 makes it an output
 *
 * On failure, throws an exception or returns YDigitalIO.PORTDIRECTION_INVALID.
 */
-(int) get_portDirection
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTDIRECTION_INVALID;
        }
    }
    res = _portDirection;
    return res;
}


-(int) portDirection
{
    return [self get_portDirection];
}

/**
 * Changes the I/O direction of all channels of the port (bitmap): 0 makes a bit an input, 1 makes it an output.
 * Remember to call the saveToFlash() method  to make sure the setting is kept after a reboot.
 *
 * @param newval : an integer corresponding to the I/O direction of all channels of the port (bitmap):
 * 0 makes a bit an input, 1 makes it an output
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_portDirection:(int) newval
{
    return [self setPortDirection:newval];
}
-(int) setPortDirection:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"portDirection" :rest_val];
}
/**
 * Returns the electrical interface for each bit of the port. For each bit set to 0  the matching I/O
 * works in the regular,
 * intuitive way, for each bit set to 1, the I/O works in reverse mode.
 *
 * @return an integer corresponding to the electrical interface for each bit of the port
 *
 * On failure, throws an exception or returns YDigitalIO.PORTOPENDRAIN_INVALID.
 */
-(int) get_portOpenDrain
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTOPENDRAIN_INVALID;
        }
    }
    res = _portOpenDrain;
    return res;
}


-(int) portOpenDrain
{
    return [self get_portOpenDrain];
}

/**
 * Changes the electrical interface for each bit of the port. 0 makes a bit a regular input/output, 1 makes
 * it an open-drain (open-collector) input/output. Remember to call the
 * saveToFlash() method  to make sure the setting is kept after a reboot.
 *
 * @param newval : an integer corresponding to the electrical interface for each bit of the port
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_portOpenDrain:(int) newval
{
    return [self setPortOpenDrain:newval];
}
-(int) setPortOpenDrain:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"portOpenDrain" :rest_val];
}
/**
 * Returns the polarity of all the bits of the port.  For each bit set to 0, the matching I/O works the regular,
 * intuitive way; for each bit set to 1, the I/O works in reverse mode.
 *
 * @return an integer corresponding to the polarity of all the bits of the port
 *
 * On failure, throws an exception or returns YDigitalIO.PORTPOLARITY_INVALID.
 */
-(int) get_portPolarity
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTPOLARITY_INVALID;
        }
    }
    res = _portPolarity;
    return res;
}


-(int) portPolarity
{
    return [self get_portPolarity];
}

/**
 * Changes the polarity of all the bits of the port: For each bit set to 0, the matching I/O works the regular,
 * intuitive way; for each bit set to 1, the I/O works in reverse mode.
 * Remember to call the saveToFlash() method  to make sure the setting will be kept after a reboot.
 *
 * @param newval : an integer corresponding to the polarity of all the bits of the port: For each bit
 * set to 0, the matching I/O works the regular,
 *         intuitive way; for each bit set to 1, the I/O works in reverse mode
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_portPolarity:(int) newval
{
    return [self setPortPolarity:newval];
}
-(int) setPortPolarity:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"portPolarity" :rest_val];
}
/**
 * Returns the port state diagnostics (Yocto-IO and Yocto-MaxiIO-V2 only). Bit 0 indicates a shortcut on
 * output 0, etc. Bit 8 indicates a power failure, and bit 9 signals overheating (overcurrent).
 * During normal use, all diagnostic bits should stay clear.
 *
 * @return an integer corresponding to the port state diagnostics (Yocto-IO and Yocto-MaxiIO-V2 only)
 *
 * On failure, throws an exception or returns YDigitalIO.PORTDIAGS_INVALID.
 */
-(int) get_portDiags
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTDIAGS_INVALID;
        }
    }
    res = _portDiags;
    return res;
}


-(int) portDiags
{
    return [self get_portDiags];
}
/**
 * Returns the number of bits (i.e. channels)implemented in the I/O port.
 *
 * @return an integer corresponding to the number of bits (i.e
 *
 * On failure, throws an exception or returns YDigitalIO.PORTSIZE_INVALID.
 */
-(int) get_portSize
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PORTSIZE_INVALID;
        }
    }
    res = _portSize;
    return res;
}


-(int) portSize
{
    return [self get_portSize];
}
/**
 * Returns the voltage source used to drive output bits.
 *
 * @return a value among YDigitalIO.OUTPUTVOLTAGE_USB_5V, YDigitalIO.OUTPUTVOLTAGE_USB_3V and
 * YDigitalIO.OUTPUTVOLTAGE_EXT_V corresponding to the voltage source used to drive output bits
 *
 * On failure, throws an exception or returns YDigitalIO.OUTPUTVOLTAGE_INVALID.
 */
-(Y_OUTPUTVOLTAGE_enum) get_outputVoltage
{
    Y_OUTPUTVOLTAGE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_OUTPUTVOLTAGE_INVALID;
        }
    }
    res = _outputVoltage;
    return res;
}


-(Y_OUTPUTVOLTAGE_enum) outputVoltage
{
    return [self get_outputVoltage];
}

/**
 * Changes the voltage source used to drive output bits.
 * Remember to call the saveToFlash() method  to make sure the setting is kept after a reboot.
 *
 * @param newval : a value among YDigitalIO.OUTPUTVOLTAGE_USB_5V, YDigitalIO.OUTPUTVOLTAGE_USB_3V and
 * YDigitalIO.OUTPUTVOLTAGE_EXT_V corresponding to the voltage source used to drive output bits
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_outputVoltage:(Y_OUTPUTVOLTAGE_enum) newval
{
    return [self setOutputVoltage:newval];
}
-(int) setOutputVoltage:(Y_OUTPUTVOLTAGE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"outputVoltage" :rest_val];
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
 * Retrieves a digital IO port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the digital IO port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDigitalIO.isOnline() to test if the digital IO port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a digital IO port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the digital IO port, for instance
 *         YMINIIO0.digitalIO.
 *
 * @return a YDigitalIO object allowing you to drive the digital IO port.
 */
+(YDigitalIO*) FindDigitalIO:(NSString*)func
{
    YDigitalIO* obj;
    obj = (YDigitalIO*) [YFunction _FindFromCache:@"DigitalIO" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDigitalIO alloc] initWith:func]);
        [YFunction _AddToCache:@"DigitalIO" : func :obj];
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
-(int) registerValueCallback:(YDigitalIOValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDigitalIO = callback;
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
    if (_valueCallbackDigitalIO != NULL) {
        _valueCallbackDigitalIO(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Sets a single bit (i.e. channel) of the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 * @param bitstate : the state of the bit (1 or 0)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bitState:(int)bitno :(int)bitstate
{
    if (!(bitstate >= 0)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid bit state"]; return YAPI_INVALID_ARGUMENT;}
    if (!(bitstate <= 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid bit state"]; return YAPI_INVALID_ARGUMENT;}
    return [self set_command:[NSString stringWithFormat:@"%c%d",82+bitstate,bitno]];
}

/**
 * Returns the state of a single bit (i.e. channel)  of the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return the bit state (0 or 1)
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_bitState:(int)bitno
{
    int portVal;
    portVal = [self get_portState];
    return ((((portVal) >> (bitno))) & (1));
}

/**
 * Reverts a single bit (i.e. channel) of the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) toggle_bitState:(int)bitno
{
    return [self set_command:[NSString stringWithFormat:@"T%d",bitno]];
}

/**
 * Changes  the direction of a single bit (i.e. channel) from the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 * @param bitdirection : direction to set, 0 makes the bit an input, 1 makes it an output.
 *         Remember to call the   saveToFlash() method to make sure the setting is kept after a reboot.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bitDirection:(int)bitno :(int)bitdirection
{
    if (!(bitdirection >= 0)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid direction"]; return YAPI_INVALID_ARGUMENT;}
    if (!(bitdirection <= 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid direction"]; return YAPI_INVALID_ARGUMENT;}
    return [self set_command:[NSString stringWithFormat:@"%c%d",73+6*bitdirection,bitno]];
}

/**
 * Returns the direction of a single bit (i.e. channel) from the I/O port (0 means the bit is an
 * input, 1  an output).
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_bitDirection:(int)bitno
{
    int portDir;
    portDir = [self get_portDirection];
    return ((((portDir) >> (bitno))) & (1));
}

/**
 * Changes the polarity of a single bit from the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0.
 * @param bitpolarity : polarity to set, 0 makes the I/O work in regular mode, 1 makes the I/O  works
 * in reverse mode.
 *         Remember to call the   saveToFlash() method to make sure the setting is kept after a reboot.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bitPolarity:(int)bitno :(int)bitpolarity
{
    if (!(bitpolarity >= 0)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid bit polarity"]; return YAPI_INVALID_ARGUMENT;}
    if (!(bitpolarity <= 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid bit polarity"]; return YAPI_INVALID_ARGUMENT;}
    return [self set_command:[NSString stringWithFormat:@"%c%d",110+4*bitpolarity,bitno]];
}

/**
 * Returns the polarity of a single bit from the I/O port (0 means the I/O works in regular mode, 1
 * means the I/O  works in reverse mode).
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_bitPolarity:(int)bitno
{
    int portPol;
    portPol = [self get_portPolarity];
    return ((((portPol) >> (bitno))) & (1));
}

/**
 * Changes  the electrical interface of a single bit from the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 * @param opendrain : 0 makes a bit a regular input/output, 1 makes
 *         it an open-drain (open-collector) input/output. Remember to call the
 *         saveToFlash() method to make sure the setting is kept after a reboot.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_bitOpenDrain:(int)bitno :(int)opendrain
{
    if (!(opendrain >= 0)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid state"]; return YAPI_INVALID_ARGUMENT;}
    if (!(opendrain <= 1)) {[self _throw: YAPI_INVALID_ARGUMENT: @"invalid state"]; return YAPI_INVALID_ARGUMENT;}
    return [self set_command:[NSString stringWithFormat:@"%c%d",100-32*opendrain,bitno]];
}

/**
 * Returns the type of electrical interface of a single bit from the I/O port. (0 means the bit is an
 * input, 1  an output).
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return   0 means the a bit is a regular input/output, 1 means the bit is an open-drain
 *         (open-collector) input/output.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_bitOpenDrain:(int)bitno
{
    int portOpenDrain;
    portOpenDrain = [self get_portOpenDrain];
    return ((((portOpenDrain) >> (bitno))) & (1));
}

/**
 * Triggers a pulse on a single bit for a specified duration. The specified bit
 * will be turned to 1, and then back to 0 after the given duration.
 *
 * @param bitno : the bit number; lowest bit has index 0
 * @param ms_duration : desired pulse duration in milliseconds. Be aware that the device time
 *         resolution is not guaranteed up to the millisecond.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) pulse:(int)bitno :(int)ms_duration
{
    return [self set_command:[NSString stringWithFormat:@"Z%d,0,%d", bitno,ms_duration]];
}

/**
 * Schedules a pulse on a single bit for a specified duration. The specified bit
 * will be turned to 1, and then back to 0 after the given duration.
 *
 * @param bitno : the bit number; lowest bit has index 0
 * @param ms_delay : waiting time before the pulse, in milliseconds
 * @param ms_duration : desired pulse duration in milliseconds. Be aware that the device time
 *         resolution is not guaranteed up to the millisecond.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) delayedPulse:(int)bitno :(int)ms_delay :(int)ms_duration
{
    return [self set_command:[NSString stringWithFormat:@"Z%d,%d,%d",bitno,ms_delay,ms_duration]];
}


-(YDigitalIO*)   nextDigitalIO
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDigitalIO FindDigitalIO:hwid];
}

+(YDigitalIO *) FirstDigitalIO
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"DigitalIO":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDigitalIO FindDigitalIO:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YDigitalIO public methods implementation)
@end

//--- (YDigitalIO functions)

YDigitalIO *yFindDigitalIO(NSString* func)
{
    return [YDigitalIO FindDigitalIO:func];
}

YDigitalIO *yFirstDigitalIO(void)
{
    return [YDigitalIO FirstDigitalIO];
}

//--- (end of YDigitalIO functions)

