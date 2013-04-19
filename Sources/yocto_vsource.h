/*********************************************************************
 *
 * $Id: yocto_vsource.h 10263 2013-03-11 17:25:38Z seb $
 *
 * Declares yFindVSource(), the high-level API for VSource functions
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

//--- (YVSource definitions)
typedef enum {
    Y_FAILURE_FALSE = 0,
    Y_FAILURE_TRUE = 1,
    Y_FAILURE_INVALID = -1
} Y_FAILURE_enum;

typedef enum {
    Y_OVERHEAT_FALSE = 0,
    Y_OVERHEAT_TRUE = 1,
    Y_OVERHEAT_INVALID = -1
} Y_OVERHEAT_enum;

typedef enum {
    Y_OVERCURRENT_FALSE = 0,
    Y_OVERCURRENT_TRUE = 1,
    Y_OVERCURRENT_INVALID = -1
} Y_OVERCURRENT_enum;

typedef enum {
    Y_OVERLOAD_FALSE = 0,
    Y_OVERLOAD_TRUE = 1,
    Y_OVERLOAD_INVALID = -1
} Y_OVERLOAD_enum;

typedef enum {
    Y_REGULATIONFAILURE_FALSE = 0,
    Y_REGULATIONFAILURE_TRUE = 1,
    Y_REGULATIONFAILURE_INVALID = -1
} Y_REGULATIONFAILURE_enum;

typedef enum {
    Y_EXTPOWERFAILURE_FALSE = 0,
    Y_EXTPOWERFAILURE_TRUE = 1,
    Y_EXTPOWERFAILURE_INVALID = -1
} Y_EXTPOWERFAILURE_enum;

#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_ADVERTISEDVALUE_INVALID       [YAPI  INVALID_STRING]
#define Y_UNIT_INVALID                  [YAPI  INVALID_STRING]
#define Y_VOLTAGE_INVALID               (0x80000000)
//--- (end of YVSource definitions)

/**
 * YVSource Class: Voltage source function interface
 * 
 * Yoctopuce application programming interface allows you to control
 * the module voltage output. You affect absolute output values or make
 * transitions
 */
@interface YVSource : YFunction
{
@protected

// Attributes (function value cache)
//--- (YVSource attributes)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    NSString*       _unit;
    int             _voltage;
    Y_FAILURE_enum  _failure;
    Y_OVERHEAT_enum _overHeat;
    Y_OVERCURRENT_enum _overCurrent;
    Y_OVERLOAD_enum _overLoad;
    Y_REGULATIONFAILURE_enum _regulationFailure;
    Y_EXTPOWERFAILURE_enum _extPowerFailure;
    struct {
        s32             target;
        s16             ms;
        u8              moving;
    }  _move;
    struct {
        s16             target;
        s32             ms;
        u8              moving;
    }  _pulseTimer;
//--- (end of YVSource attributes)
}
//--- (YVSource declaration)
// Constructor is protected, use yFindVSource factory function to instantiate
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

//--- (end of YVSource declaration)
//--- (YVSource accessors declaration)

/**
 * Continues the enumeration of voltage sources started using yFirstVSource().
 * 
 * @return a pointer to a YVSource object, corresponding to
 *         a voltage source currently online, or a null pointer
 *         if there are no more voltage sources to enumerate.
 */
-(YVSource*) nextVSource;
/**
 * Retrieves a voltage source for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the voltage source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVSource.isOnline() to test if the voltage source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the voltage source
 * 
 * @return a YVSource object allowing you to drive the voltage source.
 */
+(YVSource*) FindVSource:(NSString*) func;
/**
 * Starts the enumeration of voltage sources currently accessible.
 * Use the method YVSource.nextVSource() to iterate on
 * next voltage sources.
 * 
 * @return a pointer to a YVSource object, corresponding to
 *         the first voltage source currently online, or a null pointer
 *         if there are none.
 */
+(YVSource*) FirstVSource;

/**
 * Returns the logical name of the voltage source.
 * 
 * @return a string corresponding to the logical name of the voltage source
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the voltage source. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the voltage source
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the current value of the voltage source (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the voltage source (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue;
-(NSString*) advertisedValue;

/**
 * Returns the measuring unit for the voltage.
 * 
 * @return a string corresponding to the measuring unit for the voltage
 * 
 * On failure, throws an exception or returns Y_UNIT_INVALID.
 */
-(NSString*) get_unit;
-(NSString*) unit;

/**
 * Returns the voltage output command (mV)
 * 
 * @return an integer corresponding to the voltage output command (mV)
 * 
 * On failure, throws an exception or returns Y_VOLTAGE_INVALID.
 */
-(int) get_voltage;
-(int) voltage;

/**
 * Tunes the device output voltage (milliVolts).
 * 
 * @param newval : an integer
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_voltage:(int) newval;
-(int)     setVoltage:(int) newval;

/**
 * Returns true if the  module is in failure mode. More information can be obtained by testing
 * get_overheat, get_overcurrent etc... When a error condition is met, the output voltage is
 * set to zéro and cannot be changed until the reset() function is called.
 * 
 * @return either Y_FAILURE_FALSE or Y_FAILURE_TRUE, according to true if the  module is in failure mode
 * 
 * On failure, throws an exception or returns Y_FAILURE_INVALID.
 */
-(Y_FAILURE_enum) get_failure;
-(Y_FAILURE_enum) failure;

-(int)     set_failure:(Y_FAILURE_enum) newval;
-(int)     setFailure:(Y_FAILURE_enum) newval;

/**
 * Returns TRUE if the  module is overheating.
 * 
 * @return either Y_OVERHEAT_FALSE or Y_OVERHEAT_TRUE, according to TRUE if the  module is overheating
 * 
 * On failure, throws an exception or returns Y_OVERHEAT_INVALID.
 */
-(Y_OVERHEAT_enum) get_overHeat;
-(Y_OVERHEAT_enum) overHeat;

/**
 * Returns true if the appliance connected to the device is too greedy .
 * 
 * @return either Y_OVERCURRENT_FALSE or Y_OVERCURRENT_TRUE, according to true if the appliance
 * connected to the device is too greedy
 * 
 * On failure, throws an exception or returns Y_OVERCURRENT_INVALID.
 */
-(Y_OVERCURRENT_enum) get_overCurrent;
-(Y_OVERCURRENT_enum) overCurrent;

/**
 * Returns true if the device is not able to maintaint the requested voltage output  .
 * 
 * @return either Y_OVERLOAD_FALSE or Y_OVERLOAD_TRUE, according to true if the device is not able to
 * maintaint the requested voltage output
 * 
 * On failure, throws an exception or returns Y_OVERLOAD_INVALID.
 */
-(Y_OVERLOAD_enum) get_overLoad;
-(Y_OVERLOAD_enum) overLoad;

/**
 * Returns true if the voltage output is too high regarding the requested voltage  .
 * 
 * @return either Y_REGULATIONFAILURE_FALSE or Y_REGULATIONFAILURE_TRUE, according to true if the
 * voltage output is too high regarding the requested voltage
 * 
 * On failure, throws an exception or returns Y_REGULATIONFAILURE_INVALID.
 */
-(Y_REGULATIONFAILURE_enum) get_regulationFailure;
-(Y_REGULATIONFAILURE_enum) regulationFailure;

/**
 * Returns true if external power supply voltage is too low.
 * 
 * @return either Y_EXTPOWERFAILURE_FALSE or Y_EXTPOWERFAILURE_TRUE, according to true if external
 * power supply voltage is too low
 * 
 * On failure, throws an exception or returns Y_EXTPOWERFAILURE_INVALID.
 */
-(Y_EXTPOWERFAILURE_enum) get_extPowerFailure;
-(Y_EXTPOWERFAILURE_enum) extPowerFailure;

-(YRETCODE) get_move :(s32*)target :(s16*)ms :(u8*)moving;

-(YRETCODE)     set_move :(s32)target :(s16)ms :(u8)moving;

/**
 * Performs a smooth move at constant speed toward a given value.
 * 
 * @param target      : new output value at end of transition, in milliVolts.
 * @param ms_duration : transition duration, in milliseconds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     voltageMove :(int)target :(int)ms_duration;

-(YRETCODE) get_pulseTimer :(s16*)target :(s32*)ms :(u8*)moving;

-(YRETCODE)     set_pulseTimer :(s16)target :(s32)ms :(u8)moving;

/**
 * Sets device output to a specific volatage, for a specified duration, then brings it
 * automatically to 0V.
 * 
 * @param voltage : pulse voltage, in millivolts
 * @param ms_duration : pulse duration, in millisecondes
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     pulse :(int)voltage :(int)ms_duration;


//--- (end of YVSource accessors declaration)
@end

//--- (VSource functions declaration)

/**
 * Retrieves a voltage source for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 * 
 * This function does not require that the voltage source is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YVSource.isOnline() to test if the voltage source is
 * indeed online at a given time. In case of ambiguity when looking for
 * a voltage source by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string that uniquely characterizes the voltage source
 * 
 * @return a YVSource object allowing you to drive the voltage source.
 */
YVSource* yFindVSource(NSString* func);
/**
 * Starts the enumeration of voltage sources currently accessible.
 * Use the method YVSource.nextVSource() to iterate on
 * next voltage sources.
 * 
 * @return a pointer to a YVSource object, corresponding to
 *         the first voltage source currently online, or a null pointer
 *         if there are none.
 */
YVSource* yFirstVSource(void);

//--- (end of VSource functions declaration)
CF_EXTERN_C_END

