/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindHubPort(), the high-level API for HubPort functions
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

@class YHubPort;

//--- (YHubPort globals)
typedef void (*YHubPortValueCallback)(YHubPort *func, NSString *functionValue);
#ifndef _Y_ENABLED_ENUM
#define _Y_ENABLED_ENUM
typedef enum {
    Y_ENABLED_FALSE = 0,
    Y_ENABLED_TRUE = 1,
    Y_ENABLED_INVALID = -1,
} Y_ENABLED_enum;
#endif
#ifndef _Y_PORTSTATE_ENUM
#define _Y_PORTSTATE_ENUM
typedef enum {
    Y_PORTSTATE_OFF = 0,
    Y_PORTSTATE_OVRLD = 1,
    Y_PORTSTATE_ON = 2,
    Y_PORTSTATE_RUN = 3,
    Y_PORTSTATE_PROG = 4,
    Y_PORTSTATE_INVALID = -1,
} Y_PORTSTATE_enum;
#endif
#define Y_BAUDRATE_INVALID              YAPI_INVALID_UINT
//--- (end of YHubPort globals)

//--- (YHubPort class start)
/**
 * YHubPort Class: YoctoHub slave port control interface, available for instance in the
 * YoctoHub-Ethernet, the YoctoHub-GSM-4G, the YoctoHub-Shield or the YoctoHub-Wireless-n
 *
 * The YHubPort class provides control over the power supply for slave ports
 * on a YoctoHub. It provide information about the device connected to it.
 * The logical name of a YHubPort is always automatically set to the
 * unique serial number of the Yoctopuce device connected to it.
 */
@interface YHubPort : YFunction
//--- (end of YHubPort class start)
{
@protected
//--- (YHubPort attributes declaration)
    Y_ENABLED_enum  _enabled;
    Y_PORTSTATE_enum _portState;
    int             _baudRate;
    YHubPortValueCallback _valueCallbackHubPort;
//--- (end of YHubPort attributes declaration)
}
// Constructor is protected, use yFindHubPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YHubPort private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YHubPort private methods declaration)
//--- (YHubPort yapiwrapper declaration)
//--- (end of YHubPort yapiwrapper declaration)
//--- (YHubPort public methods declaration)
/**
 * Returns true if the YoctoHub port is powered, false otherwise.
 *
 * @return either YHubPort.ENABLED_FALSE or YHubPort.ENABLED_TRUE, according to true if the YoctoHub
 * port is powered, false otherwise
 *
 * On failure, throws an exception or returns YHubPort.ENABLED_INVALID.
 */
-(Y_ENABLED_enum)     get_enabled;


-(Y_ENABLED_enum) enabled;
/**
 * Changes the activation of the YoctoHub port. If the port is enabled, the
 * connected module is powered. Otherwise, port power is shut down.
 *
 * @param newval : either YHubPort.ENABLED_FALSE or YHubPort.ENABLED_TRUE, according to the activation
 * of the YoctoHub port
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enabled:(Y_ENABLED_enum) newval;
-(int)     setEnabled:(Y_ENABLED_enum) newval;

/**
 * Returns the current state of the YoctoHub port.
 *
 * @return a value among YHubPort.PORTSTATE_OFF, YHubPort.PORTSTATE_OVRLD, YHubPort.PORTSTATE_ON,
 * YHubPort.PORTSTATE_RUN and YHubPort.PORTSTATE_PROG corresponding to the current state of the YoctoHub port
 *
 * On failure, throws an exception or returns YHubPort.PORTSTATE_INVALID.
 */
-(Y_PORTSTATE_enum)     get_portState;


-(Y_PORTSTATE_enum) portState;
/**
 * Returns the current baud rate used by this YoctoHub port, in kbps.
 * The default value is 1000 kbps, but a slower rate may be used if communication
 * problems are encountered.
 *
 * @return an integer corresponding to the current baud rate used by this YoctoHub port, in kbps
 *
 * On failure, throws an exception or returns YHubPort.BAUDRATE_INVALID.
 */
-(int)     get_baudRate;


-(int) baudRate;
/**
 * Retrieves a YoctoHub slave port for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the YoctoHub slave port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHubPort.isOnline() to test if the YoctoHub slave port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a YoctoHub slave port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the YoctoHub slave port, for instance
 *         YHUBETH1.hubPort1.
 *
 * @return a YHubPort object allowing you to drive the YoctoHub slave port.
 */
+(YHubPort*)     FindHubPort:(NSString*)func;

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
-(int)     registerValueCallback:(YHubPortValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of YoctoHub slave ports started using yFirstHubPort().
 * Caution: You can't make any assumption about the returned YoctoHub slave ports order.
 * If you want to find a specific a YoctoHub slave port, use HubPort.findHubPort()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YHubPort object, corresponding to
 *         a YoctoHub slave port currently online, or a nil pointer
 *         if there are no more YoctoHub slave ports to enumerate.
 */
-(nullable YHubPort*) nextHubPort
NS_SWIFT_NAME(nextHubPort());
/**
 * Starts the enumeration of YoctoHub slave ports currently accessible.
 * Use the method YHubPort.nextHubPort() to iterate on
 * next YoctoHub slave ports.
 *
 * @return a pointer to a YHubPort object, corresponding to
 *         the first YoctoHub slave port currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YHubPort*) FirstHubPort
NS_SWIFT_NAME(FirstHubPort());
//--- (end of YHubPort public methods declaration)

@end

//--- (YHubPort functions declaration)
/**
 * Retrieves a YoctoHub slave port for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the YoctoHub slave port is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YHubPort.isOnline() to test if the YoctoHub slave port is
 * indeed online at a given time. In case of ambiguity when looking for
 * a YoctoHub slave port by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the YoctoHub slave port, for instance
 *         YHUBETH1.hubPort1.
 *
 * @return a YHubPort object allowing you to drive the YoctoHub slave port.
 */
YHubPort* yFindHubPort(NSString* func);
/**
 * Starts the enumeration of YoctoHub slave ports currently accessible.
 * Use the method YHubPort.nextHubPort() to iterate on
 * next YoctoHub slave ports.
 *
 * @return a pointer to a YHubPort object, corresponding to
 *         the first YoctoHub slave port currently online, or a nil pointer
 *         if there are none.
 */
YHubPort* yFirstHubPort(void);

//--- (end of YHubPort functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

