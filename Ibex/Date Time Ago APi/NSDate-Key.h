//
//  NSDate-Key.h
//  BlueNRG
//

#import <Foundation/Foundation.h>

@interface NSDate(Key)

+ (NSDate*)dateWithDateKey: (NSUInteger) aDateKey;

+ (NSInteger)numberOfMonthsBetweenDateKey: (NSUInteger) startDateKey andDateKey: (NSUInteger) endDateKey;

- (NSUInteger)dateKey;

- (NSString *)TimeRemaingUntil: (NSDate *)aDate;

- (NSInteger)numberOfSecsUntil: (NSDate*) aDate;

- (NSInteger)numberOfMinsUntil: (NSDate*) aDate;

- (NSInteger)numberOfHoursUntil: (NSDate*) aDate;

- (NSInteger)numberOfDaysUntil: (NSDate*) aDate;

- (NSInteger)numberOfMonthsUntil: (NSDate*) aDate;

- (NSInteger)numberOfYearsUntil: (NSDate*) aDate;

- (NSDate*)nextDay;

- (NSDate*)nextWeek;

- (NSDate*)prevWeek;

- (NSDate*)nextMonth;

- (NSDate*)prevMonth;

- (NSDate*)prevMonths:(NSInteger)numberOfMonths;

- (NSString*)time;

- (NSTimeInterval)timeIntervalSinceMidnight;

- (NSDate*)zeroSecondsDate;

+ (NSDate *)dateFromString:(NSString *)stringDate withFormat:(NSString *)format;

+ (NSString *)getStringFromDate:(NSDate *)Date withFormat:(NSString *)format;

+ (NSString *)getUTCFormateDate:(NSDate *)localDate;
+ (NSDate *)getDateFromUTCString:(NSString *)utcDate;

- (NSDate *)toLocalTime;

- (NSString *)timeAgoForInsta;

@end
