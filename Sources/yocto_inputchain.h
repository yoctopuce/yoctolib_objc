/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindInputChain(), the high-level API for InputChain functions
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

@class YInputChain;

//--- (YInputChain globals)
typedef void (*YInputChainValueCallback)(YInputChain *func, NSString *functionValue);
typedef void (*YEventCallback)(YInputChain *inputChain, int timestamp, NSString *eventType, NSString *eventData, NSString *eventChange);
#define Y_EXPECTEDNODES_INVALID         YAPI_INVALID_UINT
#define Y_DETECTEDNODES_INVALID         YAPI_INVALID_UINT
#define Y_REFRESHRATE_INVALID           YAPI_INVALID_UINT
#define Y_BITCHAIN1_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN2_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN3_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN4_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN5_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN6_INVALID             YAPI_INVALID_STRING
#define Y_BITCHAIN7_INVALID             YAPI_INVALID_STRING
#define Y_WATCHDOGPERIOD_INVALID        YAPI_INVALID_UINT
#define Y_CHAINDIAGS_INVALID            YAPI_INVALID_UINT
//--- (end of YInputChain globals)

//--- (YInputChain class start)
/**
 * YInputChain Class: InputChain function interface
 *
 * The YInputChain class provides access to separate
 * digital inputs connected in a chain.
 */
@interface YInputChain : YFunction
//--- (end of YInputChain class start)
{
@protected
//--- (YInputChain attributes declaration)
    int             _expectedNodes;
    int             _detectedNodes;
    int             _refreshRate;
    NSString*       _bitChain1;
    NSString*       _bitChain2;
    NSString*       _bitChain3;
    NSString*       _bitChain4;
    NSString*       _bitChain5;
    NSString*       _bitChain6;
    NSString*       _bitChain7;
    int             _watchdogPeriod;
    int             _chainDiags;
    YInputChainValueCallback _valueCallbackInputChain;
    YEventCallback  _eventCallback;
    int             _prevPos;
    int             _eventPos;
    int             _eventStamp;
    NSMutableArray* _eventChains;
//--- (end of YInputChain attributes declaration)
}
// Constructor is protected, use yFindInputChain factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YInputChain private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YInputChain private methods declaration)
//--- (YInputChain yapiwrapper declaration)
//--- (end of YInputChain yapiwrapper declaration)
//--- (YInputChain public methods declaration)
/**
 * Returns the number of nodes expected in the chain.
 *
 * @return an integer corresponding to the number of nodes expected in the chain
 *
 * On failure, throws an exception or returns YInputChain.EXPECTEDNODES_INVALID.
 */
-(int)     get_expectedNodes;


-(int) expectedNodes;
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
-(int)     set_expectedNodes:(int) newval;
-(int)     setExpectedNodes:(int) newval;

/**
 * Returns the number of nodes detected in the chain.
 *
 * @return an integer corresponding to the number of nodes detected in the chain
 *
 * On failure, throws an exception or returns YInputChain.DETECTEDNODES_INVALID.
 */
-(int)     get_detectedNodes;


-(int) detectedNodes;
/**
 * Returns the desired refresh rate, measured in Hz.
 * The higher the refresh rate is set, the higher the
 * communication speed on the chain will be.
 *
 * @return an integer corresponding to the desired refresh rate, measured in Hz
 *
 * On failure, throws an exception or returns YInputChain.REFRESHRATE_INVALID.
 */
-(int)     get_refreshRate;


-(int) refreshRate;
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
-(int)     set_refreshRate:(int) newval;
-(int)     setRefreshRate:(int) newval;

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
-(NSString*)     get_bitChain1;


-(NSString*) bitChain1;
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
-(NSString*)     get_bitChain2;


-(NSString*) bitChain2;
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
-(NSString*)     get_bitChain3;


-(NSString*) bitChain3;
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
-(NSString*)     get_bitChain4;


-(NSString*) bitChain4;
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
-(NSString*)     get_bitChain5;


-(NSString*) bitChain5;
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
-(NSString*)     get_bitChain6;


-(NSString*) bitChain6;
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
-(NSString*)     get_bitChain7;


-(NSString*) bitChain7;
/**
 * Returns the wait time in seconds before triggering an inactivity
 * timeout error.
 *
 * @return an integer corresponding to the wait time in seconds before triggering an inactivity
 *         timeout error
 *
 * On failure, throws an exception or returns YInputChain.WATCHDOGPERIOD_INVALID.
 */
-(int)     get_watchdogPeriod;


-(int) watchdogPeriod;
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
-(int)     set_watchdogPeriod:(int) newval;
-(int)     setWatchdogPeriod:(int) newval;

/**
 * Returns the controller state diagnostics. Bit 0 indicates a chain length
 * error, bit 1 indicates an inactivity timeout and bit 2 indicates
 * a loopback test failure.
 *
 * @return an integer corresponding to the controller state diagnostics
 *
 * On failure, throws an exception or returns YInputChain.CHAINDIAGS_INVALID.
 */
-(int)     get_chainDiags;


-(int) chainDiags;
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
+(YInputChain*)     FindInputChain:(NSString*)func;

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
-(int)     registerValueCallback:(YInputChainValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     resetWatchdog;

/**
 * Returns a string with last events observed on the digital input chain.
 * This method return only events that are still buffered in the device memory.
 *
 * @return a string with last events observed (one per line).
 *
 * On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSString*)     get_lastEvents;

/**
 * Registers a callback function to be called each time that an event is detected on the
 * input chain.
 *
 * @param callback : the callback function to call, or a nil pointer.
 *         The callback function should take four arguments:
 *         the YInputChain object that emitted the event, the
 *         UTC timestamp of the event, a character string describing
 *         the type of event and a character string with the event data.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     registerEventCallback:(YEventCallback _Nullable)callback;

-(int)     _internalEventHandler:(NSString*)cbpos;

-(NSString*)     _strXor:(NSString*)a :(NSString*)b;

-(NSMutableArray*)     hex2array:(NSString*)hexstr;


/**
 * Continues the enumeration of digital input chains started using yFirstInputChain().
 * Caution: You can't make any assumption about the returned digital input chains order.
 * If you want to find a specific a digital input chain, use InputChain.findInputChain()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YInputChain object, corresponding to
 *         a digital input chain currently online, or a nil pointer
 *         if there are no more digital input chains to enumerate.
 */
-(nullable YInputChain*) nextInputChain
NS_SWIFT_NAME(nextInputChain());
/**
 * Starts the enumeration of digital input chains currently accessible.
 * Use the method YInputChain.nextInputChain() to iterate on
 * next digital input chains.
 *
 * @return a pointer to a YInputChain object, corresponding to
 *         the first digital input chain currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YInputChain*) FirstInputChain
NS_SWIFT_NAME(FirstInputChain());
//--- (end of YInputChain public methods declaration)

@end

//--- (YInputChain functions declaration)
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
YInputChain* yFindInputChain(NSString* func);
/**
 * Starts the enumeration of digital input chains currently accessible.
 * Use the method YInputChain.nextInputChain() to iterate on
 * next digital input chains.
 *
 * @return a pointer to a YInputChain object, corresponding to
 *         the first digital input chain currently online, or a nil pointer
 *         if there are none.
 */
YInputChain* yFirstInputChain(void);

//--- (end of YInputChain functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

