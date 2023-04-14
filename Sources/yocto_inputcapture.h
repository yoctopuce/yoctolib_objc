/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindInputCaptureData(), the high-level API for InputCaptureData functions
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

@class YInputCapture;

//--- (generated code: YInputCapture globals)
typedef void (*YInputCaptureValueCallback)(YInputCapture *func, NSString *functionValue);
#ifndef _Y_CAPTURETYPE_ENUM
#define _Y_CAPTURETYPE_ENUM
typedef enum {
    Y_CAPTURETYPE_NONE = 0,
    Y_CAPTURETYPE_TIMED = 1,
    Y_CAPTURETYPE_V_MAX = 2,
    Y_CAPTURETYPE_V_MIN = 3,
    Y_CAPTURETYPE_I_MAX = 4,
    Y_CAPTURETYPE_I_MIN = 5,
    Y_CAPTURETYPE_P_MAX = 6,
    Y_CAPTURETYPE_P_MIN = 7,
    Y_CAPTURETYPE_V_AVG_MAX = 8,
    Y_CAPTURETYPE_V_AVG_MIN = 9,
    Y_CAPTURETYPE_V_RMS_MAX = 10,
    Y_CAPTURETYPE_V_RMS_MIN = 11,
    Y_CAPTURETYPE_I_AVG_MAX = 12,
    Y_CAPTURETYPE_I_AVG_MIN = 13,
    Y_CAPTURETYPE_I_RMS_MAX = 14,
    Y_CAPTURETYPE_I_RMS_MIN = 15,
    Y_CAPTURETYPE_P_AVG_MAX = 16,
    Y_CAPTURETYPE_P_AVG_MIN = 17,
    Y_CAPTURETYPE_PF_MIN = 18,
    Y_CAPTURETYPE_DPF_MIN = 19,
    Y_CAPTURETYPE_INVALID = -1,
} Y_CAPTURETYPE_enum;
#endif
#ifndef _Y_CAPTURETYPEATSTARTUP_ENUM
#define _Y_CAPTURETYPEATSTARTUP_ENUM
typedef enum {
    Y_CAPTURETYPEATSTARTUP_NONE = 0,
    Y_CAPTURETYPEATSTARTUP_TIMED = 1,
    Y_CAPTURETYPEATSTARTUP_V_MAX = 2,
    Y_CAPTURETYPEATSTARTUP_V_MIN = 3,
    Y_CAPTURETYPEATSTARTUP_I_MAX = 4,
    Y_CAPTURETYPEATSTARTUP_I_MIN = 5,
    Y_CAPTURETYPEATSTARTUP_P_MAX = 6,
    Y_CAPTURETYPEATSTARTUP_P_MIN = 7,
    Y_CAPTURETYPEATSTARTUP_V_AVG_MAX = 8,
    Y_CAPTURETYPEATSTARTUP_V_AVG_MIN = 9,
    Y_CAPTURETYPEATSTARTUP_V_RMS_MAX = 10,
    Y_CAPTURETYPEATSTARTUP_V_RMS_MIN = 11,
    Y_CAPTURETYPEATSTARTUP_I_AVG_MAX = 12,
    Y_CAPTURETYPEATSTARTUP_I_AVG_MIN = 13,
    Y_CAPTURETYPEATSTARTUP_I_RMS_MAX = 14,
    Y_CAPTURETYPEATSTARTUP_I_RMS_MIN = 15,
    Y_CAPTURETYPEATSTARTUP_P_AVG_MAX = 16,
    Y_CAPTURETYPEATSTARTUP_P_AVG_MIN = 17,
    Y_CAPTURETYPEATSTARTUP_PF_MIN = 18,
    Y_CAPTURETYPEATSTARTUP_DPF_MIN = 19,
    Y_CAPTURETYPEATSTARTUP_INVALID = -1,
} Y_CAPTURETYPEATSTARTUP_enum;
#endif
#define Y_LASTCAPTURETIME_INVALID       YAPI_INVALID_LONG
#define Y_NSAMPLES_INVALID              YAPI_INVALID_UINT
#define Y_SAMPLINGRATE_INVALID          YAPI_INVALID_UINT
#define Y_CONDVALUE_INVALID             YAPI_INVALID_DOUBLE
#define Y_CONDALIGN_INVALID             YAPI_INVALID_UINT
#define Y_CONDVALUEATSTARTUP_INVALID    YAPI_INVALID_DOUBLE
//--- (end of generated code: YInputCapture globals)

#define Y_CAPTURETYPEALL_enum           Y_CAPTURETYPE_enum

//--- (generated code: YInputCaptureData globals)
//--- (end of generated code: YInputCaptureData globals)




//--- (generated code: YInputCaptureData class start)
/**
 * YInputCaptureData Class: Sampled data from a Yoctopuce electrical sensor
 *
 * InputCaptureData objects represent raw data
 * sampled by the analog/digital converter present in
 * a Yoctopuce electrical sensor. When several inputs
 * are samples simultaneously, their data are provided
 * as distinct series.
 */
@interface YInputCaptureData : NSObject
//--- (end of generated code: YInputCaptureData class start)
{
@protected
//--- (generated code: YInputCaptureData attributes declaration)
    int             _fmt;
    int             _var1size;
    int             _var2size;
    int             _var3size;
    int             _nVars;
    int             _recOfs;
    int             _nRecs;
    int             _samplesPerSec;
    int             _trigType;
    double          _trigVal;
    int             _trigPos;
    double          _trigUTC;
    NSString*       _var1unit;
    NSString*       _var2unit;
    NSString*       _var3unit;
    NSMutableArray* _var1samples;
    NSMutableArray* _var2samples;
    NSMutableArray* _var3samples;
//--- (end of generated code: YInputCaptureData attributes declaration)
}

-(id)   initWith:(YFunction *)yfun :(NSData*)sdata;

-(void)        _throw:(YRETCODE) errType withMsg:(const char*) errMsg;
-(void)        _throw:(YRETCODE) errType :(NSString*) errMsg;
-(void)        _throw: (NSError*) error;

//--- (generated code: YInputCaptureData private methods declaration)
//--- (end of generated code: YInputCaptureData private methods declaration)
//--- (generated code: YInputCaptureData public methods declaration)
-(int)     _decodeU16:(NSData*)sdata :(int)ofs;

-(double)     _decodeU32:(NSData*)sdata :(int)ofs;

-(double)     _decodeVal:(NSData*)sdata :(int)ofs :(int)len;

-(int)     _decodeSnapBin:(NSData*)sdata;

/**
 * Returns the number of series available in the capture.
 *
 * @return an integer corresponding to the number of
 *         simultaneous data series available.
 */
-(int)     get_serieCount;

/**
 * Returns the number of records captured (in a serie).
 * In the exceptional case where it was not possible
 * to transfer all data in time, the number of records
 * actually present in the series might be lower than
 * the number of records captured
 *
 * @return an integer corresponding to the number of
 *         records expected in each serie.
 */
-(int)     get_recordCount;

/**
 * Returns the effective sampling rate of the device.
 *
 * @return an integer corresponding to the number of
 *         samples taken each second.
 */
-(int)     get_samplingRate;

/**
 * Returns the type of automatic conditional capture
 * that triggered the capture of this data sequence.
 *
 * @return the type of conditional capture.
 */
-(Y_CAPTURETYPEALL_enum)     get_captureType;

/**
 * Returns the threshold value that triggered
 * this automatic conditional capture, if it was
 * not an instant captured triggered manually.
 *
 * @return the conditional threshold value
 *         at the time of capture.
 */
-(double)     get_triggerValue;

/**
 * Returns the index in the series of the sample
 * corresponding to the exact time when the capture
 * was triggered. In case of trigger based on average
 * or RMS value, the trigger index corresponds to
 * the end of the averaging period.
 *
 * @return an integer corresponding to a position
 *         in the data serie.
 */
-(int)     get_triggerPosition;

/**
 * Returns the absolute time when the capture was
 * triggered, as a Unix timestamp. Milliseconds are
 * included in this timestamp (floating-point number).
 *
 * @return a floating-point number corresponding to
 *         the number of seconds between the Jan 1,
 *         1970 and the moment where the capture
 *         was triggered.
 */
-(double)     get_triggerRealTimeUTC;

/**
 * Returns the unit of measurement for data points in
 * the first serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*)     get_serie1Unit;

/**
 * Returns the unit of measurement for data points in
 * the second serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*)     get_serie2Unit;

/**
 * Returns the unit of measurement for data points in
 * the third serie.
 *
 * @return a string containing to a physical unit of
 *         measurement.
 */
-(NSString*)     get_serie3Unit;

/**
 * Returns the sampled data corresponding to the first serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie1Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 1.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_serie1Values;

/**
 * Returns the sampled data corresponding to the second serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie2Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 2.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_serie2Values;

/**
 * Returns the sampled data corresponding to the third serie.
 * The corresponding physical unit can be obtained
 * using the method get_serie3Unit().
 *
 * @return a list of real numbers corresponding to all
 *         samples received for serie 3.
 *
 * On failure, throws an exception or returns an empty array.
 */
-(NSMutableArray*)     get_serie3Values;


//--- (end of generated code: YInputCaptureData public methods declaration)

@end

//--- (generated code: YInputCaptureData functions declaration)
//--- (end of generated code: YInputCaptureData functions declaration)

//--- (generated code: YInputCapture class start)
/**
 * YInputCapture Class: instant snapshot trigger control interface
 *
 * The YInputCapture class allows you to access data samples
 * measured by a Yoctopuce electrical sensor. The data capture can be
 * triggered manually, or be configured to detect specific events.
 */
@interface YInputCapture : YFunction
//--- (end of generated code: YInputCapture class start)
{
@protected
//--- (generated code: YInputCapture attributes declaration)
    s64             _lastCaptureTime;
    int             _nSamples;
    int             _samplingRate;
    Y_CAPTURETYPE_enum _captureType;
    double          _condValue;
    int             _condAlign;
    Y_CAPTURETYPEATSTARTUP_enum _captureTypeAtStartup;
    double          _condValueAtStartup;
    YInputCaptureValueCallback _valueCallbackInputCapture;
//--- (end of generated code: YInputCapture attributes declaration)
}
// Constructor is protected, use yFindI2cPort factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YInputCapture private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YInputCapture private methods declaration)
//--- (generated code: YInputCapture yapiwrapper declaration)
//--- (end of generated code: YInputCapture yapiwrapper declaration)
//--- (generated code: YInputCapture public methods declaration)
/**
 * Returns the number of elapsed milliseconds between the module power on
 * and the last capture (time of trigger), or zero if no capture has been done.
 *
 * @return an integer corresponding to the number of elapsed milliseconds between the module power on
 *         and the last capture (time of trigger), or zero if no capture has been done
 *
 * On failure, throws an exception or returns YInputCapture.LASTCAPTURETIME_INVALID.
 */
-(s64)     get_lastCaptureTime;


-(s64) lastCaptureTime;
/**
 * Returns the number of samples that will be captured.
 *
 * @return an integer corresponding to the number of samples that will be captured
 *
 * On failure, throws an exception or returns YInputCapture.NSAMPLES_INVALID.
 */
-(int)     get_nSamples;


-(int) nSamples;
/**
 * Changes the type of automatic conditional capture.
 * The maximum number of samples depends on the device memory.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : an integer corresponding to the type of automatic conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_nSamples:(int) newval;
-(int)     setNSamples:(int) newval;

/**
 * Returns the sampling frequency, in Hz.
 *
 * @return an integer corresponding to the sampling frequency, in Hz
 *
 * On failure, throws an exception or returns YInputCapture.SAMPLINGRATE_INVALID.
 */
-(int)     get_samplingRate;


-(int) samplingRate;
/**
 * Returns the type of automatic conditional capture.
 *
 * @return a value among YInputCapture.CAPTURETYPE_NONE, YInputCapture.CAPTURETYPE_TIMED,
 * YInputCapture.CAPTURETYPE_V_MAX, YInputCapture.CAPTURETYPE_V_MIN, YInputCapture.CAPTURETYPE_I_MAX,
 * YInputCapture.CAPTURETYPE_I_MIN, YInputCapture.CAPTURETYPE_P_MAX, YInputCapture.CAPTURETYPE_P_MIN,
 * YInputCapture.CAPTURETYPE_V_AVG_MAX, YInputCapture.CAPTURETYPE_V_AVG_MIN,
 * YInputCapture.CAPTURETYPE_V_RMS_MAX, YInputCapture.CAPTURETYPE_V_RMS_MIN,
 * YInputCapture.CAPTURETYPE_I_AVG_MAX, YInputCapture.CAPTURETYPE_I_AVG_MIN,
 * YInputCapture.CAPTURETYPE_I_RMS_MAX, YInputCapture.CAPTURETYPE_I_RMS_MIN,
 * YInputCapture.CAPTURETYPE_P_AVG_MAX, YInputCapture.CAPTURETYPE_P_AVG_MIN,
 * YInputCapture.CAPTURETYPE_PF_MIN and YInputCapture.CAPTURETYPE_DPF_MIN corresponding to the type of
 * automatic conditional capture
 *
 * On failure, throws an exception or returns YInputCapture.CAPTURETYPE_INVALID.
 */
-(Y_CAPTURETYPE_enum)     get_captureType;


-(Y_CAPTURETYPE_enum) captureType;
/**
 * Changes the type of automatic conditional capture.
 *
 * @param newval : a value among YInputCapture.CAPTURETYPE_NONE, YInputCapture.CAPTURETYPE_TIMED,
 * YInputCapture.CAPTURETYPE_V_MAX, YInputCapture.CAPTURETYPE_V_MIN, YInputCapture.CAPTURETYPE_I_MAX,
 * YInputCapture.CAPTURETYPE_I_MIN, YInputCapture.CAPTURETYPE_P_MAX, YInputCapture.CAPTURETYPE_P_MIN,
 * YInputCapture.CAPTURETYPE_V_AVG_MAX, YInputCapture.CAPTURETYPE_V_AVG_MIN,
 * YInputCapture.CAPTURETYPE_V_RMS_MAX, YInputCapture.CAPTURETYPE_V_RMS_MIN,
 * YInputCapture.CAPTURETYPE_I_AVG_MAX, YInputCapture.CAPTURETYPE_I_AVG_MIN,
 * YInputCapture.CAPTURETYPE_I_RMS_MAX, YInputCapture.CAPTURETYPE_I_RMS_MIN,
 * YInputCapture.CAPTURETYPE_P_AVG_MAX, YInputCapture.CAPTURETYPE_P_AVG_MIN,
 * YInputCapture.CAPTURETYPE_PF_MIN and YInputCapture.CAPTURETYPE_DPF_MIN corresponding to the type of
 * automatic conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_captureType:(Y_CAPTURETYPE_enum) newval;
-(int)     setCaptureType:(Y_CAPTURETYPE_enum) newval;

/**
 * Changes current threshold value for automatic conditional capture.
 *
 * @param newval : a floating point number corresponding to current threshold value for automatic
 * conditional capture
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_condValue:(double) newval;
-(int)     setCondValue:(double) newval;

/**
 * Returns current threshold value for automatic conditional capture.
 *
 * @return a floating point number corresponding to current threshold value for automatic conditional capture
 *
 * On failure, throws an exception or returns YInputCapture.CONDVALUE_INVALID.
 */
-(double)     get_condValue;


-(double) condValue;
/**
 * Returns the relative position of the trigger event within the capture window.
 * When the value is 50%, the capture is centered on the event.
 *
 * @return an integer corresponding to the relative position of the trigger event within the capture window
 *
 * On failure, throws an exception or returns YInputCapture.CONDALIGN_INVALID.
 */
-(int)     get_condAlign;


-(int) condAlign;
/**
 * Changes the relative position of the trigger event within the capture window.
 * The new value must be between 10% (on the left) and 90% (on the right).
 * When the value is 50%, the capture is centered on the event.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : an integer corresponding to the relative position of the trigger event within the capture window
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_condAlign:(int) newval;
-(int)     setCondAlign:(int) newval;

/**
 * Returns the type of automatic conditional capture
 * applied at device power on.
 *
 * @return a value among YInputCapture.CAPTURETYPEATSTARTUP_NONE,
 * YInputCapture.CAPTURETYPEATSTARTUP_TIMED, YInputCapture.CAPTURETYPEATSTARTUP_V_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_PF_MIN and
 * YInputCapture.CAPTURETYPEATSTARTUP_DPF_MIN corresponding to the type of automatic conditional capture
 *         applied at device power on
 *
 * On failure, throws an exception or returns YInputCapture.CAPTURETYPEATSTARTUP_INVALID.
 */
-(Y_CAPTURETYPEATSTARTUP_enum)     get_captureTypeAtStartup;


-(Y_CAPTURETYPEATSTARTUP_enum) captureTypeAtStartup;
/**
 * Changes the type of automatic conditional capture
 * applied at device power on.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : a value among YInputCapture.CAPTURETYPEATSTARTUP_NONE,
 * YInputCapture.CAPTURETYPEATSTARTUP_TIMED, YInputCapture.CAPTURETYPEATSTARTUP_V_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_V_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_I_RMS_MIN, YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MAX,
 * YInputCapture.CAPTURETYPEATSTARTUP_P_AVG_MIN, YInputCapture.CAPTURETYPEATSTARTUP_PF_MIN and
 * YInputCapture.CAPTURETYPEATSTARTUP_DPF_MIN corresponding to the type of automatic conditional capture
 *         applied at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_captureTypeAtStartup:(Y_CAPTURETYPEATSTARTUP_enum) newval;
-(int)     setCaptureTypeAtStartup:(Y_CAPTURETYPEATSTARTUP_enum) newval;

/**
 * Changes current threshold value for automatic conditional
 * capture applied at device power on.
 *
 * If you want the change to be kept after a device reboot,
 * make sure  to call the matching module saveToFlash().
 *
 * @param newval : a floating point number corresponding to current threshold value for automatic conditional
 *         capture applied at device power on
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_condValueAtStartup:(double) newval;
-(int)     setCondValueAtStartup:(double) newval;

/**
 * Returns the threshold value for automatic conditional
 * capture applied at device power on.
 *
 * @return a floating point number corresponding to the threshold value for automatic conditional
 *         capture applied at device power on
 *
 * On failure, throws an exception or returns YInputCapture.CONDVALUEATSTARTUP_INVALID.
 */
-(double)     get_condValueAtStartup;


-(double) condValueAtStartup;
/**
 * Retrieves an instant snapshot trigger for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the instant snapshot trigger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YInputCapture.isOnline() to test if the instant snapshot trigger is
 * indeed online at a given time. In case of ambiguity when looking for
 * an instant snapshot trigger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the instant snapshot trigger, for instance
 *         MyDevice.inputCapture.
 *
 * @return a YInputCapture object allowing you to drive the instant snapshot trigger.
 */
+(YInputCapture*)     FindInputCapture:(NSString*)func;

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
-(int)     registerValueCallback:(YInputCaptureValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

/**
 * Returns all details about the last automatic input capture.
 *
 * @return an YInputCaptureData object including
 *         data series and all related meta-information.
 *         On failure, throws an exception or returns an capture object.
 */
-(YInputCaptureData*)     get_lastCapture;

/**
 * Returns a new immediate capture of the device inputs.
 *
 * @param msDuration : duration of the capture window,
 *         in milliseconds (eg. between 20 and 1000).
 *
 * @return an YInputCaptureData object including
 *         data series for the specified duration.
 *         On failure, throws an exception or returns an capture object.
 */
-(YInputCaptureData*)     get_immediateCapture:(int)msDuration;


/**
 * comment from .yc definition
 */
-(nullable YInputCapture*) nextInputCapture
NS_SWIFT_NAME(nextInputCapture());
/**
 * comment from .yc definition
 */
+(nullable YInputCapture*) FirstInputCapture
NS_SWIFT_NAME(FirstInputCapture());
//--- (end of generated code: YInputCapture public methods declaration)

@end

//--- (generated code: YInputCapture functions declaration)
/**
 * Retrieves an instant snapshot trigger for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the instant snapshot trigger is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YInputCapture.isOnline() to test if the instant snapshot trigger is
 * indeed online at a given time. In case of ambiguity when looking for
 * an instant snapshot trigger by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the instant snapshot trigger, for instance
 *         MyDevice.inputCapture.
 *
 * @return a YInputCapture object allowing you to drive the instant snapshot trigger.
 */
YInputCapture* yFindInputCapture(NSString* func);
/**
 * comment from .yc definition
 */
YInputCapture* yFirstInputCapture(void);

//--- (end of generated code: YInputCapture functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

