#import <Foundation/Foundation.h>
#import "yocto_api.h"
#import "yocto_datalogger.h"

int main (int argc, const char * argv[])
{
    NSError    *error;
    YDataLogger *logger;
    NSArray     *dataStreams;
    int         i;


    @autoreleasepool {
      
        // Setup the API to use local USB devices
        if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
            NSLog(@"RegisterHub error: %@", [error localizedDescription]);
            return 1;
        }

        logger = [YDataLogger FirstDataLogger];
        if(logger == nil) {
            NSLog(@"No data logger found");
            return 0;
        }
        NSLog(@"Using DataLogger of %@", [[logger module] serialNumber]);

        if([logger get_dataStreams:&dataStreams] != YAPI_SUCCESS) {
            NSLog(@"get_dataStreams failed");
            return -1;
        }

        NSLog(@"%ld stream(s) of data.",[dataStreams count]);

        for(i = 0; i < [dataStreams count]; i++) {
            YDataStream *s = [dataStreams objectAtIndex:i];
            int         nrows, r;
            
            NSLog(@"Data stream %d:",i);
            NSLog(@"- Run #%d, time=%u / UTC %ld\n", 
                  [s get_runIndex],[s get_startTime], [s get_startTimeUTC]);
            nrows = [s get_rowCount ];
            if(nrows > 0) {
                int c;
                NSLog(@"- %d samples, taken every %f [s]",nrows,[s get_dataSamplesInterval]);
                NSString *keys = @"";
                NSArray *names  = [s get_columnNames];
                for(c = 0; c < [names count] ; c++) {
                    keys = [keys stringByAppendingFormat:@"%@  ", [names objectAtIndex:c]];
                }
                NSLog(@"%@",keys);
                NSArray *table = [s get_dataRows ];
                for(r = 0; r < [table count]; r++) {
                    NSArray  *row  = [table objectAtIndex:r];
                    NSString *line = @"";
                    for(c = 0; c < [row count]; c++) {
                        line = [line stringByAppendingFormat:@"%@   ",[row objectAtIndex:c]];
                    }
                    NSLog(@"%@",line);
                }
            }        
        }
    }
    return 0;
}

