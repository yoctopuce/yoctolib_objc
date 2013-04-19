#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_colorled.h"



int main (int argc, const char * argv[])
{
    NSError *errmsg;

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // Setup the API to use local USB devices
    if(yRegisterHub(@"usb",&errmsg) != YAPI_SUCCESS) {
        NSLog(@"RegisterHub error: %@\n",[errmsg localizedDescription]);
        [pool drain];
        return 1;
    }

    srandom((unsigned)time(NULL));
    while(1){
        yUpdateDeviceList(NULL);
        YColorLed *led =  yFirstColorLed();
        while(led){
            unsigned hsl = (unsigned)(random() % 256)<<16 | 0xff80;
            [led set_hslColor:hsl];
            led = [led nextColorLed]; 
        }
    }
    
    [pool drain];
    return 0;
}

