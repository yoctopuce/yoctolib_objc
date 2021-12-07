/*********************************************************************
 *
 *  $Id: yocto_quadraturedecoder.h 45843 2021-08-04 07:51:59Z mvuilleu $
 *
 *  Declares yFindQuadratureDecoder(), the high-level API for QuadratureDecoder functions
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

@class YQuadratureDecoder;

//--- (YQuadratureDecoder globals)
typedef void (*YQuadratureDecoderValueCallback)(YQuadratureDecoder *func, NSString *functionValue);
typedef void (*YQuadratureDecoderTimedReportCallback)(YQuadratureDecoder *func, YMeasure *measure);
#ifndef _Y_DECODING_ENUM
#define _Y_DECODING_ENUM
typedef enum {
    Y_DECODING_OFF = 0,
    Y_DECODING_ON = 1,
    Y_DECODING_INVALID = -1,
} Y_DECODING_enum;
#endif
#define Y_SPEED_INVALID                 YAPI_INVALID_DOUBLE
#define Y_EDGESPERCYCLE_INVALID         YAPI_INVALID_UINT
//--- (end of YQuadratureDecoder globals)

//--- (YQuadratureDecoder class start)
/**
 * YQuadratureDecoder Class: quadrature decoder control interface, available for instance in the
 * Yocto-MaxiKnob or the Yocto-PWM-Rx
 *
 * The YQuadratureDecoder class allows you to read and configure Yoctopuce quadrature decoders.
 * It inherits from YSensor class the core functions to read measurements,
 * to register callback functions, and to access the autonomous datalogger.
 */
@interface YQuadratureDecoder : YSensor
//--- (end of YQuadratureDecoder class start)
{
@protected
//--- (YQuadratureDecoder attributes declaration)
    double          _speed;
    Y_DECODING_enum _decoding;
    int             _edgesPerCycle;
    YQuadratureDecoderValueCallback _valueCallbackQuadratureDecoder;
    YQuadratureDecoderTimedReportCallback _timedReportCallbackQuadratureDecoder;
//--- (end of YQuadratureDecoder attributes declaration)
}
// Constructor is protected, use yFindQuadratureDecoder factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YQuadratureDecoder private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YQuadratureDecoder private methods declaration)
//--- (YQuadratureDecoder yapiwrapper declaration)
//--- (end of YQuadratureDecoder yapiwrapper declaration)
//--- (YQuadratureDecoder public methods declaration)
/**
 * Changes the current expected position of the quadrature decoder.
 * Invoking this function implicitly activates the quadrature decoder.
 *
 * @param newval : a floating point number corresponding to the current expected position of the quadrature decoder
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_currentValue:(double) newval;
-(int)     setCurrentValue:(double) newval;

/**
 * Returns the cycle frequency, in Hz.
 *
 * @return a floating point number corresponding to the cycle frequency, in Hz
 *
 * On failure, throws an exception or returns YQuadratureDecoder.SPEED_INVALID.
 */
-(double)     get_speed;


-(double) speed;
/**
 * Returns the current activation state of the quadrature decoder.
 *
 * @return either YQuadratureDecoder.DECODING_OFF or YQuadratureDecoder.DECODING_ON, according to the
 * current activation state of the quadrature decoder
 *
 * On failure, throws an exception or returns YQuadratureDecoder.DECODING_INVALID.
 */
-(Y_DECODING_enum)     get_decoding;


-(Y_DECODING_enum) decoding;
/**
 * Changes the activation state of the quadrature decoder.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : either YQuadratureDecoder.DECODING_OFF or YQuadratureDecoder.DECODING_ON, according
 * to the activation state of the quadrature decoder
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_decoding:(Y_DECODING_enum) newval;
-(int)     setDecoding:(Y_DECODING_enum) newval;

/**
 * Returns the edge count per full cycle configuration setting.
 *
 * @return an integer corresponding to the edge count per full cycle configuration setting
 *
 * On failure, throws an exception or returns YQuadratureDecoder.EDGESPERCYCLE_INVALID.
 */
-(int)     get_edgesPerCycle;


-(int) edgesPerCycle;
/**
 * Changes the edge count per full cycle configuration setting.
 * Remember to call the saveToFlash()
 * method of the module if the modification must be kept.
 *
 * @param newval : an integer corresponding to the edge count per full cycle configuration setting
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_edgesPerCycle:(int) newval;
-(int)     setEdgesPerCycle:(int) newval;

/**
 * Retrieves a quadrature decoder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quadrature decoder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQuadratureDecoder.isOnline() to test if the quadrature decoder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quadrature decoder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the quadrature decoder, for instance
 *         YMXBTN01.quadratureDecoder1.
 *
 * @return a YQuadratureDecoder object allowing you to drive the quadrature decoder.
 */
+(YQuadratureDecoder*)     FindQuadratureDecoder:(NSString*)func;

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
-(int)     registerValueCallback:(YQuadratureDecoderValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

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
-(int)     registerTimedReportCallback:(YQuadratureDecoderTimedReportCallback _Nullable)callback;

-(int)     _invokeTimedReportCallback:(YMeasure*)value;


/**
 * Continues the enumeration of quadrature decoders started using yFirstQuadratureDecoder().
 * Caution: You can't make any assumption about the returned quadrature decoders order.
 * If you want to find a specific a quadrature decoder, use QuadratureDecoder.findQuadratureDecoder()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YQuadratureDecoder object, corresponding to
 *         a quadrature decoder currently online, or a nil pointer
 *         if there are no more quadrature decoders to enumerate.
 */
-(nullable YQuadratureDecoder*) nextQuadratureDecoder
NS_SWIFT_NAME(nextQuadratureDecoder());
/**
 * Starts the enumeration of quadrature decoders currently accessible.
 * Use the method YQuadratureDecoder.nextQuadratureDecoder() to iterate on
 * next quadrature decoders.
 *
 * @return a pointer to a YQuadratureDecoder object, corresponding to
 *         the first quadrature decoder currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YQuadratureDecoder*) FirstQuadratureDecoder
NS_SWIFT_NAME(FirstQuadratureDecoder());
//--- (end of YQuadratureDecoder public methods declaration)

@end

//--- (YQuadratureDecoder functions declaration)
/**
 * Retrieves a quadrature decoder for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the quadrature decoder is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YQuadratureDecoder.isOnline() to test if the quadrature decoder is
 * indeed online at a given time. In case of ambiguity when looking for
 * a quadrature decoder by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the quadrature decoder, for instance
 *         YMXBTN01.quadratureDecoder1.
 *
 * @return a YQuadratureDecoder object allowing you to drive the quadrature decoder.
 */
YQuadratureDecoder* yFindQuadratureDecoder(NSString* func);
/**
 * Starts the enumeration of quadrature decoders currently accessible.
 * Use the method YQuadratureDecoder.nextQuadratureDecoder() to iterate on
 * next quadrature decoders.
 *
 * @return a pointer to a YQuadratureDecoder object, corresponding to
 *         the first quadrature decoder currently online, or a nil pointer
 *         if there are none.
 */
YQuadratureDecoder* yFirstQuadratureDecoder(void);

//--- (end of YQuadratureDecoder functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

