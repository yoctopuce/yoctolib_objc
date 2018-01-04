/*********************************************************************
 *
 * $Id: yocto_files.m 28744 2017-10-03 08:14:16Z seb $
 *
 * Implements yFindFiles(), the high-level API for Files functions
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


#import "yocto_files.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YFileRecord


-(id)   initWith:(NSString *)json_str
{
    yJsonStateMachine j;
    if(!(self = [super init]))
        return nil;
//--- (generated code: YFileRecord attributes initialization)
    _size = 0;
    _crc = 0;
//--- (end of generated code: YFileRecord attributes initialization)

    // Parse JSON data
    j.src = STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        return self;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if (!strcmp(j.token, "name")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _name = STR_y2oc(j.token);
            while(j.next == YJSON_PARSE_STRINGCONT && yJsonParse(&j) == YJSON_PARSE_AVAIL) {
                _name =[_name stringByAppendingString: STR_y2oc(j.token)];
                ARC_retain(_name);
            }
        } else if(!strcmp(j.token, "crc")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _crc = atoi(j.token);;
        } else if(!strcmp(j.token, "size")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return self;
            }
            _size = atoi(j.token);;
        } else {
            yJsonSkip(&j, 1);
        }
    }
    return self;
}

// destructor
-(void)  dealloc
{
//--- (generated code: YFileRecord cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YFileRecord cleanup)
}

//--- (generated code: YFileRecord private methods implementation)

//--- (end of generated code: YFileRecord private methods implementation)

//--- (generated code: YFileRecord public methods implementation)
-(NSString*) get_name
{
    return _name;
}

-(int) get_size
{
    return _size;
}

-(int) get_crc
{
    return _crc;
}

//--- (end of generated code: YFileRecord public methods implementation)

@end
//--- (generated code: YFileRecord functions)
//--- (end of generated code: YFileRecord functions)




@implementation YFiles

// Constructor is protected, use yFindFiles factory function to instantiate
-(id)              initWith:(NSString*) func
{
    if(!(self = [super initWith:func]))
        return nil;
    _className = @"Files";
//--- (generated code: YFiles attributes initialization)
    _filesCount = Y_FILESCOUNT_INVALID;
    _freeSpace = Y_FREESPACE_INVALID;
    _valueCallbackFiles = NULL;
//--- (end of generated code: YFiles attributes initialization)
    return self;
}


// destructor
-(void) dealloc
{
//--- (generated code: YFiles cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YFiles cleanup)
}


//--- (generated code: YFiles private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "filesCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _filesCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "freeSpace")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _freeSpace =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YFiles private methods implementation)

//--- (generated code: YFiles public methods implementation)
/**
 * Returns the number of files currently loaded in the filesystem.
 *
 * @return an integer corresponding to the number of files currently loaded in the filesystem
 *
 * On failure, throws an exception or returns Y_FILESCOUNT_INVALID.
 */
-(int) get_filesCount
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_FILESCOUNT_INVALID;
        }
    }
    res = _filesCount;
    return res;
}


-(int) filesCount
{
    return [self get_filesCount];
}
/**
 * Returns the free space for uploading new files to the filesystem, in bytes.
 *
 * @return an integer corresponding to the free space for uploading new files to the filesystem, in bytes
 *
 * On failure, throws an exception or returns Y_FREESPACE_INVALID.
 */
-(int) get_freeSpace
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_FREESPACE_INVALID;
        }
    }
    res = _freeSpace;
    return res;
}


-(int) freeSpace
{
    return [self get_freeSpace];
}
/**
 * Retrieves a filesystem for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the filesystem is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YFiles.isOnline() to test if the filesystem is
 * indeed online at a given time. In case of ambiguity when looking for
 * a filesystem by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the filesystem
 *
 * @return a YFiles object allowing you to drive the filesystem.
 */
+(YFiles*) FindFiles:(NSString*)func
{
    YFiles* obj;
    obj = (YFiles*) [YFunction _FindFromCache:@"Files" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YFiles alloc] initWith:func]);
        [YFunction _AddToCache:@"Files" : func :obj];
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
-(int) registerValueCallback:(YFilesValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackFiles = callback;
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
    if (_valueCallbackFiles != NULL) {
        _valueCallbackFiles(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(NSMutableData*) sendCommand:(NSString*)command
{
    NSString* url;
    url = [NSString stringWithFormat:@"files.json?a=%@",command];

    return [self _download:url];
}

/**
 * Reinitialize the filesystem to its clean, unfragmented, empty state.
 * All files previously uploaded are permanently lost.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) format_fs
{
    NSMutableData* json;
    NSString* res;
    json = [self sendCommand:@"format"];
    res = [self _json_get_key:json :@"res"];
    if (!([res isEqualToString:@"ok"])) {[self _throw: YAPI_IO_ERROR: @"format failed"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}

/**
 * Returns a list of YFileRecord objects that describe files currently loaded
 * in the filesystem.
 *
 * @param pattern : an optional filter pattern, using star and question marks
 *         as wildcards. When an empty pattern is provided, all file records
 *         are returned.
 *
 * @return a list of YFileRecord objects, containing the file path
 *         and name, byte size and 32-bit CRC of the file content.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_list:(NSString*)pattern
{
    NSMutableData* json;
    NSMutableArray* filelist = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    json = [self sendCommand:[NSString stringWithFormat:@"dir&f=%@",pattern]];
    filelist = [self _json_get_array:json];
    [res removeAllObjects];
    for (NSString* _each  in filelist) {
        [res addObject:ARC_sendAutorelease([[YFileRecord alloc] initWith:_each])];
    }
    return res;
}

/**
 * Test if a file exist on the filesystem of the module.
 *
 * @param filename : the file name to test.
 *
 * @return a true if the file existe, false ortherwise.
 *
 * On failure, throws an exception.
 */
-(bool) fileExist:(NSString*)filename
{
    NSMutableData* json;
    NSMutableArray* filelist = [NSMutableArray array];
    if ((int)[(filename) length] == 0) {
        return NO;
    }
    json = [self sendCommand:[NSString stringWithFormat:@"dir&f=%@",filename]];
    filelist = [self _json_get_array:json];
    if ((int)[filelist count] > 0) {
        return YES;
    }
    return NO;
}

/**
 * Downloads the requested file and returns a binary buffer with its content.
 *
 * @param pathname : path and name of the file to download
 *
 * @return a binary buffer with the file content
 *
 * On failure, throws an exception or returns an empty content.
 */
-(NSMutableData*) download:(NSString*)pathname
{
    return [self _download:pathname];
}

/**
 * Uploads a file to the filesystem, to the specified full path name.
 * If a file already exists with the same path name, its content is overwritten.
 *
 * @param pathname : path and name of the new file to create
 * @param content : binary buffer with the content to set
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) upload:(NSString*)pathname :(NSData*)content
{
    return [self _upload:pathname :content];
}

/**
 * Deletes a file, given by its full path name, from the filesystem.
 * Because of filesystem fragmentation, deleting a file may not always
 * free up the whole space used by the file. However, rewriting a file
 * with the same path name will always reuse any space not freed previously.
 * If you need to ensure that no space is taken by previously deleted files,
 * you can use format_fs to fully reinitialize the filesystem.
 *
 * @param pathname : path and name of the file to remove.
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) remove:(NSString*)pathname
{
    NSMutableData* json;
    NSString* res;
    json = [self sendCommand:[NSString stringWithFormat:@"del&f=%@",pathname]];
    res  = [self _json_get_key:json :@"res"];
    if (!([res isEqualToString:@"ok"])) {[self _throw: YAPI_IO_ERROR: @"unable to remove file"]; return YAPI_IO_ERROR;}
    return YAPI_SUCCESS;
}


-(YFiles*)   nextFiles
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YFiles FindFiles:hwid];
}

+(YFiles *) FirstFiles
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"Files":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YFiles FindFiles:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YFiles public methods implementation)

@end
//--- (generated code: YFiles functions)

YFiles *yFindFiles(NSString* func)
{
    return [YFiles FindFiles:func];
}

YFiles *yFirstFiles(void)
{
    return [YFiles FirstFiles];
}

//--- (end of generated code: YFiles functions)
