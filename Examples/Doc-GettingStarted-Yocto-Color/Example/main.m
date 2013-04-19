#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_colorled.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number>  [ color | rgb ]");
    NSLog(@"       demo <logical_name> [ color | rgb ]");
    NSLog(@"       demo any  [ color | rgb ]                (use any discovered device)");
    NSLog(@"Eg.");
    NSLog(@"   demo any FF1493 ");
    NSLog(@"   demo YRGBLED1-123456 red");
    exit(1);
}

int main(int argc, const char * argv[])
{
    NSError * error;
    
    if(argc < 3) {
        usage();
    }
    
    @autoreleasepool {
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
        NSString *target    = [NSString stringWithUTF8String:argv[1]];
        NSString *color_str = [NSString stringWithUTF8String:argv[2]];
        if ([target isEqualToString:@"any"]) {
            YColorLed *colorLed = [YColorLed FirstColorLed];
            if (colorLed==NULL) {
                NSLog(@"No Yocto-Color connected (check USB cable)");
                return 1;
            }
            target = [[colorLed module] serialNumber];
        }

        YColorLed *led1 =  [YColorLed FindColorLed:[target stringByAppendingString:@".colorLed1"]];
        YColorLed *led2 =  [YColorLed FindColorLed:[target stringByAppendingString:@".colorLed2"]];
        unsigned color;
        if ([color_str isEqualToString:@"red"])
            color = 0xFF0000;
        else if ([color_str isEqualToString:@"green"])            
            color = 0x00FF00;
        else if ([color_str isEqualToString:@"blue"])
            color = 0x0000FF;
        else 
            color = (int)strtoul([color_str UTF8String],NULL, 16);
    
        if ([led1 isOnline]) {
            [led1 set_rgbColor:color];  // immediate switch
            [led2 rgbMove:color:1000];  // smooth transition  
        } else {
            NSLog(@"Module not connected (check identification and USB cable)\n");
        }
    }
    
    return 0;
}
