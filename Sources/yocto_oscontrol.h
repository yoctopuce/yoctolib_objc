/*********************************************************************
 *
 * $Id: yocto_oscontrol.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindOsControl(), the high-level API for OsControl functions
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

@class YOsControl;

//--- (YOsControl globals)
typedef void (*YOsControlValueCallback)(YOsControl *func, NSString *functionValue);
#define Y_SHUTDOWNCOUNTDOWN_INVALID     YAPI_INVALID_UINT
//--- (end of YOsControl globals)

//--- (YOsControl class start)
/**
 * YOsControl Class: OS control
 *
 * The OScontrol object allows some control over the operating system running a VirtualHub.
 * OsControl is available on the VirtualHub software only. This feature must be activated at the VirtualHub
 * start up with -o option.
 */
@interface YOsControl : YFunction
//--- (end of YOsControl class start)
{
@protected
//--- (YOsControl attributes declaration)
    int             _shutdownCountdown;
    YOsControlValueCallback _valueCallbackOsControl;
//--- (end of YOsControl attributes declaration)
}
// Constructor is protected, use yFindOsControl factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YOsControl private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YOsControl private methods declaration)
//--- (YOsControl public methods declaration)
/**
 * Returns the remaining number of seconds before the OS shutdown, or zero when no
 * shutdown has been scheduled.
 *
 * @return an integer corresponding to the remaining number of seconds before the OS shutdown, or zero when no
 *         shutdown has been scheduled
 *
 * On failure, throws an exception or returns Y_SHUTDOWNCOUNTDOWN_INVALID.
 */
-(int)     get_shutdownCountdown;


-(int) shutdownCountdown;
-(int)     set_shutdownCountdown:(int) newval;
-(int)     setShutdownCountdown:(int) newval;

/**
 * Retrieves OS control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the OS control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YOsControl.isOnline() to test if the OS control is
 * indeed online at a given time. In case of ambiguity when looking for
 * OS control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the OS control
 *
 * @return a YOsControl object allowing you to drive the OS control.
 */
+(YOsControl*)     FindOsControl:(NSString*)func;

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
-(int)     registerValueCallback:(YOsControlValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Schedules an OS shutdown after a given number of seconds.
 *
 * @param secBeforeShutDown : number of seconds before shutdown
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     shutdown:(int)secBeforeShutDown;


/**
 * Continues the enumeration of OS control started using yFirstOsControl().
 *
 * @return a pointer to a YOsControl object, corresponding to
 *         OS control currently online, or a null pointer
 *         if there are no more OS control to enumerate.
 */
-(YOsControl*) nextOsControl;
/**
 * Starts the enumeration of OS control currently accessible.
 * Use the method YOsControl.nextOsControl() to iterate on
 * next OS control.
 *
 * @return a pointer to a YOsControl object, corresponding to
 *         the first OS control currently online, or a null pointer
 *         if there are none.
 */
+(YOsControl*) FirstOsControl;
//--- (end of YOsControl public methods declaration)

@end

//--- (OsControl functions declaration)
/**
 * Retrieves OS control for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the OS control is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YOsControl.isOnline() to test if the OS control is
 * indeed online at a given time. In case of ambiguity when looking for
 * OS control by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the OS control
 *
 * @return a YOsControl object allowing you to drive the OS control.
 */
YOsControl* yFindOsControl(NSString* func);
/**
 * Starts the enumeration of OS control currently accessible.
 * Use the method YOsControl.nextOsControl() to iterate on
 * next OS control.
 *
 * @return a pointer to a YOsControl object, corresponding to
 *         the first OS control currently online, or a null pointer
 *         if there are none.
 */
YOsControl* yFirstOsControl(void);

//--- (end of OsControl functions declaration)
CF_EXTERN_C_END

