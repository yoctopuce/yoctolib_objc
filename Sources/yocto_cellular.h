/*********************************************************************
 *
 * $Id: yocto_cellular.h 21495 2015-09-14 07:33:16Z mvuilleu $
 *
 * Declares yFindCellular(), the high-level API for Cellular functions
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

@class YCellRecord;
@class YCellular;

//--- (generated code: YCellRecord globals)
//--- (end of generated code: YCellRecord globals)

//--- (generated code: YCellRecord class start)
/**
 * YCellRecord Class: Description of a cellular antenna
 *
 *
 */
@interface YCellRecord : NSObject
//--- (end of generated code: YCellRecord class start)
{
@protected
//--- (generated code: YCellRecord attributes declaration)
    NSString*       _oper;
    int             _mcc;
    int             _mnc;
    int             _lac;
    int             _cid;
    int             _dbm;
    int             _tad;
//--- (end of generated code: YCellRecord attributes declaration)
}
// Constructor is protected, use yFindCellRecord factory function to instantiate
-(id)   initWith:(int)mcc :(int)mnc :(int)lac :(int)cellId :(int)dbm :(int)tad :(NSString *)oper;

//--- (generated code: YCellRecord private methods declaration)
//--- (end of generated code: YCellRecord private methods declaration)
//--- (generated code: YCellRecord public methods declaration)
-(NSString*)     get_cellOperator;

-(int)     get_mobileCountryCode;

-(int)     get_mobileNetworkCode;

-(int)     get_locationAreaCode;

-(int)     get_cellId;

-(int)     get_signalStrength;

-(int)     get_timingAdvance;


//--- (end of generated code: YCellRecord public methods declaration)

@end

//--- (generated code: CellRecord functions declaration)
//--- (end of generated code: CellRecord functions declaration)

//--- (generated code: YCellular globals)
typedef void (*YCellularValueCallback)(YCellular *func, NSString *functionValue);
#ifndef _Y_ENABLEDATA_ENUM
#define _Y_ENABLEDATA_ENUM
typedef enum {
    Y_ENABLEDATA_HOMENETWORK = 0,
    Y_ENABLEDATA_ROAMING = 1,
    Y_ENABLEDATA_NEVER = 2,
    Y_ENABLEDATA_INVALID = -1,
} Y_ENABLEDATA_enum;
#endif
#define Y_LINKQUALITY_INVALID           YAPI_INVALID_UINT
#define Y_CELLOPERATOR_INVALID          YAPI_INVALID_STRING
#define Y_CELLIDENTIFIER_INVALID        YAPI_INVALID_STRING
#define Y_IMSI_INVALID                  YAPI_INVALID_STRING
#define Y_MESSAGE_INVALID               YAPI_INVALID_STRING
#define Y_PIN_INVALID                   YAPI_INVALID_STRING
#define Y_LOCKEDOPERATOR_INVALID        YAPI_INVALID_STRING
#define Y_APN_INVALID                   YAPI_INVALID_STRING
#define Y_APNSECRET_INVALID             YAPI_INVALID_STRING
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of generated code: YCellular globals)

//--- (generated code: YCellular class start)
/**
 * YCellular Class: Cellular function interface
 *
 * YCellular functions provides control over cellular network parameters
 * and status for devices that are GSM-enabled.
 */
@interface YCellular : YFunction
//--- (end of generated code: YCellular class start)
{
@protected
//--- (generated code: YCellular attributes declaration)
    int             _linkQuality;
    NSString*       _cellOperator;
    NSString*       _cellIdentifier;
    NSString*       _imsi;
    NSString*       _message;
    NSString*       _pin;
    NSString*       _lockedOperator;
    Y_ENABLEDATA_enum _enableData;
    NSString*       _apn;
    NSString*       _apnSecret;
    NSString*       _command;
    YCellularValueCallback _valueCallbackCellular;
//--- (end of generated code: YCellular attributes declaration)
}
// Constructor is protected, use yFindCellular factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YCellular private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YCellular private methods declaration)
//--- (generated code: YCellular public methods declaration)
/**
 * Returns the link quality, expressed in percent.
 *
 * @return an integer corresponding to the link quality, expressed in percent
 *
 * On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
 */
-(int)     get_linkQuality;


-(int) linkQuality;
/**
 * Returns the name of the cell operator currently in use.
 *
 * @return a string corresponding to the name of the cell operator currently in use
 *
 * On failure, throws an exception or returns Y_CELLOPERATOR_INVALID.
 */
-(NSString*)     get_cellOperator;


-(NSString*) cellOperator;
/**
 * Returns the unique identifier of the cellular antenna in use: MCC, MNC, LAC and Cell ID.
 *
 * @return a string corresponding to the unique identifier of the cellular antenna in use: MCC, MNC,
 * LAC and Cell ID
 *
 * On failure, throws an exception or returns Y_CELLIDENTIFIER_INVALID.
 */
-(NSString*)     get_cellIdentifier;


-(NSString*) cellIdentifier;
/**
 * Returns an opaque string if a PIN code has been configured in the device to access
 * the SIM card, or an empty string if none has been configured or if the code provided
 * was rejected by the SIM card.
 *
 * @return a string corresponding to an opaque string if a PIN code has been configured in the device to access
 *         the SIM card, or an empty string if none has been configured or if the code provided
 *         was rejected by the SIM card
 *
 * On failure, throws an exception or returns Y_IMSI_INVALID.
 */
-(NSString*)     get_imsi;


-(NSString*) imsi;
/**
 * Returns the latest status message from the wireless interface.
 *
 * @return a string corresponding to the latest status message from the wireless interface
 *
 * On failure, throws an exception or returns Y_MESSAGE_INVALID.
 */
-(NSString*)     get_message;


-(NSString*) message;
/**
 * Returns an opaque string if a PIN code has been configured in the device to access
 * the SIM card, or an empty string if none has been configured or if the code provided
 * was rejected by the SIM card.
 *
 * @return a string corresponding to an opaque string if a PIN code has been configured in the device to access
 *         the SIM card, or an empty string if none has been configured or if the code provided
 *         was rejected by the SIM card
 *
 * On failure, throws an exception or returns Y_PIN_INVALID.
 */
-(NSString*)     get_pin;


-(NSString*) pin;
/**
 * Changes the PIN code used by the module to access the SIM card.
 * This function does not change the code on the SIM card itself, but only changes
 * the parameter used by the device to try to get access to it. If the SIM code
 * does not work immediately on first try, it will be automatically forgotten
 * and the message will be set to "Enter SIM PIN". The method should then be
 * invoked again with right correct PIN code. After three failed attempts in a row,
 * the message is changed to "Enter SIM PUK" and the SIM card PUK code must be
 * provided using method sendPUK.
 *
 * Remember to call the saveToFlash() method of the module to save the
 * new value in the device flash.
 *
 * @param newval : a string corresponding to the PIN code used by the module to access the SIM card
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pin:(NSString*) newval;
-(int)     setPin:(NSString*) newval;

/**
 * Returns the name of the only cell operator to use if automatic choice is disabled,
 * or an empty string if the SIM card will automatically choose among available
 * cell operators.
 *
 * @return a string corresponding to the name of the only cell operator to use if automatic choice is disabled,
 *         or an empty string if the SIM card will automatically choose among available
 *         cell operators
 *
 * On failure, throws an exception or returns Y_LOCKEDOPERATOR_INVALID.
 */
-(NSString*)     get_lockedOperator;


-(NSString*) lockedOperator;
/**
 * Changes the name of the cell operator to be used. If the name is an empty
 * string, the choice will be made automatically based on the SIM card. Otherwise,
 * the selected operator is the only one that will be used.
 *
 * @param newval : a string corresponding to the name of the cell operator to be used
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_lockedOperator:(NSString*) newval;
-(int)     setLockedOperator:(NSString*) newval;

/**
 * Returns the condition for enabling IP data services (GPRS).
 * When data services are disabled, SMS are the only mean of communication.
 *
 * @return a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER
 * corresponding to the condition for enabling IP data services (GPRS)
 *
 * On failure, throws an exception or returns Y_ENABLEDATA_INVALID.
 */
-(Y_ENABLEDATA_enum)     get_enableData;


-(Y_ENABLEDATA_enum) enableData;
/**
 * Changes the condition for enabling IP data services (GPRS).
 * The service can be either fully deactivated, or limited to the SIM home network,
 * or enabled for all partner networks (roaming). Caution: enabling data services
 * on roaming networks may cause prohibitive communication costs !
 *
 * When data services are disabled, SMS are the only mean of communication.
 *
 * @param newval : a value among Y_ENABLEDATA_HOMENETWORK, Y_ENABLEDATA_ROAMING and Y_ENABLEDATA_NEVER
 * corresponding to the condition for enabling IP data services (GPRS)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_enableData:(Y_ENABLEDATA_enum) newval;
-(int)     setEnableData:(Y_ENABLEDATA_enum) newval;

/**
 * Returns the Access Point Name (APN) to be used, if needed.
 * When left blank, the APN suggested by the cell operator will be used.
 *
 * @return a string corresponding to the Access Point Name (APN) to be used, if needed
 *
 * On failure, throws an exception or returns Y_APN_INVALID.
 */
-(NSString*)     get_apn;


-(NSString*) apn;
/**
 * Returns the Access Point Name (APN) to be used, if needed.
 * When left blank, the APN suggested by the cell operator will be used.
 *
 * @param newval : a string
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_apn:(NSString*) newval;
-(int)     setApn:(NSString*) newval;

/**
 * Returns an opaque string if APN authentication parameters have been configured
 * in the device, or an empty string otherwise.
 * To configure these parameters, use set_apnAuth().
 *
 * @return a string corresponding to an opaque string if APN authentication parameters have been configured
 *         in the device, or an empty string otherwise
 *
 * On failure, throws an exception or returns Y_APNSECRET_INVALID.
 */
-(NSString*)     get_apnSecret;


-(NSString*) apnSecret;
-(int)     set_apnSecret:(NSString*) newval;
-(int)     setApnSecret:(NSString*) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a cellular interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the cellular interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCellular.isOnline() to test if the cellular interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a cellular interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the cellular interface
 *
 * @return a YCellular object allowing you to drive the cellular interface.
 */
+(YCellular*)     FindCellular:(NSString*)func;

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
-(int)     registerValueCallback:(YCellularValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Sends a PUK code to unlock the SIM card after three failed PIN code attempts, and
 * setup a new PIN into the SIM card. Only ten consecutives tentatives are permitted:
 * after that, the SIM card will be blocked permanently without any mean of recovery
 * to use it again. Note that after calling this method, you have usually to invoke
 * method set_pin() to tell the YoctoHub which PIN to use in the future.
 *
 * @param puk : the SIM PUK code
 * @param newPin : new PIN code to configure into the SIM card
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sendPUK:(NSString*)puk :(NSString*)newPin;

/**
 * Configure authentication parameters to connect to the APN. Both
 * PAP and CHAP authentication are supported.
 *
 * @param username : APN username
 * @param password : APN password
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_apnAuth:(NSString*)username :(NSString*)password;

/**
 * Sends an AT command to the GSM module and returns the command output.
 * The command will only execute when the GSM module is in standard
 * command state, and should leave it in the exact same state.
 * Use this function with great care !
 *
 * @param cmd : the AT command to execute, like for instance: "+CCLK?".
 *
 * @return a string with the result of the commands. Empty lines are
 *         automatically removed from the output.
 */
-(NSString*)     _AT:(NSString*)cmd;

/**
 * Returns the list detected cell operators in the neighborhood.
 * This function will typically take between 30 seconds to 1 minute to
 * return. Note that any SIM card can usually only connect to specific
 * operators. All networks returned by this function might therefore
 * not be available for connection.
 *
 * @return a list of string (cell operator names).
 */
-(NSMutableArray*)     get_availableOperators;

/**
 * Returns a list of nearby cellular antennas, as required for quick
 * geolocation of the device. The first cell listed is the serving
 * cell, and the next ones are the neighboor cells reported by the
 * serving cell.
 *
 * @return a list of YCellRecords.
 */
-(NSMutableArray*)     quickCellSurvey;


/**
 * Continues the enumeration of cellular interfaces started using yFirstCellular().
 *
 * @return a pointer to a YCellular object, corresponding to
 *         a cellular interface currently online, or a null pointer
 *         if there are no more cellular interfaces to enumerate.
 */
-(YCellular*) nextCellular;
/**
 * Starts the enumeration of cellular interfaces currently accessible.
 * Use the method YCellular.nextCellular() to iterate on
 * next cellular interfaces.
 *
 * @return a pointer to a YCellular object, corresponding to
 *         the first cellular interface currently online, or a null pointer
 *         if there are none.
 */
+(YCellular*) FirstCellular;
//--- (end of generated code: YCellular public methods declaration)

@end

//--- (generated code: Cellular functions declaration)
/**
 * Retrieves a cellular interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the cellular interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCellular.isOnline() to test if the cellular interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a cellular interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the cellular interface
 *
 * @return a YCellular object allowing you to drive the cellular interface.
 */
YCellular* yFindCellular(NSString* func);
/**
 * Starts the enumeration of cellular interfaces currently accessible.
 * Use the method YCellular.nextCellular() to iterate on
 * next cellular interfaces.
 *
 * @return a pointer to a YCellular object, corresponding to
 *         the first cellular interface currently online, or a null pointer
 *         if there are none.
 */
YCellular* yFirstCellular(void);

//--- (end of generated code: Cellular functions declaration)
CF_EXTERN_C_END

