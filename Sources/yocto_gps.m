/*********************************************************************
 *
 *  $Id: yocto_gps.m 32610 2018-10-10 06:52:20Z seb $
 *
 *  Implements the high-level API for Gps functions
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


#import "yocto_gps.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"



@implementation YGps

// Constructor is protected, use yFindGps factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"Gps";
//--- (YGps attributes initialization)
    _isFixed = Y_ISFIXED_INVALID;
    _satCount = Y_SATCOUNT_INVALID;
    _coordSystem = Y_COORDSYSTEM_INVALID;
    _latitude = Y_LATITUDE_INVALID;
    _longitude = Y_LONGITUDE_INVALID;
    _dilution = Y_DILUTION_INVALID;
    _altitude = Y_ALTITUDE_INVALID;
    _groundSpeed = Y_GROUNDSPEED_INVALID;
    _direction = Y_DIRECTION_INVALID;
    _unixTime = Y_UNIXTIME_INVALID;
    _dateTime = Y_DATETIME_INVALID;
    _utcOffset = Y_UTCOFFSET_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackGps = NULL;
//--- (end of YGps attributes initialization)
    return self;
}
//--- (YGps yapiwrapper)
//--- (end of YGps yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YGps cleanup)
    ARC_release(_latitude);
    _latitude = nil;
    ARC_release(_longitude);
    _longitude = nil;
    ARC_release(_dateTime);
    _dateTime = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YGps cleanup)
}
//--- (YGps private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "isFixed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _isFixed =  (Y_ISFIXED_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "satCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _satCount =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "coordSystem")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _coordSystem =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "latitude")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_latitude);
        _latitude =  [self _parseString:j];
        ARC_retain(_latitude);
        return 1;
    }
    if(!strcmp(j->token, "longitude")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_longitude);
        _longitude =  [self _parseString:j];
        ARC_retain(_longitude);
        return 1;
    }
    if(!strcmp(j->token, "dilution")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _dilution =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "altitude")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _altitude =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "groundSpeed")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _groundSpeed =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "direction")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _direction =  floor(atof(j->token) * 1000.0 / 65536.0 + 0.5) / 1000.0;
        return 1;
    }
    if(!strcmp(j->token, "unixTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _unixTime =  atol(j->token);
        return 1;
    }
    if(!strcmp(j->token, "dateTime")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_dateTime);
        _dateTime =  [self _parseString:j];
        ARC_retain(_dateTime);
        return 1;
    }
    if(!strcmp(j->token, "utcOffset")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _utcOffset =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "command")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_command);
        _command =  [self _parseString:j];
        ARC_retain(_command);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of YGps private methods implementation)
//--- (YGps public methods implementation)
/**
 * Returns TRUE if the receiver has found enough satellites to work.
 *
 * @return either Y_ISFIXED_FALSE or Y_ISFIXED_TRUE, according to TRUE if the receiver has found
 * enough satellites to work
 *
 * On failure, throws an exception or returns Y_ISFIXED_INVALID.
 */
-(Y_ISFIXED_enum) get_isFixed
{
    Y_ISFIXED_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ISFIXED_INVALID;
        }
    }
    res = _isFixed;
    return res;
}


-(Y_ISFIXED_enum) isFixed
{
    return [self get_isFixed];
}
/**
 * Returns the count of visible satellites.
 *
 * @return an integer corresponding to the count of visible satellites
 *
 * On failure, throws an exception or returns Y_SATCOUNT_INVALID.
 */
-(s64) get_satCount
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_SATCOUNT_INVALID;
        }
    }
    res = _satCount;
    return res;
}


-(s64) satCount
{
    return [self get_satCount];
}
/**
 * Returns the representation system used for positioning data.
 *
 * @return a value among Y_COORDSYSTEM_GPS_DMS, Y_COORDSYSTEM_GPS_DM and Y_COORDSYSTEM_GPS_D
 * corresponding to the representation system used for positioning data
 *
 * On failure, throws an exception or returns Y_COORDSYSTEM_INVALID.
 */
-(Y_COORDSYSTEM_enum) get_coordSystem
{
    Y_COORDSYSTEM_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COORDSYSTEM_INVALID;
        }
    }
    res = _coordSystem;
    return res;
}


-(Y_COORDSYSTEM_enum) coordSystem
{
    return [self get_coordSystem];
}

/**
 * Changes the representation system used for positioning data.
 *
 * @param newval : a value among Y_COORDSYSTEM_GPS_DMS, Y_COORDSYSTEM_GPS_DM and Y_COORDSYSTEM_GPS_D
 * corresponding to the representation system used for positioning data
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_coordSystem:(Y_COORDSYSTEM_enum) newval
{
    return [self setCoordSystem:newval];
}
-(int) setCoordSystem:(Y_COORDSYSTEM_enum) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"coordSystem" :rest_val];
}
/**
 * Returns the current latitude.
 *
 * @return a string corresponding to the current latitude
 *
 * On failure, throws an exception or returns Y_LATITUDE_INVALID.
 */
-(NSString*) get_latitude
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LATITUDE_INVALID;
        }
    }
    res = _latitude;
    return res;
}


-(NSString*) latitude
{
    return [self get_latitude];
}
/**
 * Returns the current longitude.
 *
 * @return a string corresponding to the current longitude
 *
 * On failure, throws an exception or returns Y_LONGITUDE_INVALID.
 */
-(NSString*) get_longitude
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LONGITUDE_INVALID;
        }
    }
    res = _longitude;
    return res;
}


-(NSString*) longitude
{
    return [self get_longitude];
}
/**
 * Returns the current horizontal dilution of precision,
 * the smaller that number is, the better .
 *
 * @return a floating point number corresponding to the current horizontal dilution of precision,
 *         the smaller that number is, the better
 *
 * On failure, throws an exception or returns Y_DILUTION_INVALID.
 */
-(double) get_dilution
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DILUTION_INVALID;
        }
    }
    res = _dilution;
    return res;
}


-(double) dilution
{
    return [self get_dilution];
}
/**
 * Returns the current altitude. Beware:  GPS technology
 * is very inaccurate regarding altitude.
 *
 * @return a floating point number corresponding to the current altitude
 *
 * On failure, throws an exception or returns Y_ALTITUDE_INVALID.
 */
-(double) get_altitude
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_ALTITUDE_INVALID;
        }
    }
    res = _altitude;
    return res;
}


-(double) altitude
{
    return [self get_altitude];
}
/**
 * Returns the current ground speed in Km/h.
 *
 * @return a floating point number corresponding to the current ground speed in Km/h
 *
 * On failure, throws an exception or returns Y_GROUNDSPEED_INVALID.
 */
-(double) get_groundSpeed
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_GROUNDSPEED_INVALID;
        }
    }
    res = _groundSpeed;
    return res;
}


-(double) groundSpeed
{
    return [self get_groundSpeed];
}
/**
 * Returns the current move bearing in degrees, zero
 * is the true (geographic) north.
 *
 * @return a floating point number corresponding to the current move bearing in degrees, zero
 *         is the true (geographic) north
 *
 * On failure, throws an exception or returns Y_DIRECTION_INVALID.
 */
-(double) get_direction
{
    double res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DIRECTION_INVALID;
        }
    }
    res = _direction;
    return res;
}


-(double) direction
{
    return [self get_direction];
}
/**
 * Returns the current time in Unix format (number of
 * seconds elapsed since Jan 1st, 1970).
 *
 * @return an integer corresponding to the current time in Unix format (number of
 *         seconds elapsed since Jan 1st, 1970)
 *
 * On failure, throws an exception or returns Y_UNIXTIME_INVALID.
 */
-(s64) get_unixTime
{
    s64 res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_UNIXTIME_INVALID;
        }
    }
    res = _unixTime;
    return res;
}


-(s64) unixTime
{
    return [self get_unixTime];
}
/**
 * Returns the current time in the form "YYYY/MM/DD hh:mm:ss".
 *
 * @return a string corresponding to the current time in the form "YYYY/MM/DD hh:mm:ss"
 *
 * On failure, throws an exception or returns Y_DATETIME_INVALID.
 */
-(NSString*) get_dateTime
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_DATETIME_INVALID;
        }
    }
    res = _dateTime;
    return res;
}


-(NSString*) dateTime
{
    return [self get_dateTime];
}
/**
 * Returns the number of seconds between current time and UTC time (time zone).
 *
 * @return an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * On failure, throws an exception or returns Y_UTCOFFSET_INVALID.
 */
-(int) get_utcOffset
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_UTCOFFSET_INVALID;
        }
    }
    res = _utcOffset;
    return res;
}


-(int) utcOffset
{
    return [self get_utcOffset];
}

/**
 * Changes the number of seconds between current time and UTC time (time zone).
 * The timezone is automatically rounded to the nearest multiple of 15 minutes.
 * If current UTC time is known, the current time is automatically be updated according to the selected time zone.
 *
 * @param newval : an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_utcOffset:(int) newval
{
    return [self setUtcOffset:newval];
}
-(int) setUtcOffset:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"utcOffset" :rest_val];
}
-(NSString*) get_command
{
    NSString* res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    res = _command;
    return res;
}


-(NSString*) command
{
    return [self get_command];
}

-(int) set_command:(NSString*) newval
{
    return [self setCommand:newval];
}
-(int) setCommand:(NSString*) newval
{
    NSString* rest_val;
    rest_val = newval;
    return [self _setAttr:@"command" :rest_val];
}
/**
 * Retrieves a GPS for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the GPS is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YGps.isOnline() to test if the GPS is
 * indeed online at a given time. In case of ambiguity when looking for
 * a GPS by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the GPS
 *
 * @return a YGps object allowing you to drive the GPS.
 */
+(YGps*) FindGps:(NSString*)func
{
    YGps* obj;
    obj = (YGps*) [YFunction _FindFromCache:@"Gps" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YGps alloc] initWith:func]);
        [YFunction _AddToCache:@"Gps" : func :obj];
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
-(int) registerValueCallback:(YGpsValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackGps = callback;
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
    if (_valueCallbackGps != NULL) {
        _valueCallbackGps(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}


-(YGps*)   nextGps
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YGps FindGps:hwid];
}

+(YGps *) FirstGps
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Gps":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YGps FindGps:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YGps public methods implementation)

@end
//--- (YGps functions)

YGps *yFindGps(NSString* func)
{
    return [YGps FindGps:func];
}

YGps *yFirstGps(void)
{
    return [YGps FirstGps];
}

//--- (end of YGps functions)
