/*********************************************************************
 *
 *  $Id: yocto_digitalio.h 43619 2021-01-29 09:14:45Z mvuilleu $
 *
 *  Declares yFindDigitalIO(), the high-level API for DigitalIO functions
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

@class YDigitalIO;

//--- (YDigitalIO globals)
typedef void (*YDigitalIOValueCallback)(YDigitalIO *func, NSString *functionValue);
#ifndef _Y_OUTPUTVOLTAGE_ENUM
#define _Y_OUTPUTVOLTAGE_ENUM
typedef enum {
    Y_OUTPUTVOLTAGE_USB_5V = 0,
    Y_OUTPUTVOLTAGE_USB_3V = 1,
    Y_OUTPUTVOLTAGE_EXT_V = 2,
    Y_OUTPUTVOLTAGE_INVALID = -1,
} Y_OUTPUTVOLTAGE_enum;
#endif
#define Y_PORTSTATE_INVALID             YAPI_INVALID_UINT
#define Y_PORTDIRECTION_INVALID         YAPI_INVALID_UINT
#define Y_PORTOPENDRAIN_INVALID         YAPI_INVALID_UINT
#define Y_PORTPOLARITY_INVALID          YAPI_INVALID_UINT
#define Y_PORTDIAGS_INVALID             YAPI_INVALID_UINT
#define Y_PORTSIZE_INVALID              YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YDigitalIO globals)

//--- (YDigitalIO class start)
/**
 * YDigitalIO Class: digital IO port control interface, available for instance in the Yocto-IO or the
 * Yocto-Maxi-IO-V2
 *
 * The YDigitalIO class allows you drive a Yoctopuce digital input/output port.
 * It can be used to setup the direction of each channel, to read the state of each channel
 * and to switch the state of each channel configures as an output.
 * You can work on all channels at once, or one by one. Most functions
 * use a binary representation for channels where bit 0 matches channel #0 , bit 1 matches channel
 * #1 and so on. If you are not familiar with numbers binary representation, you will find more
 * information here: https://en.wikipedia.org/wiki/Binary_number#Representation. It is also possible
 * to automatically generate short pulses of a determined duration. Electrical behavior
 * of each I/O can be modified (open drain and reverse polarity).
 */
@interface YDigitalIO : YFunction
//--- (end of YDigitalIO class start)
{
@protected
//--- (YDigitalIO attributes declaration)
    int             _portState;
    int             _portDirection;
    int             _portOpenDrain;
    int             _portPolarity;
    int             _portDiags;
    int             _portSize;
    Y_OUTPUTVOLTAGE_enum _outputVoltage;
    NSString*       _command;
    YDigitalIOValueCallback _valueCallbackDigitalIO;
//--- (end of YDigitalIO attributes declaration)
}
// Constructor is protected, use yFindDigitalIO factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YDigitalIO private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YDigitalIO private methods declaration)
//--- (YDigitalIO yapiwrapper declaration)
//--- (end of YDigitalIO yapiwrapper declaration)
//--- (YDigitalIO public methods declaration)
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
-(int)     get_portState;


-(int) portState;
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
-(int)     set_portState:(int) newval;
-(int)     setPortState:(int) newval;

/**
 * Returns the I/O direction of all channels of the port (bitmap): 0 makes a bit an input, 1 makes it an output.
 *
 * @return an integer corresponding to the I/O direction of all channels of the port (bitmap): 0 makes
 * a bit an input, 1 makes it an output
 *
 * On failure, throws an exception or returns YDigitalIO.PORTDIRECTION_INVALID.
 */
-(int)     get_portDirection;


-(int) portDirection;
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
-(int)     set_portDirection:(int) newval;
-(int)     setPortDirection:(int) newval;

/**
 * Returns the electrical interface for each bit of the port. For each bit set to 0  the matching I/O
 * works in the regular,
 * intuitive way, for each bit set to 1, the I/O works in reverse mode.
 *
 * @return an integer corresponding to the electrical interface for each bit of the port
 *
 * On failure, throws an exception or returns YDigitalIO.PORTOPENDRAIN_INVALID.
 */
-(int)     get_portOpenDrain;


-(int) portOpenDrain;
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
-(int)     set_portOpenDrain:(int) newval;
-(int)     setPortOpenDrain:(int) newval;

/**
 * Returns the polarity of all the bits of the port.  For each bit set to 0, the matching I/O works the regular,
 * intuitive way; for each bit set to 1, the I/O works in reverse mode.
 *
 * @return an integer corresponding to the polarity of all the bits of the port
 *
 * On failure, throws an exception or returns YDigitalIO.PORTPOLARITY_INVALID.
 */
-(int)     get_portPolarity;


-(int) portPolarity;
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
-(int)     set_portPolarity:(int) newval;
-(int)     setPortPolarity:(int) newval;

/**
 * Returns the port state diagnostics (Yocto-IO and Yocto-MaxiIO-V2 only). Bit 0 indicates a shortcut on
 * output 0, etc. Bit 8 indicates a power failure, and bit 9 signals overheating (overcurrent).
 * During normal use, all diagnostic bits should stay clear.
 *
 * @return an integer corresponding to the port state diagnostics (Yocto-IO and Yocto-MaxiIO-V2 only)
 *
 * On failure, throws an exception or returns YDigitalIO.PORTDIAGS_INVALID.
 */
-(int)     get_portDiags;


-(int) portDiags;
/**
 * Returns the number of bits (i.e. channels)implemented in the I/O port.
 *
 * @return an integer corresponding to the number of bits (i.e
 *
 * On failure, throws an exception or returns YDigitalIO.PORTSIZE_INVALID.
 */
-(int)     get_portSize;


-(int) portSize;
/**
 * Returns the voltage source used to drive output bits.
 *
 * @return a value among YDigitalIO.OUTPUTVOLTAGE_USB_5V, YDigitalIO.OUTPUTVOLTAGE_USB_3V and
 * YDigitalIO.OUTPUTVOLTAGE_EXT_V corresponding to the voltage source used to drive output bits
 *
 * On failure, throws an exception or returns YDigitalIO.OUTPUTVOLTAGE_INVALID.
 */
-(Y_OUTPUTVOLTAGE_enum)     get_outputVoltage;


-(Y_OUTPUTVOLTAGE_enum) outputVoltage;
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
-(int)     set_outputVoltage:(Y_OUTPUTVOLTAGE_enum) newval;
-(int)     setOutputVoltage:(Y_OUTPUTVOLTAGE_enum) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

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
+(YDigitalIO*)     FindDigitalIO:(NSString*)func;

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
-(int)     registerValueCallback:(YDigitalIOValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     set_bitState:(int)bitno :(int)bitstate;

/**
 * Returns the state of a single bit (i.e. channel)  of the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return the bit state (0 or 1)
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     get_bitState:(int)bitno;

/**
 * Reverts a single bit (i.e. channel) of the I/O port.
 *
 * @param bitno : the bit number; lowest bit has index 0
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     toggle_bitState:(int)bitno;

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
-(int)     set_bitDirection:(int)bitno :(int)bitdirection;

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
-(int)     get_bitDirection:(int)bitno;

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
-(int)     set_bitPolarity:(int)bitno :(int)bitpolarity;

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
-(int)     get_bitPolarity:(int)bitno;

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
-(int)     set_bitOpenDrain:(int)bitno :(int)opendrain;

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
-(int)     get_bitOpenDrain:(int)bitno;

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
-(int)     pulse:(int)bitno :(int)ms_duration;

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
-(int)     delayedPulse:(int)bitno :(int)ms_delay :(int)ms_duration;


/**
 * Continues the enumeration of digital IO ports started using yFirstDigitalIO().
 * Caution: You can't make any assumption about the returned digital IO ports order.
 * If you want to find a specific a digital IO port, use DigitalIO.findDigitalIO()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YDigitalIO object, corresponding to
 *         a digital IO port currently online, or a nil pointer
 *         if there are no more digital IO ports to enumerate.
 */
-(nullable YDigitalIO*) nextDigitalIO
NS_SWIFT_NAME(nextDigitalIO());
/**
 * Starts the enumeration of digital IO ports currently accessible.
 * Use the method YDigitalIO.nextDigitalIO() to iterate on
 * next digital IO ports.
 *
 * @return a pointer to a YDigitalIO object, corresponding to
 *         the first digital IO port currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YDigitalIO*) FirstDigitalIO
NS_SWIFT_NAME(FirstDigitalIO());
//--- (end of YDigitalIO public methods declaration)

@end

//--- (YDigitalIO functions declaration)
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
YDigitalIO* yFindDigitalIO(NSString* func);
/**
 * Starts the enumeration of digital IO ports currently accessible.
 * Use the method YDigitalIO.nextDigitalIO() to iterate on
 * next digital IO ports.
 *
 * @return a pointer to a YDigitalIO object, corresponding to
 *         the first digital IO port currently online, or a nil pointer
 *         if there are none.
 */
YDigitalIO* yFirstDigitalIO(void);

//--- (end of YDigitalIO functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

