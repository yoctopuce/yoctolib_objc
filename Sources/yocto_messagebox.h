/*********************************************************************
 *
 * $Id: yocto_messagebox.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 * Declares yFindMessageBox(), the high-level API for MessageBox functions
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
@class YSms;
@class YMessageBox;

//--- (generated code: YSms globals)
//--- (end of generated code: YSms globals)

//--- (generated code: YSms class start)
/**
 * YSms Class: SMS message sent or received, returned by messageBox.get_messages or messageBox.newMessage
 *
 * YSms objects are used to describe an SMS message, received or to be sent.
 * These objects are used in particular in conjunction with the YMessageBox class.
 */
@interface YSms : NSObject
//--- (end of generated code: YSms class start)
{
@protected
//--- (generated code: YSms attributes declaration)
    YMessageBox*    _mbox;
    int             _slot;
    bool            _deliv;
    NSString*       _smsc;
    int             _mref;
    NSString*       _orig;
    NSString*       _dest;
    int             _pid;
    int             _alphab;
    int             _mclass;
    NSString*       _stamp;
    NSMutableData*  _udh;
    NSMutableData*  _udata;
    int             _npdu;
    NSMutableData*  _pdu;
    NSMutableArray* _parts;
    NSString*       _aggSig;
    int             _aggIdx;
    int             _aggCnt;
//--- (end of generated code: YSms attributes declaration)
}
// Constructor is protected, use yFindSms factory function to instantiate
-(id)   initWith:(YMessageBox*)mbox;

//--- (generated code: YSms private methods declaration)
//--- (end of generated code: YSms private methods declaration)
//--- (generated code: YSms public methods declaration)
-(int)     get_slot;

-(NSString*)     get_smsc;

-(int)     get_msgRef;

-(NSString*)     get_sender;

-(NSString*)     get_recipient;

-(int)     get_protocolId;

-(bool)     isReceived;

-(int)     get_alphabet;

-(int)     get_msgClass;

-(int)     get_dcs;

-(NSString*)     get_timestamp;

-(NSMutableData*)     get_userDataHeader;

-(NSMutableData*)     get_userData;

/**
 * Returns the content of the message.
 *
 * @return  a string with the content of the message.
 */
-(NSString*)     get_textData;

-(NSMutableArray*)     get_unicodeData;

-(int)     get_partCount;

-(NSMutableData*)     get_pdu;

-(NSMutableArray*)     get_parts;

-(NSString*)     get_concatSignature;

-(int)     get_concatIndex;

-(int)     get_concatCount;

-(int)     set_slot:(int)val;

-(int)     set_received:(bool)val;

-(int)     set_smsc:(NSString*)val;

-(int)     set_msgRef:(int)val;

-(int)     set_sender:(NSString*)val;

-(int)     set_recipient:(NSString*)val;

-(int)     set_protocolId:(int)val;

-(int)     set_alphabet:(int)val;

-(int)     set_msgClass:(int)val;

-(int)     set_dcs:(int)val;

-(int)     set_timestamp:(NSString*)val;

-(int)     set_userDataHeader:(NSData*)val;

-(int)     set_userData:(NSData*)val;

-(int)     convertToUnicode;

/**
 * Add a regular text to the SMS. This function support messages
 * of more than 160 characters. ISO-latin accented characters
 * are supported. For messages with special unicode characters such as asian
 * characters and emoticons, use the  addUnicodeData method.
 *
 * @param val : the text to be sent in the message
 *
 * @return YAPI.SUCCESS when the call succeeds.
 */
-(int)     addText:(NSString*)val;

/**
 * Add a unicode text to the SMS. This function support messages
 * of more than 160 characters, using SMS concatenation.
 *
 * @param val : an array of special unicode characters
 *
 * @return YAPI.SUCCESS when the call succeeds.
 */
-(int)     addUnicodeData:(NSMutableArray*)val;

-(int)     set_pdu:(NSData*)pdu;

-(int)     set_parts:(NSMutableArray*)parts;

-(NSMutableData*)     encodeAddress:(NSString*)addr;

-(NSString*)     decodeAddress:(NSData*)addr :(int)ofs :(int)siz;

-(NSMutableData*)     encodeTimeStamp:(NSString*)exp;

-(NSString*)     decodeTimeStamp:(NSData*)exp :(int)ofs :(int)siz;

-(int)     udataSize;

-(NSMutableData*)     encodeUserData;

-(int)     generateParts;

-(int)     generatePdu;

-(int)     parseUserDataHeader;

-(int)     parsePdu:(NSData*)pdu;

/**
 * Sends the SMS to the recipient. Messages of more than 160 characters are supported
 * using SMS concatenation.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     send;

-(int)     deleteFromSIM;


//--- (end of generated code: YSms public methods declaration)

@end

//--- (generated code: YSms functions declaration)
//--- (end of generated code: YSms functions declaration)

//--- (generated code: YMessageBox globals)
typedef void (*YMessageBoxValueCallback)(YMessageBox *func, NSString *functionValue);
#define Y_SLOTSINUSE_INVALID            YAPI_INVALID_UINT
#define Y_SLOTSCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_SLOTSBITMAP_INVALID           YAPI_INVALID_STRING
#define Y_PDUSENT_INVALID               YAPI_INVALID_UINT
#define Y_PDURECEIVED_INVALID           YAPI_INVALID_UINT
#define Y_OBEY_INVALID                  YAPI_INVALID_STRING
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of generated code: YMessageBox globals)

//--- (generated code: YMessageBox class start)
/**
 * YMessageBox Class: SMS message box interface control interface, available for instance in the
 * YoctoHub-GSM-2G, the YoctoHub-GSM-3G-EU, the YoctoHub-GSM-3G-NA or the YoctoHub-GSM-4G
 *
 * The YMessageBox class provides SMS sending and receiving capability for
 * GSM-enabled Yoctopuce devices.
 */
@interface YMessageBox : YFunction
//--- (end of generated code: YMessageBox class start)
{
@protected
//--- (generated code: YMessageBox attributes declaration)
    int             _slotsInUse;
    int             _slotsCount;
    NSString*       _slotsBitmap;
    int             _pduSent;
    int             _pduReceived;
    NSString*       _obey;
    NSString*       _command;
    YMessageBoxValueCallback _valueCallbackMessageBox;
    int             _nextMsgRef;
    NSString*       _prevBitmapStr;
    NSMutableArray* _pdus;
    NSMutableArray* _messages;
    bool            _gsm2unicodeReady;
    NSMutableArray* _gsm2unicode;
    NSMutableData*  _iso2gsm;
//--- (end of generated code: YMessageBox attributes declaration)
}
// Constructor is protected, use yFindMessageBox factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YMessageBox private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YMessageBox private methods declaration)
//--- (generated code: YMessageBox public methods declaration)
/**
 * Returns the number of message storage slots currently in use.
 *
 * @return an integer corresponding to the number of message storage slots currently in use
 *
 * On failure, throws an exception or returns YMessageBox.SLOTSINUSE_INVALID.
 */
-(int)     get_slotsInUse;


-(int) slotsInUse;
/**
 * Returns the total number of message storage slots on the SIM card.
 *
 * @return an integer corresponding to the total number of message storage slots on the SIM card
 *
 * On failure, throws an exception or returns YMessageBox.SLOTSCOUNT_INVALID.
 */
-(int)     get_slotsCount;


-(int) slotsCount;
-(NSString*)     get_slotsBitmap;


-(NSString*) slotsBitmap;
/**
 * Returns the number of SMS units sent so far.
 *
 * @return an integer corresponding to the number of SMS units sent so far
 *
 * On failure, throws an exception or returns YMessageBox.PDUSENT_INVALID.
 */
-(int)     get_pduSent;


-(int) pduSent;
/**
 * Changes the value of the outgoing SMS units counter.
 *
 * @param newval : an integer corresponding to the value of the outgoing SMS units counter
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pduSent:(int) newval;
-(int)     setPduSent:(int) newval;

/**
 * Returns the number of SMS units received so far.
 *
 * @return an integer corresponding to the number of SMS units received so far
 *
 * On failure, throws an exception or returns YMessageBox.PDURECEIVED_INVALID.
 */
-(int)     get_pduReceived;


-(int) pduReceived;
/**
 * Changes the value of the incoming SMS units counter.
 *
 * @param newval : an integer corresponding to the value of the incoming SMS units counter
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_pduReceived:(int) newval;
-(int)     setPduReceived:(int) newval;

/**
 * Returns the phone number authorized to send remote management commands.
 * When a phone number is specified, the hub will take contre of all incoming
 * SMS messages: it will execute commands coming from the authorized number,
 * and delete all messages once received (whether authorized or not).
 * If you need to receive SMS messages using your own software, leave this
 * attribute empty.
 *
 * @return a string corresponding to the phone number authorized to send remote management commands
 *
 * On failure, throws an exception or returns YMessageBox.OBEY_INVALID.
 */
-(NSString*)     get_obey;


-(NSString*) obey;
/**
 * Changes the phone number authorized to send remote management commands.
 * The phone number usually starts with a '+' and does not include spacers.
 * When a phone number is specified, the hub will take contre of all incoming
 * SMS messages: it will execute commands coming from the authorized number,
 * and delete all messages once received (whether authorized or not).
 * If you need to receive SMS messages using your own software, leave this
 * attribute empty. Remember to call the saveToFlash() method of the
 * module if the modification must be kept.
 *
 * This feature is only available since YoctoHub-GSM-4G.
 *
 * @param newval : a string corresponding to the phone number authorized to send remote management commands
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_obey:(NSString*) newval;
-(int)     setObey:(NSString*) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

/**
 * Retrieves a SMS message box interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the SMS message box interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMessageBox.isOnline() to test if the SMS message box interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SMS message box interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SMS message box interface, for instance
 *         YHUBGSM1.messageBox.
 *
 * @return a YMessageBox object allowing you to drive the SMS message box interface.
 */
+(YMessageBox*)     FindMessageBox:(NSString*)func;

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
-(int)     registerValueCallback:(YMessageBoxValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     nextMsgRef;

-(int)     clearSIMSlot:(int)slot;

-(NSString*)     _AT:(NSString*)cmd;

-(YSms*)     fetchPdu:(int)slot;

-(int)     initGsm2Unicode;

-(NSMutableArray*)     gsm2unicode:(NSData*)gsm;

-(NSString*)     gsm2str:(NSData*)gsm;

-(NSMutableData*)     str2gsm:(NSString*)msg;

-(int)     checkNewMessages;

-(NSMutableArray*)     get_pdus;

/**
 * Clear the SMS units counters.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     clearPduCounters;

/**
 * Sends a regular text SMS, with standard parameters. This function can send messages
 * of more than 160 characters, using SMS concatenation. ISO-latin accented characters
 * are supported. For sending messages with special unicode characters such as asian
 * characters and emoticons, use newMessage to create a new message and define
 * the content of using methods addText and addUnicodeData.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 * @param message : the text to be sent in the message
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sendTextMessage:(NSString*)recipient :(NSString*)message;

/**
 * Sends a Flash SMS (class 0 message). Flash messages are displayed on the handset
 * immediately and are usually not saved on the SIM card. This function can send messages
 * of more than 160 characters, using SMS concatenation. ISO-latin accented characters
 * are supported. For sending messages with special unicode characters such as asian
 * characters and emoticons, use newMessage to create a new message and define
 * the content of using methods addText et addUnicodeData.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 * @param message : the text to be sent in the message
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     sendFlashMessage:(NSString*)recipient :(NSString*)message;

/**
 * Creates a new empty SMS message, to be configured and sent later on.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(YSms*)     newMessage:(NSString*)recipient;

/**
 * Returns the list of messages received and not deleted. This function
 * will automatically decode concatenated SMS.
 *
 * @return an YSms object list.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*)     get_messages;


/**
 * Continues the enumeration of SMS message box interfaces started using yFirstMessageBox().
 * Caution: You can't make any assumption about the returned SMS message box interfaces order.
 * If you want to find a specific a SMS message box interface, use MessageBox.findMessageBox()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YMessageBox object, corresponding to
 *         a SMS message box interface currently online, or a nil pointer
 *         if there are no more SMS message box interfaces to enumerate.
 */
-(nullable YMessageBox*) nextMessageBox
NS_SWIFT_NAME(nextMessageBox());
/**
 * Starts the enumeration of SMS message box interfaces currently accessible.
 * Use the method YMessageBox.nextMessageBox() to iterate on
 * next SMS message box interfaces.
 *
 * @return a pointer to a YMessageBox object, corresponding to
 *         the first SMS message box interface currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YMessageBox*) FirstMessageBox
NS_SWIFT_NAME(FirstMessageBox());
//--- (end of generated code: YMessageBox public methods declaration)

@end

//--- (generated code: YMessageBox functions declaration)
/**
 * Retrieves a SMS message box interface for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the SMS message box interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMessageBox.isOnline() to test if the SMS message box interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a SMS message box interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the SMS message box interface, for instance
 *         YHUBGSM1.messageBox.
 *
 * @return a YMessageBox object allowing you to drive the SMS message box interface.
 */
YMessageBox* yFindMessageBox(NSString* func);
/**
 * Starts the enumeration of SMS message box interfaces currently accessible.
 * Use the method YMessageBox.nextMessageBox() to iterate on
 * next SMS message box interfaces.
 *
 * @return a pointer to a YMessageBox object, corresponding to
 *         the first SMS message box interface currently online, or a nil pointer
 *         if there are none.
 */
YMessageBox* yFirstMessageBox(void);

//--- (end of generated code: YMessageBox functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

