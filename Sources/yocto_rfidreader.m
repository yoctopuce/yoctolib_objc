/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Implements the high-level API for RfidReader functions
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


#import "yocto_rfidreader.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"


@implementation YRfidTagInfo
-(id) init
{
//--- (generated code: YRfidTagInfo attributes initialization)
    _tagType = 0;
    _size = 0;
    _usable = 0;
    _blksize = 0;
    _fblk = 0;
    _lblk = 0;
//--- (end of generated code: YRfidTagInfo attributes initialization)
    return self;
}
//--- (generated code: YRfidTagInfo yapiwrapper)
//--- (end of generated code: YRfidTagInfo yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (generated code: YRfidTagInfo cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YRfidTagInfo cleanup)
}
//--- (generated code: YRfidTagInfo private methods implementation)

//--- (end of generated code: YRfidTagInfo private methods implementation)
//--- (generated code: YRfidTagInfo public methods implementation)
/**
 * Returns the RFID tag identifier.
 *
 * @return a string with the RFID tag identifier.
 */
-(NSString*) get_tagId
{
    return _tagId;
}

/**
 * Returns the type of the RFID tag, as a numeric constant.
 * (IEC_14443_MIFARE_CLASSIC1K, ...).
 *
 * @return an integer corresponding to the RFID tag type
 */
-(int) get_tagType
{
    return _tagType;
}

/**
 * Returns the type of the RFID tag, as a string.
 *
 * @return a string corresponding to the RFID tag type
 */
-(NSString*) get_tagTypeStr
{
    return _typeStr;
}

/**
 * Returns the total memory size of the RFID tag, in bytes.
 *
 * @return the total memory size of the RFID tag
 */
-(int) get_tagMemorySize
{
    return _size;
}

/**
 * Returns the usable storage size of the RFID tag, in bytes.
 *
 * @return the usable storage size of the RFID tag
 */
-(int) get_tagUsableSize
{
    return _usable;
}

/**
 * Returns the block size of the RFID tag, in bytes.
 *
 * @return the block size of the RFID tag
 */
-(int) get_tagBlockSize
{
    return _blksize;
}

/**
 * Returns the index of the first usable storage block on the RFID tag.
 *
 * @return the index of the first usable storage block on the RFID tag
 */
-(int) get_tagFirstBlock
{
    return _fblk;
}

/**
 * Returns the index of the last usable storage block on the RFID tag.
 *
 * @return the index of the last usable storage block on the RFID tag
 */
-(int) get_tagLastBlock
{
    return _lblk;
}

-(void) imm_init:(NSString*)tagId :(int)tagType :(int)size :(int)usable :(int)blksize :(int)fblk :(int)lblk
{
    NSString* typeStr;
    typeStr = @"unknown";
    if (tagType == Y_IEC_15693) {
        typeStr = @"IEC 15693";
    }
    if (tagType == Y_IEC_14443) {
        typeStr = @"IEC 14443";
    }
    if (tagType == Y_IEC_14443_MIFARE_ULTRALIGHT) {
        typeStr = @"MIFARE Ultralight";
    }
    if (tagType == Y_IEC_14443_MIFARE_CLASSIC1K) {
        typeStr = @"MIFARE Classic 1K";
    }
    if (tagType == Y_IEC_14443_MIFARE_CLASSIC4K) {
        typeStr = @"MIFARE Classic 4K";
    }
    if (tagType == Y_IEC_14443_MIFARE_DESFIRE) {
        typeStr = @"MIFARE DESFire";
    }
    if (tagType == Y_IEC_14443_NTAG_213) {
        typeStr = @"NTAG 213";
    }
    if (tagType == Y_IEC_14443_NTAG_215) {
        typeStr = @"NTAG 215";
    }
    if (tagType == Y_IEC_14443_NTAG_216) {
        typeStr = @"NTAG 216";
    }
    if (tagType == Y_IEC_14443_NTAG_424_DNA) {
        typeStr = @"NTAG 424 DNA";
    }
    _tagId = tagId;
    _tagType = tagType;
    _typeStr = typeStr;
    _size = size;
    _usable = usable;
    _blksize = blksize;
    _fblk = fblk;
    _lblk = lblk;
}

//--- (end of generated code: YRfidTagInfo public methods implementation)
@end

//--- (generated code: YRfidTagInfo functions)
//--- (end of generated code: YRfidTagInfo functions)


@implementation YRfidStatus
-(id) init
{
//--- (generated code: YRfidStatus attributes initialization)
    _errCode = 0;
    _errBlk = 0;
    _yapierr = 0;
    _fab = 0;
    _lab = 0;
//--- (end of generated code: YRfidStatus attributes initialization)
    return self;
}
//--- (generated code: YRfidStatus yapiwrapper)
//--- (end of generated code: YRfidStatus yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (generated code: YRfidStatus cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YRfidStatus cleanup)
}
//--- (generated code: YRfidStatus private methods implementation)

//--- (end of generated code: YRfidStatus private methods implementation)
//--- (generated code: YRfidStatus public methods implementation)
/**
 * Returns RFID tag identifier related to the status.
 *
 * @return a string with the RFID tag identifier.
 */
-(NSString*) get_tagId
{
    return _tagId;
}

/**
 * Returns the detailled error code, or 0 if no error happened.
 *
 * @return a numeric error code
 */
-(int) get_errorCode
{
    return _errCode;
}

/**
 * Returns the RFID tag memory block number where the error was encountered, or -1 if the
 * error is not specific to a memory block.
 *
 * @return an RFID tag block number
 */
-(int) get_errorBlock
{
    return _errBlk;
}

/**
 * Returns a string describing precisely the RFID commande result.
 *
 * @return an error message string
 */
-(NSString*) get_errorMessage
{
    return _errMsg;
}

-(int) get_yapiError
{
    return _yapierr;
}

/**
 * Returns the block number of the first RFID tag memory block affected
 * by the operation. Depending on the type of operation and on the tag
 * memory granularity, this number may be smaller than the requested
 * memory block index.
 *
 * @return an RFID tag block number
 */
-(int) get_firstAffectedBlock
{
    return _fab;
}

/**
 * Returns the block number of the last RFID tag memory block affected
 * by the operation. Depending on the type of operation and on the tag
 * memory granularity, this number may be bigger than the requested
 * memory block index.
 *
 * @return an RFID tag block number
 */
-(int) get_lastAffectedBlock
{
    return _lab;
}

-(void) imm_init:(NSString*)tagId :(int)errCode :(int)errBlk :(int)fab :(int)lab
{
    NSString* errMsg;
    if (errCode == 0) {
        _yapierr = YAPI_SUCCESS;
        errMsg = @"Success (no error)";
    } else {
        if (errCode < 0) {
            if (errCode > -50) {
                _yapierr = errCode;
                errMsg = [NSString stringWithFormat:@"YoctoLib error %d",errCode];
            } else {
                _yapierr = YAPI_RFID_HARD_ERROR;
                errMsg = [NSString stringWithFormat:@"Non-recoverable RFID error %d",errCode];
            }
        } else {
            if (errCode > 1000) {
                _yapierr = YAPI_RFID_SOFT_ERROR;
                errMsg = [NSString stringWithFormat:@"Recoverable RFID error %d",errCode];
            } else {
                _yapierr = YAPI_RFID_HARD_ERROR;
                errMsg = [NSString stringWithFormat:@"Non-recoverable RFID error %d",errCode];
            }
        }
        if (errCode == Y_TAG_NOTFOUND) {
            errMsg = @"Tag not found";
        }
        if (errCode == Y_TAG_JUSTLEFT) {
            errMsg = @"Tag left during operation";
        }
        if (errCode == Y_TAG_LEFT) {
            errMsg = @"Tag not here anymore";
        }
        if (errCode == Y_READER_BUSY) {
            errMsg = @"Reader is busy";
        }
        if (errCode == Y_INVALID_CMD_ARGUMENTS) {
            errMsg = @"Invalid command arguments";
        }
        if (errCode == Y_UNKNOWN_CAPABILITIES) {
            errMsg = @"Unknown capabilities";
        }
        if (errCode == Y_MEMORY_NOT_SUPPORTED) {
            errMsg = @"Memory no present";
        }
        if (errCode == Y_INVALID_BLOCK_INDEX) {
            errMsg = @"Invalid block index";
        }
        if (errCode == Y_MEM_SPACE_UNVERRUN_ATTEMPT) {
            errMsg = @"Tag memory space overrun attempt";
        }
        if (errCode == Y_COMMAND_NOT_SUPPORTED) {
            errMsg = @"The command is not supported";
        }
        if (errCode == Y_COMMAND_NOT_RECOGNIZED) {
            errMsg = @"The command is not recognized";
        }
        if (errCode == Y_COMMAND_OPTION_NOT_RECOGNIZED) {
            errMsg = @"The command option is not supported.";
        }
        if (errCode == Y_COMMAND_CANNOT_BE_PROCESSED_IN_TIME) {
            errMsg = @"The command cannot be processed in time";
        }
        if (errCode == Y_UNDOCUMENTED_ERROR) {
            errMsg = @"Error with no information given";
        }
        if (errCode == Y_BLOCK_NOT_AVAILABLE) {
            errMsg = @"Block is not available";
        }
        if (errCode == Y_BLOCK_ALREADY_LOCKED) {
            errMsg = @"Block is already locked and thus cannot be locked again.";
        }
        if (errCode == Y_BLOCK_LOCKED) {
            errMsg = @"Block is locked and its content cannot be changed";
        }
        if (errCode == Y_BLOCK_NOT_SUCESSFULLY_PROGRAMMED) {
            errMsg = @"Block was not successfully programmed";
        }
        if (errCode == Y_BLOCK_NOT_SUCESSFULLY_LOCKED) {
            errMsg = @"Block was not successfully locked";
        }
        if (errCode == Y_BLOCK_IS_PROTECTED) {
            errMsg = @"Block is protected";
        }
        if (errCode == Y_CRYPTOGRAPHIC_ERROR) {
            errMsg = @"Generic cryptographic error";
        }
        if (errCode == Y_BROWNOUT_DETECTED) {
            errMsg = @"BrownOut detected (BOD)";
        }
        if (errCode == Y_BUFFER_OVERFLOW) {
            errMsg = @"Buffer Overflow (BOF)";
        }
        if (errCode == Y_CRC_ERROR) {
            errMsg = @"Communication CRC Error (CCE)";
        }
        if (errCode == Y_COLLISION_DETECTED) {
            errMsg = @"Collision Detected (CLD/CDT)";
        }
        if (errCode == Y_COMMAND_RECEIVE_TIMEOUT) {
            errMsg = @"Command Receive Timeout (CRT)";
        }
        if (errCode == Y_DID_NOT_SLEEP) {
            errMsg = @"Did Not Sleep (DNS)";
        }
        if (errCode == Y_ERROR_DECIMAL_EXPECTED) {
            errMsg = @"Error Decimal Expected (EDX)";
        }
        if (errCode == Y_HARDWARE_FAILURE) {
            errMsg = @"Error Hardware Failure (EHF)";
        }
        if (errCode == Y_ERROR_HEX_EXPECTED) {
            errMsg = @"Error Hex Expected (EHX)";
        }
        if (errCode == Y_FIFO_LENGTH_ERROR) {
            errMsg = @"FIFO length error (FLE)";
        }
        if (errCode == Y_FRAMING_ERROR) {
            errMsg = @"Framing error (FER)";
        }
        if (errCode == Y_NOT_IN_CNR_MODE) {
            errMsg = @"Not in CNR Mode (NCM)";
        }
        if (errCode == Y_NUMBER_OU_OF_RANGE) {
            errMsg = @"Number Out of Range (NOR)";
        }
        if (errCode == Y_NOT_SUPPORTED) {
            errMsg = @"Not Supported (NOS)";
        }
        if (errCode == Y_NO_RF_FIELD_ACTIVE) {
            errMsg = @"No RF field active (NRF)";
        }
        if (errCode == Y_READ_DATA_LENGTH_ERROR) {
            errMsg = @"Read data length error (RDL)";
        }
        if (errCode == Y_WATCHDOG_RESET) {
            errMsg = @"Watchdog reset (SRT)";
        }
        if (errCode == Y_TAG_COMMUNICATION_ERROR) {
            errMsg = @"Tag Communication Error (TCE)";
        }
        if (errCode == Y_TAG_NOT_RESPONDING) {
            errMsg = @"Tag Not Responding (TNR)";
        }
        if (errCode == Y_TIMEOUT_ERROR) {
            errMsg = @"TimeOut Error (TOE)";
        }
        if (errCode == Y_UNKNOW_COMMAND) {
            errMsg = @"Unknown Command (UCO)";
        }
        if (errCode == Y_UNKNOW_ERROR) {
            errMsg = @"Unknown error (UER)";
        }
        if (errCode == Y_UNKNOW_PARAMETER) {
            errMsg = @"Unknown Parameter (UPA)";
        }
        if (errCode == Y_UART_RECEIVE_ERROR) {
            errMsg = @"UART Receive Error (URE)";
        }
        if (errCode == Y_WRONG_DATA_LENGTH) {
            errMsg = @"Wrong Data Length (WDL)";
        }
        if (errCode == Y_WRONG_MODE) {
            errMsg = @"Wrong Mode (WMO)";
        }
        if (errCode == Y_UNKNOWN_DWARFxx_ERROR_CODE) {
            errMsg = @"Unknown DWARF15 error code";
        }
        if (errCode == Y_UNEXPECTED_TAG_ID_IN_RESPONSE) {
            errMsg = @"Unexpected Tag id in response";
        }
        if (errCode == Y_UNEXPECTED_TAG_INDEX) {
            errMsg = @"internal error : unexpected TAG index";
        }
        if (errCode == Y_TRANSFER_CLOSED) {
            errMsg = @"transfer closed";
        }
        if (errCode == Y_WRITE_DATA_MISSING) {
            errMsg = @"Missing write data";
        }
        if (errCode == Y_WRITE_TOO_MUCH_DATA) {
            errMsg = @"Attempt to write too much data";
        }
        if (errCode == Y_COULD_NOT_BUILD_REQUEST) {
            errMsg = @"Could not not request";
        }
        if (errCode == Y_INVALID_OPTIONS) {
            errMsg = @"Invalid transfer options";
        }
        if (errCode == Y_UNEXPECTED_RESPONSE) {
            errMsg = @"Unexpected Tag response";
        }
        if (errCode == Y_AFI_NOT_AVAILABLE) {
            errMsg = @"AFI not available";
        }
        if (errCode == Y_DSFID_NOT_AVAILABLE) {
            errMsg = @"DSFID not available";
        }
        if (errCode == Y_TAG_RESPONSE_TOO_SHORT) {
            errMsg = @"Tag's response too short";
        }
        if (errCode == Y_DEC_EXPECTED) {
            errMsg = @"Error Decimal value Expected, or is missing";
        }
        if (errCode == Y_HEX_EXPECTED) {
            errMsg = @"Error Hexadecimal value Expected, or is missing";
        }
        if (errCode == Y_NOT_SAME_SECOR) {
            errMsg = @"Input and Output block are not in the same Sector";
        }
        if (errCode == Y_MIFARE_AUTHENTICATED) {
            errMsg = @"No chip with MIFARE Classic technology Authenticated";
        }
        if (errCode == Y_NO_DATABLOCK) {
            errMsg = @"No Data Block";
        }
        if (errCode == Y_KEYB_IS_READABLE) {
            errMsg = @"Key B is Readable";
        }
        if (errCode == Y_OPERATION_NOT_EXECUTED) {
            errMsg = @"Operation Not Executed, would have caused an overflow";
        }
        if (errCode == Y_BLOK_MODE_ERROR) {
            errMsg = @"Block has not been initialized as a 'value block'";
        }
        if (errCode == Y_BLOCK_NOT_WRITABLE) {
            errMsg = @"Block Not Writable";
        }
        if (errCode == Y_BLOCK_ACCESS_ERROR) {
            errMsg = @"Block Access Error";
        }
        if (errCode == Y_BLOCK_NOT_AUTHENTICATED) {
            errMsg = @"Block Not Authenticated";
        }
        if (errCode == Y_ACCESS_KEY_BIT_NOT_WRITABLE) {
            errMsg = @"Access bits or Keys not Writable";
        }
        if (errCode == Y_USE_KEYA_FOR_AUTH) {
            errMsg = @"Use Key B for authentication";
        }
        if (errCode == Y_USE_KEYB_FOR_AUTH) {
            errMsg = @"Use Key A for authentication";
        }
        if (errCode == Y_KEY_NOT_CHANGEABLE) {
            errMsg = @"Key(s) not changeable";
        }
        if (errCode == Y_BLOCK_TOO_HIGH) {
            errMsg = @"Block index is too high";
        }
        if (errCode == Y_AUTH_ERR) {
            errMsg = @"Authentication Error (i.e. wrong key)";
        }
        if (errCode == Y_NOKEY_SELECT) {
            errMsg = @"No Key Select, select a temporary or a static key";
        }
        if (errCode == Y_CARD_NOT_SELECTED) {
            errMsg = @" Card is Not Selected";
        }
        if (errCode == Y_BLOCK_TO_READ_NONE) {
            errMsg = @"Number of Blocks to Read is 0";
        }
        if (errCode == Y_NO_TAG) {
            errMsg = @"No Tag detected";
        }
        if (errCode == Y_TOO_MUCH_DATA) {
            errMsg = @"Too Much Data (i.e. Uart input buffer overflow)";
        }
        if (errCode == Y_CON_NOT_SATISFIED) {
            errMsg = @"Conditions Not Satisfied";
        }
        if (errCode == Y_BLOCK_IS_SPECIAL) {
            errMsg = @"Bad parameter: block is a special block";
        }
        if (errCode == Y_READ_BEYOND_ANNOUNCED_SIZE) {
            errMsg = @"Attempt to read more than announced size.";
        }
        if (errCode == Y_BLOCK_ZERO_IS_RESERVED) {
            errMsg = @"Block 0 is reserved and cannot be used";
        }
        if (errCode == Y_VALUE_BLOCK_BAD_FORMAT) {
            errMsg = @"One value block is not properly initialized";
        }
        if (errCode == Y_ISO15693_ONLY_FEATURE) {
            errMsg = @"Feature available on ISO 15693 only";
        }
        if (errCode == Y_ISO14443_ONLY_FEATURE) {
            errMsg = @"Feature available on ISO 14443 only";
        }
        if (errCode == Y_MIFARE_CLASSIC_ONLY_FEATURE) {
            errMsg = @"Feature available on ISO 14443 MIFARE Classic only";
        }
        if (errCode == Y_BLOCK_MIGHT_BE_PROTECTED) {
            errMsg = @"Block might be protected";
        }
        if (errCode == Y_NO_SUCH_BLOCK) {
            errMsg = @"No such block";
        }
        if (errCode == Y_COUNT_TOO_BIG) {
            errMsg = @"Count parameter is too large";
        }
        if (errCode == Y_UNKNOWN_MEM_SIZE) {
            errMsg = @"Tag memory size is unknown";
        }
        if (errCode == Y_MORE_THAN_2BLOCKS_MIGHT_NOT_WORK) {
            errMsg = @"Writing more than two blocks at once might not be supported by self tag";
        }
        if (errCode == Y_READWRITE_NOT_SUPPORTED) {
            errMsg = @"Read/write operation not supported for self tag";
        }
        if (errCode == Y_UNEXPECTED_VICC_ID_IN_RESPONSE) {
            errMsg = @"Unexpected VICC ID in response";
        }
        if (errCode == Y_LOCKBLOCK_NOT_SUPPORTED) {
            errMsg = @"This tag does not support the Lock block function";
        }
        if (errCode == Y_INTERNAL_ERROR_SHOULD_NEVER_HAPPEN) {
            errMsg = @"Yoctopuce RFID code ran into an unexpected state, please contact support";
        }
        if (errCode == Y_INVLD_BLOCK_MODE_COMBINATION) {
            errMsg = @"Invalid combination of block mode options";
        }
        if (errCode == Y_INVLD_ACCESS_MODE_COMBINATION) {
            errMsg = @"Invalid combination of access mode options";
        }
        if (errCode == Y_INVALID_SIZE) {
            errMsg = @"Invalid data size parameter";
        }
        if (errCode == Y_BAD_PASSWORD_FORMAT) {
            errMsg = @"Bad password format or type";
        }
        if (errBlk >= 0) {
            errMsg = [NSString stringWithFormat:@"%@ (block %d)", errMsg,errBlk];
        }
    }
    _tagId = tagId;
    _errCode = errCode;
    _errBlk = errBlk;
    _errMsg = errMsg;
    _fab = fab;
    _lab = lab;
}

//--- (end of generated code: YRfidStatus public methods implementation)
@end

//--- (generated code: YRfidStatus functions)
//--- (end of generated code: YRfidStatus functions)


@implementation YRfidOptions
-(id) init
{
//--- (generated code: YRfidOptions attributes initialization)
    KeyType = 0;
//--- (end of generated code: YRfidOptions attributes initialization)
    return self;
}
//--- (generated code: YRfidOptions yapiwrapper)
//--- (end of generated code: YRfidOptions yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (generated code: YRfidOptions cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YRfidOptions cleanup)
}
//--- (generated code: YRfidOptions private methods implementation)

//--- (end of generated code: YRfidOptions private methods implementation)
//--- (generated code: YRfidOptions public methods implementation)
-(NSString*) imm_getParams
{
    int opt;
    NSString* res;
    if (ForceSingleBlockAccess) {
        opt = 1;
    } else {
        opt = 0;
    }
    if (ForceMultiBlockAccess) {
        opt = ((opt) | (2));
    }
    if (EnableRawAccess) {
        opt = ((opt) | (4));
    }
    if (DisableBoundaryChecks) {
        opt = ((opt) | (8));
    }
    if (EnableDryRun) {
        opt = ((opt) | (16));
    }
    res = [NSString stringWithFormat:@"&o=%d",opt];
    if (KeyType != 0) {
        res = [NSString stringWithFormat:@"%@&k=%02x:%@", res, KeyType,HexKey];
    }
    return res;
}

//--- (end of generated code: YRfidOptions public methods implementation)
@end

//--- (generated code: YRfidOptions functions)
//--- (end of generated code: YRfidOptions functions)


@implementation YRfidReader
// Constructor is protected, use yFindRfidReader factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"RfidReader";
//--- (generated code: YRfidReader attributes initialization)
    _nTags = Y_NTAGS_INVALID;
    _refreshRate = Y_REFRESHRATE_INVALID;
    _valueCallbackRfidReader = NULL;
    _eventCallback = NULL;
    _prevCbPos = 0;
    _eventPos = 0;
    _eventStamp = 0;
//--- (end of generated code: YRfidReader attributes initialization)
    return self;
}
//--- (generated code: YRfidReader yapiwrapper)
static void yInternalEventCallback(YRfidReader *obj, NSString *value)
{
    [obj _internalEventHandler:value];
}
//--- (end of generated code: YRfidReader yapiwrapper)
// destructor
-(void)  dealloc
{
//--- (generated code: YRfidReader cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YRfidReader cleanup)
}
//--- (generated code: YRfidReader private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "nTags")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _nTags =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "refreshRate")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _refreshRate =  atoi(j->token);
        return 1;
    }
    return [super _parseAttr:j];
}
//--- (end of generated code: YRfidReader private methods implementation)
//--- (generated code: YRfidReader public methods implementation)
/**
 * Returns the number of RFID tags currently detected.
 *
 * @return an integer corresponding to the number of RFID tags currently detected
 *
 * On failure, throws an exception or returns YRfidReader.NTAGS_INVALID.
 */
-(int) get_nTags
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_NTAGS_INVALID;
        }
    }
    res = _nTags;
    return res;
}


-(int) nTags
{
    return [self get_nTags];
}
/**
 * Returns the tag list refresh rate, measured in Hz.
 *
 * @return an integer corresponding to the tag list refresh rate, measured in Hz
 *
 * On failure, throws an exception or returns YRfidReader.REFRESHRATE_INVALID.
 */
-(int) get_refreshRate
{
    int res;
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI_yapiContext GetCacheValidity]] != YAPI_SUCCESS) {
            return Y_REFRESHRATE_INVALID;
        }
    }
    res = _refreshRate;
    return res;
}


-(int) refreshRate
{
    return [self get_refreshRate];
}

/**
 * Changes the present tag list refresh rate, measured in Hz. The reader will do
 * its best to respect it. Note that the reader cannot detect tag arrival or removal
 * while it is  communicating with a tag.  Maximum frequency is limited to 100Hz,
 * but in real life it will be difficult to do better than 50Hz.
 * Remember to call the saveToFlash() method of the module if the
 * modification must be kept.
 *
 * @param newval : an integer corresponding to the present tag list refresh rate, measured in Hz
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_refreshRate:(int) newval
{
    return [self setRefreshRate:newval];
}
-(int) setRefreshRate:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"refreshRate" :rest_val];
}
/**
 * Retrieves a RFID reader for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the RFID reader is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YRfidReader.isOnline() to test if the RFID reader is
 * indeed online at a given time. In case of ambiguity when looking for
 * a RFID reader by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * If a call to this object's is_online() method returns FALSE although
 * you are certain that the matching device is plugged, make sure that you did
 * call registerHub() at application initialization time.
 *
 * @param func : a string that uniquely characterizes the RFID reader, for instance
 *         MyDevice.rfidReader.
 *
 * @return a YRfidReader object allowing you to drive the RFID reader.
 */
+(YRfidReader*) FindRfidReader:(NSString*)func
{
    YRfidReader* obj;
    obj = (YRfidReader*) [YFunction _FindFromCache:@"RfidReader" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YRfidReader alloc] initWith:func]);
        [YFunction _AddToCache:@"RfidReader" : func :obj];
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
-(int) registerValueCallback:(YRfidReaderValueCallback _Nullable)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackRfidReader = callback;
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
    if (_valueCallbackRfidReader != NULL) {
        _valueCallbackRfidReader(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) _chkerror:(NSString*)tagId :(NSData*)json :(YRfidStatus*)status
{
    NSString* jsonStr;
    int errCode;
    int errBlk;
    int fab;
    int lab;
    int retcode;

    if ((int)[json length] == 0) {
        errCode = [self get_errorType];
        errBlk = -1;
        fab = -1;
        lab = -1;
    } else {
        jsonStr = ARC_sendAutorelease([[NSString alloc] initWithData:json encoding:NSISOLatin1StringEncoding]);
        errCode = [[self _json_get_key:json :@"err"] intValue];
        errBlk = [[self _json_get_key:json :@"errBlk"] intValue]-1;
        if (_ystrpos(jsonStr, @"\"fab\":") >= 0) {
            fab = [[self _json_get_key:json :@"fab"] intValue]-1;
            lab = [[self _json_get_key:json :@"lab"] intValue]-1;
        } else {
            fab = -1;
            lab = -1;
        }
    }
    [status imm_init:tagId : errCode : errBlk : fab :lab];
    retcode = [status get_yapiError];
    if (!(retcode == YAPI_SUCCESS)) {[self _throw: retcode: [status get_errorMessage]]; return retcode;}
    return YAPI_SUCCESS;
}

-(int) reset
{
    NSMutableData* json;
    YRfidStatus* status;
    status = ARC_sendAutorelease([[YRfidStatus alloc] init]);

    json = [self _download:@"rfid.json?a=reset"];
    return [self _chkerror:@"" : json :status];
}

/**
 * Returns the list of RFID tags currently detected by the reader.
 *
 * @return a list of strings, corresponding to each tag identifier.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_tagIdList
{
    NSMutableData* json;
    NSMutableArray* jsonList = [NSMutableArray array];
    NSMutableArray* taglist = [NSMutableArray array];

    json = [self _download:@"rfid.json?a=list"];
    [taglist removeAllObjects];
    if ((int)[json length] > 3) {
        jsonList = [self _json_get_array:json];
        for (NSString* _each  in jsonList) {
            [taglist addObject:[self _json_get_string:[NSMutableData dataWithData:[_each dataUsingEncoding:NSISOLatin1StringEncoding]]]];
        }
    }
    return taglist;
}

/**
 * Retourne la description des propriétés d'un tag RFID présent.
 * Cette fonction peut causer des communications avec le tag.
 *
 * @param tagId : identifier of the tag to check
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns an empty YRfidTagInfo objact.
 * When it happens, you can get more information from the status object.
 */
-(YRfidTagInfo*) get_tagInfo:(NSString*)tagId :(YRfidStatus*)status
{
    NSString* url;
    NSMutableData* json;
    int tagType;
    int size;
    int usable;
    int blksize;
    int fblk;
    int lblk;
    YRfidTagInfo* res;
    url = [NSString stringWithFormat:@"rfid.json?a=info&t=%@",tagId];

    json = [self _download:url];
    [self _chkerror:tagId : json :status];
    tagType = [[self _json_get_key:json :@"type"] intValue];
    size = [[self _json_get_key:json :@"size"] intValue];
    usable = [[self _json_get_key:json :@"usable"] intValue];
    blksize = [[self _json_get_key:json :@"blksize"] intValue];
    fblk = [[self _json_get_key:json :@"fblk"] intValue];
    lblk = [[self _json_get_key:json :@"lblk"] intValue];
    res = ARC_sendAutorelease([[YRfidTagInfo alloc] init]);
    [res imm_init:tagId : tagType : size : usable : blksize : fblk :lblk];
    return res;
}

/**
 * Change an RFID tag configuration to prevents any further write to
 * the selected blocks. This operation is definitive and irreversible.
 * Depending on the tag type and block index, adjascent blocks may become
 * read-only as well, based on the locking granularity.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : first block to lock
 * @param nBlocks : number of blocks to lock
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code. When it
 * happens, you can get more information from the status object.
 */
-(int) tagLockBlocks:(NSString*)tagId :(int)firstBlock :(int)nBlocks :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSString* optstr;
    NSString* url;
    NSMutableData* json;
    optstr = [options imm_getParams];
    url = [NSString stringWithFormat:@"rfid.json?a=lock&t=%@&b=%d&n=%d%@",tagId,firstBlock,nBlocks,optstr];

    json = [self _download:url];
    return [self _chkerror:tagId : json :status];
}

/**
 * Reads the locked state for RFID tag memory data blocks.
 * FirstBlock cannot be a special block, and any special
 * block encountered in the middle of the read operation will be
 * skipped automatically.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : number of the first block to check
 * @param nBlocks : number of blocks to check
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return a list of booleans with the lock state of selected blocks
 *
 * On failure, throws an exception or returns an empty list. When it
 * happens, you can get more information from the status object.
 */
-(NSMutableArray*) get_tagLockState:(NSString*)tagId :(int)firstBlock :(int)nBlocks :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSString* optstr;
    NSString* url;
    NSMutableData* json;
    NSMutableData* binRes;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int val;
    bool isLocked;
    optstr = [options imm_getParams];
    url = [NSString stringWithFormat:@"rfid.json?a=chkl&t=%@&b=%d&n=%d%@",tagId,firstBlock,nBlocks,optstr];

    json = [self _download:url];
    [self _chkerror:tagId : json :status];
    if ([status get_yapiError] != YAPI_SUCCESS) {
        return res;
    }
    binRes = [YAPI _hexStr2Bin:[self _json_get_key:json :@"bitmap"]];
    idx = 0;
    while (idx < nBlocks) {
        val = (((u8*)([binRes bytes]))[((idx) >> (3))]);
        isLocked = (((val) & (((1) << (((idx) & (7)))))) != 0);
        [res addObject:[NSNumber numberWithLong:isLocked]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Tells which block of a RFID tag memory are special and cannot be used
 * to store user data. Mistakely writing a special block can lead to
 * an irreversible alteration of the tag.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : number of the first block to check
 * @param nBlocks : number of blocks to check
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return a list of booleans with the lock state of selected blocks
 *
 * On failure, throws an exception or returns an empty list. When it
 * happens, you can get more information from the status object.
 */
-(NSMutableArray*) get_tagSpecialBlocks:(NSString*)tagId :(int)firstBlock :(int)nBlocks :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSString* optstr;
    NSString* url;
    NSMutableData* json;
    NSMutableData* binRes;
    NSMutableArray* res = [NSMutableArray array];
    int idx;
    int val;
    bool isLocked;
    optstr = [options imm_getParams];
    url = [NSString stringWithFormat:@"rfid.json?a=chks&t=%@&b=%d&n=%d%@",tagId,firstBlock,nBlocks,optstr];

    json = [self _download:url];
    [self _chkerror:tagId : json :status];
    if ([status get_yapiError] != YAPI_SUCCESS) {
        return res;
    }
    binRes = [YAPI _hexStr2Bin:[self _json_get_key:json :@"bitmap"]];
    idx = 0;
    while (idx < nBlocks) {
        val = (((u8*)([binRes bytes]))[((idx) >> (3))]);
        isLocked = (((val) & (((1) << (((idx) & (7)))))) != 0);
        [res addObject:[NSNumber numberWithLong:isLocked]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Reads data from an RFID tag memory, as an hexadecimal string.
 * The read operation may span accross multiple blocks if the requested
 * number of bytes is larger than the RFID tag block size. By default
 * firstBlock cannot be a special block, and any special block encountered
 * in the middle of the read operation will be skipped automatically.
 * If you rather want to read special blocks, use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where read should start
 * @param nBytes : total number of bytes to read
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return an hexadecimal string if the call succeeds.
 *
 * On failure, throws an exception or returns an empty binary buffer. When it
 * happens, you can get more information from the status object.
 */
-(NSString*) tagReadHex:(NSString*)tagId :(int)firstBlock :(int)nBytes :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSString* optstr;
    NSString* url;
    NSMutableData* json;
    NSString* hexbuf;
    optstr = [options imm_getParams];
    url = [NSString stringWithFormat:@"rfid.json?a=read&t=%@&b=%d&n=%d%@",tagId,firstBlock,nBytes,optstr];

    json = [self _download:url];
    [self _chkerror:tagId : json :status];
    if ([status get_yapiError] == YAPI_SUCCESS) {
        hexbuf = [self _json_get_key:json :@"res"];
    } else {
        hexbuf = @"";
    }
    return hexbuf;
}

/**
 * Reads data from an RFID tag memory, as a binary buffer. The read operation
 * may span accross multiple blocks if the requested number of bytes
 * is larger than the RFID tag block size.  By default
 * firstBlock cannot be a special block, and any special block encountered
 * in the middle of the read operation will be skipped automatically.
 * If you rather want to read special blocks, use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where read should start
 * @param nBytes : total number of bytes to read
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return a binary object with the data read if the call succeeds.
 *
 * On failure, throws an exception or returns an empty binary buffer. When it
 * happens, you can get more information from the status object.
 */
-(NSMutableData*) tagReadBin:(NSString*)tagId :(int)firstBlock :(int)nBytes :(YRfidOptions*)options :(YRfidStatus*)status
{
    return [YAPI _hexStr2Bin:[self tagReadHex:tagId : firstBlock : nBytes : options :status]];
}

/**
 * Reads data from an RFID tag memory, as a byte list. The read operation
 * may span accross multiple blocks if the requested number of bytes
 * is larger than the RFID tag block size.  By default
 * firstBlock cannot be a special block, and any special block encountered
 * in the middle of the read operation will be skipped automatically.
 * If you rather want to read special blocks, use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where read should start
 * @param nBytes : total number of bytes to read
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return a byte list with the data read if the call succeeds.
 *
 * On failure, throws an exception or returns an empty list. When it
 * happens, you can get more information from the status object.
 */
-(NSMutableArray*) tagReadArray:(NSString*)tagId :(int)firstBlock :(int)nBytes :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSMutableData* blk;
    int idx;
    int endidx;
    NSMutableArray* res = [NSMutableArray array];
    blk = [self tagReadBin:tagId : firstBlock : nBytes : options :status];
    endidx = (int)[blk length];
    idx = 0;
    while (idx < endidx) {
        [res addObject:[NSNumber numberWithLong:(((u8*)([blk bytes]))[idx])]];
        idx = idx + 1;
    }
    return res;
}

/**
 * Reads data from an RFID tag memory, as a text string. The read operation
 * may span accross multiple blocks if the requested number of bytes
 * is larger than the RFID tag block size.  By default
 * firstBlock cannot be a special block, and any special block encountered
 * in the middle of the read operation will be skipped automatically.
 * If you rather want to read special blocks, use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where read should start
 * @param nChars : total number of characters to read
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return a text string with the data read if the call succeeds.
 *
 * On failure, throws an exception or returns an empty string. When it
 * happens, you can get more information from the status object.
 */
-(NSString*) tagReadStr:(NSString*)tagId :(int)firstBlock :(int)nChars :(YRfidOptions*)options :(YRfidStatus*)status
{
    return ARC_sendAutorelease([[NSString alloc] initWithData:[self tagReadBin:tagId : firstBlock : nChars : options :status] encoding:NSISOLatin1StringEncoding]);
}

/**
 * Writes data provided as a binary buffer to an RFID tag memory.
 * The write operation may span accross multiple blocks if the
 * number of bytes to write is larger than the RFID tag block size.
 * By default firstBlock cannot be a special block, and any special block
 * encountered in the middle of the write operation will be skipped
 * automatically. If you rather want to rewrite special blocks as well,
 * use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where write should start
 * @param buff : the binary buffer to write
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code. When it
 * happens, you can get more information from the status object.
 */
-(int) tagWriteBin:(NSString*)tagId :(int)firstBlock :(NSData*)buff :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSString* optstr;
    NSString* hexstr;
    int buflen;
    NSString* fname;
    NSMutableData* json;
    buflen = (int)[buff length];
    if (buflen <= 16) {
        // short data, use an URL-based command
        hexstr = [YAPI _bin2HexStr:buff];
        return [self tagWriteHex:tagId : firstBlock : hexstr : options :status];
    } else {
        // long data, use an upload command
        optstr = [options imm_getParams];
        fname = [NSString stringWithFormat:@"Rfid:t=%@&b=%d&n=%d%@",tagId,firstBlock,buflen,optstr];
        json = [self _uploadEx:fname :buff];
        return [self _chkerror:tagId : json :status];
    }
}

/**
 * Writes data provided as a list of bytes to an RFID tag memory.
 * The write operation may span accross multiple blocks if the
 * number of bytes to write is larger than the RFID tag block size.
 * By default firstBlock cannot be a special block, and any special block
 * encountered in the middle of the write operation will be skipped
 * automatically. If you rather want to rewrite special blocks as well,
 * use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where write should start
 * @param byteList : a list of byte to write
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code. When it
 * happens, you can get more information from the status object.
 */
-(int) tagWriteArray:(NSString*)tagId :(int)firstBlock :(NSMutableArray*)byteList :(YRfidOptions*)options :(YRfidStatus*)status
{
    int bufflen;
    NSMutableData* buff;
    int idx;
    int hexb;
    bufflen = (int)[byteList count];
    buff = [NSMutableData dataWithLength:bufflen];
    idx = 0;
    while (idx < bufflen) {
        hexb = [[byteList objectAtIndex:idx] intValue];
        (((u8*)([buff mutableBytes]))[ idx]) = hexb;
        idx = idx + 1;
    }

    return [self tagWriteBin:tagId : firstBlock : buff : options :status];
}

/**
 * Writes data provided as an hexadecimal string to an RFID tag memory.
 * The write operation may span accross multiple blocks if the
 * number of bytes to write is larger than the RFID tag block size.
 * By default firstBlock cannot be a special block, and any special block
 * encountered in the middle of the write operation will be skipped
 * automatically. If you rather want to rewrite special blocks as well,
 * use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where write should start
 * @param hexString : a string of hexadecimal byte codes to write
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code. When it
 * happens, you can get more information from the status object.
 */
-(int) tagWriteHex:(NSString*)tagId :(int)firstBlock :(NSString*)hexString :(YRfidOptions*)options :(YRfidStatus*)status
{
    int bufflen;
    NSString* optstr;
    NSString* url;
    NSMutableData* json;
    NSMutableData* buff;
    int idx;
    int hexb;
    bufflen = (int)[(hexString) length];
    bufflen = ((bufflen) >> (1));
    if (bufflen <= 16) {
        // short data, use an URL-based command
        optstr = [options imm_getParams];
        url = [NSString stringWithFormat:@"rfid.json?a=writ&t=%@&b=%d&w=%@%@",tagId,firstBlock,hexString,optstr];
        json = [self _download:url];
        return [self _chkerror:tagId : json :status];
    } else {
        // long data, use an upload command
        buff = [NSMutableData dataWithLength:bufflen];
        idx = 0;
        while (idx < bufflen) {
            hexb = (int)strtoul(STR_oc2y([hexString substringWithRange:NSMakeRange( 2 * idx, 2)]), NULL, 16);
            (((u8*)([buff mutableBytes]))[ idx]) = hexb;
            idx = idx + 1;
        }
        return [self tagWriteBin:tagId : firstBlock : buff : options :status];
    }
}

/**
 * Writes data provided as an ASCII string to an RFID tag memory.
 * The write operation may span accross multiple blocks if the
 * number of bytes to write is larger than the RFID tag block size.
 * By default firstBlock cannot be a special block, and any special block
 * encountered in the middle of the write operation will be skipped
 * automatically. If you rather want to rewrite special blocks as well,
 * use EnableRawAccess option.
 *
 * @param tagId : identifier of the tag to use
 * @param firstBlock : block number where write should start
 * @param text : the text string to write
 * @param options : an YRfidOptions object with the optional
 *         command execution parameters, such as security key
 *         if required
 * @param status : an RfidStatus object that will contain
 *         the detailled status of the operation
 *
 * @return YAPI.SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code. When it
 * happens, you can get more information from the status object.
 */
-(int) tagWriteStr:(NSString*)tagId :(int)firstBlock :(NSString*)text :(YRfidOptions*)options :(YRfidStatus*)status
{
    NSMutableData* buff;
    buff = [NSMutableData dataWithData:[text dataUsingEncoding:NSISOLatin1StringEncoding]];

    return [self tagWriteBin:tagId : firstBlock : buff : options :status];
}

/**
 * Returns a string with last tag arrival/removal events observed.
 * This method return only events that are still buffered in the device memory.
 *
 * @return a string with last events observed (one per line).
 *
 * On failure, throws an exception or returns  YAPI_INVALID_STRING.
 */
-(NSString*) get_lastEvents
{
    NSMutableData* content;

    content = [self _download:@"events.txt"];
    return ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
}

/**
 * Registers a callback function to be called each time that an RFID tag appears or
 * disappears. The callback is invoked only during the execution of
 * ySleep or yHandleEvents. This provides control over the time when
 * the callback is triggered. For good responsiveness, remember to call one of these
 * two functions periodically. To unregister a callback, pass a nil pointer as argument.
 *
 * @param callback : the callback function to call, or a nil pointer.
 *         The callback function should take four arguments:
 *         the YRfidReader object that emitted the event, the
 *         UTC timestamp of the event, a character string describing
 *         the type of event ("+" or "-") and a character string with the
 *         RFID tag identifier.
 *         On failure, throws an exception or returns a negative error code.
 */
-(int) registerEventCallback:(YEventCallback _Nullable)callback
{
    _eventCallback = callback;
    _isFirstCb = YES;
    if (callback != NULL) {
        [self registerValueCallback:yInternalEventCallback];
    } else {
        [self registerValueCallback:(YRfidReaderValueCallback) nil];
    }
    return 0;
}

-(int) _internalEventHandler:(NSString*)cbVal
{
    int cbPos;
    int cbDPos;
    int cbNtags;
    int searchTags;
    NSString* url;
    NSMutableData* content;
    NSString* contentStr;
    NSMutableArray* currentTags = [NSMutableArray array];
    NSMutableArray* eventArr = [NSMutableArray array];
    int arrLen;
    NSMutableArray* lastEvents = [NSMutableArray array];
    NSString* lenStr;
    int arrPos;
    NSString* eventStr;
    int eventLen;
    NSString* hexStamp;
    int typePos;
    int dataPos;
    int evtStamp;
    NSString* evtType;
    NSString* evtData;
    int tagIdx;
    // detect possible power cycle of the reader to clear event pointer
    cbPos = [cbVal intValue];
    cbNtags = ((cbPos) % (1000));
    cbPos = ((cbPos) / (1000));
    cbDPos = ((cbPos - _prevCbPos) & (0x7ffff));
    _prevCbPos = cbPos;
    if (cbDPos > 16384) {
        _eventPos = 0;
    }
    if (!(_eventCallback != NULL)) {
        return YAPI_SUCCESS;
    }
    // load all events since previous call
    url = [NSString stringWithFormat:@"events.txt?pos=%d",_eventPos];

    content = [self _download:url];
    contentStr = ARC_sendAutorelease([[NSString alloc] initWithData:content encoding:NSISOLatin1StringEncoding]);
    eventArr = [NSMutableArray arrayWithArray:[contentStr componentsSeparatedByString:@"\n"]];
    arrLen = (int)[eventArr count];
    if (!(arrLen > 0)) {[self _throw: YAPI_IO_ERROR: @"fail to download events"]; return YAPI_IO_ERROR;}
    // last element of array is the new position preceeded by '@'
    arrLen = arrLen - 1;
    lenStr = [eventArr objectAtIndex:arrLen];
    lenStr = [lenStr substringWithRange:NSMakeRange( 1, (int)[(lenStr) length]-1)];
    // update processed event position pointer
    _eventPos = [lenStr intValue];
    if (_isFirstCb) {
        // first emulated value callback caused by registerValueCallback:
        // attempt to retrieve arrivals of all tags present to emulate arrival
        _isFirstCb = NO;
        _eventStamp = 0;
        if (cbNtags == 0) {
            return YAPI_SUCCESS;
        }
        currentTags = [self get_tagIdList];
        cbNtags = (int)[currentTags count];
        searchTags = cbNtags;
        [lastEvents removeAllObjects];
        arrPos = arrLen - 1;
        while ((arrPos >= 0) && (searchTags > 0)) {
            eventStr = [eventArr objectAtIndex:arrPos];
            typePos = _ystrpos(eventStr, @":")+1;
            if (typePos > 8) {
                dataPos = _ystrpos(eventStr, @"=")+1;
                evtType = [eventStr substringWithRange:NSMakeRange( typePos, 1)];
                if ((dataPos > 10) && [evtType isEqualToString:@"+"]) {
                    evtData = [eventStr substringWithRange:NSMakeRange( dataPos, (int)[(eventStr) length]-dataPos)];
                    tagIdx = searchTags - 1;
                    while (tagIdx >= 0) {
                        if ([evtData isEqualToString:[currentTags objectAtIndex:tagIdx]]) {
                            [lastEvents addObject:[NSNumber numberWithLong:0+arrPos]];
                            [currentTags replaceObjectAtIndex:tagIdx withObject:@""];
                            while ((searchTags > 0) && [[currentTags objectAtIndex:searchTags-1] isEqualToString:@""]) {
                                searchTags = searchTags - 1;
                            }
                            tagIdx = -1;
                        }
                        tagIdx = tagIdx - 1;
                    }
                }
            }
            arrPos = arrPos - 1;
        }
        // If we have any remaining tags without a known arrival event,
        // create a pseudo callback with timestamp zero
        tagIdx = 0;
        while (tagIdx < searchTags) {
            evtData = [currentTags objectAtIndex:tagIdx];
            if (!([evtData isEqualToString:@""])) {
                _eventCallback(self, 0, @"+", evtData);
            }
            tagIdx = tagIdx + 1;
        }
    } else {
        // regular callback
        [lastEvents removeAllObjects];
        arrPos = arrLen - 1;
        while (arrPos >= 0) {
            [lastEvents addObject:[NSNumber numberWithLong:0+arrPos]];
            arrPos = arrPos - 1;
        }
    }
    // now generate callbacks for each selected event
    arrLen = (int)[lastEvents count];
    arrPos = arrLen - 1;
    while (arrPos >= 0) {
        tagIdx = [[lastEvents objectAtIndex:arrPos] intValue];
        eventStr = [eventArr objectAtIndex:tagIdx];
        eventLen = (int)[(eventStr) length];
        if (eventLen >= 1) {
            hexStamp = [eventStr substringWithRange:NSMakeRange( 0, 8)];
            evtStamp = (int)strtoul(STR_oc2y(hexStamp), NULL, 16);
            typePos = _ystrpos(eventStr, @":")+1;
            if ((evtStamp >= _eventStamp) && (typePos > 8)) {
                _eventStamp = evtStamp;
                dataPos = _ystrpos(eventStr, @"=")+1;
                evtType = [eventStr substringWithRange:NSMakeRange( typePos, 1)];
                evtData = @"";
                if (dataPos > 10) {
                    evtData = [eventStr substringWithRange:NSMakeRange( dataPos, eventLen-dataPos)];
                }
                _eventCallback(self, evtStamp, evtType, evtData);
            }
        }
        arrPos = arrPos - 1;
    }
    return YAPI_SUCCESS;
}


-(YRfidReader*)   nextRfidReader
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YRfidReader FindRfidReader:hwid];
}

+(YRfidReader *) FirstRfidReader
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"RfidReader":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YRfidReader FindRfidReader:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YRfidReader public methods implementation)
@end

//--- (generated code: YRfidReader functions)

YRfidReader *yFindRfidReader(NSString* func)
{
    return [YRfidReader FindRfidReader:func];
}

YRfidReader *yFirstRfidReader(void)
{
    return [YRfidReader FirstRfidReader];
}

//--- (end of generated code: YRfidReader functions)

