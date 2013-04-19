/*********************************************************************
 *
 * $Id: pic24config.php 9668 2013-02-04 12:36:11Z martinm $
 *
 * Implements yFindFiles(), the high-level API for Files functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 * Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 * 1) If you have obtained this file from www.yoctopuce.com,
 *    Yoctopuce Sarl licenses to you (hereafter Licensee) the
 *    right to use, modify, copy, and integrate this source file
 *    into your own solution for the sole purpose of interfacing
 *    a Yoctopuce product with Licensee's solution.
 *
 *    The use of this file and all relationship between Yoctopuce 
 *    and Licensee are governed by Yoctopuce General Terms and 
 *    Conditions.
 *
 *    THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *    WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS 
 *    FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *    EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, 
 *    COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *    LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *    CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *    BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *    WARRANTY, OR OTHERWISE.
 *
 * 2) If your intent is not to interface with Yoctopuce products,
 *    you are not entitled to use, read or create any derived
 *    material from this source file.
 *
 *********************************************************************/


#import "yocto_files.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YFileRecord

//--- (generated code: YFileRecord attributes)
//--- (end of generated code: YFileRecord attributes)

-(id)   initWith:(NSString *)json_str
{
    yJsonStateMachine j;
    if(!(self = [super init]))
        return nil;
    
    // Parse JSON data 
    j.src = STR_oc2y(json_str);
    j.end = j.src + strlen(j.src);
    j.st = YJSON_START;
    if(yJsonParse(&j) != YJSON_PARSE_AVAIL || j.st != YJSON_PARSE_STRUCT) {
        return nil;
    }
    while(yJsonParse(&j) == YJSON_PARSE_AVAIL && j.st == YJSON_PARSE_MEMBNAME) {
        if (!strcmp(j.token, "name")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return nil;
            }
            _name = STR_y2oc(j.token);
            while(j.next == YJSON_PARSE_STRINGCONT && yJsonParse(&j) == YJSON_PARSE_AVAIL) {
                _name =[_name stringByAppendingString: STR_y2oc(j.token)];
                ARC_retain(_name);
            }
        } else if(!strcmp(j.token, "crc")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return nil;
            }
            _crc = atoi(j.token);;
        } else if(!strcmp(j.token, "size")) {
            if (yJsonParse(&j) != YJSON_PARSE_AVAIL) {
                return nil;
            }
            _size = atoi(j.token);;
        } else {
            yJsonSkip(&j, 1);
        }
    }
    return self;
}




//--- (generated code: YFileRecord implementation)

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

-(NSString*) name
{
    return _name;
}

-(int) size
{
    return _size;
}

-(int) crc
{
    return _crc;
}

//--- (end of generated code: YFileRecord implementation)

@end
//--- (generated code: FileRecord functions)
//--- (end of generated code: FileRecord functions)



static NSMutableDictionary* _FilesCache = nil;

@implementation YFiles

// Constructor is protected, use yFindFiles factory function to instantiate
-(id)              initWithFunction:(NSString*) func
{
//--- (generated code: YFiles attributes)
   if(!(self = [super initProtected:@"Files":func]))
          return nil;
    _logicalName = Y_LOGICALNAME_INVALID;
    _advertisedValue = Y_ADVERTISEDVALUE_INVALID;
    _filesCount = Y_FILESCOUNT_INVALID;
    _freeSpace = Y_FREESPACE_INVALID;
//--- (end of generated code: YFiles attributes)
    return self;
}
//--- (generated code: YFiles implementation)

-(int) _parse:(yJsonStateMachine*) j
{
    if(yJsonParse(j) != YJSON_PARSE_AVAIL || j->st != YJSON_PARSE_STRUCT) {
    failed:
        return -1;
    }
    while(yJsonParse(j) == YJSON_PARSE_AVAIL && j->st == YJSON_PARSE_MEMBNAME) {
        if(!strcmp(j->token, "logicalName")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_logicalName);
            _logicalName =  [self _parseString:j];
            ARC_retain(_logicalName);
        } else if(!strcmp(j->token, "advertisedValue")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            ARC_release(_advertisedValue);
            _advertisedValue =  [self _parseString:j];
            ARC_retain(_advertisedValue);
        } else if(!strcmp(j->token, "filesCount")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _filesCount =  atoi(j->token);
        } else if(!strcmp(j->token, "freeSpace")) {
            if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
            _freeSpace =  atoi(j->token);
        } else {
            // ignore unknown field
            yJsonSkip(j, 1);
        }
    }
    if(j->st != YJSON_PARSE_STRUCT) goto failed;
    return 0;
}

/**
 * Returns the logical name of the filesystem.
 * 
 * @return a string corresponding to the logical name of the filesystem
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
 * Changes the logical name of the filesystem. You can use yCheckLogicalName()
 * prior to this call to make sure that your parameter is valid.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 * 
 * @param newval : a string corresponding to the logical name of the filesystem
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
 * Returns the current value of the filesystem (no more than 6 characters).
 * 
 * @return a string corresponding to the current value of the filesystem (no more than 6 characters)
 * 
 * On failure, throws an exception or returns Y_ADVERTISEDVALUE_INVALID.
 */
-(NSString*) get_advertisedValue
{
    return [self advertisedValue];
}
-(NSString*) advertisedValue
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_ADVERTISEDVALUE_INVALID;
    }
    return _advertisedValue;
}

/**
 * Returns the number of files currently loaded in the filesystem.
 * 
 * @return an integer corresponding to the number of files currently loaded in the filesystem
 * 
 * On failure, throws an exception or returns Y_FILESCOUNT_INVALID.
 */
-(unsigned) get_filesCount
{
    return [self filesCount];
}
-(unsigned) filesCount
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_FILESCOUNT_INVALID;
    }
    return _filesCount;
}

/**
 * Returns the free space for uploading new files to the filesystem, in bytes.
 * 
 * @return an integer corresponding to the free space for uploading new files to the filesystem, in bytes
 * 
 * On failure, throws an exception or returns Y_FREESPACE_INVALID.
 */
-(unsigned) get_freeSpace
{
    return [self freeSpace];
}
-(unsigned) freeSpace
{
    if(_cacheExpiration <= [YAPI  GetTickCount]) {
        if(YISERR([self load:[YAPI DefaultCacheValidity]])) return Y_FREESPACE_INVALID;
    }
    return _freeSpace;
}
-(NSData*) sendCommand :(NSString*)command
{
    NSString* url;
    url =  [NSString stringWithFormat:@"files.json?a=%@",command];
    return [self _download:url];
    
}

/**
 * Reinitializes the filesystem to its clean, unfragmented, empty state.
 * All files previously uploaded are permanently lost.
 * 
 * @return YAPI_SUCCESS if the call succeeds.
 * 
 * On failure, throws an exception or returns a negative error code.
 */
-(int) format_fs
{
    NSData* json;
    NSString* res;
    json = [self sendCommand:@"format"]; 
    res  = [self _json_get_key:json : @"res"];
    if (!([res isEqualToString:@"ok"])) {[self _throw: YAPI_IO_ERROR: @"format failed"]; return  YAPI_IO_ERROR;};
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
-(NSMutableArray*) get_list :(NSString*)pattern
{
    NSData* json;
    NSMutableArray* list = [NSMutableArray array];
    NSMutableArray* res = [NSMutableArray array];
    json = [self sendCommand:[NSString stringWithFormat:@"dir&f=%@",pattern]];
    list = [self _json_get_array:json];
    for (NSString* _each  in list) { [res addObject:[[YFileRecord alloc] initWith:_each]];};
    return res;
    
}

/**
 * Downloads the requested file and returns a binary buffer with its content.
 * 
 * @param pathname : path and name of the new file to load
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
-(int) upload :(NSString*)pathname :(NSData*)content
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
-(int) remove :(NSString*)pathname
{
    NSData* json;
    NSString* res;
    json = [self sendCommand:[NSString stringWithFormat:@"del&f=%@",pathname]]; 
    res  = [self _json_get_key:json : @"res"];
    if (!([res isEqualToString:@"ok"])) {[self _throw: YAPI_IO_ERROR: @"unable to remove file"]; return  YAPI_IO_ERROR;};
    return YAPI_SUCCESS;
    
}


-(YFiles*)   nextFiles
{
    NSString  *hwid;
    
    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return yFindFiles(hwid);
}
-(void )    registerValueCallback:(YFunctionUpdateCallback)callback
{ 
    _callback = callback;
    if (callback != NULL) {
        [self _registerFuncCallback];
    } else {
        [self _unregisterFuncCallback];
    }
}
-(void )    set_objectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object :(SEL)selector
{ [self setObjectCallback:object withSelector:selector];}
-(void )    setObjectCallback:(id)object withSelector:(SEL)selector
{ 
    _callbackObject = object;
    _callbackSel    = selector;
    if (object != nil) {
        [self _registerFuncCallback];
        if([self isOnline]) {
           yapiLockFunctionCallBack(NULL);
           yInternalPushNewVal([self functionDescriptor],[self advertisedValue]);
           yapiUnlockFunctionCallBack(NULL);
        }
    } else {
        [self _unregisterFuncCallback];
    }
}

+(YFiles*) FindFiles:(NSString*) func
{
    YFiles * retVal=nil;
    if(func==nil) return nil;
    // Search in cache
    {
        if (_FilesCache == nil){
            _FilesCache = [[NSMutableDictionary alloc] init];
        }
        if(nil != [_FilesCache objectForKey:func]){
            retVal = [_FilesCache objectForKey:func];
       } else {
           YFiles *newFiles = [[YFiles alloc] initWithFunction:func];
           [_FilesCache setObject:newFiles forKey:func];
           retVal = newFiles;
           ARC_autorelease(retVal);
       }
   }
   return retVal;
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

//--- (end of generated code: YFiles implementation)

@end
//--- (generated code: Files functions)

YFiles *yFindFiles(NSString* func)
{
    return [YFiles FindFiles:func];
}

YFiles *yFirstFiles(void)
{
    return [YFiles FirstFiles];
}

//--- (end of generated code: Files functions)
