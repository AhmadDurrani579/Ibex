//
//  NSDate-Key.m
//  BlueNRG
//

#import "NSDate-Key.h"
#import "NSDate+TimeAgo.h"

@implementation NSDate(Key)

+ (NSDate*) dateWithDateKey: (NSUInteger) aDateKey
{
    NSInteger year = (int)(aDateKey / 10000);
    NSInteger month = (int)((aDateKey % 10000) / 100);
    NSInteger day = (int)(aDateKey % 100);
    
    
    static NSDateFormatter* dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    }
    
    NSString* formattedDate = [NSString stringWithFormat: @"%ld-%02ld-%02ld", (long)year, (long)month, (long)day];
    return [dateFormatter dateFromString: formattedDate];
}

+ (NSInteger) numberOfMonthsBetweenDateKey: (NSUInteger) startDateKey andDateKey: (NSUInteger) endDateKey
{
    NSInteger retVal = 0;
    
    NSInteger endYear = (NSInteger)endDateKey / 10000;
    NSInteger startYear = (NSInteger)startDateKey / 10000;
    
    retVal = (endYear - startYear) * 12;
    
    NSInteger endMonth = ((NSInteger)endDateKey / 100) - endYear * 100;
    NSInteger startMonth = ((NSInteger)startDateKey / 100) - startYear * 100;
    retVal += endMonth - startMonth;
    return retVal;
}

- (NSString *)timeAgoForInsta
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if(deltaSeconds < 5)
    {
        return @"Just now";
    }
    else if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d%@seconds ago" withValue:deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return @"1m"; //@"A minute ago"
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d%@m" withValue:deltaMinutes]; //inutes ago
    }
    else if (deltaMinutes < 120)
    {
        return @"1h"; //An hour ago
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d%@h" withValue:minutes]; //ours ago
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return @"Yesterday";
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d%@d" withValue:minutes]; //ays ago
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return @"Last week";
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d%@w" withValue:minutes]; //eeks ago
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return @"Last month";
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d%@m" withValue:minutes]; //onths ago
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return @"Last year";
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d%@y" withValue:minutes]; //ears ago
}

- (NSString *) stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:localeFormat, value];
}

-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  return @"_";
        if(Y == 1 && XY != 11)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

- (NSUInteger) dateKey
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [cal components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate: self];

    return [comps year] * 10000 + [comps month] * 100 + [comps day];
}


- (NSString *)TimeRemaingUntil: (NSDate *)aDate
{
    NSUInteger flags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSCalendar* gregorianCalendar   = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; //NSGregorianCalendar
    NSDateComponents* components    = [gregorianCalendar components:flags fromDate:self toDate:aDate options: 0];
    NSMutableArray *arrayComponents = [NSMutableArray array];
    
    
    NSString *month                 = [NSString stringWithFormat:@"%ld",(long)[components month]];
    if ([month integerValue] > 0) {
        if ([month integerValue] > 1) {
            month                   = [NSString stringWithFormat:@"%@ Months",month];
        }else{
            month                   = [NSString stringWithFormat:@"%@ Month",month];
        }
        [arrayComponents addObject:month];
    }
    
    NSString *day   = [NSString stringWithFormat:@"%ld",(long)[components day]];
    if ([day integerValue] > 0) {
        if ([day integerValue] > 1) {
            day                     = [NSString stringWithFormat:@"%@ Days",day];
        }else{
            day                     = [NSString stringWithFormat:@"%@ Day",day];
        }
        [arrayComponents addObject:day];
    }
    
    if (arrayComponents.count <=0) {
        NSString *hour  = [NSString stringWithFormat:@"%ld",(long)[components hour]];
        if ([hour integerValue] > 0) {
            if ([hour integerValue] > 1) {
                hour                    = [NSString stringWithFormat:@"%@ Hours",hour];
            }else{
                hour                    = [NSString stringWithFormat:@"%@ Hour",hour];
            }
            [arrayComponents addObject:hour];
        }
    }

    if (arrayComponents.count <= 0) {
        NSString *min   = [NSString stringWithFormat:@"%ld",(long)[components minute]];
        if ([min integerValue] > 0) {
            if ([min integerValue] > 1) {
                min                     = [NSString stringWithFormat:@"%@ Mins",min];
            }else{
                min                     = [NSString stringWithFormat:@"%@ Min",min];
            }
            [arrayComponents addObject:min];
        }
    }
    
    if (arrayComponents.count <= 0) {
        NSString *sec   = [NSString stringWithFormat:@"%ld",(long)[components second]];
        if ([sec integerValue] > 0) {
            if ([sec integerValue] > 1) {
                sec                     = [NSString stringWithFormat:@"%@ Secs",sec];
            }else{
                sec                     = [NSString stringWithFormat:@"%@ Sec",sec];
            }
            [arrayComponents addObject:sec];
        }
    }
    
    
    
    NSString    *finalString        = @"Expired";
    if (arrayComponents.count > 0) {
        finalString = [arrayComponents componentsJoinedByString:@" "];
    }

    return finalString;
}


- (NSInteger) numberOfSecsUntil: (NSDate*) aDate
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitSecond fromDate: self toDate: aDate options: 0];
    
    return [components second];
}


- (NSInteger) numberOfMinsUntil: (NSDate*) aDate
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitMinute fromDate:self toDate:aDate options: 0];
    
    return [components minute];
}

- (NSInteger) numberOfHoursUntil: (NSDate*) aDate
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitHour fromDate: self toDate: aDate options: 0];
    
    return [components hour];
}

- (NSInteger) numberOfDaysUntil: (NSDate*) aDate 
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitDay fromDate: self toDate: aDate options: 0];
    
    return [components day];
}

- (NSInteger) numberOfMonthsUntil: (NSDate*) aDate
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitMonth fromDate: self toDate: aDate options: 0];
    
    return [components month];
}


- (NSInteger) numberOfYearsUntil: (NSDate*) aDate
{
    NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [gregorianCalendar components: NSCalendarUnitYear fromDate: self toDate: aDate options: 0];
    
    return [components year];
}

- (NSDate*) nextDay
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setDay: 1];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}


- (NSDate*) nextWeek
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setDay: 7];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}

- (NSDate*) prevWeek
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setDay: -7];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}

- (NSDate*) nextMonth
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setMonth: 1];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}

- (NSDate*) prevMonth
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setMonth: -1];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}

- (NSDate*) prevMonths: (NSInteger) numberOfMonths
{
    // set up date components
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    [components setMonth: -numberOfMonths];
    
    // create a calendar
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    return [gregorian dateByAddingComponents: components toDate: self options: 0];
}

- (NSString*) time
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle: NSDateFormatterNoStyle];
    [df setTimeStyle: NSDateFormatterShortStyle];
    return [df stringFromDate: self];
}

- (NSTimeInterval) timeIntervalSinceMidnight
{
    return [self timeIntervalSinceDate: [NSDate dateWithDateKey: [self dateKey]]];
}

- (NSDate*) zeroSecondsDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [cal components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                               NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                     fromDate: self];
    
    [comps setSecond: 0];
    
    return [cal dateFromComponents: comps];
}

- (NSDate *)toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}


#pragma mark - Date Converstion Method

+ (NSDate *)dateFromString:(NSString *)stringDate withFormat:(NSString *)format {
    NSDate *convertedDate;
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [myDateFormatter setDateFormat:format];
    
    convertedDate = [myDateFormatter dateFromString:stringDate];
    
    
    return convertedDate;
}


+ (NSString *)getStringFromDate:(NSDate *)Date withFormat:(NSString *)format{
    NSString *convertedDate = nil;
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [myDateFormatter setDateFormat:format];
    
    convertedDate = [myDateFormatter stringFromDate:Date];
    
    return convertedDate;
}

+ (NSString *)getUTCFormateDate:(NSDate *)localDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MMM dd,yyyy hh:mm:ss a"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}

+ (NSDate *)getDateFromUTCString:(NSString *)utcDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MMM dd,yyyy hh:mm:ss a"];
    NSDate *date = [dateFormatter dateFromString:utcDate];
    
    return date;
}

@end
