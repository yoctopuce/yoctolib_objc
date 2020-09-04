/*********************************************************************
 *
 *  $Id: yocto_multisenscontroller.h 41625 2020-08-31 07:09:39Z seb $
 *
 *  Declares yFindMultiSensController(), the high-level API for MultiSensController functions
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

@class YMultiSensController;

//--- (YMultiSensController globals)
typedef void (*YMultiSensControllerValueCallback)(YMultiSensController *func, NSString *functionValue);
#ifndef _Y_MAINTENANCEMODE_ENUM
#define _Y_MAINTENANCEMODE_ENUM
typedef enum {
    Y_MAINTENANCEMODE_FALSE = 0,
    Y_MAINTENANCEMODE_TRUE = 1,
    Y_MAINTENANCEMODE_INVALID = -1,
} Y_MAINTENANCEMODE_enum;
#endif
#define Y_NSENSORS_INVALID              YAPI_INVALID_UINT
#define Y_MAXSENSORS_INVALID            YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YMultiSensController globals)

//--- (YMultiSensController class start)
/**
 * YMultiSensController Class: Sensor chain configuration interface, available for instance in the
 * Yocto-Temperature-IR
 *
 * The YMultiSensController class allows you to setup a customized
 * sensor chain on devices featuring that functionality.
 */
@interface YMultiSensController : YFunction
//--- (end of YMultiSensController class start)
{
@protected
//--- (YMultiSensController attributes declaration)
    int             _nSensors;
    int             _maxSensors;
    Y_MAINTENANCEMODE_enum _maintenanceMode;
    NSString*       _command;
    YMultiSensControllerValueCallback _valueCallbackMultiSensController;
//--- (end of YMultiSensController attributes declaration)
}
// Constructor is protected, use yFindMultiSensController factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YMultiSensController private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YMultiSensController private methods declaration)
//--- (YMultiSensController yapiwrapper declaration)
//--- (end of YMultiSensController yapiwrapper declaration)
//--- (YMultiSensController public methods declaration)
/**
 * Returns the number of sensors to poll.
 *
 * @return an integer corresponding to the number of sensors to poll
 *
 * On failure, throws an exception or returns Y_NSENSORS_INVALID.
 */
-(int)     get_nSensors;


-(int) nSensors;
/**
 * Changes the number of sensors to poll. Remember to call the
 * saveToFlash() method of the module if the
 * modification must be kept. It is recommended to restart the
 * device with  module->reboot() after modifying
 * (and saving) this settings
 *
 * @param newval : an integer corresponding to the number of sensors to poll
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_nSensors:(int) newval;
-(int)     setNSensors:(int) newval;

/**
 * Returns the maximum configurable sensor count allowed on this device.
 *
 * @return an integer corresponding to the maximum configurable sensor count allowed on this device
 *
 * On failure, throws an exception or returns Y_MAXSENSORS_INVALID.
 */
-(int)     get_maxSensors;


-(int) maxSensors;
/**
 * Returns true when the device is in maintenance mode.
 *
 * @return either Y_MAINTENANCEMODE_FALSE or Y_MAINTENANCEMODE_TRUE, according to true when the device
 * is in maintenance mode
 *
 * On failure, throws an exception or returns Y_MAINTENANCEMODE_INVALID.
 */
-(Y_MAINTENANCEMODE_enum)     get_maintenanceMode;


-(Y_MAINTENANCEMODE_enum) maintenanceMode;
/**
 * Changes the device mode to enable maintenance and to stop sensor polling.
 * This way, the device does not automatically restart when it cannot
 * communicate with one of the sensors.
 *
 * @param newval : either Y_MAINTENANCEMODE_FALSE or Y_MAINTENANCEMODE_TRUE, according to the device
 * mode to enable maintenance and to stop sensor polling
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_maintenanceMode:(Y_MAINTENANCEMODE_enum) newval;
-(int)     setMaintenanceMode:(Y_MAINTENANCEMODE_enum) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a multi-sensor controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-sensor controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiSensController.isOnline() to test if the multi-sensor controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-sensor controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-sensor controller, for instance
 *         YTEMPIR1.multiSensController.
 *
 * @return a YMultiSensController object allowing you to drive the multi-sensor controller.
 */
+(YMultiSensController*)     FindMultiSensController:(NSString*)func;

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
-(int)     registerValueCallback:(YMultiSensControllerValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Configures the I2C address of the only sensor connected to the device.
 * It is recommended to put the the device in maintenance mode before
 * changing sensor addresses.  This method is only intended to work with a single
 * sensor connected to the device, if several sensors are connected, the result
 * is unpredictable.
 * Note that the device is probably expecting to find a string of sensors with specific
 * addresses. Check the device documentation to find out which addresses should be used.
 *
 * @param addr : new address of the connected sensor
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int)     setupAddress:(int)addr;


/**
 * Continues the enumeration of multi-sensor controllers started using yFirstMultiSensController().
 * Caution: You can't make any assumption about the returned multi-sensor controllers order.
 * If you want to find a specific a multi-sensor controller, use MultiSensController.findMultiSensController()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YMultiSensController object, corresponding to
 *         a multi-sensor controller currently online, or a nil pointer
 *         if there are no more multi-sensor controllers to enumerate.
 */
-(nullable YMultiSensController*) nextMultiSensController
NS_SWIFT_NAME(nextMultiSensController());
/**
 * Starts the enumeration of multi-sensor controllers currently accessible.
 * Use the method YMultiSensController.nextMultiSensController() to iterate on
 * next multi-sensor controllers.
 *
 * @return a pointer to a YMultiSensController object, corresponding to
 *         the first multi-sensor controller currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YMultiSensController*) FirstMultiSensController
NS_SWIFT_NAME(FirstMultiSensController());
//--- (end of YMultiSensController public methods declaration)

@end

//--- (YMultiSensController functions declaration)
/**
 * Retrieves a multi-sensor controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the multi-sensor controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiSensController.isOnline() to test if the multi-sensor controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-sensor controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-sensor controller, for instance
 *         YTEMPIR1.multiSensController.
 *
 * @return a YMultiSensController object allowing you to drive the multi-sensor controller.
 */
YMultiSensController* yFindMultiSensController(NSString* func);
/**
 * Starts the enumeration of multi-sensor controllers currently accessible.
 * Use the method YMultiSensController.nextMultiSensController() to iterate on
 * next multi-sensor controllers.
 *
 * @return a pointer to a YMultiSensController object, corresponding to
 *         the first multi-sensor controller currently online, or a nil pointer
 *         if there are none.
 */
YMultiSensController* yFirstMultiSensController(void);

//--- (end of YMultiSensController functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

