/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Declares yFindSegmentedDisplay(), the high-level API for SegmentedDisplay functions
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

@class YSegmentedDisplay;

//--- (YSegmentedDisplay globals)
typedef void (*YSegmentedDisplayValueCallback)(YSegmentedDisplay *func, NSString *functionValue);
#ifndef _Y_DISPLAYMODE_ENUM
#define _Y_DISPLAYMODE_ENUM
typedef enum {
    Y_DISPLAYMODE_DISCONNECTED = 0,
    Y_DISPLAYMODE_MANUAL = 1,
    Y_DISPLAYMODE_AUTO1 = 2,
    Y_DISPLAYMODE_AUTO60 = 3,
    Y_DISPLAYMODE_INVALID = -1,
} Y_DISPLAYMODE_enum;
#endif
#define Y_DISPLAYEDTEXT_INVALID         YAPI_INVALID_STRING
//--- (end of YSegmentedDisplay globals)

//--- (YSegmentedDisplay class start)
/**
 * YSegmentedDisplay Class: segmented display control interface
 *
 * The SegmentedDisplay class allows you to drive segmented displays.
 */
@interface YSegmentedDisplay : YFunction
//--- (end of YSegmentedDisplay class start)
{
@protected
//--- (YSegmentedDisplay attributes declaration)
    NSString*       _displayedText;
    Y_DISPLAYMODE_enum _displayMode;
    YSegmentedDisplayValueCallback _valueCallbackSegmentedDisplay;
//--- (end of YSegmentedDisplay attributes declaration)
}
// Constructor is protected, use yFindSegmentedDisplay factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (YSegmentedDisplay private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of YSegmentedDisplay private methods declaration)
//--- (YSegmentedDisplay yapiwrapper declaration)
//--- (end of YSegmentedDisplay yapiwrapper declaration)
//--- (YSegmentedDisplay public methods declaration)
/**
 * Returns the text currently displayed on the screen.
 *
 * @return a string corresponding to the text currently displayed on the screen
 *
 * On failure, throws an exception or returns YSegmentedDisplay.DISPLAYEDTEXT_INVALID.
 */
-(NSString*)     get_displayedText;


-(NSString*) displayedText;
/**
 * Changes the text currently displayed on the screen.
 *
 * @param newval : a string corresponding to the text currently displayed on the screen
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     set_displayedText:(NSString*) newval;
-(int)     setDisplayedText:(NSString*) newval;

-(Y_DISPLAYMODE_enum)     get_displayMode;


-(Y_DISPLAYMODE_enum) displayMode;
-(int)     set_displayMode:(Y_DISPLAYMODE_enum) newval;
-(int)     setDisplayMode:(Y_DISPLAYMODE_enum) newval;

/**
 * Retrieves a segmented display for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the segmented display is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSegmentedDisplay.isOnline() to test if the segmented display is
 * indeed online at a given time. In case of ambiguity when looking for
 * a segmented display by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the segmented display, for instance
 *         MyDevice.segmentedDisplay.
 *
 * @return a YSegmentedDisplay object allowing you to drive the segmented display.
 */
+(YSegmentedDisplay*)     FindSegmentedDisplay:(NSString*)func;

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
-(int)     registerValueCallback:(YSegmentedDisplayValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;


/**
 * Continues the enumeration of segmented displays started using yFirstSegmentedDisplay().
 * Caution: You can't make any assumption about the returned segmented displays order.
 * If you want to find a specific a segmented display, use SegmentedDisplay.findSegmentedDisplay()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YSegmentedDisplay object, corresponding to
 *         a segmented display currently online, or a nil pointer
 *         if there are no more segmented displays to enumerate.
 */
-(nullable YSegmentedDisplay*) nextSegmentedDisplay
NS_SWIFT_NAME(nextSegmentedDisplay());
/**
 * Starts the enumeration of segmented displays currently accessible.
 * Use the method YSegmentedDisplay.nextSegmentedDisplay() to iterate on
 * next segmented displays.
 *
 * @return a pointer to a YSegmentedDisplay object, corresponding to
 *         the first segmented display currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YSegmentedDisplay*) FirstSegmentedDisplay
NS_SWIFT_NAME(FirstSegmentedDisplay());
//--- (end of YSegmentedDisplay public methods declaration)

@end

//--- (YSegmentedDisplay functions declaration)
/**
 * Retrieves a segmented display for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the segmented display is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YSegmentedDisplay.isOnline() to test if the segmented display is
 * indeed online at a given time. In case of ambiguity when looking for
 * a segmented display by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the segmented display, for instance
 *         MyDevice.segmentedDisplay.
 *
 * @return a YSegmentedDisplay object allowing you to drive the segmented display.
 */
YSegmentedDisplay* yFindSegmentedDisplay(NSString* func);
/**
 * Starts the enumeration of segmented displays currently accessible.
 * Use the method YSegmentedDisplay.nextSegmentedDisplay() to iterate on
 * next segmented displays.
 *
 * @return a pointer to a YSegmentedDisplay object, corresponding to
 *         the first segmented display currently online, or a nil pointer
 *         if there are none.
 */
YSegmentedDisplay* yFirstSegmentedDisplay(void);

//--- (end of YSegmentedDisplay functions declaration)

NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

