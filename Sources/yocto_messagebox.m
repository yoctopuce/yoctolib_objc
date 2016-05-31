/*********************************************************************
 *
 * $Id: yocto_messagebox.m 24649 2016-05-31 11:20:13Z mvuilleu $
 *
 * Implements the high-level API for MessageBox functions
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


#import "yocto_messagebox.h"
#include "yapi/yjson.h"
#include "yapi/yapi.h"

@implementation YSms

-(id)              initWith:(YMessageBox*)mbox
{
   if(!(self = [super init]))
          return nil;
//--- (generated code: YSms attributes initialization)
    _slot = 0;
    _mref = 0;
    _pid = 0;
    _alphab = 0;
    _mclass = 0;
    _npdu = 0;
    _parts = [NSMutableArray array];
    _aggIdx = 0;
    _aggCnt = 0;
//--- (end of generated code: YSms attributes initialization)
    _mbox = mbox;
    return self;
}
// destructor
-(void)  dealloc
{
//--- (generated code: YSms cleanup)
    ARC_dealloc(super);
//--- (end of generated code: YSms cleanup)
}
//--- (generated code: YSms private methods implementation)

//--- (end of generated code: YSms private methods implementation)
//--- (generated code: YSms public methods implementation)
-(int) get_slot
{
    return _slot;
}

-(NSString*) get_smsc
{
    return _smsc;
}

-(int) get_msgRef
{
    return _mref;
}

-(NSString*) get_sender
{
    return _orig;
}

-(NSString*) get_recipient
{
    return _dest;
}

-(int) get_protocolId
{
    return _pid;
}

-(bool) isReceived
{
    return _deliv;
}

-(int) get_alphabet
{
    return _alphab;
}

-(int) get_msgClass
{
    if (((_mclass) & (16)) == 0) {
        return -1;
    }
    return ((_mclass) & (3));
}

-(int) get_dcs
{
    return ((_mclass) | ((((_alphab) << (2)))));
}

-(NSString*) get_timestamp
{
    return _stamp;
}

-(NSMutableData*) get_userDataHeader
{
    return _udh;
}

-(NSMutableData*) get_userData
{
    return _udata;
}

-(NSString*) get_textData
{
    NSMutableData* isolatin;
    int isosize;
    int i;
    
    if (_alphab == 0) {
        return [_mbox gsm2str:_udata];
    }
    if (_alphab == 2) {
        isosize = (((int)[_udata length]) >> (1));
        isolatin = [NSMutableData dataWithLength:isosize];
        i = 0;
        while (i < isosize) {
            (((u8*)([isolatin mutableBytes]))[ i]) = (((u8*)([_udata bytes]))[2*i+1]);
            i = i + 1;
        }
        return ARC_sendAutorelease([[NSString alloc] initWithData:isolatin encoding:NSISOLatin1StringEncoding]);
    }
    
    // default: convert 8 bit to string as-is
    return ARC_sendAutorelease([[NSString alloc] initWithData:_udata encoding:NSISOLatin1StringEncoding]);
}

-(NSMutableArray*) get_unicodeData
{
    NSMutableArray* res = [NSMutableArray array];
    int unisize;
    int unival;
    int i;
    
    if (_alphab == 0) {
        return [_mbox gsm2unicode:_udata];
    }
    if (_alphab == 2) {
        unisize = (((int)[_udata length]) >> (1));
        [res removeAllObjects];
        i = 0;
        while (i < unisize) {
            unival = 256*(((u8*)([_udata bytes]))[2*i])+(((u8*)([_udata bytes]))[2*i+1]);
            [res addObject:[NSNumber numberWithLong:unival]];
            i = i + 1;
        }
    } else {
        unisize = (int)[_udata length];
        [res removeAllObjects];
        i = 0;
        while (i < unisize) {
            [res addObject:[NSNumber numberWithLong:(((u8*)([_udata bytes]))[i])+0]];
            i = i + 1;
        }
    }
    return res;
}

-(int) get_partCount
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _npdu;
}

-(NSMutableData*) get_pdu
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _pdu;
}

-(NSMutableArray*) get_parts
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _parts;
}

-(NSString*) get_concatSignature
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _aggSig;
}

-(int) get_concatIndex
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _aggIdx;
}

-(int) get_concatCount
{
    if (_npdu == 0) {
        [self generatePdu];
    }
    return _aggCnt;
}

-(int) set_slot:(int)val
{
    _slot = val;
    return YAPI_SUCCESS;
}

-(int) set_received:(bool)val
{
    _deliv = val;
    return YAPI_SUCCESS;
}

-(int) set_smsc:(NSString*)val
{
    _smsc = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_msgRef:(int)val
{
    _mref = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_sender:(NSString*)val
{
    _orig = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_recipient:(NSString*)val
{
    _dest = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_protocolId:(int)val
{
    _pid = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_alphabet:(int)val
{
    _alphab = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_msgClass:(int)val
{
    if (val == -1) {
        _mclass = 0;
    } else {
        _mclass = 16+val;
    }
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_dcs:(int)val
{
    _alphab = (((((val) >> (2)))) & (3));
    _mclass = ((val) & (16+3));
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_timestamp:(NSString*)val
{
    _stamp = val;
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) set_userDataHeader:(NSData*)val
{
    _udh = [NSMutableData dataWithData:val];
    _npdu = 0;
    [self parseUserDataHeader];
    return YAPI_SUCCESS;
}

-(int) set_userData:(NSData*)val
{
    _udata = [NSMutableData dataWithData:val];
    _npdu = 0;
    return YAPI_SUCCESS;
}

-(int) convertToUnicode
{
    NSMutableArray* ucs2 = [NSMutableArray array];
    int udatalen;
    int i;
    int uni;
    
    if (_alphab == 2) {
        return YAPI_SUCCESS;
    }
    if (_alphab == 0) {
        ucs2 = [_mbox gsm2unicode:_udata];
    } else {
        udatalen = (int)[_udata length];
        [ucs2 removeAllObjects];
        i = 0;
        while (i < udatalen) {
            uni = (((u8*)([_udata bytes]))[i]);
            [ucs2 addObject:[NSNumber numberWithLong:uni]];
            i = i + 1;
        }
    }
    _alphab = 2;
    _udata = [NSMutableData dataWithLength:0];
    [self addUnicodeData:ucs2];
    
    return YAPI_SUCCESS;
}

-(int) addText:(NSString*)val
{
    NSMutableData* udata;
    int udatalen;
    NSMutableData* newdata;
    int newdatalen;
    int i;
    
    if ((int)[(val) length] == 0) {
        return YAPI_SUCCESS;
    }
    
    if (_alphab == 0) {
        newdata = [_mbox str2gsm:val];
        newdatalen = (int)[newdata length];
        if (newdatalen == 0) {
            [self convertToUnicode];
            newdata = [NSMutableData dataWithData:[val dataUsingEncoding:NSISOLatin1StringEncoding]];
            newdatalen = (int)[newdata length];
        }
    } else {
        newdata = [NSMutableData dataWithData:[val dataUsingEncoding:NSISOLatin1StringEncoding]];
        newdatalen = (int)[newdata length];
    }
    udatalen = (int)[_udata length];
    if (_alphab == 2) {
        udata = [NSMutableData dataWithLength:udatalen + 2*newdatalen];
        i = 0;
        while (i < udatalen) {
            (((u8*)([udata mutableBytes]))[ i]) = (((u8*)([_udata bytes]))[i]);
            i = i + 1;
        }
        i = 0;
        while (i < newdatalen) {
            (((u8*)([udata mutableBytes]))[ udatalen+1]) = (((u8*)([newdata bytes]))[i]);
            udatalen = udatalen + 2;
            i = i + 1;
        }
    } else {
        udata = [NSMutableData dataWithLength:udatalen+newdatalen];
        i = 0;
        while (i < udatalen) {
            (((u8*)([udata mutableBytes]))[ i]) = (((u8*)([_udata bytes]))[i]);
            i = i + 1;
        }
        i = 0;
        while (i < newdatalen) {
            (((u8*)([udata mutableBytes]))[ udatalen]) = (((u8*)([newdata bytes]))[i]);
            udatalen = udatalen + 1;
            i = i + 1;
        }
    }
    
    return [self set_userData:udata];
}

-(int) addUnicodeData:(NSMutableArray*)val
{
    int arrlen;
    int newdatalen;
    int i;
    int uni;
    NSMutableData* udata;
    int udatalen;
    int surrogate;
    
    if (_alphab != 2) {
        [self convertToUnicode];
    }
    // compute number of 16-bit code units
    arrlen = (int)[val count];
    newdatalen = arrlen;
    i = 0;
    while (i < arrlen) {
        uni = [[val objectAtIndex:i] intValue];
        if (uni > 65535) {
            newdatalen = newdatalen + 1;
        }
        i = i + 1;
    }
    // now build utf-16 buffer
    udatalen = (int)[_udata length];
    udata = [NSMutableData dataWithLength:udatalen+2*newdatalen];
    i = 0;
    while (i < udatalen) {
        (((u8*)([udata mutableBytes]))[ i]) = (((u8*)([_udata bytes]))[i]);
        i = i + 1;
    }
    i = 0;
    while (i < arrlen) {
        uni = [[val objectAtIndex:i] intValue];
        if (uni >= 65536) {
            surrogate = uni - 65536;
            uni = (((((surrogate) >> (10))) & (1023))) + 55296;
            (((u8*)([udata mutableBytes]))[ udatalen]) = ((uni) >> (8));
            (((u8*)([udata mutableBytes]))[ udatalen+1]) = ((uni) & (255));
            udatalen = udatalen + 2;
            uni = (((surrogate) & (1023))) + 56320;
        }
        (((u8*)([udata mutableBytes]))[ udatalen]) = ((uni) >> (8));
        (((u8*)([udata mutableBytes]))[ udatalen+1]) = ((uni) & (255));
        udatalen = udatalen + 2;
        i = i + 1;
    }
    
    return [self set_userData:udata];
}

-(int) set_pdu:(NSData*)pdu
{
    _pdu = [NSMutableData dataWithData:pdu];
    _npdu = 1;
    return [self parsePdu:pdu];
}

-(int) set_parts:(NSMutableArray*)parts
{
    NSMutableArray* sorted = [NSMutableArray array];
    int partno;
    int initpartno;
    int i;
    int retcode;
    int totsize;
    YSms* subsms;
    NSMutableData* subdata;
    NSMutableData* res;
    _npdu = (int)[parts count];
    if (_npdu == 0) {
        return YAPI_INVALID_ARGUMENT;
    }
    
    [sorted removeAllObjects];
    partno = 0;
    while (partno < _npdu) {
        initpartno = partno;
        i = 0;
        while (i < _npdu) {
            subsms = [parts objectAtIndex:i];
            if ([subsms get_concatIndex] == partno) {
                [sorted addObject:subsms];
                partno = partno + 1;
            }
            i = i + 1;
        }
        if (initpartno == partno) {
            partno = partno + 1;
        }
    }
    _parts = sorted;
    _npdu = (int)[sorted count];
    // inherit header fields from first part
    subsms = [_parts objectAtIndex:0];
    retcode = [self parsePdu:[subsms get_pdu]];
    if (retcode != YAPI_SUCCESS) {
        return retcode;
    }
    // concatenate user data from all parts
    totsize = 0;
    partno = 0;
    while (partno < (int)[_parts count]) {
        subsms = [_parts objectAtIndex:partno];
        subdata = [subsms get_userData];
        totsize = totsize + (int)[subdata length];
        partno = partno + 1;
    }
    res = [NSMutableData dataWithLength:totsize];
    totsize = 0;
    partno = 0;
    while (partno < (int)[_parts count]) {
        subsms = [_parts objectAtIndex:partno];
        subdata = [subsms get_userData];
        i = 0;
        while (i < (int)[subdata length]) {
            (((u8*)([res mutableBytes]))[ totsize]) = (((u8*)([subdata bytes]))[i]);
            totsize = totsize + 1;
            i = i + 1;
        }
        partno = partno + 1;
    }
    _udata = res;
    return YAPI_SUCCESS;
}

-(NSMutableData*) encodeAddress:(NSString*)addr
{
    NSMutableData* bytes;
    int srclen;
    int numlen;
    int i;
    int val;
    int digit;
    NSMutableData* res;
    bytes = [NSMutableData dataWithData:[addr dataUsingEncoding:NSISOLatin1StringEncoding]];
    srclen = (int)[bytes length];
    numlen = 0;
    i = 0;
    while (i < srclen) {
        val = (((u8*)([bytes bytes]))[i]);
        if ((val >= 48) && (val < 58)) {
            numlen = numlen + 1;
        }
        i = i + 1;
    }
    if (numlen == 0) {
        res = [NSMutableData dataWithLength:1];
        (((u8*)([res mutableBytes]))[ 0]) = 0;
        return res;
    }
    res = [NSMutableData dataWithLength:2+((numlen+1) >> (1))];
    (((u8*)([res mutableBytes]))[ 0]) = numlen;
    if ((((u8*)([bytes bytes]))[0]) == 43) {
        (((u8*)([res mutableBytes]))[ 1]) = 145;
    } else {
        (((u8*)([res mutableBytes]))[ 1]) = 129;
    }
    numlen = 4;
    digit = 0;
    i = 0;
    while (i < srclen) {
        val = (((u8*)([bytes bytes]))[i]);
        if ((val >= 48) && (val < 58)) {
            if (((numlen) & (1)) == 0) {
                digit = val - 48;
            } else {
                (((u8*)([res mutableBytes]))[ ((numlen) >> (1))]) = digit + 16*(val-48);
            }
            numlen = numlen + 1;
        }
        i = i + 1;
    }
    // pad with F if needed
    if (((numlen) & (1)) != 0) {
        (((u8*)([res mutableBytes]))[ ((numlen) >> (1))]) = digit + 240;
    }
    return res;
}

-(NSString*) decodeAddress:(NSData*)addr :(int)ofs :(int)siz
{
    int addrType;
    NSMutableData* gsm7;
    NSString* res;
    int i;
    int rpos;
    int carry;
    int nbits;
    int byt;
    if (siz == 0) {
        return @"";
    }
    res = @"";
    addrType = (((((u8*)([addr bytes]))[ofs])) & (112));
    if (addrType == 80) {
        siz = ((4*siz) / (7));
        gsm7 = [NSMutableData dataWithLength:siz];
        rpos = 1;
        carry = 0;
        nbits = 0;
        i = 0;
        while (i < siz) {
            if (nbits == 7) {
                (((u8*)([gsm7 mutableBytes]))[ i]) = carry;
                carry = 0;
                nbits = 0;
            } else {
                byt = (((u8*)([addr bytes]))[ofs+rpos]);
                rpos = rpos + 1;
                (((u8*)([gsm7 mutableBytes]))[ i]) = ((carry) | ((((((byt) << (nbits)))) & (127))));
                carry = ((byt) >> ((7 - nbits)));
                nbits = nbits + 1;
            }
            i = i + 1;
        }
        return [_mbox gsm2str:gsm7];
    } else {
        if (addrType == 16) {
            res = @"+";
        }
        siz = (((siz+1)) >> (1));
        i = 0;
        while (i < siz) {
            byt = (((u8*)([addr bytes]))[ofs+i+1]);
            res = [NSString stringWithFormat:@"%@%x%x", res, ((byt) & (15)),((byt) >> (4))];
            i = i + 1;
        }
        if ((((((u8*)([addr bytes]))[ofs+siz])) >> (4)) == 15) {
            res = [res substringWithRange:NSMakeRange( 0, (int)[(res) length]-1)];
        }
        return res;
    }
}

-(NSMutableData*) encodeTimeStamp:(NSString*)exp
{
    int explen;
    int i;
    NSMutableData* res;
    int n;
    NSMutableData* expasc;
    int v1;
    int v2;
    explen = (int)[(exp) length];
    if (explen == 0) {
        res = [NSMutableData dataWithLength:0];
        return res;
    }
    if ([[exp substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"]) {
        n = [[exp substringWithRange:NSMakeRange(1, explen-1)] intValue];
        res = [NSMutableData dataWithLength:1];
        if (n > 30*86400) {
            n = 192+(((n+6*86400)) / ((7*86400)));
        } else {
            if (n > 86400) {
                n = 166+(((n+86399)) / (86400));
            } else {
                if (n > 43200) {
                    n = 143+(((n-43200+1799)) / (1800));
                } else {
                    n = -1+(((n+299)) / (300));
                }
            }
        }
        if (n < 0) {
            n = 0;
        }
        (((u8*)([res mutableBytes]))[0]) = n;
        return res;
    }
    if ([[exp substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"-"] || [[exp substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"/"]) {
        exp = [exp substringWithRange:NSMakeRange( 2, explen-2)];
        explen = (int)[(exp) length];
    }
    expasc = [NSMutableData dataWithData:[exp dataUsingEncoding:NSISOLatin1StringEncoding]];
    res = [NSMutableData dataWithLength:7];
    n = 0;
    i = 0;
    while ((i+1 < explen) && (n < 7)) {
        v1 = (((u8*)([expasc bytes]))[i]);
        if ((v1 >= 48) && (v1 < 58)) {
            v2 = (((u8*)([expasc bytes]))[i+1]);
            if ((v2 >= 48) && (v2 < 58)) {
                v1 = v1 - 48;
                v2 = v2 - 48;
                (((u8*)([res mutableBytes]))[ n]) = (((v2) << (4))) + v1;
                n = n + 1;
                i = i + 1;
            }
        }
        i = i + 1;
    }
    while (n < 7) {
        (((u8*)([res mutableBytes]))[ n]) = 0;
        n = n + 1;
    }
    if (i+2 < explen) {
        v1 = (((u8*)([expasc bytes]))[i-3]);
        v2 = (((u8*)([expasc bytes]))[i]);
        if (((v1 == 43) || (v1 == 45)) && (v2 == 58)) {
            v1 = (((u8*)([expasc bytes]))[i+1]);
            v2 = (((u8*)([expasc bytes]))[i+2]);
            if ((v1 >= 48) && (v1 < 58) && (v1 >= 48) && (v1 < 58)) {
                v1 = (((10*(v1 - 48)+(v2 - 48))) / (15));
                n = n - 1;
                v2 = 4 * (((u8*)([res bytes]))[n]) + v1;
                if ((((u8*)([expasc bytes]))[i-3]) == 45) {
                    v2 += 128;
                }
                (((u8*)([res mutableBytes]))[ n]) = v2;
            }
        }
    }
    return res;
}

-(NSString*) decodeTimeStamp:(NSData*)exp :(int)ofs :(int)siz
{
    int n;
    NSString* res;
    int i;
    int byt;
    NSString* sign;
    NSString* hh;
    NSString* ss;
    if (siz < 1) {
        return @"";
    }
    if (siz == 1) {
        n = (((u8*)([exp bytes]))[ofs]);
        if (n < 144) {
            n = n * 300;
        } else {
            if (n < 168) {
                n = (n-143) * 1800;
            } else {
                if (n < 197) {
                    n = (n-166) * 86400;
                } else {
                    n = (n-192) * 7 * 86400;
                }
            }
        }
        return [NSString stringWithFormat:@"+%d",n];
    }
    res = @"20";
    i = 0;
    while ((i < siz) && (i < 6)) {
        byt = (((u8*)([exp bytes]))[ofs+i]);
        res = [NSString stringWithFormat:@"%@%x%x", res, ((byt) & (15)),((byt) >> (4))];
        if (i < 3) {
            if (i < 2) {
                res = [NSString stringWithFormat:@"%@-",res];
            } else {
                res = [NSString stringWithFormat:@"%@ ",res];
            }
        } else {
            if (i < 5) {
                res = [NSString stringWithFormat:@"%@:",res];
            }
        }
        i = i + 1;
    }
    if (siz == 7) {
        byt = (((u8*)([exp bytes]))[ofs+i]);
        sign = @"+";
        if (((byt) & (8)) != 0) {
            byt = byt - 8;
            sign = @"-";
        }
        byt = (10*(((byt) & (15)))) + (((byt) >> (4)));
        hh = [NSString stringWithFormat:@"%d",((byt) >> (2))];
        ss = [NSString stringWithFormat:@"%d",15*(((byt) & (3)))];
        if ((int)[(hh) length]<2) {
            hh = [NSString stringWithFormat:@"0%@",hh];
        }
        if ((int)[(ss) length]<2) {
            ss = [NSString stringWithFormat:@"0%@",ss];
        }
        res = [NSString stringWithFormat:@"%@%@%@:%@", res, sign, hh,ss];
    }
    return res;
}

-(int) udataSize
{
    int res;
    int udhsize;
    udhsize = (int)[_udh length];
    res = (int)[_udata length];
    if (_alphab == 0) {
        if (udhsize > 0) {
            res = res + (((8 + 8*udhsize + 6)) / (7));
        }
        res = (((res * 7 + 7)) / (8));
    } else {
        if (udhsize > 0) {
            res = res + 1 + udhsize;
        }
    }
    return res;
}

-(NSMutableData*) encodeUserData
{
    int udsize;
    int udlen;
    int udhsize;
    int udhlen;
    NSMutableData* res;
    int i;
    int wpos;
    int carry;
    int nbits;
    int selfb;
    // nbits = number of bits in carry
    udsize = [self udataSize];
    udhsize = (int)[_udh length];
    udlen = (int)[_udata length];
    res = [NSMutableData dataWithLength:1+udsize];
    udhlen = 0;
    nbits = 0;
    carry = 0;
    // 1. Encode UDL
    if (_alphab == 0) {
        if (udhsize > 0) {
            udhlen = (((8 + 8*udhsize + 6)) / (7));
            nbits = 7*udhlen - 8 - 8*udhsize;
        }
        (((u8*)([res mutableBytes]))[ 0]) = udhlen+udlen;
    } else {
        (((u8*)([res mutableBytes]))[ 0]) = udsize;
    }
    // 2. Encode UDHL and UDL
    wpos = 1;
    if (udhsize > 0) {
        (((u8*)([res mutableBytes]))[ wpos]) = udhsize;
        wpos = wpos + 1;
        i = 0;
        while (i < udhsize) {
            (((u8*)([res mutableBytes]))[ wpos]) = (((u8*)([_udh bytes]))[i]);
            wpos = wpos + 1;
            i = i + 1;
        }
    }
    // 3. Encode UD
    if (_alphab == 0) {
        i = 0;
        while (i < udlen) {
            if (nbits == 0) {
                carry = (((u8*)([_udata bytes]))[i]);
                nbits = 7;
            } else {
                selfb = (((u8*)([_udata bytes]))[i]);
                (((u8*)([res mutableBytes]))[ wpos]) = ((carry) | ((((((selfb) << (nbits)))) & (255))));
                wpos = wpos + 1;
                nbits = nbits - 1;
                carry = ((selfb) >> ((7 - nbits)));
            }
            i = i + 1;
        }
        if (nbits > 0) {
            (((u8*)([res mutableBytes]))[ wpos]) = carry;
        }
    } else {
        i = 0;
        while (i < udlen) {
            (((u8*)([res mutableBytes]))[ wpos]) = (((u8*)([_udata bytes]))[i]);
            wpos = wpos + 1;
            i = i + 1;
        }
    }
    return res;
}

-(int) generateParts
{
    int udhsize;
    int udlen;
    int mss;
    int partno;
    int partlen;
    NSMutableData* newud;
    NSMutableData* newudh;
    YSms* newpdu;
    int i;
    int wpos;
    udhsize = (int)[_udh length];
    udlen = (int)[_udata length];
    mss = 140 - 1 - 5 - udhsize;
    if (_alphab == 0) {
        mss = (((mss * 8 - 6)) / (7));
    }
    _npdu = (((udlen+mss-1)) / (mss));
    [_parts removeAllObjects];
    partno = 0;
    wpos = 0;
    while (wpos < udlen) {
        partno = partno + 1;
        newudh = [NSMutableData dataWithLength:5+udhsize];
        (((u8*)([newudh mutableBytes]))[ 0]) = 0;
        (((u8*)([newudh mutableBytes]))[ 1]) = 3;
        (((u8*)([newudh mutableBytes]))[ 2]) = _mref;
        (((u8*)([newudh mutableBytes]))[ 3]) = _npdu;
        (((u8*)([newudh mutableBytes]))[ 4]) = partno;
        i = 0;
        while (i < udhsize) {
            (((u8*)([newudh mutableBytes]))[ 5+i]) = (((u8*)([_udh bytes]))[i]);
            i = i + 1;
        }
        if (wpos+mss < udlen) {
            partlen = mss;
        } else {
            partlen = udlen-wpos;
        }
        newud = [NSMutableData dataWithLength:partlen];
        i = 0;
        while (i < partlen) {
            (((u8*)([newud mutableBytes]))[ i]) = (((u8*)([_udata bytes]))[wpos]);
            wpos = wpos + 1;
            i = i + 1;
        }
        newpdu = ARC_sendAutorelease([[YSms alloc] initWith:_mbox]);
        [newpdu set_received:[self isReceived]];
        [newpdu set_smsc:[self get_smsc]];
        [newpdu set_msgRef:[self get_msgRef]];
        [newpdu set_sender:[self get_sender]];
        [newpdu set_recipient:[self get_recipient]];
        [newpdu set_protocolId:[self get_protocolId]];
        [newpdu set_dcs:[self get_dcs]];
        [newpdu set_timestamp:[self get_timestamp]];
        [newpdu set_userDataHeader:newudh];
        [newpdu set_userData:newud];
        [_parts addObject:newpdu];
    }
    return YAPI_SUCCESS;
}

-(int) generatePdu
{
    NSMutableData* sca;
    NSMutableData* hdr;
    NSMutableData* addr;
    NSMutableData* stamp;
    NSMutableData* udata;
    int pdutyp;
    int pdulen;
    int i;
    // Determine if the message can fit within a single PDU
    [_parts removeAllObjects];
    if ([self udataSize] > 140) {
        _pdu = [NSMutableData dataWithLength:0];
        return [self generateParts];
    }
    sca = [self encodeAddress:_smsc];
    if ((int)[sca length] > 0) {
        (((u8*)([sca mutableBytes]))[ 0]) = (int)[sca length]-1;
    }
    stamp = [self encodeTimeStamp:_stamp];
    udata = [self encodeUserData];
    if (_deliv) {
        addr = [self encodeAddress:_orig];
        hdr = [NSMutableData dataWithLength:1];
        pdutyp = 0;
    } else {
        addr = [self encodeAddress:_dest];
        _mref = [_mbox nextMsgRef];
        hdr = [NSMutableData dataWithLength:2];
        (((u8*)([hdr mutableBytes]))[1]) = _mref;
        pdutyp = 1;
        if ((int)[stamp length] > 0) {
            pdutyp = pdutyp + 16;
        }
        if ((int)[stamp length] == 7) {
            pdutyp = pdutyp + 8;
        }
    }
    if ((int)[_udh length] > 0) {
        pdutyp = pdutyp + 64;
    }
    (((u8*)([hdr mutableBytes]))[0]) = pdutyp;
    pdulen = (int)[sca length]+(int)[hdr length]+(int)[addr length]+2+(int)[stamp length]+(int)[udata length];
    _pdu = [NSMutableData dataWithLength:pdulen];
    pdulen = 0;
    i = 0;
    while (i < (int)[sca length]) {
        (((u8*)([_pdu mutableBytes]))[ pdulen]) = (((u8*)([sca bytes]))[i]);
        pdulen = pdulen + 1;
        i = i + 1;
    }
    i = 0;
    while (i < (int)[hdr length]) {
        (((u8*)([_pdu mutableBytes]))[ pdulen]) = (((u8*)([hdr bytes]))[i]);
        pdulen = pdulen + 1;
        i = i + 1;
    }
    i = 0;
    while (i < (int)[addr length]) {
        (((u8*)([_pdu mutableBytes]))[ pdulen]) = (((u8*)([addr bytes]))[i]);
        pdulen = pdulen + 1;
        i = i + 1;
    }
    (((u8*)([_pdu mutableBytes]))[ pdulen]) = _pid;
    pdulen = pdulen + 1;
    (((u8*)([_pdu mutableBytes]))[ pdulen]) = [self get_dcs];
    pdulen = pdulen + 1;
    i = 0;
    while (i < (int)[stamp length]) {
        (((u8*)([_pdu mutableBytes]))[ pdulen]) = (((u8*)([stamp bytes]))[i]);
        pdulen = pdulen + 1;
        i = i + 1;
    }
    i = 0;
    while (i < (int)[udata length]) {
        (((u8*)([_pdu mutableBytes]))[ pdulen]) = (((u8*)([udata bytes]))[i]);
        pdulen = pdulen + 1;
        i = i + 1;
    }
    _npdu = 1;
    return YAPI_SUCCESS;
}

-(int) parseUserDataHeader
{
    int udhlen;
    int i;
    int iei;
    int ielen;
    NSString* sig;
    
    _aggSig = @"";
    _aggIdx = 0;
    _aggCnt = 0;
    udhlen = (int)[_udh length];
    i = 0;
    while (i+1 < udhlen) {
        iei = (((u8*)([_udh bytes]))[i]);
        ielen = (((u8*)([_udh bytes]))[i+1]);
        i = i + 2;
        if (i + ielen <= udhlen) {
            if ((iei == 0) && (ielen == 3)) {
                sig = [NSString stringWithFormat:@"%@-%@-%02x-%02x", _orig, _dest,
                _mref,(((u8*)([_udh bytes]))[i])];
                _aggSig = sig;
                _aggCnt = (((u8*)([_udh bytes]))[i+1]);
                _aggIdx = (((u8*)([_udh bytes]))[i+2]);
            }
            if ((iei == 8) && (ielen == 4)) {
                sig = [NSString stringWithFormat:@"%@-%@-%02x-%02x%02x", _orig, _dest,
                _mref, (((u8*)([_udh bytes]))[i]),(((u8*)([_udh bytes]))[i+1])];
                _aggSig = sig;
                _aggCnt = (((u8*)([_udh bytes]))[i+2]);
                _aggIdx = (((u8*)([_udh bytes]))[i+3]);
            }
        }
        i = i + ielen;
    }
    return YAPI_SUCCESS;
}

-(int) parsePdu:(NSData*)pdu
{
    int rpos;
    int addrlen;
    int pdutyp;
    int tslen;
    int dcs;
    int udlen;
    int udhsize;
    int udhlen;
    int i;
    int carry;
    int nbits;
    int selfb;
    
    _pdu = [NSMutableData dataWithData:pdu];
    _npdu = 1;
    
    // parse meta-data
    _smsc = [self decodeAddress:pdu : 1 :2*((((u8*)([pdu bytes]))[0])-1)];
    rpos = 1+(((u8*)([pdu bytes]))[0]);
    pdutyp = (((u8*)([pdu bytes]))[rpos]);
    rpos = rpos + 1;
    _deliv = (((pdutyp) & (3)) == 0);
    if (_deliv) {
        addrlen = (((u8*)([pdu bytes]))[rpos]);
        rpos = rpos + 1;
        _orig = [self decodeAddress:pdu : rpos :addrlen];
        _dest = @"";
        tslen = 7;
    } else {
        _mref = (((u8*)([pdu bytes]))[rpos]);
        rpos = rpos + 1;
        addrlen = (((u8*)([pdu bytes]))[rpos]);
        rpos = rpos + 1;
        _dest = [self decodeAddress:pdu : rpos :addrlen];
        _orig = @"";
        if ((((pdutyp) & (16))) != 0) {
            if ((((pdutyp) & (8))) != 0) {
                tslen = 7;
            } else {
                tslen= 1;
            }
        } else {
            tslen = 0;
        }
    }
    rpos = rpos + ((((addrlen+3)) >> (1)));
    _pid = (((u8*)([pdu bytes]))[rpos]);
    rpos = rpos + 1;
    dcs = (((u8*)([pdu bytes]))[rpos]);
    rpos = rpos + 1;
    _alphab = (((((dcs) >> (2)))) & (3));
    _mclass = ((dcs) & (16+3));
    _stamp = [self decodeTimeStamp:pdu : rpos :tslen];
    rpos = rpos + tslen;
    
    // parse user data (including udh)
    nbits = 0;
    carry = 0;
    udlen = (((u8*)([pdu bytes]))[rpos]);
    rpos = rpos + 1;
    if (((pdutyp) & (64)) != 0) {
        udhsize = (((u8*)([pdu bytes]))[rpos]);
        rpos = rpos + 1;
        _udh = [NSMutableData dataWithLength:udhsize];
        i = 0;
        while (i < udhsize) {
            (((u8*)([_udh mutableBytes]))[ i]) = (((u8*)([pdu bytes]))[rpos]);
            rpos = rpos + 1;
            i = i + 1;
        }
        if (_alphab == 0) {
            udhlen = (((8 + 8*udhsize + 6)) / (7));
            nbits = 7*udhlen - 8 - 8*udhsize;
            if (nbits > 0) {
                selfb = (((u8*)([pdu bytes]))[rpos]);
                rpos = rpos + 1;
                carry = ((selfb) >> (nbits));
                nbits = 8 - nbits;
            }
        } else {
            udhlen = 1+udhsize;
        }
        udlen = udlen - udhlen;
    } else {
        udhsize = 0;
        _udh = [NSMutableData dataWithLength:0];
    }
    _udata = [NSMutableData dataWithLength:udlen];
    if (_alphab == 0) {
        i = 0;
        while (i < udlen) {
            if (nbits == 7) {
                (((u8*)([_udata mutableBytes]))[ i]) = carry;
                carry = 0;
                nbits = 0;
            } else {
                selfb = (((u8*)([pdu bytes]))[rpos]);
                rpos = rpos + 1;
                (((u8*)([_udata mutableBytes]))[ i]) = ((carry) | ((((((selfb) << (nbits)))) & (127))));
                carry = ((selfb) >> ((7 - nbits)));
                nbits = nbits + 1;
            }
            i = i + 1;
        }
    } else {
        i = 0;
        while (i < udlen) {
            (((u8*)([_udata mutableBytes]))[ i]) = (((u8*)([pdu bytes]))[rpos]);
            rpos = rpos + 1;
            i = i + 1;
        }
    }
    [self parseUserDataHeader];
    
    return YAPI_SUCCESS;
}

-(int) send
{
    int i;
    int retcode;
    YSms* pdu;
    // may throw an exception
    if (_npdu == 0) {
        [self generatePdu];
    }
    if (_npdu == 1) {
        return [_mbox _upload:@"sendSMS" :_pdu];
    }
    retcode = YAPI_SUCCESS;
    i = 0;
    while ((i < _npdu) && (retcode == YAPI_SUCCESS)) {
        pdu = [_parts objectAtIndex:i];
        retcode= [pdu send];
        i = i + 1;
    }
    return retcode;
}

-(int) deleteFromSIM
{
    int i;
    int retcode;
    YSms* pdu;
    // may throw an exception
    if (_slot > 0) {
        return [_mbox clearSIMSlot:_slot];
    }
    retcode = YAPI_SUCCESS;
    i = 0;
    while ((i < _npdu) && (retcode == YAPI_SUCCESS)) {
        pdu = [_parts objectAtIndex:i];
        retcode= [pdu deleteFromSIM];
        i = i + 1;
    }
    return retcode;
}

//--- (end of generated code: YSms public methods implementation)

@end
//--- (generated code: Sms functions)
//--- (end of generated code: Sms functions)



@implementation YMessageBox

// Constructor is protected, use yFindMessageBox factory function to instantiate
-(id)              initWith:(NSString*) func
{
   if(!(self = [super initWith:func]))
          return nil;
    _className = @"MessageBox";
//--- (generated code: YMessageBox attributes initialization)
    _slotsInUse = Y_SLOTSINUSE_INVALID;
    _slotsCount = Y_SLOTSCOUNT_INVALID;
    _slotsBitmap = Y_SLOTSBITMAP_INVALID;
    _pduSent = Y_PDUSENT_INVALID;
    _pduReceived = Y_PDURECEIVED_INVALID;
    _command = Y_COMMAND_INVALID;
    _valueCallbackMessageBox = NULL;
    _nextMsgRef = 0;
    _pdus = [NSMutableArray array];
    _messages = [NSMutableArray array];
    _gsm2unicode = [NSMutableArray array];
//--- (end of generated code: YMessageBox attributes initialization)
    return self;
}
// destructor
-(void)  dealloc
{
//--- (generated code: YMessageBox cleanup)
    ARC_release(_slotsBitmap);
    _slotsBitmap = nil;
    ARC_release(_command);
    _command = nil;
    ARC_dealloc(super);
//--- (end of generated code: YMessageBox cleanup)
}
//--- (generated code: YMessageBox private methods implementation)

-(int) _parseAttr:(yJsonStateMachine*) j
{
    if(!strcmp(j->token, "slotsInUse")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _slotsInUse =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "slotsCount")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _slotsCount =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "slotsBitmap")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
       ARC_release(_slotsBitmap);
        _slotsBitmap =  [self _parseString:j];
        ARC_retain(_slotsBitmap);
        return 1;
    }
    if(!strcmp(j->token, "pduSent")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pduSent =  atoi(j->token);
        return 1;
    }
    if(!strcmp(j->token, "pduReceived")) {
        if(yJsonParse(j) != YJSON_PARSE_AVAIL) return -1;
        _pduReceived =  atoi(j->token);
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
//--- (end of generated code: YMessageBox private methods implementation)
//--- (generated code: YMessageBox public methods implementation)
/**
 * Returns the number of message storage slots currently in use.
 *
 * @return an integer corresponding to the number of message storage slots currently in use
 *
 * On failure, throws an exception or returns Y_SLOTSINUSE_INVALID.
 */
-(int) get_slotsInUse
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SLOTSINUSE_INVALID;
        }
    }
    return _slotsInUse;
}


-(int) slotsInUse
{
    return [self get_slotsInUse];
}
/**
 * Returns the total number of message storage slots on the SIM card.
 *
 * @return an integer corresponding to the total number of message storage slots on the SIM card
 *
 * On failure, throws an exception or returns Y_SLOTSCOUNT_INVALID.
 */
-(int) get_slotsCount
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SLOTSCOUNT_INVALID;
        }
    }
    return _slotsCount;
}


-(int) slotsCount
{
    return [self get_slotsCount];
}
-(NSString*) get_slotsBitmap
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_SLOTSBITMAP_INVALID;
        }
    }
    return _slotsBitmap;
}


-(NSString*) slotsBitmap
{
    return [self get_slotsBitmap];
}
/**
 * Returns the number of SMS units sent so far.
 *
 * @return an integer corresponding to the number of SMS units sent so far
 *
 * On failure, throws an exception or returns Y_PDUSENT_INVALID.
 */
-(int) get_pduSent
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PDUSENT_INVALID;
        }
    }
    return _pduSent;
}


-(int) pduSent
{
    return [self get_pduSent];
}

/**
 * Changes the value of the outgoing SMS units counter.
 *
 * @param newval : an integer corresponding to the value of the outgoing SMS units counter
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pduSent:(int) newval
{
    return [self setPduSent:newval];
}
-(int) setPduSent:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"pduSent" :rest_val];
}
/**
 * Returns the number of SMS units received so far.
 *
 * @return an integer corresponding to the number of SMS units received so far
 *
 * On failure, throws an exception or returns Y_PDURECEIVED_INVALID.
 */
-(int) get_pduReceived
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_PDURECEIVED_INVALID;
        }
    }
    return _pduReceived;
}


-(int) pduReceived
{
    return [self get_pduReceived];
}

/**
 * Changes the value of the incoming SMS units counter.
 *
 * @param newval : an integer corresponding to the value of the incoming SMS units counter
 *
 * @return YAPI_SUCCESS if the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) set_pduReceived:(int) newval
{
    return [self setPduReceived:newval];
}
-(int) setPduReceived:(int) newval
{
    NSString* rest_val;
    rest_val = [NSString stringWithFormat:@"%d", newval];
    return [self _setAttr:@"pduReceived" :rest_val];
}
-(NSString*) get_command
{
    if (_cacheExpiration <= [YAPI GetTickCount]) {
        if ([self load:[YAPI DefaultCacheValidity]] != YAPI_SUCCESS) {
            return Y_COMMAND_INVALID;
        }
    }
    return _command;
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
 * Retrieves a MessageBox interface for a given identifier.
 * The identifier can be specified using several formats:
 * <ul>
 * <li>FunctionLogicalName</li>
 * <li>ModuleSerialNumber.FunctionIdentifier</li>
 * <li>ModuleSerialNumber.FunctionLogicalName</li>
 * <li>ModuleLogicalName.FunctionIdentifier</li>
 * <li>ModuleLogicalName.FunctionLogicalName</li>
 * </ul>
 *
 * This function does not require that the MessageBox interface is online at the time
 * it is invoked. The returned object is nevertheless valid.
 * Use the method YMessageBox.isOnline() to test if the MessageBox interface is
 * indeed online at a given time. In case of ambiguity when looking for
 * a MessageBox interface by logical name, no error is notified: the first instance
 * found is returned. The search is performed first by hardware name,
 * then by logical name.
 *
 * @param func : a string that uniquely characterizes the MessageBox interface
 *
 * @return a YMessageBox object allowing you to drive the MessageBox interface.
 */
+(YMessageBox*) FindMessageBox:(NSString*)func
{
    YMessageBox* obj;
    obj = (YMessageBox*) [YFunction _FindFromCache:@"MessageBox" :func];
    if (obj == nil) {
        obj = ARC_sendAutorelease([[YMessageBox alloc] initWith:func]);
        [YFunction _AddToCache:@"MessageBox" : func :obj];
    }
    return obj;
}

/**
 * Registers the callback function that is invoked on every change of advertised value.
 * The callback is invoked only during the execution of ySleep or yHandleEvents.
 * This provides control over the time when the callback is triggered. For good responsiveness, remember to call
 * one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
 *
 * @param callback : the callback function to call, or a null pointer. The callback function should take two
 *         arguments: the function object of which the value has changed, and the character string describing
 *         the new advertised value.
 * @noreturn
 */
-(int) registerValueCallback:(YMessageBoxValueCallback)callback
{
    NSString* val;
    if (callback != NULL) {
        [YFunction _UpdateValueCallbackList:self :YES];
    } else {
        [YFunction _UpdateValueCallbackList:self :NO];
    }
    _valueCallbackMessageBox = callback;
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
    if (_valueCallbackMessageBox != NULL) {
        _valueCallbackMessageBox(self, value);
    } else {
        [super _invokeValueCallback:value];
    }
    return 0;
}

-(int) nextMsgRef
{
    _nextMsgRef = _nextMsgRef + 1;
    return _nextMsgRef;
}

-(int) clearSIMSlot:(int)slot
{
    _prevBitmapStr = @"";
    return [self set_command:[NSString stringWithFormat:@"DS%d",slot]];
}

-(YSms*) fetchPdu:(int)slot
{
    NSMutableData* binPdu;
    NSMutableArray* arrPdu = [NSMutableArray array];
    NSString* hexPdu;
    YSms* sms;
    
    // may throw an exception
    binPdu = [self _download:[NSString stringWithFormat:@"sms.json?pos=%d&len=1",slot]];
    arrPdu = [self _json_get_array:binPdu];
    hexPdu = [self _decode_json_string:[arrPdu objectAtIndex:0]];
    sms = ARC_sendAutorelease([[YSms alloc] initWith:self]);
    [sms set_slot:slot];
    [sms parsePdu:[YAPI _hexStr2Bin:hexPdu]];
    return sms;
}

-(int) initGsm2Unicode
{
    int i;
    int uni;
    
    [_gsm2unicode removeAllObjects];
    // 00-07
    [_gsm2unicode addObject:[NSNumber numberWithLong:64]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:163]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:36]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:165]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:232]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:233]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:249]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:236]];
    // 08-0F
    [_gsm2unicode addObject:[NSNumber numberWithLong:242]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:199]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:10]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:216]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:248]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:13]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:197]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:229]];
    // 10-17
    [_gsm2unicode addObject:[NSNumber numberWithLong:916]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:95]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:934]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:915]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:923]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:937]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:928]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:936]];
    // 18-1F
    [_gsm2unicode addObject:[NSNumber numberWithLong:931]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:920]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:926]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:27]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:198]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:230]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:223]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:201]];
    // 20-7A
    i = 32;
    while (i <= 122) {
        [_gsm2unicode addObject:[NSNumber numberWithLong:i]];
        i = i + 1;
    }
    // exceptions in range 20-7A
    [_gsm2unicode replaceObjectAtIndex: 36 withObject:[NSNumber numberWithLong:164]];
    [_gsm2unicode replaceObjectAtIndex: 64 withObject:[NSNumber numberWithLong:161]];
    [_gsm2unicode replaceObjectAtIndex: 91 withObject:[NSNumber numberWithLong:196]];
    [_gsm2unicode replaceObjectAtIndex: 92 withObject:[NSNumber numberWithLong:214]];
    [_gsm2unicode replaceObjectAtIndex: 93 withObject:[NSNumber numberWithLong:209]];
    [_gsm2unicode replaceObjectAtIndex: 94 withObject:[NSNumber numberWithLong:220]];
    [_gsm2unicode replaceObjectAtIndex: 95 withObject:[NSNumber numberWithLong:167]];
    [_gsm2unicode replaceObjectAtIndex: 96 withObject:[NSNumber numberWithLong:191]];
    // 7B-7F
    [_gsm2unicode addObject:[NSNumber numberWithLong:228]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:246]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:241]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:252]];
    [_gsm2unicode addObject:[NSNumber numberWithLong:224]];
    // Invert table as well wherever possible
    _iso2gsm = [NSMutableData dataWithLength:256];
    i = 0;
    while (i <= 127) {
        uni = [[_gsm2unicode objectAtIndex:i] intValue];
        if (uni <= 255) {
            (((u8*)([_iso2gsm mutableBytes]))[ uni]) = i;
        }
        i = i + 1;
    }
    i = 0;
    while (i < 4) {
        (((u8*)([_iso2gsm mutableBytes]))[ 91+i]) = 27;
        (((u8*)([_iso2gsm mutableBytes]))[ 123+i]) = 27;
        i = i + 1;
    }
    // Done
    _gsm2unicodeReady = YES;
    
    return YAPI_SUCCESS;
}

-(NSMutableArray*) gsm2unicode:(NSData*)gsm
{
    int i;
    int gsmlen;
    int reslen;
    NSMutableArray* res = [NSMutableArray array];
    int uni;
    
    if (!(_gsm2unicodeReady)) {
        [self initGsm2Unicode];
    }
    gsmlen = (int)[gsm length];
    reslen = gsmlen;
    i = 0;
    while (i < gsmlen) {
        if ((((u8*)([gsm bytes]))[i]) == 27) {
            reslen = reslen - 1;
        }
        i = i + 1;
    }
    [res removeAllObjects];
    i = 0;
    while (i < gsmlen) {
        uni = [[_gsm2unicode objectAtIndex:(((u8*)([gsm bytes]))[i])] intValue];
        if ((uni == 27) && (i+1 < gsmlen)) {
            i = i + 1;
            uni = (((u8*)([gsm bytes]))[i]);
            if (uni < 60) {
                if (uni < 41) {
                    if (uni==20) {
                        uni=94;
                    } else {
                        if (uni==40) {
                            uni=123;
                        } else {
                            uni=0;
                        }
                    }
                } else {
                    if (uni==41) {
                        uni=125;
                    } else {
                        if (uni==47) {
                            uni=92;
                        } else {
                            uni=0;
                        }
                    }
                }
            } else {
                if (uni < 62) {
                    if (uni==60) {
                        uni=91;
                    } else {
                        if (uni==61) {
                            uni=126;
                        } else {
                            uni=0;
                        }
                    }
                } else {
                    if (uni==62) {
                        uni=93;
                    } else {
                        if (uni==64) {
                            uni=124;
                        } else {
                            if (uni==101) {
                                uni=164;
                            } else {
                                uni=0;
                            }
                        }
                    }
                }
            }
        }
        if (uni > 0) {
            [res addObject:[NSNumber numberWithLong:uni]];
        }
        i = i + 1;
    }
    return res;
}

-(NSString*) gsm2str:(NSData*)gsm
{
    int i;
    int gsmlen;
    int reslen;
    NSMutableData* resbin;
    NSString* resstr;
    int uni;
    
    if (!(_gsm2unicodeReady)) {
        [self initGsm2Unicode];
    }
    gsmlen = (int)[gsm length];
    reslen = gsmlen;
    i = 0;
    while (i < gsmlen) {
        if ((((u8*)([gsm bytes]))[i]) == 27) {
            reslen = reslen - 1;
        }
        i = i + 1;
    }
    resbin = [NSMutableData dataWithLength:reslen];
    i = 0;
    reslen = 0;
    while (i < gsmlen) {
        uni = [[_gsm2unicode objectAtIndex:(((u8*)([gsm bytes]))[i])] intValue];
        if ((uni == 27) && (i+1 < gsmlen)) {
            i = i + 1;
            uni = (((u8*)([gsm bytes]))[i]);
            if (uni < 60) {
                if (uni < 41) {
                    if (uni==20) {
                        uni=94;
                    } else {
                        if (uni==40) {
                            uni=123;
                        } else {
                            uni=0;
                        }
                    }
                } else {
                    if (uni==41) {
                        uni=125;
                    } else {
                        if (uni==47) {
                            uni=92;
                        } else {
                            uni=0;
                        }
                    }
                }
            } else {
                if (uni < 62) {
                    if (uni==60) {
                        uni=91;
                    } else {
                        if (uni==61) {
                            uni=126;
                        } else {
                            uni=0;
                        }
                    }
                } else {
                    if (uni==62) {
                        uni=93;
                    } else {
                        if (uni==64) {
                            uni=124;
                        } else {
                            if (uni==101) {
                                uni=164;
                            } else {
                                uni=0;
                            }
                        }
                    }
                }
            }
        }
        if ((uni > 0) && (uni < 256)) {
            (((u8*)([resbin mutableBytes]))[ reslen]) = uni;
            reslen = reslen + 1;
        }
        i = i + 1;
    }
    resstr = ARC_sendAutorelease([[NSString alloc] initWithData:resbin encoding:NSISOLatin1StringEncoding]);
    if ((int)[(resstr) length] > reslen) {
        resstr = [resstr substringWithRange:NSMakeRange(0, reslen)];
    }
    return resstr;
}

-(NSMutableData*) str2gsm:(NSString*)msg
{
    NSMutableData* asc;
    int asclen;
    int i;
    int ch;
    int gsm7;
    int extra;
    NSMutableData* res;
    int wpos;
    
    if (!(_gsm2unicodeReady)) {
        [self initGsm2Unicode];
    }
    asc = [NSMutableData dataWithData:[msg dataUsingEncoding:NSISOLatin1StringEncoding]];
    asclen = (int)[asc length];
    extra = 0;
    i = 0;
    while (i < asclen) {
        ch = (((u8*)([asc bytes]))[i]);
        gsm7 = (((u8*)([_iso2gsm bytes]))[ch]);
        if (gsm7 == 27) {
            extra = extra + 1;
        }
        if (gsm7 == 0) {
            res = [NSMutableData dataWithLength:0];
            return res;
        }
        i = i + 1;
    }
    res = [NSMutableData dataWithLength:asclen+extra];
    wpos = 0;
    i = 0;
    while (i < asclen) {
        ch = (((u8*)([asc bytes]))[i]);
        gsm7 = (((u8*)([_iso2gsm bytes]))[ch]);
        (((u8*)([res mutableBytes]))[ wpos]) = gsm7;
        wpos = wpos + 1;
        if (gsm7 == 27) {
            if (ch < 100) {
                if (ch<93) {
                    if (ch<92) {
                        gsm7=60;
                    } else {
                        gsm7=47;
                    }
                } else {
                    if (ch<94) {
                        gsm7=62;
                    } else {
                        gsm7=20;
                    }
                }
            } else {
                if (ch<125) {
                    if (ch<124) {
                        gsm7=40;
                    } else {
                        gsm7=64;
                    }
                } else {
                    if (ch<126) {
                        gsm7=41;
                    } else {
                        gsm7=61;
                    }
                }
            }
            (((u8*)([res mutableBytes]))[ wpos]) = gsm7;
            wpos = wpos + 1;
        }
        i = i + 1;
    }
    return res;
}

-(int) checkNewMessages
{
    NSString* bitmapStr;
    NSMutableData* prevBitmap;
    NSMutableData* newBitmap;
    int slot;
    int nslots;
    int pduIdx;
    int idx;
    int bitVal;
    int prevBit;
    int i;
    int nsig;
    int cnt;
    NSString* sig;
    NSMutableArray* newArr = [NSMutableArray array];
    NSMutableArray* newMsg = [NSMutableArray array];
    NSMutableArray* newAgg = [NSMutableArray array];
    NSMutableArray* signatures = [NSMutableArray array];
    YSms* sms;
    
    // may throw an exception
    bitmapStr = [self get_slotsBitmap];
    if ([bitmapStr isEqualToString:_prevBitmapStr]) {
        return YAPI_SUCCESS;
    }
    prevBitmap = [YAPI _hexStr2Bin:_prevBitmapStr];
    newBitmap = [YAPI _hexStr2Bin:bitmapStr];
    _prevBitmapStr = bitmapStr;
    nslots = 8*(int)[newBitmap length];
    [newArr removeAllObjects];
    [newMsg removeAllObjects];
    [signatures removeAllObjects];
    nsig = 0;
    // copy known messages
    pduIdx = 0;
    while (pduIdx < (int)[_pdus count]) {
        sms = [_pdus objectAtIndex:pduIdx];
        slot = [sms get_slot];
        idx = ((slot) >> (3));
        if (idx < (int)[newBitmap length]) {
            bitVal = ((1) << ((((slot) & (7)))));
            if (((((((u8*)([newBitmap bytes]))[idx])) & (bitVal))) != 0) {
                [newArr addObject:sms];
                if ([sms get_concatCount] == 0) {
                    [newMsg addObject:sms];
                } else {
                    sig = [sms get_concatSignature];
                    i = 0;
                    while ((i < nsig) && ((int)[(sig) length] > 0)) {
                        if ([[signatures objectAtIndex:i] isEqualToString:sig]) {
                            sig = @"";
                        }
                        i = i + 1;
                    }
                    if ((int)[(sig) length] > 0) {
                        [signatures addObject:sig];
                        nsig = nsig + 1;
                    }
                }
            }
        }
        pduIdx = pduIdx + 1;
    }
    // receive new messages
    slot = 0;
    while (slot < nslots) {
        idx = ((slot) >> (3));
        bitVal = ((1) << ((((slot) & (7)))));
        prevBit = 0;
        if (idx < (int)[prevBitmap length]) {
            prevBit = (((((u8*)([prevBitmap bytes]))[idx])) & (bitVal));
        }
        if (((((((u8*)([newBitmap bytes]))[idx])) & (bitVal))) != 0) {
            if (prevBit == 0) {
                sms = [self fetchPdu:slot];
                [newArr addObject:sms];
                if ([sms get_concatCount] == 0) {
                    [newMsg addObject:sms];
                } else {
                    sig = [sms get_concatSignature];
                    i = 0;
                    while ((i < nsig) && ((int)[(sig) length] > 0)) {
                        if ([[signatures objectAtIndex:i] isEqualToString:sig]) {
                            sig = @"";
                        }
                        i = i + 1;
                    }
                    if ((int)[(sig) length] > 0) {
                        [signatures addObject:sig];
                        nsig = nsig + 1;
                    }
                }
            }
        }
        slot = slot + 1;
    }
    _pdus = newArr;
    // append complete concatenated messages
    i = 0;
    while (i < nsig) {
        sig = [signatures objectAtIndex:i];
        cnt = 0;
        pduIdx = 0;
        while (pduIdx < (int)[_pdus count]) {
            sms = [_pdus objectAtIndex:pduIdx];
            if ([sms get_concatCount] > 0) {
                if ([[sms get_concatSignature] isEqualToString:sig]) {
                    if (cnt == 0) {
                        cnt = [sms get_concatCount];
                        [newAgg removeAllObjects];
                    }
                    [newAgg addObject:sms];
                }
            }
            pduIdx = pduIdx + 1;
        }
        if ((cnt > 0) && ((int)[newAgg count] == cnt)) {
            sms = ARC_sendAutorelease([[YSms alloc] initWith:self]);
            [sms set_parts:newAgg];
            [newMsg addObject:sms];
        }
        i = i + 1;
    }
    _messages = newMsg;
    
    return YAPI_SUCCESS;
}

-(NSMutableArray*) get_pdus
{
    [self checkNewMessages];
    return _pdus;
}

/**
 * Clear the SMS units counters.
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) clearPduCounters
{
    int retcode;
    // may throw an exception
    retcode = [self set_pduReceived:0];
    if (retcode != YAPI_SUCCESS) {
        return retcode;
    }
    retcode = [self set_pduSent:0];
    return retcode;
}

/**
 * Sends a regular text SMS, with standard parameters. This function can send messages
 * of more than 160 characters, using SMS concatenation. ISO-latin accented characters
 * are supported. For sending messages with special unicode characters such as asian
 * characters and emoticons, use newMessage to create a new message and define
 * the content of using methods addText and addUnicodeData.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 * @param message : the text to be sent in the message
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sendTextMessage:(NSString*)recipient :(NSString*)message
{
    YSms* sms;
    // may throw an exception
    sms = ARC_sendAutorelease([[YSms alloc] initWith:self]);
    [sms set_recipient:recipient];
    [sms addText:message];
    return [sms send];
}

/**
 * Sends a Flash SMS (class 0 message). Flash messages are displayed on the handset
 * immediately and are usually not saved on the SIM card. This function can send messages
 * of more than 160 characters, using SMS concatenation. ISO-latin accented characters
 * are supported. For sending messages with special unicode characters such as asian
 * characters and emoticons, use newMessage to create a new message and define
 * the content of using methods addText et addUnicodeData.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 * @param message : the text to be sent in the message
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(int) sendFlashMessage:(NSString*)recipient :(NSString*)message
{
    YSms* sms;
    // may throw an exception
    sms = ARC_sendAutorelease([[YSms alloc] initWith:self]);
    [sms set_recipient:recipient];
    [sms set_msgClass:0];
    [sms addText:message];
    return [sms send];
}

/**
 * Creates a new empty SMS message, to be configured and sent later on.
 *
 * @param recipient : a text string with the recipient phone number, either as a
 *         national number, or in international format starting with a plus sign
 *
 * @return YAPI_SUCCESS when the call succeeds.
 *
 * On failure, throws an exception or returns a negative error code.
 */
-(YSms*) newMessage:(NSString*)recipient
{
    YSms* sms;
    sms = ARC_sendAutorelease([[YSms alloc] initWith:self]);
    [sms set_recipient:recipient];
    return sms;
}

/**
 * Returns the list of messages received and not deleted. This function
 * will automatically decode concatenated SMS.
 *
 * @return an YSms object list.
 *
 * On failure, throws an exception or returns an empty list.
 */
-(NSMutableArray*) get_messages
{
    [self checkNewMessages];
    
    return _messages;
}


-(YMessageBox*)   nextMessageBox
{
    NSString  *hwid;

    if(YISERR([self _nextFunction:&hwid]) || [hwid isEqualToString:@""]) {
        return NULL;
    }
    return [YMessageBox FindMessageBox:hwid];
}

+(YMessageBox *) FirstMessageBox
{
    NSMutableArray    *ar_fundescr;
    YDEV_DESCR        ydevice;
    NSString          *serial, *funcId, *funcName, *funcVal;

    if(!YISERR([YapiWrapper getFunctionsByClass:@"MessageBox":0:&ar_fundescr:NULL]) && [ar_fundescr count] > 0){
        NSNumber*  ns_devdescr = [ar_fundescr objectAtIndex:0];
        if (!YISERR([YapiWrapper getFunctionInfo:[ns_devdescr intValue] :&ydevice :&serial :&funcId :&funcName :&funcVal :NULL])) {
            return  [YMessageBox FindMessageBox:[NSString stringWithFormat:@"%@.%@",serial,funcId]];
        }
    }
    return nil;
}

//--- (end of generated code: YMessageBox public methods implementation)

@end
//--- (generated code: MessageBox functions)

YMessageBox *yFindMessageBox(NSString* func)
{
    return [YMessageBox FindMessageBox:func];
}

YMessageBox *yFirstMessageBox(void)
{
    return [YMessageBox FirstMessageBox];
}

//--- (end of generated code: MessageBox functions)
