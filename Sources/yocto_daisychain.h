/*********************************************************************
 *
 * $Id: yocto_daisychain.h 26552 2017-02-03 15:32:18Z seb $
 *
 * Declares yFindDaisyChain(), the high-level API for DaisyChain functions
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

@class YDaisyChain;

//--- (YDaisyChain globals)
typedef void (*YDaisyChainValueCallback)(YDaisyChain *func, NSString *functionValue);
#ifndef _Y_DAISYSTATE_ENUM
#define _Y_DAISYSTATE_ENUM
typedef enum {
    Y_DAISYSTATE_READY = 0,
    Y_DAISYSTATE_IS_CHILD = 1,
    Y_DAISYSTATE_FIRMWARE_MISMATCH = 2,
    Y_DAISYSTATE_CHILD_MISSING = 3,
    Y_DAISYSTATE_CHILD_LOST = 4,
    Y_DAISYSTATE_INVALID = -1,
} Y_DAISYSTATE_enum;
#endif
#define Y_CHILDCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_REQUIREDCHILDCOUNT_INVALID    YAPI_INVALID_UINT
//--- (end of YDaisyChain globals)

//--- (YDaisyChain class start)
/**
 * YDaisyChain Class: DaisyChain function interface
 *
 * The YDaisyChain interface can be used to verify that devices that
 * are daisy-chained directly from device to device, without a hub,
 * are detected properly.
 */
@interface YDaisyChain : YFunction
//--- (end of YDaisyChain class start)
{
@protected
//--- (YDaisyChain attributes declaration)
    Y_DAISYSTATE_enum _daisyState;
    int             _childCount;
    int             _requiredChildCount;
    YDaisyChainValueCallback _valueCallbackDaisyChain;
//--- (end of YDaisyChain attributes declaration)
}
// Constructor is protected, use yFindDaisyChain factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YDaisyChain private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YDaisyChain private methods declaration)
//--- (YDaisyChain public methods declaration)
/**
 * Returns the state of the daisy-link between modules.
 *
 * @return a value among Y_DAISYSTATE_READY, Y_DAISYSTATE_IS_CHILD, Y_DAISYSTATE_FIRMWARE_MISMATCH,
 * Y_DAISYSTATE_CHILD_MISSING and Y_DAISYSTATE_CHILD_LOST corresponding to the state of the daisy-link
 * between modules
 *
 * On failure, throws an exception or returns Y_DAISYSTATE_INVALID.
 */
-(Y_DAISYSTATE_enum)     get_daisyState;


-(Y_DAISYSTATE_enum) daisyState;
/**
 * Returns the number of child nodes currently detected.
 *
 * @return an integer corresponding to the number of child nodes currently detected
 *
 * On failure, throws an exception or returns Y_CHILDCOUNT_INVALID.
 */
-(int)     get_childCount;


-(int) childCount;
/**
 * Returns the number of child nodes expected in normal conditions.
 *
 * @return an integer corresponding to the number of child nodes expected in normal conditions
 *
 * On failure, throws an exception or returns Y_REQUIREDCHILDCOUNT_INVALID.
 */
-(int)     get_requiredChildCount;


-(int) requiredChildCount;
/**
 * Changes the number of child nodes expected in normal conditions.
 * If the value is zero, no check is performed. If it is non-zero, the number
 * child nodes is checked on startup and the status will change to error if
 * the count does not match.
 *
 * @param newval : an integer corresponding to the number of child nodes expected in normal conditions
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_requiredChildCount:(int) newval;
-(int)     setRequiredChildCount:(int) newval;

/**
 * Retrieves a module chain for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the module chain is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDaisyChain.isOnline() to test if the module chain is
 * indeed online at a given time. In case of ambiguity when looking for
 * a module chain by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the module chain
 *
 * @return a YDaisyChain object allowing you to drive the module chain.
 */
+(YDaisyChain*)     FindDaisyChain:(NSString*)func;

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
-(int)     registerValueCallback:(YDaisyChainValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of module chains started using yFirstDaisyChain().
 *
 * @return a pointer to a YDaisyChain object, corresponding to
 *         a module chain currently online, or a nil pointer
 *         if there are no more module chains to enumerate.
 */
-(YDaisyChain*) nextDaisyChain;
/**
 * Starts the enumeration of module chains currently accessible.
 * Use the method YDaisyChain.nextDaisyChain() to iterate on
 * next module chains.
 *
 * @return a pointer to a YDaisyChain object, corresponding to
 *         the first module chain currently online, or a nil pointer
 *         if there are none.
 */
+(YDaisyChain*) FirstDaisyChain;
//--- (end of YDaisyChain public methods declaration)

@end

//--- (DaisyChain functions declaration)
/**
 * Retrieves a module chain for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the module chain is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDaisyChain.isOnline() to test if the module chain is
 * indeed online at a given time. In case of ambiguity when looking for
 * a module chain by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the module chain
 *
 * @return a YDaisyChain object allowing you to drive the module chain.
 */
YDaisyChain* yFindDaisyChain(NSString* func);
/**
 * Starts the enumeration of module chains currently accessible.
 * Use the method YDaisyChain.nextDaisyChain() to iterate on
 * next module chains.
 *
 * @return a pointer to a YDaisyChain object, corresponding to
 *         the first module chain currently online, or a nil pointer
 *         if there are none.
 */
YDaisyChain* yFirstDaisyChain(void);

//--- (end of DaisyChain functions declaration)
CF_EXTERN_C_END

