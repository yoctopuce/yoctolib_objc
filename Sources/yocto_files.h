/*********************************************************************
 *
 * $Id: yocto_files.h 59977 2024-03-18 15:02:32Z mvuilleu $
 *
 * Declares yFindFiles(), the high-level API for Files functions
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

#include "yocto_api.h"
CF_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN
@class YFiles;

//--- (generated code: YFiles globals)
typedef void (*YFilesValueCallback)(YFiles *func, NSString *functionValue);
#define Y_FILESCOUNT_INVALID            YAPI_INVALID_UINT
#define Y_FREESPACE_INVALID             YAPI_INVALID_UINT
//--- (end of generated code: YFiles globals)

//--- (generated code: YFileRecord globals)
//--- (end of generated code: YFileRecord globals)




//--- (generated code: YFileRecord class start)
/**
 * YFileRecord Class: Description of a file on the device filesystem, returned by files.get_list
 *
 * YFileRecord objects are used to describe a file that is stored on a Yoctopuce device.
 * These objects are used in particular in conjunction with the YFiles class.
 */
@interface YFileRecord : NSObject
//--- (end of generated code: YFileRecord class start)
{
@protected
//--- (generated code: YFileRecord attributes declaration)
    NSString*       _name;
    int             _size;
    int             _crc;
//--- (end of generated code: YFileRecord attributes declaration)
}

-(id)    initWith:(NSString*)jsondata;

//--- (generated code: YFileRecord private methods declaration)
//--- (end of generated code: YFileRecord private methods declaration)
//--- (generated code: YFileRecord public methods declaration)
/**
 * Returns the name of the file.
 *
 * @return a string with the name of the file.
 */
-(NSString*)     get_name;

/**
 * Returns the size of the file in bytes.
 *
 * @return the size of the file.
 */
-(int)     get_size;

/**
 * Returns the 32-bit CRC of the file content.
 *
 * @return the 32-bit CRC of the file content.
 */
-(int)     get_crc;


//--- (end of generated code: YFileRecord public methods declaration)

@end

//--- (generated code: YFileRecord functions declaration)
//--- (end of generated code: YFileRecord functions declaration)


//--- (generated code: YFiles class start)
/**
 * YFiles Class: filesystem control interface, available for instance in the Yocto-Color-V2, the
 * Yocto-SPI, the YoctoHub-Ethernet or the YoctoHub-GSM-4G
 *
 * The YFiles class is used to access the filesystem embedded on
 * some Yoctopuce devices. This filesystem makes it
 * possible for instance to design a custom web UI
 * (for networked devices) or to add fonts (on display devices).
 */
@interface YFiles : YFunction
//--- (end of generated code: YFiles class start)
{
@protected
//--- (generated code: YFiles attributes declaration)
    int             _filesCount;
    int             _freeSpace;
    YFilesValueCallback _valueCallbackFiles;
//--- (end of generated code: YFiles attributes declaration)
}
// Constructor is protected, use yFindFiles factory function to instantiate
-(id)    initWith:(NSString*) func;

//--- (generated code: YFiles private methods declaration)
// Function-specific method for parsing of JSON output and caching result
-(int)             _parseAttr:(yJsonStateMachine*) j;

//--- (end of generated code: YFiles private methods declaration)
//--- (generated code: YFiles public methods declaration)
/**
 * Returns the number of files currently loaded in the filesystem.
 *
 * @return an integer corresponding to the number of files currently loaded in the filesystem
 *
 * On failure, throws an exception or returns YFiles.FILESCOUNT_INVALID.
 */
-(int)     get_filesCount;


-(int) filesCount;
/**
 * Returns the free space for uploading new files to the filesystem, in bytes.
 *
 * @return an integer corresponding to the free space for uploading new files to the filesystem, in bytes
 *
 * On failure, throws an exception or returns YFiles.FREESPACE_INVALID.
 */
-(int)     get_freeSpace;


-(int) freeSpace;
/**
 * Retrieves a filesystem for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
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
 * @param func : a string that uniquely characterizes the filesystem, for instance
 *         YRGBLED2.files.
 *
 * @return a YFiles object allowing you to drive the filesystem.
 */
+(YFiles*)     FindFiles:(NSString*)func;

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
-(int)     registerValueCallback:(YFilesValueCallback _Nullable)callback;

-(int)     _invokeValueCallback:(NSString*)value;

-(NSMutableData*)     sendCommand:(NSString*)command;

/**
 * Reinitialize the filesystem to its clean, unfragmented, empty state.
 * All files previously uploaded are permanently lost.
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     format_fs;

/**
 * Returns a list of YFileRecord objects that describe files currently loaded
 * in the filesystem.
 *
 * @param pattern : an optional filter pattern, using star and question marks
 *         as wild cards. When an empty pattern is provided, all file records
 *         are returned.
 *
 * @return a list of YFileRecord objects, containing the file path
 *         and name, byte size and 32-bit CRC of the file content.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*)     get_list:(NSString*)pattern;

/**
 * Test if a file exist on the filesystem of the module.
 *
 * @param filename : the file name to test.
 *
 * @return a true if the file exist, false otherwise.
 *
 * On failure, throws an exception.
 */
-(bool)     fileExist:(NSString*)filename;

/**
 * Downloads the requested file and returns a binary buffer with its content.
 *
 * @param pathname : path and name of the file to download
 *
 * @return a binary buffer with the file content
 *
 * On failure, throws an exception or returns an empty content.
 */
-(NSMutableData*)     download:(NSString*)pathname;

/**
 * Uploads a file to the filesystem, to the specified full path name.
 * If a file already exists with the same path name, its content is overwritten.
 *
 * @param pathname : path and name of the new file to create
 * @param content : binary buffer with the content to set
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     upload:(NSString*)pathname :(NSData*)content;

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
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int)     remove:(NSString*)pathname;


/**
 * Continues the enumeration of filesystems started using yFirstFiles().
 * Caution: You can't make any assumption about the returned filesystems order.
 * If you want to find a specific a filesystem, use Files.findFiles()
 * and a hardwareID or a logical name.
 *
 * @return a pointer to a YFiles object, corresponding to
 *         a filesystem currently online, or a nil pointer
 *         if there are no more filesystems to enumerate.
 */
-(nullable YFiles*) nextFiles
NS_SWIFT_NAME(nextFiles());
/**
 * Starts the enumeration of filesystems currently accessible.
 * Use the method YFiles.nextFiles() to iterate on
 * next filesystems.
 *
 * @return a pointer to a YFiles object, corresponding to
 *         the first filesystem currently online, or a nil pointer
 *         if there are none.
 */
+(nullable YFiles*) FirstFiles
NS_SWIFT_NAME(FirstFiles());
//--- (end of generated code: YFiles public methods declaration)

@end

//--- (generated code: YFiles functions declaration)
/**
 * Retrieves a filesystem for a given identifier.
 * The identifier can be specified using several formats:
 *
 * - FunctionLogicalName
 * - ModuleSerialNumber.FunctionIdentifier
 * - ModuleSerialNumber.FunctionLogicalName
 * - ModuleLogicalName.FunctionIdentifier
 * - ModuleLogicalName.FunctionLogicalName
 *
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
 * @param func : a string that uniquely characterizes the filesystem, for instance
 *         YRGBLED2.files.
 *
 * @return a YFiles object allowing you to drive the filesystem.
 */
YFiles* yFindFiles(NSString* func);
/**
 * Starts the enumeration of filesystems currently accessible.
 * Use the method YFiles.nextFiles() to iterate on
 * next filesystems.
 *
 * @return a pointer to a YFiles object, corresponding to
 *         the first filesystem currently online, or a nil pointer
 *         if there are none.
 */
YFiles* yFirstFiles(void);

//--- (end of generated code: YFiles functions declaration)
NS_ASSUME_NONNULL_END
CF_EXTERN_C_END

