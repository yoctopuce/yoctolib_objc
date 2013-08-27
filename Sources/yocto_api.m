/*********************************************************************
 *
 * $Id: yocto_api.m 12326 2013-08-13 15:52:20Z mvuilleu $
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

#import  "yocto_api.h"
#include "yapi/yapi.h"
#include "yapi/yjson.h"
#import  "objc/message.h"

@implementation  YapiEvent 
@synthesize type =_type;
@synthesize module = _module;
@synthesize function = _function;
@synthesize value =_value;

-(id) initFull:(unsigned)type :(YModule*)module :(YFunction*)function :(NSString*)value
{
    if((self=[super init])){
        _type      = type;
        _module    = module;
        _function  = function;
        _value = value;
        if(_value!=nil){
            ARC_retain(_value);
        }
    }
    return self;
}

-(id) initDeviceEvent:(unsigned)type forModule:(YModule*)module
{
    return [self initFull:type:module :nil :nil];
}

-(id) initFunction:(YFunction*)function withEvent:(unsigned) type
{
    return [self initFull:type :nil :function :nil];
}



-(id) initFunction:(YFunction*)function newValue:(NSString*)value
{
    return [self initFull:YAPI_FUN_VALUE :nil :function :value];
}


-(id) init
{
    return [self initFull:YAPI_INVALID:nil:nil:nil];
}


-(void)  dealloc
{
    if (_value!=nil){
        ARC_release(_value);
    }
    ARC_dealloc(super);
}

@end



YRETCODE yFormatRetVal(NSError** error,YRETCODE errCode,const char *message)
{
    if (YISERR(errCode)) {
        if (error) {
            NSString *description = STR_y2oc(message);
            // Make and return custom domain error.
            NSArray *objArray = [NSArray arrayWithObjects:description,  nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
            NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
            *error = [NSError errorWithDomain:@"com.yoctopuce"
                                         code:errCode 
                                     userInfo:eDict];
        }
    }
    return errCode;
}



// 
// YAPI Context
//
// This class provides Objective-C style entry points to lowlevcel functions defined to yapi.h
// Could be implemented by a singleton, we use static methods insead


// global variables to emulate static data member of YAPI class
static int           YAPI_defaultCacheValidity  = 5;
static BOOL          YAPI_exceptionsDisabled    = NO;
static NSString *    YAPI_INVALID_STRING        = @"!INVALID!";
static BOOL          YAPI_apiInitialized        = NO;

static NSMutableArray *YAPI_plug_events = nil;
static NSMutableArray *YAPI_data_events = nil;


//static NSMutableArray* _FunctionCache     = nil;
static NSMutableArray* _FunctionCallbacks = nil;
static NSMutableArray* _devCache = nil;
NSMutableDictionary* YAPI_YFunctions=nil;
//static NSMutableDictionary* _ModuleCache = nil;
static id              YAPI_delegate=nil;



static yLogCallback YAPI_logFunction=NULL;
static void yapiLogFunctionFwd(const char *clog,u32 loglen)
{
    if(YAPI_logFunction || YAPI_delegate){
        NSString *log = [[NSString alloc] initWithUTF8String:clog];
        if(YAPI_logFunction)
            YAPI_logFunction(log);
        if(YAPI_delegate!=nil) {
            SEL sel = @selector(yLog:);
            if([YAPI_delegate respondsToSelector:sel]) {
                [YAPI_delegate yLog:log];
            }
        }

        ARC_release(log);
    }
}

static yDeviceUpdateCallback YAPI_deviceArrivalCallback = NULL;
static void yapiDeviceArrivalCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    @autoreleasepool {
        if(_FunctionCallbacks != nil) {
            //look if we have some allocated function with a callback to refresh
            for (id it in _FunctionCallbacks) {
                if ([it functionDescriptor] == Y_FUNCTIONDESCRIPTOR_INVALID){
                    ev =[[YapiEvent alloc] initFunction:it withEvent:YAPI_FUN_REFRESH];
                    [YAPI_data_events addObject:ev];
                    ARC_release(ev);
                }
            }
        }
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) {
            return;
        }
        module = yFindModule([STR_y2oc(infos.serial) stringByAppendingFormat:@".module"]);
        if(!YAPI_deviceArrivalCallback && YAPI_delegate==nil) return;
        ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_ARRIVAL forModule:module];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}

static yDeviceUpdateCallback YAPI_deviceRemovalCallback = NULL;
    
static void yapiDeviceRemovalCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    @autoreleasepool {
        if(!YAPI_deviceRemovalCallback && YAPI_delegate==nil) return;
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) return;    
        module = yFindModule([STR_y2oc(infos.serial) stringByAppendingFormat:@".module"]);
        ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_REMOVAL forModule:module];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}

static yDeviceUpdateCallback YAPI_deviceChangeCallback = NULL;
static void yapiDeviceChangeCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    @autoreleasepool {
        
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) return;    
        module = yFindModule(STR_y2oc(infos.serial));
        if(!YAPI_deviceChangeCallback && YAPI_delegate==nil) return;
        ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_CHANGE forModule:module];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}

void yInternalPushNewVal(YAPI_FUNCTION fundescr,NSString * value)
{
    YapiEvent  *ev;
    for (id it in _FunctionCallbacks) {
        if ([it functionDescriptor] == fundescr){
            if(value==NULL){
                ev =[[YapiEvent alloc] initFunction:it withEvent:YAPI_FUN_UPDATE];
            }else{
                ev =[[YapiEvent alloc] initFunction:it newValue:value];
            }
            [YAPI_data_events addObject:ev];
            ARC_release(ev);
        }
    }
}

static void yapiFunctionUpdateCallbackFwd(YAPI_FUNCTION fundescr,const char *value)
{
    if(value){
        @autoreleasepool {
            yInternalPushNewVal(fundescr,STR_y2oc(value));
        }
    }else {
        yInternalPushNewVal(fundescr,nil);
    }
}


static  yCRITICAL_SECTION   YAPI_updateDeviceList_CS;
static  yCRITICAL_SECTION   YAPI_handleEvent_CS;
static  NSMutableDictionary *YAPI_calibHandlers;

@interface YAPI_CalibrationObj : NSObject <CalibrationHandlerDelegate>
@end


@implementation YAPI_CalibrationObj
-(double) yCalibrationHandler:(double)rawValue
                             :(int)calibType
                             :(NSArray*)params
                             :(NSArray*)rawValues
                             :(NSArray*) refValues
{
    // calibration types n=1..10 and 11.20 are meant for linear calibration using n points
    unsigned long npt = calibType % 10;
    double x   = [[rawValues objectAtIndex:0] doubleValue];
    double adj = [[refValues objectAtIndex:0] doubleValue]- x;
    int    i   = 0;
    
    if(npt > [rawValues count])
        npt = [rawValues count];
    if(npt > [refValues count])
        npt = [refValues count];
    while(rawValue > [[rawValues objectAtIndex:i] doubleValue] && ++i < npt) {
        double x2   = x;
        double adj2 = adj;
        
        x   = [[rawValues objectAtIndex:i] doubleValue];
        adj = [[refValues objectAtIndex:i] doubleValue]- x;
        if(rawValue < x && x > x2) {
            adj = adj2 + (adj - adj2) * (rawValue - x2) / (x - x2);
        }
    }
    return rawValue + adj;
}
@end


static YAPI_CalibrationObj *YAPI_linearCalibration;
static YAPI_CalibrationObj *YAPI_invalidCalibration;

@implementation YAPI



+(id) _getCalibrationHandler:(int) calibType
{
    id hdl=[YAPI_calibHandlers objectForKey:[NSNumber numberWithInt:calibType]];
    if(hdl==nil)
        return YAPI_invalidCalibration;
    return hdl;
}


static double decExp[16] = {
    1.0e-6, 1.0e-5, 1.0e-4, 1.0e-3, 1.0e-2, 1.0e-1, 1.0,
    1.0e1, 1.0e2, 1.0e3, 1.0e4, 1.0e5, 1.0e6, 1.0e7, 1.0e8, 1.0e9 };

// Convert Yoctopuce 16-bit decimal floats to standard double-precision floats
//

// dirty declaration to prevent compilation warning
// used into datalogger.m too
double _decimalToDouble(s16 val);

double _decimalToDouble(s16 val)
{
    int     negate = 0;
    double  res;
    
    if(val == 0) return 0.0;
    if(val < 0) {
        negate = 1;
        val = -val;
    }
    res = (double)(val & 2047) * decExp[val >> 11];
    
    return (negate ? -res : res);
}

// Convert standard double-precision floats to Yoctopuce 16-bit decimal floats
//
static s16 _doubleToDecimal(double val)
{
    int     negate = 0;
    double  comp, mant;
    u16     decpow;
    s16     res;
    
    if(val == 0.0) {
        return 0;
    }
    if(val < 0) {
        negate = 1;
        val = -val;
    }
    comp = val / 1999.0;
    decpow = 0;
    while(comp > decExp[decpow] && decpow < 15) {
        decpow++;
    }
    mant = val / decExp[decpow];
    if(decpow == 15 && mant > 2047.0) {
        res = (15 << 11) + 2047; // overflow
    } else {
        res = (decpow << 11) + (u16)floor(mant+.5);
    }
    return (negate ? -res : res);
}



// Method used to encode calibration points into fixed-point 16-bit integers or decimal floating-point
//
+(NSString*) _encodeCalibrationPoints:(NSArray*)rawValues :(NSArray*)refValues :(double)resolution :(int) calibrationOffset :(NSString*)actualCparams
{
    int         npt = (int)([rawValues count] < [refValues count] ? [rawValues count] : [refValues count]);
    int         caltype;
    int         rawVal, refVal;
    int         minRaw = 0;
    NSMutableString    *res;
    
    if(npt ==0 ){
        return @"0";
    }
    if([actualCparams isEqualToString:@""]){
        caltype = 10 + npt;
    }else{
        NSUInteger pos = [actualCparams rangeOfString:@"."].location;
        caltype = [[actualCparams substringToIndex:pos] intValue];
        if(caltype <= 10) {
            caltype = npt;
        } else {
            caltype = 10+npt;
        }
    }
    res = [NSMutableString stringWithFormat:@"%u",caltype];
    if (caltype <=10){
        for(int i = 0; i < npt; i++) {
            rawVal = (int) ([[rawValues objectAtIndex:i] doubleValue] / resolution - calibrationOffset + .5);
            if(rawVal >= minRaw && rawVal < 65536) {
                refVal = (int) ([[refValues objectAtIndex:i] doubleValue] / resolution - calibrationOffset + .5);
                if(refVal >= 0 && refVal < 65536) {
                    [res appendFormat:@",%d,%d",rawVal,refVal];
                    minRaw = rawVal+1;
                }
            }
        }
    } else {
        // 16-bit floating-point decimal encoding
        for(int i = 0; i < npt; i++) {
            rawVal = _doubleToDecimal([[rawValues objectAtIndex:i] doubleValue]);
            refVal = _doubleToDecimal([[refValues objectAtIndex:i] doubleValue]);
            [res appendFormat:@",%d,%d",rawVal,refVal];
        }
    }
    return res;
}

// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
//
// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
+(int) _decodeCalibrationPoints:(NSString*)calibParams :(NSMutableArray*)intPt :(NSMutableArray*)rawPt :(NSMutableArray*)calPt withResolution:(double)resolution andOffset:(int)calibrationOffset
{
    int        calibType, nval;
    
    // parse calibration parameters
    [rawPt removeAllObjects];
    [calPt removeAllObjects];
    
    NSArray *stringArray = [calibParams componentsSeparatedByString:@","];
    calibType = [[stringArray objectAtIndex:0] intValue];
    nval = (calibType <= 20 ? 2*(calibType % 10) : 99);
    for (int i =1; i< nval && i< [stringArray count] ;i+=2){
        int rawval = [[stringArray objectAtIndex:i] intValue];
        int calval = [[stringArray objectAtIndex:i+1] intValue];
        double rawval_d, calval_d;
        if(calibType <= 10) {
            rawval_d = (rawval + calibrationOffset) * resolution;
            calval_d = (calval + calibrationOffset) * resolution;
        } else {
            rawval_d = _decimalToDouble(rawval);
            calval_d = _decimalToDouble(calval);
        }
        if(intPt){
            [intPt addObject:[NSNumber numberWithInt:rawval]];
            [intPt addObject:[NSNumber numberWithInt:calval]];
        }
        [rawPt addObject:[NSNumber numberWithDouble:rawval_d]];
        [calPt addObject:[NSNumber numberWithDouble:calval_d]];
    }
    return calibType;
}


+(double) _applyCalibration:(double) rawValue :(NSString*)calibration_str :(int)calibOffset :(double)resolution
{
    double res =-DBL_MAX;
    if(rawValue == -DBL_MAX || resolution == -DBL_MAX) {
        return res;
    }
    
    NSMutableArray * cur_calpar = [[NSMutableArray alloc] init];
    NSMutableArray * cur_calraw = [[NSMutableArray alloc] init];
    NSMutableArray * cur_calref = [[NSMutableArray alloc] init];
    int calibType = [YAPI _decodeCalibrationPoints:calibration_str
                                                       :cur_calpar
                                                       :cur_calraw
                                                       :cur_calref
                                         withResolution:resolution
                                              andOffset:calibOffset];

    if(calibType == 0) {
        ARC_release(cur_calpar);
        ARC_release(cur_calraw);
        ARC_release(cur_calref);
        return rawValue;
    }
    id handler = [YAPI _getCalibrationHandler:calibType];
    if(handler!=nil) {
        SEL sel = @selector(yCalibrationHandler:::::);
        if([handler respondsToSelector:sel]) {
            res = [handler yCalibrationHandler:rawValue
                                        :calibType
                                        :cur_calpar
                                        :cur_calraw
                                        :cur_calref];
        }
    }
    ARC_release(cur_calpar);
    ARC_release(cur_calraw);
    ARC_release(cur_calref);
    return res;
}



// Default cache validity (in [ms]) before reloading data from device. This saves a lots of trafic.
// Note that a value under 2 ms makes little sense since a USB bus itself has a 2ms roundtrip period
+(int)         DefaultCacheValidity
{
    return YAPI_defaultCacheValidity;
}

/**
 * 
 */
+(void)         SetDefaultCacheValidity:(int)defaultCacheValidity
{
    YAPI_defaultCacheValidity=defaultCacheValidity;
}

// Switch to turn off exceptions and use return codes instead, for source-code compatibility
// with languages without exception support like C    
+(BOOL)        ExceptionsDisabled
{
    return YAPI_exceptionsDisabled;
}

// Return value for invalid strings
+(NSString*)    INVALID_STRING
{
    return YAPI_INVALID_STRING;
}


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
+(NSString*)    GetAPIVersion
{
    const char * version;
    yapiGetAPIVersion(&version,NULL);
    return STR_y2oc(version);
}

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
+(YRETCODE)    InitAPI:(int)mode :(NSError**)errmsg
{
    char errbuf[YOCTO_ERRMSG_LEN];
    
    if(YAPI_apiInitialized) return YAPI_SUCCESS;
    YRETCODE res = yapiInitAPI(mode, errbuf);
    if(YISERR(res)) {
        return yFormatRetVal(errmsg, res,errbuf);
    }
    
    yapiRegisterLogFunction(yapiLogFunctionFwd);
    YAPI_plug_events = [[NSMutableArray alloc ] initWithCapacity:16];
    yapiRegisterDeviceArrivalCallback(yapiDeviceArrivalCallbackFwd);
    yapiRegisterDeviceRemovalCallback(yapiDeviceRemovalCallbackFwd);
    yapiRegisterDeviceChangeCallback(yapiDeviceChangeCallbackFwd);
    YAPI_data_events = [[NSMutableArray alloc ] initWithCapacity:16];
    yapiRegisterFunctionUpdateCallback(yapiFunctionUpdateCallbackFwd);
    yInitializeCriticalSection(&YAPI_updateDeviceList_CS);
    yInitializeCriticalSection(&YAPI_handleEvent_CS);
    YAPI_linearCalibration  = [[YAPI_CalibrationObj alloc] init];
    YAPI_invalidCalibration = [[YAPI_CalibrationObj alloc] init];
    YAPI_calibHandlers = [[NSMutableDictionary alloc] initWithCapacity:20];
    for(int i =1 ;i <=20;i++){
        NSNumber *type = [NSNumber numberWithInt:i];
        [YAPI_calibHandlers setObject:YAPI_linearCalibration forKey:type];
    }
    YAPI_YFunctions =[[NSMutableDictionary alloc] initWithCapacity:8];
    YAPI_apiInitialized = YES;
    
    return YAPI_SUCCESS;
}

/**
 * Frees dynamically allocated memory blocks used by the Yoctopuce library.
 * It is generally not required to call this function, unless you
 * want to free all dynamically allocated memory blocks in order to
 * track a memory leak for instance.
 * You should not call any other library function after calling
 * yFreeAPI(), or your program will crash.
 */

+(void)        FreeAPI
{
    if (YAPI_apiInitialized) {
        yDeleteCriticalSection(&YAPI_updateDeviceList_CS);
        yDeleteCriticalSection(&YAPI_handleEvent_CS);
        yapiFreeAPI();
        ARC_release(YAPI_plug_events);
        YAPI_plug_events = nil;
        ARC_release(YAPI_data_events);
        YAPI_data_events = nil;
        ARC_release(YAPI_linearCalibration);
        YAPI_linearCalibration=nil;
        ARC_release(YAPI_invalidCalibration);
        YAPI_invalidCalibration=nil;
        ARC_release(YAPI_calibHandlers);
        YAPI_calibHandlers =nil;
        ARC_release(YAPI_delegate);
        YAPI_delegate = nil;
        ARC_release(YAPI_YFunctions);
        YAPI_YFunctions =nil;
        ARC_release(_FunctionCallbacks)
        _FunctionCallbacks=nil;
        ARC_release(_devCache);
        _devCache = nil;
        YAPI_apiInitialized = NO;
    }
}

/**
 * Re-enables the use of exceptions for runtime error handling.
 * Be aware than when exceptions are enabled, every function that fails
 * triggers an exception. If the exception is not caught by the user code,
 * it  either fires the debugger or aborts (i.e. crash) the program.
 * On failure, throws an exception or returns a negative error code.
 */
+(void)        EnableExceptions
{
    YAPI_exceptionsDisabled=NO;
}

/**
 * Disables the use of exceptions to report runtime errors.
 * When exceptions are disabled, every function returns a specific
 * error value which depends on its type and which is documented in
 * this reference manual.
 */
+(void)        DisableExceptions
{
    YAPI_exceptionsDisabled=YES;
}


/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite usefull to debug the API.
 * 
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
+(void)    RegisterLogFunction:(yLogCallback) logfun
{
    YAPI_logFunction = logfun;
}


/**
 * Register a callback function, to be called each time
 * a device is pluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
+(void)    RegisterDeviceArrivalCallback:(yDeviceUpdateCallback) arrivalCallback
{
    YAPI_deviceArrivalCallback = arrivalCallback;
    // call callback on all allready present devices
    if (arrivalCallback) {
        YModule *mod = yFirstModule();
        while (mod) {
            if ([mod isOnline]) {
                yapiLockDeviceCallBack(NULL);
                yapiDeviceArrivalCallbackFwd([mod functionDescriptor]);
                yapiUnlockDeviceCallBack(NULL);
            }
            mod = [mod nextModule];
        }
    }
}

/**
 * Register a callback function, to be called each time
 * a device is unpluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
+(void)    RegisterDeviceRemovalCallback:(yDeviceUpdateCallback) removalCallback
{
    YAPI_deviceRemovalCallback = removalCallback;
}

+(void)    RegisterDeviceChangeCallback:(yDeviceUpdateCallback) changeCallback
{
    YAPI_deviceChangeCallback = changeCallback;
}






/**
 * (Objective-C only) Register an object that must follow the procol YDeviceHotPlug. The methodes
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param object : an object that must follow the procol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */
+(void) SetDelegate:(id)object
{
    YAPI_delegate = object;
}






/**
 * (Objective-C only) Register an object that must follow the procol YDeviceHotPlug. The methodes
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param object : an object that must follow the procol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */
+(void) RegisterCalibrationHandler:(NSNumber*)calibrationType :(id)object
{
    [YAPI_calibHandlers setObject:object forKey:calibrationType];
}


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
+(YRETCODE)    RegisterHub:(NSString*)url :(NSError**)errmsg
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;

    if (!YAPI_apiInitialized) {
        res = [YAPI InitAPI:0:errmsg];
        if(YISERR(res)) return res;
    }
    @autoreleasepool {
        res = yapiRegisterHub(STR_oc2y(url), errbuf);
    }
    return yFormatRetVal(errmsg, res, errbuf);
}

/**
 *
 */
+(YRETCODE)   PreregisterHub:(NSString*)url :(NSError**)error
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;
    
    if (!YAPI_apiInitialized) {
        res = [YAPI InitAPI:0:error];
        if(YISERR(res)) return res;
    }
    res = yapiPreregisterHub(STR_oc2y(url), errbuf);
    return yFormatRetVal(error, res, errbuf);
}

/**
 * Setup the Yoctopuce library to no more use modules connected on a previously
 * registered machine with RegisterHub.
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 */
+(void)         UnregisterHub:(NSString*) url
{
    
    if (!YAPI_apiInitialized) {
        return;
    }
    yapiUnregisterHub(STR_oc2y(url));
}



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
+(YRETCODE)    UpdateDeviceList:(NSError**) errmsg
{
    YRETCODE    res;
    
    if (!YAPI_apiInitialized) {
        res = [YAPI InitAPI:0:errmsg];
        if(YISERR(res)) return res;
    }
    // prevent reentrance into this function
    yEnterCriticalSection(&YAPI_updateDeviceList_CS);
    // call the updateDeviceList of the yapi layer
    // yapi know when it is needed to do a full update
    res = [YapiWrapper updateDeviceList:false:errmsg];
    if(YISERR(res)) {
        yLeaveCriticalSection(&YAPI_updateDeviceList_CS);
        return res;
    }
    res = [YapiWrapper handleEvents:errmsg];
    if(YISERR(res)) {
        yLeaveCriticalSection(&YAPI_updateDeviceList_CS);
        return res;
    }
    while([YAPI_plug_events count] >0){
        YapiEvent   *ev;
        yapiLockDeviceCallBack(NULL);
        if ([YAPI_plug_events count] ==0){
            yapiUnlockFunctionCallBack(NULL);
            break;        
        }
        ev = [YAPI_plug_events objectAtIndex:0];;
        [YAPI_plug_events removeObjectAtIndex:0];
        yapiUnlockDeviceCallBack(NULL);
        switch(ev.type){
            case YAPI_DEV_ARRIVAL:
                if(YAPI_deviceArrivalCallback)
                    YAPI_deviceArrivalCallback(ev.module);    
                if(YAPI_delegate!=nil) {
                    SEL sel = @selector(yDeviceArrival:);
                    if([YAPI_delegate respondsToSelector:sel]) {
                        [YAPI_delegate yDeviceArrival:ev.module];
                    }
                }
                break;
            case YAPI_DEV_REMOVAL:
                if(YAPI_deviceRemovalCallback)
                    YAPI_deviceRemovalCallback(ev.module);    
                if(YAPI_delegate!=nil) {
                    SEL sel = @selector(yDeviceRemoval:);
                    if([YAPI_delegate respondsToSelector:sel]) {
                        [YAPI_delegate yDeviceRemoval:ev.module];
                    }
                }
                break;
            case YAPI_DEV_CHANGE:
                if(YAPI_deviceChangeCallback)
                    YAPI_deviceChangeCallback(ev.module);    
                break;
            default:
                break;
        }
    }
    yLeaveCriticalSection(&YAPI_updateDeviceList_CS);
    return YAPI_SUCCESS;
}


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
+(YRETCODE)     HandleEvents:(NSError**) errmsg
{
    YRETCODE    res;
    
    // prevent reentrance into this function
    yEnterCriticalSection(&YAPI_handleEvent_CS);
    res = [YapiWrapper handleEvents:errmsg];
    if(YISERR(res)) {
        yLeaveCriticalSection(&YAPI_handleEvent_CS);
        return res;
    }
    // pop data event and call user callback
    while([YAPI_data_events count] >0){
        YapiEvent       *ev;
        yapiLockFunctionCallBack(NULL);
        if ([YAPI_data_events count] ==0){
            yapiUnlockFunctionCallBack(NULL);
            break;        
        }
        ev = [YAPI_data_events objectAtIndex:0];
        ARC_retain(ev);
        [YAPI_data_events removeObjectAtIndex:0];
        yapiUnlockFunctionCallBack(NULL);
        switch (ev.type) {
            case YAPI_FUN_VALUE:
                [ev.function notifyValue:ev.value];
                break;
            case YAPI_FUN_REFRESH:
                [ev.function isOnline];
                break;
            default:
                break;
        }
        ARC_release(ev);
        
    }
    yLeaveCriticalSection(&YAPI_handleEvent_CS);
    return YAPI_SUCCESS;
}


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
+(YRETCODE)        Sleep:(unsigned) ms_duration :(NSError**) errmsg
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;
    u64         waituntil= [YAPI GetTickCount] + ms_duration;
    
    do{
        res = [YAPI HandleEvents:errmsg];
        if(YISERR(res)) {
            return yFormatRetVal(errmsg, res, errbuf);
        }
        if(waituntil > [YAPI GetTickCount]){
            res = yapiSleep(3, errbuf);
            if(YISERR(res)) {
                return yFormatRetVal(errmsg, res, errbuf);
            }
        }
    }while(waituntil > [YAPI GetTickCount]);
     
    return YAPI_SUCCESS;
}



/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the milisecond as timebase.
 * 
 * @return a long integer corresponding to the millisecond counter.
 */
+(u64) GetTickCount
{
    return yapiGetTickCount();
}


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
+(BOOL)        CheckLogicalName:(NSString * const) name
{
    return (yapiCheckLogicalName([name UTF8String])!=0);
}
@end


// Wrappers to yapi low-level API
@implementation YapiWrapper 

+(u16) getAPIVersion:(NSString**)version :(NSString**)subversion
{
    const char  *ver, *subver;    
    u16         res;
    
    res = yapiGetAPIVersion(&ver, &subver);
    *version    = STR_y2oc(ver);
    *subversion = STR_y2oc(subver);
    return res;
}



+(YDEV_DESCR)     getDevice:(NSString * const)device_str :(NSError**)error
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YAPI_DEVICE     res;
    
    res = yapiGetDevice([device_str UTF8String], errbuf);
    return yFormatRetVal(error, res, errbuf);
}


+(int)         getAllDevices:(NSMutableArray **)devices :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    int     n_elems = 32;
    int     initsize = n_elems * sizeof(YAPI_DEVICE);
    int     neededsize, res;
    YAPI_DEVICE *ptr = malloc(sizeof(YAPI_DEVICE)*n_elems);
    
    res = yapiGetAllDevices(ptr, initsize, &neededsize, errbuf);
    if(YISERR(res)) {
        free(ptr);
        return yFormatRetVal(error, res, errbuf);
    }
    if(neededsize > initsize) {
        free(ptr);
        n_elems = neededsize / sizeof(YAPI_DEVICE);
        initsize = n_elems * sizeof(YAPI_DEVICE);
        ptr = malloc(sizeof(YAPI_DEVICE)*n_elems);
        res = yapiGetAllDevices(ptr, initsize, NULL, errbuf);
        if(YISERR(res)) {
            free(ptr);
            return yFormatRetVal(error, res, errbuf);
        }
    }
    *devices = [NSMutableArray arrayWithCapacity:res];
    for (int  i=0 ; i< res ; i++) {
        [*devices addObject:[NSNumber numberWithInt:ptr[i]]];
    }
    free(ptr);
    return res;
}

+(YRETCODE)    getDeviceInfo:(YDEV_DESCR)devdesc :(yDeviceSt*)infos :(NSError**)error
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;
    
    res = yapiGetDeviceInfo(devdesc, infos, errbuf);
    return yFormatRetVal(error, res, errbuf);
}

+(YFUN_DESCR)   getFunction:(NSString * const)class_str :(NSString * const)function_str :(NSError**)error
{
    char errbuf[YOCTO_ERRMSG_LEN];
    
    YAPI_FUNCTION res = yapiGetFunction([class_str UTF8String], [function_str UTF8String], errbuf);
    return yFormatRetVal(error, res, errbuf);
}


+(int)         getFunctionsByClass:(NSString * const)class_str :(YFUN_DESCR)prevfundesc :(NSMutableArray **)functions :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    int     n_elems = 32;
    int     initsize = n_elems * sizeof(YAPI_DEVICE);
    int     neededsize;
    YAPI_FUNCTION *ptr    = malloc(sizeof(YAPI_FUNCTION) *n_elems);
    
    int res = yapiGetFunctionsByClass([class_str UTF8String], prevfundesc, ptr, initsize, &neededsize, errbuf);
    if(YISERR(res)) {
        free(ptr);
        return yFormatRetVal(error, res, errbuf);
    }
    if(neededsize > initsize) {
        free(ptr);
        n_elems = neededsize / sizeof(YAPI_FUNCTION);
        initsize = n_elems * sizeof(YAPI_FUNCTION);
        ptr = malloc(sizeof(YAPI_FUNCTION) *n_elems);
        res = yapiGetFunctionsByClass([class_str UTF8String], prevfundesc, ptr, initsize, NULL, errbuf);
        if(YISERR(res)) {
            free(ptr);
            return yFormatRetVal(error, res, errbuf);
        }
    }

    *functions = [NSMutableArray arrayWithCapacity:res];
    for (int  i=0 ; i< res ; i++) {
        [*functions addObject:[NSNumber numberWithInt:ptr[i]]];
    }
    free(ptr);
    
    return res;
}

+(int)         getFunctionsByDevice:(YDEV_DESCR) devdesc :(YFUN_DESCR)prevfundesc :(NSMutableArray **)functions :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    int     n_elems = 32;
    int     initsize = n_elems * sizeof(YAPI_DEVICE);
    int     neededsize;
    YAPI_FUNCTION *ptr    = malloc(sizeof(YAPI_FUNCTION) *n_elems);
    
    int res = yapiGetFunctionsByDevice(devdesc, prevfundesc, ptr, initsize, &neededsize, errbuf);
    if(YISERR(res)) {
        free(ptr);
        return yFormatRetVal(error, res, errbuf);
    }
    if(neededsize > initsize) {
        free(ptr);
        n_elems = neededsize / sizeof(YAPI_FUNCTION);
        initsize = n_elems * sizeof(YAPI_FUNCTION);
        ptr = malloc(sizeof(YAPI_FUNCTION) *n_elems);
        res = yapiGetFunctionsByDevice(devdesc, prevfundesc, ptr, initsize, NULL, errbuf);
        if(YISERR(res)) {
            free(ptr);
            return yFormatRetVal(error, res, errbuf);
        }
    }
    *functions = [NSMutableArray arrayWithCapacity:res];
    for (int  i=0 ; i< res ; i++) {
        [*functions addObject:[NSNumber numberWithInt:ptr[i]]];
    }
    free(ptr);

    return res;
}


+(YDEV_DESCR)     getDeviceByFunction:(YFUN_DESCR)fundesc :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    YAPI_DEVICE dev=INVALID_HASH_IDX;
    YRETCODE res = yapiGetFunctionInfo(fundesc, &dev, NULL, NULL, NULL, NULL, errbuf);
    if(res!= YAPI_SUCCESS){
        return yFormatRetVal(error, res, errbuf);
    }
    return dev;
}

+(YRETCODE)    getFunctionInfo:(YFUN_DESCR)fundesc :(YDEV_DESCR*)devdescr :(NSString**)serial :(NSString**)funcId :(NSString**)funcName :(NSString**)funcVal :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    char    snum[YOCTO_SERIAL_LEN];
    char    fnid[YOCTO_FUNCTION_LEN];
    char    fnam[YOCTO_LOGICAL_LEN];
    char    fval[YOCTO_PUBVAL_LEN];
    YAPI_DEVICE devdescr_c;
    
    YRETCODE res = yapiGetFunctionInfo(fundesc, &devdescr_c, snum, fnid, fnam, fval, errbuf);
    if(YISERR(res)) {
        return yFormatRetVal(error, res, errbuf);
    } else {
        if(serial)
            *serial   = STR_y2oc(snum);
        if(funcId)
            *funcId   = STR_y2oc(fnid);
        if(funcName)
            *funcName = STR_y2oc(fnam);
        if(funcVal)
            *funcVal  = STR_y2oc(fval);
        if(devdescr)
            *devdescr = devdescr_c;
    }
    
    return YAPI_SUCCESS;
}


+(YRETCODE) updateDeviceList:(bool) forceupdate :(NSError**)error
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res = yapiUpdateDeviceList(forceupdate?1:0,errbuf);
    return yFormatRetVal(error, res, errbuf);
}


+(YRETCODE) handleEvents:(NSError**)error
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res = yapiHandleEvents(errbuf);
    return yFormatRetVal(error, res, errbuf);
}

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


@implementation YDevice

// Constructor is private, use getDevice factory method
-(id) initWithDeviceDescriptor:(YDEV_DESCR)devdesc
{
    if(!(self = [super init]))
        return nil;
    _devdescr    = devdesc;
    _cacheJson   = @"";
    _cacheStamp  = 0;
    _functions   = nil;
    return self;

}

-(id) init
{
    return [self initWithDeviceDescriptor:0];
}


-(void)  dealloc
{
    if (_subpath){
        free(_subpath);
        _subpath =NULL;
    }
    ARC_release(_cacheJson);
    ARC_dealloc(super);
}


// Constructor is private, use getDevice factory method
+(YDevice*)   getDevice:(YDEV_DESCR)devdescr
{
    
    // Search in cache
    if (_devCache == nil){
        _devCache = [[NSMutableArray alloc] init];
    }
    
    for(unsigned int idx = 0; idx < [_devCache count]; idx++) {
        YDevice* tmp = [_devCache objectAtIndex:idx];
        if(tmp->_devdescr == devdescr) {
            return [_devCache objectAtIndex:idx];
        }
    }
    // Not found, add new entry
    YDevice *dev = [[YDevice alloc] initWithDeviceDescriptor:devdescr];
    [_devCache addObject:dev];
    ARC_release(dev);
    
    return dev;
}


-(YRETCODE)   _HTTPRequestPrepare:(NSString*)req_first_line  withBody:(NSData*)body :(NSMutableData**) fullrequest :(NSError**) error
{
    YRETCODE    res;
    char        errbuff[YOCTO_ERRMSG_LEN]="";

    if(_subpath==NULL){
        
        int neededsize;
        res = yapiGetDevicePath(_devdescr,_rootdevice, NULL, 0, &neededsize, errbuff);
        if(YISERR(res)) {
            return yFormatRetVal(error, res, errbuff);
        }
        _subpath = malloc(neededsize);
        res = yapiGetDevicePath(_devdescr,_rootdevice, _subpath, neededsize, NULL, errbuff);
        if(YISERR(res)) {
            return yFormatRetVal(error, res, errbuff);
        }
    }
    
    NSCharacterSet *chset = [NSCharacterSet characterSetWithCharactersInString:@" \r\n"];
    NSArray        *parts = [req_first_line componentsSeparatedByCharactersInSet:chset];
    if([parts count]<2){
        return yFormatRetVal(error, YAPI_INVALID_ARGUMENT, "Invalid HTTP request");
    }
    NSString       *relpath =  [[parts objectAtIndex:1] substringFromIndex:1];
    if(body==nil){
        req_first_line =[NSString stringWithFormat:@"%@ %s%@ \r\n\r\n",[parts objectAtIndex:0], _subpath,  relpath];
        *fullrequest = [NSMutableData dataWithData:[req_first_line dataUsingEncoding:NSISOLatin1StringEncoding]];
    } else {
        req_first_line =[NSString stringWithFormat:@"%@ %s%@ \r\n",[parts objectAtIndex:0],  _subpath, relpath];
        *fullrequest = [NSMutableData dataWithCapacity:[req_first_line length] +[body length]];
        [(*fullrequest) appendData:[req_first_line dataUsingEncoding:NSISOLatin1StringEncoding]];
        [(*fullrequest) appendData:body];
    }
    return YAPI_SUCCESS;
}


-(YRETCODE)    HTTPRequestAsync:(NSString*)request :(HTTPRequestCallback)callback :(NSMutableDictionary*)context :(NSError**)error
{
    YRETCODE        res;
    char            errbuff[YOCTO_ERRMSG_LEN]="";
    NSMutableData*  fullrequest;
    
    _cacheStamp     = [YAPI GetTickCount]; //invalidate cache
    res=[self _HTTPRequestPrepare:request withBody:nil :&fullrequest :error];
    if(YISERR(res)) return res;
    if(YISERR(res=yapiHTTPRequestAsyncEx(_rootdevice, [fullrequest bytes],(int)[fullrequest length], NULL, NULL, errbuff))){
        return yFormatRetVal(error, res, errbuff);
    }
    return YAPI_SUCCESS;
}



-(YRETCODE)    HTTPRequest:(NSString*)req_first_line withBody:(NSData*)req_head_and_body :(NSData**)buffer :(NSError**)error
{

    YRETCODE        res;
    char            errbuff[YOCTO_ERRMSG_LEN]="";
    YIOHDL          iohdl;
    NSMutableData*  fullrequest;
    char            *reply;
    int             replysize = 0;
    
    res=[self _HTTPRequestPrepare:req_first_line withBody:req_head_and_body :&fullrequest :error];
    if(YISERR(res)) return res;

    if(YISERR(res=yapiHTTPRequestSyncStartEx(&iohdl, _rootdevice, [fullrequest bytes],(int)[fullrequest length], &reply, &replysize, errbuff))) {
        return yFormatRetVal(error, res, errbuff);
    }
    *buffer = [NSData dataWithBytes:reply length:replysize];
    if(YISERR(res=yapiHTTPRequestSyncDone(&iohdl, errbuff))) {
        return yFormatRetVal(error, res, errbuff);
    }
    
    return YAPI_SUCCESS;
}


-(YRETCODE)     HTTPRequest:(NSString*)request :(NSData**)buffer :(NSError**)error;
{
    return [self HTTPRequest:request withBody:nil :buffer :error];
}


-(YRETCODE)   requestAPI:(NSString**)apires :(NSError**)error
{
    yJsonStateMachine j;
    NSData       *raw_buffer=nil;
    NSString     *buffer;
    int          res;
    
    // Check if we have a valid cache value
    if(_cacheStamp > [YAPI GetTickCount]) {
        *apires = _cacheJson;
        return YAPI_SUCCESS;
    }
    
    // Entry is outdated, get new data
    res = [self HTTPRequest: @"GET /api.json" :&raw_buffer :error];
    if(YISERR(res)) {
        // Check if an update of the device list does not solve the issue
        res = [YapiWrapper updateDeviceList:1:error];
        if(YISERR(res)) {
            return (YRETCODE)res;
        }
        res = [self HTTPRequest:@"GET /api.json"  :&raw_buffer :error];
        if(YISERR(res)) {
            return (YRETCODE)res;
        }
    }
    buffer = [[NSString alloc] initWithData:raw_buffer encoding:NSASCIIStringEncoding];
    ARC_autorelease(buffer);
    // Parse HTTP header
    j.src = STR_oc2y(buffer);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_HTTP_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_HTTP_READ_CODE) {
        return yFormatRetVal(error,YAPI_IO_ERROR,"Failed to parse HTTP header");
    }
    if(![STR_y2oc(j.token) isEqualToString:@"200"]) {
        NSString *tmp = [[NSString alloc] initWithFormat:@"Unexpected HTTP return code: %s",j.token];
        yFormatRetVal(error,YAPI_IO_ERROR, STR_oc2y(tmp));
        ARC_release(tmp);
        return YAPI_IO_ERROR;
    }
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_HTTP_READ_MSG) {
        yFormatRetVal(error,YAPI_IO_ERROR, "Unexpected HTTP header format");
        return YAPI_IO_ERROR;
    }
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        yFormatRetVal(error,YAPI_IO_ERROR, "Unexpected JSON reply format");
        return YAPI_IO_ERROR;
    }
    // we know for sure that the last character parsed was a '{'
    do j.src--; while(j.src[0] != '{');
    *apires = STR_y2oc(j.src);    
    
    // store result in cache
    ARC_release(_cacheJson);
    _cacheJson = *apires;
    ARC_retain(_cacheJson);
    _cacheStamp = [YAPI GetTickCount] + [YAPI DefaultCacheValidity];
    
    return YAPI_SUCCESS;
}

-(YRETCODE)   getFunctions:(NSArray**)functions :(NSError**)error
{
    if(_functions == nil) {
        NSMutableArray *func;
        int res = [YapiWrapper getFunctionsByDevice:_devdescr:0:&func:error];        
        if(YISERR(res)) return (YRETCODE)res;
        _functions = [[NSArray alloc] initWithArray:func];
    }
    *functions = _functions;

    return YAPI_SUCCESS;
}

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
@implementation YFunction

// Constructor is protected. Use the device-specific factory function to instantiate
-(id) initProtected:(NSString*)classname :(NSString*)func
{
    
    if(!(self = [super init]))
          return nil;
    _className          = classname;
    ARC_retain(_className);
    _func               = func;
    ARC_retain(_func);
    _cacheExpiration    = 0;
    _fundescr           = Y_FUNCTIONDESCRIPTOR_INVALID;
    // Make and return custom domain error.
    NSArray *objArray = [NSArray arrayWithObjects:@"",  nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
    _lastError = [NSError errorWithDomain:@"com.yoctopuce"
                                 code:YAPI_SUCCESS
                             userInfo:eDict];

    if ([YAPI_YFunctions objectForKey:@"YFunction"] == nil){
        [YAPI_YFunctions setObject:[NSMutableArray array] forKey:@"YFunction"];
    }
    [[YAPI_YFunctions objectForKey:@"YFunction"] addObject:self];

    return self;
}


-(void)  dealloc
{
    ARC_release(_className);
    ARC_release(_func);
    ARC_dealloc(super);
}

// Method used to throw exceptions or save error type/message
-(void)        _throw:(YRETCODE) errType withMsg:(const char*) errMsg
{
    NSError *error=nil;
    yFormatRetVal(&error, errType, errMsg);
    [self _throw:error];
}


// Method used to throw exceptions or save error type/message
-(void)        _throw:(YRETCODE) errType :(NSString*) errMsg
{
    NSError *error;
    // Make and return custom domain error.
    NSArray *objArray = [NSArray arrayWithObjects:errMsg,  nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
    error = [NSError errorWithDomain:@"com.yoctopuce"
                                         code:errType
                                     userInfo:eDict];
    [self _throw:error];
}

// Method used to throw exceptions or save error type/message
-(void)        _throw:(NSError*) error
{
    
    ARC_retain(error);
    ARC_release(_lastError)
    _lastError  = error;
    // Method used to throw exceptions or save error type/message
    if(![YAPI ExceptionsDisabled]) {
        NSNumber     *n   = [NSNumber numberWithInteger:[error code]];
        NSDictionary *dic =[NSDictionary dictionaryWithObject:n forKey:@"errType"];
        NSException  *e   =[NSException exceptionWithName:@"YAPI_Exception" 
                                                   reason:[error localizedDescription]
                                                 userInfo:dic];
        @throw e;
    }
}

// Method used to retrieve our unique function descriptor (may trigger a hub scan)
-(YRETCODE)    _getDescriptor:(YFUN_DESCR*)fundescr :(NSError**) error
{
    int res;
    YFUN_DESCR tmp_fundescr;
    
    tmp_fundescr = [YapiWrapper getFunction:_className: _func: error];
    if(YISERR(tmp_fundescr)) {
        res = [YapiWrapper updateDeviceList:1:error];
        if(YISERR(res)) {
            return (YRETCODE)res;
        }
        tmp_fundescr = [YapiWrapper getFunction:_className: _func: error];
        if(YISERR(tmp_fundescr)) {
            return (YRETCODE)tmp_fundescr;
        }
    }
    _fundescr = *fundescr = tmp_fundescr;
    return YAPI_SUCCESS;
}

// Method used to retrieve our device object (may trigger a hub scan)
-(YRETCODE)    _getDevice:(YDevice**)dev :(NSError**) error
{
    YFUN_DESCR    fundescr;
    YDEV_DESCR    devdescr;
    YRETCODE      res;

    // Resolve function name
    res = [self _getDescriptor:&fundescr: error];
    if(YISERR(res)) return res;
    
    // Get device descriptor
    devdescr = [YapiWrapper getDeviceByFunction:fundescr: error];
    if(YISERR(devdescr)) return res;
    
    // Get device object
    *dev = [YDevice getDevice:devdescr];

    return YAPI_SUCCESS;
}



// Method used to find the next instance of our function
-(YRETCODE)    _nextFunction:(NSString**) hwId
{
    NSMutableArray*     v_fundescr;
    NSNumber*           ns_fundescr;
    YFUN_DESCR          fundescr;
    YDEV_DESCR          devdescr;
    NSString            *serial, *funcId, *funcName, *funcVal;
    NSError             *error;
    YRETCODE            res;

    res = [self _getDescriptor:&fundescr :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    res = [YapiWrapper getFunctionsByClass:_className:fundescr:&v_fundescr:&error];
    if(YISERR((YRETCODE)res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    if([v_fundescr count]  == 0) {
        *hwId = @"";
        return YAPI_SUCCESS;
    }
    
    ns_fundescr =[v_fundescr objectAtIndex:0];
    res = [YapiWrapper getFunctionInfo:[ns_fundescr intValue]:&devdescr :&serial :&funcId :&funcName :&funcVal :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    *hwId = [NSString stringWithFormat:@"%@.%@",serial,funcId];

    return YAPI_SUCCESS;
}

-(int)         _parse:(yJsonStateMachine*) j
{
    NSLog(@"This function should never been called\n");
    return 0;
}

-(NSString*)     _parseString:(yJsonStateMachine*) j
{
    NSString*  res = STR_y2oc(j->token);
    
    while(j->next == YJSON_PARSE_STRINGCONT && yJsonParse(j) == YJSON_PARSE_AVAIL) {
        res =[res stringByAppendingString: STR_y2oc(j->token)];
    }
    return res;
}





-(YRETCODE)  _buildSetRequest:(NSString*)changeattr  :(NSString*)changeval :(NSString**)request :(NSError**)error
{
    YRETCODE        res;
    YFUN_DESCR      fundesc;
    char            funcid[YOCTO_FUNCTION_LEN];
    char            errbuf[YOCTO_ERRMSG_LEN];
    NSMutableString *buffer;
    
    
    // Resolve the function name
    res = [self _getDescriptor:&fundesc:error];
    if(YISERR(res)) {
        return res;
    }

    if(YISERR(res=yapiGetFunctionInfo((int)fundesc, NULL, NULL, funcid, NULL, NULL,errbuf))){
        yFormatRetVal(error,res,errbuf);
        [self _throw:res withMsg:errbuf];
        return res;
    }
    buffer = [NSMutableString stringWithFormat: @"GET /api/%s/",funcid];
    if(![changeattr isEqualToString: @""]) {
        [buffer appendString:changeattr];
        if(changeval) {
            int pos;
            [buffer appendString:@"?"];
            [buffer appendString:changeattr];
            [buffer appendString:@"="];
            for(pos=0;pos < [changeval length] ;pos++){
                unsigned char       c;
                unsigned char       esc[2];
                c = [changeval characterAtIndex:pos];
                if(c <= ' ' || (c > 'z' && c != '~') || c == '"' || c == '%' || c == '&' || 
                   c == '+' || c == '<' || c == '=' || c == '>' || c == '\\' || c == '^' || c == '`') {
                    esc[0]=(c >= 0xa0 ? (c>>4)-10+'A' : (c>>4)+'0');
                    c &= 0xf;
                    esc[1]=(c >= 0xa ? c-10+'A' : c+'0');
                    [buffer appendFormat:@"%%%c%c",esc[0],esc[1]];
                } else {
                    [buffer appendFormat:@"%c",c];
                }
            }
        }
    }
    [buffer appendString:@" \r\n\r\n"];
    *request = [NSString stringWithString:buffer];
    return YAPI_SUCCESS;
}


// Method used to change attributes
-(YRETCODE)    _setAttr:(NSString*)attrname :(NSString*)newvalue
{
    NSError     *error;
    NSString    *request;
    YRETCODE    res;
    YDevice     *dev;
        
    // Execute http request
    res = [self _buildSetRequest:attrname:newvalue:&request:&error ];
    if(YISERR(res)) {
        [self _throw:error];
        return res;
    }
    // Get device Object
    res = [self _getDevice:&dev:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return res;
    }
        
    res = [dev HTTPRequestAsync:request:NULL:NULL:&error];
    if(YISERR(res)) {
        // Check if an update of the device list does not solve the issue
        res = [YapiWrapper updateDeviceList:true:&error];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }
 
        res = [dev HTTPRequestAsync:request:NULL:NULL:&error];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }

    
    }
    _cacheExpiration=0;
    return YAPI_SUCCESS;
}



-(NSData*) _request:(NSString *)request withBody:(NSData*)body
{
    NSError     *error;
    YRETCODE    res;
    YDevice     *dev;
    NSData      *buffer;
    
    // Get device Object
    res = [self _getDevice:&dev:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return nil;
    }
    
    res = [dev HTTPRequest:request withBody:body :&buffer :&error];
    if(YISERR(res)) {
        // Check if an update of the device list does not solve the issue
        res = [YapiWrapper updateDeviceList:true:&error];
        if(YISERR(res)) {
            [self _throw:error];
            return nil;
        }
        res = [dev HTTPRequest:request withBody:body :&buffer :&error];
        if(YISERR(res)) {
            [self _throw:error];
            return nil;
        }
    }
    
    NSRange all = {0,[buffer length]};
    NSString* str= @"OK\r\n";
    NSData* str_data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSRange pos = [buffer rangeOfData:str_data options:0 range:all];
    if(0 != pos.location){
        str= @"HTTP/1.1 200 OK\r\n";
        str_data=[str dataUsingEncoding:NSUTF8StringEncoding];
        pos = [buffer rangeOfData:str_data options:0 range:all];
        if(0 != pos.location){
            [self _throw:YAPI_IO_ERROR:@"http request failed"];
            return nil;
        }
    }
    return buffer;
}


-(NSData*) _download:(NSString *)url
{
    NSData      *buffer;
    
    NSString *request = [NSString stringWithFormat:@"GET /%@ \r\n",url];
    buffer = [self _request:request withBody:nil];
    NSString *endofheader= @"\r\n\r\n";
    NSData   *endofheader_data=[endofheader dataUsingEncoding:NSISOLatin1StringEncoding];
    NSRange  all = {0,[buffer length]};
    NSRange  pos = [buffer rangeOfData:endofheader_data options:0 range:all];
    if(NSNotFound == pos.location){
        [self _throw:YAPI_IO_ERROR:@"http request failed"];
        return nil;
    }
    pos.location += [endofheader_data length];
    pos.length = all.length -pos.location;
    return   [buffer subdataWithRange:pos];
}

-(YRETCODE) _upload:(NSString *)path :(NSData *)content
{
    NSString *request = @"POST /upload.html HTTP/1.1\r\n";
    NSString *mp_header =    [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"api\"\r\n"
                                                            "Content-Type: application/octet-stream\r\n"
                                                            "Content-Transfer-Encoding: binary\r\n\r\n",path];
    NSString *boundary;
    NSRange  mp_head_pos,content_pos;
    do {
        boundary = [NSString stringWithFormat:@"Zz%06xzZ", rand() & 0xffffff];
        mp_head_pos =[mp_header rangeOfString:boundary];
        NSRange range={0,[content length]};
        content_pos =[content rangeOfData:[boundary dataUsingEncoding:NSISOLatin1StringEncoding] options:0 range:range];
    } while( mp_head_pos.location !=NSNotFound || content_pos.location!=NSNotFound);
    //construct header parts
    NSString *header_start = [NSString stringWithFormat:@"Content-Type: multipart/form-data; boundary=%@\r\n\r\n--%@\r\n%@",boundary,boundary,mp_header];
    NSString *header_stop  = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    NSMutableData *head_body = [NSMutableData dataWithCapacity:([header_start length] + [content length]+ [header_stop length])];
    [head_body appendData:[header_start dataUsingEncoding:NSISOLatin1StringEncoding]];
    [head_body appendData:content];
    [head_body appendData:[header_stop dataUsingEncoding:NSISOLatin1StringEncoding]];
    if ([self _request:request withBody:head_body]==nil){
        [self _throw:YAPI_IO_ERROR:@"http request failed"];
        return YAPI_IO_ERROR;
    }
    return YAPI_SUCCESS;
}


-(NSString*)   _json_get_key:(NSData*)json :(NSString*)key
{
    yJsonStateMachine j;
    const char *key_cstr= STR_oc2y(key);
    NSString *json_str = [[NSString alloc] initWithData:json encoding:NSASCIIStringEncoding];
    ARC_autorelease(json_str);
    // Parse JSON data for the device and locate our function in it
    j.src = STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        [self _throw:YAPI_IO_ERROR:@"JSON structure expected"];
        return nil;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j.token, key_cstr)) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                [self _throw:YAPI_IO_ERROR:@"JSON structure expected"];
                return nil;
            }
            return  [self _parseString:&j];
        }
        yJsonSkip(&j, 1);
    }
    return nil;
}

-(NSMutableArray*) _json_get_array:(NSData*)json
{
    NSMutableArray *res = [NSMutableArray array];
    yJsonStateMachine j;
    const char *json_cstr,*last;
    NSString *json_str = [[NSString alloc] initWithData:json encoding:NSASCIIStringEncoding];
    ARC_autorelease(json_str);
    j.src = json_cstr= STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_ARRAY) {
        [self _throw:YAPI_IO_ERROR:@"JSON structure expected"];
        return nil;
    }
    int depth =j.depth;
    do {
        last=j.src;
        while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.depth> depth );
        if (j.depth == depth ) {
            NSRange range;
            while(*last ==',' || *last =='\n')last++;
            range.location =last -json_cstr;
            range.length = j.src-last;
            NSString * item=[json_str substringWithRange:range];
            [res addObject:item];
        }
    } while ( j.st != YJSON_PARSE_ARRAY);
    return res;
}


/**
 * Returns a descriptive text that identifies the function.
 * The text always includes the class name, and may include as well
 * either the logical name of the function or its hardware identifier.
 * 
 * @return a string that describes the function
 */
-(NSString*)    description
{
    YFUN_DESCR   fundescr;
    NSString     *serial, *funcId;

    fundescr = [YapiWrapper  getFunction:_className: _func: NULL];
    if(!YISERR(fundescr) && !YISERR([YapiWrapper getFunctionInfo:fundescr: NULL: &serial: &funcId: NULL: NULL: NULL])) {
        return [NSString stringWithFormat:@"%@(%@)=%@.%@",_className,_func,serial,funcId];
    }
    return [NSString stringWithFormat:@"%@(%@)=unresolved",_className,_func];
}



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

-(NSString*)    describe
{ 
    return [self description];
}
     

/**
 * Returns a descriptive text that identifies the function.
 * The text always includes the class name, and may include as well
 * either the logical name of the function or its hardware identifier.
 *
 * @return a string that describes the function
 */
-(NSString*)    friendlyName
{
    YFUN_DESCR   fundescr;
    YDEV_DESCR   moddescr;
    NSString     *serial, *funcId,*funcname;
    NSString     *mod_serial, *mod_funcId,*mod_funcname;
    
    fundescr = [YapiWrapper  getFunction:_className: _func: NULL];
    if(!YISERR(fundescr) && !YISERR([YapiWrapper getFunctionInfo:fundescr: NULL: &serial: &funcId: &funcname: NULL: NULL])) {
        if([funcname length]!=0) {
            funcId = funcname;
        }

        moddescr = [YapiWrapper  getFunction:@"Module": serial: NULL];
        if(!YISERR(moddescr) && !YISERR([YapiWrapper getFunctionInfo:moddescr: NULL: &mod_serial: &mod_funcId: &mod_funcname: NULL: NULL])) {
            if([mod_funcname length]!=0) {
                return [NSString stringWithFormat:@"%@.%@",mod_funcname,funcId];
            }
        }
        return [NSString stringWithFormat:@"%@.%@",serial,funcId];
    }
    return Y_FRIENDLYNAME_INVALID;
}

    
-(NSString*)    get_friendlyName
{ return [self friendlyName];}



/**
 * Returns the unique hardware identifier of the function in the form SERIAL&#46;FUNCTIONID.
 * The unique hardware identifier is composed of the device serial
 * number and of the hardware identifier of the function. (for example RELAYLO1-123456.relay1)
 * 
 * @return a string that uniquely identifies the function (ex: RELAYLO1-123456.relay1)
 * 
 * On failure, throws an exception or returns  Y_HARDWAREID_INVALID.
 */
-(NSString*)    get_hardwareId
{    return [self hardwareId];}

-(NSString*) hardwareId
{
    YFUN_DESCR   fundescr;
    NSString     *funcId,*snum;
    NSError      *error;
    YRETCODE     res;
    
    // Get our function Id
    fundescr = [YapiWrapper getFunction:_className:_func:&error];
    if(YISERR(fundescr)) {
        [self _throw:error];
        return Y_HARDWAREID_INVALID;
    }
    res = [YapiWrapper getFunctionInfo:fundescr :NULL :&snum :&funcId :NULL :NULL :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return Y_HARDWAREID_INVALID;
    }
    return [NSString stringWithFormat:@"%@.%@",snum,funcId ];
}


/**
 * Returns the hardware identifier of the function, without reference to the module. For example
 * relay1
 * 
 * @return a string that identifies the function (ex: relay1)
 * 
 * On failure, throws an exception or returns  Y_FUNCTIONID_INVALID.
 */
-(NSString*)    get_functionId
{    return [self functionId];}

-(NSString*) functionId
{
    YFUN_DESCR   fundescr;
    NSString     *funcId,*snum;
    NSError      *error;
    YRETCODE     res;
    
    // Get our function Id
    fundescr = [YapiWrapper getFunction:_className:_func:&error];
    if(YISERR(fundescr)) {
        [self _throw:error];
        return Y_FUNCTIONID_INVALID;
    }
    res = [YapiWrapper getFunctionInfo:fundescr :NULL :&snum :&funcId :NULL :NULL :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return Y_FUNCTIONID_INVALID;
    }
    return funcId;
}


/**
 * Returns the numerical error code of the latest error with this function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 * 
 * @return a number corresponding to the code of the latest error that occured while
 *         using this function object
 */
-(YRETCODE)    get_errType
{return [self errType];}
-(YRETCODE)    errType
{
    return (YRETCODE) [_lastError code];
}
    
/**
 * Returns the error message of the latest error with this function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 * 
 * @return a string corresponding to the latest error message that occured while
 *         using this function object
 */
-(NSString*)    get_errorMessage
{return [self errorMessage];}
 -(NSString*)   errorMessage
{
    return [_lastError localizedDescription];
}
    
/**
 * Checks if the function is currently reachable, without raising any error.
 * If there is a cached value for the function in cache, that has not yet
 * expired, the device is considered reachable.
 * No exception is raised if there is an error while trying to contact the
 * device hosting the requested function.
 * 
 * @return true if the function can be reached, and false otherwise
 */
-(BOOL)        isOnline
{
    YDevice     *dev;
    NSString    *apires;

    // A valid value in cache means that the device is online
    if(_cacheExpiration > [YAPI GetTickCount]) return YES;
    
    // Check that the function is available, without throwing exceptions
    if(YISERR([self _getDevice:&dev:NULL])) return NO;

    // Try to execute a function request to be positively sure that the device is ready
    if(YISERR([dev requestAPI:&apires: NULL])) return NO;
       
    return YES;   
}

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
-(YRETCODE)    load:(int) msValidity
{
    yJsonStateMachine j;
    YDevice     *dev;
    NSError     *error;
    NSString    *apires;
    YFUN_DESCR  fundescr;
    YRETCODE    res;
    char        errbuf[YOCTO_ERRMSG_LEN];
    char        funcId[YOCTO_FUNCTION_LEN];

    // Resolve our reference to our device, load REST API
    res = [self _getDevice:&dev:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    res = [dev requestAPI:&apires:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    
    // Get our function Id
    fundescr = [YapiWrapper getFunction:_className:_func:&error];
    if(YISERR(fundescr)) {
        [self _throw:error];
        return (YRETCODE)fundescr;
    }
    res = yapiGetFunctionInfo(fundescr, NULL, NULL, funcId, NULL, NULL, errbuf);
    if(YISERR(res)) {
        res = yFormatRetVal(&error,res,errbuf);
        [self _throw:error];
        return res;
    }            

    // Parse JSON data for the device and locate our function in it
    j.src = STR_oc2y(apires);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        yFormatRetVal(&error,YAPI_IO_ERROR,"JSON structure expected");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j.token, funcId)) {
            [self _parse:&j];
            break;
        }
        yJsonSkip(&j, 1);
    }
    _cacheExpiration = yapiGetTickCount() + msValidity;
    
    return YAPI_SUCCESS;
}

/**
 * Gets the YModule object for the device on which the function is located.
 * If the function cannot be located on any module, the returned instance of
 * YModule is not shown as on-line.
 * 
 * @return an instance of YModule
 */
-(YModule*)    get_module
{    return [self module];}

 -(YModule*)    module
{
    YFUN_DESCR   fundescr;
    YDEV_DESCR   devdescr;
    NSString     *serial, *funcId, *funcName, *funcValue;
    
    fundescr = [YapiWrapper getFunction:_className: _func: NULL];
    if(!YISERR(fundescr)) {
        if(!YISERR([YapiWrapper getFunctionInfo:fundescr:&devdescr:&serial:&funcId:&funcName:&funcValue:NULL])) {
            return [YModule FindModule:[serial stringByAppendingString: @".module"] ];
        }
    }
    // return a true YModule object even if it is not a module valid for communicating
    return [YModule FindModule:[NSString stringWithFormat:@"module_of_%@_%@",_className,_func]];

    
}



-(YFUN_DESCR)     get_functionDescriptor
{   return [self functionDescriptor];}
-(YFUN_DESCR)     functionDescriptor
{
    return _fundescr;
}

-(void*)    get_userData
{   return [self userData];}
-(void*)    userData
{
    return _userData;
}


-(void)     set_userData:(void*) data
{ [self setUserData:data];}
-(void)     setUserData:(void*) data
{
    _userData =data;
}



-(void) _registerFuncCallback
{
    unsigned i;
    [self isOnline];
    if (_FunctionCallbacks == nil){
        _FunctionCallbacks = [[NSMutableArray alloc] init];
    }
    for (i=0 ; i< [_FunctionCallbacks count];i++) {        
        if ([_FunctionCallbacks objectAtIndex:i] == self) {
            return;
        }
    }
    [_FunctionCallbacks  addObject:self];
   }

-(void) _unregisterFuncCallback
{
    unsigned i;
    for (i=0 ; i< [_FunctionCallbacks count];i++) {        
        if ([_FunctionCallbacks objectAtIndex:i] == self) {
            [_FunctionCallbacks removeObjectAtIndex:i];
        }
    }
}




#import <objc/message.h>

-(void)     notifyValue:(NSString *)value
{
    if(_callback != NULL){
        _callback(self,value);
    }
    if(_callbackObject && [_callbackObject respondsToSelector:_callbackSel]) {
        objc_msgSend(_callbackObject, _callbackSel, self, value);
    }
}


                    
@end //YFunction




@implementation YModule

// Constructor is protected, use yFindModule factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (generated code: YModule attributes)
   if(!(self = [super initProtected:@"Module":func]))
          return nil;
    _productName = Y_PRODUCTNAME_INVALID;
    _serialNumber = Y_SERIALNUMBER_INVALID;
    _logicalName = Y_LOGICALNAME_INVALID;
    _productId = Y_PRODUCTID_INVALID;
    _productRelease = Y_PRODUCTRELEASE_INVALID;
    _firmwareRelease = Y_FIRMWARERELEASE_INVALID;
    _persistentSettings = Y_PERSISTENTSETTINGS_INVALID;
    _luminosity = Y_LUMINOSITY_INVALID;
    _beacon = Y_BEACON_INVALID;
    _upTime = Y_UPTIME_INVALID;
    _usbCurrent = Y_USBCURRENT_INVALID;
    _rebootCountdown = Y_REBOOTCOUNTDOWN_INVALID;
    _usbBandwidth = Y_USBBANDWIDTH_INVALID;
//--- (end of generated code: YModule attributes)
    return self;
}

-(void) dealloc
{
//--- (generated code: YModule cleanup)
    ARC_release(_productName);
    _productName = nil;
    ARC_release(_serialNumber);
    _serialNumber = nil;
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_firmwareRelease);
    _firmwareRelease = nil;
//--- (end of generated code: YModule cleanup)
    [super dealloc];
}
//--- (generated code: YModule implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "productName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_productName);
            _productName =  [self _parseString:j];
            ARC_retain(_productName);
        } else if(!strcmp(j->token, "serialNumber")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_serialNumber);
            _serialNumber =  [self _parseString:j];
            ARC_retain(_serialNumber);
        } else if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "productId")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _productId =  atoi(j->token);
        } else if(!strcmp(j->token, "productRelease")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _productRelease =  atoi(j->token);
        } else if(!strcmp(j->token, "firmwareRelease")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_firmwareRelease);
            _firmwareRelease =  [self _parseString:j];
            ARC_retain(_firmwareRelease);
        } else if(!strcmp(j->token, "persistentSettings")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _persistentSettings =  atoi(j->token);
        } else if(!strcmp(j->token, "luminosity")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _luminosity =  atoi(j->token);
        } else if(!strcmp(j->token, "beacon")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _beacon =  (Y_BEACON_enum)atoi(j->token);
        } else if(!strcmp(j->token, "upTime")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _upTime =  atoi(j->token);
        } else if(!strcmp(j->token, "usbCurrent")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _usbCurrent =  atoi(j->token);
        } else if(!strcmp(j->token, "rebootCountdown")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _rebootCountdown =  atoi(j->token);
        } else if(!strcmp(j->token, "usbBandwidth")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _usbBandwidth =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the commercial name of the module, as set by the factory.
 * 
 * @return a string corresponding to the commercial name of the module, as set by the factory
 * 
 * On failure, throws an exception or returns Y_PRODUCTNAME_INVALID.
 */
-(NSString*) get_productName
{
    return [self productName];
}
-(NSString*) productName
{
    if(_productName == Y_PRODUCTNAME_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PRODUCTNAME_INVALID;
    }
    return _productName;
}

/**
 * Returns the serial number of the module, as set by the factory.
 * 
 * @return a string corresponding to the serial number of the module, as set by the factory
 * 
 * On failure, throws an exception or returns Y_SERIALNUMBER_INVALID.
 */
-(NSString*) get_serialNumber
{
    return [self serialNumber];
}
-(NSString*) serialNumber
{
    if(_serialNumber == Y_SERIALNUMBER_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_SERIALNUMBER_INVALID;
    }
    return _serialNumber;
}

/**
 * Returns the logical name of the module.
 * 
 * @return a string corresponding to the logical name of the module
 * 
 * On failure, throws an exception or returns Y_LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    return [self logicalName];
}
-(NSString*) logicalName
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LOGICALNAME_INVALID;
    }
    return _logicalName;
}

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
-(int) set_logicalName:(NSString*) newval
{
    return [self setLogicalName:newval];
}
-(int) setLogicalName:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}

/**
 * Returns the USB device identifier of the module.
 * 
 * @return an integer corresponding to the USB device identifier of the module
 * 
 * On failure, throws an exception or returns Y_PRODUCTID_INVALID.
 */
-(int) get_productId
{
    return [self productId];
}
-(int) productId
{
    if(_productId == Y_PRODUCTID_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PRODUCTID_INVALID;
    }
    return _productId;
}

/**
 * Returns the hardware release version of the module.
 * 
 * @return an integer corresponding to the hardware release version of the module
 * 
 * On failure, throws an exception or returns Y_PRODUCTRELEASE_INVALID.
 */
-(int) get_productRelease
{
    return [self productRelease];
}
-(int) productRelease
{
    if(_productRelease == Y_PRODUCTRELEASE_INVALID) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PRODUCTRELEASE_INVALID;
    }
    return _productRelease;
}

/**
 * Returns the version of the firmware embedded in the module.
 * 
 * @return a string corresponding to the version of the firmware embedded in the module
 * 
 * On failure, throws an exception or returns Y_FIRMWARERELEASE_INVALID.
 */
-(NSString*) get_firmwareRelease
{
    return [self firmwareRelease];
}
-(NSString*) firmwareRelease
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_FIRMWARERELEASE_INVALID;
    }
    return _firmwareRelease;
}

/**
 * Returns the current state of persistent module settings.
 * 
 * @return a value among Y_PERSISTENTSETTINGS_LOADED, Y_PERSISTENTSETTINGS_SAVED and
 * Y_PERSISTENTSETTINGS_MODIFIED corresponding to the current state of persistent module settings
 * 
 * On failure, throws an exception or returns Y_PERSISTENTSETTINGS_INVALID.
 */
-(Y_PERSISTENTSETTINGS_enum) get_persistentSettings
{
    return [self persistentSettings];
}
-(Y_PERSISTENTSETTINGS_enum) persistentSettings
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_PERSISTENTSETTINGS_INVALID;
    }
    return _persistentSettings;
}

-(int) set_persistentSettings:(Y_PERSISTENTSETTINGS_enum) newval
{
    return [self setPersistentSettings:newval];
}
-(int) setPersistentSettings:(Y_PERSISTENTSETTINGS_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"persistentSettings" :rest_val];
}

/**
 * Saves current settings in the nonvolatile memory of the module.
 * Warning: the number of allowed save operations during a module life is
 * limited (about 100000 cycles). Do not call this function within a loop.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) saveToFlash
{
    NSString* rest_val;
    rest_val = @"1";
    return [self _setAttr:@"persistentSettings" :rest_val];
}

/**
 * Reloads the settings stored in the nonvolatile memory, as
 * when the module is powered on.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) revertFromFlash
{
    NSString* rest_val;
    rest_val = @"0";
    return [self _setAttr:@"persistentSettings" :rest_val];
}

/**
 * Returns the luminosity of the  module informative leds (from 0 to 100).
 * 
 * @return an integer corresponding to the luminosity of the  module informative leds (from 0 to 100)
 * 
 * On failure, throws an exception or returns Y_LUMINOSITY_INVALID.
 */
-(int) get_luminosity
{
    return [self luminosity];
}
-(int) luminosity
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_LUMINOSITY_INVALID;
    }
    return _luminosity;
}

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
-(int) set_luminosity:(int) newval
{
    return [self setLuminosity:newval];
}
-(int) setLuminosity:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"luminosity" :rest_val];
}

/**
 * Returns the state of the localization beacon.
 * 
 * @return either Y_BEACON_OFF or Y_BEACON_ON, according to the state of the localization beacon
 * 
 * On failure, throws an exception or returns Y_BEACON_INVALID.
 */
-(Y_BEACON_enum) get_beacon
{
    return [self beacon];
}
-(Y_BEACON_enum) beacon
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_BEACON_INVALID;
    }
    return _beacon;
}

/**
 * Turns on or off the module localization beacon.
 * 
 * @param newval : either Y_BEACON_OFF or Y_BEACON_ON
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_beacon:(Y_BEACON_enum) newval
{
    return [self setBeacon:newval];
}
-(int) setBeacon:(Y_BEACON_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"beacon" :rest_val];
}

/**
 * Returns the number of milliseconds spent since the module was powered on.
 * 
 * @return an integer corresponding to the number of milliseconds spent since the module was powered on
 * 
 * On failure, throws an exception or returns Y_UPTIME_INVALID.
 */
-(unsigned) get_upTime
{
    return [self upTime];
}
-(unsigned) upTime
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_UPTIME_INVALID;
    }
    return _upTime;
}

/**
 * Returns the current consumed by the module on the USB bus, in milli-amps.
 * 
 * @return an integer corresponding to the current consumed by the module on the USB bus, in milli-amps
 * 
 * On failure, throws an exception or returns Y_USBCURRENT_INVALID.
 */
-(unsigned) get_usbCurrent
{
    return [self usbCurrent];
}
-(unsigned) usbCurrent
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_USBCURRENT_INVALID;
    }
    return _usbCurrent;
}

/**
 * Returns the remaining number of seconds before the module restarts, or zero when no
 * reboot has been scheduled.
 * 
 * @return an integer corresponding to the remaining number of seconds before the module restarts, or zero when no
 *         reboot has been scheduled
 * 
 * On failure, throws an exception or returns Y_REBOOTCOUNTDOWN_INVALID.
 */
-(int) get_rebootCountdown
{
    return [self rebootCountdown];
}
-(int) rebootCountdown
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_REBOOTCOUNTDOWN_INVALID;
    }
    return _rebootCountdown;
}

-(int) set_rebootCountdown:(int) newval
{
    return [self setRebootCountdown:newval];
}
-(int) setRebootCountdown:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"rebootCountdown" :rest_val];
}

/**
 * Schedules a simple module reboot after the given number of seconds.
 * 
 * @param secBeforeReboot : number of seconds before rebooting
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reboot :(int)secBeforeReboot
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", secBeforeReboot];
    return [self _setAttr:@"rebootCountdown" :rest_val];
}

/**
 * Schedules a module reboot into special firmware update mode.
 * 
 * @param secBeforeReboot : number of seconds before rebooting
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerFirmwareUpdate :(int)secBeforeReboot
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", -secBeforeReboot];
    return [self _setAttr:@"rebootCountdown" :rest_val];
}

/**
 * Returns the number of USB interfaces used by the module.
 * 
 * @return either Y_USBBANDWIDTH_SIMPLE or Y_USBBANDWIDTH_DOUBLE, according to the number of USB
 * interfaces used by the module
 * 
 * On failure, throws an exception or returns Y_USBBANDWIDTH_INVALID.
 */
-(Y_USBBANDWIDTH_enum) get_usbBandwidth
{
    return [self usbBandwidth];
}
-(Y_USBBANDWIDTH_enum) usbBandwidth
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_USBBANDWIDTH_INVALID;
    }
    return _usbBandwidth;
}

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
-(int) set_usbBandwidth:(Y_USBBANDWIDTH_enum) newval
{
    return [self setUsbBandwidth:newval];
}
-(int) setUsbBandwidth:(Y_USBBANDWIDTH_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", newval];
    return [self _setAttr:@"usbBandwidth" :rest_val];
}
/**
 * Downloads the specified built-in file and returns a binary buffer with its content.
 * 
 * @param pathname : name of the new file to load
 * 
 * @return a binary buffer with the file content
 * 
 * On failure, throws an exception or returns an empty content.
 */
-(NSData*) download :(NSString*)pathname
{
    return [self _download:pathname];
    
}

/**
 * Returns the icon of the module. The icon is a PNG image and does not
 * exceeds 1536 bytes.
 * 
 * @return a binary buffer with module icon, in png format.
 */
-(NSData*) get_icon2d
{
    return [self _download:@"icon2d.png"];
    
}

/**
 * Returns a string with last logs of the module. This method return only
 * logs that are still in the module.
 * 
 * @return a string with last logs of the module.
 */
-(NSString*) get_lastLogs
{
    NSData* content;
    content = [self _download:@"logs.txt"];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSASCIIStringEncoding]);
    
}


-(YModule*)   nextModule
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindModule(hwid);
}

+(YModule*) FindModule:(NSString*) func
{
    YModule * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    if ([YAPI_YFunctions objectForKey:@"YModule"] == nil){
        [YAPI_YFunctions setObject:[NSMutableDictionary dictionary] forKey:@"YModule"];
    }
    if(nil != [[YAPI_YFunctions objectForKey:@"YModule"] objectForKey:func]){
        retVal = [[YAPI_YFunctions objectForKey:@"YModule"] objectForKey:func];
    } else {
        retVal = [[YModule alloc] initWithFunction:func];
        [[YAPI_YFunctions objectForKey:@"YModule"] setObject:retVal forKey:func];
        ARC_autorelease(retVal);
    }
    return retVal;
}

+(YModule *) FirstModule
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;
    
    if(!YISERR([YapiWrapper getFunctionsByClass:@"Module":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YModule FindModule:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YModule implementation)

/**
 * Returns a descriptive text that identifies the function.
 * The text always includes the class name, and may include as well
 * either the logical name of the function or its hardware identifier.
 *
 * @return a string that describes the function
 */
-(NSString*)    friendlyName
{
    YFUN_DESCR   fundescr;
    NSString     *serial, *funcId,*funcname;
    
    fundescr = [YapiWrapper  getFunction:_className: _func: NULL];
    if(!YISERR(fundescr) && !YISERR([YapiWrapper getFunctionInfo:fundescr: NULL: &serial: &funcId: &funcname: NULL: NULL])) {
        if([funcname length]!=0) {
            serial = funcname;
        }
        return serial;
    }
    return Y_FRIENDLYNAME_INVALID;
}



// Method used to retrieve details of the nth function of our device
-(YRETCODE)        _getFunction:(int) idx  :(NSString**)serial  :(NSString**)funcId :(NSString**)funcName :(NSString**)funcVal :(NSError**)error
{
    NSArray         *functions;
    NSNumber        *ns_fundescr;
    YDevice         *dev;
    int             res;
    YFUN_DESCR      fundescr;
    YDEV_DESCR      devdescr;
    NSError         *tmp;
    
    // retrieve device object
    res = [self _getDevice:&dev:&tmp];
    if(YISERR(res)) {
        if(error)
            *error =tmp;
        [self _throw:tmp];
        return (YRETCODE)res;
    }
    
    // get reference to all functions from the device
    res = [dev getFunctions:&functions :error];
    if(YISERR(res)) return (YRETCODE)res;
    
    // get latest function info from yellow pages
    
    ns_fundescr = [functions objectAtIndex:idx];
    fundescr = [ns_fundescr intValue];
    res = [YapiWrapper getFunctionInfo:fundescr:&devdescr:serial:funcId:funcName:funcVal:error];
    if(YISERR(res)) return (YRETCODE)res;
    
    return YAPI_SUCCESS;
    
}


// Retrieve the number of functions (beside "module") in the device
-(int)              functionCount
{
    NSMutableArray  *functions;
    YDevice     *dev;
    NSError     *error;
    int         res;
    
    res =[self _getDevice:&dev:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    res = [dev getFunctions:&functions:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return (YRETCODE)res;
    }
    return (int)[functions count];
    
}

// Retrieve the Id of the nth function (beside "module") in the device
-(NSString*)           functionId:(int) functionIndex
{
    NSString      *serial, *funcId, *funcName, *funcVal;
    NSError       *error;
    
    int res = [self _getFunction:functionIndex:&serial:&funcId:&funcName:&funcVal:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }
    return funcId; 
}

// Retrieve the logical name of the nth function (beside "module") in the device
-(NSString*)           functionName:(int) functionIndex
{
    NSString    *serial, *funcId, *funcName, *funcVal;
    NSError     *error;
    
    int res = [self _getFunction:functionIndex:&serial:&funcId:&funcName:&funcVal:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }
    
    return funcName; 
}


// Retrieve the advertised value of the nth function (beside "module") in the device
-(NSString*)           functionValue:(int) functionIndex
{
    NSString    *serial, *funcId, *funcName, *funcVal;
    NSError     *error;
    
    int res = [self _getFunction:functionIndex:&serial:&funcId:&funcName:&funcVal:&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }    
    
    return funcVal;
}


@end //YModule





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
YRETCODE yInitAPI(int mode, NSError** errmsg) 
{ return [YAPI InitAPI:mode:errmsg]; }


/**
 * Frees dynamically allocated memory blocks used by the Yoctopuce library.
 * It is generally not required to call this function, unless you
 * want to free all dynamically allocated memory blocks in order to
 * track a memory leak for instance.
 * You should not call any other library function after calling
 * yFreeAPI(), or your program will crash.
 */
void yFreeAPI(void)
{ [YAPI FreeAPI]; }



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
NSString* yGetAPIVersion(void)
{
    return [YAPI GetAPIVersion];
}


/**
 * Disables the use of exceptions to report runtime errors.
 * When exceptions are disabled, every function returns a specific
 * error value which depends on its type and which is documented in
 * this reference manual.
 */
void yDisableExceptions(void) { [YAPI DisableExceptions]; }

/**
 * Re-enables the use of exceptions for runtime error handling.
 * Be aware than when exceptions are enabled, every function that fails
 * triggers an exception. If the exception is not caught by the user code,
 * it  either fires the debugger or aborts (i.e. crash) the program.
 * On failure, throws an exception or returns a negative error code.
 */
void yEnableExceptions(void)  { [YAPI EnableExceptions]; }

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
YRETCODE yRegisterHub(NSString * url, NSError** errmsg) { return [YAPI RegisterHub:url:errmsg]; }

/** 
 * 
 */
YRETCODE yPreregisterHub(NSString * url, NSError** errmsg) { return [YAPI PreregisterHub:url:errmsg]; }

/**
 * Setup the Yoctopuce library to no more use modules connected on a previously
 * registered machine with RegisterHub.
 * 
 * @param url : a string containing either "usb" or the
 *         root URL of the hub to monitor
 */
void     yUnregisterHub(NSString * url) { [YAPI UnregisterHub:url]; }



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
YRETCODE yUpdateDeviceList(NSError** errmsg) {  return [YAPI  UpdateDeviceList:errmsg]; }

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
YRETCODE yHandleEvents(NSError** errmsg)
{ return [YAPI HandleEvents:errmsg];}

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
YRETCODE ySleep(unsigned ms_duration, NSError **errmsg)
{ return [YAPI Sleep:ms_duration:errmsg]; }


/**
 * (Objective-C only) Register an object that must follow the procol YDeviceHotPlug. The methodes
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param object : an object that must follow the procol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */

void ySetDelegate(id object)
{
    [YAPI SetDelegate:object];
}


/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the milisecond as timebase.
 * 
 * @return a long integer corresponding to the millisecond counter.
 */
u64 yGetTickCount(void) { return [YAPI GetTickCount]; }

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
BOOL yCheckLogicalName(NSString * name){  return [YAPI  CheckLogicalName:name]; }

/**
 * Register a callback function, to be called each time
 * a device is pluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param arrivalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceArrivalCallback(yDeviceUpdateCallback arrivalCallback)
{   [YAPI  RegisterDeviceArrivalCallback:arrivalCallback];}

/**
 * Register a callback function, to be called each time
 * a device is unpluged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 * 
 * @param removalCallback : a procedure taking a YModule parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceRemovalCallback(yDeviceUpdateCallback removalCallback)
{   [YAPI  RegisterDeviceRemovalCallback:removalCallback];}
void    yRegisterDeviceChangeCallback(yDeviceUpdateCallback changeCallback)
{   [YAPI  RegisterDeviceChangeCallback:changeCallback];}

/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite usefull to debug the API.
 * 
 * @param logfun : a procedure taking a string parameter, or null
 *         to unregister a previously registered  callback.
 */
void    yRegisterLogFunction(yLogCallback logfun)
{   [YAPI  RegisterLogFunction:logfun];}




//--- (generated code: Module functions)

YModule *yFindModule(NSString* func)
{
    return [YModule FindModule:func];
}

YModule *yFirstModule(void)
{
    return [YModule FirstModule];
}

//--- (end of generated code: Module functions)


