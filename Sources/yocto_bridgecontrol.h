/*********************************************************************
 *
 * $Id: yocto_bridgecontrol.h 27017 2017-03-31 14:47:59Z seb $
 *
 * Declares yFindBridgeControl(), the high-level API for BridgeControl functions
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

@class YBridgeControl;

//--- (YBridgeControl globals)
typedef void (*YBridgeControlValueCallback)(YBridgeControl *func, NSString *functionValue);
#ifndef _Y_EXCITATIONMODE_ENUM
#define _Y_EXCITATIONMODE_ENUM
typedef enum {
    Y_EXCITATIONMODE_INTERNAL_AC = 0,
    Y_EXCITATIONMODE_INTERNAL_DC = 1,
    Y_EXCITATIONMODE_EXTERNAL_DC = 2,
    Y_EXCITATIONMODE_INVALID = -1,
} Y_EXCITATIONMODE_enum;
#endif
#define Y_BRIDGELATENCY_INVALID         YAPI_INVALID_UINT
#define Y_ADVALUE_INVALID               YAPI_INVALID_INT
#define Y_ADGAIN_INVALID                YAPI_INVALID_UINT
//--- (end of YBridgeControl globals)

//--- (YBridgeControl class start)
/**
 * YBridgeControl Class: BridgeControl function interface
 *
 * The Yoctopuce class YBridgeControl allows you to control bridge excitation parameters
 * and measure parameters for a Wheatstone bridge sensor. To read the measurements, it
 * is best to use the GenericSensor calss, which will compute the measured value
 * in the optimal way.
 */
@interface YBridgeControl : YFunction
//--- (end of YBridgeControl class start)
{
@protected
//--- (YBridgeControl attributes declaration)
    Y_EXCITATIONMODE_enum _excitationMode;
    int             _bridgeLatency;
    int             _adValue;
    int             _adGain;
    YBridgeControlValueCallback _valueCallbackBridgeControl;
//--- (end of YBridgeControl attributes declaration)
}
// Constructor is protected, use yFindBridgeControl factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YBridgeControl private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YBridgeControl private methods declaration)
//--- (YBridgeControl public methods declaration)
/**
 * Returns the current Wheatstone bridge excitation method.
 *
 * @return a value among Y_EXCITATIONMODE_INTERNAL_AC, Y_EXCITATIONMODE_INTERNAL_DC and
 * Y_EXCITATIONMODE_EXTERNAL_DC corresponding to the current Wheatstone bridge excitation method
 *
 * On failure, throws an exception or returns Y_EXCITATIONMODE_INVALID.
 */
-(Y_EXCITATIONMODE_enum)     get_excitationMode;


-(Y_EXCITATIONMODE_enum) excitationMode;
/**
 * Changes the current Wheatstone bridge excitation method.
 *
 * @param newval : a value among Y_EXCITATIONMODE_INTERNAL_AC, Y_EXCITATIONMODE_INTERNAL_DC and
 * Y_EXCITATIONMODE_EXTERNAL_DC corresponding to the current Wheatstone bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_excitationMode:(Y_EXCITATIONMODE_enum) newval;
-(int)     setExcitationMode:(Y_EXCITATIONMODE_enum) newval;

/**
 * Returns the current Wheatstone bridge excitation method.
 *
 * @return an integer corresponding to the current Wheatstone bridge excitation method
 *
 * On failure, throws an exception or returns Y_BRIDGELATENCY_INVALID.
 */
-(int)     get_bridgeLatency;


-(int) bridgeLatency;
/**
 * Changes the current Wheatstone bridge excitation method.
 *
 * @param newval : an integer corresponding to the current Wheatstone bridge excitation method
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_bridgeLatency:(int) newval;
-(int)     setBridgeLatency:(int) newval;

/**
 * Returns the raw value returned by the ratiometric A/D converter
 * during last read.
 *
 * @return an integer corresponding to the raw value returned by the ratiometric A/D converter
 *         during last read
 *
 * On failure, throws an exception or returns Y_ADVALUE_INVALID.
 */
-(int)     get_adValue;


-(int) adValue;
/**
 * Returns the current ratiometric A/D converter gain. The gain is automatically
 * configured according to the signalRange set in the corresponding genericSensor.
 *
 * @return an integer corresponding to the current ratiometric A/D converter gain
 *
 * On failure, throws an exception or returns Y_ADGAIN_INVALID.
 */
-(int)     get_adGain;


-(int) adGain;
/**
 * Retrieves a Wheatstone bridge controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Wheatstone bridge controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBridgeControl.isOnline() to test if the Wheatstone bridge controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Wheatstone bridge controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the Wheatstone bridge controller
 *
 * @return a YBridgeControl object allowing you to drive the Wheatstone bridge controller.
 */
+(YBridgeControl*)     FindBridgeControl:(NSString*)func;

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
-(int)     registerValueCallback:(YBridgeControlValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of Wheatstone bridge controllers started using yFirstBridgeControl().
 *
 * @return a pointer to a YBridgeControl object, corresponding to
 *         a Wheatstone bridge controller currently online, or a nil pointer
 *         if there are no more Wheatstone bridge controllers to enumerate.
 */
-(YBridgeControl*) nextBridgeControl;
/**
 * Starts the enumeration of Wheatstone bridge controllers currently accessible.
 * Use the method YBridgeControl.nextBridgeControl() to iterate on
 * next Wheatstone bridge controllers.
 *
 * @return a pointer to a YBridgeControl object, corresponding to
 *         the first Wheatstone bridge controller currently online, or a nil pointer
 *         if there are none.
 */
+(YBridgeControl*) FirstBridgeControl;
//--- (end of YBridgeControl public methods declaration)

@end

//--- (BridgeControl functions declaration)
/**
 * Retrieves a Wheatstone bridge controller for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the Wheatstone bridge controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YBridgeControl.isOnline() to test if the Wheatstone bridge controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a Wheatstone bridge controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the Wheatstone bridge controller
 *
 * @return a YBridgeControl object allowing you to drive the Wheatstone bridge controller.
 */
YBridgeControl* yFindBridgeControl(NSString* func);
/**
 * Starts the enumeration of Wheatstone bridge controllers currently accessible.
 * Use the method YBridgeControl.nextBridgeControl() to iterate on
 * next Wheatstone bridge controllers.
 *
 * @return a pointer to a YBridgeControl object, corresponding to
 *         the first Wheatstone bridge controller currently online, or a nil pointer
 *         if there are none.
 */
YBridgeControl* yFirstBridgeControl(void);

//--- (end of BridgeControl functions declaration)
CF_EXTERN_C_END

