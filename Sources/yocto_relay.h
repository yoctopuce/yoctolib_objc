/*********************************************************************
 *
 * $Id: yocto_relay.h 19608 2015-03-05 10:37:24Z seb $
 *
 * Declares yFindRelay(), the high-level API for Relay functions
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

@class YRelay;

//--- (YRelay globals)
typedef void (*YRelayValueCallback)(YRelay *func, NSString *functionValue);
#ifndef _Y_STATE_ENUM
#define _Y_STATE_ENUM
typedef enum {
    Y_STATE_A = 0,
    Y_STATE_B = 1,
    Y_STATE_INVALID = -1,
} Y_STATE_enum;
#endif
#ifndef _Y_STATEATPOWERON_ENUM
#define _Y_STATEATPOWERON_ENUM
typedef enum {
    Y_STATEATPOWERON_UNCHANGED = 0,
    Y_STATEATPOWERON_A = 1,
    Y_STATEATPOWERON_B = 2,
    Y_STATEATPOWERON_INVALID = -1,
} Y_STATEATPOWERON_enum;
#endif
#ifndef _Y_OUTPUT_ENUM
#define _Y_OUTPUT_ENUM
typedef enum {
    Y_OUTPUT_OFF = 0,
    Y_OUTPUT_ON = 1,
    Y_OUTPUT_INVALID = -1,
} Y_OUTPUT_enum;
#endif
#ifndef _STRUCT_DELAYEDPULSE
#define _STRUCT_DELAYEDPULSE
typedef struct _YDelayedPulse {
    int             target;
    int             ms;
    int             moving;
} YDelayedPulse;
#endif
#define Y_DELAYEDPULSETIMER_INVALID (YDelayedPulse){YAPI_INVALID_INT,YAPI_INVALID_INT,YAPI_INVALID_UINT}
#define Y_MAXTIMEONSTATEA_INVALID       YAPI_INVALID_LONG
#define Y_MAXTIMEONSTATEB_INVALID       YAPI_INVALID_LONG
#define Y_PULSETIMER_INVALID            YAPI_INVALID_LONG
#define Y_COUNTDOWN_INVALID             YAPI_INVALID_LONG
//--- (end of YRelay globals)

//--- (YRelay class start)
/**
 * YRelay Class: Relay function interface
 *
 * The Yoctopuce application programming interface allows you to switch the relay state.
 * This change is not persistent: the relay will automatically return to its idle position
 * whenever power is lost or if the module is restarted.
 * The library can also generate automatically short pulses of determined duration.
 * On devices with two output for each relay (double throw), the two outputs are named A and B,
 * with output A corresponding to the idle position (at power off) and the output B corresponding to the
 * active state. If you prefer the alternate default state, simply switch your cables on the board.
 */
@interface YRelay : YFunction
//--- (end of YRelay class start)
{
@protected
//--- (YRelay attributes declaration)
    Y_STATE_enum    _state;
    Y_STATEATPOWERON_enum _stateAtPowerOn;
    s64             _maxTimeOnStateA;
    s64             _maxTimeOnStateB;
    Y_OUTPUT_enum   _output;
    s64             _pulseTimer;
    YDelayedPulse   _delayedPulseTimer;
    s64             _countdown;
    YRelayValueCallback _valueCallbackRelay;
//--- (end of YRelay attributes declaration)
}
// Constructor is protected, use yFindRelay factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YRelay private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YRelay private methods declaration)
//--- (YRelay public methods declaration)
/**
 * Returns the state of the relays (A for the idle position, B for the active position).
 *
 * @return either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
 *
 * On failure, throws an exception or returns Y_STATE_INVALID.
 */
-(Y_STATE_enum)     get_state;


-(Y_STATE_enum) state;
/**
 * Changes the state of the relays (A for the idle position, B for the active position).
 *
 * @param newval : either Y_STATE_A or Y_STATE_B, according to the state of the relays (A for the idle
 * position, B for the active position)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_state:(Y_STATE_enum) newval;
-(int)     setState:(Y_STATE_enum) newval;

/**
 * Returns the state of the relays at device startup (A for the idle position, B for the active
 * position, UNCHANGED for no change).
 *
 * @return a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 * corresponding to the state of the relays at device startup (A for the idle position, B for the
 * active position, UNCHANGED for no change)
 *
 * On failure, throws an exception or returns Y_STATEATPOWERON_INVALID.
 */
-(Y_STATEATPOWERON_enum)     get_stateAtPowerOn;


-(Y_STATEATPOWERON_enum) stateAtPowerOn;
/**
 * Preset the state of the relays at device startup (A for the idle position,
 * B for the active position, UNCHANGED for no modification). Remember to call the matching module saveToFlash()
 * method, otherwise this call will have no effect.
 *
 * @param newval : a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_stateAtPowerOn:(Y_STATEATPOWERON_enum) newval;
-(int)     setStateAtPowerOn:(Y_STATEATPOWERON_enum) newval;

/**
 * Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically
 * switching back in to B state. Zero means no maximum time.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEA_INVALID.
 */
-(s64)     get_maxTimeOnStateA;


-(s64) maxTimeOnStateA;
/**
 * Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically
 * switching back in to B state. Use zero for no maximum time.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_maxTimeOnStateA:(s64) newval;
-(int)     setMaxTimeOnStateA:(s64) newval;

/**
 * Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically
 * switching back in to A state. Zero means no maximum time.
 *
 * @return an integer
 *
 * On failure, throws an exception or returns Y_MAXTIMEONSTATEB_INVALID.
 */
-(s64)     get_maxTimeOnStateB;


-(s64) maxTimeOnStateB;
/**
 * Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically
 * switching back in to A state. Use zero for no maximum time.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_maxTimeOnStateB:(s64) newval;
-(int)     setMaxTimeOnStateB:(s64) newval;

/**
 * Returns the output state of the relays, when used as a simple switch (single throw).
 *
 * @return either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays, when used
 * as a simple switch (single throw)
 *
 * On failure, throws an exception or returns Y_OUTPUT_INVALID.
 */
-(Y_OUTPUT_enum)     get_output;


-(Y_OUTPUT_enum) output;
/**
 * Changes the output state of the relays, when used as a simple switch (single throw).
 *
 * @param newval : either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the relays,
 * when used as a simple switch (single throw)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_output:(Y_OUTPUT_enum) newval;
-(int)     setOutput:(Y_OUTPUT_enum) newval;

/**
 * Returns the number of milliseconds remaining before the relays is returned to idle position
 * (state A), during a measured pulse generation. When there is no ongoing pulse, returns zero.
 *
 * @return an integer corresponding to the number of milliseconds remaining before the relays is
 * returned to idle position
 *         (state A), during a measured pulse generation
 *
 * On failure, throws an exception or returns Y_PULSETIMER_INVALID.
 */
-(s64)     get_pulseTimer;


-(s64) pulseTimer;
-(int)     set_pulseTimer:(s64) newval;
-(int)     setPulseTimer:(s64) newval;

/**
 * Sets the relay to output B (active) for a specified duration, then brings it
 * automatically back to output A (idle state).
 *
 * @param ms_duration : pulse duration, in millisecondes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     pulse:(int)ms_duration;

-(YDelayedPulse)     get_delayedPulseTimer;


-(YDelayedPulse) delayedPulseTimer;
-(int)     set_delayedPulseTimer:(YDelayedPulse) newval;
-(int)     setDelayedPulseTimer:(YDelayedPulse) newval;

/**
 * Schedules a pulse.
 *
 * @param ms_delay : waiting time before the pulse, in millisecondes
 * @param ms_duration : pulse duration, in millisecondes
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     delayedPulse:(int)ms_delay :(int)ms_duration;

/**
 * Returns the number of milliseconds remaining before a pulse (delayedPulse() call)
 * When there is no scheduled pulse, returns zero.
 *
 * @return an integer corresponding to the number of milliseconds remaining before a pulse (delayedPulse() call)
 *         When there is no scheduled pulse, returns zero
 *
 * On failure, throws an exception or returns Y_COUNTDOWN_INVALID.
 */
-(s64)     get_countdown;


-(s64) countdown;
/**
 * Retrieves a relay for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the relay is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRelay.isOnline() to test if the relay is
 * indeed online at a given time. In case of ambiguity when looking for
 * a relay by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the relay
 *
 * @return a YRelay object allowing you to drive the relay.
 */
+(YRelay*)     FindRelay:(NSString*)func;

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
-(int)     registerValueCallback:(YRelayValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of relays started using yFirstRelay().
 *
 * @return a pointer to a YRelay object, corresponding to
 *         a relay currently online, or a null pointer
 *         if there are no more relays to enumerate.
 */
-(YRelay*) nextRelay;
/**
 * Starts the enumeration of relays currently accessible.
 * Use the method YRelay.nextRelay() to iterate on
 * next relays.
 *
 * @return a pointer to a YRelay object, corresponding to
 *         the first relay currently online, or a null pointer
 *         if there are none.
 */
+(YRelay*) FirstRelay;
//--- (end of YRelay public methods declaration)

@end

//--- (Relay functions declaration)
/**
 * Retrieves a relay for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the relay is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRelay.isOnline() to test if the relay is
 * indeed online at a given time. In case of ambiguity when looking for
 * a relay by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the relay
 *
 * @return a YRelay object allowing you to drive the relay.
 */
YRelay* yFindRelay(NSString* func);
/**
 * Starts the enumeration of relays currently accessible.
 * Use the method YRelay.nextRelay() to iterate on
 * next relays.
 *
 * @return a pointer to a YRelay object, corresponding to
 *         the first relay currently online, or a null pointer
 *         if there are none.
 */
YRelay* yFirstRelay(void);

//--- (end of Relay functions declaration)
CF_EXTERN_C_END

