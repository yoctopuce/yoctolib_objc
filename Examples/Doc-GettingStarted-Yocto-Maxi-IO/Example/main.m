#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_digitalio.h"

static void usage(void)
{
    NSLog(@"usage: demo <serial_number> ");
    NSLog(@"       demo <logical_name>");
    NSLog(@"       demo any           (use any discovered device)");
    exit(1);
}

int main(int argc, const char * argv[])
{
    NSError *error;

    
    @autoreleasepool {

        YDigitalIO   *io;

	   	// Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb": &error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }
  	    
	   	if (argc >1  && strcmp(argv[1],"any")) {
            NSString *target = [NSString stringWithUTF8String:argv[1]];
            io =  [YDigitalIO FindDigitalIO:[NSString stringWithFormat:@"%@.digitalIO",target]];
	    }else{
            io = [YDigitalIO  FirstDigitalIO];
        }
        // make sure the device is here
        if (![io isOnline]) {
            NSLog(@"No module connected (check USB cable)");
            usage();
        }
        // lets configure the channels direction
        // bits 0..3 as output
        // bits 4..7 as input
        
        [io set_portDirection:0x0F];
        [io set_portPolarity:0]; // polarity set to regular
        [io set_portOpenDrain:0]; // No open drain
        
        NSLog(@"Channels 0..3 are configured as outputs and channels 4..7");
        NSLog(@"are configred as inputs, you can connect some inputs to");
        NSLog(@"ouputs and see what happens");

        int  outputdata = 0;
        while ([io isOnline]) {
            outputdata = (outputdata +1) % 16; // cycle ouput 0..15
            [io set_portState:outputdata]; // We could have used set_bitState as well
            [YAPI Sleep:1000:&error];
            int inputdata = [io get_portState]; // read port values
            char line[9]; // display part state value as binary
            for (int i = 0; i<8 ; i++) {
                if  (inputdata & (128 >> i))  
                    line[i]='1';
                else 
                    line[i]='0';
            }
            line[8]=0;
            NSLog(@"port value = %s",line);
            
        }
        NSLog(@"Module disconnected");
        [YAPI FreeAPI];
	}        
    return 0;
}
