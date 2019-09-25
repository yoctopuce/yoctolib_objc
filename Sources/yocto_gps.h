/*********************************************************************
 *
 *  $Id: yocto_gps.h 37165 2019-09-13 16:57:27Z mvuilleu $
 *
 *  Declares yFindGps(), the high-level API for Gps functions
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

@class YGps;

//--- (YGps globals)
typedef void (*YGpsValueCallback)(YGps *func, NSString *functionValue);
#ifndef _Y_ISFIXED_ENUM
#define _Y_ISFIXED_ENUM
typedef enum {
    Y_ISFIXED_FALSE = 0,
    Y_ISFIXED_TRUE = 1,
    Y_ISFIXED_INVALID = -1,
} Y_ISFIXED_enum;
#endif
#ifndef _Y_COORDSYSTEM_ENUM
#define _Y_COORDSYSTEM_ENUM
typedef enum {
    Y_COORDSYSTEM_GPS_DMS = 0,
    Y_COORDSYSTEM_GPS_DM = 1,
    Y_COORDSYSTEM_GPS_D = 2,
    Y_COORDSYSTEM_INVALID = -1,
} Y_COORDSYSTEM_enum;
#endif
#ifndef _Y_CONSTELLATION_ENUM
#define _Y_CONSTELLATION_ENUM
typedef enum {
    Y_CONSTELLATION_GPS = 0,
    Y_CONSTELLATION_GLONASS = 1,
    Y_CONSTELLATION_GALLILEO = 2,
    Y_CONSTELLATION_GNSS = 3,
    Y_CONSTELLATION_GPS_GLONASS = 4,
    Y_CONSTELLATION_GPS_GALLILEO = 5,
    Y_CONSTELLATION_GLONASS_GALLELIO = 6,
    Y_CONSTELLATION_INVALID = -1,
} Y_CONSTELLATION_enum;
#endif
#define Y_SATCOUNT_INVALID              YAPI_INVALID_LONG
#define Y_LATITUDE_INVALID              YAPI_INVALID_STRING
#define Y_LONGITUDE_INVALID             YAPI_INVALID_STRING
#define Y_DILUTION_INVALID              YAPI_INVALID_DOUBLE
#define Y_ALTITUDE_INVALID              YAPI_INVALID_DOUBLE
#define Y_GROUNDSPEED_INVALID           YAPI_INVALID_DOUBLE
#define Y_DIRECTION_INVALID             YAPI_INVALID_DOUBLE
#define Y_UNIXTIME_INVALID              YAPI_INVALID_LONG
#define Y_DATETIME_INVALID              YAPI_INVALID_STRING
#define Y_UTCOFFSET_INVALID             YAPI_INVALID_INT
#define Y_COMMAND_INVALID               YAPI_INVALID_STRING
//--- (end of YGps globals)

//--- (YGps class start)
/**
 * YGps Class: GPS function interface
 *
 * The GPS function allows you to extract positioning
 * data from the GPS device. This class can provides
 * complete positioning information: However, if you
 * wish to define callbacks on position changes, you
 * should use the YLatitude et YLongitude classes.
 */
@interface YGps : YFunction
//--- (end of YGps class start)
{
@protected
//--- (YGps attributes declaration)
    Y_ISFIXED_enum  _isFixed;
    s64             _satCount;
    Y_COORDSYSTEM_enum _coordSystem;
    Y_CONSTELLATION_enum _constellation;
    NSString*       _latitude;
    NSString*       _longitude;
    double          _dilution;
    double          _altitude;
    double          _groundSpeed;
    double          _direction;
    s64             _unixTime;
    NSString*       _dateTime;
    int             _utcOffset;
    NSString*       _command;
    YGpsValueCallback _valueCallbackGps;
//--- (end of YGps attributes declaration)
}
// Constructor is protected, use yFindGps factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YGps private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YGps private methods declaration)
//--- (YGps yapiwrapper declaration)
//--- (end of YGps yapiwrapper declaration)
//--- (YGps public methods declaration)
/**
 * Returns TRUE if the receiver has found enough satellites to work.
 *
 * @return either Y_ISFIXED_FALSE or Y_ISFIXED_TRUE, according to TRUE if the receiver has found
 * enough satellites to work
 *
 * On failure, throws an exception or returns Y_ISFIXED_INVALID.
 */
-(Y_ISFIXED_enum)     get_isFixed;


-(Y_ISFIXED_enum) isFixed;
/**
 * Returns the count of visible satellites.
 *
 * @return an integer corresponding to the count of visible satellites
 *
 * On failure, throws an exception or returns Y_SATCOUNT_INVALID.
 */
-(s64)     get_satCount;


-(s64) satCount;
/**
 * Returns the representation system used for positioning data.
 *
 * @return a value among Y_COORDSYSTEM_GPS_DMS, Y_COORDSYSTEM_GPS_DM and Y_COORDSYSTEM_GPS_D
 * corresponding to the representation system used for positioning data
 *
 * On failure, throws an exception or returns Y_COORDSYSTEM_INVALID.
 */
-(Y_COORDSYSTEM_enum)     get_coordSystem;


-(Y_COORDSYSTEM_enum) coordSystem;
/**
 * Changes the representation system used for positioning data.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : a value among Y_COORDSYSTEM_GPS_DMS, Y_COORDSYSTEM_GPS_DM and Y_COORDSYSTEM_GPS_D
 * corresponding to the representation system used for positioning data
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_coordSystem:(Y_COORDSYSTEM_enum) newval;
-(int)     setCoordSystem:(Y_COORDSYSTEM_enum) newval;

/**
 * Returns the the satellites constellation used to compute
 * positioning data.
 *
 * @return a value among Y_CONSTELLATION_GPS, Y_CONSTELLATION_GLONASS, Y_CONSTELLATION_GALLILEO,
 * Y_CONSTELLATION_GNSS, Y_CONSTELLATION_GPS_GLONASS, Y_CONSTELLATION_GPS_GALLILEO and
 * Y_CONSTELLATION_GLONASS_GALLELIO corresponding to the the satellites constellation used to compute
 *         positioning data
 *
 * On failure, throws an exception or returns Y_CONSTELLATION_INVALID.
 */
-(Y_CONSTELLATION_enum)     get_constellation;


-(Y_CONSTELLATION_enum) constellation;
/**
 * Changes the satellites constellation used to compute
 * positioning data. Possible  constellations are GPS, Glonass, Galileo ,
 * GNSS ( = GPS + Glonass + Galileo) and the 3 possible pairs. This seeting has effect on Yocto-GPS rev A.
 *
 * @param newval : a value among Y_CONSTELLATION_GPS, Y_CONSTELLATION_GLONASS,
 * Y_CONSTELLATION_GALLILEO, Y_CONSTELLATION_GNSS, Y_CONSTELLATION_GPS_GLONASS,
 * Y_CONSTELLATION_GPS_GALLILEO and Y_CONSTELLATION_GLONASS_GALLELIO corresponding to the satellites
 * constellation used to compute
 *         positioning data
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_constellation:(Y_CONSTELLATION_enum) newval;
-(int)     setConstellation:(Y_CONSTELLATION_enum) newval;

/**
 * Returns the current latitude.
 *
 * @return a string corresponding to the current latitude
 *
 * On failure, throws an exception or returns Y_LATITUDE_INVALID.
 */
-(NSString*)     get_latitude;


-(NSString*) latitude;
/**
 * Returns the current longitude.
 *
 * @return a string corresponding to the current longitude
 *
 * On failure, throws an exception or returns Y_LONGITUDE_INVALID.
 */
-(NSString*)     get_longitude;


-(NSString*) longitude;
/**
 * Returns the current horizontal dilution of precision,
 * the smaller that number is, the better .
 *
 * @return a floating point number corresponding to the current horizontal dilution of precision,
 *         the smaller that number is, the better
 *
 * On failure, throws an exception or returns Y_DILUTION_INVALID.
 */
-(double)     get_dilution;


-(double) dilution;
/**
 * Returns the current altitude. Beware:  GPS technology
 * is very inaccurate regarding altitude.
 *
 * @return a floating point number corresponding to the current altitude
 *
 * On failure, throws an exception or returns Y_ALTITUDE_INVALID.
 */
-(double)     get_altitude;


-(double) altitude;
/**
 * Returns the current ground speed in Km/h.
 *
 * @return a floating point number corresponding to the current ground speed in Km/h
 *
 * On failure, throws an exception or returns Y_GROUNDSPEED_INVALID.
 */
-(double)     get_groundSpeed;


-(double) groundSpeed;
/**
 * Returns the current move bearing in degrees, zero
 * is the true (geographic) north.
 *
 * @return a floating point number corresponding to the current move bearing in degrees, zero
 *         is the true (geographic) north
 *
 * On failure, throws an exception or returns Y_DIRECTION_INVALID.
 */
-(double)     get_direction;


-(double) direction;
/**
 * Returns the current time in Unix format (number of
 * seconds elapsed since Jan 1st, 1970).
 *
 * @return an integer corresponding to the current time in Unix format (number of
 *         seconds elapsed since Jan 1st, 1970)
 *
 * On failure, throws an exception or returns Y_UNIXTIME_INVALID.
 */
-(s64)     get_unixTime;


-(s64) unixTime;
/**
 * Returns the current time in the form "YYYY/MM/DD hh:mm:ss".
 *
 * @return a string corresponding to the current time in the form "YYYY/MM/DD hh:mm:ss"
 *
 * On failure, throws an exception or returns Y_DATETIME_INVALID.
 */
-(NSString*)     get_dateTime;


-(NSString*) dateTime;
/**
 * Returns the number of seconds between current time and UTC time (time zone).
 *
 * @return an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * On failure, throws an exception or returns Y_UTCOFFSET_INVALID.
 */
-(int)     get_utcOffset;


-(int) utcOffset;
/**
 * Changes the number of seconds between current time and UTC time (time zone).
 * The timezone is automatically rounded to the nearest multiple of 15 minutes.
 * If current UTC time is known, the current time is automatically be updated according to the selected time zone.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the number of seconds between current time and UTC time (time zone)
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_utcOffset:(int) newval;
-(int)     setUtcOffset:(int) newval;

-(NSString*)     get_command;


-(NSString*) command;
-(int)     set_command:(NSString*) newval;
-(int)     setCommand:(NSString*) newval;

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
+(YGps*)     FindGps:(NSString*)func;

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
-(int)     registerValueCallback:(YGpsValueCallback)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of GPS started using yFirstGps().
 * Caution: You can't make any assumption about the returned GPS order.
 * If you want to find a specific a GPS, use Gps.findGps()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YGps object, corresponding to
 *         a GPS currently online, or a nil pointer
 *         if there are no more GPS to enumerate.
 */
-(YGps*) nextGps;
/**
 * Starts the enumeration of GPS currently accessible.
 * Use the method YGps.nextGps() to iterate on
 * next GPS.
 *
 * @return a pointer to a YGps object, corresponding to
 *         the first GPS currently online, or a nil pointer
 *         if there are none.
 */
+(YGps*) FirstGps;
//--- (end of YGps public methods declaration)

@end

//--- (YGps functions declaration)
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
YGps* yFindGps(NSString* func);
/**
 * Starts the enumeration of GPS currently accessible.
 * Use the method YGps.nextGps() to iterate on
 * next GPS.
 *
 * @return a pointer to a YGps object, corresponding to
 *         the first GPS currently online, or a nil pointer
 *         if there are none.
 */
YGps* yFirstGps(void);

//--- (end of YGps functions declaration)
CF_EXTERN_C_END

