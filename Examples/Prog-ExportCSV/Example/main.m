#import <Foundation/Foundation.h>
#import "yocto_api.h"

int main (int argc, const char * argv[])
{
  NSError  *error;
  YSensor  *sensor;
  NSMutableArray* sensorList;
  YConsolidatedDataSet* data;
  NSMutableArray* record;
  NSString  *line;
  NSDate    *date;

  @autoreleasepool {

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    // Enumerate all connected sensors
    sensorList = [NSMutableArray array];
    sensor = [YSensor FirstSensor];
    if(sensor == nil) {
      NSLog(@"No data sensor found");
      return 0;
    }
    while(sensor) {
      [sensorList addObject:sensor];
      sensor = [sensor nextSensor];
    }

    // Generate consolidated CSV output for all sensors
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddThh:mm:ss.SSS"];
    data = [[YConsolidatedDataSet alloc] initWith:0 :0 :sensorList];
    while([data nextRecord:record] < 100) {
      double timestamp = [[record objectAtIndex:0] doubleValue];
      date = [NSDate dateWithTimeIntervalSince1970:timestamp];
      line = [dateFormatter stringFromDate: date];
      for (size_t idx = 1; idx < [record count]; idx++) {
        line = [NSString stringWithFormat:@"%@;%.3f", line, [[record objectAtIndex:idx] doubleValue]];
      }
      NSLog(@"%@", line);
    }

    //[YAPI FreeAPI];
  }
  return 0;
}

