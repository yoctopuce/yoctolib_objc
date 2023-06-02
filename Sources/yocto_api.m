/*********************************************************************
 *
 * $Id: yocto_api.m 54649 2023-05-22 10:09:20Z seb $
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

NSString *           YAPI_INVALID_STRING=@"!INVALID!";

static yDeviceUpdateCallback YAPI_deviceArrivalCallback = NULL;
static yDeviceUpdateCallback YAPI_deviceRemovalCallback = NULL;
static yDeviceUpdateCallback YAPI_deviceChangeCallback = NULL;
static YHubDiscoveryCallback YAPI_HubDiscoveryCallback = NULL;
static id              YAPI_delegate=nil;




NSMutableDictionary* YAPI_YFunctions;

@implementation  YapiEvent

-(id) initFull:(yapiEventType)type :(YModule*)module :(YFunction*)function :(NSString*)value :(int)beacon
{
    if((self=[super init])){
        _type      = type;
        _module    = module;
        _function  = function;
        _value = value;
        _beacon = beacon;
        if(_value!=nil){
            ARC_retain(_value);
        }
    }
    return self;
}

-(id) initDeviceEvent:(yapiEventType)type forModule:(YModule*)module
{
    return [self initFull:type:module :nil :nil :-1];
}


-(id) initDeviceEvent:(yapiEventType)type forModule:(YModule*)module andBeacon:(int)beacon
{
    return [self initFull:type:module :nil :nil :beacon];
}

-(id) initFunction:(YFunction*)function withEvent:(unsigned) type
{
    return [self initFull:type :nil :function :nil :-1];
}

-(id) initFunction:(YFunction*)function newValue:(NSString*)value
{
    return [self initFull:YAPI_FUN_VALUE :nil :function :value :-1];
}

-(id) initWithSensor:(YSensor*)sensor AndTimestamp:(double)timestamp AndDuration:(double)duration AndReport:(NSMutableArray*) report
{
    if((self=[super init])){
        _type = YAPI_FUN_TIMEDREPORT;
        _sensor = sensor;
        _timestamp = timestamp;
        _duration = duration;
        _report =report;
        ARC_retain(_report);
    }
    return self;
}


-(id) initHubEvent:(NSString*)serial withUrl:(NSString*)url
{
    if((self = [super init])){
        _type = YAPI_HUB_DISCOVERY;
        _serial = serial;
        ARC_retain(_serial);
        _url = url;
        ARC_retain(_url);
    }
    return self;
}


-(id) _init
{
    return [self initFull:YAPI_INVALID:nil:nil:nil:-1];
}

-(void)  dealloc
{
    if (_value!=nil){
        ARC_release(_value);
    }
    if (_report != nil){
        ARC_release(_report);
    }
    if (_serial!=nil){
        ARC_release(_serial);
    }
    if (_url != nil){
        ARC_release(_url);
    }
    _module=nil;
    _function=nil;
    ARC_dealloc(super);
}

-(void) invokeFunctionEvent
{
    YMeasure* measure;
    switch (_type) {
        case YAPI_FUN_VALUE:
            [_function _invokeValueCallback:_value];
            break;
        case YAPI_FUN_TIMEDREPORT:
            if([[_report objectAtIndex:0] intValue] <= 2) {
                measure = [_sensor _decodeTimedReport:_timestamp :_duration :_report];
                [_sensor _invokeTimedReportCallback:measure];
            }
            break;
        case YAPI_FUN_REFRESH:
            [_function isOnline];
            break;
        case YAPI_DEV_CONFCHANGE:
            [_module _invokeConfigChangeCallback];
            break;
        case YAPI_DEV_BEACON:
            [_module _invokeBeaconCallback:_beacon];
            break;
        default:
            break;
    }
}

-(void) invokePlugEvent
{
    switch(_type){
        case YAPI_DEV_ARRIVAL:
            if(YAPI_deviceArrivalCallback)
                YAPI_deviceArrivalCallback(_module);
            if(YAPI_delegate!=nil) {
                SEL sel = @selector(yDeviceArrival:);
                if([YAPI_delegate respondsToSelector:sel]) {
                    [YAPI_delegate yDeviceArrival:_module];
                }
            }
            break;
        case YAPI_DEV_REMOVAL:
            if(YAPI_deviceRemovalCallback)
                YAPI_deviceRemovalCallback(_module);
            if(YAPI_delegate!=nil) {
                SEL sel = @selector(yDeviceRemoval:);
                if([YAPI_delegate respondsToSelector:sel]) {
                    [YAPI_delegate yDeviceRemoval:_module];
                }
            }
            break;
        case YAPI_DEV_CHANGE:
            if(YAPI_deviceChangeCallback)
                YAPI_deviceChangeCallback(_module);
            break;
        case YAPI_HUB_DISCOVERY:
            if(YAPI_HubDiscoveryCallback)
                YAPI_HubDiscoveryCallback(_serial, _url);
            break;
        default:
            break;
    }

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


NSString *           Y_INVALID_STRING        = @"!INVALID!";


//
// YAPI Context
//
// This class provides Objective-C style entry points to lowlevcel functions defined to yapi.h
// Could be implemented by a singleton, we use static methods insead


// global variables to emulate static data member of YAPI class
static int           YAPI_defaultCacheValidity  = 5;
static BOOL          YAPI_exceptionsDisabled    = NO;
static BOOL          YAPI_apiInitialized        = NO;

static NSMutableArray *YAPI_plug_events = nil;
static NSMutableArray *YAPI_data_events = nil;


static NSMutableArray* _ValueCallbackList = nil;
static NSMutableArray* _TimedReportCallbackList = nil;
static NSMutableArray* _devCache = nil;
static NSMutableDictionary* YFunctions_cache = nil;
static NSMutableDictionary* _moduleCallbackList = nil;



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

static void yapiDeviceLogCallbackFwd(YDEV_DESCR devdescr, const char* line)
{
    YModule             *module;
    yDeviceSt           infos;
    YModuleLogCallback  callback;

    if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) {
        return;
    }
    module = [YModule FindModule:[STR_y2oc(infos.serial) stringByAppendingFormat:@".module"]];
    callback = [module get_logCallback];
    if (callback) {
        callback(module, STR_y2oc(line));
    }
}



static void yapiDeviceArrivalCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    @autoreleasepool {
        [YDevice PlugDevice:devdescr];
        if(_ValueCallbackList != nil) {
            //look if we have some allocated function with a callback to refresh
            for (id it in _ValueCallbackList) {
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
        module = [YModule FindModule:[STR_y2oc(infos.serial) stringByAppendingFormat:@".module"]];
        if(!YAPI_deviceArrivalCallback && YAPI_delegate==nil) return;
        ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_ARRIVAL forModule:module];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}

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

static void yapiDeviceChangeCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    @autoreleasepool {
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) return;
        module = yFindModule([STR_y2oc(infos.serial) stringByAppendingFormat:@".module"]);
        if(!YAPI_deviceChangeCallback && YAPI_delegate==nil) return;
        ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_CHANGE forModule:module];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}

static void yapiDeviceConfigChangeCallbackFwd(YAPI_DEVICE devdescr)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    NSString     *serial;
    NSNumber     *val;
    @autoreleasepool {
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) return;
         serial = STR_y2oc(infos.serial);
        module = yFindModule([serial stringByAppendingFormat:@".module"]);
        val = [_moduleCallbackList objectForKey:serial] ;
        if (val != nil) {
            int int_val = [val intValue];
            if (int_val > 0) {
                ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_CONFCHANGE forModule:module];
                [YAPI_data_events addObject:ev];
                ARC_release(ev);
            }
        }
    }
}


static void yapiBeaconCallbackFwd(YAPI_DEVICE devdescr, int beacon)
{
    YapiEvent    *ev;
    yDeviceSt    infos;
    YModule      *module;
    NSString     *serial;
    NSNumber     *val;
    @autoreleasepool {
        if(YISERR(yapiGetDeviceInfo(devdescr,&infos,NULL))) return;
        serial = STR_y2oc(infos.serial);
        module = yFindModule([serial stringByAppendingFormat:@".module"]);
        val = [_moduleCallbackList objectForKey:serial] ;
        if (val != nil) {
            int int_val = [val intValue];
            if (int_val > 0) {
                ev =[[YapiEvent alloc] initDeviceEvent:YAPI_DEV_BEACON forModule:module andBeacon:beacon];
                [YAPI_data_events addObject:ev];
                ARC_release(ev);
            }
        }
    }
}




static void yapiHubDiscoveryCallbackFwd(const char *serial_ptr, const char *url_ptr)
{
    YapiEvent    *ev;
    @autoreleasepool {
        if (YAPI_HubDiscoveryCallback == NULL) return;
        NSString *serial = STR_y2oc(serial_ptr);
        NSString *url = STR_y2oc(url_ptr);
        ev =[[YapiEvent alloc] initHubEvent:serial withUrl:url];
        [YAPI_plug_events addObject:ev];
        ARC_release(ev);
    }
}


static void yInternalPushNewVal(YAPI_FUNCTION fundescr,NSString * value)
{
    YapiEvent  *ev;
    if (_ValueCallbackList==nil)
        return;
    for (id it in _ValueCallbackList) {
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


static void yapiTimedReportCallbackFwd(YAPI_FUNCTION fundescr,double timestamp, const u8* bytes, u32 len, double duration)
{
    YapiEvent  *ev;
    if (_TimedReportCallbackList==nil)
        return;
    for (id it in _TimedReportCallbackList) {
        if ([it functionDescriptor] == fundescr){
            NSMutableArray * report = [NSMutableArray arrayWithCapacity:len];
            for (int i = 0; i < len; i++) {
                [report addObject:[NSNumber numberWithUnsignedShort:bytes[i]]];
            }
            ev =[[YapiEvent alloc] initWithSensor:it AndTimestamp:timestamp AndDuration:duration AndReport:report];
            [YAPI_data_events addObject:ev];
            ARC_release(ev);
        }
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
    unsigned long npt;
    double x   = [[rawValues objectAtIndex:0] doubleValue];
    double adj = [[refValues objectAtIndex:0] doubleValue]- x;
    int    i   = 0;

    if(calibType < YOCTO_CALIB_TYPE_OFS) {
        npt = calibType % 10;
        if(npt > [rawValues count])
            npt = [rawValues count];
        if(npt > [refValues count])
            npt = [refValues count];
    } else {
        npt = [refValues count];
    }
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



int _ystrpos(NSString* haystack, NSString* needle)
{
    NSRange range = [haystack rangeOfString:needle];
    if (range.location == NSNotFound) {
        return -1;
    }
    return (int)range.location;
}

@implementation YHub

-(id) initWith:(YAPIContext*)ctx :(int)hubref
{
   if(!(self = [super init]))
          return nil;
//--- (generated code: YHub attributes initialization)
    _hubref = 0;
    _userData = nil;
//--- (end of generated code: YHub attributes initialization)
    _ctx = ctx;
    _hubref = hubref;
    return self;
}
// destructor
-(void)  dealloc
{
//--- (generated code: YHub cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YHub cleanup)
}
//--- (generated code: YHub private methods implementation)

//--- (end of generated code: YHub private methods implementation)
//--- (generated code: YHub public methods implementation)
-(NSString*) _getStrAttr:(NSString*)attrName
{
    char val[1024];
    int res;
    int fullsize;
    fullsize = 0;
    res = yapiGetHubStrAttr(_hubref, STR_oc2y(attrName), val, 1024, &fullsize);
    if (res > 0) {
        return ARC_sendAutorelease([[NSString alloc] initWithBytes:val length:res encoding:NSUTF8StringEncoding]);
    }
    return @"";
}

-(int) _getIntAttr:(NSString*)attrName
{
    return yapiGetHubIntAttr(_hubref, STR_oc2y(attrName));
}

-(void) _setIntAttr:(NSString*)attrName :(int)value
{
    yapiSetHubIntAttr(_hubref, STR_oc2y(attrName), value);
}

/**
 * Returns the URL that has been used first to register this hub.
 */
-(NSString*) get_registeredUrl
{
    return [self _getStrAttr:@"registeredUrl"];
}

/**
 * Returns all known URLs that have been used to register this hub.
 * URLs are pointing to the same hub when the devices connected
 * are sharing the same serial number.
 */
-(NSMutableArray*) get_knownUrls
{
    char smallbuff[1024];
    char *bigbuff;
    int buffsize;
    int fullsize;
    int yapi_res;
    NSString* urls_packed;
    NSString* known_url_val;
    NSMutableArray* url_list = [NSMutableArray array];

    fullsize = 0;
    known_url_val = @"knownUrls";
    yapi_res = yapiGetHubStrAttr(_hubref, STR_oc2y(known_url_val), smallbuff, 1024, &fullsize);
    if (yapi_res < 0) {
        return url_list;
    }
    if (fullsize <= 1024) {
        urls_packed = ARC_sendAutorelease([[NSString alloc] initWithBytes:smallbuff length:yapi_res encoding:NSUTF8StringEncoding]);
    } else {
        buffsize = fullsize;
        bigbuff = (char *)malloc(buffsize);
        yapi_res = yapiGetHubStrAttr(_hubref, STR_oc2y(known_url_val), bigbuff, buffsize, &fullsize);
        if (yapi_res < 0) {
            free(bigbuff);
            return url_list;
        } else {
            urls_packed = ARC_sendAutorelease([[NSString alloc] initWithBytes:bigbuff length:yapi_res encoding:NSUTF8StringEncoding]);
        }
        free(bigbuff);
    }
    if (!([urls_packed isEqualToString:@""])) {
        url_list = [NSMutableArray arrayWithArray:[urls_packed componentsSeparatedByString:@"?"]];
    }
    return url_list;
}

/**
 * Returns the URL currently in use to communicate with this hub.
 */
-(NSString*) get_connectionUrl
{
    return [self _getStrAttr:@"connectionUrl"];
}

/**
 * Returns the hub serial number, if the hub was already connected once.
 */
-(NSString*) get_serialNumber
{
    return [self _getStrAttr:@"serialNumber"];
}

/**
 * Tells if this hub is still registered within the API.
 *
 * @return true if the hub has not been unregistered.
 */
-(bool) isInUse
{
    return [self _getIntAttr:@"isInUse"] > 0;
}

/**
 * Tells if there is an active communication channel with this hub.
 *
 * @return true if the hub is currently connected.
 */
-(bool) isOnline
{
    return [self _getIntAttr:@"isOnline"] > 0;
}

/**
 * Tells if write access on this hub is blocked. Return true if it
 * is not possible to change attributes on this hub
 *
 * @return true if it is not possible to change attributes on this hub.
 */
-(bool) isReadOnly
{
    return [self _getIntAttr:@"isReadOnly"] > 0;
}

/**
 * Modifies tthe network connection delay for this hub.
 * The default value is inherited from ySetNetworkTimeout
 * at the time when the hub is registered, but it can be updated
 * afterwards for each specific hub if necessary.
 *
 * @param networkMsTimeout : the network connection delay in milliseconds.
 * @noreturn
 */
-(void) set_networkTimeout:(int)networkMsTimeout
{
    [self _setIntAttr:@"networkTimeout" :networkMsTimeout];
}

/**
 * Returns the network connection delay for this hub.
 * The default value is inherited from ySetNetworkTimeout
 * at the time when the hub is registered, but it can be updated
 * afterwards for each specific hub if necessary.
 *
 * @return the network connection delay in milliseconds.
 */
-(int) get_networkTimeout
{
    return [self _getIntAttr:@"networkTimeout"];
}

/**
 * Returns the numerical error code of the latest error with the hub.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 *
 * @return a number corresponding to the code of the latest error that occurred while
 *         using the hub object
 */
-(int) get_errorType
{
    return [self _getIntAttr:@"errorType"];
}

/**
 * Returns the error message of the latest error with the hub.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 *
 * @return a string corresponding to the latest error message that occured while
 *         using the hub object
 */
-(NSString*) get_errorMessage
{
    return [self _getStrAttr:@"errorMessage"];
}

/**
 * Returns the value of the userData attribute, as previously stored
 * using method set_userData.
 * This attribute is never touched directly by the API, and is at
 * disposal of the caller to store a context.
 *
 * @return the object stored previously by the caller.
 */
-(id) get_userData
{
    return _userData;
}

/**
 * Stores a user context provided as argument in the userData
 * attribute of the function.
 * This attribute is never touched by the API, and is at
 * disposal of the caller to store a context.
 *
 * @param data : any kind of object to be stored
 * @noreturn
 */
-(void) set_userData:(id _Nullable)data
{
    _userData = data;
}

/**
 * Starts the enumeration of hubs currently in use by the API.
 * Use the method YHub.nextHubInUse() to iterate on the
 * next hubs.
 *
 * @return a pointer to a YHub object, corresponding to
 *         the first hub currently in use by the API, or a
 *         nil pointer if none has been registered.
 */
+(YHub*) FirstHubInUse
{
    return [YAPI nextHubInUseInternal:-1];
}

/**
 * Continues the module enumeration started using YHub.FirstHubInUse().
 * Caution: You can't make any assumption about the order of returned hubs.
 *
 * @return a pointer to a YHub object, corresponding to
 *         the next hub currenlty in use, or a nil pointer
 *         if there are no more hubs to enumerate.
 */
-(YHub*) nextHubInUse
{
    return [_ctx nextHubInUseInternal:_hubref];
}

//--- (end of generated code: YHub public methods implementation)

@end
//--- (generated code: YHub functions)
//--- (end of generated code: YHub functions)



@implementation YAPIContext

// Constructor is protected, use yFindAPIContext factory function to instantiate
-(id)              init
{
   if(!(self = [super init]))
          return nil;
//--- (generated code: YAPIContext attributes initialization)
    _defaultCacheValidity = 5;
//--- (end of generated code: YAPIContext attributes initialization)
    _hub_cache = [[NSMutableDictionary alloc] init];
    return self;
}
// destructor
-(void)  dealloc
{
    ARC_release(_hub_cache);
    _hub_cache = nil;
//--- (generated code: YAPIContext cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YAPIContext cleanup)
}
//--- (generated code: YAPIContext private methods implementation)

//--- (end of generated code: YAPIContext private methods implementation)
//--- (generated code: YAPIContext public methods implementation)
/**
 * Modifies the delay between each forced enumeration of the used YoctoHubs.
 * By default, the library performs a full enumeration every 10 seconds.
 * To reduce network traffic, you can increase this delay.
 * It's particularly useful when a YoctoHub is connected to the GSM network
 * where traffic is billed. This parameter doesn't impact modules connected by USB,
 * nor the working of module arrival/removal callbacks.
 * Note: you must call this function after yInitAPI.
 *
 * @param deviceListValidity : nubmer of seconds between each enumeration.
 * @noreturn
 */
-(void) SetDeviceListValidity:(int)deviceListValidity
{
    yapiSetNetDevListValidity(deviceListValidity);
}

/**
 * Returns the delay between each forced enumeration of the used YoctoHubs.
 * Note: you must call this function after yInitAPI.
 *
 * @return the number of seconds between each enumeration.
 */
-(int) GetDeviceListValidity
{
    int res;
    res = yapiGetNetDevListValidity();
    return res;
}

/**
 * Adds a UDEV rule which authorizes all users to access Yoctopuce modules
 * connected to the USB ports. This function works only under Linux. The process that
 * calls this method must have root privileges because this method changes the Linux configuration.
 *
 * @param force : if true, overwrites any existing rule.
 *
 * @return an empty string if the rule has been added.
 *
 * On failure, returns a string that starts with "error:".
 */
-(NSString*) AddUdevRule:(bool)force
{
    NSString* msg;
    int res;
    int c_force;
    char errmsg[YOCTO_ERRMSG_LEN];
    if (force) {
        c_force = 1;
    } else {
        c_force = 0;
    }
    res = yapiAddUdevRulesForYocto(c_force, errmsg);
    if (res < 0) {
        msg = [NSString stringWithFormat:@"%@%@", @"error: ", STR_y2oc(errmsg)];
    } else {
        msg = @"";
    }
    return msg;
}

/**
 * Modifies the network connection delay for yRegisterHub() and yUpdateDeviceList().
 * This delay impacts only the YoctoHubs and VirtualHub
 * which are accessible through the network. By default, this delay is of 20000 milliseconds,
 * but depending or you network you may want to change this delay,
 * gor example if your network infrastructure is based on a GSM connection.
 *
 * @param networkMsTimeout : the network connection delay in milliseconds.
 * @noreturn
 */
-(void) SetNetworkTimeout:(int)networkMsTimeout
{
    yapiSetNetworkTimeout(networkMsTimeout);
}

/**
 * Returns the network connection delay for yRegisterHub() and yUpdateDeviceList().
 * This delay impacts only the YoctoHubs and VirtualHub
 * which are accessible through the network. By default, this delay is of 20000 milliseconds,
 * but depending or you network you may want to change this delay,
 * for example if your network infrastructure is based on a GSM connection.
 *
 * @return the network connection delay in milliseconds.
 */
-(int) GetNetworkTimeout
{
    int res;
    res = yapiGetNetworkTimeout();
    return res;
}

/**
 * Change the validity period of the data loaded by the library.
 * By default, when accessing a module, all the attributes of the
 * module functions are automatically kept in cache for the standard
 * duration (5 ms). This method can be used to change this standard duration,
 * for example in order to reduce network or USB traffic. This parameter
 * does not affect value change callbacks
 * Note: This function must be called after yInitAPI.
 *
 * @param cacheValidityMs : an integer corresponding to the validity attributed to the
 *         loaded function parameters, in milliseconds.
 * @noreturn
 */
-(void) SetCacheValidity:(u64)cacheValidityMs
{
    _defaultCacheValidity = cacheValidityMs;
}

/**
 * Returns the validity period of the data loaded by the library.
 * This method returns the cache validity of all attributes
 * module functions.
 * Note: This function must be called after yInitAPI .
 *
 * @return an integer corresponding to the validity attributed to the
 *         loaded function parameters, in milliseconds
 */
-(u64) GetCacheValidity
{
    return _defaultCacheValidity;
}

-(YHub*) nextHubInUseInternal:(int)hubref
{
    int nextref;
    nextref = yapiGetNextHubRef(hubref);
    if (nextref < 0) {
        return nil;
    }
    return [self getYHubObj:nextref];
}

-(YHub*) getYHubObj:(int)hubref
{
    YHub* obj;
    obj = [self _findYHubFromCache:hubref];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YHub alloc] initWith:self :hubref]);
        [self _addYHubToCache:hubref :obj];
    }
    return obj;
}

//--- (end of generated code: YAPIContext public methods implementation)

-(YHub*) _findYHubFromCache:(int)hubref
{
    NSNumber* ref= [NSNumber numberWithInt:hubref];
    if ([_hub_cache doesContain: ref]) {
        return _hub_cache [ref];
    }
    return nil;
}

-(void) _addYHubToCache:(int) hubref :(YHub*) obj
{
    NSNumber* ref= [NSNumber numberWithInt:hubref];
    [_hub_cache setObject:obj forKey:ref];
}


@end
//--- (generated code: YAPIContext functions)
//--- (end of generated code: YAPIContext functions)


static YAPI_CalibrationObj *YAPI_linearCalibration = nil;
static YAPI_CalibrationObj *YAPI_invalidCalibration = nil;
YAPIContext *YAPI_yapiContext = nil;

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


+(double) _decimalToDouble:(s16) val
{
    int     negate = 0;
    double  res;
    int mantis = val & 2047;
    if(mantis == 0) return 0.0;
    if(val < 0) {
        negate = 1;
        val = -val;
    }
    res = (double)(mantis) * decExp[val >> 11];

    return (negate ? -res : res);
}

// Convert standard double-precision floats to Yoctopuce 16-bit decimal floats
//
+(s16) _doubleToDecimal:(double) val
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


+(NSMutableArray*) _decodeWords:(NSString*)sdat
{
    NSMutableArray*     udat= [[NSMutableArray alloc] init];
    const char *ptr = STR_oc2y(sdat);

    for(unsigned p = 0; p < strlen(ptr);) {
        unsigned val;
        unsigned c = ptr[p++];
        if(c == '*') {
            val = 0;
        } else if(c == 'X') {
            val = 0xffff;
        } else if(c == 'Y') {
            val = 0x7fff;
        } else if(c >= 'a') {
            int srcpos = (int)[udat count]-1-(c-'a');
            if(srcpos < 0)
                val = 0;
            else
                val = [[udat objectAtIndex:srcpos] intValue];
        } else {
            if(p+2 > [sdat length]) return udat;
            val = (c - '0');
            c = ptr[p++];
            val += (c - '0') << 5;
            c = ptr[p++];
            if(c == 'z') c = '\\';
            val += (c - '0') << 10;
        }
        [udat addObject:[NSNumber numberWithInt:val]];
    }
    return udat;

}

+(NSMutableArray*) _decodeFloats:(NSString*)sdat
{
    NSMutableArray* idat= [[NSMutableArray alloc] init];
    const char *ptr = STR_oc2y(sdat);

    for(unsigned p = 0; p < strlen(ptr);) {
        int val = 0;
        int sign = 1;
        int dec = 0;
        int decInc = 0;
        unsigned c = ptr[p++];
        if(c != '-' && (c < '0' || c > '9')) {
            if(p >= strlen(ptr)) {
                return idat;
            }
            c = ptr[p++];
        }
        if(c == '-') {
            if(p >= strlen(ptr)) {
                return idat;
            }
            sign = -sign;
            c = ptr[p++];
        }
        while((c >= '0' && c <= '9') || c == '.') {
            if(c == '.') {
                decInc = 1;
            } else if(dec < 3) {
                val = val * 10 + (c - '0');
                dec += decInc;
            }
            if(p < strlen(ptr)) {
                c = ptr[p++];
            } else {
                c = 0;
            }
        }
        if(dec < 3) {
            if(dec == 0) val *= 1000;
            else if(dec == 1) val *= 100;
            else val *= 10;
        }
        [idat addObject:[NSNumber numberWithInt:sign*val]];
    }
    return idat;
}


static const char* hexArray = "0123456789ABCDEF";

+(NSString*) _bin2HexStr:(NSData*)data
{
    NSUInteger len = [data length];
    if (len) {
        const u8 *ptr = [data bytes];
        char *buffer = malloc(len * 2 + 1);
        memset(buffer, 0, len * 2 + 1);
        for (unsigned long j = 0; j < len; j++, ptr++) {
            u8 v = *ptr;
            buffer[j * 2] = hexArray[v >> 4];
            buffer[j * 2 + 1] = hexArray[v & 0x0F];
        }
        NSString *res = STR_y2oc(buffer);
        free(buffer);
        return res;
    }
    return @"";
}
+(NSMutableData*) _hexStr2Bin:(NSString*)hex_str
{
    unsigned long len = [hex_str length] / 2;
    const char *p  = STR_oc2y(hex_str);
    NSMutableData *res = [NSMutableData dataWithLength:len];
    for (unsigned long i = 0; i < len; i++) {
        u8 b = 0;
        int j;
        for(j = 0; j < 2; j++) {
            b <<= 4;
            if(*p >= 'a' && *p <='f'){
                b +=  10 + *p - 'a';
            }else if(*p >= 'A' && *p <='F'){
                b +=  10 + *p - 'A';
            }else if(*p >='0' && *p <='9'){
                b += *p - '0';
            }
            p++;
        }
        (((u8*)([res mutableBytes]))[i]) = b;
    }
    return res;
}

+(NSMutableData*) _binMerge:(NSData*)dataA :(NSData*)dataB
{
    NSMutableData *data = [NSMutableData dataWithCapacity:[dataA length] + [dataB length]];
    [data appendData:dataA];
    [data appendData:dataB];
    return data;
}

// Default cache validity (in [ms]) before reloading data from device. This saves a lots of trafic.
// Note that a value under 2 ms makes little sense since a USB bus itself has a 2ms roundtrip period
+(u64)         DefaultCacheValidity
{
    return [YAPI_yapiContext GetCacheValidity];
}

/**
 *
 */
+(void)         SetDefaultCacheValidity:(u64)defaultCacheValidity
{
    [YAPI_yapiContext SetCacheValidity:defaultCacheValidity];
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
    return Y_INVALID_STRING;
}

//--- (generated code: YAPIContext yapiwrapper)
/**
 * Modifies the delay between each forced enumeration of the used YoctoHubs.
 * By default, the library performs a full enumeration every 10 seconds.
 * To reduce network traffic, you can increase this delay.
 * It's particularly useful when a YoctoHub is connected to the GSM network
 * where traffic is billed. This parameter doesn't impact modules connected by USB,
 * nor the working of module arrival/removal callbacks.
 * Note: you must call this function after yInitAPI.
 *
 * @param deviceListValidity : nubmer of seconds between each enumeration.
 * @noreturn
 */
+(void) SetDeviceListValidity:(int)deviceListValidity
{
        [YAPI_yapiContext SetDeviceListValidity:deviceListValidity];
}
/**
 * Returns the delay between each forced enumeration of the used YoctoHubs.
 * Note: you must call this function after yInitAPI.
 *
 * @return the number of seconds between each enumeration.
 */
+(int) GetDeviceListValidity
{
        return [YAPI_yapiContext GetDeviceListValidity];
}
/**
 * Adds a UDEV rule which authorizes all users to access Yoctopuce modules
 * connected to the USB ports. This function works only under Linux. The process that
 * calls this method must have root privileges because this method changes the Linux configuration.
 *
 * @param force : if true, overwrites any existing rule.
 *
 * @return an empty string if the rule has been added.
 *
 * On failure, returns a string that starts with "error:".
 */
+(NSString*) AddUdevRule:(bool)force
{
        return [YAPI_yapiContext AddUdevRule:force];
}
/**
 * Modifies the network connection delay for yRegisterHub() and yUpdateDeviceList().
 * This delay impacts only the YoctoHubs and VirtualHub
 * which are accessible through the network. By default, this delay is of 20000 milliseconds,
 * but depending or you network you may want to change this delay,
 * gor example if your network infrastructure is based on a GSM connection.
 *
 * @param networkMsTimeout : the network connection delay in milliseconds.
 * @noreturn
 */
+(void) SetNetworkTimeout:(int)networkMsTimeout
{
        [YAPI_yapiContext SetNetworkTimeout:networkMsTimeout];
}
/**
 * Returns the network connection delay for yRegisterHub() and yUpdateDeviceList().
 * This delay impacts only the YoctoHubs and VirtualHub
 * which are accessible through the network. By default, this delay is of 20000 milliseconds,
 * but depending or you network you may want to change this delay,
 * for example if your network infrastructure is based on a GSM connection.
 *
 * @return the network connection delay in milliseconds.
 */
+(int) GetNetworkTimeout
{
        return [YAPI_yapiContext GetNetworkTimeout];
}
/**
 * Change the validity period of the data loaded by the library.
 * By default, when accessing a module, all the attributes of the
 * module functions are automatically kept in cache for the standard
 * duration (5 ms). This method can be used to change this standard duration,
 * for example in order to reduce network or USB traffic. This parameter
 * does not affect value change callbacks
 * Note: This function must be called after yInitAPI.
 *
 * @param cacheValidityMs : an integer corresponding to the validity attributed to the
 *         loaded function parameters, in milliseconds.
 * @noreturn
 */
+(void) SetCacheValidity:(u64)cacheValidityMs
{
        [YAPI_yapiContext SetCacheValidity:cacheValidityMs];
}
/**
 * Returns the validity period of the data loaded by the library.
 * This method returns the cache validity of all attributes
 * module functions.
 * Note: This function must be called after yInitAPI .
 *
 * @return an integer corresponding to the validity attributed to the
 *         loaded function parameters, in milliseconds
 */
+(u64) GetCacheValidity
{
        return [YAPI_yapiContext GetCacheValidity];
}
+(YHub*) nextHubInUseInternal:(int)hubref
{
        return [YAPI_yapiContext nextHubInUseInternal:hubref];
}
+(YHub*) getYHubObj:(int)hubref
{
        return [YAPI_yapiContext getYHubObj:hubref];
}
//--- (end of generated code: YAPIContext yapiwrapper)




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
 * When YAPI.DETECT_NONE is used as detection mode,
 * you must explicitly use yRegisterHub() to point the API to the
 * VirtualHub on which your devices are connected before trying to access them.
 *
 * @param mode : an integer corresponding to the type of automatic
 *         device detection to use. Possible values are
 *         YAPI.DETECT_NONE, YAPI.DETECT_USB, YAPI.DETECT_NET,
 *         and YAPI.DETECT_ALL.
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
+(YRETCODE)    InitAPI:(int)mode :(NSError**)errmsg
{
    char errbuf[YOCTO_ERRMSG_LEN];
    NSNumber *type;

    if(YAPI_apiInitialized) return YAPI_SUCCESS;
    YRETCODE res = yapiInitAPI(mode, errbuf);
    if(YISERR(res)) {
        return yFormatRetVal(errmsg, res,errbuf);
    }

    yapiRegisterLogFunction(yapiLogFunctionFwd);
    yapiRegisterDeviceLogCallback(yapiDeviceLogCallbackFwd);
    YAPI_plug_events = [[NSMutableArray alloc ] initWithCapacity:16];
    yapiRegisterDeviceArrivalCallback(yapiDeviceArrivalCallbackFwd);
    yapiRegisterDeviceRemovalCallback(yapiDeviceRemovalCallbackFwd);
    yapiRegisterDeviceChangeCallback(yapiDeviceChangeCallbackFwd);
    YAPI_data_events = [[NSMutableArray alloc ] initWithCapacity:16];
    yapiRegisterFunctionUpdateCallback(yapiFunctionUpdateCallbackFwd);
    yapiRegisterTimedReportCallback(yapiTimedReportCallbackFwd);
    yapiRegisterDeviceConfigChangeCallback(yapiDeviceConfigChangeCallbackFwd);
    yapiRegisterBeaconCallback(yapiBeaconCallbackFwd);
    yapiRegisterHubDiscoveryCallback(yapiHubDiscoveryCallbackFwd);
    yInitializeCriticalSection(&YAPI_updateDeviceList_CS);
    yInitializeCriticalSection(&YAPI_handleEvent_CS);
    YAPI_linearCalibration  = [[YAPI_CalibrationObj alloc] init];
    YAPI_invalidCalibration = [[YAPI_CalibrationObj alloc] init];
    YAPI_yapiContext = [[YAPIContext alloc] init];
    YAPI_calibHandlers = [[NSMutableDictionary alloc] initWithCapacity:20];
    for(int i =1 ;i <=20;i++){
        type = [NSNumber numberWithInt:i];
        [YAPI_calibHandlers setObject:YAPI_linearCalibration forKey:type];
    }
    type = [NSNumber numberWithInt:YOCTO_CALIB_TYPE_OFS];
    [YAPI_calibHandlers setObject:YAPI_linearCalibration forKey:type];
    YAPI_YFunctions = [[NSMutableDictionary alloc] init];
    YAPI_apiInitialized = YES;

    return YAPI_SUCCESS;
}

/**
 * Waits for all pending communications with Yoctopuce devices to be
 * completed then frees dynamically allocated resources used by
 * the Yoctopuce library.
 *
 * From an operating system standpoint, it is generally not required to call
 * this function since the OS will automatically free allocated resources
 * once your program is completed. However there are two situations when
 * you may really want to use that function:
 *
 * - Free all dynamically allocated memory blocks in order to
 * track a memory leak.
 *
 * - Send commands to devices right before the end
 * of the program. Since commands are sent in an asynchronous way
 * the program could exit before all commands are effectively sent.
 *
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
        ARC_release(_ValueCallbackList)
        _ValueCallbackList=nil;
        ARC_release(_TimedReportCallbackList)
        _TimedReportCallbackList=nil;
        ARC_release(_devCache);
        _devCache = nil;
        YAPI_apiInitialized = NO;
    }
}

/**
 * Re-enables the use of exceptions for runtime error handling.
 * Be aware than when exceptions are enabled, every function that fails
 * triggers an exception. If the exception is not caught by the user code,
 * it either fires the debugger or aborts (i.e. crash) the program.
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
 * the API have something to say. Quite useful to debug the API.
 *
 * @param logfun : a procedure taking a string parameter, or nil
 *         to unregister a previously registered  callback.
 */
+(void)    RegisterLogFunction:(yLogCallback) logfun
{
    YAPI_logFunction = logfun;
}


/**
 * Register a callback function, to be called each time
 * a device is plugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param arrivalCallback : a procedure taking a YModule parameter, or nil
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
 * a device is unplugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param removalCallback : a procedure taking a YModule parameter, or nil
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
 * Register a callback function, to be called each time an Network Hub send
 * an SSDP message. The callback has two string parameter, the first one
 * contain the serial number of the hub and the second contain the URL of the
 * network hub (this URL can be passed to RegisterHub). This callback will be invoked
 * while yUpdateDeviceList is running. You will have to call this function on a regular basis.
 *
 * @param hubDiscoveryCallback : a procedure taking two string parameter, the serial
 *         number and the hub URL. Use nil to unregister a previously registered  callback.
 */
+(void)        RegisterHubDiscoveryCallback:(YHubDiscoveryCallback) hubDiscoveryCallback
{
    YAPI_HubDiscoveryCallback = hubDiscoveryCallback;
    [YAPI TriggerHubDiscovery:NULL];
}




/**
 * (Objective-C only) Register an object that must follow the protocol YDeviceHotPlug. The methods
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param object : an object that must follow the protocol YAPIDelegate, or nil
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
 * Setup the Yoctopuce library to use modules connected on a given machine. Idealy this
 * call will be made once at the begining of your application.  The
 * parameter will determine how the API will work. Use the following values:
 *
 * <b>usb</b>: When the usb keyword is used, the API will work with
 * devices connected directly to the USB bus. Some programming languages such a JavaScript,
 * PHP, and Java don't provide direct access to USB hardware, so usb will
 * not work with these. In this case, use a VirtualHub or a networked YoctoHub (see below).
 *
 * <b><i>x.x.x.x</i></b> or <b><i>hostname</i></b>: The API will use the devices connected to the
 * host with the given IP address or hostname. That host can be a regular computer
 * running a <i>native VirtualHub</i>, a <i>VirtualHub for web</i> hosted on a server,
 * or a networked YoctoHub such as YoctoHub-Ethernet or
 * YoctoHub-Wireless. If you want to use the VirtualHub running on you local
 * computer, use the IP address 127.0.0.1. If the given IP is unresponsive, yRegisterHub
 * will not return until a time-out defined by ySetNetworkTimeout has elapsed.
 * However, it is possible to preventively test a connection  with yTestHub.
 * If you cannot afford a network time-out, you can use the non blocking yPregisterHub
 * function that will establish the connection as soon as it is available.
 *
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
 * You can call <i>RegisterHub</i> several times to connect to several machines. On
 * the other hand, it is useless and even counterproductive to call <i>RegisterHub</i>
 * with to same address multiple times during the life of the application.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
 * Fault-tolerant alternative to yRegisterHub(). This function has the same
 * purpose and same arguments as yRegisterHub(), but does not trigger
 * an error when the selected hub is not available at the time of the function call.
 * If the connexion cannot be established immediately, a background task will automatically
 * perform periodic retries. This makes it possible to register a network hub independently of the current
 * connectivity, and to try to contact it only when a device is actively needed.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
+(YRETCODE)   PreregisterHub:(NSString*)url :(NSError**)errmsg
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;

    if (!YAPI_apiInitialized) {
        res = [YAPI InitAPI:0:errmsg];
        if(YISERR(res)) return res;
    }
    res = yapiPreregisterHub(STR_oc2y(url), errbuf);
    return yFormatRetVal(errmsg, res, errbuf);
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
 * Test if the hub is reachable. This method do not register the hub, it only test if the
 * hub is usable. The url parameter follow the same convention as the yRegisterHub
 * method. This method is useful to verify the authentication parameters for a hub. It
 * is possible to force this method to return after mstimeout milliseconds.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param mstimeout : the number of millisecond available to test the connection.
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
+(YRETCODE)   TestHub:(NSString*) url :(int)mstimeout :(NSError**) errmsg
{
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;

    res = yapiTestHub(STR_oc2y(url), mstimeout, errbuf);
    return yFormatRetVal(errmsg, res, errbuf);
}

/**
 * Triggers a (re)detection of connected Yoctopuce modules.
 * The library searches the machines or USB ports previously registered using
 * yRegisterHub(), and invokes any user-defined callback function
 * in case a change in the list of connected devices is detected.
 *
 * This function can be called as frequently as desired to refresh the device list
 * and to make the application aware of hot-plug events. However, since device
 * detection is quite a heavy process, UpdateDeviceList shouldn't be called more
 * than once every two seconds.
 *
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
        ev = [YAPI_plug_events objectAtIndex:0];
        ARC_retain(ev);
        [YAPI_plug_events removeObjectAtIndex:0];
        yapiUnlockDeviceCallBack(NULL);
        [ev invokePlugEvent];
        ARC_release(ev);
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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
        [ev invokeFunctionEvent];
        ARC_release(ev);

    }
    yLeaveCriticalSection(&YAPI_handleEvent_CS);
    return YAPI_SUCCESS;
}


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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
            res = yapiSleep(2, errbuf);
            if(YISERR(res)) {
                return yFormatRetVal(errmsg, res, errbuf);
            }
        }
    }while(waituntil > [YAPI GetTickCount]);

    return YAPI_SUCCESS;
}

/**
 * Force a hub discovery, if a callback as been registered with yRegisterHubDiscoveryCallback it
 * will be called for each net work hub that will respond to the discovery.
 *
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *         On failure returns a negative error code.
 */
 +(YRETCODE)    TriggerHubDiscovery:(NSError**) errmsg
 {
    char        errbuf[YOCTO_ERRMSG_LEN];
    YRETCODE    res;

    if (!YAPI_apiInitialized) {
        res = [YAPI InitAPI:0:errmsg];
        if(YISERR(res)) return res;
    }
    @autoreleasepool {
        res = yapiTriggerHubDiscovery(errbuf);
    }
    return yFormatRetVal(errmsg, res, errbuf);
 }


/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the millisecond as timebase.
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
    return [YapiWrapper getFunctionInfoEx:fundesc :devdescr :serial :funcId :nil :funcName :funcVal :error];
}

+(YRETCODE)    getFunctionInfoEx:(YFUN_DESCR)fundesc :(YDEV_DESCR*)devdescr :(NSString**)serial :(NSString**)funcId :(NSString**)baseType :(NSString**)funcName :(NSString**)funcVal :(NSError**)error
{
    char    errbuf[YOCTO_ERRMSG_LEN];
    char    snum[YOCTO_SERIAL_LEN];
    char    fnid[YOCTO_FUNCTION_LEN];
    char    fnbt[YOCTO_FUNCTION_LEN];
    char    fnam[YOCTO_LOGICAL_LEN];
    char    fval[YOCTO_PUBVAL_LEN];
    YAPI_DEVICE devdescr_c;

    YRETCODE res = yapiGetFunctionInfoEx(fundesc, &devdescr_c, snum, fnid, fnbt, fnam, fval, errbuf);
    if(YISERR(res)) {
        return yFormatRetVal(error, res, errbuf);
    } else {
        if(serial)
            *serial   = STR_y2oc(snum);
        if(funcId)
            *funcId   = STR_y2oc(fnid);
        if(baseType)
            *baseType = STR_y2oc(fnbt);
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

+(void)  PlugDevice:(YDEV_DESCR)devdescr
{
    // Search in cache
    if (_devCache == nil){
        return;
    }

    for(unsigned int idx = 0; idx < [_devCache count]; idx++) {
        YDevice* tmp = [_devCache objectAtIndex:idx];
        if(tmp->_devdescr == devdescr) {
            tmp->_cacheStamp = 0;
            if (tmp->_subpath){
                free(tmp->_subpath);
                tmp->_subpath =NULL;
            }
            return;
        }
    }
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



-(YRETCODE)    HTTPRequest:(NSString*)req_first_line withBody:(NSData*)req_head_and_body :(NSMutableData**)buffer :(NSError**)error
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
    if (replysize >0  && reply != NULL)  {
        *buffer = [NSMutableData dataWithBytes:reply length:replysize];
    } else {
        *buffer = [NSMutableData data];
    }
    if(YISERR(res=yapiHTTPRequestSyncDone(&iohdl, errbuff))) {
        return yFormatRetVal(error, res, errbuff);
    }

    return YAPI_SUCCESS;
}


-(YRETCODE)     HTTPRequest:(NSString*)request :(NSMutableData**)buffer :(NSError**)error;
{
    return [self HTTPRequest:request withBody:nil :buffer :error];
}


-(YRETCODE)   requestAPI:(NSString**)apires :(NSError**)error
{
    yJsonStateMachine j;
    NSMutableData       *raw_buffer=nil;
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
    buffer = [[NSString alloc] initWithData:raw_buffer encoding:NSISOLatin1StringEncoding];
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


-(void)   clearCache
{
    _cacheStamp = 0;
    ARC_release(_cacheJson);
    _cacheJson =nil;
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



@implementation YFunction

// Constructor is protected. Use the device-specific factory function to instantiate
-(id) initWith:(NSString*)func
{

    if(!(self = [super init]))
          return nil;
//--- (generated code: YFunction attributes initialization)
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _valueCallbackFunction = NULL;
    _cacheExpiration = 0;
//--- (end of generated code: YFunction attributes initialization)
    _className          = @"Function";
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
    _dataStreams = [[NSMutableDictionary alloc] init];
    return self;
}


-(void)  dealloc
{
//--- (generated code: YFunction cleanup)
    ARC_release(_logicalName);
    _logicalName = nil;
    ARC_release(_advertisedValue);
    _advertisedValue = nil;
    ARC_dealloc(super);
//--- (end of generated code: YFunction cleanup)
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
    //if (_lastError != nil){
    //    ARC_release(_lastError)
    //}
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

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if (![self _parseAttr:j]) {
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) {
        return -1;
    }

    [self _parserHelper];

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


-(NSString*)   _escapeAttr:(NSString*)changeval;
{
    NSMutableString * escaped = [NSMutableString stringWithString:@""];
    int pos;
    for(pos=0;pos < [changeval length] ;pos++){
        unsigned char       c;
        unsigned char       esc[2];
        c = [changeval characterAtIndex:pos] & 0xff;
        if(c <= ' ' || (c > 'z' && c != '~') || c == '"' || c == '%' || c == '&' ||
           c == '+' || c == '<' || c == '=' || c == '>' || c == '\\' || c == '^' || c == '`') {
            esc[0]=(c >= 0xa0 ? (c>>4)-10+'A' : (c>>4)+'0');
            c &= 0xf;
            esc[1]=(c >= 0xa ? c-10+'A' : c+'0');
            [escaped appendFormat:@"%%%c%c",esc[0],esc[1]];
        } else {
            [escaped appendFormat:@"%c",c];
        }
    }
    return escaped;

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
            [buffer appendString:@"?"];
            [buffer appendString:changeattr];
            [buffer appendString:@"="];
            [buffer appendString:[self _escapeAttr:changeval]];
        }
    }
    [buffer appendString:@"&. \r\n\r\n"];
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
    if (_cacheExpiration != 0) {
        _cacheExpiration = yapiGetTickCount();
    }
    return YAPI_SUCCESS;
}



-(NSMutableData*) _request:(NSString *)request withBody:(NSData*)body
{
    NSError       *error;
    YRETCODE      res;
    YDevice       *dev;
    NSMutableData *buffer;

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
    NSData* str_data=[str dataUsingEncoding:NSISOLatin1StringEncoding];
    NSRange pos = [buffer rangeOfData:str_data options:0 range:all];
    if(0 != pos.location){
        str= @"HTTP/1.1 200 OK\r\n";
        str_data=[str dataUsingEncoding:NSISOLatin1StringEncoding];
        pos = [buffer rangeOfData:str_data options:0 range:all];
        if(0 != pos.location){
            [self _throw:YAPI_IO_ERROR:@"http request failed"];
            return nil;
        }
    }
    return buffer;
}


-(NSMutableData*) _download:(NSString *)url
{
    NSMutableData      *buffer;

    NSString *request = [NSString stringWithFormat:@"GET /%@ \r\n",url];
    buffer = [self _request:request withBody:nil];
    NSString *endofheader= @"\r\n\r\n";
    NSData   *endofheader_data=[endofheader dataUsingEncoding:NSISOLatin1StringEncoding];
    NSRange  all = {0,[buffer length]};
    NSRange  pos = [buffer rangeOfData:endofheader_data options:0 range:all];
    if(NSNotFound == pos.location){
        [self _throw:YAPI_IO_ERROR:@"http request failed"];
        return [NSMutableData data];
    }
    pos.location += [endofheader_data length];
    pos.length = all.length -pos.location;
    NSRange range = NSMakeRange(0, pos.location);
    [buffer replaceBytesInRange:range withBytes:NULL length:0];
    return buffer;
}

-(YRETCODE) _upload:(NSString *)path :(NSData *)content
{
    if ([self _uploadEx:path :content]==nil){
        [self _throw:YAPI_IO_ERROR:@"http request failed"];
        return YAPI_IO_ERROR;
    }
    return YAPI_SUCCESS;
}

-(NSMutableData*) _uploadEx:(NSString *)path :(NSData *)content
{
    NSString *request = @"POST /upload.html HTTP/1.1\r\n";
    NSString *mp_header =    [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"api\"\r\n"
                              "Content-Type: application/octet-stream\r\n"
                              "Content-Transfer-Encoding: binary\r\n\r\n",path];
    NSString *boundary;
    NSMutableData      *buffer;
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
    buffer = [self _request:request withBody:head_body];
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
    NSRange range = NSMakeRange(0, pos.location);
    [buffer replaceBytesInRange:range withBytes:NULL length:0];
    return buffer;
}



-(NSString*)   _json_get_key:(NSData*)json :(NSString*)key
{
    yJsonStateMachine j;
    const char *key_cstr= STR_oc2y(key);
    NSString *json_str = [[NSString alloc] initWithData:json encoding:NSISOLatin1StringEncoding];
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
    NSString *json_str = [[NSString alloc] initWithData:json encoding:NSISOLatin1StringEncoding];
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
        while (yJsonParse(&j) == YJSON_PARSE_AVAIL) {
            if (j.next == YJSON_PARSE_STRINGCONT || j.depth > depth){
                continue;
            }
            break;
        }
        if (j.depth == depth ) {
            NSRange range;
            while (*last == ',' || *last == '\n' || *last == '\r'){
                last++;
            }
            range.location = last - json_cstr;
            range.length = j.src - last;
            NSString * item=[json_str substringWithRange:range];
            [res addObject:item];
        }
    } while ( j.st != YJSON_PARSE_ARRAY);
    return res;
}


-(NSString*) _json_get_string:(NSData*)json
{
    yJsonStateMachine j;
    const char *json_cstr;
    NSString *json_str = [[NSString alloc] initWithData:json encoding:NSISOLatin1StringEncoding];
    ARC_autorelease(json_str);
    j.src = json_cstr= STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRING) {
        [self _throw:YAPI_IO_ERROR:@"JSON string expected"];
        return @"";
    }
    return [self _parseString:&j];
}
-(NSString*)   _get_json_path:(NSString*)json :(NSString*)path
{
    const char *json_data = STR_oc2y(json);
    int len = (int)strlen(json_data);
    const char *p;
    char        errbuff[YOCTO_ERRMSG_LEN];
    int res;

    res = yapiJsonGetPath(STR_oc2y(path), json_data, len, &p, errbuff);
    if (res > 0) {
        NSString *result = ARC_sendAutorelease([[NSString  alloc] initWithBytes:p length:res encoding:NSISOLatin1StringEncoding]);
        yapiFreeMem((void*)p);
        return result;
    }
    return @"";
}
-(NSString*)   _decode_json_string:(NSString*)json
{
    int len = (int)[json length];
    char buffer[128];
    char *p = buffer;
    int decoded_len;

    if (len== 0) {
        return @"";
    }
    
    if (len >= 127){
        p = (char*) malloc(len + 1);

    }
    decoded_len = yapiJsonDecodeString(STR_oc2y(json), p);
    NSString *result =ARC_sendAutorelease([[NSString  alloc] initWithBytes:p length:decoded_len encoding:NSISOLatin1StringEncoding]);
    if (len >= 127){
        free(p);
    }
    return result;
}


// Method used to cache DataStream objects (new DataLogger)
-(YDataStream*) _findDataStream:(YDataSet*)dataset :(NSString*)def
{
    NSString *key = [[dataset get_functionId] stringByAppendingFormat:@":%@",def];
    YDataStream *stream = [_dataStreams objectForKey:key];
    if(stream != nil)
        return stream;
    YDataStream *newDataStream = [[YDataStream alloc] initWith:self :dataset :[YAPI _decodeWords:def]];
    [_dataStreams  setObject:newDataStream forKey:key];
    return newDataStream;
}

// Method used to clear cache of DataStream object (undocumented)
-(void) _clearDataStreamCache
{
    [_dataStreams removeAllObjects];
}


+(id) _FindFromCache:(NSString*)classname :(NSString*)func
{
    if (YFunctions_cache == nil) {
        YFunctions_cache =[[NSMutableDictionary alloc] init];
    }
    return [YFunctions_cache objectForKey:[NSString stringWithFormat:@"%@_%@",classname,func]];
}
+(void) _AddToCache:(NSString*)classname :(NSString*)func :(id)obj
{
    if (YFunctions_cache == nil) {
        YFunctions_cache =[[NSMutableDictionary alloc] init];
    }
    [YFunctions_cache setObject:obj forKey:[NSString stringWithFormat:@"%@_%@",classname,func]];
}

+(void) _ClearCache
{
    if (YFunctions_cache != nil) {
        [YFunctions_cache removeAllObjects];
        ARC_release(YFunctions_cache);
        YFunctions_cache = nil;
    }
}


+(void) _UpdateValueCallbackList:(YFunction*) function :(BOOL) add
{
    unsigned i;
    if (add) {
        [function isOnline];
        if (_ValueCallbackList == nil){
            _ValueCallbackList = [[NSMutableArray alloc] init];
        }
        for (i=0 ; i< [_ValueCallbackList count];i++) {
            if ([_ValueCallbackList objectAtIndex:i] == function) {
                return;
            }
        }
        [_ValueCallbackList  addObject:function];
    } else {
        for (i=0 ; i< [_ValueCallbackList count];i++) {
            if ([_ValueCallbackList objectAtIndex:i] == function) {
                [_ValueCallbackList removeObjectAtIndex:i];
            }
        }
    }
}


+(void) _UpdateTimedReportCallbackList:(YFunction*) function :(BOOL) add;
{
    unsigned i;
    if (add) {
        [function isOnline];
        if (_TimedReportCallbackList == nil){
            _TimedReportCallbackList = [[NSMutableArray alloc] init];
        }
        for (i=0 ; i< [_TimedReportCallbackList count];i++) {
            if ([_TimedReportCallbackList objectAtIndex:i] == function) {
                return;
            }
        }
        [_TimedReportCallbackList  addObject:function];
    } else {
        for (i=0 ; i< [_TimedReportCallbackList count];i++) {
            if ([_TimedReportCallbackList objectAtIndex:i] == function) {
                [_TimedReportCallbackList removeObjectAtIndex:i];
            }
        }
    }
}

//--- (generated code: YFunction private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "logicalName")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_logicalName);
        _logicalName =  [self _parseString:j];
        ARC_retain(_logicalName);
        return 1;
    }
    if(!strcmp(j->token, "advertisedValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_advertisedValue);
        _advertisedValue =  [self _parseString:j];
        ARC_retain(_advertisedValue);
        return 1;
    }
    return 0;
}
//--- (end of generated code: YFunction private methods implementation)

//--- (generated code: YFunction public methods implementation)
/**
 * Returns the logical name of the function.
 *
 * @return a string corresponding to the logical name of the function
 *
 * On failure, throws an exception or returns YFunction.LOGICALNAME_INVALID.
 */
-(NSString*) get_logicalName
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOGICALNAME_INVALID;
        }
    }
    res = _logicalName;
    return res;
}


-(NSString*) logicalName
{
    return [self get_logicalName];
}

/**
 * Changes the logical name of the function. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a string corresponding to the logical name of the function
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
        if (! [YAPI CheckLogicalName:newval]) {
            [self _throw:YAPI_INVALID_ARGUMENT :[@"Invalid name :" stringByAppendingString:newval]];
            return YAPI_INVALID_ARGUMENT;
        }
    rest_val = newval;
    return [self _setAttr:@"logicalName" :rest_val];
}
/**
 * Returns a short string representing the current state of the function.
 *
 * @return a string corresponding to a short string representing the current state of the function
 *
 * On failure, throws an exception or returns YFunction.ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADVERTISEDVALUE_INVALID;
        }
    }
    res = _advertisedValue;
    return res;
}


-(NSString*) advertisedValue
{
    return [self get_advertisedValue];
}

-(int) set_advertisedValue:(NSString*) newval
{
    return [self setAdvertisedValue:newval];
}
-(int) setAdvertisedValue:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"advertisedValue" :rest_val];
}
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
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the function, for instance
 *         MyDevice..
 *
 * @return a YFunction object allowing you to drive the function.
 */
+(YFunction*) FindFunction:(NSString*)func
{
    YFunction* obj;
    obj = (YFunction*) [YFunction _FindFromCache:@"Function" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YFunction alloc] initWith:func]);
        [YFunction _AddToCache:@"Function" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YFunctionValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackFunction = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackFunction != NULL) {
        _valueCallbackFunction(self, value);
    } else {
    }
    return 0;
}

/**
 * Disables the propagation of every new advertised value to the parent hub.
 * You can use this function to save bandwidth and CPU on computers with limited
 * resources, or to prevent unwanted invocations of the HTTP callback.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) muteValueCallbacks
{
    return [self set_advertisedValue:@"SILENT"];
}

/**
 * Re-enables the propagation of every new advertised value to the parent hub.
 * This function reverts the effect of a previous call to muteValueCallbacks().
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) unmuteValueCallbacks
{
    return [self set_advertisedValue:@""];
}

/**
 * Returns the current value of a single function attribute, as a text string, as quickly as
 * possible but without using the cached value.
 *
 * @param attrName : the name of the requested attribute
 *
 * @return a string with the value of the the attribute
 *
 * On failure, throws an exception or returns an empty string.
 */
-(NSString*) loadAttribute:(NSString*)attrName
{
    NSString* url;
    NSMutableData* attrVal;
    url = [NSString stringWithFormat:@"api/%@/%@", [self get_functionId],attrName];
    attrVal = [self _download:url];
    return ARC_sendAutorelease([[NSString alloc] initWithData:attrVal encoding:NSISOLatin1StringEncoding]);
}

/**
 * Indicates whether changes to the function are prohibited or allowed.
 * Returns true if the function is blocked by an admin password
 * or if the function is not available.
 *
 * @return true if the function is write-protected or not online.
 */
-(bool) isReadOnly
{
    NSString* serial;
    char errmsg[YOCTO_ERRMSG_LEN];
    int res;
    @try {
        serial = [self get_serialNumber];
    }
    @catch (NSException *e) {
        return YES;
    }
    res = yapiIsModuleWritable(STR_oc2y(serial), errmsg);
    if (res > 0) {
        return NO;
    }
    return YES;
}

/**
 * Returns the serial number of the module, as set by the factory.
 *
 * @return a string corresponding to the serial number of the module, as set by the factory.
 *
 * On failure, throws an exception or returns YFunction.SERIALNUMBER_INVALID.
 */
-(NSString*) get_serialNumber
{
    YModule* m;
    m = [self get_module];
    return [m get_serialNumber];
}

-(int) _parserHelper
{
    return 0;
}


-(YFunction*)   nextFunction
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YFunction FindFunction:hwid];
}

+(YFunction *) FirstFunction
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Function":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YFunction FindFunction:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YFunction public methods implementation)


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
 * Returns the unique hardware identifier of the function in the form SERIAL.FUNCTIONID.
 * The unique hardware identifier is composed of the device serial
 * number and of the hardware identifier of the function (for example RELAYLO1-123456.relay1).
 *
 * @return a string that uniquely identifies the function (ex: RELAYLO1-123456.relay1)
 *
 * On failure, throws an exception or returns  YFunction.HARDWAREID_INVALID.
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
 * On failure, throws an exception or returns  YFunction.FUNCTIONID_INVALID.
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
 * Returns the numerical error code of the latest error with the function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 *
 * @return a number corresponding to the code of the latest error that occurred while
 *         using the function object
 */
-(YRETCODE)    get_errorType
{return [self errType];}
-(YRETCODE)    get_errType
{return [self errType];}
-(YRETCODE)    errType
{
    return (YRETCODE) [_lastError code];
}

/**
 * Returns the error message of the latest error with the function.
 * This method is mostly useful when using the Yoctopuce library with
 * exceptions disabled.
 *
 * @return a string corresponding to the latest error message that occured while
 *         using the function object
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
 * device hosting the function.
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

     // Preload the function data, since we have it in device cache
    [self load:YAPI_defaultCacheValidity];

    return YES;
}

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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(YRETCODE)    load:(u64) msValidity
{
    yJsonStateMachine j;
    YDevice     *dev;
    NSError     *error;
    NSString    *apires;
    YFUN_DESCR  fundescr;
    YRETCODE    res;
    char        errbuf[YOCTO_ERRMSG_LEN];
    char        serial[YOCTO_SERIAL_LEN];
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
    res = yapiGetFunctionInfo(fundescr, NULL, serial, funcId, NULL, NULL, errbuf);
    if(YISERR(res)) {
        res = yFormatRetVal(&error,res,errbuf);
        [self _throw:error];
        return res;
    }
    _cacheExpiration = yapiGetTickCount() + msValidity;
    ARC_release(_serial);
    _serial = STR_y2oc(serial);
    ARC_retain(_serial)
    ARC_release(_funId);
    _funId = STR_y2oc(funcId);
    ARC_retain(_funId)
    ARC_release(_hwId);
    _hwId = [NSString stringWithFormat:@"%@.%@",_serial,_funId];
    ARC_retain(_hwId);

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

    return YAPI_SUCCESS;
}


/**
 * Invalidates the cache. Invalidates the cache of the function attributes. Forces the
 * next call to get_xxx() or loadxxx() to use values that come from the device.
 *
 * @noreturn
 */
-(void)    clearCache
{
    YDevice     *dev;
    NSError     *error;
    YRETCODE    res;

    // Resolve our reference to our device, load REST API
    res = [self _getDevice:&dev:&error];
    if(YISERR(res)) {
        return;
    }
    [dev clearCache];
    if (_cacheExpiration){
        _cacheExpiration = yapiGetTickCount();
    }
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

/**
 * Returns the value of the userData attribute, as previously stored using method
 * set_userData.
 * This attribute is never touched directly by the API, and is at disposal of the caller to
 * store a context.
 *
 * @return the object stored previously by the caller.
 */
-(id)    get_userData
{   return [self userData];}
-(id)    userData
{
    return _userData;
}


/**
 * Stores a user context provided as argument in the userData attribute of the function.
 * This attribute is never touched by the API, and is at disposal of the caller to store a context.
 *
 * @param data : any kind of object to be stored
 * @noreturn
 */
-(void)     set_userData:(id _Nullable)data
{
    [self setUserData:data];}

-(void)     setUserData:(id _Nullable)data
{
    _userData = data;
}

@end //YFunction


@implementation YSensor

// Constructor is protected, use yFindSensor factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"Sensor";
//--- (generated code: YSensor attributes initialization)
    _unit = Y_UNIT_INVALID;
    _currentValue = Y_CURRENTVALUE_INVALID;
    _lowestValue = Y_LOWESTVALUE_INVALID;
    _highestValue = Y_HIGHESTVALUE_INVALID;
    _currentRawValue = Y_CURRENTRAWVALUE_INVALID;
    _logFrequency = Y_LOGFREQUENCY_INVALID;
    _reportFrequency = Y_REPORTFREQUENCY_INVALID;
    _advMode = Y_ADVMODE_INVALID;
    _calibrationParam = Y_CALIBRATIONPARAM_INVALID;
    _resolution = Y_RESOLUTION_INVALID;
    _sensorState = Y_SENSORSTATE_INVALID;
    _valueCallbackSensor = NULL;
    _timedReportCallbackSensor = NULL;
    _prevTimedReport = 0;
    _iresol = 0;
    _offset = 0;
    _scale = 0;
    _decexp = 0;
    _caltyp = 0;
    _calpar = [NSMutableArray array];
    _calraw = [NSMutableArray array];
    _calref = [NSMutableArray array];
    _calhdl = nil;
//--- (end of generated code: YSensor attributes initialization)
    return self;
}


-(void) dealloc
{
//--- (generated code: YSensor cleanup)
    ARC_release(_unit);
    _unit = nil;
    ARC_release(_logFrequency);
    _logFrequency = nil;
    ARC_release(_reportFrequency);
    _reportFrequency = nil;
    ARC_release(_calibrationParam);
    _calibrationParam = nil;
    ARC_dealloc(super);
//--- (end of generated code: YSensor cleanup)
}

//--- (generated code: YSensor private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "unit")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_unit);
        _unit =  [self _parseString:j];
        ARC_retain(_unit);
        return 1;
    }
    if(!strcmp(j->token, "currentValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "lowestValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lowestValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "highestValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _highestValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "currentRawValue")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentRawValue =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "logFrequency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_logFrequency);
        _logFrequency =  [self _parseString:j];
        ARC_retain(_logFrequency);
        return 1;
    }
    if(!strcmp(j->token, "reportFrequency")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_reportFrequency);
        _reportFrequency =  [self _parseString:j];
        ARC_retain(_reportFrequency);
        return 1;
    }
    if(!strcmp(j->token, "advMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _advMode =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "calibrationParam")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_calibrationParam);
        _calibrationParam =  [self _parseString:j];
        ARC_retain(_calibrationParam);
        return 1;
    }
    if(!strcmp(j->token, "resolution")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _resolution =  floor(atof(j->token) / 65.536 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "sensorState")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _sensorState =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YSensor private methods implementation)

// Method used to encode calibration points into fixed-point 16-bit integers or decimal floating-point
//
-(NSString*) _encodeCalibrationPoints:(NSArray*)rawValues :(NSArray*)refValues :(NSString*)actualCparams
{
    int         npt = (int)([rawValues count] < [refValues count] ? [rawValues count] : [refValues count]);
    int         caltype;
    int         rawVal, refVal;
    int         minRaw = 0;
    NSMutableString    *res;

    if(npt == 0) {
        return @"0";
    }

    NSUInteger pos = [actualCparams rangeOfString:@","].location;
     if ([actualCparams  isEqualToString:@""] || [actualCparams  isEqualToString:@"0"] || pos != NSNotFound) {
        [self _throw:YAPI_NOT_SUPPORTED :@"Device does not support new calibration parameters. Please upgrade your firmware"];
        return @"0";
    }
    NSArray *iCalib =  [YAPI _decodeWords:actualCparams];
    int calibrationOffset = [[iCalib objectAtIndex:0] intValue];
    int divisor = [[iCalib objectAtIndex:1] intValue];
    if (divisor > 0) {
        caltype = npt;
    } else {
        caltype = 10+npt;
    }
    res = [NSMutableString stringWithFormat:@"%u",caltype];
    if (caltype <=10){
        for(int i = 0; i < npt; i++) {
            rawVal = (int) ([[rawValues objectAtIndex:i] doubleValue] * divisor - calibrationOffset + .5);
            if(rawVal >= minRaw && rawVal < 65536) {
                refVal = (int) ([[refValues objectAtIndex:i] doubleValue] * divisor - calibrationOffset + .5);
                if(refVal >= 0 && refVal < 65536) {
                    [res appendFormat:@",%d,%d",rawVal,refVal];
                    minRaw = rawVal+1;
                }
            }
        }
    } else {
        // 16-bit floating-point decimal encoding
        for(int i = 0; i < npt; i++) {
            rawVal = [YAPI _doubleToDecimal:[[rawValues objectAtIndex:i] doubleValue]];
            refVal = [YAPI _doubleToDecimal:[[refValues objectAtIndex:i] doubleValue]];
            [res appendFormat:@",%d,%d",rawVal,refVal];
        }
    }
    return res;
}

// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
//
// Method used to decode calibration points given as 16-bit fixed-point or decimal floating-point
-(int) _decodeCalibrationPoints:(NSString*)calibParams :(NSMutableArray*)intPt :(NSMutableArray*)rawPt :(NSMutableArray*)calPt
{
    int    pos=0, calibType;
    double calibrationOffset,divisor;

    [intPt removeAllObjects];
    [rawPt removeAllObjects];
    [calPt removeAllObjects];

    if ([calibParams isEqualToString:@""] || [calibParams isEqualToString:@"0"]) {
        // old format: no calibration
        return 0;
    }
    if ([calibParams rangeOfString:@","].location != NSNotFound) {
        // old format -> device must do the calibration
        return -1;
    }

    // new format
    NSArray *iCalib = [YAPI _decodeWords:calibParams];
    if([iCalib count] < 2) {
        // bad format
        return -1;
    }
    if([iCalib count] == 2) {
        // no calibration
        return 0;
    }

    calibrationOffset = [[iCalib objectAtIndex:pos++] doubleValue];
    divisor = [[iCalib objectAtIndex:pos++] doubleValue];
    calibType = [[iCalib objectAtIndex:pos++] intValue];

    // parse calibration parameters
    while(pos+1 < [iCalib count]) {
        int rawval = [[iCalib objectAtIndex:pos++] intValue];
        int calval = [[iCalib objectAtIndex:pos++] intValue];
        double rawval_d, calval_d;
        [intPt addObject:[NSNumber numberWithInt:rawval]];
        [intPt addObject:[NSNumber numberWithInt:calval]];
        if(divisor != 0) {
            rawval_d = (rawval + calibrationOffset) / divisor;
            calval_d = (calval + calibrationOffset) / divisor;
        } else {
            rawval_d = [YAPI _decimalToDouble:rawval];
            calval_d = [YAPI _decimalToDouble:calval];
        }
        [rawPt addObject:[NSNumber numberWithDouble:rawval_d]];
        [calPt addObject:[NSNumber numberWithDouble:calval_d]];
    }
    if ([intPt count] < 10) {
        return -1;
    }
    return calibType;
}

//--- (generated code: YSensor public methods implementation)
/**
 * Returns the measuring unit for the measure.
 *
 * @return a string corresponding to the measuring unit for the measure
 *
 * On failure, throws an exception or returns YSensor.UNIT_INVALID.
 */
-(NSString*) get_unit
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_UNIT_INVALID;
        }
    }
    res = _unit;
    return res;
}


-(NSString*) unit
{
    return [self get_unit];
}
/**
 * Returns the current value of the measure, in the specified unit, as a floating point number.
 * Note that a get_currentValue() call will *not* start a measure in the device, it
 * will just return the last measure that occurred in the device. Indeed, internally, each Yoctopuce
 * devices is continuously making measurements at a hardware specific frequency.
 *
 * If continuously calling  get_currentValue() leads you to performances issues, then
 * you might consider to switch to callback programming model. Check the "advanced
 * programming" chapter in in your device user manual for more information.
 *
 * @return a floating point number corresponding to the current value of the measure, in the specified
 * unit, as a floating point number
 *
 * On failure, throws an exception or returns YSensor.CURRENTVALUE_INVALID.
 */
-(double) get_currentValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTVALUE_INVALID;
        }
    }
    res = [self _applyCalibration:_currentRawValue];
    if (res == Y_CURRENTVALUE_INVALID) {
        res = _currentValue;
    }
    res = res * _iresol;
    res = floor(res+0.5) / _iresol;
    return res;
}


-(double) currentValue
{
    return [self get_currentValue];
}

/**
 * Changes the recorded minimal value observed. Can be used to reset the value returned
 * by get_lowestValue().
 *
 * @param newval : a floating point number corresponding to the recorded minimal value observed
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_lowestValue:(double) newval
{
    return [self setLowestValue:newval];
}
-(int) setLowestValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"lowestValue" :rest_val];
}
/**
 * Returns the minimal value observed for the measure since the device was started.
 * Can be reset to an arbitrary value thanks to set_lowestValue().
 *
 * @return a floating point number corresponding to the minimal value observed for the measure since
 * the device was started
 *
 * On failure, throws an exception or returns YSensor.LOWESTVALUE_INVALID.
 */
-(double) get_lowestValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOWESTVALUE_INVALID;
        }
    }
    res = _lowestValue * _iresol;
    res = floor(res+0.5) / _iresol;
    return res;
}


-(double) lowestValue
{
    return [self get_lowestValue];
}

/**
 * Changes the recorded maximal value observed. Can be used to reset the value returned
 * by get_lowestValue().
 *
 * @param newval : a floating point number corresponding to the recorded maximal value observed
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_highestValue:(double) newval
{
    return [self setHighestValue:newval];
}
-(int) setHighestValue:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"highestValue" :rest_val];
}
/**
 * Returns the maximal value observed for the measure since the device was started.
 * Can be reset to an arbitrary value thanks to set_highestValue().
 *
 * @return a floating point number corresponding to the maximal value observed for the measure since
 * the device was started
 *
 * On failure, throws an exception or returns YSensor.HIGHESTVALUE_INVALID.
 */
-(double) get_highestValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_HIGHESTVALUE_INVALID;
        }
    }
    res = _highestValue * _iresol;
    res = floor(res+0.5) / _iresol;
    return res;
}


-(double) highestValue
{
    return [self get_highestValue];
}
/**
 * Returns the uncalibrated, unrounded raw value returned by the
 * sensor, in the specified unit, as a floating point number.
 *
 * @return a floating point number corresponding to the uncalibrated, unrounded raw value returned by the
 *         sensor, in the specified unit, as a floating point number
 *
 * On failure, throws an exception or returns YSensor.CURRENTRAWVALUE_INVALID.
 */
-(double) get_currentRawValue
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTRAWVALUE_INVALID;
        }
    }
    res = _currentRawValue;
    return res;
}


-(double) currentRawValue
{
    return [self get_currentRawValue];
}
/**
 * Returns the datalogger recording frequency for this function, or "OFF"
 * when measures are not stored in the data logger flash memory.
 *
 * @return a string corresponding to the datalogger recording frequency for this function, or "OFF"
 *         when measures are not stored in the data logger flash memory
 *
 * On failure, throws an exception or returns YSensor.LOGFREQUENCY_INVALID.
 */
-(NSString*) get_logFrequency
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LOGFREQUENCY_INVALID;
        }
    }
    res = _logFrequency;
    return res;
}


-(NSString*) logFrequency
{
    return [self get_logFrequency];
}

/**
 * Changes the datalogger recording frequency for this function.
 * The frequency can be specified as samples per second,
 * as sample per minute (for instance "15/m") or in samples per
 * hour (eg. "4/h"). To disable recording for this function, use
 * the value "OFF". Note that setting the  datalogger recording frequency
 * to a greater value than the sensor native sampling frequency is useless,
 * and even counterproductive: those two frequencies are not related.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the datalogger recording frequency for this function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_logFrequency:(NSString*) newval
{
    return [self setLogFrequency:newval];
}
-(int) setLogFrequency:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"logFrequency" :rest_val];
}
/**
 * Returns the timed value notification frequency, or "OFF" if timed
 * value notifications are disabled for this function.
 *
 * @return a string corresponding to the timed value notification frequency, or "OFF" if timed
 *         value notifications are disabled for this function
 *
 * On failure, throws an exception or returns YSensor.REPORTFREQUENCY_INVALID.
 */
-(NSString*) get_reportFrequency
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REPORTFREQUENCY_INVALID;
        }
    }
    res = _reportFrequency;
    return res;
}


-(NSString*) reportFrequency
{
    return [self get_reportFrequency];
}

/**
 * Changes the timed value notification frequency for this function.
 * The frequency can be specified as samples per second,
 * as sample per minute (for instance "15/m") or in samples per
 * hour (e.g. "4/h"). To disable timed value notifications for this
 * function, use the value "OFF". Note that setting the  timed value
 * notification frequency to a greater value than the sensor native
 * sampling frequency is unless, and even counterproductive: those two
 * frequencies are not related.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a string corresponding to the timed value notification frequency for this function
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_reportFrequency:(NSString*) newval
{
    return [self setReportFrequency:newval];
}
-(int) setReportFrequency:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"reportFrequency" :rest_val];
}
/**
 * Returns the measuring mode used for the advertised value pushed to the parent hub.
 *
 * @return a value among YSensor.ADVMODE_IMMEDIATE, YSensor.ADVMODE_PERIOD_AVG,
 * YSensor.ADVMODE_PERIOD_MIN and YSensor.ADVMODE_PERIOD_MAX corresponding to the measuring mode used
 * for the advertised value pushed to the parent hub
 *
 * On failure, throws an exception or returns YSensor.ADVMODE_INVALID.
 */
-(Y_ADVMODE_enum) get_advMode
{
    Y_ADVMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ADVMODE_INVALID;
        }
    }
    res = _advMode;
    return res;
}


-(Y_ADVMODE_enum) advMode
{
    return [self get_advMode];
}

/**
 * Changes the measuring mode used for the advertised value pushed to the parent hub.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a value among YSensor.ADVMODE_IMMEDIATE, YSensor.ADVMODE_PERIOD_AVG,
 * YSensor.ADVMODE_PERIOD_MIN and YSensor.ADVMODE_PERIOD_MAX corresponding to the measuring mode used
 * for the advertised value pushed to the parent hub
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_advMode:(Y_ADVMODE_enum) newval
{
    return [self setAdvMode:newval];
}
-(int) setAdvMode:(Y_ADVMODE_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"advMode" :rest_val];
}
-(NSString*) get_calibrationParam
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CALIBRATIONPARAM_INVALID;
        }
    }
    res = _calibrationParam;
    return res;
}


-(NSString*) calibrationParam
{
    return [self get_calibrationParam];
}

-(int) set_calibrationParam:(NSString*) newval
{
    return [self setCalibrationParam:newval];
}
-(int) setCalibrationParam:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"calibrationParam" :rest_val];
}

/**
 * Changes the resolution of the measured physical values. The resolution corresponds to the numerical precision
 * when displaying value. It does not change the precision of the measure itself.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @param newval : a floating point number corresponding to the resolution of the measured physical values
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_resolution:(double) newval
{
    return [self setResolution:newval];
}
-(int) setResolution:(double) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%ld",(s64)floor(newval * 65536.0 + 0.5)];
    return [self _setAttr:@"resolution" :rest_val];
}
/**
 * Returns the resolution of the measured values. The resolution corresponds to the numerical precision
 * of the measures, which is not always the same as the actual precision of the sensor.
 * Remember to call the saveToFlash() method of the module if the modification must be kept.
 *
 * @return a floating point number corresponding to the resolution of the measured values
 *
 * On failure, throws an exception or returns YSensor.RESOLUTION_INVALID.
 */
-(double) get_resolution
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RESOLUTION_INVALID;
        }
    }
    res = _resolution;
    return res;
}


-(double) resolution
{
    return [self get_resolution];
}
/**
 * Returns the sensor health state code, which is zero when there is an up-to-date measure
 * available or a positive code if the sensor is not able to provide a measure right now.
 *
 * @return an integer corresponding to the sensor health state code, which is zero when there is an
 * up-to-date measure
 *         available or a positive code if the sensor is not able to provide a measure right now
 *
 * On failure, throws an exception or returns YSensor.SENSORSTATE_INVALID.
 */
-(int) get_sensorState
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SENSORSTATE_INVALID;
        }
    }
    res = _sensorState;
    return res;
}


-(int) sensorState
{
    return [self get_sensorState];
}
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
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the sensor, for instance
 *         MyDevice..
 *
 * @return a YSensor object allowing you to drive the sensor.
 */
+(YSensor*) FindSensor:(NSString*)func
{
    YSensor* obj;
    obj = (YSensor*) [YFunction _FindFromCache:@"Sensor" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YSensor alloc] initWith:func]);
        [YFunction _AddToCache:@"Sensor" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YSensorValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackSensor = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackSensor != NULL) {
        _valueCallbackSensor(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) _parserHelper
{
    int position;
    int maxpos;
    NSMutableArray* iCalib = [NSMutableArray array];
    int iRaw;
    int iRef;
    double fRaw;
    double fRef;
    _caltyp = -1;
    _scale = -1;
    [_calpar removeAllObjects];
    [_calraw removeAllObjects];
    [_calref removeAllObjects];
    // Store inverted resolution, to provide better rounding
    if (_resolution > 0) {
        _iresol = floor(1.0 / _resolution+0.5);
    } else {
        _iresol = 10000;
        _resolution = 0.0001;
    }
    // Old format: supported when there is no calibration
    if ([_calibrationParam isEqualToString:@""] || [_calibrationParam isEqualToString:@"0"]) {
        _caltyp = 0;
        return 0;
    }
    if (_ystrpos(_calibrationParam, @",") >= 0) {
        // Plain text format
        iCalib = [YAPI _decodeFloats:_calibrationParam];
        _caltyp = (([[iCalib objectAtIndex:0] intValue]) / (1000));
        if (_caltyp > 0) {
            if (_caltyp < YOCTO_CALIB_TYPE_OFS) {
                // Unknown calibration type: calibrated value will be provided by the device
                _caltyp = -1;
                return 0;
            }
            _calhdl = [YAPI _getCalibrationHandler:_caltyp];
            if (!(_calhdl != NULL)) {
                // Unknown calibration type: calibrated value will be provided by the device
                _caltyp = -1;
                return 0;
            }
        }
        // New 32 bits text format
        _offset = 0;
        _scale = 1000;
        maxpos = (int)[iCalib count];
        [_calpar removeAllObjects];
        position = 1;
        while (position < maxpos) {
            [_calpar addObject:[iCalib objectAtIndex:position]];
            position = position + 1;
        }
        [_calraw removeAllObjects];
        [_calref removeAllObjects];
        position = 1;
        while (position + 1 < maxpos) {
            fRaw = [[iCalib objectAtIndex:position] doubleValue];
            fRaw = fRaw / 1000.0;
            fRef = [[iCalib objectAtIndex:position + 1] doubleValue];
            fRef = fRef / 1000.0;
            [_calraw addObject:[NSNumber numberWithDouble:fRaw]];
            [_calref addObject:[NSNumber numberWithDouble:fRef]];
            position = position + 2;
        }
    } else {
        // Recorder-encoded format, including encoding
        iCalib = [YAPI _decodeWords:_calibrationParam];
        // In case of unknown format, calibrated value will be provided by the device
        if ((int)[iCalib count] < 2) {
            _caltyp = -1;
            return 0;
        }
        // Save variable format (scale for scalar, or decimal exponent)
        _offset = 0;
        _scale = 1;
        _decexp = 1.0;
        position = [[iCalib objectAtIndex:0] intValue];
        while (position > 0) {
            _decexp = _decexp * 10;
            position = position - 1;
        }
        // Shortcut when there is no calibration parameter
        if ((int)[iCalib count] == 2) {
            _caltyp = 0;
            return 0;
        }
        _caltyp = [[iCalib objectAtIndex:2] intValue];
        _calhdl = [YAPI _getCalibrationHandler:_caltyp];
        // parse calibration points
        if (_caltyp <= 10) {
            maxpos = _caltyp;
        } else {
            if (_caltyp <= 20) {
                maxpos = _caltyp - 10;
            } else {
                maxpos = 5;
            }
        }
        maxpos = 3 + 2 * maxpos;
        if (maxpos > (int)[iCalib count]) {
            maxpos = (int)[iCalib count];
        }
        [_calpar removeAllObjects];
        [_calraw removeAllObjects];
        [_calref removeAllObjects];
        position = 3;
        while (position + 1 < maxpos) {
            iRaw = [[iCalib objectAtIndex:position] intValue];
            iRef = [[iCalib objectAtIndex:position + 1] intValue];
            [_calpar addObject:[NSNumber numberWithLong:iRaw]];
            [_calpar addObject:[NSNumber numberWithLong:iRef]];
            [_calraw addObject:[NSNumber numberWithDouble:[YAPI _decimalToDouble:iRaw]]];
            [_calref addObject:[NSNumber numberWithDouble:[YAPI _decimalToDouble:iRef]]];
            position = position + 2;
        }
    }
    return 0;
}

/**
 * Checks if the sensor is currently able to provide an up-to-date measure.
 * Returns false if the device is unreachable, or if the sensor does not have
 * a current measure to transmit. No exception is raised if there is an error
 * while trying to contact the device hosting $THEFUNCTION$.
 *
 * @return true if the sensor can provide an up-to-date measure, and false otherwise
 */
-(bool) isSensorReady
{
    if (!([self isOnline])) {
        return NO;
    }
    if (!(_sensorState == 0)) {
        return NO;
    }
    return YES;
}

/**
 * Returns the YDatalogger object of the device hosting the sensor. This method returns an object
 * that can control global parameters of the data logger. The returned object
 * should not be freed.
 *
 * @return an YDatalogger object, or nil on error.
 */
-(YDataLogger*) get_dataLogger
{
    YDataLogger* logger;
    YModule* modu;
    NSString* serial;
    NSString* hwid;

    modu = [self get_module];
    serial = [modu get_serialNumber];
    if ([serial isEqualToString:YAPI_INVALID_STRING]) {
        return nil;
    }
    hwid = [NSString stringWithFormat:@"%@%@", serial, @".dataLogger"];
    logger = [YDataLogger FindDataLogger:hwid];
    return logger;
}

/**
 * Starts the data logger on the device. Note that the data logger
 * will only save the measures on this sensor if the logFrequency
 * is not set to "OFF".
 *
 * @return YAPI.SUCCESS if the call succeeds.
 */
-(int) startDataLogger
{
    NSMutableData* res;

    res = [self _download:@"api/dataLogger/recording?recording=1"];
    if (!((int)[res length] > 0)) {[self _throw: YAPI_IO_ERROR: @"unable to start datalogger"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Stops the datalogger on the device.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 */
-(int) stopDataLogger
{
    NSMutableData* res;

    res = [self _download:@"api/dataLogger/recording?recording=0"];
    if (!((int)[res length] > 0)) {[self _throw: YAPI_IO_ERROR: @"unable to stop datalogger"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Retrieves a YDataSet object holding historical data for this
 * sensor, for a specified time interval. The measures will be
 * retrieved from the data logger, which must have been turned
 * on at the desired time. See the documentation of the YDataSet
 * class for information on how to get an overview of the
 * recorded data, and how to load progressively a large set
 * of measures from the data logger.
 *
 * This function only works if the device uses a recent firmware,
 * as YDataSet objects are not supported by firmwares older than
 * version 13000.
 *
 * @param startTime : the start of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any measure, without initial limit.
 * @param endTime : the end of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any measure, without ending limit.
 *
 * @return an instance of YDataSet, providing access to historical
 *         data. Past measures can be loaded progressively
 *         using methods from the YDataSet object.
 */
-(YDataSet*) get_recordedData:(double)startTime :(double)endTime
{
    NSString* funcid;
    NSString* funit;

    funcid = [self get_functionId];
    funit = [self get_unit];
    return ARC_sendAutorelease([[YDataSet alloc] initWith:self :funcid :funit :startTime :endTime]);
}

/**
 * Registers the callback function that is invoked on every periodic timed notification.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and an YMeasure object describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerTimedReportCallback:(YSensorTimedReportCallback _Nullable)callback
{
    YSensor* sensor;
    sensor = self;
    if (callback != NULL) {
        [YFunction _UpdateTimedReportCallbackList:sensor :YES];
    } else {
        [YFunction _UpdateTimedReportCallbackList:sensor :NO];
    }
    _timedReportCallbackSensor = callback;
    return 0;
}

-(int) _invokeTimedReportCallback:(YMeasure*)value
{
    if (_timedReportCallbackSensor != NULL) {
        _timedReportCallbackSensor(self, value);
    } else {
    }
    return 0;
}

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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) calibrateFromPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues
{
    NSString* rest_val;
    int res;

    rest_val = [self _encodeCalibrationPoints:rawValues :refValues];
    res = [self _setAttr:@"calibrationParam" :rest_val];
    return res;
}

/**
 * Retrieves error correction data points previously entered using the method
 * calibrateFromPoints.
 *
 * @param rawValues : array of floating point numbers, that will be filled by the
 *         function with the raw sensor values for the correction points.
 * @param refValues : array of floating point numbers, that will be filled by the
 *         function with the desired values for the correction points.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadCalibrationPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues
{
    [rawValues removeAllObjects];
    [refValues removeAllObjects];
    // Load function parameters if not yet loaded
    if (_scale == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return YAPI_DEVICE_NOT_FOUND;
        }
    }
    if (_caltyp < 0) {
        [self _throw:YAPI_NOT_SUPPORTED :@"Calibration parameters format mismatch. Please upgrade your library or firmware."];
        return YAPI_NOT_SUPPORTED;
    }
    [rawValues removeAllObjects];
    [refValues removeAllObjects];
    for (NSNumber* _each  in _calraw) {
        [rawValues addObject:[NSNumber numberWithDouble:[_each intValue]]];
    }
    for (NSNumber* _each  in _calref) {
        [refValues addObject:[NSNumber numberWithDouble:[_each intValue]]];
    }
    return YAPI_SUCCESS;
}

-(NSString*) _encodeCalibrationPoints:(NSMutableArray*)rawValues :(NSMutableArray*)refValues
{
    NSString* res;
    int npt;
    int idx;
    npt = (int)[rawValues count];
    if (npt != (int)[refValues count]) {
        [self _throw:YAPI_INVALID_ARGUMENT :@"Invalid calibration parameters (size mismatch)"];
        return YAPI_INVALID_STRING;
    }
    // Shortcut when building empty calibration parameters
    if (npt == 0) {
        return @"0";
    }
    // Load function parameters if not yet loaded
    if (_scale == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return YAPI_INVALID_STRING;
        }
    }
    // Detect old firmware
    if ((_caltyp < 0) || (_scale < 0)) {
        [self _throw:YAPI_NOT_SUPPORTED :@"Calibration parameters format mismatch. Please upgrade your library or firmware."];
        return @"0";
    }
    // 32-bit fixed-point encoding
    res = [NSString stringWithFormat:@"%d",YOCTO_CALIB_TYPE_OFS];
    idx = 0;
    while (idx < npt) {
        res = [NSString stringWithFormat:@"%@,%g,%g", res, [[rawValues objectAtIndex:idx] doubleValue],[[refValues objectAtIndex:idx] doubleValue]];
        idx = idx + 1;
    }
    return res;
}

-(double) _applyCalibration:(double)rawValue
{
    if (rawValue == Y_CURRENTVALUE_INVALID) {
        return Y_CURRENTVALUE_INVALID;
    }
    if (_caltyp == 0) {
        return rawValue;
    }
    if (_caltyp < 0) {
        return Y_CURRENTVALUE_INVALID;
    }
    if (!(_calhdl != NULL)) {
        return Y_CURRENTVALUE_INVALID;
    }
    return [_calhdl yCalibrationHandler: rawValue: _caltyp: _calpar: _calraw:_calref];
}

-(YMeasure*) _decodeTimedReport:(double)timestamp :(double)duration :(NSMutableArray*)report
{
    int i;
    int byteVal;
    double poww;
    double minRaw;
    double avgRaw;
    double maxRaw;
    int sublen;
    double difRaw;
    double startTime;
    double endTime;
    double minVal;
    double avgVal;
    double maxVal;
    if (duration > 0) {
        startTime = timestamp - duration;
    } else {
        startTime = _prevTimedReport;
    }
    endTime = timestamp;
    _prevTimedReport = endTime;
    if (startTime == 0) {
        startTime = endTime;
    }
    // 32 bits timed report format
    if ((int)[report count] <= 5) {
        // sub-second report, 1-4 bytes
        poww = 1;
        avgRaw = 0;
        byteVal = 0;
        i = 1;
        while (i < (int)[report count]) {
            byteVal = [[report objectAtIndex:i] intValue];
            avgRaw = avgRaw + poww * byteVal;
            poww = poww * 0x100;
            i = i + 1;
        }
        if (((byteVal) & (0x80)) != 0) {
            avgRaw = avgRaw - poww;
        }
        avgVal = avgRaw / 1000.0;
        if (_caltyp != 0) {
            if (_calhdl != NULL) {
                avgVal = [_calhdl yCalibrationHandler: avgVal: _caltyp: _calpar: _calraw:_calref];
            }
        }
        minVal = avgVal;
        maxVal = avgVal;
    } else {
        // averaged report: avg,avg-min,max-avg
        sublen = 1 + (([[report objectAtIndex:1] intValue]) & (3));
        poww = 1;
        avgRaw = 0;
        byteVal = 0;
        i = 2;
        while ((sublen > 0) && (i < (int)[report count])) {
            byteVal = [[report objectAtIndex:i] intValue];
            avgRaw = avgRaw + poww * byteVal;
            poww = poww * 0x100;
            i = i + 1;
            sublen = sublen - 1;
        }
        if (((byteVal) & (0x80)) != 0) {
            avgRaw = avgRaw - poww;
        }
        sublen = 1 + (((([[report objectAtIndex:1] intValue]) >> (2))) & (3));
        poww = 1;
        difRaw = 0;
        while ((sublen > 0) && (i < (int)[report count])) {
            byteVal = [[report objectAtIndex:i] intValue];
            difRaw = difRaw + poww * byteVal;
            poww = poww * 0x100;
            i = i + 1;
            sublen = sublen - 1;
        }
        minRaw = avgRaw - difRaw;
        sublen = 1 + (((([[report objectAtIndex:1] intValue]) >> (4))) & (3));
        poww = 1;
        difRaw = 0;
        while ((sublen > 0) && (i < (int)[report count])) {
            byteVal = [[report objectAtIndex:i] intValue];
            difRaw = difRaw + poww * byteVal;
            poww = poww * 0x100;
            i = i + 1;
            sublen = sublen - 1;
        }
        maxRaw = avgRaw + difRaw;
        avgVal = avgRaw / 1000.0;
        minVal = minRaw / 1000.0;
        maxVal = maxRaw / 1000.0;
        if (_caltyp != 0) {
            if (_calhdl != NULL) {
                avgVal = [_calhdl yCalibrationHandler: avgVal: _caltyp: _calpar: _calraw:_calref];
                minVal = [_calhdl yCalibrationHandler: minVal: _caltyp: _calpar: _calraw:_calref];
                maxVal = [_calhdl yCalibrationHandler: maxVal: _caltyp: _calpar: _calraw:_calref];
            }
        }
    }
    return ARC_sendAutorelease([[YMeasure alloc] initWith:startTime :endTime :minVal :avgVal :maxVal]);
}

-(double) _decodeVal:(int)w
{
    double val;
    val = w;
    if (_caltyp != 0) {
        if (_calhdl != NULL) {
            val = [_calhdl yCalibrationHandler: val:_caltyp: _calpar: _calraw:_calref];
        }
    }
    return val;
}

-(double) _decodeAvg:(int)dw
{
    double val;
    val = dw;
    if (_caltyp != 0) {
        if (_calhdl != NULL) {
            val = [_calhdl yCalibrationHandler: val: _caltyp: _calpar: _calraw:_calref];
        }
    }
    return val;
}


-(YSensor*)   nextSensor
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YSensor FindSensor:hwid];
}

+(YSensor *) FirstSensor
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Sensor":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YSensor FindSensor:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YSensor public methods implementation)


@end

@implementation YModule

// Constructor is protected, use yFindModule factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"Module";
//--- (generated code: YModule attributes initialization)
    _productName = Y_PRODUCTNAME_INVALID;
    _serialNumber = Y_SERIALNUMBER_INVALID;
    _productId = Y_PRODUCTID_INVALID;
    _productRelease = Y_PRODUCTRELEASE_INVALID;
    _firmwareRelease = Y_FIRMWARERELEASE_INVALID;
    _persistentSettings = Y_PERSISTENTSETTINGS_INVALID;
    _luminosity = Y_LUMINOSITY_INVALID;
    _beacon = Y_BEACON_INVALID;
    _upTime = Y_UPTIME_INVALID;
    _usbCurrent = Y_USBCURRENT_INVALID;
    _rebootCountdown = Y_REBOOTCOUNTDOWN_INVALID;
    _userVar = Y_USERVAR_INVALID;
    _valueCallbackModule = NULL;
    _logCallback = NULL;
    _confChangeCallback = NULL;
    _beaconCallback = NULL;
//--- (end of generated code: YModule attributes initialization)
    return self;
}

-(void) dealloc
{
//--- (generated code: YModule cleanup)
    ARC_release(_productName);
    _productName = nil;
    ARC_release(_serialNumber);
    _serialNumber = nil;
    ARC_release(_firmwareRelease);
    _firmwareRelease = nil;
    ARC_dealloc(super);
//--- (end of generated code: YModule cleanup)
}

// Method used to retrieve details of the nth function of our device
-(YRETCODE)        _getFunction:(int) idx  :(NSString**)serial  :(NSString**)funcId :(NSString**)baseType :(NSString**)funcName :(NSString**)funcVal :(NSError**)error
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
    res = [YapiWrapper getFunctionInfoEx:fundescr:&devdescr:serial:funcId :baseType :funcName:funcVal:error];
    if(YISERR(res)) return (YRETCODE)res;

    return YAPI_SUCCESS;

}


+(void) _updateModuleCallbackList:(YModule*)modul :(BOOL)add;
{
    NSNumber *val;
    NSString *serial;
    if (add) {
        [modul isOnline];
        serial = [modul get_serialNumber];
        if (_moduleCallbackList == nil){
            _moduleCallbackList = [[NSMutableDictionary alloc] init];
        }
        val = [_moduleCallbackList objectForKey:serial] ;
        if (val == nil) {
            [_moduleCallbackList setObject: [NSNumber numberWithLong:1] forKey:serial];
        } else {
            int int_val = [val intValue] + 1;
            [_moduleCallbackList setObject:[NSNumber numberWithLong:int_val] forKey:serial];
        }
    } else {
        serial = [modul get_serialNumber];
        val = [_moduleCallbackList objectForKey:serial] ;
        if (val != nil) {
            int int_val = [val intValue];
            if (int_val > 1) {
                [_moduleCallbackList setObject:[NSNumber numberWithLong:int_val - 1] forKey:serial];
            }
        }
    }
}



//--- (generated code: YModule private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "productName")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_productName);
        _productName =  [self _parseString:j];
        ARC_retain(_productName);
        return 1;
    }
    if(!strcmp(j->token, "serialNumber")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_serialNumber);
        _serialNumber =  [self _parseString:j];
        ARC_retain(_serialNumber);
        return 1;
    }
    if(!strcmp(j->token, "productId")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _productId =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "productRelease")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _productRelease =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "firmwareRelease")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_firmwareRelease);
        _firmwareRelease =  [self _parseString:j];
        ARC_retain(_firmwareRelease);
        return 1;
    }
    if(!strcmp(j->token, "persistentSettings")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _persistentSettings =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "luminosity")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _luminosity =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "beacon")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _beacon =  (Y_BEACON_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "upTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _upTime =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "usbCurrent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _usbCurrent =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "rebootCountdown")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _rebootCountdown =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "userVar")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _userVar =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YModule private methods implementation)

//--- (generated code: YModule public methods implementation)
/**
 * Returns the commercial name of the module, as set by the factory.
 *
 * @return a string corresponding to the commercial name of the module, as set by the factory
 *
 * On failure, throws an exception or returns YModule.PRODUCTNAME_INVALID.
 */
-(NSString*) get_productName
{
    NSString* res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PRODUCTNAME_INVALID;
        }
    }
    res = _productName;
    return res;
}


-(NSString*) productName
{
    return [self get_productName];
}
/**
 * Returns the serial number of the module, as set by the factory.
 *
 * @return a string corresponding to the serial number of the module, as set by the factory
 *
 * On failure, throws an exception or returns YModule.SERIALNUMBER_INVALID.
 */
-(NSString*) get_serialNumber
{
    NSString* res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SERIALNUMBER_INVALID;
        }
    }
    res = _serialNumber;
    return res;
}


-(NSString*) serialNumber
{
    return [self get_serialNumber];
}
/**
 * Returns the USB device identifier of the module.
 *
 * @return an integer corresponding to the USB device identifier of the module
 *
 * On failure, throws an exception or returns YModule.PRODUCTID_INVALID.
 */
-(int) get_productId
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PRODUCTID_INVALID;
        }
    }
    res = _productId;
    return res;
}


-(int) productId
{
    return [self get_productId];
}
/**
 * Returns the release number of the module hardware, preprogrammed at the factory.
 * The original hardware release returns value 1, revision B returns value 2, etc.
 *
 * @return an integer corresponding to the release number of the module hardware, preprogrammed at the factory
 *
 * On failure, throws an exception or returns YModule.PRODUCTRELEASE_INVALID.
 */
-(int) get_productRelease
{
    int res;
    if (_cacheExpiration == 0) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PRODUCTRELEASE_INVALID;
        }
    }
    res = _productRelease;
    return res;
}


-(int) productRelease
{
    return [self get_productRelease];
}
/**
 * Returns the version of the firmware embedded in the module.
 *
 * @return a string corresponding to the version of the firmware embedded in the module
 *
 * On failure, throws an exception or returns YModule.FIRMWARERELEASE_INVALID.
 */
-(NSString*) get_firmwareRelease
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_FIRMWARERELEASE_INVALID;
        }
    }
    res = _firmwareRelease;
    return res;
}


-(NSString*) firmwareRelease
{
    return [self get_firmwareRelease];
}
/**
 * Returns the current state of persistent module settings.
 *
 * @return a value among YModule.PERSISTENTSETTINGS_LOADED, YModule.PERSISTENTSETTINGS_SAVED and
 * YModule.PERSISTENTSETTINGS_MODIFIED corresponding to the current state of persistent module settings
 *
 * On failure, throws an exception or returns YModule.PERSISTENTSETTINGS_INVALID.
 */
-(Y_PERSISTENTSETTINGS_enum) get_persistentSettings
{
    Y_PERSISTENTSETTINGS_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_PERSISTENTSETTINGS_INVALID;
        }
    }
    res = _persistentSettings;
    return res;
}


-(Y_PERSISTENTSETTINGS_enum) persistentSettings
{
    return [self get_persistentSettings];
}

-(int) set_persistentSettings:(Y_PERSISTENTSETTINGS_enum) newval
{
    return [self setPersistentSettings:newval];
}
-(int) setPersistentSettings:(Y_PERSISTENTSETTINGS_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"persistentSettings" :rest_val];
}
/**
 * Returns the luminosity of the  module informative LEDs (from 0 to 100).
 *
 * @return an integer corresponding to the luminosity of the  module informative LEDs (from 0 to 100)
 *
 * On failure, throws an exception or returns YModule.LUMINOSITY_INVALID.
 */
-(int) get_luminosity
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LUMINOSITY_INVALID;
        }
    }
    res = _luminosity;
    return res;
}


-(int) luminosity
{
    return [self get_luminosity];
}

/**
 * Changes the luminosity of the module informative leds. The parameter is a
 * value between 0 and 100.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the luminosity of the module informative leds
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"luminosity" :rest_val];
}
/**
 * Returns the state of the localization beacon.
 *
 * @return either YModule.BEACON_OFF or YModule.BEACON_ON, according to the state of the localization beacon
 *
 * On failure, throws an exception or returns YModule.BEACON_INVALID.
 */
-(Y_BEACON_enum) get_beacon
{
    Y_BEACON_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BEACON_INVALID;
        }
    }
    res = _beacon;
    return res;
}


-(Y_BEACON_enum) beacon
{
    return [self get_beacon];
}

/**
 * Turns on or off the module localization beacon.
 *
 * @param newval : either YModule.BEACON_OFF or YModule.BEACON_ON
 *
 * @return YAPI.SUCCESS if the call succeeds.
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
 * On failure, throws an exception or returns YModule.UPTIME_INVALID.
 */
-(s64) get_upTime
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_UPTIME_INVALID;
        }
    }
    res = _upTime;
    return res;
}


-(s64) upTime
{
    return [self get_upTime];
}
/**
 * Returns the current consumed by the module on the USB bus, in milli-amps.
 *
 * @return an integer corresponding to the current consumed by the module on the USB bus, in milli-amps
 *
 * On failure, throws an exception or returns YModule.USBCURRENT_INVALID.
 */
-(int) get_usbCurrent
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_USBCURRENT_INVALID;
        }
    }
    res = _usbCurrent;
    return res;
}


-(int) usbCurrent
{
    return [self get_usbCurrent];
}
/**
 * Returns the remaining number of seconds before the module restarts, or zero when no
 * reboot has been scheduled.
 *
 * @return an integer corresponding to the remaining number of seconds before the module restarts, or zero when no
 *         reboot has been scheduled
 *
 * On failure, throws an exception or returns YModule.REBOOTCOUNTDOWN_INVALID.
 */
-(int) get_rebootCountdown
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REBOOTCOUNTDOWN_INVALID;
        }
    }
    res = _rebootCountdown;
    return res;
}


-(int) rebootCountdown
{
    return [self get_rebootCountdown];
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
 * Returns the value previously stored in this attribute.
 * On startup and after a device reboot, the value is always reset to zero.
 *
 * @return an integer corresponding to the value previously stored in this attribute
 *
 * On failure, throws an exception or returns YModule.USERVAR_INVALID.
 */
-(int) get_userVar
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_USERVAR_INVALID;
        }
    }
    res = _userVar;
    return res;
}


-(int) userVar
{
    return [self get_userVar];
}

/**
 * Stores a 32 bit value in the device RAM. This attribute is at programmer disposal,
 * should he need to store a state variable.
 * On startup and after a device reboot, the value is always reset to zero.
 *
 * @param newval : an integer
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_userVar:(int) newval
{
    return [self setUserVar:newval];
}
-(int) setUserVar:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"userVar" :rest_val];
}
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
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string containing either the serial number or
 *         the logical name of the desired module
 *
 * @return a YModule object allowing you to drive the module
 *         or get additional information on the module.
 */
+(YModule*) FindModule:(NSString*)func
{
    YModule* obj;
    NSString* cleanHwId;
    int modpos;
    cleanHwId = func;
    modpos = _ystrpos(func, @".module");
    if (modpos != ((int)[(func) length] - 7)) {
        cleanHwId = [NSString stringWithFormat:@"%@%@", func, @".module"];
    }
    obj = (YModule*) [YFunction _FindFromCache:@"Module" :cleanHwId];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YModule alloc] initWith:cleanHwId]);
        [YFunction _AddToCache:@"Module" : cleanHwId :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YModuleValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackModule = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackModule != NULL) {
        _valueCallbackModule(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(NSString*) get_productNameAndRevision
{
    NSString* prodname;
    int prodrel;
    NSString* fullname;

    prodname = [self get_productName];
    prodrel = [self get_productRelease];
    if (prodrel > 1) {
        fullname = [NSString stringWithFormat:@"%@ rev. %c", prodname,64 + prodrel];
    } else {
        fullname = prodname;
    }
    return fullname;
}

/**
 * Saves current settings in the nonvolatile memory of the module.
 * Warning: the number of allowed save operations during a module life is
 * limited (about 100000 cycles). Do not call this function within a loop.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) saveToFlash
{
    return [self set_persistentSettings:Y_PERSISTENTSETTINGS_SAVED];
}

/**
 * Reloads the settings stored in the nonvolatile memory, as
 * when the module is powered on.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) revertFromFlash
{
    return [self set_persistentSettings:Y_PERSISTENTSETTINGS_LOADED];
}

/**
 * Schedules a simple module reboot after the given number of seconds.
 *
 * @param secBeforeReboot : number of seconds before rebooting
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) reboot:(int)secBeforeReboot
{
    return [self set_rebootCountdown:secBeforeReboot];
}

/**
 * Schedules a module reboot into special firmware update mode.
 *
 * @param secBeforeReboot : number of seconds before rebooting
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) triggerFirmwareUpdate:(int)secBeforeReboot
{
    return [self set_rebootCountdown:-secBeforeReboot];
}

-(void) _startStopDevLog:(NSString*)serial :(bool)start
{
    int i_start;
    if (start) {
        i_start = 1;
    } else {
        i_start = 0;
    }

    yapiStartStopDeviceLogCallback(STR_oc2y(serial), i_start);
}

/**
 * Registers a device log callback function. This callback will be called each time
 * that a module sends a new log message. Mostly useful to debug a Yoctopuce module.
 *
 * @param callback : the callback function to call, or a nil pointer. The callback function should take two
 *         arguments: the module object that emitted the log message, and the character string containing the log.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) registerLogCallback:(YModuleLogCallback _Nullable)callback
{
    NSString* serial;

    serial = [self get_serialNumber];
    if ([serial isEqualToString:YAPI_INVALID_STRING]) {
        return YAPI_DEVICE_NOT_FOUND;
    }
    _logCallback = callback;
    [self _startStopDevLog:serial :callback != NULL];
    return 0;
}

-(YModuleLogCallback) get_logCallback
{
    return _logCallback;
}

/**
 * Register a callback function, to be called when a persistent settings in
 * a device configuration has been changed (e.g. change of unit, etc).
 *
 * @param callback : a procedure taking a YModule parameter, or nil
 *         to unregister a previously registered  callback.
 */
-(int) registerConfigChangeCallback:(YModuleConfigChangeCallback _Nullable)callback
{
    if (callback != NULL) {
        [YModule _updateModuleCallbackList:self :YES];
    } else {
        [YModule _updateModuleCallbackList:self :NO];
    }
    _confChangeCallback = callback;
    return 0;
}

-(int) _invokeConfigChangeCallback
{
    if (_confChangeCallback != NULL) {
        _confChangeCallback(self);
    }
    return 0;
}

/**
 * Register a callback function, to be called when the localization beacon of the module
 * has been changed. The callback function should take two arguments: the YModule object of
 * which the beacon has changed, and an integer describing the new beacon state.
 *
 * @param callback : The callback function to call, or nil to unregister a
 *         previously registered callback.
 */
-(int) registerBeaconCallback:(YModuleBeaconCallback _Nullable)callback
{
    if (callback != NULL) {
        [YModule _updateModuleCallbackList:self :YES];
    } else {
        [YModule _updateModuleCallbackList:self :NO];
    }
    _beaconCallback = callback;
    return 0;
}

-(int) _invokeBeaconCallback:(int)beaconState
{
    if (_beaconCallback != NULL) {
        _beaconCallback(self, beaconState);
    }
    return 0;
}

/**
 * Triggers a configuration change callback, to check if they are supported or not.
 */
-(int) triggerConfigChangeCallback
{
    [self _setAttr:@"persistentSettings" :@"2"];
    return 0;
}

/**
 * Tests whether the byn file is valid for this module. This method is useful to test if the module
 * needs to be updated.
 * It is possible to pass a directory as argument instead of a file. In this case, this method returns
 * the path of the most recent
 * appropriate .byn file. If the parameter onlynew is true, the function discards firmwares that are older or
 * equal to the installed firmware.
 *
 * @param path : the path of a byn file or a directory that contains byn files
 * @param onlynew : returns only files that are strictly newer
 *
 * @return the path of the byn file to use or a empty string if no byn files matches the requirement
 *
 * On failure, throws an exception or returns a string that start with "error:".
 */
-(NSString*) checkFirmware:(NSString*)path :(bool)onlynew
{
    NSString* serial;
    int release;
    NSString* tmp_res;
    if (onlynew) {
        release = [[self get_firmwareRelease] intValue];
    } else {
        release = 0;
    }
    //may throw an exception
    serial = [self get_serialNumber];
    tmp_res = [YFirmwareUpdate CheckFirmware:serial : path :release];
    if (_ystrpos(tmp_res, @"error:") == 0) {
        [self _throw:YAPI_INVALID_ARGUMENT :tmp_res];
    }
    return tmp_res;
}

/**
 * Prepares a firmware update of the module. This method returns a YFirmwareUpdate object which
 * handles the firmware update process.
 *
 * @param path : the path of the .byn file to use.
 * @param force : true to force the firmware update even if some prerequisites appear not to be met
 *
 * @return a YFirmwareUpdate object or nil on error.
 */
-(YFirmwareUpdate*) updateFirmwareEx:(NSString*)path :(bool)force
{
    NSString* serial;
    NSMutableData* settings;

    serial = [self get_serialNumber];
    settings = [self get_allSettings];
    if ((int)[settings length] == 0) {
        [self _throw:YAPI_IO_ERROR :@"Unable to get device settings"];
        settings = [NSMutableData dataWithData:[@"error:Unable to get device settings" dataUsingEncoding:NSISOLatin1StringEncoding]];
    }
    return ARC_sendAutorelease([[YFirmwareUpdate alloc] initWith:serial :path :settings :force]);
}

/**
 * Prepares a firmware update of the module. This method returns a YFirmwareUpdate object which
 * handles the firmware update process.
 *
 * @param path : the path of the .byn file to use.
 *
 * @return a YFirmwareUpdate object or nil on error.
 */
-(YFirmwareUpdate*) updateFirmware:(NSString*)path
{
    return [self updateFirmwareEx:path :NO];
}

/**
 * Returns all the settings and uploaded files of the module. Useful to backup all the
 * logical names, calibrations parameters, and uploaded files of a device.
 *
 * @return a binary buffer with all the settings.
 *
 * On failure, throws an exception or returns an binary object of size 0.
 */
-(NSMutableData*) get_allSettings
{
    NSMutableData* settings;
    NSMutableData* json;
    NSMutableData* res;
    NSString* sep;
    NSString* name;
    NSString* item;
    NSString* t_type;
    NSString* id;
    NSString* url;
    NSString* file_data;
    NSMutableData* file_data_bin;
    NSMutableData* temp_data_bin;
    NSString* ext_settings;
    NSMutableArray* filelist = [NSMutableArray array];
    NSMutableArray* templist = [NSMutableArray array];

    settings = [self _download:@"api.json"];
    if ((int)[settings length] == 0) {
        return settings;
    }
    ext_settings = @", \"extras\":[";
    templist = [self get_functionIds:@"Temperature"];
    sep = @"";
    for (NSString* _each  in  templist) {
        if ([[self get_firmwareRelease] intValue] > 9000) {
            url = [NSString stringWithFormat:@"api/%@/sensorType",_each];
            t_type = ARC_sendAutorelease([[NSString alloc] initWithData:[self _download:url] encoding:NSISOLatin1StringEncoding]);
            if ([t_type isEqualToString:@"RES_NTC"] || [t_type isEqualToString:@"RES_LINEAR"]) {
                id = [_each substringWithRange:NSMakeRange( 11, (int)[(_each) length] - 11)];
                if ([id isEqualToString:@""]) {
                    id = @"1";
                }
                temp_data_bin = [self _download:[NSString stringWithFormat:@"extra.json?page=%@",id]];
                if ((int)[temp_data_bin length] > 0) {
                    item = [NSString stringWithFormat:@"%@{\"fid\":\"%@\", \"json\":%@}\n", sep, _each,ARC_sendAutorelease([[NSString alloc] initWithData:temp_data_bin encoding:NSISOLatin1StringEncoding])];
                    ext_settings = [NSString stringWithFormat:@"%@%@", ext_settings, item];
                    sep = @",";
                }
            }
        }
    }
    ext_settings = [NSString stringWithFormat:@"%@%@", ext_settings, @"],\n\"files\":["];
    if ([self hasFunction:@"files"]) {
        json = [self _download:@"files.json?a=dir&f="];
        if ((int)[json length] == 0) {
            return json;
        }
        filelist = [self _json_get_array:json];
        sep = @"";
        for (NSString* _each  in  filelist) {
            name = [self _json_get_key:[NSMutableData dataWithData:[_each dataUsingEncoding:NSISOLatin1StringEncoding]] :@"name"];
            if (((int)[(name) length] > 0) && !([name isEqualToString:@"startupConf.json"])) {
                file_data_bin = [self _download:[self _escapeAttr:name]];
                file_data = [YAPI _bin2HexStr:file_data_bin];
                item = [NSString stringWithFormat:@"%@{\"name\":\"%@\", \"data\":\"%@\"}\n", sep, name,file_data];
                ext_settings = [NSString stringWithFormat:@"%@%@", ext_settings, item];
                sep = @",";
            }
        }
    }
    res = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@%@%@%@", @"{ \"api\":", ARC_sendAutorelease([[NSString alloc] initWithData:settings encoding:NSISOLatin1StringEncoding]), ext_settings, @"]}"] dataUsingEncoding:NSISOLatin1StringEncoding]];
    return res;
}

-(int) loadThermistorExtra:(NSString*)funcId :(NSString*)jsonExtra
{
    NSMutableArray* values = [NSMutableArray array];
    NSString* url;
    NSString* curr;
    NSString* currTemp;
    int ofs;
    int size;
    url = [NSString stringWithFormat:@"%@%@%@", @"api/", funcId, @".json?command=Z"];

    [self _download:url];
    // add records in growing resistance value
    values = [self _json_get_array:[NSMutableData dataWithData:[jsonExtra dataUsingEncoding:NSISOLatin1StringEncoding]]];
    ofs = 0;
    size = (int)[values count];
    while (ofs + 1 < size) {
        curr = [values objectAtIndex:ofs];
        currTemp = [values objectAtIndex:ofs + 1];
        url = [NSString stringWithFormat:@"api/%@.json?command=m%@:%@", funcId, curr,currTemp];
        [self _download:url];
        ofs = ofs + 2;
    }
    return YAPI_SUCCESS;
}

-(int) set_extraSettings:(NSString*)jsonExtra
{
    NSMutableArray* extras = [NSMutableArray array];
    NSString* functionId;
    NSString* data;
    extras = [self _json_get_array:[NSMutableData dataWithData:[jsonExtra dataUsingEncoding:NSISOLatin1StringEncoding]]];
    for (NSString* _each  in  extras) {
        functionId = [self _get_json_path:_each :@"fid"];
        functionId = [self _decode_json_string:functionId];
        data = [self _get_json_path:_each :@"json"];
        if ([self hasFunction:functionId]) {
            [self loadThermistorExtra:functionId :data];
        }
    }
    return YAPI_SUCCESS;
}

/**
 * Restores all the settings and uploaded files to the module.
 * This method is useful to restore all the logical names and calibrations parameters,
 * uploaded files etc. of a device from a backup.
 * Remember to call the saveToFlash() method of the module if the
 * modifications must be kept.
 *
 * @param settings : a binary buffer with all the settings.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_allSettingsAndFiles:(NSData*)settings
{
    NSMutableData* down;
    NSString* json;
    NSString* json_api;
    NSString* json_files;
    NSString* json_extra;
    int fuperror;
    int globalres;
    fuperror = 0;
    json = ARC_sendAutorelease([[NSString alloc] initWithData:settings encoding:NSISOLatin1StringEncoding]);
    json_api = [self _get_json_path:json :@"api"];
    if ([json_api isEqualToString:@""]) {
        return [self set_allSettings:settings];
    }
    json_extra = [self _get_json_path:json :@"extras"];
    if (!([json_extra isEqualToString:@""])) {
        [self set_extraSettings:json_extra];
    }
    [self set_allSettings:[NSMutableData dataWithData:[json_api dataUsingEncoding:NSISOLatin1StringEncoding]]];
    if ([self hasFunction:@"files"]) {
        NSMutableArray* files = [NSMutableArray array];
        NSString* res;
        NSString* name;
        NSString* data;
        down = [self _download:@"files.json?a=format"];
        res = [self _get_json_path:ARC_sendAutorelease([[NSString alloc] initWithData:down encoding:NSISOLatin1StringEncoding]) :@"res"];
        res = [self _decode_json_string:res];
        if (!([res isEqualToString:@"ok"])) {[self _throw: YAPI_IO_ERROR: @"format failed"]; return YAPI_IO_ERROR;}
        json_files = [self _get_json_path:json :@"files"];
        files = [self _json_get_array:[NSMutableData dataWithData:[json_files dataUsingEncoding:NSISOLatin1StringEncoding]]];
        for (NSString* _each  in  files) {
            name = [self _get_json_path:_each :@"name"];
            name = [self _decode_json_string:name];
            data = [self _get_json_path:_each :@"data"];
            data = [self _decode_json_string:data];
            if ([name isEqualToString:@""]) {
                fuperror = fuperror + 1;
            } else {
                [self _upload:name :[YAPI _hexStr2Bin:data]];
            }
        }
    }
    // Apply settings a second time for file-dependent settings and dynamic sensor nodes
    globalres = [self set_allSettings:[NSMutableData dataWithData:[json_api dataUsingEncoding:NSISOLatin1StringEncoding]]];
    if (!(fuperror == 0)) {[self _throw: YAPI_IO_ERROR: @"Error during file upload"]; return YAPI_IO_ERROR;}
    return globalres;
}

/**
 * Tests if the device includes a specific function. This method takes a function identifier
 * and returns a boolean.
 *
 * @param funcId : the requested function identifier
 *
 * @return true if the device has the function identifier
 */
-(bool) hasFunction:(NSString*)funcId
{
    int count;
    int i;
    NSString* fid;

    count = [self functionCount];
    i = 0;
    while (i < count) {
        fid = [self functionId:i];
        if ([fid isEqualToString:funcId]) {
            return YES;
        }
        i = i + 1;
    }
    return NO;
}

/**
 * Retrieve all hardware identifier that match the type passed in argument.
 *
 * @param funType : The type of function (Relay, LightSensor, Voltage,...)
 *
 * @return an array of strings.
 */
-(NSMutableArray*) get_functionIds:(NSString*)funType
{
    int count;
    int i;
    NSString* ftype;
    NSMutableArray* res = [NSMutableArray array];

    count = [self functionCount];
    i = 0;
    while (i < count) {
        ftype = [self functionType:i];
        if ([ftype isEqualToString:funType]) {
            [res addObject:[self functionId:i]];
        } else {
            ftype = [self functionBaseType:i];
            if ([ftype isEqualToString:funType]) {
                [res addObject:[self functionId:i]];
            }
        }
        i = i + 1;
    }
    return res;
}

-(NSMutableData*) _flattenJsonStruct:(NSData*)jsoncomplex
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char smallbuff[1024];
    char *bigbuff;
    int buffsize;
    int fullsize;
    int res;
    NSString* jsonflat;
    NSString* jsoncomplexstr;
    fullsize = 0;
    jsoncomplexstr = ARC_sendAutorelease([[NSString alloc] initWithData:jsoncomplex encoding:NSISOLatin1StringEncoding]);
    res = yapiGetAllJsonKeys(STR_oc2y(jsoncomplexstr), smallbuff, 1024, &fullsize, errmsg);
    if (res < 0) {
        [self _throw:YAPI_INVALID_ARGUMENT :STR_y2oc(errmsg)];
        jsonflat = [NSString stringWithFormat:@"%@%@", @"error:", STR_y2oc(errmsg)];
        return [NSMutableData dataWithData:[jsonflat dataUsingEncoding:NSISOLatin1StringEncoding]];
    }
    if (fullsize <= 1024) {
        jsonflat = ARC_sendAutorelease([[NSString alloc] initWithBytes:smallbuff length:fullsize encoding:NSUTF8StringEncoding]);
    } else {
        fullsize = fullsize * 2;
        buffsize = fullsize;
        bigbuff = (char *)malloc(buffsize);
        res = yapiGetAllJsonKeys(STR_oc2y(jsoncomplexstr), bigbuff, buffsize, &fullsize, errmsg);
        if (res < 0) {
            [self _throw:YAPI_INVALID_ARGUMENT :STR_y2oc(errmsg)];
            jsonflat = [NSString stringWithFormat:@"%@%@", @"error:", STR_y2oc(errmsg)];
        } else {
            jsonflat = ARC_sendAutorelease([[NSString alloc] initWithBytes:bigbuff length:fullsize encoding:NSUTF8StringEncoding]);
        }
        free(bigbuff);
    }
    return [NSMutableData dataWithData:[jsonflat dataUsingEncoding:NSISOLatin1StringEncoding]];
}

-(int) calibVersion:(NSString*)cparams
{
    if ([cparams isEqualToString:@"0,"]) {
        return 3;
    }
    if (_ystrpos(cparams, @",") >= 0) {
        if (_ystrpos(cparams, @" ") > 0) {
            return 3;
        } else {
            return 1;
        }
    }
    if ([cparams isEqualToString:@""] || [cparams isEqualToString:@"0"]) {
        return 1;
    }
    if (((int)[(cparams) length] < 2) || (_ystrpos(cparams, @".") >= 0)) {
        return 0;
    } else {
        return 2;
    }
}

-(int) calibScale:(NSString*)unit_name :(NSString*)sensorType
{
    if ([unit_name isEqualToString:@"g"] || [unit_name isEqualToString:@"gauss"] || [unit_name isEqualToString:@"W"]) {
        return 1000;
    }
    if ([unit_name isEqualToString:@"C"]) {
        if ([sensorType isEqualToString:@""]) {
            return 16;
        }
        if ([sensorType intValue] < 8) {
            return 16;
        } else {
            return 100;
        }
    }
    if ([unit_name isEqualToString:@"m"] || [unit_name isEqualToString:@"deg"]) {
        return 10;
    }
    return 1;
}

-(int) calibOffset:(NSString*)unit_name
{
    if ([unit_name isEqualToString:@"% RH"] || [unit_name isEqualToString:@"mbar"] || [unit_name isEqualToString:@"lx"]) {
        return 0;
    }
    return 32767;
}

-(NSString*) calibConvert:(NSString*)param :(NSString*)currentFuncValue :(NSString*)unit_name :(NSString*)sensorType
{
    int paramVer;
    int funVer;
    int funScale;
    int funOffset;
    int paramScale;
    int paramOffset;
    NSMutableArray* words = [NSMutableArray array];
    NSMutableArray* words_str = [NSMutableArray array];
    NSMutableArray* calibData = [NSMutableArray array];
    NSMutableArray* iCalib = [NSMutableArray array];
    int calibType;
    int i;
    int maxSize;
    double ratio;
    int nPoints;
    double wordVal;
    // Initial guess for parameter encoding
    paramVer = [self calibVersion:param];
    funVer = [self calibVersion:currentFuncValue];
    funScale = [self calibScale:unit_name :sensorType];
    funOffset = [self calibOffset:unit_name];
    paramScale = funScale;
    paramOffset = funOffset;
    if (funVer < 3) {
        // Read the effective device scale if available
        if (funVer == 2) {
            words = [YAPI _decodeWords:currentFuncValue];
            if (([[words objectAtIndex:0] intValue] == 1366) && ([[words objectAtIndex:1] intValue] == 12500)) {
                // Yocto-3D RefFrame used a special encoding
                funScale = 1;
                funOffset = 0;
            } else {
                funScale = [[words objectAtIndex:1] intValue];
                funOffset = [[words objectAtIndex:0] intValue];
            }
        } else {
            if (funVer == 1) {
                if ([currentFuncValue isEqualToString:@""] || ([currentFuncValue intValue] > 10)) {
                    funScale = 0;
                }
            }
        }
    }
    [calibData removeAllObjects];
    calibType = 0;
    if (paramVer < 3) {
        // Handle old 16 bit parameters formats
        if (paramVer == 2) {
            words = [YAPI _decodeWords:param];
            if (([[words objectAtIndex:0] intValue] == 1366) && ([[words objectAtIndex:1] intValue] == 12500)) {
                // Yocto-3D RefFrame used a special encoding
                paramScale = 1;
                paramOffset = 0;
            } else {
                paramScale = [[words objectAtIndex:1] intValue];
                paramOffset = [[words objectAtIndex:0] intValue];
            }
            if (((int)[words count] >= 3) && ([[words objectAtIndex:2] intValue] > 0)) {
                maxSize = 3 + 2 * (([[words objectAtIndex:2] intValue]) % (10));
                if (maxSize > (int)[words count]) {
                    maxSize = (int)[words count];
                }
                i = 3;
                while (i < maxSize) {
                    [calibData addObject:[NSNumber numberWithDouble:(double) [[words objectAtIndex:i] intValue]]];
                    i = i + 1;
                }
            }
        } else {
            if (paramVer == 1) {
                words_str = [NSMutableArray arrayWithArray:[param componentsSeparatedByString:@","]];
                for (NSString* _each  in words_str) {
                    [words addObject:[NSNumber numberWithLong:[_each intValue]]];
                }
                if ([param isEqualToString:@""] || ([[words objectAtIndex:0] intValue] > 10)) {
                    paramScale = 0;
                }
                if (((int)[words count] > 0) && ([[words objectAtIndex:0] intValue] > 0)) {
                    maxSize = 1 + 2 * (([[words objectAtIndex:0] intValue]) % (10));
                    if (maxSize > (int)[words count]) {
                        maxSize = (int)[words count];
                    }
                    i = 1;
                    while (i < maxSize) {
                        [calibData addObject:[NSNumber numberWithDouble:(double) [[words objectAtIndex:i] intValue]]];
                        i = i + 1;
                    }
                }
            } else {
                if (paramVer == 0) {
                    ratio = [param doubleValue];
                    if (ratio > 0) {
                        [calibData addObject:[NSNumber numberWithDouble:0.0]];
                        [calibData addObject:[NSNumber numberWithDouble:0.0]];
                        [calibData addObject:[NSNumber numberWithDouble:floor(65535 / ratio+0.5)]];
                        [calibData addObject:[NSNumber numberWithDouble:65535.0]];
                    }
                }
            }
        }
        i = 0;
        while (i < (int)[calibData count]) {
            if (paramScale > 0) {
                // scalar decoding
                [calibData replaceObjectAtIndex: i withObject:[NSNumber numberWithDouble:([[calibData objectAtIndex:i] doubleValue] - paramOffset) / paramScale]];
            } else {
                // floating-point decoding
                [calibData replaceObjectAtIndex: i withObject:[NSNumber numberWithDouble:[YAPI _decimalToDouble:(int) floor([[calibData objectAtIndex:i] doubleValue]+0.5)]]];
            }
            i = i + 1;
        }
    } else {
        // Handle latest 32bit parameter format
        iCalib = [YAPI _decodeFloats:param];
        calibType = (int) floor([[iCalib objectAtIndex:0] doubleValue] / 1000.0+0.5);
        if (calibType >= 30) {
            calibType = calibType - 30;
        }
        i = 1;
        while (i < (int)[iCalib count]) {
            [calibData addObject:[NSNumber numberWithDouble:[[iCalib objectAtIndex:i] doubleValue] / 1000.0]];
            i = i + 1;
        }
    }
    if (funVer >= 3) {
        // Encode parameters in new format
        if ((int)[calibData count] == 0) {
            param = @"0,";
        } else {
            param = [NSString stringWithFormat:@"%d",30 + calibType];
            i = 0;
            while (i < (int)[calibData count]) {
                if (((i) & (1)) > 0) {
                    param = [NSString stringWithFormat:@"%@%@", param, @":"];
                } else {
                    param = [NSString stringWithFormat:@"%@%@", param, @" "];
                }
                param = [NSString stringWithFormat:@"%@%@", param, [NSString stringWithFormat:@"%d",(int) floor([[calibData objectAtIndex:i] doubleValue] * 1000.0 / 1000.0+0.5)]];
                i = i + 1;
            }
            param = [NSString stringWithFormat:@"%@%@", param, @","];
        }
    } else {
        if (funVer >= 1) {
            // Encode parameters for older devices
            nPoints = (((int)[calibData count]) / (2));
            param = [NSString stringWithFormat:@"%d",nPoints];
            i = 0;
            while (i < 2 * nPoints) {
                if (funScale == 0) {
                    wordVal = [YAPI _doubleToDecimal:(int) floor([[calibData objectAtIndex:i] doubleValue]+0.5)];
                } else {
                    wordVal = [[calibData objectAtIndex:i] doubleValue] * funScale + funOffset;
                }
                param = [NSString stringWithFormat:@"%@%@%@", param, @",", [NSString stringWithFormat:@"%f",floor(wordVal+0.5)]];
                i = i + 1;
            }
        } else {
            // Initial V0 encoding used for old Yocto-Light
            if ((int)[calibData count] == 4) {
                param = [NSString stringWithFormat:@"%f",floor(1000 * ([[calibData objectAtIndex:3] doubleValue] - [[calibData objectAtIndex:1] doubleValue]) / [[calibData objectAtIndex:2] doubleValue] - [[calibData objectAtIndex:0] doubleValue]+0.5)];
            }
        }
    }
    return param;
}

-(int) _tryExec:(NSString*)url
{
    int res;
    int done;
    res = YAPI_SUCCESS;
    done = 1;
    @try {
        [self _download:url];
    }
    @catch (NSException *e) {
        done = 0;
    }
    if (done == 0) {
        // retry silently after a short wait
        @try {
            [YAPI Sleep:500 :NULL];
            [self _download:url];
        }
        @catch (NSException *e) {
            // second failure, return error code
            res = [self get_errorType];
        }
    }
    return res;
}

/**
 * Restores all the settings of the device. Useful to restore all the logical names and calibrations parameters
 * of a module from a backup.Remember to call the saveToFlash() method of the module if the
 * modifications must be kept.
 *
 * @param settings : a binary buffer with all the settings.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_allSettings:(NSData*)settings
{
    NSMutableArray* restoreLast = [NSMutableArray array];
    NSMutableData* old_json_flat;
    NSMutableArray* old_dslist = [NSMutableArray array];
    NSMutableArray* old_jpath = [NSMutableArray array];
    NSMutableArray* old_jpath_len = [NSMutableArray array];
    NSMutableArray* old_val_arr = [NSMutableArray array];
    NSMutableData* actualSettings;
    NSMutableArray* new_dslist = [NSMutableArray array];
    NSMutableArray* new_jpath = [NSMutableArray array];
    NSMutableArray* new_jpath_len = [NSMutableArray array];
    NSMutableArray* new_val_arr = [NSMutableArray array];
    int cpos;
    int eqpos;
    int leng;
    int i;
    int j;
    int subres;
    int res;
    NSString* njpath;
    NSString* jpath;
    NSString* fun;
    NSString* attr;
    NSString* value;
    NSString* url;
    NSString* tmp;
    NSString* new_calib;
    NSString* sensorType;
    NSString* unit_name;
    NSString* newval;
    NSString* oldval;
    NSString* old_calib;
    NSString* each_str;
    bool do_update;
    bool found;
    res = YAPI_SUCCESS;
    tmp = ARC_sendAutorelease([[NSString alloc] initWithData:settings encoding:NSISOLatin1StringEncoding]);
    tmp = [self _get_json_path:tmp :@"api"];
    if (!([tmp isEqualToString:@""])) {
        settings = [NSMutableData dataWithData:[tmp dataUsingEncoding:NSISOLatin1StringEncoding]];
    }
    oldval = @"";
    newval = @"";
    old_json_flat = [self _flattenJsonStruct:settings];
    old_dslist = [self _json_get_array:old_json_flat];
    for (NSString* _each  in old_dslist) {
        each_str = [self _json_get_string:[NSMutableData dataWithData:[_each dataUsingEncoding:NSISOLatin1StringEncoding]]];
        // split json path and attr
        leng = (int)[(each_str) length];
        eqpos = _ystrpos(each_str, @"=");
        if ((eqpos < 0) || (leng == 0)) {
            [self _throw:YAPI_INVALID_ARGUMENT :@"Invalid settings"];
            return YAPI_INVALID_ARGUMENT;
        }
        jpath = [each_str substringWithRange:NSMakeRange( 0, eqpos)];
        eqpos = eqpos + 1;
        value = [each_str substringWithRange:NSMakeRange( eqpos, leng - eqpos)];
        [old_jpath addObject:jpath];
        [old_jpath_len addObject:[NSNumber numberWithLong:(int)[(jpath) length]]];
        [old_val_arr addObject:value];
    }

    @try {
        actualSettings = [self _download:@"api.json"];
    }
    @catch (NSException *e) {
        // retry silently after a short wait
        [YAPI Sleep:500 :NULL];
        actualSettings = [self _download:@"api.json"];
    }
    actualSettings = [self _flattenJsonStruct:actualSettings];
    new_dslist = [self _json_get_array:actualSettings];
    for (NSString* _each  in new_dslist) {
        // remove quotes
        each_str = [self _json_get_string:[NSMutableData dataWithData:[_each dataUsingEncoding:NSISOLatin1StringEncoding]]];
        // split json path and attr
        leng = (int)[(each_str) length];
        eqpos = _ystrpos(each_str, @"=");
        if ((eqpos < 0) || (leng == 0)) {
            [self _throw:YAPI_INVALID_ARGUMENT :@"Invalid settings"];
            return YAPI_INVALID_ARGUMENT;
        }
        jpath = [each_str substringWithRange:NSMakeRange( 0, eqpos)];
        eqpos = eqpos + 1;
        value = [each_str substringWithRange:NSMakeRange( eqpos, leng - eqpos)];
        [new_jpath addObject:jpath];
        [new_jpath_len addObject:[NSNumber numberWithLong:(int)[(jpath) length]]];
        [new_val_arr addObject:value];
    }
    i = 0;
    while (i < (int)[new_jpath count]) {
        njpath = [new_jpath objectAtIndex:i];
        leng = (int)[(njpath) length];
        cpos = _ystrpos(njpath, @"/");
        if ((cpos < 0) || (leng == 0)) {
            continue;
        }
        fun = [njpath substringWithRange:NSMakeRange( 0, cpos)];
        cpos = cpos + 1;
        attr = [njpath substringWithRange:NSMakeRange( cpos, leng - cpos)];
        do_update = YES;
        if ([fun isEqualToString:@"services"]) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"firmwareRelease"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"usbCurrent"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"upTime"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"persistentSettings"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"adminPassword"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"userPassword"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"rebootCountdown"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"advertisedValue"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"poeCurrent"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"readiness"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"ipAddress"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"subnetMask"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"router"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"linkQuality"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"ssid"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"channel"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"security"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"message"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"signalValue"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"currentValue"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"currentRawValue"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"currentRunIndex"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"pulseTimer"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"lastTimePressed"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"lastTimeReleased"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"filesCount"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"freeSpace"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"timeUTC"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"rtcTime"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"unixTime"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"dateTime"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"rawValue"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"lastMsg"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"delayedPulseTimer"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"rxCount"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"txCount"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"msgCount"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"rxMsgCount"])) {
            do_update = NO;
        }
        if ((do_update) && ([attr isEqualToString:@"txMsgCount"])) {
            do_update = NO;
        }
        if (do_update) {
            do_update = NO;
            newval = [new_val_arr objectAtIndex:i];
            j = 0;
            found = NO;
            while ((j < (int)[old_jpath count]) && !(found)) {
                if (([[new_jpath_len objectAtIndex:i] intValue] == [[old_jpath_len objectAtIndex:j] intValue]) && ([[new_jpath objectAtIndex:i] isEqualToString:[old_jpath objectAtIndex:j]])) {
                    found = YES;
                    oldval = [old_val_arr objectAtIndex:j];
                    if (!([newval isEqualToString:oldval])) {
                        do_update = YES;
                    }
                }
                j = j + 1;
            }
        }
        if (do_update) {
            if ([attr isEqualToString:@"calibrationParam"]) {
                old_calib = @"";
                unit_name = @"";
                sensorType = @"";
                new_calib = newval;
                j = 0;
                found = NO;
                while ((j < (int)[old_jpath count]) && !(found)) {
                    if (([[new_jpath_len objectAtIndex:i] intValue] == [[old_jpath_len objectAtIndex:j] intValue]) && ([[new_jpath objectAtIndex:i] isEqualToString:[old_jpath objectAtIndex:j]])) {
                        found = YES;
                        old_calib = [old_val_arr objectAtIndex:j];
                    }
                    j = j + 1;
                }
                tmp = [NSString stringWithFormat:@"%@%@", fun, @"/unit"];
                j = 0;
                found = NO;
                while ((j < (int)[new_jpath count]) && !(found)) {
                    if ([tmp isEqualToString:[new_jpath objectAtIndex:j]]) {
                        found = YES;
                        unit_name = [new_val_arr objectAtIndex:j];
                    }
                    j = j + 1;
                }
                tmp = [NSString stringWithFormat:@"%@%@", fun, @"/sensorType"];
                j = 0;
                found = NO;
                while ((j < (int)[new_jpath count]) && !(found)) {
                    if ([tmp isEqualToString:[new_jpath objectAtIndex:j]]) {
                        found = YES;
                        sensorType = [new_val_arr objectAtIndex:j];
                    }
                    j = j + 1;
                }
                newval = [self calibConvert:old_calib : [new_val_arr objectAtIndex:i] : unit_name :sensorType];
                url = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"api/", fun, @".json?", attr, @"=", [self _escapeAttr:newval]];
                subres = [self _tryExec:url];
                if ((res == YAPI_SUCCESS) && (subres != YAPI_SUCCESS)) {
                    res = subres;
                }
            } else {
                url = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"api/", fun, @".json?", attr, @"=", [self _escapeAttr:oldval]];
                if ([attr isEqualToString:@"resolution"]) {
                    [restoreLast addObject:url];
                } else {
                    subres = [self _tryExec:url];
                    if ((res == YAPI_SUCCESS) && (subres != YAPI_SUCCESS)) {
                        res = subres;
                    }
                }
            }
        }
        i = i + 1;
    }
    for (NSString* _each  in restoreLast) {
        subres = [self _tryExec:_each];
        if ((res == YAPI_SUCCESS) && (subres != YAPI_SUCCESS)) {
            res = subres;
        }
    }
    [self clearCache];
    return res;
}

/**
 * Adds a file to the uploaded data at the next HTTP callback.
 * This function only affects the next HTTP callback and only works in
 * HTTP callback mode.
 *
 * @param filename : the name of the file to upload at the next HTTP callback
 *
 * @return nothing.
 */
-(int) addFileToHTTPCallback:(NSString*)filename
{
    NSMutableData* content;

    content = [self _download:[NSString stringWithFormat:@"%@%@", @"@YCB+", filename]];
    if ((int)[content length] == 0) {
        return YAPI_NOT_SUPPORTED;
    }
    return YAPI_SUCCESS;
}

/**
 * Returns the unique hardware identifier of the module.
 * The unique hardware identifier is made of the device serial
 * number followed by string ".module".
 *
 * @return a string that uniquely identifies the module
 */
-(NSString*) get_hardwareId
{
    NSString* serial;

    serial = [self get_serialNumber];
    return [NSString stringWithFormat:@"%@%@", serial, @".module"];
}

/**
 * Downloads the specified built-in file and returns a binary buffer with its content.
 *
 * @param pathname : name of the new file to load
 *
 * @return a binary buffer with the file content
 *
 * On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSMutableData*) download:(NSString*)pathname
{
    return [self _download:pathname];
}

/**
 * Returns the icon of the module. The icon is a PNG image and does not
 * exceeds 1536 bytes.
 *
 * @return a binary buffer with module icon, in png format.
 *         On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSMutableData*) get_icon2d
{
    return [self _download:@"icon2d.png"];
}

/**
 * Returns a string with last logs of the module. This method return only
 * logs that are still in the module.
 *
 * @return a string with last logs of the module.
 *         On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSString*) get_lastLogs
{
    NSMutableData* content;

    content = [self _download:@"logs.txt"];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
}

/**
 * Adds a text message to the device logs. This function is useful in
 * particular to trace the execution of HTTP callbacks. If a newline
 * is desired after the message, it must be included in the string.
 *
 * @param text : the string to append to the logs.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) log:(NSString*)text
{
    return [self _upload:@"logs.txt" :[NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]]];
}

/**
 * Returns a list of all the modules that are plugged into the current module.
 * This method only makes sense when called for a YoctoHub/VirtualHub.
 * Otherwise, an empty array will be returned.
 *
 * @return an array of strings containing the sub modules.
 */
-(NSMutableArray*) get_subDevices
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char smallbuff[1024];
    char *bigbuff;
    int buffsize;
    int fullsize;
    int yapi_res;
    NSString* subdevice_list;
    NSMutableArray* subdevices = [NSMutableArray array];
    NSString* serial;

    serial = [self get_serialNumber];
    fullsize = 0;
    yapi_res = yapiGetSubdevices(STR_oc2y(serial), smallbuff, 1024, &fullsize, errmsg);
    if (yapi_res < 0) {
        return subdevices;
    }
    if (fullsize <= 1024) {
        subdevice_list = ARC_sendAutorelease([[NSString alloc] initWithBytes:smallbuff length:yapi_res encoding:NSUTF8StringEncoding]);
    } else {
        buffsize = fullsize;
        bigbuff = (char *)malloc(buffsize);
        yapi_res = yapiGetSubdevices(STR_oc2y(serial), bigbuff, buffsize, &fullsize, errmsg);
        if (yapi_res < 0) {
            free(bigbuff);
            return subdevices;
        } else {
            subdevice_list = ARC_sendAutorelease([[NSString alloc] initWithBytes:bigbuff length:yapi_res encoding:NSUTF8StringEncoding]);
        }
        free(bigbuff);
    }
    if (!([subdevice_list isEqualToString:@""])) {
        subdevices = [NSMutableArray arrayWithArray:[subdevice_list componentsSeparatedByString:@","]];
    }
    return subdevices;
}

/**
 * Returns the serial number of the YoctoHub on which this module is connected.
 * If the module is connected by USB, or if the module is the root YoctoHub, an
 * empty string is returned.
 *
 * @return a string with the serial number of the YoctoHub or an empty string
 */
-(NSString*) get_parentHub
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char hubserial[YOCTO_SERIAL_LEN];
    int pathsize;
    int yapi_res;
    NSString* serial;

    serial = [self get_serialNumber];
    // retrieve device object
    pathsize = 0;
    yapi_res = yapiGetDevicePathEx(STR_oc2y(serial), hubserial, nil, 0, &pathsize, errmsg);
    if (yapi_res < 0) {
        return @"";
    }
    return STR_y2oc(hubserial);
}

/**
 * Returns the URL used to access the module. If the module is connected by USB, the
 * string 'usb' is returned.
 *
 * @return a string with the URL of the module.
 */
-(NSString*) get_url
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char path[1024];
    int pathsize;
    int yapi_res;
    NSString* serial;

    serial = [self get_serialNumber];
    // retrieve device object
    pathsize = 0;
    yapi_res = yapiGetDevicePathEx(STR_oc2y(serial), nil, path, 1024, &pathsize, errmsg);
    if (yapi_res < 0) {
        return @"";
    }
    return STR_y2oc(path);
}


-(YModule*)   nextModule
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YModule FindModule:hwid];
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

//--- (end of generated code: YModule public methods implementation)

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
    NSString      *serial, *funcId,  *funcName, *funcVal;
    NSError       *error;

    int res = [self _getFunction:functionIndex :&serial :&funcId :nil :&funcName :&funcVal :&error];

    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }
    return funcId;
}

// Retrieve the type of the nth function (beside "module") in the device
-(NSString*)           functionType:(int) functionIndex
{
    NSString      *serial, *funcId, *funcName, *funcVal;
    NSError       *error;
    char        buffer[YOCTO_FUNCTION_LEN], *d = buffer;
    const char *p;

    int res = [self _getFunction:functionIndex :&serial :&funcId :nil :&funcName :&funcVal :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }
    p = STR_oc2y(funcId);
    *d++ = *p++ & 0xdf;
    while (*p) {
        *d++ = *p++;
    }
    while (d > buffer && d[-1] <= '9') d--;
    *d = 0;
    return STR_y2oc(buffer);
}

// Retrieve the base type of the nth function (beside "module") in the device
-(NSString*)           functionBaseType:(int) functionIndex
{
    NSString      *serial, *funcId, *baseType, *funcName, *funcVal;
    NSError       *error;

    int res = [self _getFunction:functionIndex :&serial :&funcId :&baseType :&funcName :&funcVal :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }
    return baseType;
}


// Retrieve the logical name of the nth function (beside "module") in the device
-(NSString*)           functionName:(int) functionIndex
{
    NSString    *serial, *funcId, *funcName, *funcVal;
    NSError     *error;

    int res = [self _getFunction:functionIndex :&serial :&funcId :nil :&funcName :&funcVal :&error];
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

    int res = [self _getFunction:functionIndex :&serial :&funcId :nil :&funcName :&funcVal :&error];
    if(YISERR(res)) {
        [self _throw:error];
        return [YAPI INVALID_STRING];
    }

    return funcVal;
}

@end //YModule


@implementation YFirmwareUpdate

-(id)   initWith:(NSString*)serial :(NSString*)path :(NSData*)settings :(bool)force
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YFirmwareUpdate attributes initialization)
    _progress_c = 0;
    _progress = 0;
    _restore_step = 0;
//--- (end of generated code: YFirmwareUpdate attributes initialization)
    _serial = serial;
    _firmwarepath = path;
    _settings = [NSMutableData dataWithData: settings];
    _force = force;
    return self;
}

// destructor
-(void)  dealloc
{
//--- (generated code: YFirmwareUpdate cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YFirmwareUpdate cleanup)
}

//--- (generated code: YFirmwareUpdate private methods implementation)

//--- (end of generated code: YFirmwareUpdate private methods implementation)

//--- (generated code: YFirmwareUpdate public methods implementation)
-(int) _processMore:(int)newupdate
{
    char errmsg[YOCTO_ERRMSG_LEN];
    YModule* m;
    int res;
    NSString* serial;
    NSString* firmwarepath;
    NSString* settings;
    NSString* prod_prefix;
    int force;
    if ((_progress_c < 100) && (_progress_c != YAPI_VERSION_MISMATCH)) {
        serial = _serial;
        firmwarepath = _firmwarepath;
        settings = ARC_sendAutorelease([[NSString alloc] initWithData:_settings encoding:NSISOLatin1StringEncoding]);
        if (_force) {
            force = 1;
        } else {
            force = 0;
        }
        res = yapiUpdateFirmwareEx(STR_oc2y(serial), STR_oc2y(firmwarepath), STR_oc2y(settings), force, newupdate, errmsg);
        if ((res == YAPI_VERSION_MISMATCH) && ((int)[_settings length] != 0)) {
            _progress_c = res;
            _progress_msg = STR_y2oc(errmsg);
            return _progress;
        }
        if (res < 0) {
            _progress = res;
            _progress_msg = STR_y2oc(errmsg);
            return res;
        }
        _progress_c = res;
        _progress = ((_progress_c * 9) / (10));
        _progress_msg = STR_y2oc(errmsg);
    } else {
        if (((int)[_settings length] != 0)) {
            _progress_msg = @"restoring settings";
            m = [YModule FindModule:[NSString stringWithFormat:@"%@%@", _serial, @".module"]];
            if (!([m isOnline])) {
                return _progress;
            }
            if (_progress < 95) {
                prod_prefix = [[m get_productName] substringWithRange:NSMakeRange( 0, 8)];
                if ([prod_prefix isEqualToString:@"YoctoHub"]) {
                    [YAPI Sleep:1000 :NULL];
                    _progress = _progress + 1;
                    return _progress;
                } else {
                    _progress = 95;
                }
            }
            if (_progress < 100) {
                [m set_allSettingsAndFiles:_settings];
                [m saveToFlash];
                _settings = [NSMutableData dataWithLength:0];
                if (_progress_c == YAPI_VERSION_MISMATCH) {
                    _progress = YAPI_IO_ERROR;
                    _progress_msg = @"Unable to update firmware";
                } else {
                    _progress = 100;
                    _progress_msg = @"success";
                }
            }
        } else {
            _progress = 100;
            _progress_msg = @"success";
        }
    }
    return _progress;
}

/**
 * Returns a list of all the modules in "firmware update" mode.
 *
 * @return an array of strings containing the serial numbers of devices in "firmware update" mode.
 */
+(NSMutableArray*) GetAllBootLoaders
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char smallbuff[1024];
    char *bigbuff;
    int buffsize;
    int fullsize;
    int yapi_res;
    NSString* bootloader_list;
    NSMutableArray* bootladers = [NSMutableArray array];
    fullsize = 0;
    yapi_res = yapiGetBootloaders(smallbuff, 1024, &fullsize, errmsg);
    if (yapi_res < 0) {
        return bootladers;
    }
    if (fullsize <= 1024) {
        bootloader_list = ARC_sendAutorelease([[NSString alloc] initWithBytes:smallbuff length:yapi_res encoding:NSUTF8StringEncoding]);
    } else {
        buffsize = fullsize;
        bigbuff = (char *)malloc(buffsize);
        yapi_res = yapiGetBootloaders(bigbuff, buffsize, &fullsize, errmsg);
        if (yapi_res < 0) {
            free(bigbuff);
            return bootladers;
        } else {
            bootloader_list = ARC_sendAutorelease([[NSString alloc] initWithBytes:bigbuff length:yapi_res encoding:NSUTF8StringEncoding]);
        }
        free(bigbuff);
    }
    if (!([bootloader_list isEqualToString:@""])) {
        bootladers = [NSMutableArray arrayWithArray:[bootloader_list componentsSeparatedByString:@","]];
    }
    return bootladers;
}

/**
 * Test if the byn file is valid for this module. It is possible to pass a directory instead of a file.
 * In that case, this method returns the path of the most recent appropriate byn file. This method will
 * ignore any firmware older than minrelease.
 *
 * @param serial : the serial number of the module to update
 * @param path : the path of a byn file or a directory that contains byn files
 * @param minrelease : a positive integer
 *
 * @return : the path of the byn file to use, or an empty string if no byn files matches the requirement
 *
 * On failure, returns a string that starts with "error:".
 */
+(NSString*) CheckFirmware:(NSString*)serial :(NSString*)path :(int)minrelease
{
    char errmsg[YOCTO_ERRMSG_LEN];
    char smallbuff[1024];
    char *bigbuff;
    int buffsize;
    int fullsize;
    int res;
    NSString* firmware_path;
    NSString* release;
    fullsize = 0;
    release = [NSString stringWithFormat:@"%d",minrelease];
    res = yapiCheckFirmware(STR_oc2y(serial), STR_oc2y(release), STR_oc2y(path), smallbuff, 1024, &fullsize, errmsg);
    if (res < 0) {
        firmware_path = [NSString stringWithFormat:@"%@%@", @"error:", STR_y2oc(errmsg)];
        return [NSString stringWithFormat:@"%@%@", @"error:", STR_y2oc(errmsg)];
    }
    if (fullsize <= 1024) {
        firmware_path = ARC_sendAutorelease([[NSString alloc] initWithBytes:smallbuff length:fullsize encoding:NSUTF8StringEncoding]);
    } else {
        buffsize = fullsize;
        bigbuff = (char *)malloc(buffsize);
        res = yapiCheckFirmware(STR_oc2y(serial), STR_oc2y(release), STR_oc2y(path), bigbuff, buffsize, &fullsize, errmsg);
        if (res < 0) {
            firmware_path = [NSString stringWithFormat:@"%@%@", @"error:", STR_y2oc(errmsg)];
        } else {
            firmware_path = ARC_sendAutorelease([[NSString alloc] initWithBytes:bigbuff length:fullsize encoding:NSUTF8StringEncoding]);
        }
        free(bigbuff);
    }
    return firmware_path;
}

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
-(int) get_progress
{
    if (_progress >= 0) {
        [self _processMore:0];
    }
    return _progress;
}

/**
 * Returns the last progress message of the firmware update process. If an error occurs during the
 * firmware update process, the error message is returned
 *
 * @return a string  with the latest progress message, or the error message.
 */
-(NSString*) get_progressMessage
{
    return _progress_msg;
}

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
-(int) startUpdate
{
    NSString* err;
    int leng;
    err = ARC_sendAutorelease([[NSString alloc] initWithData:_settings encoding:NSISOLatin1StringEncoding]);
    leng = (int)[(err) length];
    if ((leng >= 6) && ([@"error:" isEqualToString:[err substringWithRange:NSMakeRange(0, 6)]])) {
        _progress = -1;
        _progress_msg = [err substringWithRange:NSMakeRange( 6, leng - 6)];
    } else {
        _progress = 0;
        _progress_c = 0;
        [self _processMore:1];
    }
    return _progress;
}

//--- (end of generated code: YFirmwareUpdate public methods implementation)

@end

@implementation YDataStream

-(id)   initWith:(YFunction *)parent
{
    if(!(self = [super init]))
        return nil;
    _parent = parent;
//--- (generated code: YDataStream attributes initialization)
    _runNo = 0;
    _utcStamp = 0;
    _nCols = 0;
    _nRows = 0;
    _startTime = 0;
    _duration = 0;
    _dataSamplesInterval = 0;
    _firstMeasureDuration = 0;
    _columnNames = [NSMutableArray array];
    _minVal = 0;
    _avgVal = 0;
    _maxVal = 0;
    _caltyp = 0;
    _calpar = [NSMutableArray array];
    _calraw = [NSMutableArray array];
    _calref = [NSMutableArray array];
    _values = [NSMutableArray array];
//--- (end of generated code: YDataStream attributes initialization)

    return self;
}
-(id)   initWith:(YFunction *)parent :(YDataSet*)dataset :(NSMutableArray*) encoded
{
    if(!(self = [super init]))
        return nil;
    _parent = parent;
//--- (generated code: YDataStream attributes initialization)
    _runNo = 0;
    _utcStamp = 0;
    _nCols = 0;
    _nRows = 0;
    _startTime = 0;
    _duration = 0;
    _dataSamplesInterval = 0;
    _firstMeasureDuration = 0;
    _columnNames = [NSMutableArray array];
    _minVal = 0;
    _avgVal = 0;
    _maxVal = 0;
    _caltyp = 0;
    _calpar = [NSMutableArray array];
    _calraw = [NSMutableArray array];
    _calref = [NSMutableArray array];
    _values = [NSMutableArray array];
//--- (end of generated code: YDataStream attributes initialization)
    [self _initFromDataSet:dataset :encoded];
    return self;
}

// destructor
-(void)  dealloc
{
    if (_columnNames!=nil) { ARC_release(_columnNames);}
    if (_calpar!=nil) { ARC_release(_calpar);}
    if (_calraw!=nil) { ARC_release(_calraw);}
    if (_calref!=nil) { ARC_release(_calref);}
    if (_values!=nil) { ARC_release(_values);}
//--- (generated code: YDataStream cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YDataStream cleanup)
}

//--- (generated code: YDataStream private methods implementation)

//--- (end of generated code: YDataStream private methods implementation)

//--- (generated code: YDataStream public methods implementation)
-(int) _initFromDataSet:(YDataSet*)dataset :(NSMutableArray*)encoded
{
    int val;
    int i;
    int maxpos;
    int ms_offset;
    int samplesPerHour;
    double fRaw;
    double fRef;
    NSMutableArray* iCalib = [NSMutableArray array];
    // decode sequence header to extract data
    _runNo = [[encoded objectAtIndex:0] intValue] + ((([[encoded objectAtIndex:1] intValue]) << (16)));
    _utcStamp = [[encoded objectAtIndex:2] intValue] + ((([[encoded objectAtIndex:3] intValue]) << (16)));
    val = [[encoded objectAtIndex:4] intValue];
    _isAvg = (((val) & (0x100)) == 0);
    samplesPerHour = ((val) & (0xff));
    if (((val) & (0x100)) != 0) {
        samplesPerHour = samplesPerHour * 3600;
    } else {
        if (((val) & (0x200)) != 0) {
            samplesPerHour = samplesPerHour * 60;
        }
    }
    _dataSamplesInterval = 3600.0 / samplesPerHour;
    ms_offset = [[encoded objectAtIndex:6] intValue];
    if (ms_offset < 1000) {
        // new encoding -> add the ms to the UTC timestamp
        _startTime = _utcStamp + (ms_offset / 1000.0);
    } else {
        // legacy encoding subtract the measure interval form the UTC timestamp
        _startTime = _utcStamp - _dataSamplesInterval;
    }
    _firstMeasureDuration = [[encoded objectAtIndex:5] intValue];
    if (!(_isAvg)) {
        _firstMeasureDuration = _firstMeasureDuration / 1000.0;
    }
    val = [[encoded objectAtIndex:7] intValue];
    _isClosed = (val != 0xffff);
    if (val == 0xffff) {
        val = 0;
    }
    _nRows = val;
    if (_nRows > 0) {
        if (_firstMeasureDuration > 0) {
            _duration = _firstMeasureDuration + (_nRows - 1) * _dataSamplesInterval;
        } else {
            _duration = _nRows * _dataSamplesInterval;
        }
    } else {
        _duration = 0;
    }
    // precompute decoding parameters
    iCalib = [dataset _get_calibration];
    _caltyp = [[iCalib objectAtIndex:0] intValue];
    if (_caltyp != 0) {
        _calhdl = [YAPI _getCalibrationHandler:_caltyp];
        maxpos = (int)[iCalib count];
        [_calpar removeAllObjects];
        [_calraw removeAllObjects];
        [_calref removeAllObjects];
        i = 1;
        while (i < maxpos) {
            [_calpar addObject:[iCalib objectAtIndex:i]];
            i = i + 1;
        }
        i = 1;
        while (i + 1 < maxpos) {
            fRaw = [[iCalib objectAtIndex:i] doubleValue];
            fRaw = fRaw / 1000.0;
            fRef = [[iCalib objectAtIndex:i + 1] doubleValue];
            fRef = fRef / 1000.0;
            [_calraw addObject:[NSNumber numberWithDouble:fRaw]];
            [_calref addObject:[NSNumber numberWithDouble:fRef]];
            i = i + 2;
        }
    }
    // preload column names for backward-compatibility
    _functionId = [dataset get_functionId];
    if (_isAvg) {
        [_columnNames removeAllObjects];
        [_columnNames addObject:[NSString stringWithFormat:@"%@_min",_functionId]];
        [_columnNames addObject:[NSString stringWithFormat:@"%@_avg",_functionId]];
        [_columnNames addObject:[NSString stringWithFormat:@"%@_max",_functionId]];
        _nCols = 3;
    } else {
        [_columnNames removeAllObjects];
        [_columnNames addObject:_functionId];
        _nCols = 1;
    }
    // decode min/avg/max values for the sequence
    if (_nRows > 0) {
        _avgVal = [self _decodeAvg:[[encoded objectAtIndex:8] intValue] + ((((([[encoded objectAtIndex:9] intValue]) ^ (0x8000))) << (16))) :1];
        _minVal = [self _decodeVal:[[encoded objectAtIndex:10] intValue] + ((([[encoded objectAtIndex:11] intValue]) << (16)))];
        _maxVal = [self _decodeVal:[[encoded objectAtIndex:12] intValue] + ((([[encoded objectAtIndex:13] intValue]) << (16)))];
    }
    return 0;
}

-(int) _parseStream:(NSData*)sdata
{
    int idx;
    NSMutableArray* udat = [NSMutableArray array];
    NSMutableArray* dat = [NSMutableArray array];
    if (_isLoaded && !(_isClosed)) {
        return YAPI_SUCCESS;
    }
    if ((int)[sdata length] == 0) {
        _nRows = 0;
        return YAPI_SUCCESS;
    }

    udat = [YAPI _decodeWords:[_parent _json_get_string:sdata]];
    [_values removeAllObjects];
    idx = 0;
    if (_isAvg) {
        while (idx + 3 < (int)[udat count]) {
            [dat removeAllObjects];
            if (([[udat objectAtIndex:idx] intValue] == 65535) && ([[udat objectAtIndex:idx + 1] intValue] == 65535)) {
                [dat addObject:[NSNumber numberWithDouble:NAN]];
                [dat addObject:[NSNumber numberWithDouble:NAN]];
                [dat addObject:[NSNumber numberWithDouble:NAN]];
            } else {
                [dat addObject:[NSNumber numberWithDouble:[self _decodeVal:[[udat objectAtIndex:idx + 2] intValue] + ((([[udat objectAtIndex:idx + 3] intValue]) << (16)))]]];
                [dat addObject:[NSNumber numberWithDouble:[self _decodeAvg:[[udat objectAtIndex:idx] intValue] + ((((([[udat objectAtIndex:idx + 1] intValue]) ^ (0x8000))) << (16))) :1]]];
                [dat addObject:[NSNumber numberWithDouble:[self _decodeVal:[[udat objectAtIndex:idx + 4] intValue] + ((([[udat objectAtIndex:idx + 5] intValue]) << (16)))]]];
            }
            idx = idx + 6;
            [_values addObject:[dat copy]];
        }
    } else {
        while (idx + 1 < (int)[udat count]) {
            [dat removeAllObjects];
            if (([[udat objectAtIndex:idx] intValue] == 65535) && ([[udat objectAtIndex:idx + 1] intValue] == 65535)) {
                [dat addObject:[NSNumber numberWithDouble:NAN]];
            } else {
                [dat addObject:[NSNumber numberWithDouble:[self _decodeAvg:[[udat objectAtIndex:idx] intValue] + ((((([[udat objectAtIndex:idx + 1] intValue]) ^ (0x8000))) << (16))) :1]]];
            }
            [_values addObject:[dat copy]];
            idx = idx + 2;
        }
    }

    _nRows = (int)[_values count];
    _isLoaded = YES;
    return YAPI_SUCCESS;
}

-(bool) _wasLoaded
{
    return _isLoaded;
}

-(NSString*) _get_url
{
    NSString* url;
    url = [NSString stringWithFormat:@"logger.json?id=%@&run=%d&utc=%lu",
    _functionId,_runNo,_utcStamp];
    return url;
}

-(NSString*) _get_baseurl
{
    NSString* url;
    url = [NSString stringWithFormat:@"logger.json?id=%@&run=%d&utc=",
    _functionId,_runNo];
    return url;
}

-(NSString*) _get_urlsuffix
{
    NSString* url;
    url = [NSString stringWithFormat:@"%lu",_utcStamp];
    return url;
}

-(int) loadStream
{
    return [self _parseStream:[_parent _download:[self _get_url]]];
}

-(double) _decodeVal:(int)w
{
    double val;
    val = w;
    val = val / 1000.0;
    if (_caltyp != 0) {
        if (_calhdl != NULL) {
            val = [_calhdl yCalibrationHandler: val:_caltyp: _calpar: _calraw:_calref];
        }
    }
    return val;
}

-(double) _decodeAvg:(int)dw :(int)count
{
    double val;
    val = dw;
    val = val / 1000.0;
    if (_caltyp != 0) {
        if (_calhdl != NULL) {
            val = [_calhdl yCalibrationHandler: val: _caltyp: _calpar: _calraw:_calref];
        }
    }
    return val;
}

-(bool) isClosed
{
    return _isClosed;
}

/**
 * Returns the run index of the data stream. A run can be made of
 * multiple datastreams, for different time intervals.
 *
 * @return an unsigned number corresponding to the run index.
 */
-(int) get_runIndex
{
    return _runNo;
}

/**
 * Returns the relative start time of the data stream, measured in seconds.
 * For recent firmwares, the value is relative to the present time,
 * which means the value is always negative.
 * If the device uses a firmware older than version 13000, value is
 * relative to the start of the time the device was powered on, and
 * is always positive.
 * If you need an absolute UTC timestamp, use get_realStartTimeUTC().
 *
 * <b>DEPRECATED</b>: This method has been replaced by get_realStartTimeUTC().
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the start of the run and the beginning of this data
 *         stream.
 */
-(int) get_startTime
{
    return (int)(_utcStamp - ((unsigned)time(NULL)));
}

/**
 * Returns the start time of the data stream, relative to the Jan 1, 1970.
 * If the UTC time was not set in the datalogger at the time of the recording
 * of this data stream, this method returns 0.
 *
 * <b>DEPRECATED</b>: This method has been replaced by get_realStartTimeUTC().
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         stream (i.e. Unix time representation of the absolute time).
 */
-(s64) get_startTimeUTC
{
    return (int) floor(_startTime+0.5);
}

/**
 * Returns the start time of the data stream, relative to the Jan 1, 1970.
 * If the UTC time was not set in the datalogger at the time of the recording
 * of this data stream, this method returns 0.
 *
 * @return a floating-point number  corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         stream (i.e. Unix time representation of the absolute time).
 */
-(double) get_realStartTimeUTC
{
    return _startTime;
}

/**
 * Returns the number of milliseconds between two consecutive
 * rows of this data stream. By default, the data logger records one row
 * per second, but the recording frequency can be changed for
 * each device function
 *
 * @return an unsigned number corresponding to a number of milliseconds.
 */
-(int) get_dataSamplesIntervalMs
{
    return (int) floor(_dataSamplesInterval*1000+0.5);
}

-(double) get_dataSamplesInterval
{
    return _dataSamplesInterval;
}

-(double) get_firstDataSamplesInterval
{
    return _firstMeasureDuration;
}

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
-(int) get_rowCount
{
    if ((_nRows != 0) && _isClosed) {
        return _nRows;
    }
    [self loadStream];
    return _nRows;
}

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
-(int) get_columnCount
{
    if (_nCols != 0) {
        return _nCols;
    }
    [self loadStream];
    return _nCols;
}

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
-(NSMutableArray*) get_columnNames
{
    if ((int)[_columnNames count] != 0) {
        return _columnNames;
    }
    [self loadStream];
    return _columnNames;
}

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
-(double) get_minValue
{
    return _minVal;
}

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
-(double) get_averageValue
{
    return _avgVal;
}

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
-(double) get_maxValue
{
    return _maxVal;
}

-(double) get_realDuration
{
    if (_isClosed) {
        return _duration;
    }
    return (double) ((unsigned)time(NULL)) - _utcStamp;
}

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
-(NSMutableArray*) get_dataRows
{
    if (((int)[_values count] == 0) || !(_isClosed)) {
        [self loadStream];
    }
    return _values;
}

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
-(double) get_data:(int)row :(int)col
{
    if (((int)[_values count] == 0) || !(_isClosed)) {
        [self loadStream];
    }
    if (row >= (int)[_values count]) {
        return Y_DATA_INVALID;
    }
    if (col >= (int)[[_values objectAtIndex:row] count]) {
        return Y_DATA_INVALID;
    }
    return [[[_values objectAtIndex:row] objectAtIndex:col] doubleValue];
}

//--- (end of generated code: YDataStream public methods implementation)

@end



@implementation YMeasure


-(id)   initWith:(double)start :(double)end :(double)minVal :(double)avgVal :(double)maxVal
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YMeasure attributes initialization)
    _start = 0;
    _end = 0;
    _minVal = 0;
    _avgVal = 0;
    _maxVal = 0;
//--- (end of generated code: YMeasure attributes initialization)
    _start = start;
    _end = end;
    _minVal = minVal;
    _avgVal = avgVal;
    _maxVal = maxVal;
    return self;
}

-(id)   init
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YMeasure attributes initialization)
    _start = 0;
    _end = 0;
    _minVal = 0;
    _avgVal = 0;
    _maxVal = 0;
//--- (end of generated code: YMeasure attributes initialization)
    return self;
}

// destructor
-(void)  dealloc
{
//--- (generated code: YMeasure cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YMeasure cleanup)
}

//--- (generated code: YMeasure private methods implementation)

//--- (end of generated code: YMeasure private methods implementation)

//--- (generated code: YMeasure public methods implementation)
/**
 * Returns the start time of the measure, relative to the Jan 1, 1970 UTC
 * (Unix timestamp). When the recording rate is higher then 1 sample
 * per second, the timestamp may have a fractional part.
 *
 * @return a floating point number corresponding to the number of seconds
 *         between the Jan 1, 1970 UTC and the beginning of this measure.
 */
-(double) get_startTimeUTC
{
    return _start;
}

/**
 * Returns the end time of the measure, relative to the Jan 1, 1970 UTC
 * (Unix timestamp). When the recording rate is higher than 1 sample
 * per second, the timestamp may have a fractional part.
 *
 * @return a floating point number corresponding to the number of seconds
 *         between the Jan 1, 1970 UTC and the end of this measure.
 */
-(double) get_endTimeUTC
{
    return _end;
}

/**
 * Returns the smallest value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the smallest value observed.
 */
-(double) get_minValue
{
    return _minVal;
}

/**
 * Returns the average value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the average value observed.
 */
-(double) get_averageValue
{
    return _avgVal;
}

/**
 * Returns the largest value observed during the time interval
 * covered by this measure.
 *
 * @return a floating-point number corresponding to the largest value observed.
 */
-(double) get_maxValue
{
    return _maxVal;
}

//--- (end of generated code: YMeasure public methods implementation)

-(NSDate*)       get_startTimeUTC_asNSDate
{
    return [NSDate dateWithTimeIntervalSince1970:_start];
}
-(NSDate*)       get_endTimeUTC_asNSDate
{
    return [NSDate dateWithTimeIntervalSince1970:_end];
}

@end


@implementation YDataSet

-(id)   initWith:(YFunction *)parent :(NSString*)functionId :(NSString*)unit :(double)startTime :(double)endTime
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YDataSet attributes initialization)
    _bulkLoad = 0;
    _startTimeMs = 0;
    _endTimeMs = 0;
    _progress = 0;
    _calib = [NSMutableArray array];
    _streams = [NSMutableArray array];
    _preview = [NSMutableArray array];
    _measures = [NSMutableArray array];
    _summaryMinVal = 0;
    _summaryMaxVal = 0;
    _summaryTotalAvg = 0;
    _summaryTotalTime = 0;
//--- (end of generated code: YDataSet attributes initialization)
    _parent = parent;
    _functionId = functionId;
    _unit       = unit;
    _startTimeMs  = startTime * 1000;
    _endTimeMs    = endTime * 1000;
    _progress   = -1;
    return self;
}

-(id)   initWith:(YFunction *)parent
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YDataSet attributes initialization)
    _bulkLoad = 0;
    _startTimeMs = 0;
    _endTimeMs = 0;
    _progress = 0;
    _calib = [NSMutableArray array];
    _streams = [NSMutableArray array];
    _preview = [NSMutableArray array];
    _measures = [NSMutableArray array];
    _summaryMinVal = 0;
    _summaryMaxVal = 0;
    _summaryTotalAvg = 0;
    _summaryTotalTime = 0;
//--- (end of generated code: YDataSet attributes initialization)
    _parent    = parent;
    _startTimeMs = 0;
    _endTimeMs   = 0;
    _summary = [[YMeasure alloc] init];
    return self;
}

-(int)  _parse:(NSString *)json
{
    yJsonStateMachine j;

    // Parse JSON data
    const char *json_cstr;
    j.src = json_cstr= STR_oc2y(json);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        return YAPI_NOT_SUPPORTED;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if (!strcmp(j.token, "id")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return YAPI_NOT_SUPPORTED;
            }
            _functionId = [_parent _parseString:&j];
        } else if (!strcmp(j.token, "unit")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return YAPI_NOT_SUPPORTED;
            }
            _unit = [_parent _parseString:&j];
        } else if (!strcmp(j.token, "bulk")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return YAPI_NOT_SUPPORTED;
            }
            _bulkLoad = [[_parent _parseString:&j] intValue];
        } else if (!strcmp(j.token, "calib")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return YAPI_NOT_SUPPORTED;
            }
            _calib = [YAPI _decodeFloats:[_parent _parseString:&j]];
            _calib[0] = [NSNumber numberWithInt: [[_calib objectAtIndex:0] intValue] / 1000];
        } else if (!strcmp(j.token, "cal")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return YAPI_NOT_SUPPORTED;
            }
            if([_calib count] == 0) {
                _calib = [YAPI _decodeWords:[_parent _parseString:&j]];
            }
        } else if (!strcmp(j.token, "streams")) {
            YDataStream *stream;
            double streamEndTime;
            double streamStartTime;
            _streams = [[NSMutableArray alloc] init];
            _preview = [[NSMutableArray alloc] init];
            _measures = [[NSMutableArray alloc] init];
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL || j.token[0] != '[') {
                return YAPI_NOT_SUPPORTED;
            }
            // select streams for specified timeframe
            while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.token[0] != ']') {
                stream = [_parent _findDataStream:self:[_parent _parseString:&j]];
                streamStartTime = [stream get_realStartTimeUTC] * 1000;
                streamEndTime = streamStartTime + [stream get_realDuration] * 1000;
                if(_startTimeMs > 0 && streamEndTime <= _startTimeMs) {
                    // this stream is too early, drop it
                } else if(_endTimeMs > 0 && streamStartTime >= _endTimeMs) {
                    // this stream is too late, drop it
                } else {
                    [_streams addObject:stream];
                }
            }
        } else {
            yJsonSkip(&j, 1);
        }
    }
    _progress = 0;
    return [self get_progress];
}


// destructor
-(void)  dealloc
{
//--- (generated code: YDataSet cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YDataSet cleanup)
}
//--- (generated code: YDataSet private methods implementation)

//--- (end of generated code: YDataSet private methods implementation)

//--- (generated code: YDataSet public methods implementation)
-(NSMutableArray*) _get_calibration
{
    return _calib;
}

-(int) loadSummary:(NSData*)data
{
    NSMutableArray* dataRows = [NSMutableArray array];
    double tim;
    double mitv;
    double itv;
    double fitv;
    double end_;
    int nCols;
    int minCol;
    int avgCol;
    int maxCol;
    int res;
    int m_pos;
    double previewTotalTime;
    double previewTotalAvg;
    double previewMinVal;
    double previewMaxVal;
    double previewAvgVal;
    double previewStartMs;
    double previewStopMs;
    double previewDuration;
    double streamStartTimeMs;
    double streamDuration;
    double streamEndTimeMs;
    double minVal;
    double avgVal;
    double maxVal;
    double summaryStartMs;
    double summaryStopMs;
    double summaryTotalTime;
    double summaryTotalAvg;
    double summaryMinVal;
    double summaryMaxVal;
    NSString* url;
    NSString* strdata;
    NSMutableArray* measure_data = [NSMutableArray array];

    if (_progress < 0) {
        strdata = ARC_sendAutorelease([[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding]);
        if ([strdata isEqualToString:@"{}"]) {
            [_parent _throw:YAPI_VERSION_MISMATCH :@"device firmware is too old"];
            return YAPI_VERSION_MISMATCH;
        }
        res = [self _parse:strdata];
        if (res < 0) {
            return res;
        }
    }
    summaryTotalTime = 0;
    summaryTotalAvg = 0;
    summaryMinVal = YAPI_MAX_DOUBLE;
    summaryMaxVal = YAPI_MIN_DOUBLE;
    summaryStartMs = YAPI_MAX_DOUBLE;
    summaryStopMs = YAPI_MIN_DOUBLE;

    // Parse complete streams
    for (YDataStream* _each  in  _streams) {
        streamStartTimeMs = floor([_each get_realStartTimeUTC] * 1000+0.5);
        streamDuration = [_each get_realDuration];
        streamEndTimeMs = streamStartTimeMs + floor(streamDuration * 1000+0.5);
        if ((streamStartTimeMs >= _startTimeMs) && ((_endTimeMs == 0) || (streamEndTimeMs <= _endTimeMs))) {
            // stream that are completely inside the dataset
            previewMinVal = [_each get_minValue];
            previewAvgVal = [_each get_averageValue];
            previewMaxVal = [_each get_maxValue];
            previewStartMs = streamStartTimeMs;
            previewStopMs = streamEndTimeMs;
            previewDuration = streamDuration;
        } else {
            // stream that are partially in the dataset
            // we need to parse data to filter value outside the dataset
            if (!([_each _wasLoaded])) {
                url = [_each _get_url];
                data = [_parent _download:url];
                [_each _parseStream:data];
            }
            dataRows = [_each get_dataRows];
            if ((int)[dataRows count] == 0) {
                return [self get_progress];
            }
            tim = streamStartTimeMs;
            fitv = floor([_each get_firstDataSamplesInterval] * 1000+0.5);
            itv = floor([_each get_dataSamplesInterval] * 1000+0.5);
            nCols = (int)[[dataRows objectAtIndex:0] count];
            minCol = 0;
            if (nCols > 2) {
                avgCol = 1;
            } else {
                avgCol = 0;
            }
            if (nCols > 2) {
                maxCol = 2;
            } else {
                maxCol = 0;
            }
            previewTotalTime = 0;
            previewTotalAvg = 0;
            previewStartMs = streamEndTimeMs;
            previewStopMs = streamStartTimeMs;
            previewMinVal = YAPI_MAX_DOUBLE;
            previewMaxVal = YAPI_MIN_DOUBLE;
            m_pos = 0;
            while (m_pos < (int)[dataRows count]) {
                measure_data = [dataRows objectAtIndex:m_pos];
                if (m_pos == 0) {
                    mitv = fitv;
                } else {
                    mitv = itv;
                }
                end_ = tim + mitv;
                if ((end_ > _startTimeMs) && ((_endTimeMs == 0) || (tim < _endTimeMs))) {
                    minVal = [[measure_data objectAtIndex:minCol] doubleValue];
                    avgVal = [[measure_data objectAtIndex:avgCol] doubleValue];
                    maxVal = [[measure_data objectAtIndex:maxCol] doubleValue];
                    if (previewStartMs > tim) {
                        previewStartMs = tim;
                    }
                    if (previewStopMs < end_) {
                        previewStopMs = end_;
                    }
                    if (previewMinVal > minVal) {
                        previewMinVal = minVal;
                    }
                    if (previewMaxVal < maxVal) {
                        previewMaxVal = maxVal;
                    }
                    if (!(isnan(avgVal))) {
                        previewTotalAvg = previewTotalAvg + (avgVal * mitv);
                        previewTotalTime = previewTotalTime + mitv;
                    }
                }
                tim = end_;
                m_pos = m_pos + 1;
            }
            if (previewTotalTime > 0) {
                previewAvgVal = previewTotalAvg / previewTotalTime;
                previewDuration = (previewStopMs - previewStartMs) / 1000.0;
            } else {
                previewAvgVal = 0.0;
                previewDuration = 0.0;
            }
        }
        [_preview addObject:ARC_sendAutorelease([[YMeasure alloc] initWith:previewStartMs / 1000.0 :previewStopMs / 1000.0 :previewMinVal :previewAvgVal :previewMaxVal])];
        if (summaryMinVal > previewMinVal) {
            summaryMinVal = previewMinVal;
        }
        if (summaryMaxVal < previewMaxVal) {
            summaryMaxVal = previewMaxVal;
        }
        if (summaryStartMs > previewStartMs) {
            summaryStartMs = previewStartMs;
        }
        if (summaryStopMs < previewStopMs) {
            summaryStopMs = previewStopMs;
        }
        summaryTotalAvg = summaryTotalAvg + (previewAvgVal * previewDuration);
        summaryTotalTime = summaryTotalTime + previewDuration;
    }
    if ((_startTimeMs == 0) || (_startTimeMs > summaryStartMs)) {
        _startTimeMs = summaryStartMs;
    }
    if ((_endTimeMs == 0) || (_endTimeMs < summaryStopMs)) {
        _endTimeMs = summaryStopMs;
    }
    if (summaryTotalTime > 0) {
        _summary = ARC_sendAutorelease([[YMeasure alloc] initWith:summaryStartMs / 1000.0 :summaryStopMs / 1000.0 :summaryMinVal :summaryTotalAvg / summaryTotalTime :summaryMaxVal]);
    } else {
        _summary = ARC_sendAutorelease([[YMeasure alloc] initWith:0.0 :0.0 :YAPI_INVALID_DOUBLE :YAPI_INVALID_DOUBLE :YAPI_INVALID_DOUBLE]);
    }
    return [self get_progress];
}

-(int) processMore:(int)progress :(NSData*)data
{
    YDataStream* stream;
    NSMutableArray* dataRows = [NSMutableArray array];
    double tim;
    double itv;
    double fitv;
    double avgv;
    double end_;
    int nCols;
    int minCol;
    int avgCol;
    int maxCol;
    bool firstMeasure;
    NSString* baseurl;
    NSString* url;
    NSString* suffix;
    NSMutableArray* suffixes = [NSMutableArray array];
    int idx;
    NSMutableData* bulkFile;
    NSMutableArray* streamStr = [NSMutableArray array];
    int urlIdx;
    NSMutableData* streamBin;

    if (progress != _progress) {
        return _progress;
    }
    if (_progress < 0) {
        return [self loadSummary:data];
    }
    stream = [_streams objectAtIndex:_progress];
    if (!([stream _wasLoaded])) {
        [stream _parseStream:data];
    }
    dataRows = [stream get_dataRows];
    _progress = _progress + 1;
    if ((int)[dataRows count] == 0) {
        return [self get_progress];
    }
    tim = floor([stream get_realStartTimeUTC] * 1000+0.5);
    fitv = floor([stream get_firstDataSamplesInterval] * 1000+0.5);
    itv = floor([stream get_dataSamplesInterval] * 1000+0.5);
    if (fitv == 0) {
        fitv = itv;
    }
    if (tim < itv) {
        tim = itv;
    }
    nCols = (int)[[dataRows objectAtIndex:0] count];
    minCol = 0;
    if (nCols > 2) {
        avgCol = 1;
    } else {
        avgCol = 0;
    }
    if (nCols > 2) {
        maxCol = 2;
    } else {
        maxCol = 0;
    }

    firstMeasure = YES;
    for (NSMutableArray* _each  in dataRows) {
        if (firstMeasure) {
            end_ = tim + fitv;
            firstMeasure = NO;
        } else {
            end_ = tim + itv;
        }
        avgv = [[_each objectAtIndex:avgCol] doubleValue];
        if ((end_ > _startTimeMs) && ((_endTimeMs == 0) || (tim < _endTimeMs)) && !(isnan(avgv))) {
            [_measures addObject:ARC_sendAutorelease([[YMeasure alloc] initWith:tim / 1000 :end_ / 1000 :[[_each objectAtIndex:minCol] doubleValue] :avgv :[[_each objectAtIndex:maxCol] doubleValue]])];
        }
        tim = end_;
    }
    // Perform bulk preload to speed-up network transfer
    if ((_bulkLoad > 0) && (_progress < (int)[_streams count])) {
        stream = [_streams objectAtIndex:_progress];
        if ([stream _wasLoaded]) {
            return [self get_progress];
        }
        baseurl = [stream _get_baseurl];
        url = [stream _get_url];
        suffix = [stream _get_urlsuffix];
        [suffixes addObject:suffix];
        idx = _progress + 1;
        while ((idx < (int)[_streams count]) && ((int)[suffixes count] < _bulkLoad)) {
            stream = [_streams objectAtIndex:idx];
            if (!([stream _wasLoaded]) && ([[stream _get_baseurl] isEqualToString:baseurl])) {
                suffix = [stream _get_urlsuffix];
                [suffixes addObject:suffix];
                url = [NSString stringWithFormat:@"%@%@%@", url, @",", suffix];
            }
            idx = idx + 1;
        }
        bulkFile = [_parent _download:url];
        streamStr = [_parent _json_get_array:bulkFile];
        urlIdx = 0;
        idx = _progress;
        while ((idx < (int)[_streams count]) && (urlIdx < (int)[suffixes count]) && (urlIdx < (int)[streamStr count])) {
            stream = [_streams objectAtIndex:idx];
            if (([[stream _get_baseurl] isEqualToString:baseurl]) && ([[stream _get_urlsuffix] isEqualToString:[suffixes objectAtIndex:urlIdx]])) {
                streamBin = [NSMutableData dataWithData:[[streamStr objectAtIndex:urlIdx] dataUsingEncoding:NSISOLatin1StringEncoding]];
                [stream _parseStream:streamBin];
                urlIdx = urlIdx + 1;
            }
            idx = idx + 1;
        }
    }
    return [self get_progress];
}

-(NSMutableArray*) get_privateDataStreams
{
    return _streams;
}

/**
 * Returns the unique hardware identifier of the function who performed the measures,
 * in the form SERIAL.FUNCTIONID. The unique hardware identifier is composed of the
 * device serial number and of the hardware identifier of the function
 * (for example THRMCPL1-123456.temperature1)
 *
 * @return a string that uniquely identifies the function (ex: THRMCPL1-123456.temperature1)
 *
 * On failure, throws an exception or returns  YDataSet.HARDWAREID_INVALID.
 */
-(NSString*) get_hardwareId
{
    YModule* mo;
    if (!([_hardwareId isEqualToString:@""])) {
        return _hardwareId;
    }
    mo = [_parent get_module];
    _hardwareId = [NSString stringWithFormat:@"%@.%@", [mo get_serialNumber],[self get_functionId]];
    return _hardwareId;
}

/**
 * Returns the hardware identifier of the function that performed the measure,
 * without reference to the module. For example temperature1.
 *
 * @return a string that identifies the function (ex: temperature1)
 */
-(NSString*) get_functionId
{
    return _functionId;
}

/**
 * Returns the measuring unit for the measured value.
 *
 * @return a string that represents a physical unit.
 *
 * On failure, throws an exception or returns  YDataSet.UNIT_INVALID.
 */
-(NSString*) get_unit
{
    return _unit;
}

/**
 * Returns the start time of the dataset, relative to the Jan 1, 1970.
 * When the YDataSet object is created, the start time is the value passed
 * in parameter to the get_dataSet() function. After the
 * very first call to loadMore(), the start time is updated
 * to reflect the timestamp of the first measure actually found in the
 * dataLogger within the specified range.
 *
 * <b>DEPRECATED</b>: This method has been replaced by get_summary()
 * which contain more precise informations.
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the beginning of this data
 *         set (i.e. Unix time representation of the absolute time).
 */
-(s64) get_startTimeUTC
{
    return [self imm_get_startTimeUTC];
}

-(s64) imm_get_startTimeUTC
{
    return (s64) (_startTimeMs / 1000.0);
}

/**
 * Returns the end time of the dataset, relative to the Jan 1, 1970.
 * When the YDataSet object is created, the end time is the value passed
 * in parameter to the get_dataSet() function. After the
 * very first call to loadMore(), the end time is updated
 * to reflect the timestamp of the last measure actually found in the
 * dataLogger within the specified range.
 *
 * <b>DEPRECATED</b>: This method has been replaced by get_summary()
 * which contain more precise informations.
 *
 * @return an unsigned number corresponding to the number of seconds
 *         between the Jan 1, 1970 and the end of this data
 *         set (i.e. Unix time representation of the absolute time).
 */
-(s64) get_endTimeUTC
{
    return [self imm_get_endTimeUTC];
}

-(s64) imm_get_endTimeUTC
{
    return (s64) floor(_endTimeMs / 1000.0+0.5);
}

/**
 * Returns the progress of the downloads of the measures from the data logger,
 * on a scale from 0 to 100. When the object is instantiated by get_dataSet,
 * the progress is zero. Each time loadMore() is invoked, the progress
 * is updated, to reach the value 100 only once all measures have been loaded.
 *
 * @return an integer in the range 0 to 100 (percentage of completion).
 */
-(int) get_progress
{
    if (_progress < 0) {
        return 0;
    }
    // index not yet loaded
    if (_progress >= (int)[_streams count]) {
        return 100;
    }
    return ((1 + (1 + _progress) * 98) / ((1 + (int)[_streams count])));
}

/**
 * Loads the next block of measures from the dataLogger, and updates
 * the progress indicator.
 *
 * @return an integer in the range 0 to 100 (percentage of completion),
 *         or a negative error code in case of failure.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) loadMore
{
    NSString* url;
    YDataStream* stream;
    if (_progress < 0) {
        url = [NSString stringWithFormat:@"logger.json?id=%@",_functionId];
        if (_startTimeMs != 0) {
            url = [NSString stringWithFormat:@"%@&from=%lu",url,[self imm_get_startTimeUTC]];
        }
        if (_endTimeMs != 0) {
            url = [NSString stringWithFormat:@"%@&to=%lu",url,[self imm_get_endTimeUTC] + 1];
        }
    } else {
        if (_progress >= (int)[_streams count]) {
            return 100;
        } else {
            stream = [_streams objectAtIndex:_progress];
            if ([stream _wasLoaded]) {
                // Do not reload stream if it was already loaded
                return [self processMore:_progress :[NSMutableData dataWithData:[@"" dataUsingEncoding:NSISOLatin1StringEncoding]]];
            }
            url = [stream _get_url];
        }
    }
    @try {
        return [self processMore:_progress :[_parent _download:url]];
    }
    @catch (NSException *e) {
        return [self processMore:_progress :[_parent _download:url]];
    }
}

/**
 * Returns an YMeasure object which summarizes the whole
 * YDataSet. In includes the following information:
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
-(YMeasure*) get_summary
{
    return _summary;
}

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
-(NSMutableArray*) get_preview
{
    return _preview;
}

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
-(NSMutableArray*) get_measuresAt:(YMeasure*)measure
{
    double startUtcMs;
    YDataStream* stream;
    NSMutableArray* dataRows = [NSMutableArray array];
    NSMutableArray* measures = [NSMutableArray array];
    double tim;
    double itv;
    double end_;
    int nCols;
    int minCol;
    int avgCol;
    int maxCol;

    startUtcMs = [measure get_startTimeUTC] * 1000;
    stream = nil;
    for (YDataStream* _each  in _streams) {
        if (floor([_each get_realStartTimeUTC] *1000+0.5) == startUtcMs) {
            stream = _each;
        }
    }
    if (stream == nil) {
        return measures;
    }
    dataRows = [stream get_dataRows];
    if ((int)[dataRows count] == 0) {
        return measures;
    }
    tim = floor([stream get_realStartTimeUTC] * 1000+0.5);
    itv = floor([stream get_dataSamplesInterval] * 1000+0.5);
    if (tim < itv) {
        tim = itv;
    }
    nCols = (int)[[dataRows objectAtIndex:0] count];
    minCol = 0;
    if (nCols > 2) {
        avgCol = 1;
    } else {
        avgCol = 0;
    }
    if (nCols > 2) {
        maxCol = 2;
    } else {
        maxCol = 0;
    }

    for (NSMutableArray* _each  in dataRows) {
        end_ = tim + itv;
        if ((end_ > _startTimeMs) && ((_endTimeMs == 0) || (tim < _endTimeMs))) {
            [measures addObject:ARC_sendAutorelease([[YMeasure alloc] initWith:tim / 1000.0 :end_ / 1000.0 :[[_each objectAtIndex:minCol] doubleValue] :[[_each objectAtIndex:avgCol] doubleValue] :[[_each objectAtIndex:maxCol] doubleValue]])];
        }
        tim = end_;
    }
    return measures;
}

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
-(NSMutableArray*) get_measures
{
    return _measures;
}

//--- (end of generated code: YDataSet public methods implementation)
@end


@implementation YConsolidatedDataSet

-(id)   initWith:(double)startTime :(double)endTime :(NSMutableArray*)sensorList
{
    if(!(self = [super init]))
        return nil;
//--- (generated code: YConsolidatedDataSet attributes initialization)
    _start = 0;
    _end = 0;
    _nsensors = 0;
    _sensors = [NSMutableArray array];
    _datasets = [NSMutableArray array];
    _progresss = [NSMutableArray array];
    _nextidx = [NSMutableArray array];
    _nexttim = [NSMutableArray array];
//--- (end of generated code: YConsolidatedDataSet attributes initialization)
    [self imm_init: startTime :endTime :sensorList];
    return self;
}

// destructor
-(void)  dealloc
{
//--- (generated code: YConsolidatedDataSet cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YConsolidatedDataSet cleanup)
}
//--- (generated code: YConsolidatedDataSet private methods implementation)

//--- (end of generated code: YConsolidatedDataSet private methods implementation)

//--- (generated code: YConsolidatedDataSet public methods implementation)
-(int) imm_init:(double)startt :(double)endt :(NSMutableArray*)sensorList
{
    _start = startt;
    _end = endt;
    _sensors = sensorList;
    _nsensors = -1;
    return YAPI_SUCCESS;
}

/**
 * Returns an object holding historical data for multiple
 * sensors, for a specified time interval.
 * The measures will be retrieved from the data logger, which must have been turned
 * on at the desired time. The resulting object makes it possible to load progressively
 * a large set of measures from multiple sensors, consolidating data on the fly
 * to align records based on measurement timestamps.
 *
 * @param sensorNames : array of logical names or hardware identifiers of the sensors
 *         for which data must be loaded from their data logger.
 * @param startTime : the start of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any measure, without initial limit.
 * @param endTime : the end of the desired measure time interval,
 *         as a Unix timestamp, i.e. the number of seconds since
 *         January 1, 1970 UTC. The special value 0 can be used
 *         to include any measure, without ending limit.
 *
 * @return an instance of YConsolidatedDataSet, providing access to
 *         consolidated historical data. Records can be loaded progressively
 *         using the YConsolidatedDataSet.nextRecord() method.
 */
+(YConsolidatedDataSet*) Init:(NSMutableArray*)sensorNames :(double)startTime :(double)endTime
{
    int nSensors;
    NSMutableArray* sensorList = [NSMutableArray array];
    int idx;
    NSString* sensorName;
    YSensor* s;
    YConsolidatedDataSet* obj;
    nSensors = (int)[sensorNames count];
    [sensorList removeAllObjects];
    idx = 0;
    while (idx < nSensors) {
        sensorName = [sensorNames objectAtIndex:idx];
        s = [YSensor FindSensor:sensorName];
        [sensorList addObject:s];
        idx = idx + 1;
    }
    obj = ARC_sendAutorelease([[YConsolidatedDataSet alloc] initWith:startTime :endTime :sensorList]);
    return obj;
}

/**
 * Extracts the next data record from the data logger of all sensors linked to this
 * object.
 *
 * @param datarec : array of floating point numbers, that will be filled by the
 *         function with the timestamp of the measure in first position,
 *         followed by the measured value in next positions.
 *
 * @return an integer in the range 0 to 100 (percentage of completion),
 *         or a negative error code in case of failure.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) nextRecord:(NSMutableArray*)datarec
{
    int s;
    int idx;
    YSensor* sensor;
    YDataSet* newdataset;
    int globprogress;
    int currprogress;
    double currnexttim;
    double newvalue;
    NSMutableArray* measures = [NSMutableArray array];
    double nexttime;
    //
    // Ensure the dataset have been retrieved
    //
    if (_nsensors == -1) {
        _nsensors = (int)[_sensors count];
        [_datasets removeAllObjects];
        [_progresss removeAllObjects];
        [_nextidx removeAllObjects];
        [_nexttim removeAllObjects];
        s = 0;
        while (s < _nsensors) {
            sensor = [_sensors objectAtIndex:s];
            newdataset = [sensor get_recordedData:_start :_end];
            [_datasets addObject:newdataset];
            [_progresss addObject:[NSNumber numberWithLong:0]];
            [_nextidx addObject:[NSNumber numberWithLong:0]];
            [_nexttim addObject:[NSNumber numberWithDouble:0.0]];
            s = s + 1;
        }
    }
    [datarec removeAllObjects];
    //
    // Find next timestamp to process
    //
    nexttime = 0;
    s = 0;
    while (s < _nsensors) {
        currnexttim = [[_nexttim objectAtIndex:s] doubleValue];
        if (currnexttim == 0) {
            idx = [[_nextidx objectAtIndex:s] intValue];
            measures = [((YDataSet*) [_datasets objectAtIndex:s]) get_measures];
            currprogress = [[_progresss objectAtIndex:s] intValue];
            while ((idx >= (int)[measures count]) && (currprogress < 100)) {
                currprogress = [((YDataSet*) [_datasets objectAtIndex:s]) loadMore];
                if (currprogress < 0) {
                    currprogress = 100;
                }
                [_progresss replaceObjectAtIndex: s withObject:[NSNumber numberWithLong:currprogress]];
                measures = [((YDataSet*) [_datasets objectAtIndex:s]) get_measures];
            }
            if (idx < (int)[measures count]) {
                currnexttim = [((YMeasure*) [measures objectAtIndex:idx]) get_endTimeUTC];
                [_nexttim replaceObjectAtIndex: s withObject:[NSNumber numberWithDouble:currnexttim]];
            }
        }
        if (currnexttim > 0) {
            if ((nexttime == 0) || (nexttime > currnexttim)) {
                nexttime = currnexttim;
            }
        }
        s = s + 1;
    }
    if (nexttime == 0) {
        return 100;
    }
    //
    // Extract data for self timestamp
    //
    [datarec removeAllObjects];
    [datarec addObject:[NSNumber numberWithDouble:nexttime]];
    globprogress = 0;
    s = 0;
    while (s < _nsensors) {
        if ([[_nexttim objectAtIndex:s] doubleValue] == nexttime) {
            idx = [[_nextidx objectAtIndex:s] intValue];
            measures = [((YDataSet*) [_datasets objectAtIndex:s]) get_measures];
            newvalue = [((YMeasure*) [measures objectAtIndex:idx]) get_averageValue];
            [datarec addObject:[NSNumber numberWithDouble:newvalue]];
            [_nexttim replaceObjectAtIndex: s withObject:[NSNumber numberWithDouble:0.0]];
            [_nextidx replaceObjectAtIndex: s withObject:[NSNumber numberWithLong:idx + 1]];
        } else {
            [datarec addObject:[NSNumber numberWithDouble:NAN]];
        }
        currprogress = [[_progresss objectAtIndex:s] intValue];
        globprogress = globprogress + currprogress;
        s = s + 1;
    }
    if (globprogress > 0) {
        globprogress = ((globprogress) / (_nsensors));
        if (globprogress > 99) {
            globprogress = 99;
        }
    }
    return globprogress;
}

//--- (end of generated code: YConsolidatedDataSet public methods implementation)
@end


@implementation YDataLogger

// Constructor is protected, use yFindDataLogger factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"DataLogger";
//--- (generated code: YDataLogger attributes initialization)
    _currentRunIndex = Y_CURRENTRUNINDEX_INVALID;
    _timeUTC = Y_TIMEUTC_INVALID;
    _recording = Y_RECORDING_INVALID;
    _autoStart = Y_AUTOSTART_INVALID;
    _beaconDriven = Y_BEACONDRIVEN_INVALID;
    _usage = Y_USAGE_INVALID;
    _clearHistory = Y_CLEARHISTORY_INVALID;
    _valueCallbackDataLogger = NULL;
//--- (end of generated code: YDataLogger attributes initialization)
    _dataLoggerURL =  @"/logger.json";
    return self;
}



-(void) dealloc
{
//--- (generated code: YDataLogger cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YDataLogger cleanup)
}
//--- (generated code: YDataLogger private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "currentRunIndex")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _currentRunIndex =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "timeUTC")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _timeUTC =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "recording")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _recording =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "autoStart")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _autoStart =  (Y_AUTOSTART_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "beaconDriven")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _beaconDriven =  (Y_BEACONDRIVEN_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "usage")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _usage =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "clearHistory")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _clearHistory =  (Y_CLEARHISTORY_enum)atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YDataLogger private methods implementation)

// DataLogger-specific method to retrieve and pre-parse recorded data
//
-(int) _getData:(unsigned)runIdx  :(unsigned)timeIdx :(NSString**) buffer :(yJsonStateMachine*) j
{
    YDevice     *dev;
    NSMutableData      *raw_buffer;
    NSString    *query;
    NSError     *error;
    int         res;

    // Resolve our reference to our device, load REST API
    res = [self _getDevice:&dev: &error ];
    if(YISERR(res)) {
        [self _throw:error];
        return res;
    }
    if(timeIdx) {
        query =[NSString stringWithFormat:@"GET %@?run=%u&time=%u HTTP/1.1\r\n\r\n",_dataLoggerURL, runIdx, timeIdx];
    } else {
        query =[NSString stringWithFormat:@"GET %@ HTTP/1.1\r\n\r\n",_dataLoggerURL];
    }
    res = [dev HTTPRequest:query :&raw_buffer: &error ];
    if(YISERR(res)) {
        // Check if an update of the device list does not solve the issue
        res = [YapiWrapper updateDeviceList:1:&error ];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }
        res = [dev HTTPRequest:query:&raw_buffer:&error];
        if(YISERR(res)) {
            [self _throw:error];
            return res;
        }
    }
    *buffer = [[NSString alloc] initWithData:raw_buffer encoding:NSISOLatin1StringEncoding];
    ARC_autorelease(*buffer);
    // Parse HTTP header
    j->src = STR_oc2y(*buffer);
    j->end = j->src + strlen(j->src);
    j->st = YJSON_HTTP_START;
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_HTTP_READ_CODE) {
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Failed to parse HTTP header");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }
    if(![STR_y2oc(j->token) isEqualToString:@"200"]) {
        if([STR_y2oc(j->token) isEqualToString:@"404"] &&
           ![_dataLoggerURL isEqualToString:@"/dataLogger.json"]) {
            // retry using backward-compatible datalogger URL
            _dataLoggerURL =@"/dataLogger.json";
            return [self _getData:runIdx :timeIdx :buffer :j];
        }

        NSString *tmp = [[NSString alloc] initWithFormat:@"Unexpected HTTP return code: %s",j->token];
        NSError  *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,STR_oc2y(tmp));
        [self _throw:error];
        ARC_release(tmp);
        return YAPI_IO_ERROR;
    }
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_HTTP_READ_MSG) {
        NSError *error;
        yFormatRetVal(&error,YAPI_IO_ERROR,"Unexpected HTTP header format");
        [self _throw:error];
        return YAPI_IO_ERROR;
    }

    return YAPI_SUCCESS;
}


//--- (generated code: YDataLogger public methods implementation)
/**
 * Returns the current run number, corresponding to the number of times the module was
 * powered on with the dataLogger enabled at some point.
 *
 * @return an integer corresponding to the current run number, corresponding to the number of times the module was
 *         powered on with the dataLogger enabled at some point
 *
 * On failure, throws an exception or returns YDataLogger.CURRENTRUNINDEX_INVALID.
 */
-(int) get_currentRunIndex
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CURRENTRUNINDEX_INVALID;
        }
    }
    res = _currentRunIndex;
    return res;
}


-(int) currentRunIndex
{
    return [self get_currentRunIndex];
}
/**
 * Returns the Unix timestamp for current UTC time, if known.
 *
 * @return an integer corresponding to the Unix timestamp for current UTC time, if known
 *
 * On failure, throws an exception or returns YDataLogger.TIMEUTC_INVALID.
 */
-(s64) get_timeUTC
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_TIMEUTC_INVALID;
        }
    }
    res = _timeUTC;
    return res;
}


-(s64) timeUTC
{
    return [self get_timeUTC];
}

/**
 * Changes the current UTC time reference used for recorded data.
 *
 * @param newval : an integer corresponding to the current UTC time reference used for recorded data
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_timeUTC:(s64) newval
{
    return [self setTimeUTC:newval];
}
-(int) setTimeUTC:(s64) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%u", (u32)newval];
    return [self _setAttr:@"timeUTC" :rest_val];
}
/**
 * Returns the current activation state of the data logger.
 *
 * @return a value among YDataLogger.RECORDING_OFF, YDataLogger.RECORDING_ON and
 * YDataLogger.RECORDING_PENDING corresponding to the current activation state of the data logger
 *
 * On failure, throws an exception or returns YDataLogger.RECORDING_INVALID.
 */
-(Y_RECORDING_enum) get_recording
{
    Y_RECORDING_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_RECORDING_INVALID;
        }
    }
    res = _recording;
    return res;
}


-(Y_RECORDING_enum) recording
{
    return [self get_recording];
}

/**
 * Changes the activation state of the data logger to start/stop recording data.
 *
 * @param newval : a value among YDataLogger.RECORDING_OFF, YDataLogger.RECORDING_ON and
 * YDataLogger.RECORDING_PENDING corresponding to the activation state of the data logger to
 * start/stop recording data
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_recording:(Y_RECORDING_enum) newval
{
    return [self setRecording:newval];
}
-(int) setRecording:(Y_RECORDING_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"recording" :rest_val];
}
/**
 * Returns the default activation state of the data logger on power up.
 *
 * @return either YDataLogger.AUTOSTART_OFF or YDataLogger.AUTOSTART_ON, according to the default
 * activation state of the data logger on power up
 *
 * On failure, throws an exception or returns YDataLogger.AUTOSTART_INVALID.
 */
-(Y_AUTOSTART_enum) get_autoStart
{
    Y_AUTOSTART_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_AUTOSTART_INVALID;
        }
    }
    res = _autoStart;
    return res;
}


-(Y_AUTOSTART_enum) autoStart
{
    return [self get_autoStart];
}

/**
 * Changes the default activation state of the data logger on power up.
 * Do not forget to call the saveToFlash() method of the module to save the
 * configuration change.  Note: if the device doesn't have any time source at his disposal when
 * starting up, it will wait for ~8 seconds before automatically starting to record  with
 * an arbitrary timestamp
 *
 * @param newval : either YDataLogger.AUTOSTART_OFF or YDataLogger.AUTOSTART_ON, according to the
 * default activation state of the data logger on power up
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_autoStart:(Y_AUTOSTART_enum) newval
{
    return [self setAutoStart:newval];
}
-(int) setAutoStart:(Y_AUTOSTART_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"autoStart" :rest_val];
}
/**
 * Returns true if the data logger is synchronised with the localization beacon.
 *
 * @return either YDataLogger.BEACONDRIVEN_OFF or YDataLogger.BEACONDRIVEN_ON, according to true if
 * the data logger is synchronised with the localization beacon
 *
 * On failure, throws an exception or returns YDataLogger.BEACONDRIVEN_INVALID.
 */
-(Y_BEACONDRIVEN_enum) get_beaconDriven
{
    Y_BEACONDRIVEN_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_BEACONDRIVEN_INVALID;
        }
    }
    res = _beaconDriven;
    return res;
}


-(Y_BEACONDRIVEN_enum) beaconDriven
{
    return [self get_beaconDriven];
}

/**
 * Changes the type of synchronisation of the data logger.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : either YDataLogger.BEACONDRIVEN_OFF or YDataLogger.BEACONDRIVEN_ON, according to
 * the type of synchronisation of the data logger
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_beaconDriven:(Y_BEACONDRIVEN_enum) newval
{
    return [self setBeaconDriven:newval];
}
-(int) setBeaconDriven:(Y_BEACONDRIVEN_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"beaconDriven" :rest_val];
}
/**
 * Returns the percentage of datalogger memory in use.
 *
 * @return an integer corresponding to the percentage of datalogger memory in use
 *
 * On failure, throws an exception or returns YDataLogger.USAGE_INVALID.
 */
-(int) get_usage
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_USAGE_INVALID;
        }
    }
    res = _usage;
    return res;
}


-(int) usage
{
    return [self get_usage];
}
-(Y_CLEARHISTORY_enum) get_clearHistory
{
    Y_CLEARHISTORY_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_CLEARHISTORY_INVALID;
        }
    }
    res = _clearHistory;
    return res;
}


-(Y_CLEARHISTORY_enum) clearHistory
{
    return [self get_clearHistory];
}

-(int) set_clearHistory:(Y_CLEARHISTORY_enum) newval
{
    return [self setClearHistory:newval];
}
-(int) setClearHistory:(Y_CLEARHISTORY_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"clearHistory" :rest_val];
}
/**
 * Retrieves a data logger for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the data logger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YDataLogger.isOnline() to test if the data logger is
 * indeed online at a given time. In case of ambiguity when looking for
 * a data logger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the data logger, for instance
 *         LIGHTMK4.dataLogger.
 *
 * @return a YDataLogger object allowing you to drive the data logger.
 */
+(YDataLogger*) FindDataLogger:(NSString*)func
{
    YDataLogger* obj;
    obj = (YDataLogger*) [YFunction _FindFromCache:@"DataLogger" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YDataLogger alloc] initWith:func]);
        [YFunction _AddToCache:@"DataLogger" : func :obj];
    }
    return obj;
}

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
-(int) registerValueCallback:(YDataLoggerValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackDataLogger = callback;
    // Immediately invoke value callback with current value
    if (callback != NULL && [self isOnline]) {
        val = _advertisedValue;
        if (!([val isEqualToString:@""])) {
            [self _invokeValueCallback:val];
        }
    }
    return 0;
}

-(int) _invokeValueCallback:(NSString*)value
{
    if (_valueCallbackDataLogger != NULL) {
        _valueCallbackDataLogger(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Clears the data logger memory and discards all recorded data streams.
 * This method also resets the current run index to zero.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) forgetAllDataStreams
{
    return [self set_clearHistory:Y_CLEARHISTORY_TRUE];
}

/**
 * Returns a list of YDataSet objects that can be used to retrieve
 * all measures stored by the data logger.
 *
 * This function only works if the device uses a recent firmware,
 * as YDataSet objects are not supported by firmwares older than
 * version 13000.
 *
 * @return a list of YDataSet object.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_dataSets
{
    return [self parse_dataSets:[self _download:@"logger.json"]];
}

-(NSMutableArray*) parse_dataSets:(NSData*)json
{
    NSMutableArray* dslist = [NSMutableArray array];
    YDataSet* dataset;
    NSMutableArray* res = [NSMutableArray array];

    dslist = [self _json_get_array:json];
    [res removeAllObjects];
    for (NSString* _each  in dslist) {
        dataset = ARC_sendAutorelease([[YDataSet alloc] initWith:self]);
        [dataset _parse:_each];
        [res addObject:dataset];
    }
    return res;
}


-(YDataLogger*)   nextDataLogger
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YDataLogger FindDataLogger:hwid];
}

+(YDataLogger *) FirstDataLogger
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"DataLogger":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YDataLogger FindDataLogger:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YDataLogger public methods implementation)

@end

//--- (generated code: YDataLogger functions)

YDataLogger *yFindDataLogger(NSString* func)
{
    return [YDataLogger FindDataLogger:func];
}

YDataLogger *yFirstDataLogger(void)
{
    return [YDataLogger FirstDataLogger];
}

//--- (end of generated code: YDataLogger functions)



/**
 * Initializes the Yoctopuce programming library explicitly.
 * It is not strictly needed to call yInitAPI(), as the library is
 * automatically  initialized when calling yRegisterHub() for the
 * first time.
 *
 * When YAPI.DETECT_NONE is used as detection mode,
 * you must explicitly use yRegisterHub() to point the API to the
 * VirtualHub on which your devices are connected before trying to access them.
 *
 * @param mode : an integer corresponding to the type of automatic
 *         device detection to use. Possible values are
 *         YAPI.DETECT_NONE, YAPI.DETECT_USB, YAPI.DETECT_NET,
 *         and YAPI.DETECT_ALL.
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
YRETCODE yInitAPI(int mode, NSError** errmsg)
{ return [YAPI InitAPI:mode:errmsg]; }


/**
 * Waits for all pending communications with Yoctopuce devices to be
 * completed then frees dynamically allocated resources used by
 * the Yoctopuce library.
 *
 * From an operating system standpoint, it is generally not required to call
 * this function since the OS will automatically free allocated resources
 * once your program is completed. However there are two situations when
 * you may really want to use that function:
 *
 * - Free all dynamically allocated memory blocks in order to
 * track a memory leak.
 *
 * - Send commands to devices right before the end
 * of the program. Since commands are sent in an asynchronous way
 * the program could exit before all commands are effectively sent.
 *
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
 * it either fires the debugger or aborts (i.e. crash) the program.
 */
void yEnableExceptions(void)  { [YAPI EnableExceptions]; }

/**
 * Setup the Yoctopuce library to use modules connected on a given machine. Idealy this
 * call will be made once at the begining of your application.  The
 * parameter will determine how the API will work. Use the following values:
 *
 * <b>usb</b>: When the usb keyword is used, the API will work with
 * devices connected directly to the USB bus. Some programming languages such a JavaScript,
 * PHP, and Java don't provide direct access to USB hardware, so usb will
 * not work with these. In this case, use a VirtualHub or a networked YoctoHub (see below).
 *
 * <b><i>x.x.x.x</i></b> or <b><i>hostname</i></b>: The API will use the devices connected to the
 * host with the given IP address or hostname. That host can be a regular computer
 * running a <i>native VirtualHub</i>, a <i>VirtualHub for web</i> hosted on a server,
 * or a networked YoctoHub such as YoctoHub-Ethernet or
 * YoctoHub-Wireless. If you want to use the VirtualHub running on you local
 * computer, use the IP address 127.0.0.1. If the given IP is unresponsive, yRegisterHub
 * will not return until a time-out defined by ySetNetworkTimeout has elapsed.
 * However, it is possible to preventively test a connection  with yTestHub.
 * If you cannot afford a network time-out, you can use the non blocking yPregisterHub
 * function that will establish the connection as soon as it is available.
 *
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
 * You can call <i>RegisterHub</i> several times to connect to several machines. On
 * the other hand, it is useless and even counterproductive to call <i>RegisterHub</i>
 * with to same address multiple times during the life of the application.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
YRETCODE yRegisterHub(NSString * url, NSError** errmsg) { return [YAPI RegisterHub:url:errmsg]; }

/**
 * Fault-tolerant alternative to yRegisterHub(). This function has the same
 * purpose and same arguments as yRegisterHub(), but does not trigger
 * an error when the selected hub is not available at the time of the function call.
 * If the connexion cannot be established immediately, a background task will automatically
 * perform periodic retries. This makes it possible to register a network hub independently of the current
 * connectivity, and to try to contact it only when a device is actively needed.
 *
 * @param url : a string containing either "usb","callback" or the
 *         root URL of the hub to monitor
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
 * and to make the application aware of hot-plug events. However, since device
 * detection is quite a heavy process, UpdateDeviceList shouldn't be called more
 * than once every two seconds.
 *
 * @param errmsg : a string passed by reference to receive any error message.
 *
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
YRETCODE yHandleEvents(NSError** errmsg)
{ return [YAPI HandleEvents:errmsg];}

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
 * @return YAPI.SUCCESS when the call succeeds.
 *
 * On failure returns a negative error code.
 */
YRETCODE ySleep(unsigned ms_duration, NSError **errmsg)
{ return [YAPI Sleep:ms_duration:errmsg]; }


/**
 * (Objective-C only) Register an object that must follow the protocol YDeviceHotPlug. The methods
 * yDeviceArrival and yDeviceRemoval  will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param object : an object that must follow the protocol YAPIDelegate, or nil
 *         to unregister a previously registered  object.
 */

void ySetDelegate(id object)
{
    [YAPI SetDelegate:object];
}


/**
 * Returns the current value of a monotone millisecond-based time counter.
 * This counter can be used to compute delays in relation with
 * Yoctopuce devices, which also uses the millisecond as timebase.
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
 * a device is plugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param arrivalCallback : a procedure taking a YModule parameter, or nil
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceArrivalCallback(yDeviceUpdateCallback arrivalCallback)
{   [YAPI  RegisterDeviceArrivalCallback:arrivalCallback];}

/**
 * Register a callback function, to be called each time
 * a device is unplugged. This callback will be invoked while yUpdateDeviceList
 * is running. You will have to call this function on a regular basis.
 *
 * @param removalCallback : a procedure taking a YModule parameter, or nil
 *         to unregister a previously registered  callback.
 */
void    yRegisterDeviceRemovalCallback(yDeviceUpdateCallback removalCallback)
{   [YAPI  RegisterDeviceRemovalCallback:removalCallback];}
void    yRegisterDeviceChangeCallback(yDeviceUpdateCallback changeCallback)
{   [YAPI  RegisterDeviceChangeCallback:changeCallback];}

/**
 * Registers a log callback function. This callback will be called each time
 * the API have something to say. Quite useful to debug the API.
 *
 * @param logfun : a procedure taking a string parameter, or nil
 *         to unregister a previously registered  callback.
 */
void    yRegisterLogFunction(yLogCallback logfun)
{   [YAPI  RegisterLogFunction:logfun];}



//--- (generated code: YFunction functions)

YFunction *yFindFunction(NSString* func)
{
    return [YFunction FindFunction:func];
}

YFunction *yFirstFunction(void)
{
    return [YFunction FirstFunction];
}

//--- (end of generated code: YFunction functions)

//--- (generated code: YSensor functions)

YSensor *yFindSensor(NSString* func)
{
    return [YSensor FindSensor:func];
}

YSensor *yFirstSensor(void)
{
    return [YSensor FirstSensor];
}

//--- (end of generated code: YSensor functions)

//--- (generated code: YModule functions)

YModule *yFindModule(NSString* func)
{
    return [YModule FindModule:func];
}

YModule *yFirstModule(void)
{
    return [YModule FirstModule];
}

//--- (end of generated code: YModule functions)

//--- (generated code: YDataStream functions)
//--- (end of generated code: YDataStream functions)
//--- (generated code: YMeasure functions)
//--- (end of generated code: YMeasure functions)

//--- (generated code: YDataSet functions)
//--- (end of generated code: YDataSet functions)

