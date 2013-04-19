/*********************************************************************
 *
 * $Id: yocto_hubport.h 9945 2013-02-20 21:46:06Z seb $
 *
 * Declares yFindHubPort(), the high-level API for HubPort functions
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

//--- (YHubPort definitions)
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1
} Y_ENABLED_enum;

typedef enum {
    Y_PORTSTATE_OFF = 0,
    Y_PORTSTATE_ON = 1,
    Y_PORTSTATE_RUN = 2,
    Y_PORTSTATE_INVALID = -1
} Y_PORTSTATE_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_BAUDRATE_INVALID              (-1)
//--- (end of YHubPort definitions)

/**
 * YHubPort Class: Yocto-hub port interface
 * 
 * 
 */
@interface YHubPort : YFunction
{
@protected

// Attributes (function value cache)
//--- (YHubPort attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    Y_ENABLED_enum  _enabled;
    Y_PORTSTATE_enum _portState;
    int             _baudRate;
//--- (end of YHubPort attributes)
}
//--- (YHubPort declaration)
// Constructor is protected, use yFindHubPort factory function to instantiate
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

//--- (end of YHubPort declaration)
//--- (YHubPort accessors declaration)

/**
 * Continues the enumeration of Yocto-hub ports started using yFirstHubPort().
 * 
 * @return a pointer to a YHubPort object, corresponding to
 *         a Yocto-hub port currently online, or a null pointer
 *         if there are no more Yocto-hub ports to enumerate.
 */
-(YHubPort*) nextHubPort;
/**
 * Retrieves a Yocto-hub port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the Yocto-hub port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHubPort.isOnline() to test if the Yocto-hub port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Yocto-hub port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the Yocto-hub port
 * 
 * @return a YHubPort object allowing you to drive the Yocto-hub port.
 */
+(YHubPort*) FindHubPort:(NSString*) func;
/**
 * Starts the enumeration of Yocto-hub ports currently accessible.
 * Use the method YHubPort.nextHubPort() to iterate on
 * next Yocto-hub ports.
 * 
 * @return a pointer to a YHubPort object, corresponding to
 *         the first Yocto-hub port currently online, or a null pointer
 *         if there are none.
 */
+(YHubPort*) FirstHubPort;

/**
 * Returns the logical name of the Yocto-hub port, which is always the serial number of the
 * connected module.
 * 
 * @return a string corresponding to the logical name of the Yocto-hub port, which is always the
 * serial number of the
 *         connected module
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * It is not possible to configure the logical name of a Yocto-hub port. The logical
 * name is automatically set to the serial number of the connected module.
 * 
 * @param newval : a string
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the Yocto-hub port (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the Yocto-hub port (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns true if the Yocto-hub port is powered, false otherwise.
 * 
 * @return either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to true if the Yocto-hub port is
 * powered, false otherwise
 * 
 * On failure, throws an exception or returns Y_ENABLED_INVALID.
 */
-(Y_ENABLED_enum) get_enabled;
-(Y_ENABLED_enum) enabled;

/**
 * Changes the activation of the Yocto-hub port. If the port is enabled, the
 * *      connected module will be powered. Otherwise, port power will be shut down.
 * 
 * @param newval : either Y_ENABLED_FALSE or Y_ENABLED_TRUE, according to the activation of the Yocto-hub port
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Returns the current state of the Yocto-hub port.
 * 
 * @return a value among Y_PORTSTATE_OFF, Y_PORTSTATE_ON and Y_PORTSTATE_RUN corresponding to the
 * current state of the Yocto-hub port
 * 
 * On failure, throws an exception or returns Y_PORTSTATE_INVALID.
 */
-(Y_PORTSTATE_enum) get_portState;
-(Y_PORTSTATE_enum) portState;

/**
 * Returns the current baud rate used by this Yocto-hub port, in kbps.
 * The default value is 1000 kbps, but a slower rate may be used if communication
 * problems are hit.
 * 
 * @return an integer corresponding to the current baud rate used by this Yocto-hub port, in kbps
 * 
 * On failure, throws an exception or returns Y_BAUDRATE_INVALID.
 */
-(int) get_baudRate;
-(int) baudRate;


//--- (end of YHubPort accessors declaration)
@end

//--- (HubPort functions declaration)

/**
 * Retrieves a Yocto-hub port for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the Yocto-hub port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHubPort.isOnline() to test if the Yocto-hub port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Yocto-hub port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the Yocto-hub port
 * 
 * @return a YHubPort object allowing you to drive the Yocto-hub port.
 */
YHubPort* yFindHubPort(NSString* func);
/**
 * Starts the enumeration of Yocto-hub ports currently accessible.
 * Use the method YHubPort.nextHubPort() to iterate on
 * next Yocto-hub ports.
 * 
 * @return a pointer to a YHubPort object, corresponding to
 *         the first Yocto-hub port currently online, or a null pointer
 *         if there are none.
 */
YHubPort* yFirstHubPort(void);

//--- (end of HubPort functions declaration)
CF_EXTERN_C_END

