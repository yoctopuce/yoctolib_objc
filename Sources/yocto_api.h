/*********************************************************************
 *
 * $Id: yocto_api.h 21732 2015-10-09 16:32:36Z seb $
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
#import <Foundation/Foundation.h>

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

#define STR_y2oc(c_str)          [NSString stringWithCString:c_str encoding:NSISOLatin1StringEncoding]
#define STR_oc2y(objective_str)  [objective_str cStringUsingEncoding:NSISOLatin1StringEncoding]

extern NSMutableDictionary* YAPI_YFunctions;

#define YOCTO_API_REVISION          "21816"

// yInitAPI argument
#define Y_DETECT_NONE           0
#define Y_DETECT_USB            1
#define Y_DETECT_NET            2
#define Y_RESEND_MISSING_PKT    4
#define Y_DETECT_ALL   (Y_DETECT_USB | Y_DETECT_NET)

// Forward-declaration
@class YModule;
@class YFunction;
@class YSensor;
@class YDataLogger;
@class YMeasure;
@class YDataStream;
@class YDataSet;
@class YFirmwareUpdate;

/// prototype of log callback
typedef void    (*yLogCallback)(NSString * log);

/// prototype of the device arrival/update/removal callback
typedef void    (*yDeviceUpdateCallback)(YModule * module);

/// prototype of hub discovery callback
typedef void (*YHubDiscoveryCallback)(NSString * serial, NSString * url);


typedef YAPI_DEVICE     YDEV_DESCR;
typedef YAPI_FUNCTION   YFUN_DESCR;
#define Y_FUNCTIONDESCRIPTOR_INVALID      (-1)

extern NSString *           YAPI_INVALID_STRING;
#define YAPI_INVALID_INT                  (0x7fffffff)
#define YAPI_INVALID_UINT                 (-1)
#define YAPI_INVALID_LONG                 (0x7fffffffffffffff)
#define YAPI_INVALID_DOUBLE               (-DBL_MAX)

#define Y_HARDWAREID_INVALID              YAPI_INVALID_STRING
#define Y_FUNCTIONID_INVALID              YAPI_INVALID_STRING
#define Y_FRIENDLYNAME_INVALID            YAPI_INVALID_STRING


//--- (generated code: YFunction globals)
typedef void (*YFunctionValueCallback)(YFunction *func, NSString *functionValue);
#define Y_LOGICALNAME_INVALID           YAPI_INVALID_STRING
#define Y_ADVERTISEDVALUE_INVALID       YAPI_INVALID_STRING
//--- (end of generated code: YFunction globals)

//--- (generated code: YModule globals)
typedef void (*YModuleLogCallback)(YModule *module, NSString *logline);
typedef void (*YModuleValueCallback)(YModule *func, NSString *functionValue);
#ifndef _Y_PERSISTENTSETTINGS_ENUM
#define _Y_PERSISTENTSETTINGS_ENUM
typedef enum {
    Y_PERSISTENTSETTINGS_LOADED = 0,
    Y_PERSISTENTSETTINGS_SAVED = 1,
    Y_PERSISTENTSETTINGS_MODIFIED = 2,
    Y_PERSISTENTSETTINGS_INVALID = -1,
} Y_PERSISTENTSETTINGS_enum;
#endif
#ifndef _Y_BEACON_ENUM
#define _Y_BEACON_ENUM
typedef enum {
    Y_BEACON_OFF = 0,
    Y_BEACON_ON = 1,
    Y_BEACON_INVALID = -1,
} Y_BEACON_enum;
#endif
#define Y_PRODUCTNAME_INVALID           YAPI_INVALID_STRING
#define Y_SERIALNUMBER_INVALID          YAPI_INVALID_STRING
#define Y_PRODUCTID_INVALID             YAPI_INVALID_UINT
#define Y_PRODUCTRELEASE_INVALID        YAPI_INVALID_UINT
#define Y_FIRMWARERELEASE_INVALID       YAPI_INVALID_STRING
#define Y_LUMINOSITY_INVALID            YAPI_INVALID_UINT
#define Y_UPTIME_INVALID                YAPI_INVALID_LONG
#define Y_USBCURRENT_INVALID            YAPI_INVALID_UINT
#define Y_REBOOTCOUNTDOWN_INVALID       YAPI_INVALID_INT
#define Y_USERVAR_INVALID               YAPI_INVALID_INT
//--- (end of generated code: YModule globals)

//--- (generated code: YSensor globals)
typedef void (*YSensorValueCallback)(YSensor *func, NSString *functionValue);
typedef void (*YSensorTimedReportCallback)(YSensor *func, YMeasure *measure);
#define Y_UNIT_INVALID                  YAPI_INVALID_STRING
#define Y_CURRENTVALUE_INVALID          YAPI_INVALID_DOUBLE
#define Y_LOWESTVALUE_INVALID           YAPI_INVALID_DOUBLE
#define Y_HIGHESTVALUE_INVALID          YAPI_INVALID_DOUBLE
#define Y_CURRENTRAWVALUE_INVALID       YAPI_INVALID_DOUBLE
#define Y_LOGFREQUENCY_INVALID          YAPI_INVALID_STRING
#define Y_REPORTFREQUENCY_INVALID       YAPI_INVALID_STRING
#define Y_CALIBRATIONPARAM_INVALID      YAPI_INVALID_STRING
#define Y_RESOLUTION_INVALID            YAPI_INVALID_DOUBLE
#define Y_SENSORSTATE_INVALID           YAPI_INVALID_INT
//--- (end of generated code: YSensor globals)

//--- (generated code: YDataStream globals)
//--- (end of generated code: YDataStream globals)

//--- (generated code: YFirmwareUpdate globals)
//--- (end of generated code: YFirmwareUpdate globals)

//--- (generated code: YMeasure globals)
//--- (end of generated code: YMeasure globals)

//--- (generated code: YDataSet globals)
//--- (end of generated code: YDataSet globals)



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
    YAPI_FUN_TIMEDREPORT,
    YAPI_FUN_REFRESH,
    YAPI_HUB_DISCOVERY,
    YAPI_INVALID
} yapiEventType;

@interface  YapiEvent : NSObject
{
    yapiEventType            _type;
    YModule*            _module;
    YFunction*          _function;
    YSensor*            _sensor;
    double              _timestamp;
    NSMutableArray*     _report;
    NSString*           _value;
    NSString*           _serial;
    NSString*           _url;
}

-(void) invokeFunctionEvent;
-(void) invokePlugEvent;
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

// internal helper function
int _ystrpos(NSString* haystack, NSString* needle);


//
// YAPI Context
//
// This class provides Objective-C style entry points to lowlevcel functions defined to yapi.h

@interface YAPI : NSObject

// internal methode do not call directly
+(id)       _getCalibrationHandler:(int) calibType;
+(double)   _decimalToDouble:(s16) val;
+(s16)      _doubleToDecimal:(double) val;
+(NSMutableArray*) _decodeWords:(NSString*)s;
+(NSMutableArray*) _decodeFloats:(NSString*)s;
+(NSString*) _bin2HexStr:(NSMutableData*)s;
+(NSMutableData*) _hexStr2Bin:(NSString*)s;
+(NSMutableData*) _binMerge:(NSData*)dataA :(NSData*)dataB;

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
 * the API have something to say. Quite useful to debug the API.
 *
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterLogFunction:(yLogCallback) logfun;

/**
 * Register a callback function, to be called each time
 * a device is plugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterDeviceArrivalCallback:(yDeviceUpdateCallback) arrivalCallback;

/**
 * (Objective-C only) Register an object that must follow the protocol YDeviceHotPlug. The methods
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param object : an object that must follow the protocol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */
 +(void)        SetDelegate:(id)object;


/**
 * Register a callback function, to be called each time
 * a device is unplugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterDeviceRemovalCallback:(yDeviceUpdateCallback) removalCallback;

 +(void)        RegisterDeviceChangeCallback:(yDeviceUpdateCallback) removalCallback;

/**
 * Register a callback function, to be called each time an Network Hub send
 * an SSDP message. The callback has two string parameter, the first one
 * contain the serial number of the hub and the second contain the URL of the
 * network hub (this URL can be passed to RegisterHub). This callback will be invoked
 * while yUpdateDeviceList is running. You will have to call this function on a regular basis.
 *
 * @param hubDiscoveryCallback : a procedure taking two string parameter, or null
 *         to unregister a previously registered  callback.
 */
 +(void)        RegisterHubDiscoveryCallback:(YHubDiscoveryCallback) hubDiscoveryCallback;


/**
 * Setup the Yoctopuce library to use modules connected on a given machine. The
 * parameter will determine how the API will work. Use the following values:
 *
 * <b>usb</b>: When the usb keyword is used, the API will work with
 * devices connected directly to the USB bus. Some programming languages such a Javascript,
 * PHP, and Java don't provide direct access to USB hardware, so usb will
 * not work with these. In this case, use a VirtualHub or a networked YoctoHub (see below).
 *
 * <b><i>x.x.x.x</i></b> or <b><i>hostname</i></b>: The API will use the devices connected to the
 * host with the given IP address or hostname. That host can be a regular computer
 * running a VirtualHub, or a networked YoctoHub such as YoctoHub-Ethernet or
 * YoctoHub-Wireless. If you want to use the VirtualHub running on you local
 * computer, use the IP address 127.0.0.1.
 *
 * <b>callback</b>: that keyword make the API run in "<i>HTTP Callback</i>" mode.
 * This a special mode allowing to take control of Yoctopuce devices
 * through a NAT filter when using a VirtualHub or a networked YoctoHub. You only
 * need to configure your hub to call your server script on a regular basis.
 * This mode is currently available for PHP and Node.JS only.
 *
 * Be aware that only one application can use direct USB access at a
 * given time on a machine. Multiple access would cause conflicts
 * while trying to access the USB modules. In particular, this means
 * that you must stop the VirtualHub software before starting
 * an application that uses direct USB access. The workaround
 * for this limitation is to setup the library to use the VirtualHub
 * rather than direct USB access.
 *
 * If access control has been activated on the hub, virtual or not, you want to
 * reach, the URL parameter should look like:
 *
 * http://username:password@address:port
 *
 * You can call <i>RegisterHub</i> several times to connect to several machines.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    RegisterHub:(NSString *) rooturl :(NSError**) error;

/**
 * Fault-tolerant alternative to RegisterHub(). This function has the same
 * purpose and same arguments as RegisterHub(), but does not trigger
 * an error when the selected hub is not available at the time of the function call.
 * This makes it possible to register a network hub independently of the current
 * connectivity, and to try to contact it only when a device is actively needed.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
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
 * Test if the hub is reachable. This method do not register the hub, it only test if the
 * hub is usable. The url parameter follow the same convention as the RegisterHub
 * method. This method is useful to verify the authentication parameters for a hub. It
 * is possible to force this method to return after mstimeout milliseconds.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param mstimeout : the number of millisecond available to test the connection.
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
+(YRETCODE)         TestHub:(NSString*) rooturl :(int)mstimeout :(NSError**) error;

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
 * consume CPU cycles significantly. The processor is left available for
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
 * Force a hub discovery, if a callback as been registered with yRegisterDeviceRemovalCallback it
 * will be called for each net work hub that will respond to the discovery.
 *
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
 +(YRETCODE)    TriggerHubDiscovery:(NSError**) error;

/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the millisecond as timebase.
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
+(void)         PlugDevice:(YDEV_DESCR)devdescr;
-(YRETCODE)     HTTPRequestAsync:(NSString*)request :(HTTPRequestCallback)callback :(NSMutableDictionary*)context :(NSError**)error;
-(YRETCODE)     HTTPRequest:(NSString*)request :(NSMutableData**)buffer :(NSError**)error;
-(YRETCODE)     requestAPI:(NSString**)apires :(NSError**)error;
-(void)         clearCache;
-(YRETCODE)     getFunctions:(NSArray**)functions :(NSError**)error;
@end

//--- (generated code: YFunction class start)
/**
 * YFunction Class: Common function interface
 *
 * This is the parent class for all public objects representing device functions documented in
 * the high-level programming API. This abstract class does all the real job, but without
 * knowledge of the specific function attributes.
 *
 * Instantiating a child class of YFunction does not cause any communication.
 * The instance simply keeps track of its function identifier, and will dynamically bind
 * to a matching device at the time it is really being used to read or set an attribute.
 * In order to allow true hot-plug replacement of one device by another, the binding stay
 * dynamic through the life of the object.
 *
 * The YFunction class implements a generic high-level cache for the attribute values of
 * the specified function, pre-parsed from the REST API string.
 */
@interface YFunction : NSObject
//--- (end of generated code: YFunction class start)
{
@protected
    // Protected attributes
    NSString    *_className;
    NSString    *_func;
    NSError     *_lastError;
    YFUN_DESCR  _fundescr;
    id          _userData;
    NSMutableDictionary*    _dataStreams;
//--- (generated code: YFunction attributes declaration)
    NSString*       _logicalName;
    NSString*       _advertisedValue;
    YFunctionValueCallback _valueCallbackFunction;
    u64             _cacheExpiration;
    NSString*       _serial;
    NSString*       _funId;
    NSString*       _hwId;
//--- (end of generated code: YFunction attributes declaration)
}

// Constructor is protected. Use the device-specific factory function to instantiate
-(id) initWith:(NSString*) func;

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

-(NSString*)   _escapeAttr:(NSString*)attr;
// Method used to change attributes
-(YRETCODE)    _buildSetRequest:(NSString*)changeattr  :(NSString*)changeval :(NSString**)request :(NSError**)error;
// Method used to change attributes
-(YRETCODE)    _setAttr:(NSString*)attrname :(NSString*)newvalue;
// Method used to send http request to the device (not the function)
-(NSMutableData*)     _download:(NSString*)url;
// Method used to upload a file to the device
-(YRETCODE)    _upload:(NSString*)path :(NSData*)content;
-(NSString*)   _json_get_key:(NSData*)json :(NSString*)data;
-(NSMutableArray*) _json_get_array:(NSData*)json;
-(NSString*)   _json_get_string:(NSData*)json;
-(NSString*)   _get_json_path:(NSString*)json :(NSString*)path;
-(NSString*)   _decode_json_string:(NSString*)json;

// Method used to cache DataStream objects (new DataLogger)
-(YDataStream*) _findDataStream:(YDataSet*)dataset :(NSString*)def;
// Method used to clear cache of DataStream object (undocumented)
-(void) _clearDataStreamCache;

+(id) _FindFromCache:(NSString*)classname :(NSString*)func;
+(void) _AddToCache:(NSString*)classname :(NSString*)func :(id)obj;
+(void) _ClearCache;
+(void) _UpdateValueCallbackList:(YFunction*) function :(BOOL) add;
+(void) _UpdateTimedReportCallbackList:(YFunction*) function :(BOOL) add;

//--- (generated code: YFunction private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YFunction private methods declaration)

//--- (generated code: YFunction public methods declaration)
/**
 * Returns the logical name of the function.
 *
 * @return a string corresponding to the logical name of the function
 *
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*)     get_logicalName;


-(NSString*) logicalName;
/**
 * Changes the logical name of the function. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the logical name of the function
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logicalName:(NSString*) newval;
-(int)     setLogicalName:(NSString*) newval;

/**
 * Returns a short string representing the current state of the function.
 *
 * @return a string corresponding to a short string representing the current state of the function
 *
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*)     get_advertisedValue;


-(NSString*) advertisedValue;
/**
 * Retrieves a function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YFunction.isOnline() to test if the function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the function
 *
 * @return a YFunction object allowing you to drive the function.
 */
+(YFunction*)     FindFunction:(NSString*)func;

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
-(int)     registerValueCallback:(YFunctionValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     _parserHelper;


/**
 * comment from .yc definition
 */
-(YFunction*) nextFunction;
/**
 * comment from .yc definition
 */
+(YFunction*) FirstFunction;
//--- (end of generated code: YFunction public methods declaration)

/**
 * Returns a descriptive text that identifies the function.
 * The text always includes the class name, and may include as well
 * either the logical name of the function or its hardware identifier.
 *
 * @return a string that describes the function
 */
-(NSString*)    description;
/**
 * Returns a short text that describes unambiguously the instance of the function in the form
 * TYPE(NAME)=SERIAL&#46;FUNCTIONID.
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
 * (for example: MyCustomName.relay1)
 *
 * @return a string that uniquely identifies the function using logical names
 *         (ex: MyCustomName.relay1)
 *
 * On failure, throws an exception or returns  Y_FRIENDLYNAME_INVALID.
 */
-(NSString*)    get_friendlyName;
-(NSString*)    friendlyName;

/**
 * Returns the unique hardware identifier of the function in the form SERIAL.FUNCTIONID.
 * The unique hardware identifier is composed of the device serial
 * number and of the hardware identifier of the function (for example RELAYLO1-123456.relay1).
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
 * Returns the error message of the latest error with the function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 *
 * @return a string corresponding to the latest error message that occured while
 *         using the function object
 */
-(NSString*)   get_errorMessage;
-(NSString*)   errorMessage;

/**
 * Checks if the function is currently reachable, without raising any error.
 * If there is a cached value for the function in cache, that has not yet
 * expired, the device is considered reachable.
 * No exception is raised if there is an error while trying to contact the
 * device hosting the function.
 *
 * @return true if the function can be reached, and false otherwise
 */
-(BOOL)        isOnline;

/**
 * Preloads the function cache with a specified validity duration.
 * By default, whenever accessing a device, all function attributes
 * are kept in cache for the standard duration (5 ms). This method can be
 * used to temporarily mark the cache as valid for a longer period, in order
 * to reduce network traffic for instance.
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
 * Invalidate the cache. Invalidate the cache of the function attributes. Force the
 * next call to get_xxx() or loadxxx() to use value that come from the device..
 *
 * @noreturn
 */
-(void)    clearCache;

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
-(id)    get_userData;
-(id)    userData;


/**
 * Stores a user context provided as argument in the userData attribute of the function.
 * This attribute is never touched by the API, and is at disposal of the caller to store a context.
 *
 * @param data : any kind of object to be stored
 * @noreturn
 */
-(void)     set_userData:(id) data;
-(void)     setUserData:(id) data;




@end


//--- (generated code: YModule class start)
/**
 * YModule Class: Module control interface
 *
 * This interface is identical for all Yoctopuce USB modules.
 * It can be used to control the module global parameters, and
 * to enumerate the functions provided by each module.
 */
@interface YModule : YFunction
//--- (end of generated code: YModule class start)
{
@protected
//--- (generated code: YModule attributes declaration)
    NSString*       _productName;
    NSString*       _serialNumber;
    int             _productId;
    int             _productRelease;
    NSString*       _firmwareRelease;
    Y_PERSISTENTSETTINGS_enum _persistentSettings;
    int             _luminosity;
    Y_BEACON_enum   _beacon;
    s64             _upTime;
    int             _usbCurrent;
    int             _rebootCountdown;
    int             _userVar;
    YModuleValueCallback _valueCallbackModule;
    YModuleLogCallback _logCallback;
//--- (end of generated code: YModule attributes declaration)
}


// Method used to retrieve details of the nth function of our device
-(YRETCODE)        _getFunction:(int) idx  :(NSString**)serial  :(NSString**)funcId :(NSString**)funcName :(NSString**)funcVal :(NSError**)error;

//--- (generated code: YModule private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YModule private methods declaration)

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

/**
 * Registers a device log callback function. This callback will be called each time
 * that a module sends a new log message. Mostly useful to debug a Yoctopuce module.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the module object that emitted the log message, and the character string containing the log.
 * @noreturn
 */
-(void)            registerLogCallback:(YModuleLogCallback) callback;


-(YModuleLogCallback) get_logCallback;



//--- (generated code: YModule public methods declaration)
/**
 * Returns the commercial name of the module, as set by the factory.
 *
 * @return a string corresponding to the commercial name of the module, as set by the factory
 *
 * On failure, throws an exception or returns Y_PRODUCTNAME_INVALID.
 */
-(NSString*)     get_productName;


-(NSString*) productName;
/**
 * Returns the serial number of the module, as set by the factory.
 *
 * @return a string corresponding to the serial number of the module, as set by the factory
 *
 * On failure, throws an exception or returns Y_SERIALNUMBER_INVALID.
 */
-(NSString*)     get_serialNumber;


-(NSString*) serialNumber;
/**
 * Returns the USB device identifier of the module.
 *
 * @return an integer corresponding to the USB device identifier of the module
 *
 * On failure, throws an exception or returns Y_PRODUCTID_INVALID.
 */
-(int)     get_productId;


-(int) productId;
/**
 * Returns the hardware release version of the module.
 *
 * @return an integer corresponding to the hardware release version of the module
 *
 * On failure, throws an exception or returns Y_PRODUCTRELEASE_INVALID.
 */
-(int)     get_productRelease;


-(int) productRelease;
/**
 * Returns the version of the firmware embedded in the module.
 *
 * @return a string corresponding to the version of the firmware embedded in the module
 *
 * On failure, throws an exception or returns Y_FIRMWARERELEASE_INVALID.
 */
-(NSString*)     get_firmwareRelease;


-(NSString*) firmwareRelease;
/**
 * Returns the current state of persistent module settings.
 *
 * @return a value among Y_PERSISTENTSETTINGS_LOADED, Y_PERSISTENTSETTINGS_SAVED and
 * Y_PERSISTENTSETTINGS_MODIFIED corresponding to the current state of persistent module settings
 *
 * On failure, throws an exception or returns Y_PERSISTENTSETTINGS_INVALID.
 */
-(Y_PERSISTENTSETTINGS_enum)     get_persistentSettings;


-(Y_PERSISTENTSETTINGS_enum) persistentSettings;
-(int)     set_persistentSettings:(Y_PERSISTENTSETTINGS_enum) newval;
-(int)     setPersistentSettings:(Y_PERSISTENTSETTINGS_enum) newval;

/**
 * Returns the luminosity of the  module informative leds (from 0 to 100).
 *
 * @return an integer corresponding to the luminosity of the  module informative leds (from 0 to 100)
 *
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int)     get_luminosity;


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
-(Y_BEACON_enum)     get_beacon;


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
-(s64)     get_upTime;


-(s64) upTime;
/**
 * Returns the current consumed by the module on the USB bus, in milli-amps.
 *
 * @return an integer corresponding to the current consumed by the module on the USB bus, in milli-amps
 *
 * On failure, throws an exception or returns Y_USBCURRENT_INVALID.
 */
-(int)     get_usbCurrent;


-(int) usbCurrent;
/**
 * Returns the remaining number of seconds before the module restarts, or zero when no
 * reboot has been scheduled.
 *
 * @return an integer corresponding to the remaining number of seconds before the module restarts, or zero when no
 *         reboot has been scheduled
 *
 * On failure, throws an exception or returns Y_REBOOTCOUNTDOWN_INVALID.
 */
-(int)     get_rebootCountdown;


-(int) rebootCountdown;
-(int)     set_rebootCountdown:(int) newval;
-(int)     setRebootCountdown:(int) newval;

/**
 * Returns the value previously stored in this attribute.
 * On startup and after a device reboot, the value is always reset to zero.
 *
 * @return an integer corresponding to the value previously stored in this attribute
 *
 * On failure, throws an exception or returns Y_USERVAR_INVALID.
 */
-(int)     get_userVar;


-(int) userVar;
/**
 * Returns the value previously stored in this attribute.
 * On startup and after a device reboot, the value is always reset to zero.
 *
 * @param newval : an integer
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_userVar:(int) newval;
-(int)     setUserVar:(int) newval;

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
+(YModule*)     FindModule:(NSString*)func;

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
-(int)     registerValueCallback:(YModuleValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Saves current settings in the nonvolatile memory of the module.
 * Warning: the number of allowed save operations during a module life is
 * limited (about 100000 cycles). Do not call this function within a loop.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     saveToFlash;

/**
 * Reloads the settings stored in the nonvolatile memory, as
 * when the module is powered on.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     revertFromFlash;

/**
 * Schedules a simple module reboot after the given number of seconds.
 *
 * @param secBeforeReboot : number of seconds before rebooting
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     reboot:(int)secBeforeReboot;

/**
 * Schedules a module reboot into special firmware update mode.
 *
 * @param secBeforeReboot : number of seconds before rebooting
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     triggerFirmwareUpdate:(int)secBeforeReboot;

/**
 * Tests whether the byn file is valid for this module. This method is useful to test if the module
 * needs to be updated.
 * It is possible to pass a directory as argument instead of a file. In this case, this method returns
 * the path of the most recent
 * appropriate byn file. If the parameter onlynew is true, the function discards firmware that are
 * older or equal to
 * the installed firmware.
 *
 * @param path    : the path of a byn file or a directory that contains byn files
 * @param onlynew : returns only files that are strictly newer
 *
 * @return : the path of the byn file to use or a empty string if no byn files matches the requirement
 *
 * On failure, throws an exception or returns a string that start with "error:".
 */
-(NSString*)     checkFirmware:(NSString*)path :(bool)onlynew;

/**
 * Prepares a firmware update of the module. This method returns a YFirmwareUpdate object which
 * handles the firmware update process.
 *
 * @param path : the path of the byn file to use.
 *
 * @return : A YFirmwareUpdate object or NULL on error.
 */
-(YFirmwareUpdate*)     updateFirmware:(NSString*)path;

/**
 * Returns all the settings and uploaded files of the module. Useful to backup all the logical names,
 * calibrations parameters,
 * and uploaded files of a connected module.
 *
 * @return a binary buffer with all the settings.
 *
 * On failure, throws an exception or returns an binary object of size 0.
 */
-(NSMutableData*)     get_allSettings;

-(int)     loadThermistorExtra:(NSString*)funcId :(NSString*)jsonExtra;

-(int)     set_extraSettings:(NSString*)jsonExtra;

/**
 * Restores all the settings and uploaded files of the module. Useful to restore all the logical names
 * and calibrations parameters, uploaded
 * files etc.. of a module from a backup.Remember to call the saveToFlash() method of the module if the
 * modifications must be kept.
 *
 * @param settings : a binary buffer with all the settings.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_allSettingsAndFiles:(NSData*)settings;

/**
 * Test if the device has a specific function. This method took an function identifier
 * and return a boolean.
 *
 * @param funcId : the requested function identifier
 *
 * @return : true if the device has the function identifier
 */
-(bool)     hasFunction:(NSString*)funcId;

/**
 * Retrieve all hardware identifier that match the type passed in argument.
 *
 * @param funType : The type of function (Relay, LightSensor, Voltage,...)
 *
 * @return : A array of string.
 */
-(NSMutableArray*)     get_functionIds:(NSString*)funType;

-(NSMutableData*)     _flattenJsonStruct:(NSData*)jsoncomplex;

-(int)     calibVersion:(NSString*)cparams;

-(int)     calibScale:(NSString*)unit_name :(NSString*)sensorType;

-(int)     calibOffset:(NSString*)unit_name;

-(NSString*)     calibConvert:(NSString*)param :(NSString*)currentFuncValue :(NSString*)unit_name :(NSString*)sensorType;

/**
 * Restores all the settings of the module. Useful to restore all the logical names and calibrations parameters
 * of a module from a backup.Remember to call the saveToFlash() method of the module if the
 * modifications must be kept.
 *
 * @param settings : a binary buffer with all the settings.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_allSettings:(NSData*)settings;

/**
 * Downloads the specified built-in file and returns a binary buffer with its content.
 *
 * @param pathname : name of the new file to load
 *
 * @return a binary buffer with the file content
 *
 * On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSMutableData*)     download:(NSString*)pathname;

/**
 * Returns the icon of the module. The icon is a PNG image and does not
 * exceeds 1536 bytes.
 *
 * @return a binary buffer with module icon, in png format.
 *         On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSMutableData*)     get_icon2d;

/**
 * Returns a string with last logs of the module. This method return only
 * logs that are still in the module.
 *
 * @return a string with last logs of the module.
 *         On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSString*)     get_lastLogs;


/**
 * Continues the module enumeration started using yFirstModule().
 *
 * @return a pointer to a YModule object, corresponding to
 *         the next module found, or a null pointer
 *         if there are no more modules to enumerate.
 */
-(YModule*) nextModule;
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
//--- (end of generated code: YModule public methods declaration)

@end


//--- (generated code: YSensor class start)
/**
 * YSensor Class: Sensor function interface
 *
 * The YSensor class is the parent class for all Yoctopuce sensors. It can be
 * used to read the current value and unit of any sensor, read the min/max
 * value, configure autonomous recording frequency and access recorded data.
 * It also provide a function to register a callback invoked each time the
 * observed value changes, or at a predefined interval. Using this class rather
 * than a specific subclass makes it possible to create generic applications
 * that work with any Yoctopuce sensor, even those that do not yet exist.
 * Note: The YAnButton class is the only analog input which does not inherit
 * from YSensor.
 */
@interface YSensor : YFunction
//--- (end of generated code: YSensor class start)
{
@protected
//--- (generated code: YSensor attributes declaration)
    NSString*       _unit;
    double          _currentValue;
    double          _lowestValue;
    double          _highestValue;
    double          _currentRawValue;
    NSString*       _logFrequency;
    NSString*       _reportFrequency;
    NSString*       _calibrationParam;
    double          _resolution;
    int             _sensorState;
    YSensorValueCallback _valueCallbackSensor;
    YSensorTimedReportCallback _timedReportCallbackSensor;
    double          _prevTimedReport;
    double          _iresol;
    double          _offset;
    double          _scale;
    double          _decexp;
    bool            _isScal;
    bool            _isScal32;
    int             _caltyp;
    NSMutableArray* _calpar;
    NSMutableArray* _calraw;
    NSMutableArray* _calref;
    id              _calhdl;
//--- (end of generated code: YSensor attributes declaration)
}
// Constructor is protected, use yFindSensor factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YSensor private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YSensor private methods declaration)

// Method used to encode calibration points into fixed-point 16-bit integers or decimal floating-point

-(NSString*) _encodeCalibrationPoints:(NSArray*)rawValues :(NSArray*)refValues :(NSString*)actualCparams;
// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
-(int) _decodeCalibrationPoints:(NSString*)calibParams :(NSMutableArray*)intPt :(NSMutableArray*)rawPt :(NSMutableArray*)calPt;



//--- (generated code: YSensor public methods declaration)
/**
 * Returns the measuring unit for the measure.
 *
 * @return a string corresponding to the measuring unit for the measure
 *
 * On failure, throws an exception or returns Y_UNIT_INVALID.
 */
-(NSString*)     get_unit;


-(NSString*) unit;
/**
 * Returns the current value of the measure, in the specified unit, as a floating point number.
 *
 * @return a floating point number corresponding to the current value of the measure, in the specified
 * unit, as a floating point number
 *
 * On failure, throws an exception or returns Y_CURRENTVALUE_INVALID.
 */
-(double)     get_currentValue;


-(double) currentValue;
/**
 * Changes the recorded minimal value observed.
 *
 * @param newval : a floating point number corresponding to the recorded minimal value observed
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_lowestValue:(double) newval;
-(int)     setLowestValue:(double) newval;

/**
 * Returns the minimal value observed for the measure since the device was started.
 *
 * @return a floating point number corresponding to the minimal value observed for the measure since
 * the device was started
 *
 * On failure, throws an exception or returns Y_LOWESTVALUE_INVALID.
 */
-(double)     get_lowestValue;


-(double) lowestValue;
/**
 * Changes the recorded maximal value observed.
 *
 * @param newval : a floating point number corresponding to the recorded maximal value observed
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_highestValue:(double) newval;
-(int)     setHighestValue:(double) newval;

/**
 * Returns the maximal value observed for the measure since the device was started.
 *
 * @return a floating point number corresponding to the maximal value observed for the measure since
 * the device was started
 *
 * On failure, throws an exception or returns Y_HIGHESTVALUE_INVALID.
 */
-(double)     get_highestValue;


-(double) highestValue;
/**
 * Returns the uncalibrated, unrounded raw value returned by the sensor, in the specified unit, as a
 * floating point number.
 *
 * @return a floating point number corresponding to the uncalibrated, unrounded raw value returned by
 * the sensor, in the specified unit, as a floating point number
 *
 * On failure, throws an exception or returns Y_CURRENTRAWVALUE_INVALID.
 */
-(double)     get_currentRawValue;


-(double) currentRawValue;
/**
 * Returns the datalogger recording frequency for this function, or "OFF"
 * when measures are not stored in the data logger flash memory.
 *
 * @return a string corresponding to the datalogger recording frequency for this function, or "OFF"
 *         when measures are not stored in the data logger flash memory
 *
 * On failure, throws an exception or returns Y_LOGFREQUENCY_INVALID.
 */
-(NSString*)     get_logFrequency;


-(NSString*) logFrequency;
/**
 * Changes the datalogger recording frequency for this function.
 * The frequency can be specified as samples per second,
 * as sample per minute (for instance "15/m") or in samples per
 * hour (eg. "4/h"). To disable recording for this function, use
 * the value "OFF".
 *
 * @param newval : a string corresponding to the datalogger recording frequency for this function
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_logFrequency:(NSString*) newval;
-(int)     setLogFrequency:(NSString*) newval;

/**
 * Returns the timed value notification frequency, or "OFF" if timed
 * value notifications are disabled for this function.
 *
 * @return a string corresponding to the timed value notification frequency, or "OFF" if timed
 *         value notifications are disabled for this function
 *
 * On failure, throws an exception or returns Y_REPORTFREQUENCY_INVALID.
 */
-(NSString*)     get_reportFrequency;


-(NSString*) reportFrequency;
/**
 * Changes the timed value notification frequency for this function.
 * The frequency can be specified as samples per second,
 * as sample per minute (for instance "15/m") or in samples per
 * hour (eg. "4/h"). To disable timed value notifications for this
 * function, use the value "OFF".
 *
 * @param newval : a string corresponding to the timed value notification frequency for this function
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_reportFrequency:(NSString*) newval;
-(int)     setReportFrequency:(NSString*) newval;

-(NSString*)     get_calibrationParam;


-(NSString*) calibrationParam;
-(int)     set_calibrationParam:(NSString*) newval;
-(int)     setCalibrationParam:(NSString*) newval;

/**
 * Changes the resolution of the measured physical values. The resolution corresponds to the numerical precision
 * when displaying value. It does not change the precision of the measure itself.
 *
 * @param newval : a floating point number corresponding to the resolution of the measured physical values
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_resolution:(double) newval;
-(int)     setResolution:(double) newval;

/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the measures, which is not always the same as the actual precision of the sensor.
 *
 * @return a floating point number corresponding to the resolution of the measured values
 *
 * On failure, throws an exception or returns Y_RESOLUTION_INVALID.
 */
-(double)     get_resolution;


-(double) resolution;
/**
 * Returns the sensor health state code, which is zero when there is an up-to-date measure
 * available or a positive code if the sensor is not able to provide a measure right now.
 *
 * @return an integer corresponding to the sensor health state code, which is zero when there is an
 * up-to-date measure
 *         available or a positive code if the sensor is not able to provide a measure right now
 *
 * On failure, throws an exception or returns Y_SENSORSTATE_INVALID.
 */
-(int)     get_sensorState;


-(int) sensorState;
/**
 * Retrieves a sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSensor.isOnline() to test if the sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the sensor
 *
 * @return a YSensor object allowing you to drive the sensor.
 */
+(YSensor*)     FindSensor:(NSString*)func;

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
-(int)     registerValueCallback:(YSensorValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(int)     _parserHelper;

/**
 * Checks if the sensor is currently able to provide an up-to-date measure.
 * Returns false if the device is unreachable, or if the sensor does not have
 * a current measure to transmit. No exception is raised if there is an error
 * while trying to contact the device hosting $THEFUNCTION$.
 *
 * @return true if the sensor can provide an up-to-date measure, and false otherwise
 */
-(bool)     isSensorReady;

/**
 * Starts the data logger on the device. Note that the data logger
 * will only save the measures on this sensor if the logFrequency
 * is not set to "OFF".
 *
 * @return YAPI_SUCCESS if the call succeeds.
 */
-(int)     startDataLogger;

/**
 * Stops the datalogger on the device.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 */
-(int)     stopDataLogger;

/**
 * Retrieves a DataSet object holding historical data for this
 * sensor, for a specified time interval. The measures will be
 * retrieved from the data logger, which must have been turned
 * on at the desired time. See the documentation of the DataSet
 * class for information on how to get an overview of the
 * recorded data, and how to load progressively a large set
 * of measures from the data logger.
 *
 * This function only works if the device uses a recent firmware,
 * as DataSet objects are not supported by firmwares older than
 * version 13000.
 *
 * @param startTime : the start of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any meaasure, without initial limit.
 * @param endTime : the end of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any meaasure, without ending limit.
 *
 * @return an instance of YDataSet, providing access to historical
 *         data. Past measures can be loaded progressively
 *         using methods from the YDataSet object.
 */
-(YDataSet*)     get_recordedData:(s64)startTime :(s64)endTime;

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int)     registerTimedReportCallback:(YSensorTimedReportCallback)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;

/**
 * Configures error correction data points, in particular to compensate for
 * a possible perturbation of the measure caused by an enclosure. It is possible
 * to configure up to five correction points. Correction points must be provided
 * in ascending order, and be in the range of the sensor. The device will automatically
 * perform a linear interpolation of the error correction between specified
 * points. Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * For more information on advanced capabilities to refine the calibration of
 * sensors, please contact support@yoctopuce.com.
 *
 * @param rawValues : array of floating point numbers, corresponding to the raw
 *         values returned by the sensor for the correction points.
 * @param refValues : array of floating point numbers, corresponding to the corrected
 *         values for the correction points.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     calibrateFromPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues;

/**
 * Retrieves error correction data points previously entered using the method
 * calibrateFromPoints.
 *
 * @param rawValues : array of floating point numbers, that will be filled by the
 *         function with the raw sensor values for the correction points.
 * @param refValues : array of floating point numbers, that will be filled by the
 *         function with the desired values for the correction points.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     loadCalibrationPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues;

-(NSString*)     _encodeCalibrationPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues;

-(double)     _applyCalibration:(double)rawValue;

-(YMeasure*)     _decodeTimedReport:(double)timestamp :(NSMutableArray*)report;

-(double)     _decodeVal:(int)w;

-(double)     _decodeAvg:(int)dw;


/**
 * Continues the enumeration of sensors started using yFirstSensor().
 *
 * @return a pointer to a YSensor object, corresponding to
 *         a sensor currently online, or a null pointer
 *         if there are no more sensors to enumerate.
 */
-(YSensor*) nextSensor;
/**
 * Starts the enumeration of sensors currently accessible.
 * Use the method YSensor.nextSensor() to iterate on
 * next sensors.
 *
 * @return a pointer to a YSensor object, corresponding to
 *         the first sensor currently online, or a null pointer
 *         if there are none.
 */
+(YSensor*) FirstSensor;
//--- (end of generated code: YSensor public methods declaration)

@end


//--- (generated code: YFirmwareUpdate class start)
/**
 * YFirmwareUpdate Class: Control interface for the firmware update process
 *
 * The YFirmwareUpdate class let you control the firmware update of a Yoctopuce
 * module. This class should not be instantiate directly, instead the method
 * updateFirmware should be called to get an instance of YFirmwareUpdate.
 */
@interface YFirmwareUpdate : NSObject
//--- (end of generated code: YFirmwareUpdate class start)
{
@protected
//--- (generated code: YFirmwareUpdate attributes declaration)
    NSString*       _serial;
    NSData*         _settings;
    NSString*       _firmwarepath;
    NSString*       _progress_msg;
    int             _progress_c;
    int             _progress;
    int             _restore_step;
//--- (end of generated code: YFirmwareUpdate attributes declaration)
}


-(id)   initWith:(NSString*)serial :(NSString*)path :(NSData*)settings;

//--- (generated code: YFirmwareUpdate private methods declaration)
//--- (end of generated code: YFirmwareUpdate private methods declaration)
//--- (generated code: YFirmwareUpdate public methods declaration)
-(int)     _processMore:(int)newupdate;

/**
 * Retruns a list of all the modules in "update" mode. Only USB connected
 * devices are listed. For modules connected to a YoctoHub, you must
 * connect yourself to the YoctoHub web interface.
 *
 * @return an array of strings containing the serial list of module in "update" mode.
 */
+(NSMutableArray*)     GetAllBootLoaders;

/**
 * Test if the byn file is valid for this module. It's possible to pass an directory instead of a file.
 * In this case this method return the path of the most recent appropriate byn file. This method will
 * ignore firmware that are older than mintrelase.
 *
 * @param serial  : the serial number of the module to update
 * @param path    : the path of a byn file or a directory that contain byn files
 * @param minrelease : an positif integer
 *
 * @return : the path of the byn file to use or a empty string if no byn files match the requirement
 *
 * On failure, returns a string that start with "error:".
 */
+(NSString*)     CheckFirmware:(NSString*)serial :(NSString*)path :(int)minrelease;

/**
 * Returns the progress of the firmware update, on a scale from 0 to 100. When the object is
 * instantiated, the progress is zero. The value is updated during the firmware update process until
 * the value of 100 is reached. The 100 value means that the firmware update was completed
 * successfully. If an error occurs during the firmware update, a negative value is returned, and the
 * error message can be retrieved with get_progressMessage.
 *
 * @return an integer in the range 0 to 100 (percentage of completion)
 *         or a negative error code in case of failure.
 */
-(int)     get_progress;

/**
 * Returns the last progress message of the firmware update process. If an error occurs during the
 * firmware update process, the error message is returned
 *
 * @return a string  with the latest progress message, or the error message.
 */
-(NSString*)     get_progressMessage;

/**
 * Starts the firmware update process. This method starts the firmware update process in background. This method
 * returns immediately. You can monitor the progress of the firmware update with the get_progress()
 * and get_progressMessage() methods.
 *
 * @return an integer in the range 0 to 100 (percentage of completion),
 *         or a negative error code in case of failure.
 *
 * On failure returns a negative error code.
 */
-(int)     startUpdate;


//--- (end of generated code: YFirmwareUpdate public methods declaration)

@end

#define Y_DATA_INVALID                  (-DBL_MAX)
#define Y_DURATION_INVALID              (-1)


//--- (generated code: YDataStream class start)
/**
 * YDataStream Class: Unformatted data sequence
 *
 * YDataStream objects represent bare recorded measure sequences,
 * exactly as found within the data logger present on Yoctopuce
 * sensors.
 *
 * In most cases, it is not necessary to use YDataStream objects
 * directly, as the YDataSet objects (returned by the
 * get_recordedData() method from sensors and the
 * get_dataSets() method from the data logger) provide
 * a more convenient interface.
 */
@interface YDataStream : NSObject
//--- (end of generated code: YDataStream class start)
{
@protected
//--- (generated code: YDataStream attributes declaration)
    YFunction*      _parent;
    int             _runNo;
    s64             _utcStamp;
    int             _nCols;
    int             _nRows;
    int             _duration;
    NSMutableArray* _columnNames;
    NSString*       _functionId;
    bool            _isClosed;
    bool            _isAvg;
    bool            _isScal;
    bool            _isScal32;
    int             _decimals;
    double          _offset;
    double          _scale;
    int             _samplesPerHour;
    double          _minVal;
    double          _avgVal;
    double          _maxVal;
    double          _decexp;
    int             _caltyp;
    NSMutableArray* _calpar;
    NSMutableArray* _calraw;
    NSMutableArray* _calref;
    NSMutableArray* _values;
//--- (end of generated code: YDataStream attributes declaration)
    id                      _calhdl;

}
-(id)   initWith:(YFunction *)parent;
-(id)   initWith:(YFunction *)parent :(YDataSet*)dataset :(NSArray*) encoded;


//--- (generated code: YDataStream private methods declaration)
//--- (end of generated code: YDataStream private methods declaration)
//--- (generated code: YDataStream public methods declaration)
-(int)     _initFromDataSet:(YDataSet*)dataset :(NSMutableArray*)encoded;

-(int)     parse:(NSData*)sdata;

-(NSString*)     get_url;

-(int)     loadStream;

-(double)     _decodeVal:(int)w;

-(double)     _decodeAvg:(int)dw :(int)count;

-(bool)     isClosed;

/**
 * Returns the run index of the data stream. A run can be made of
 * multiple datastreams, for different time intervals.
 *
 * @return an unsigned number corresponding to the run index.
 */
-(int)     get_runIndex;

/**
 * Returns the relative start time of the data stream, measured in seconds.
 * For recent firmwares, the value is relative to the present time,
 * which means the value is always negative.
 * If the device uses a firmware older than version 13000, value is
 * relative to the start of the time the device was powered on, and
 * is always positive.
 * If you need an absolute UTC timestamp, use get_startTimeUTC().
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the start of the run and the beginning of this data
 *         stream.
 */
-(int)     get_startTime;

/**
 * Returns the start time of the data stream, relative to the Jan 1, 1970.
 * If the UTC time was not set in the datalogger at the time of the recording
 * of this data stream, this method returns 0.
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         stream (i.e. Unix time representation of the absolute time).
 */
-(s64)     get_startTimeUTC;

/**
 * Returns the number of milliseconds between two consecutive
 * rows of this data stream. By default, the data logger records one row
 * per second, but the recording frequency can be changed for
 * each device function
 *
 * @return an unsigned number corresponding to a number of milliseconds.
 */
-(int)     get_dataSamplesIntervalMs;

-(double)     get_dataSamplesInterval;

/**
 * Returns the number of data rows present in this stream.
 *
 * If the device uses a firmware older than version 13000,
 * this method fetches the whole data stream from the device
 * if not yet done, which can cause a little delay.
 *
 * @return an unsigned number corresponding to the number of rows.
 *
 * On failure, throws an exception or returns zero.
 */
-(int)     get_rowCount;

/**
 * Returns the number of data columns present in this stream.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 *
 * If the device uses a firmware older than version 13000,
 * this method fetches the whole data stream from the device
 * if not yet done, which can cause a little delay.
 *
 * @return an unsigned number corresponding to the number of columns.
 *
 * On failure, throws an exception or returns zero.
 */
-(int)     get_columnCount;

/**
 * Returns the title (or meaning) of each data column present in this stream.
 * In most case, the title of the data column is the hardware identifier
 * of the sensor that produced the data. For streams recorded at a lower
 * recording rate, the dataLogger stores the min, average and max value
 * during each measure interval into three columns with suffixes _min,
 * _avg and _max respectively.
 *
 * If the device uses a firmware older than version 13000,
 * this method fetches the whole data stream from the device
 * if not yet done, which can cause a little delay.
 *
 * @return a list containing as many strings as there are columns in the
 *         data stream.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_columnNames;

/**
 * Returns the smallest measure observed within this stream.
 * If the device uses a firmware older than version 13000,
 * this method will always return Y_DATA_INVALID.
 *
 * @return a floating-point number corresponding to the smallest value,
 *         or Y_DATA_INVALID if the stream is not yet complete (still recording).
 *
 * On failure, throws an exception or returns Y_DATA_INVALID.
 */
-(double)     get_minValue;

/**
 * Returns the average of all measures observed within this stream.
 * If the device uses a firmware older than version 13000,
 * this method will always return Y_DATA_INVALID.
 *
 * @return a floating-point number corresponding to the average value,
 *         or Y_DATA_INVALID if the stream is not yet complete (still recording).
 *
 * On failure, throws an exception or returns Y_DATA_INVALID.
 */
-(double)     get_averageValue;

/**
 * Returns the largest measure observed within this stream.
 * If the device uses a firmware older than version 13000,
 * this method will always return Y_DATA_INVALID.
 *
 * @return a floating-point number corresponding to the largest value,
 *         or Y_DATA_INVALID if the stream is not yet complete (still recording).
 *
 * On failure, throws an exception or returns Y_DATA_INVALID.
 */
-(double)     get_maxValue;

/**
 * Returns the approximate duration of this stream, in seconds.
 *
 * @return the number of seconds covered by this stream.
 *
 * On failure, throws an exception or returns Y_DURATION_INVALID.
 */
-(int)     get_duration;

/**
 * Returns the whole data set contained in the stream, as a bidimensional
 * table of numbers.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 *
 * This method fetches the whole data stream from the device,
 * if not yet done.
 *
 * @return a list containing as many elements as there are rows in the
 *         data stream. Each row itself is a list of floating-point
 *         numbers.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_dataRows;

/**
 * Returns a single measure from the data stream, specified by its
 * row and column index.
 * The meaning of the values present in each column can be obtained
 * using the method get_columnNames().
 *
 * This method fetches the whole data stream from the device,
 * if not yet done.
 *
 * @param row : row index
 * @param col : column index
 *
 * @return a floating-point number
 *
 * On failure, throws an exception or returns Y_DATA_INVALID.
 */
-(double)     get_data:(int)row :(int)col;


//--- (end of generated code: YDataStream public methods declaration)

@end

//--- (generated code: YMeasure class start)
/**
 * YMeasure Class: Measured value
 *
 * YMeasure objects are used within the API to represent
 * a value measured at a specified time. These objects are
 * used in particular in conjunction with the YDataSet class.
 */
@interface YMeasure : NSObject
//--- (end of generated code: YMeasure class start)
{
@protected
//--- (generated code: YMeasure attributes declaration)
    double          _start;
    double          _end;
    double          _minVal;
    double          _avgVal;
    double          _maxVal;
//--- (end of generated code: YMeasure attributes declaration)

}

-(id)   init;
-(id)   initWith:(double)start :(double)end :(double)minVal :(double)avgVal :(double)maxVal;


//--- (generated code: YMeasure private methods declaration)
//--- (end of generated code: YMeasure private methods declaration)
//--- (generated code: YMeasure public methods declaration)
/**
 * Returns the start time of the measure, relative to the Jan 1, 1970 UTC
 * (Unix timestamp). When the recording rate is higher then 1 sample
 * per second, the timestamp may have a fractional part.
 *
 * @return an floating point number corresponding to the number of seconds
 *         between the Jan 1, 1970 UTC and the beginning of this measure.
 */
-(double)     get_startTimeUTC;

/**
 * Returns the end time of the measure, relative to the Jan 1, 1970 UTC
 * (Unix timestamp). When the recording rate is higher than 1 sample
 * per second, the timestamp may have a fractional part.
 *
 * @return an floating point number corresponding to the number of seconds
 *         between the Jan 1, 1970 UTC and the end of this measure.
 */
-(double)     get_endTimeUTC;

/**
 * Returns the smallest value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the smallest value observed.
 */
-(double)     get_minValue;

/**
 * Returns the average value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the average value observed.
 */
-(double)     get_averageValue;

/**
 * Returns the largest value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the largest value observed.
 */
-(double)     get_maxValue;


//--- (end of generated code: YMeasure public methods declaration)

-(NSDate*)       get_startTimeUTC_asNSDate;
-(NSDate*)       get_endTimeUTC_asNSDate;

@end

//--- (generated code: YDataSet class start)
/**
 * YDataSet Class: Recorded data sequence
 *
 * YDataSet objects make it possible to retrieve a set of recorded measures
 * for a given sensor and a specified time interval. They can be used
 * to load data points with a progress report. When the YDataSet object is
 * instantiated by the get_recordedData()  function, no data is
 * yet loaded from the module. It is only when the loadMore()
 * method is called over and over than data will be effectively loaded
 * from the dataLogger.
 *
 * A preview of available measures is available using the function
 * get_preview() as soon as loadMore() has been called
 * once. Measures themselves are available using function get_measures()
 * when loaded by subsequent calls to loadMore().
 *
 * This class can only be used on devices that use a recent firmware,
 * as YDataSet objects are not supported by firmwares older than version 13000.
 */
@interface YDataSet : NSObject
//--- (end of generated code: YDataSet class start)
{
@protected
//--- (generated code: YDataSet attributes declaration)
    YFunction*      _parent;
    NSString*       _hardwareId;
    NSString*       _functionId;
    NSString*       _unit;
    s64             _startTime;
    s64             _endTime;
    int             _progress;
    NSMutableArray* _calib;
    NSMutableArray* _streams;
    YMeasure*       _summary;
    NSMutableArray* _preview;
    NSMutableArray* _measures;
//--- (end of generated code: YDataSet attributes declaration)
}

-(id)   initWith:(YFunction *)parent :(NSString*)functionId :(NSString*)unit :(s64)startTime :(s64)endTime;
-(id)   initWith:(YFunction *)parent :(NSString *)json;

-(int)  _parse:(NSString *)json;
//--- (generated code: YDataSet private methods declaration)
//--- (end of generated code: YDataSet private methods declaration)

//--- (generated code: YDataSet public methods declaration)
-(NSMutableArray*)     get_calibration;

-(int)     processMore:(int)progress :(NSData*)data;

-(NSMutableArray*)     get_privateDataStreams;

/**
 * Returns the unique hardware identifier of the function who performed the measures,
 * in the form SERIAL.FUNCTIONID. The unique hardware identifier is composed of the
 * device serial number and of the hardware identifier of the function
 * (for example THRMCPL1-123456.temperature1)
 *
 * @return a string that uniquely identifies the function (ex: THRMCPL1-123456.temperature1)
 *
 * On failure, throws an exception or returns  Y_HARDWAREID_INVALID.
 */
-(NSString*)     get_hardwareId;

/**
 * Returns the hardware identifier of the function that performed the measure,
 * without reference to the module. For example temperature1.
 *
 * @return a string that identifies the function (ex: temperature1)
 */
-(NSString*)     get_functionId;

/**
 * Returns the measuring unit for the measured value.
 *
 * @return a string that represents a physical unit.
 *
 * On failure, throws an exception or returns  Y_UNIT_INVALID.
 */
-(NSString*)     get_unit;

/**
 * Returns the start time of the dataset, relative to the Jan 1, 1970.
 * When the YDataSet is created, the start time is the value passed
 * in parameter to the get_dataSet() function. After the
 * very first call to loadMore(), the start time is updated
 * to reflect the timestamp of the first measure actually found in the
 * dataLogger within the specified range.
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         set (i.e. Unix time representation of the absolute time).
 */
-(s64)     get_startTimeUTC;

/**
 * Returns the end time of the dataset, relative to the Jan 1, 1970.
 * When the YDataSet is created, the end time is the value passed
 * in parameter to the get_dataSet() function. After the
 * very first call to loadMore(), the end time is updated
 * to reflect the timestamp of the last measure actually found in the
 * dataLogger within the specified range.
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the end of this data
 *         set (i.e. Unix time representation of the absolute time).
 */
-(s64)     get_endTimeUTC;

/**
 * Returns the progress of the downloads of the measures from the data logger,
 * on a scale from 0 to 100. When the object is instantiated by get_dataSet,
 * the progress is zero. Each time loadMore() is invoked, the progress
 * is updated, to reach the value 100 only once all measures have been loaded.
 *
 * @return an integer in the range 0 to 100 (percentage of completion).
 */
-(int)     get_progress;

/**
 * Loads the the next block of measures from the dataLogger, and updates
 * the progress indicator.
 *
 * @return an integer in the range 0 to 100 (percentage of completion),
 *         or a negative error code in case of failure.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     loadMore;

/**
 * Returns an YMeasure object which summarizes the whole
 * DataSet. In includes the following information:
 * - the start of a time interval
 * - the end of a time interval
 * - the minimal value observed during the time interval
 * - the average value observed during the time interval
 * - the maximal value observed during the time interval
 *
 * This summary is available as soon as loadMore() has
 * been called for the first time.
 *
 * @return an YMeasure object
 */
-(YMeasure*)     get_summary;

/**
 * Returns a condensed version of the measures that can
 * retrieved in this YDataSet, as a list of YMeasure
 * objects. Each item includes:
 * - the start of a time interval
 * - the end of a time interval
 * - the minimal value observed during the time interval
 * - the average value observed during the time interval
 * - the maximal value observed during the time interval
 *
 * This preview is available as soon as loadMore() has
 * been called for the first time.
 *
 * @return a table of records, where each record depicts the
 *         measured values during a time interval
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_preview;

/**
 * Returns the detailed set of measures for the time interval corresponding
 * to a given condensed measures previously returned by get_preview().
 * The result is provided as a list of YMeasure objects.
 *
 * @param measure : condensed measure from the list previously returned by
 *         get_preview().
 *
 * @return a table of records, where each record depicts the
 *         measured values during a time interval
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_measuresAt:(YMeasure*)measure;

/**
 * Returns all measured values currently available for this DataSet,
 * as a list of YMeasure objects. Each item includes:
 * - the start of the measure time interval
 * - the end of the measure time interval
 * - the minimal value observed during the time interval
 * - the average value observed during the time interval
 * - the maximal value observed during the time interval
 *
 * Before calling this method, you should call loadMore()
 * to load data from the device. You may have to call loadMore()
 * several time until all rows are loaded, but you can start
 * looking at available data rows before the load is complete.
 *
 * The oldest measures are always loaded first, and the most
 * recent measures will be loaded last. As a result, timestamps
 * are normally sorted in ascending order within the measure table,
 * unless there was an unexpected adjustment of the datalogger UTC
 * clock.
 *
 * @return a table of records, where each record depicts the
 *         measured value for a given time interval
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_measures;


//--- (end of generated code: YDataSet public methods declaration)

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
 * Setup the Yoctopuce library to use modules connected on a given machine. The
 * parameter will determine how the API will work. Use the following values:
 *
 * <b>usb</b>: When the usb keyword is used, the API will work with
 * devices connected directly to the USB bus. Some programming languages such a Javascript,
 * PHP, and Java don't provide direct access to USB hardware, so usb will
 * not work with these. In this case, use a VirtualHub or a networked YoctoHub (see below).
 *
 * <b><i>x.x.x.x</i></b> or <b><i>hostname</i></b>: The API will use the devices connected to the
 * host with the given IP address or hostname. That host can be a regular computer
 * running a VirtualHub, or a networked YoctoHub such as YoctoHub-Ethernet or
 * YoctoHub-Wireless. If you want to use the VirtualHub running on you local
 * computer, use the IP address 127.0.0.1.
 *
 * <b>callback</b>: that keyword make the API run in "<i>HTTP Callback</i>" mode.
 * This a special mode allowing to take control of Yoctopuce devices
 * through a NAT filter when using a VirtualHub or a networked YoctoHub. You only
 * need to configure your hub to call your server script on a regular basis.
 * This mode is currently available for PHP and Node.JS only.
 *
 * Be aware that only one application can use direct USB access at a
 * given time on a machine. Multiple access would cause conflicts
 * while trying to access the USB modules. In particular, this means
 * that you must stop the VirtualHub software before starting
 * an application that uses direct USB access. The workaround
 * for this limitation is to setup the library to use the VirtualHub
 * rather than direct USB access.
 *
 * If access control has been activated on the hub, virtual or not, you want to
 * reach, the URL parameter should look like:
 *
 * http://username:password@address:port
 *
 * You can call <i>RegisterHub</i> several times to connect to several machines.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
YRETCODE yRegisterHub(NSString * url, NSError** errmsg);

/**
 * Fault-tolerant alternative to RegisterHub(). This function has the same
 * purpose and same arguments as RegisterHub(), but does not trigger
 * an error when the selected hub is not available at the time of the function call.
 * This makes it possible to register a network hub independently of the current
 * connectivity, and to try to contact it only when a device is actively needed.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
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
 * consume CPU cycles significantly. The processor is left available for
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
 * (Objective-C only) Register an object that must follow the protocol YDeviceHotPlug. The methods
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param object : an object that must follow the protocol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */

void ySetDelegate(id object);


/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the millisecond as timebase.
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
 * a device is plugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceArrivalCallback(yDeviceUpdateCallback arrivalCallback);

/**
 * Register a callback function, to be called each time
 * a device is unplugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceRemovalCallback(yDeviceUpdateCallback removalCallback);

void    yRegisterDeviceChangeCallback(yDeviceUpdateCallback removalCallback);

/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite useful to debug the API.
 *
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterLogFunction(yLogCallback logfun);

//--- (generated code: Function functions declaration)
/**
 * Retrieves a function for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the function is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YFunction.isOnline() to test if the function is
 * indeed online at a given time. In case of ambiguity when looking for
 * a function by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the function
 *
 * @return a YFunction object allowing you to drive the function.
 */
YFunction* yFindFunction(NSString* func);
/**
 * comment from .yc definition
 */
YFunction* yFirstFunction(void);

//--- (end of generated code: Function functions declaration)

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

//--- (generated code: Sensor functions declaration)
/**
 * Retrieves a sensor for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the sensor is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSensor.isOnline() to test if the sensor is
 * indeed online at a given time. In case of ambiguity when looking for
 * a sensor by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the sensor
 *
 * @return a YSensor object allowing you to drive the sensor.
 */
YSensor* yFindSensor(NSString* func);
/**
 * Starts the enumeration of sensors currently accessible.
 * Use the method YSensor.nextSensor() to iterate on
 * next sensors.
 *
 * @return a pointer to a YSensor object, corresponding to
 *         the first sensor currently online, or a null pointer
 *         if there are none.
 */
YSensor* yFirstSensor(void);

//--- (end of generated code: Sensor functions declaration)

CF_EXTERN_C_END


