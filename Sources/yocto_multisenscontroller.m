/*********************************************************************
 *
 *  $Id: yocto_multisenscontroller.m 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 *  Implements the high-level API for MultiSensController functions
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


#import "yocto_multisenscontroller.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YMultiSensController
// Constructor is protected, use yFindMultiSensController factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"MultiSensController";
//--- (YMultiSensController attributes initialization)
    _nSensors = Y_NSENSORS_INVALID;
    _maxSensors = Y_MAXSENSORS_INVALID;
    _maintenanceMode = Y_MAINTENANCEMODE_INVALID;
    _lastAddressDetected = Y_LASTADDRESSDETECTED_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackMultiSensController = NULL;
//--- (end of YMultiSensController attributes initialization)
    return self;
}
//--- (YMultiSensController yapiwrapper)
//--- (end of YMultiSensController yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (YMultiSensController cleanup)
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of YMultiSensController cleanup)
}
//--- (YMultiSensController private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "nSensors")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nSensors =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "maxSensors")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maxSensors =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "maintenanceMode")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _maintenanceMode =  (Y_MAINTENANCEMODE_enum)atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "lastAddressDetected")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _lastAddressDetected =  atoi(j->token);
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
//--- (end of YMultiSensController private methods implementation)
//--- (YMultiSensController public methods implementation)
/**
 * Returns the number of sensors to poll.
 *
 * @return an integer corresponding to the number of sensors to poll
 *
 * On failure, throws an exception or returns YMultiSensController.NSENSORS_INVALID.
 */
-(int) get_nSensors
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NSENSORS_INVALID;
        }
    }
    res = _nSensors;
    return res;
}


-(int) nSensors
{
    return [self get_nSensors];
}

/**
 * Changes the number of sensors to poll. Remember to call the
 * saveToFlash() method of the module if the
 * modification must be kept. It is recommended to restart the
 * device with  module->reboot() after modifying
 * (and saving) this settings.
 *
 * @param newval : an integer corresponding to the number of sensors to poll
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_nSensors:(int) newval
{
    return [self setNSensors:newval];
}
-(int) setNSensors:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"nSensors" :rest_val];
}
/**
 * Returns the maximum configurable sensor count allowed on this device.
 *
 * @return an integer corresponding to the maximum configurable sensor count allowed on this device
 *
 * On failure, throws an exception or returns YMultiSensController.MAXSENSORS_INVALID.
 */
-(int) get_maxSensors
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAXSENSORS_INVALID;
        }
    }
    res = _maxSensors;
    return res;
}


-(int) maxSensors
{
    return [self get_maxSensors];
}
/**
 * Returns true when the device is in maintenance mode.
 *
 * @return either YMultiSensController.MAINTENANCEMODE_FALSE or
 * YMultiSensController.MAINTENANCEMODE_TRUE, according to true when the device is in maintenance mode
 *
 * On failure, throws an exception or returns YMultiSensController.MAINTENANCEMODE_INVALID.
 */
-(Y_MAINTENANCEMODE_enum) get_maintenanceMode
{
    Y_MAINTENANCEMODE_enum res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_MAINTENANCEMODE_INVALID;
        }
    }
    res = _maintenanceMode;
    return res;
}


-(Y_MAINTENANCEMODE_enum) maintenanceMode
{
    return [self get_maintenanceMode];
}

/**
 * Changes the device mode to enable maintenance and to stop sensor polling.
 * This way, the device does not automatically restart when it cannot
 * communicate with one of the sensors.
 *
 * @param newval : either YMultiSensController.MAINTENANCEMODE_FALSE or
 * YMultiSensController.MAINTENANCEMODE_TRUE, according to the device mode to enable maintenance and
 * to stop sensor polling
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_maintenanceMode:(Y_MAINTENANCEMODE_enum) newval
{
    return [self setMaintenanceMode:newval];
}
-(int) setMaintenanceMode:(Y_MAINTENANCEMODE_enum) newval
{
    NSString* rest_val;
    rest_val = (newval ? @"1" : @"0");
    return [self _setAttr:@"maintenanceMode" :rest_val];
}
/**
 * Returns the I2C address of the most recently detected sensor. This method can
 * be used to in case of I2C communication error to determine what is the
 * last sensor that can be reached, or after a call to setupAddress
 * to make sure that the address change was properly processed.
 *
 * @return an integer corresponding to the I2C address of the most recently detected sensor
 *
 * On failure, throws an exception or returns YMultiSensController.LASTADDRESSDETECTED_INVALID.
 */
-(int) get_lastAddressDetected
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_LASTADDRESSDETECTED_INVALID;
        }
    }
    res = _lastAddressDetected;
    return res;
}


-(int) lastAddressDetected
{
    return [self get_lastAddressDetected];
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
 * Retrieves a multi-sensor controller for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
 *
 * This function does not require that the multi-sensor controller is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMultiSensController.isOnline() to test if the multi-sensor controller is
 * indeed online at a given time. In case of ambiguity when looking for
 * a multi-sensor controller by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the multi-sensor controller, for instance
 *         YTEMPIR1.multiSensController.
 *
 * @return a YMultiSensController object allowing you to drive the multi-sensor controller.
 */
+(YMultiSensController*) FindMultiSensController:(NSString*)func
{
    YMultiSensController* obj;
    obj = (YMultiSensController*) [YFunction _FindFromCache:@"MultiSensController" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YMultiSensController alloc] initWith:func]);
        [YFunction _AddToCache:@"MultiSensController" : func :obj];
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
-(int) registerValueCallback:(YMultiSensControllerValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackMultiSensController = callback;
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
    if (_valueCallbackMultiSensController != NULL) {
        _valueCallbackMultiSensController(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

/**
 * Configures the I2C address of the only sensor connected to the device.
 * It is recommended to put the the device in maintenance mode before
 * changing sensor addresses.  This method is only intended to work with a single
 * sensor connected to the device. If several sensors are connected, the result
 * is unpredictable.
 *
 * Note that the device is expecting to find a sensor or a string of sensors with specific
 * addresses. Check the device documentation to find out which addresses should be used.
 *
 * @param addr : new address of the connected sensor
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) setupAddress:(int)addr
{
    NSString* cmd;
    int res;
    cmd = [NSString stringWithFormat:@"A%d",addr];
    res = [self set_command:cmd];
    if (!(res == YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to trigger address change"]; return YAPI_IO_ERROR;}
    [YAPI Sleep:1500 :NULL];
    res = [self get_lastAddressDetected];
    if (!(res > 0)) {[self _throw: YAPI_IO_ERROR: @"IR sensor not found"]; return YAPI_IO_ERROR;}
    if (!(res == addr)) {[self _throw: YAPI_IO_ERROR: @"address change failed"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Triggers the I2C address detection procedure for the only sensor connected to the device.
 * This method is only intended to work with a single sensor connected to the device.
 * If several sensors are connected, the result is unpredictable.
 *
 * @return the I2C address of the detected sensor, or 0 if none is found
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) get_sensorAddress
{
    int res;
    res = [self set_command:@"a"];
    if (!(res == YAPI_SUCCESS)) {[self _throw: YAPI_IO_ERROR: @"unable to trigger address detection"]; return res;}
    [YAPI Sleep:1000 :NULL];
    res = [self get_lastAddressDetected];
    return res;
}


-(YMultiSensController*)   nextMultiSensController
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YMultiSensController FindMultiSensController:hwid];
}

+(YMultiSensController *) FirstMultiSensController
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"MultiSensController":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YMultiSensController FindMultiSensController:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of YMultiSensController public methods implementation)
@end

//--- (YMultiSensController functions)

YMultiSensController *yFindMultiSensController(NSString* func)
{
    return [YMultiSensController FindMultiSensController:func];
}

YMultiSensController *yFirstMultiSensController(void)
{
    return [YMultiSensController FirstMultiSensController];
}

//--- (end of YMultiSensController functions)

