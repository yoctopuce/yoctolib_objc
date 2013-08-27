/*********************************************************************
 *
 * $Id: yocto_api.h 12326 2013-08-13 15:52:20Z mvuilleu $
 *
 * High-level programming interface, common to all modules
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
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
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

#include "yapi/ydef.h"
#include "yapi/yjson.h"

//CF_EXTERN_C_BEGIN

#if __has_feature(objc_arc)
#define ARC_release(obj)    {}
#define ARC_retain(obj)     {}
#define ARC_dealloc(obj)    {}
#define ARC_autorelease(obj) {}
#define ARC_sendAutorelease(obj) obj
#else
#define ARC_release(obj)     {[obj release];}
#define ARC_retain(obj)      {[obj retain];}
#define ARC_dealloc(obj)     {[obj dealloc];}
#define ARC_autorelease(obj) {[obj autorelease];}
#define ARC_sendAutorelease(obj) [obj autorelease]
#endif

#define STR_y2oc(c_str)          [NSString stringWithUTF8String:c_str]
#define STR_oc2y(objective_str)  [objective_str UTF8String]
NSMutableDictionary* YAPI_YFunctions;


#define YOCTO_API_REVISION          "PATCH_WITH_BUILD"



//--- (generated code: YModule definitions)
typedef enum {
    Y_PERSISTENTSETTINGS_LOADED = 0,
    Y_PERSISTENTSETTINGS_SAVED = 1,
    Y_PERSISTENTSETTINGS_MODIFIED = 2,
    Y_PERSISTENTSETTINGS_INVALID = -1
} Y_PERSISTENTSETTINGS_enum;

typedef enum {
    Y_BEACON_OFF = 0,
    Y_BEACON_ON = 1,
    Y_BEACON_INVALID = -1
} Y_BEACON_enum;

typedef enum {
    Y_USBBANDWIDTH_SIMPLE = 0,
    Y_USBBANDWIDTH_DOUBLE = 1,
    Y_USBBANDWIDTH_INVALID = -1
} Y_USBBANDWIDTH_enum;

#define Y_PRODUCTNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_SERIALNUMBER_INVALID          [YAPI  INVALID_STRING]
#define Y_LOGICALNAME_INVALID           [YAPI  INVALID_STRING]
#define Y_PRODUCTID_INVALID             (-1)
#define Y_PRODUCTRELEASE_INVALID        (-1)
#define Y_FIRMWARERELEASE_INVALID       [YAPI  INVALID_STRING]
#define Y_LUMINOSITY_INVALID            (-1)
#define Y_UPTIME_INVALID                (0xffffffff)
#define Y_USBCURRENT_INVALID            (0xffffffff)
#define Y_REBOOTCOUNTDOWN_INVALID       (0x80000000)
//--- (end of generated code: YModule definitions)

// yInitAPI argument
#define Y_DETECT_NONE  0
#define Y_DETECT_USB   1
#define Y_DETECT_NET   2
#define Y_DETECT_ALL   (Y_DETECT_USB | Y_DETECT_NET)

// Forward-declaration
@class YModule;
@class YFunction;

/// prototype of log callback
typedef void    (*yLogCallback)(NSString * log);

/// prototype of the device arrival/update/removal callback
typedef void    (*yDeviceUpdateCallback)(YModule * module);

/// prototype of functions change callback
typedef void (*YFunctionUpdateCallback)(YFunction *function, NSString * functionValue);


typedef YAPI_DEVICE     YDEV_DESCR;
typedef YAPI_FUNCTION   YFUN_DESCR;
#define Y_FUNCTIONDESCRIPTOR_INVALID      (-1)
#define Y_HARDWAREID_INVALID              [YAPI  INVALID_STRING]
#define Y_FUNCTIONID_INVALID              [YAPI  INVALID_STRING]
#define Y_FRIENDLYNAME_INVALID            [YAPI  INVALID_STRING]


// 
// Class used to report exceptions within Yocto-API
// Do not instantiate directly
//
@interface YAPI_Exception : NSException 
{
    YRETCODE _errorType;
}
@property (readonly,assign) YRETCODE errorType;
-(id)    initWithError:(YRETCODE)error Message:(NSString*)errMsg;
@end

typedef enum {
    YAPI_DEV_ARRIVAL,
    YAPI_DEV_REMOVAL,
    YAPI_DEV_CHANGE,
    YAPI_FUN_UPDATE,
    YAPI_FUN_VALUE,
    YAPI_FUN_REFRESH,
    YAPI_INVALID
} yapiEventType;

@interface  YapiEvent : NSObject
{
    unsigned        _type;
    YModule*        __unsafe_unretained _module;
    YFunction*      __unsafe_unretained _function;
    NSString*        _value;
}
@property (readwrite,assign)            unsigned         type;
@property (readwrite,unsafe_unretained) YModule          *module;
@property (readwrite,unsafe_unretained) YFunction        *function;
@property (readwrite,copy)              NSString         *value;
@end

YRETCODE yFormatRetVal(NSError** error,YRETCODE errCode,const char *message);

@protocol YAPIDelegate
@optional
-(void)   yLog:(NSString*) log;
-(void)   yDeviceArrival:(YModule*) module;
-(void)   yDeviceRemoval:(YModule*) module;
@end

@protocol CalibrationHandlerDelegate
@required
-(double) yCalibrationHandler:(double)rawValue
                             :(int)calibType
                             :(NSArray*)params
                             :(NSArray*)rawValues
                             :(NSArray*) refValues;
@end


// 
// YAPI Context
//
// This class provides Objective-C style entry points to lowlevcel functions defined to yapi.h

@interface YAPI : NSObject

// internal methode do not call directly
+(id) _getCalibrationHandler:(int) calibType;

+(double) _applyCalibration:(double) rawValue :(NSString*)calibration_str :(int)calibOffset :(double)resolution;
// Method used to encode calibration points into fixed-point 16-bit integers or decimal floating-point
+(NSString*) _encodeCalibrationPoints:(NSArray*)rawValues :(NSArray*)refValues :(double)resolution :(int)calibrationOffset :(NSString*)actualCparams;
// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
+(int) _decodeCalibrationPoints:(NSString*)calibParams :(NSMutableArray*)intPt :(NSMutableArray*)rawPt :(NSMutableArray*)calPt withResolution:(double) resolution andOffset:(int)calibrationOffset;


// declare defaultCacheValidity,exceptionsDisabled, and INVALID_STRING as "static" methode since
// there is no "static" data member in Objective-C
        
// Default cache validity (in [ms]) before reloading data from device. This saves a lots of trafic.
// Note that a value under 2 ms makes little sense since a USB bus itself has a 2ms roundtrip period
+(int)         DefaultCacheValidity;
+(void)        SetDefaultCacheValidity:(int)defaultCacheValidity;

// Switch to turn off exceptions and use return codes instead, for source-code compatibility
// with languages without exception support like C    
+(BOOL)        ExceptionsDisabled;
// Return value for invalid strings
+(NSString*)   INVALID_STRING;

/**
 * Returns the version identifier for the Yoctopuce library in use.
 * The version is a string in the form "Major.Minor.Build",
 * for instance "1.01.5535". For languages using an external
 * DLL (for instance C#, VisualBasic or Delphi), the character string
 * includes as well the DLL version, for instance
 * "1.01.5535 (1.01.5439)".
 * 
 * If you want to verify in your code that the library version is
 * compatible with the version that you have used during development,
 * verify that the major number is strictly equal and that the minor
 * number is greater or equal. The build number is not relevant
 * with respect to the library compatibility.
 * 
 * @return a character string describing the library version.
 */
+(NSString*)    GetAPIVersion;

/**
 * Initializes the Yoctopuce programming library explicitly.
 * It is not strictly needed to call yInitAPI(), as the library is
 * automatically  initialized when calling yRegisterHub() for the
 * first time.
 * 
 * When Y_DETECT_NONE is used as detection mode,
 * you must explicitly use yRegisterHub() to point the API to the
 * VirtualHub on which your devices are connected before trying to access them.
 * 
 * @param mode : an integer corresponding to the type of automatic
 *         device detection to use. Possible values are
 *         Y_DETECT_NONE, Y_DETECT_USB, Y_DETECT_NET,
 *         and Y_DETECT_ALL.
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    InitAPI :(int)mode :(NSError**)errmsg;

/**
 * Frees dynamically allocated memory blocks used by the Yoctopuce library.
 * It is generally not required to call this function, unless you
 * want to free all dynamically allocated memory blocks in order to
 * track a memory leak for instance.
 * You should not call any other library function after calling
 * yFreeAPI(), or your program will crash.
 */
 +(void)        FreeAPI;

/**
 * Disables the use of exceptions to report runtime errors.
 * When exceptions are disabled, every function returns a specific
 * error value which depends on its type and which is documented in
 * this reference manual.
 */
 +(void)        DisableExceptions;

/**
 * Re-enables the use of exceptions for runtime error handling.
 * Be aware than when exceptions are enabled, every function that fails
 * triggers an exception. If the exception is not caught by the user code,
 * it  either fires the debugger or aborts (i.e. crash) the program.
 * On failure, throws an exception or returns a negative error code.
 */
 +(void)        EnableExceptions;

/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite usefull to debug the API.
 * 
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterLogFunction:(yLogCallback) logfun;

/**
 * Register a callback function, to be called each time
 * a device is pluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterDeviceArrivalCallback:(yDeviceUpdateCallback) arrivalCallback;

/**
 * (Objective-C only) Register an object that must follow the procol YDeviceHotPlug. The methodes
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param object : an object that must follow the procol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */
 +(void)        SetDelegate:(id)object;


/**
 * Register a callback function, to be called each time
 * a device is unpluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterDeviceRemovalCallback:(yDeviceUpdateCallback) removalCallback;

/**
 *
 */
 +(void)        RegisterDeviceChangeCallback:(yDeviceUpdateCallback) removalCallback;

/**
 * Setup the Yoctopuce library to use modules connected on a given machine.
 * When using Yoctopuce modules through the VirtualHub gateway,
 * you should provide as parameter the address of the machine on which the
 * VirtualHub software is running (typically "http://127.0.0.1:4444",
 * which represents the local machine).
 * When you use a language which has direct access to the USB hardware,
 * you can use the pseudo-URL "usb" instead.
 * 
 * Be aware that only one application can use direct USB access at a
 * given time on a machine. Multiple access would cause conflicts
 * while trying to access the USB modules. In particular, this means
 * that you must stop the VirtualHub software before starting
 * an application that uses direct USB access. The workaround
 * for this limitation is to setup the library to use the VirtualHub
 * rather than direct USB access.
 * 
 * If acces control has been activated on the VirtualHub you want to
 * reach, the URL parameter should look like:
 * 
 * http://username:password@adresse:port
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    RegisterHub:(NSString *) rooturl :(NSError**) error;

/**
 *
 */
+(YRETCODE)         PreregisterHub:(NSString*) rooturl :(NSError**) error;

/**
 * Setup the Yoctopuce library to no more use modules connected on a previously
 * registered machine with RegisterHub.
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 */
+(void)         UnregisterHub:(NSString*) rooturl;


/**
 * Triggers a (re)detection of connected Yoctopuce modules.
 * The library searches the machines or USB ports previously registered using
 * yRegisterHub(), and invokes any user-defined callback function
 * in case a change in the list of connected devices is detected.
 * 
 * This function can be called as frequently as desired to refresh the device list
 * and to make the application aware of hot-plug events.
 * 
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    UpdateDeviceList:(NSError**) error;

/**
 * Maintains the device-to-library communication channel.
 * If your program includes significant loops, you may want to include
 * a call to this function to make sure that the library takes care of
 * the information pushed by the modules on the communication channels.
 * This is not strictly necessary, but it may improve the reactivity
 * of the library for the following commands.
 * 
 * This function may signal an error in case there is a communication problem
 * while contacting a module.
 * 
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    HandleEvents:(NSError**) error;

/**
 * Pauses the execution flow for a specified duration.
 * This function implements a passive waiting loop, meaning that it does not
 * consume CPU cycles significatively. The processor is left available for
 * other threads and processes. During the pause, the library nevertheless
 * reads from time to time information from the Yoctopuce modules by
 * calling yHandleEvents(), in order to stay up-to-date.
 * 
 * This function may signal an error in case there is a communication problem
 * while contacting a module.
 * 
 * @param ms_duration : an integer corresponding to the duration of the pause,
 *         in milliseconds.
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    Sleep:(unsigned)ms_duration :(NSError**)error;

/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the milisecond as timebase.
 * 
 * @return a long integer corresponding to the millisecond counter.
 */
 +(u64)         GetTickCount;

/**
 * Checks if a given string is valid as logical name for a module or a function.
 * A valid logical name has a maximum of 19 characters, all among
 * A..Z, a..z, 0..9, _, and -.
 * If you try to configure a logical name with an incorrect string,
 * the invalid characters are ignored.
 * 
 * @param name : a string containing the name to check.
 * 
 * @return true if the name is valid, false otherwise.
 */
 +(BOOL)        CheckLogicalName:(NSString * const) name;

@end

// Wrappers to yapi low-level API
@interface YapiWrapper : NSObject 
// Wrappers to yapi low-level API
+(u16)         getAPIVersion:(NSString**)version :(NSString**) subversion;
+(YDEV_DESCR)  getDevice:(NSString * const)device_str :(NSError**) error;
+(int)         getAllDevices:(NSMutableArray**) buffer :(NSError**) error;
+(YRETCODE)    getDeviceInfo:(YDEV_DESCR) devdesc :(yDeviceSt*) infos :(NSError**) error;
+(YFUN_DESCR)  getFunction:(NSString * const)class_str :(NSString * const)function_str :(NSError**) error;
+(int)         getFunctionsByClass:(NSString * const)class_str :(YFUN_DESCR) prevfundesc :(NSMutableArray **) buffer :(NSError**) error;
+(int)         getFunctionsByDevice:(YDEV_DESCR) devdesc :(YFUN_DESCR) prevfundesc :(NSMutableArray **) buffer :(NSError**) error;
+(YDEV_DESCR)  getDeviceByFunction:(YFUN_DESCR) fundesc :(NSError**) error;
+(YRETCODE)    getFunctionInfo:(YFUN_DESCR)fundesc :(YDEV_DESCR*) devdescr :(NSString**) serial :(NSString**) funcId :(NSString**) funcName :(NSString**) funcVal :(NSError**) error;
+(YRETCODE)    updateDeviceList:(bool) forceupdate :(NSError**)error;
+(YRETCODE)    handleEvents:(NSError**) error;

@end



// internal function for callback
//void yapiDeviceChangeCallbackFwd(YAPI_DEVICE devdescr);
void yInternalPushNewVal(YAPI_FUNCTION fundescr,NSString *value);



// 
// YDevice Class (used internally)
//
// This class is used to cache device-level information
//
// In order to regroup multiple function queries on the same physical device,
// this class implements a device-wide API string cache (agnostic of API content).
// This is in addition to the function-specific cache implemented in YFunction.
//


@class YDevice;

typedef void (*HTTPRequestCallback)(YDevice *device,NSMutableDictionary *context,YRETCODE returnval, NSData* result,NSString* errmsg);

@interface  YDevice : NSObject
{
@private

    // Device cache entries
    YDEV_DESCR      _devdescr;
    u64             _cacheStamp;
    NSString*       _cacheJson;
    NSArray*        _functions;
    char            _rootdevice[YOCTO_SERIAL_LEN];
    char           *_subpath;
}

// Constructor is private, use getDevice factory method
-(id)           initWithDeviceDescriptor:(YDEV_DESCR)devdesc;
+(YDevice*)     getDevice:(YDEV_DESCR)devdescr;
-(YRETCODE)     HTTPRequestAsync:(NSString*)request :(HTTPRequestCallback)callback :(NSMutableDictionary*)context :(NSError**)error;
-(YRETCODE)     HTTPRequest:(NSString*)request :(NSData**)buffer :(NSError**)error;
-(YRETCODE)     requestAPI:(NSString**)apires :(NSError**)error;
-(YRETCODE)     getFunctions:(NSArray**)functions :(NSError**)error;
@end


/**
 * YFunction Class (virtual class, used internally)
 *
 * This is the parent class for all public objects representing device functions documented in
 * the high-level programming API. This abstract class does all the real job, but without 
 * knowledge of the specific function attributes.
 *
 * Instantiating a child class of YFunction does not cause any communication.
 * The instance simply keeps track of its function identifier, and will dynamically bind
 * to a matching device at the time it is really beeing used to read or set an attribute.
 * In order to allow true hot-plug replacement of one device by another, the binding stay
 * dynamic through the life of the object.
 *
 * The YFunction class implements a generic high-level cache for the attribute values of
 * the specified function, pre-parsed from the REST API string. For strongly typed languages
 * the cache variable is defined in the concrete subclass.
 */


@interface YFunction : NSObject
{   
@protected    
    // Protected attributes
    NSString    *_className;
    NSString    *_func;
    NSError     *_lastError;
    u64         _cacheExpiration;
    YFUN_DESCR  _fundescr;
    void*                   _userData;
    YFunctionUpdateCallback _callback;
    id                      _callbackObject;
    SEL                     _callbackSel;

}   

// Constructor is protected. Use the device-specific factory function to instantiate
-(id) initProtected:(NSString*)classname :(NSString*) func;



// Method used to throw exceptions or save error type/message
-(void)        _throw:(YRETCODE) errType withMsg:(const char*) errMsg;
-(void)        _throw:(YRETCODE) errType :(NSString*) errMsg;
-(void)        _throw: (NSError*) error;

// Method used to retrieve our unique function descriptor (may trigger a hub scan)
-(YRETCODE)    _getDescriptor:(YFUN_DESCR*)fundescr :(NSError**)error;
    
// Method used to retrieve our device object (may trigger a hub scan)
-(YRETCODE)    _getDevice:(YDevice**) dev :(NSError**)error;

// Method used to find the next instance of our function
-(YRETCODE)    _nextFunction:(NSString**) hwId;
    
// Function-specific method for parsing JSON output and caching result
-(int)         _parse:(yJsonStateMachine*) j;
-(NSString*)   _parseString:(yJsonStateMachine*)j;

// Method used to change attributes
-(YRETCODE)    _buildSetRequest:(NSString*)changeattr  :(NSString*)changeval :(NSString**)request :(NSError**)error;
// Method used to change attributes
-(YRETCODE)    _setAttr:(NSString*)attrname :(NSString*)newvalue;
// Method used to send http request to the device (not the function)
-(NSData*)     _download:(NSString*)url;
// Method used to upload a file to the device
-(YRETCODE)    _upload:(NSString*)path :(NSData*)content;
-(NSString*)   _json_get_key:(NSData*)json :(NSString*)data;
-(NSMutableArray*) _json_get_array:(NSData*)json;

/**
 * Returns a descriptive text that identifies the function.
 * The text always includes the class name, and may include as well
 * either the logical name of the function or its hardware identifier.
 * 
 * @return a string that describes the function
 */
-(NSString*)    description;
/**
 * Returns a short text that describes the function in the form TYPE(NAME)=SERIAL&#46;FUNCTIONID.
 * More precisely,
 * TYPE       is the type of the function,
 * NAME       it the name used for the first access to the function,
 * SERIAL     is the serial number of the module if the module is connected or "unresolved", and
 * FUNCTIONID is  the hardware identifier of the function if the module is connected.
 * For example, this method returns Relay(MyCustomName.relay1)=RELAYLO1-123456.relay1 if the
 * module is already connected or Relay(BadCustomeName.relay1)=unresolved if the module has
 * not yet been connected. This method does not trigger any USB or TCP transaction and can therefore be used in
 * a debugger.
 * 
 * @return a string that describes the function
 *         (ex: Relay(MyCustomName.relay1)=RELAYLO1-123456.relay1)
 */

-(NSString*)    describe;

/**
 * Returns a global identifier of the function in the format MODULE_NAME&#46;FUNCTION_NAME.
 * The returned string uses the logical names of the module and of the function if they are defined,
 * otherwise the serial number of the module and the hardware identifier of the function
 * (for exemple: MyCustomName.relay1)
 * 
 * @return a string that uniquely identifies the function using logical names
 *         (ex: MyCustomName.relay1)
 * 
 * On failure, throws an exception or returns  Y_FRIENDLYNAME_INVALID.
 */
-(NSString*)    get_friendlyName;
-(NSString*)    friendlyName;

/**
 * Returns the unique hardware identifier of the function in the form SERIAL&#46;FUNCTIONID.
 * The unique hardware identifier is composed of the device serial
 * number and of the hardware identifier of the function. (for example RELAYLO1-123456.relay1)
 * 
 * @return a string that uniquely identifies the function (ex: RELAYLO1-123456.relay1)
 * 
 * On failure, throws an exception or returns  Y_HARDWAREID_INVALID.
 */
-(NSString*) get_hardwareId;
-(NSString*) hardwareId;

/**
 * Returns the hardware identifier of the function, without reference to the module. For example
 * relay1
 * 
 * @return a string that identifies the function (ex: relay1)
 * 
 * On failure, throws an exception or returns  Y_FUNCTIONID_INVALID.
 */
-(NSString*) get_functionId;
-(NSString*) functionId;


/**
 * Returns the numerical error code of the last error with this module object.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 * 
 * @return a number corresponding to the code of the last error that occured while
 *         using this module object
 */
-(YRETCODE)    get_errType;
-(YRETCODE)    errType;



/**
 * Returns the error message of the latest error with this function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 * 
 * @return a string corresponding to the latest error message that occured while
 *         using this function object
 */
-(NSString*)   get_errorMessage;
-(NSString*)   errorMessage;
    
/**
 * Checks if the function is currently reachable, without raising any error.
 * If there is a cached value for the function in cache, that has not yet
 * expired, the device is considered reachable.
 * No exception is raised if there is an error while trying to contact the
 * device hosting the requested function.
 * 
 * @return true if the function can be reached, and false otherwise
 */
-(BOOL)        isOnline;

/**
 * Preloads the function cache with a specified validity duration.
 * By default, whenever accessing a device, all function attributes
 * are kept in cache for the standard duration (5 ms). This method can be
 * used to temporarily mark the cache as valid for a longer period, in order
 * to reduce network trafic for instance.
 * 
 * @param msValidity : an integer corresponding to the validity attributed to the
 *         loaded function parameters, in milliseconds
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(YRETCODE)    load:(int) msValidity;

/**
 * Gets the YModule object for the device on which the function is located.
 * If the function cannot be located on any module, the returned instance of
 * YModule is not shown as on-line.
 * 
 * @return an instance of YModule
 */
-(YModule*)    get_module;
-(YModule*)    module;


/**
 * Returns a unique identifier of type YFUN_DESCR corresponding to the function.
 * This identifier can be used to test if two instances of YFunction reference the same
 * physical function on the same physical device.
 * 
 * @return an identifier of type YFUN_DESCR.
 * 
 * If the function has never been contacted, the returned value is Y_FUNCTIONDESCRIPTOR_INVALID.
 */
-(YFUN_DESCR)     get_functionDescriptor;
-(YFUN_DESCR)     functionDescriptor;

/**
 * Returns the value of the userData attribute, as previously stored using method
 * set_userData.
 * This attribute is never touched directly by the API, and is at disposal of the caller to
 * store a context.
 * 
 * @return the object stored previously by the caller.
 */
-(void*)    get_userData;
-(void*)    userData;


/**
 * Stores a user context provided as argument in the userData attribute of the function.
 * This attribute is never touched by the API, and is at disposal of the caller to store a context.
 * 
 * @param data : any kind of object to be stored
 * @noreturn
 */
-(void)     set_userData:(void*) data;
-(void)     setUserData:(void*) data;

-(void) _registerFuncCallback;
-(void) _unregisterFuncCallback;


-(void)     notifyValue:(NSString*) value;



@end

/**
 * YModule Class: Module control interface
 * 
 * This interface is identical for all Yoctopuce USB modules.
 * It can be used to control the module global parameters, and
 * to enumerate the functions provided by each module.
 */
@interface YModule : YFunction
{
@protected

//--- (generated code: YModule attributes)
    NSString*       _productName;
    NSString*       _serialNumber;
    NSString*       _logicalName;
    int             _productId;
    int             _productRelease;
    NSString*       _firmwareRelease;
    Y_PERSISTENTSETTINGS_enum _persistentSettings;
    int             _luminosity;
    Y_BEACON_enum   _beacon;
    unsigned        _upTime;
    unsigned        _usbCurrent;
    int             _rebootCountdown;
    Y_USBBANDWIDTH_enum _usbBandwidth;
//--- (end of generated code: YModule attributes)
}
//--- (generated code: YModule declaration)
// Constructor is protected, use yFindModule factory function to instantiate
-(id)    initWithFunction:(NSString*) func;

// Function-specific method for parsing of JSON output and caching result
-(int)             _parse:(yJsonStateMachine*) j;

//--- (end of generated code: YModule declaration)
//--- (generated code: YModule accessors declaration)

/**
 * Continues the module enumeration started using yFirstModule().
 * 
 * @return a pointer to a YModule object, corresponding to
 *         the next module found, or a null pointer
 *         if there are no more modules to enumerate.
 */
-(YModule*) nextModule;
/**
 * Allows you to find a module from its serial number or from its logical name.
 * 
 * This function does not require that the module is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YModule.isOnline() to test if the module is
 * indeed online at a given time. In case of ambiguity when looking for
 * a module by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string containing either the serial number or
 *         the logical name of the desired module
 * 
 * @return a YModule object allowing you to drive the module
 *         or get additional information on the module.
 */
+(YModule*) FindModule:(NSString*) func;
/**
 * Starts the enumeration of modules currently accessible.
 * Use the method YModule.nextModule() to iterate on the
 * next modules.
 * 
 * @return a pointer to a YModule object, corresponding to
 *         the first module currently online, or a null pointer
 *         if there are none.
 */
+(YModule*) FirstModule;

/**
 * Returns the commercial name of the module, as set by the factory.
 * 
 * @return a string corresponding to the commercial name of the module, as set by the factory
 * 
 * On failure, throws an exception or returns Y_PRODUCTNAME_INVALID.
 */
-(NSString*) get_productName;
-(NSString*) productName;

/**
 * Returns the serial number of the module, as set by the factory.
 * 
 * @return a string corresponding to the serial number of the module, as set by the factory
 * 
 * On failure, throws an exception or returns Y_SERIALNUMBER_INVALID.
 */
-(NSString*) get_serialNumber;
-(NSString*) serialNumber;

/**
 * Returns the logical name of the module.
 * 
 * @return a string corresponding to the logical name of the module
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName;
-(NSString*) logicalName;

/**
 * Changes the logical name of the module. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the module
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns the USB device identifier of the module.
 * 
 * @return an integer corresponding to the USB device identifier of the module
 * 
 * On failure, throws an exception or returns Y_PRODUCTID_INVALID.
 */
-(int) get_productId;
-(int) productId;

/**
 * Returns the hardware release version of the module.
 * 
 * @return an integer corresponding to the hardware release version of the module
 * 
 * On failure, throws an exception or returns Y_PRODUCTRELEASE_INVALID.
 */
-(int) get_productRelease;
-(int) productRelease;

/**
 * Returns the version of the firmware embedded in the module.
 * 
 * @return a string corresponding to the version of the firmware embedded in the module
 * 
 * On failure, throws an exception or returns Y_FIRMWARERELEASE_INVALID.
 */
-(NSString*) get_firmwareRelease;
-(NSString*) firmwareRelease;

/**
 * Returns the current state of persistent module settings.
 * 
 * @return a value among Y_PERSISTENTSETTINGS_LOADED, Y_PERSISTENTSETTINGS_SAVED and
 * Y_PERSISTENTSETTINGS_MODIFIED corresponding to the current state of persistent module settings
 * 
 * On failure, throws an exception or returns Y_PERSISTENTSETTINGS_INVALID.
 */
-(Y_PERSISTENTSETTINGS_enum) get_persistentSettings;
-(Y_PERSISTENTSETTINGS_enum) persistentSettings;

-(int)     set_persistentSettings:(Y_PERSISTENTSETTINGS_enum) newval;
-(int)     setPersistentSettings:(Y_PERSISTENTSETTINGS_enum) newval;

/**
 * Saves current settings in the nonvolatile memory of the module.
 * Warning: the number of allowed save operations during a module life is
 * limited (about 100000 cycles). Do not call this function within a loop.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     saveToFlash;

/**
 * Reloads the settings stored in the nonvolatile memory, as
 * when the module is powered on.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     revertFromFlash;

/**
 * Returns the luminosity of the  module informative leds (from 0 to 100).
 * 
 * @return an integer corresponding to the luminosity of the  module informative leds (from 0 to 100)
 * 
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int) get_luminosity;
-(int) luminosity;

/**
 * Changes the luminosity of the module informative leds. The parameter is a
 * value between 0 and 100.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : an integer corresponding to the luminosity of the module informative leds
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_luminosity:(int) newval;
-(int)     setLuminosity:(int) newval;

/**
 * Returns the state of the localization beacon.
 * 
 * @return either Y_BEACON_OFF or Y_BEACON_ON, according to the state of the localization beacon
 * 
 * On failure, throws an exception or returns Y_BEACON_INVALID.
 */
-(Y_BEACON_enum) get_beacon;
-(Y_BEACON_enum) beacon;

/**
 * Turns on or off the module localization beacon.
 * 
 * @param newval : either Y_BEACON_OFF or Y_BEACON_ON
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_beacon:(Y_BEACON_enum) newval;
-(int)     setBeacon:(Y_BEACON_enum) newval;

/**
 * Returns the number of milliseconds spent since the module was powered on.
 * 
 * @return an integer corresponding to the number of milliseconds spent since the module was powered on
 * 
 * On failure, throws an exception or returns Y_UPTIME_INVALID.
 */
-(unsigned) get_upTime;
-(unsigned) upTime;

/**
 * Returns the current consumed by the module on the USB bus, in milli-amps.
 * 
 * @return an integer corresponding to the current consumed by the module on the USB bus, in milli-amps
 * 
 * On failure, throws an exception or returns Y_USBCURRENT_INVALID.
 */
-(unsigned) get_usbCurrent;
-(unsigned) usbCurrent;

/**
 * Returns the remaining number of seconds before the module restarts, or zero when no
 * reboot has been scheduled.
 * 
 * @return an integer corresponding to the remaining number of seconds before the module restarts, or zero when no
 *         reboot has been scheduled
 * 
 * On failure, throws an exception or returns Y_REBOOTCOUNTDOWN_INVALID.
 */
-(int) get_rebootCountdown;
-(int) rebootCountdown;

-(int)     set_rebootCountdown:(int) newval;
-(int)     setRebootCountdown:(int) newval;

/**
 * Schedules a simple module reboot after the given number of seconds.
 * 
 * @param secBeforeReboot : number of seconds before rebooting
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reboot :(int)secBeforeReboot;

/**
 * Schedules a module reboot into special firmware update mode.
 * 
 * @param secBeforeReboot : number of seconds before rebooting
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerFirmwareUpdate :(int)secBeforeReboot;

/**
 * Returns the number of USB interfaces used by the module.
 * 
 * @return either Y_USBBANDWIDTH_SIMPLE or Y_USBBANDWIDTH_DOUBLE, according to the number of USB
 * interfaces used by the module
 * 
 * On failure, throws an exception or returns Y_USBBANDWIDTH_INVALID.
 */
-(Y_USBBANDWIDTH_enum) get_usbBandwidth;
-(Y_USBBANDWIDTH_enum) usbBandwidth;

/**
 * Changes the number of USB interfaces used by the module. You must reboot the module
 * after changing this setting.
 * 
 * @param newval : either Y_USBBANDWIDTH_SIMPLE or Y_USBBANDWIDTH_DOUBLE, according to the number of
 * USB interfaces used by the module
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_usbBandwidth:(Y_USBBANDWIDTH_enum) newval;
-(int)     setUsbBandwidth:(Y_USBBANDWIDTH_enum) newval;

/**
 * Downloads the specified built-in file and returns a binary buffer with its content.
 * 
 * @param pathname : name of the new file to load
 * 
 * @return a binary buffer with the file content
 * 
 * On failure, throws an exception or returns an empty content.
 */
-(NSData*)     download :(NSString*)pathname;

/**
 * Returns the icon of the module. The icon is a PNG image and does not
 * exceeds 1536 bytes.
 * 
 * @return a binary buffer with module icon, in png format.
 */
-(NSData*)     get_icon2d;

/**
 * Returns a string with last logs of the module. This method return only
 * logs that are still in the module.
 * 
 * @return a string with last logs of the module.
 */
-(NSString*)     get_lastLogs;


//--- (end of generated code: YModule accessors declaration)


// Method used to retrieve details of the nth function of our device
-(YRETCODE)        _getFunction:(int) idx  :(NSString**)serial  :(NSString**)funcId :(NSString**)funcName :(NSString**)funcVal :(NSError**)error;


/**
 * Returns the number of functions (beside the "module" interface) available on the module.
 * 
 * @return the number of functions on the module
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int)              functionCount;

/**
 * Retrieves the hardware identifier of the <i>n</i>th function on the module.
 * 
 * @param functionIndex : the index of the function for which the information is desired, starting at
 * 0 for the first function.
 * 
 * @return a string corresponding to the unambiguous hardware identifier of the requested module function
 * 
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*)           functionId:(int) functionIndex;

/**
 * Retrieves the logical name of the <i>n</i>th function on the module.
 * 
 * @param functionIndex : the index of the function for which the information is desired, starting at
 * 0 for the first function.
 * 
 * @return a string corresponding to the logical name of the requested module function
 * 
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*)           functionName:(int) functionIndex;

/**
 * Retrieves the advertised value of the <i>n</i>th function on the module.
 * 
 * @param functionIndex : the index of the function for which the information is desired, starting at
 * 0 for the first function.
 * 
 * @return a short string (up to 6 characters) corresponding to the advertised value of the requested
 * module function
 * 
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*)           functionValue:(int) functionIndex;





@end



/**
 * Initializes the Yoctopuce programming library explicitly.
 * It is not strictly needed to call yInitAPI(), as the library is
 * automatically  initialized when calling yRegisterHub() for the
 * first time.
 * 
 * When Y_DETECT_NONE is used as detection mode,
 * you must explicitly use yRegisterHub() to point the API to the
 * VirtualHub on which your devices are connected before trying to access them.
 * 
 * @param mode : an integer corresponding to the type of automatic
 *         device detection to use. Possible values are
 *         Y_DETECT_NONE, Y_DETECT_USB, Y_DETECT_NET,
 *         and Y_DETECT_ALL.
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE yInitAPI(int mode, NSError** errmsg);

/**
 * Frees dynamically allocated memory blocks used by the Yoctopuce library.
 * It is generally not required to call this function, unless you
 * want to free all dynamically allocated memory blocks in order to
 * track a memory leak for instance.
 * You should not call any other library function after calling
 * yFreeAPI(), or your program will crash.
 */
void yFreeAPI(void);

/**
 * Returns the version identifier for the Yoctopuce library in use.
 * The version is a string in the form "Major.Minor.Build",
 * for instance "1.01.5535". For languages using an external
 * DLL (for instance C#, VisualBasic or Delphi), the character string
 * includes as well the DLL version, for instance
 * "1.01.5535 (1.01.5439)".
 * 
 * If you want to verify in your code that the library version is
 * compatible with the version that you have used during development,
 * verify that the major number is strictly equal and that the minor
 * number is greater or equal. The build number is not relevant
 * with respect to the library compatibility.
 * 
 * @return a character string describing the library version.
 */
NSString* yGetAPIVersion(void); 


/**
 * Disables the use of exceptions to report runtime errors.
 * When exceptions are disabled, every function returns a specific
 * error value which depends on its type and which is documented in
 * this reference manual.
 */
void yDisableExceptions(void);

/**
 * Re-enables the use of exceptions for runtime error handling.
 * Be aware than when exceptions are enabled, every function that fails
 * triggers an exception. If the exception is not caught by the user code,
 * it  either fires the debugger or aborts (i.e. crash) the program.
 * On failure, throws an exception or returns a negative error code.
 */
void yEnableExceptions(void);


/**
 * Setup the Yoctopuce library to use modules connected on a given machine.
 * When using Yoctopuce modules through the VirtualHub gateway,
 * you should provide as parameter the address of the machine on which the
 * VirtualHub software is running (typically "http://127.0.0.1:4444",
 * which represents the local machine).
 * When you use a language which has direct access to the USB hardware,
 * you can use the pseudo-URL "usb" instead.
 * 
 * Be aware that only one application can use direct USB access at a
 * given time on a machine. Multiple access would cause conflicts
 * while trying to access the USB modules. In particular, this means
 * that you must stop the VirtualHub software before starting
 * an application that uses direct USB access. The workaround
 * for this limitation is to setup the library to use the VirtualHub
 * rather than direct USB access.
 * 
 * If acces control has been activated on the VirtualHub you want to
 * reach, the URL parameter should look like:
 * 
 * http://username:password@adresse:port
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE yRegisterHub(NSString * url, NSError** errmsg);

/** 
 * 
 */
YRETCODE yPreregisterHub(NSString * url, NSError** errmsg);

/**
 * Setup the Yoctopuce library to no more use modules connected on a previously
 * registered machine with RegisterHub.
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 */
void     yUnregisterHub(NSString * url);




/**
 * Triggers a (re)detection of connected Yoctopuce modules.
 * The library searches the machines or USB ports previously registered using
 * yRegisterHub(), and invokes any user-defined callback function
 * in case a change in the list of connected devices is detected.
 * 
 * This function can be called as frequently as desired to refresh the device list
 * and to make the application aware of hot-plug events.
 * 
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE yUpdateDeviceList(NSError** errmsg);

/**
 * Maintains the device-to-library communication channel.
 * If your program includes significant loops, you may want to include
 * a call to this function to make sure that the library takes care of
 * the information pushed by the modules on the communication channels.
 * This is not strictly necessary, but it may improve the reactivity
 * of the library for the following commands.
 * 
 * This function may signal an error in case there is a communication problem
 * while contacting a module.
 * 
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE yHandleEvents(NSError** errmsg);

/**
 * Pauses the execution flow for a specified duration.
 * This function implements a passive waiting loop, meaning that it does not
 * consume CPU cycles significatively. The processor is left available for
 * other threads and processes. During the pause, the library nevertheless
 * reads from time to time information from the Yoctopuce modules by
 * calling yHandleEvents(), in order to stay up-to-date.
 * 
 * This function may signal an error in case there is a communication problem
 * while contacting a module.
 * 
 * @param ms_duration : an integer corresponding to the duration of the pause,
 *         in milliseconds.
 * @param errmsg : a string passed by reference to receive any error message.
 * 
 * @return YAPI_SUCCESS when the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE ySleep(unsigned ms_duration, NSError** errmsg);

/**
 * (Objective-C only) Register an object that must follow the procol YDeviceHotPlug. The methodes
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param object : an object that must follow the procol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */

void ySetDelegate(id object);


/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the milisecond as timebase.
 * 
 * @return a long integer corresponding to the millisecond counter.
 */
u64 yGetTickCount(void);


/**
 * Checks if a given string is valid as logical name for a module or a function.
 * A valid logical name has a maximum of 19 characters, all among
 * A..Z, a..z, 0..9, _, and -.
 * If you try to configure a logical name with an incorrect string,
 * the invalid characters are ignored.
 * 
 * @param name : a string containing the name to check.
 * 
 * @return true if the name is valid, false otherwise.
 */
BOOL yCheckLogicalName(NSString * name);

/**
 * Register a callback function, to be called each time
 * a device is pluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceArrivalCallback(yDeviceUpdateCallback arrivalCallback);

/**
 * Register a callback function, to be called each time
 * a device is unpluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceRemovalCallback(yDeviceUpdateCallback removalCallback);

/**
 *
 */
void    yRegisterDeviceChangeCallback(yDeviceUpdateCallback removalCallback);

/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite usefull to debug the API.
 * 
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterLogFunction(yLogCallback logfun);

//--- (generated code: Module functions declaration)

/**
 * Allows you to find a module from its serial number or from its logical name.
 * 
 * This function does not require that the module is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YModule.isOnline() to test if the module is
 * indeed online at a given time. In case of ambiguity when looking for
 * a module by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 * 
 * @param func : a string containing either the serial number or
 *         the logical name of the desired module
 * 
 * @return a YModule object allowing you to drive the module
 *         or get additional information on the module.
 */
YModule* yFindModule(NSString* func);
/**
 * Starts the enumeration of modules currently accessible.
 * Use the method YModule.nextModule() to iterate on the
 * next modules.
 * 
 * @return a pointer to a YModule object, corresponding to
 *         the first module currently online, or a null pointer
 *         if there are none.
 */
YModule* yFirstModule(void);

//--- (end of generated code: Module functions declaration)

CF_EXTERN_C_END


