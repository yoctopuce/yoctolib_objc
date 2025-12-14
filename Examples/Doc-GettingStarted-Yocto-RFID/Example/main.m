/*********************************************************************
 *
 *  $Id: svn_id $
 *
 *  Doc-GettingStarted-Yocto-RFID example
 *
 *  You can find more information on our web site:
 *   Objective-C API Reference:
 *      https://www.yoctopuce.com/EN/doc/reference/yoctolib-objc-EN.html
 *
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "yocto_api.h"
#include "yocto_rfidreader.h"
#include "yocto_buzzer.h"
#include "yocto_colorledcluster.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {
    NSError *error;
    YBuzzer* buz;
    YColorLedCluster* leds;
    YRfidReader* reader;
    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    if (argc > 1) {
      NSString     *target = [NSString stringWithUTF8String:argv[1]];
      reader = [YRfidReader FindRfidReader:target];
    } else {
      reader = [YRfidReader FirstRfidReader];
      if (reader == NULL) {
        NSLog(@"No module connected (check USB cable)");
        return 1;
      }
    }

    NSString*serial = [[reader get_module] get_serialNumber];
    leds = [YColorLedCluster FindColorLedCluster:[serial stringByAppendingString:@".colorLedCluster"]];
    buz   = [YBuzzer FindBuzzer:[serial stringByAppendingString:@".buzzer"]];

    [leds set_rgbColor:0 :1 :0x000000];
    [buz set_volume:75];
    NSLog(@"Place a RFID tag near the antenna");
    NSMutableArray *tagList = [[NSMutableArray alloc] init];

    do {
      tagList = [reader get_tagIdList];
    }  while ([tagList count]  <= 0);

    NSString* tagId = [tagList objectAtIndex:0];
    YRfidStatus *opStatus =  [[YRfidStatus alloc] init];
    YRfidOptions *options =  [[YRfidOptions alloc] init];

    YRfidTagInfo *taginfo = [reader get_tagInfo:tagId :opStatus];
    int  blocksize = [taginfo get_tagBlockSize];
    int   firstBlock = [taginfo get_tagFirstBlock];
    NSLog(@"Tag ID          = %@", [taginfo get_tagId] );
    NSLog(@"Tag Memory size = %d", [taginfo get_tagMemorySize]);
    NSLog(@"Tag Block  size = %d", [taginfo get_tagBlockSize] );

    NSString* data = [reader tagReadHex:tagId :firstBlock :3 * blocksize :options :opStatus];
    if ([opStatus get_errorCode] == Y_SUCCESS) {
      NSLog(@"First 3 blocks  = %@" ,  data );
      [leds set_rgbColor:0 :1 :0x00FF00];
      [buz pulse:1000 :100];
    } else {
      NSLog(@"Cannot read tag contents (%@)" , [opStatus get_errorMessage]);
      [leds set_rgbColor:0 :1 :0xFF0000];
    }
    [leds rgb_move:0 :1 :0x000000 :200];
    [YAPI FreeAPI];
  }
  return 0;
}
