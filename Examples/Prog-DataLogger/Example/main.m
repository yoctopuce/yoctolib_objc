#import <Foundation/Foundation.h>
#import "yocto_api.h"

static void dumpSensor(YSensor *sensor)
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd MMM yyyy hh:mm:ss,SSS"];
  NSLog(@"Using DataLogger of %@", [sensor get_friendlyName]);
  YDataSet *dataset = [sensor get_recordedData:0:0];
  NSLog(@"loading summary... ");
  [dataset loadMore];
  YMeasure *summary = [dataset get_summary];
  NSDate *start = [summary get_startTimeUTC_asNSDate];
  NSDate *end   = [summary get_endTimeUTC_asNSDate];
  NSLog(@"from %@ to %@ : min=%.3f%@ avg=%.3f%@  max=%.3f%@\n",
        [dateFormatter stringFromDate:start], [dateFormatter stringFromDate:end], [summary
            get_minValue], [sensor get_unit],
        [summary get_averageValue], [sensor get_unit],
        [summary get_maxValue], [sensor get_unit]);
  NSLog(@"Loading details :   0%%");
  int progress = 0;
  do {
    progress = [dataset loadMore];
    //NSLog(@"%d",progress);
  } while(progress < 100);
  NSArray *details = [dataset get_measures];
  for(YMeasure * m in details) {
    start = [m get_startTimeUTC_asNSDate];
    end   = [m get_endTimeUTC_asNSDate];
    NSLog(@"from %@ to %@ : min=%.3f%@ avg=%.3f%@  max=%.3f%@\n",
          [dateFormatter stringFromDate:start], [dateFormatter stringFromDate:end], [m
              get_minValue], [sensor get_unit],
          [m get_averageValue], [sensor get_unit],
          [m get_maxValue], [sensor get_unit]);
  }
}

int main (int argc, const char * argv[])
{
  NSError    *error;
  YSensor  *sensor;


  @autoreleasepool {

    // Setup the API to use local USB devices
    if([YAPI RegisterHub:@"usb" :&error] != YAPI_SUCCESS) {
      NSLog(@"RegisterHub error: %@", [error localizedDescription]);
      return 1;
    }

    if(argc == 1) {
      sensor = [YSensor FirstSensor];
      if(sensor == nil) {
        NSLog(@"No data sensor found");
        return 0;
      }
    } else {
      sensor = [YSensor FindSensor:[NSString stringWithUTF8String:argv[1]]];
      if (![sensor isOnline]) {
        NSLog(@"Sensor %@ is not connected (check USB cable)", [sensor get_hardwareId]);
        return 0;
      }
    }
    dumpSensor(sensor);
    //[YAPI FreeAPI];
  }
  return 0;
}

