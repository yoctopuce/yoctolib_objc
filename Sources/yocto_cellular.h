/*********************************************************************
 *
 * $Id: yocto_cellular.h 62273 2024-08-23 07:20:59Z seb $
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
NS_ASSUME_NONNULL_BEGIN
@class YCellRecord;
@class YCellular;

//--- (generated code: YCellRecord globals)
//--- (end of generated code: YCellRecord globals)

//--- (generated code: YCellRecord class start)
/**
 * YCellRecord Class: Cellular antenna description, returned by cellular.quickCellSurvey method
 *
 * YCellRecord objects are used to describe a wireless network.
 * These objects are used in particular in conjunction with the
 * YCellular class.
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
/**
 * Returns the name of the the cell operator, as received from the network.
 *
 * @return a string with the name of the the cell operator.
 */
-(NSString*)     get_cellOperator;

/**
 * Returns the Mobile Country Code (MCC). The MCC is a unique identifier for each country.
 *
 * @return an integer corresponding to the Mobile Country Code (MCC).
 */
-(int)     get_mobileCountryCode;

/**
 * Returns the Mobile Network Code (MNC). The MNC is a unique identifier for each phone
 * operator within a country.
 *
 * @return an integer corresponding to the Mobile Network Code (MNC).
 */
-(int)     get_mobileNetworkCode;

/**
 * Returns the Location Area Code (LAC). The LAC is a unique identifier for each
 * place within a country.
 *
 * @return an integer corresponding to the Location Area Code (LAC).
 */
-(int)     get_locationAreaCode;

/**
 * Returns the Cell ID. The Cell ID is a unique identifier for each
 * base transmission station within a LAC.
 *
 * @return an integer corresponding to the Cell Id.
 */
-(int)     get_cellId;

/**
 * Returns the signal strength, measured in dBm.
 *
 * @return an integer corresponding to the signal strength.
 */
-(int)     get_signalStrength;

/**
 * Returns the Timing Advance (TA). The TA corresponds to the time necessary
 * for the signal to reach the base station from the device.
 * Each increment corresponds about to 550m of distance.
 *
 * @return an integer corresponding to the Timing Advance (TA).
 */
-(int)     get_timingAdvance;


//--- (end of generated code: YCellRecord public methods declaration)

@end

//--- (generated code: YCellRecord functions declaration)
//--- (end of generated code: YCellRecord functions declaration)

//--- (generated code: YCellular globals)
typedef void (*YCellularValueCallback)(YCellular *func, NSString *functionValue);
#ifndef _Y_CELLTYPE_ENUM
#define _Y_CELLTYPE_ENUM
typedef enum {
    Y_CELLTYPE_GPRS = 0,
    Y_CELLTYPE_EGPRS = 1,
    Y_CELLTYPE_WCDMA = 2,
    Y_CELLTYPE_HSDPA = 3,
    Y_CELLTYPE_NONE = 4,
    Y_CELLTYPE_CDMA = 5,
    Y_CELLTYPE_LTE_M = 6,
    Y_CELLTYPE_NB_IOT = 7,
    Y_CELLTYPE_EC_GSM_IOT = 8,
    Y_CELLTYPE_INVALID = -1,
} Y_CELLTYPE_enum;
#endif
#ifndef _Y_AIRPLANEMODE_ENUM
#define _Y_AIRPLANEMODE_ENUM
typedef enum {
    Y_AIRPLANEMODE_OFF = 0,
    Y_AIRPLANEMODE_ON = 1,
    Y_AIRPLANEMODE_INVALID = -1,
} Y_AIRPLANEMODE_enum;
#endif
#ifndef _Y_ENABLEDATA_ENUM
#define _Y_ENABLEDATA_ENUM
typedef enum {
    Y_ENABLEDATA_HOMENETWORK = 0,
    Y_ENABLEDATA_ROAMING = 1,
    Y_ENABLEDATA_NEVER = 2,
    Y_ENABLEDATA_NEUTRALITY = 3,
    Y_ENABLEDATA_INVALID = -1,
} Y_ENABLEDATA_enum;
#endif
#define Y_LINKQUALITY_INVALID           YAPI_INVALID_UINT
#define Y_CELLOPERATOR_INVALID          YAPI_INVALID_STRING
#define Y_CELLIDENTIFIER_INVALID        YAPI_INVALID_STRING
#define Y_IMSI_INVALID                  YAPI_INVALID_STRING
#define Y_MESSAGE_INVALID               YAPI_INVALID_STRING
#define Y_PIN_INVALID                   YAPI_INVALID_STRING
#define Y_RADIOCONFIG_INVALID           YAPI_INVALID_STRING
#define Y_LOCKEDOPERATOR_INVALID        YAPI_INVALID_STRING
#define Y_APN_INVALID                   YAPI_INVALID_STRING
#define Y_APNSECRET_INVALID             YAPI_INVALID_STRING
#define Y_PINGINTERVAL_INVALID          YAPI_INVALID_UINT
#define Y_DATASENT_INVALID              YAPI_INVALID_UINT
#define Y_DATARECEIVED_INVALID          YAPI_INVALID_UINT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of generated code: YCellular globals)

//--- (generated code: YCellular class start)
/**
 * YCellular Class: cellular interface control interface, available for instance in the
 * YoctoHub-GSM-2G, the YoctoHub-GSM-3G-EU, the YoctoHub-GSM-3G-NA or the YoctoHub-GSM-4G
 *
 * The YCellular class provides control over cellular network parameters
 * and status for devices that are GSM-enabled.
 * Note that TCP/IP parameters are configured separately, using class YNetwork.
 */
@interface YCellular : YFunction
//--- (end of generated code: YCellular class start)
{
@protected
//--- (generated code: YCellular attributes declaration)
    int             _linkQuality;
    NSString*       _cellOperator;
    NSString*       _cellIdentifier;
    Y_CELLTYPE_enum _cellType;
    NSString*       _imsi;
    NSString*       _message;
    NSString*       _pin;
    NSString*       _radioConfig;
    NSString*       _lockedOperator;
    Y_AIRPLANEMODE_enum _airplaneMode;
    Y_ENABLEDATA_enum _enableData;
    NSString*       _apn;
    NSString*       _apnSecret;
    int             _pingInterval;
    int             _dataSent;
    int             _dataReceived;
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
 * On failure, throws an exception or returns YCellular.LINKQUALITY_INVALID.
 */
-(int)     get_linkQuality;


-(int) linkQuality;
/**
 * Returns the name of the cell operator currently in use.
 *
 * @return a string corresponding to the name of the cell operator currently in use
 *
 * On failure, throws an exception or returns YCellular.CELLOPERATOR_INVALID.
 */
-(NSString*)     get_cellOperator;


-(NSString*) cellOperator;
/**
 * Returns the unique identifier of the cellular antenna in use: MCC, MNC, LAC and Cell ID.
 *
 * @return a string corresponding to the unique identifier of the cellular antenna in use: MCC, MNC,
 * LAC and Cell ID
 *
 * On failure, throws an exception or returns YCellular.CELLIDENTIFIER_INVALID.
 */
-(NSString*)     get_cellIdentifier;


-(NSString*) cellIdentifier;
/**
 * Active cellular connection type.
 *
 * @return a value among YCellular.CELLTYPE_GPRS, YCellular.CELLTYPE_EGPRS, YCellular.CELLTYPE_WCDMA,
 * YCellular.CELLTYPE_HSDPA, YCellular.CELLTYPE_NONE, YCellular.CELLTYPE_CDMA,
 * YCellular.CELLTYPE_LTE_M, YCellular.CELLTYPE_NB_IOT and YCellular.CELLTYPE_EC_GSM_IOT
 *
 * On failure, throws an exception or returns YCellular.CELLTYPE_INVALID.
 */
-(Y_CELLTYPE_enum)     get_cellType;


-(Y_CELLTYPE_enum) cellType;
/**
 * Returns the International Mobile Subscriber Identity (MSI) that uniquely identifies
 * the SIM card. The first 3 digits represent the mobile country code (MCC), which
 * is followed by the mobile network code (MNC), either 2-digit (European standard)
 * or 3-digit (North American standard)
 *
 * @return a string corresponding to the International Mobile Subscriber Identity (MSI) that uniquely identifies
 *         the SIM card
 *
 * On failure, throws an exception or returns YCellular.IMSI_INVALID.
 */
-(NSString*)     get_imsi;


-(NSString*) imsi;
/**
 * Returns the latest status message from the wireless interface.
 *
 * @return a string corresponding to the latest status message from the wireless interface
 *
 * On failure, throws an exception or returns YCellular.MESSAGE_INVALID.
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
 * On failure, throws an exception or returns YCellular.PIN_INVALID.
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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pin:(NSString*) newval;
-(int)     setPin:(NSString*) newval;

/**
 * Returns the type of protocol used over the serial line, as a string.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 *
 * @return a string corresponding to the type of protocol used over the serial line, as a string
 *
 * On failure, throws an exception or returns YCellular.RADIOCONFIG_INVALID.
 */
-(NSString*)     get_radioConfig;


-(NSString*) radioConfig;
/**
 * Changes the type of protocol used over the serial line.
 * Possible values are "Line" for ASCII messages separated by CR and/or LF,
 * "Frame:[timeout]ms" for binary messages separated by a delay time,
 * "Char" for a continuous ASCII stream or
 * "Byte" for a continuous binary stream.
 * The suffix "/[wait]ms" can be added to reduce the transmit rate so that there
 * is always at lest the specified number of milliseconds between each bytes sent.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the type of protocol used over the serial line
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_radioConfig:(NSString*) newval;
-(int)     setRadioConfig:(NSString*) newval;

/**
 * Returns the name of the only cell operator to use if automatic choice is disabled,
 * or an empty string if the SIM card will automatically choose among available
 * cell operators.
 *
 * @return a string corresponding to the name of the only cell operator to use if automatic choice is disabled,
 *         or an empty string if the SIM card will automatically choose among available
 *         cell operators
 *
 * On failure, throws an exception or returns YCellular.LOCKEDOPERATOR_INVALID.
 */
-(NSString*)     get_lockedOperator;


-(NSString*) lockedOperator;
/**
 * Changes the name of the cell operator to be used. If the name is an empty
 * string, the choice will be made automatically based on the SIM card. Otherwise,
 * the selected operator is the only one that will be used.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the name of the cell operator to be used
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_lockedOperator:(NSString*) newval;
-(int)     setLockedOperator:(NSString*) newval;

/**
 * Returns true if the airplane mode is active (radio turned off).
 *
 * @return either YCellular.AIRPLANEMODE_OFF or YCellular.AIRPLANEMODE_ON, according to true if the
 * airplane mode is active (radio turned off)
 *
 * On failure, throws an exception or returns YCellular.AIRPLANEMODE_INVALID.
 */
-(Y_AIRPLANEMODE_enum)     get_airplaneMode;


-(Y_AIRPLANEMODE_enum) airplaneMode;
/**
 * Changes the activation state of airplane mode (radio turned off).
 *
 * @param newval : either YCellular.AIRPLANEMODE_OFF or YCellular.AIRPLANEMODE_ON, according to the
 * activation state of airplane mode (radio turned off)
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_airplaneMode:(Y_AIRPLANEMODE_enum) newval;
-(int)     setAirplaneMode:(Y_AIRPLANEMODE_enum) newval;

/**
 * Returns the condition for enabling IP data services (GPRS).
 * When data services are disabled, SMS are the only mean of communication.
 *
 * @return a value among YCellular.ENABLEDATA_HOMENETWORK, YCellular.ENABLEDATA_ROAMING,
 * YCellular.ENABLEDATA_NEVER and YCellular.ENABLEDATA_NEUTRALITY corresponding to the condition for
 * enabling IP data services (GPRS)
 *
 * On failure, throws an exception or returns YCellular.ENABLEDATA_INVALID.
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
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a value among YCellular.ENABLEDATA_HOMENETWORK, YCellular.ENABLEDATA_ROAMING,
 * YCellular.ENABLEDATA_NEVER and YCellular.ENABLEDATA_NEUTRALITY corresponding to the condition for
 * enabling IP data services (GPRS)
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns YCellular.APN_INVALID.
 */
-(NSString*)     get_apn;


-(NSString*) apn;
/**
 * Returns the Access Point Name (APN) to be used, if needed.
 * When left blank, the APN suggested by the cell operator will be used.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : a string
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns YCellular.APNSECRET_INVALID.
 */
-(NSString*)     get_apnSecret;


-(NSString*) apnSecret;
-(int)     set_apnSecret:(NSString*) newval;
-(int)     setApnSecret:(NSString*) newval;

/**
 * Returns the automated connectivity check interval, in seconds.
 *
 * @return an integer corresponding to the automated connectivity check interval, in seconds
 *
 * On failure, throws an exception or returns YCellular.PINGINTERVAL_INVALID.
 */
-(int)     get_pingInterval;


-(int) pingInterval;
/**
 * Changes the automated connectivity check interval, in seconds.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the automated connectivity check interval, in seconds
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pingInterval:(int) newval;
-(int)     setPingInterval:(int) newval;

/**
 * Returns the number of bytes sent so far.
 *
 * @return an integer corresponding to the number of bytes sent so far
 *
 * On failure, throws an exception or returns YCellular.DATASENT_INVALID.
 */
-(int)     get_dataSent;


-(int) dataSent;
/**
 * Changes the value of the outgoing data counter.
 *
 * @param newval : an integer corresponding to the value of the outgoing data counter
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_dataSent:(int) newval;
-(int)     setDataSent:(int) newval;

/**
 * Returns the number of bytes received so far.
 *
 * @return an integer corresponding to the number of bytes received so far
 *
 * On failure, throws an exception or returns YCellular.DATARECEIVED_INVALID.
 */
-(int)     get_dataReceived;


-(int) dataReceived;
/**
 * Changes the value of the incoming data counter.
 *
 * @param newval : an integer corresponding to the value of the incoming data counter
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_dataReceived:(int) newval;
-(int)     setDataReceived:(int) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a cellular interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the cellular interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCellular.isOnline() to test if the cellular interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a cellular interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the cellular interface, for instance
 *         YHUBGSM1.cellular.
 *
 * @return a YCellular object allowing you to drive the cellular interface.
 */
+(YCellular*)     FindCellular:(NSString*)func;

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
-(int)     registerValueCallback:(YCellularValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Sends a PUK code to unlock the SIM card after three failed PIN code attempts, and
 * set up a new PIN into the SIM card. Only ten consecutive tentatives are permitted:
 * after that, the SIM card will be blocked permanently without any mean of recovery
 * to use it again. Note that after calling this method, you have usually to invoke
 * method set_pin() to tell the YoctoHub which PIN to use in the future.
 *
 * @param puk : the SIM PUK code
 * @param newPin : new PIN code to configure into the SIM card
 *
 * @return YAPI.SUCCESS when the call succeeds.
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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_apnAuth:(NSString*)username :(NSString*)password;

/**
 * Clear the transmitted data counters.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     clearDataCounters;

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
 * cell, and the next ones are the neighbor cells reported by the
 * serving cell.
 *
 * @return a list of YCellRecords.
 */
-(NSMutableArray*)     quickCellSurvey;

-(NSString*)     imm_decodePLMN:(NSString*)mccmnc;

/**
 * Returns the cell operator brand for a given MCC/MNC pair.
 *
 * @param mccmnc : a string starting with a MCC code followed by a MNC code,
 *
 * @return a string containing the corresponding cell operator brand name.
 */
-(NSString*)     decodePLMN:(NSString*)mccmnc;

/**
 * Returns the list available radio communication profiles, as a string array
 * (YoctoHub-GSM-4G only).
 * Each string is a made of a numerical ID, followed by a colon,
 * followed by the profile description.
 *
 * @return a list of string describing available radio communication profiles.
 */
-(NSMutableArray*)     get_communicationProfiles;


/**
 * Continues the enumeration of cellular interfaces started using yFirstCellular().
 * Caution: You can't make any assumption about the returned cellular interfaces order.
 * If you want to find a specific a cellular interface, use Cellular.findCellular()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YCellular object, corresponding to
 *         a cellular interface currently online, or a nil pointer
 *         if there are no more cellular interfaces to enumerate.
 */
-(nullable YCellular*) nextCellular
NS_SWIFT_NAME(nextCellular());
/**
 * Starts the enumeration of cellular interfaces currently accessible.
 * Use the method YCellular.nextCellular() to iterate on
 * next cellular interfaces.
 *
 * @return a pointer to a YCellular object, corresponding to
 *         the first cellular interface currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YCellular*) FirstCellular
NS_SWIFT_NAME(FirstCellular());
//--- (end of generated code: YCellular public methods declaration)

@end

//--- (generated code: YCellular functions declaration)
/**
 * Retrieves a cellular interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the cellular interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YCellular.isOnline() to test if the cellular interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a cellular interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the cellular interface, for instance
 *         YHUBGSM1.cellular.
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
 *         the first cellular interface currently online, or a nil pointer
 *         if there are none.
 */
YCellular* yFirstCellular(void);

//--- (end of generated code: YCellular functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

