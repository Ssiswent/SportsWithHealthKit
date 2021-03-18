//
//  GHDateTools.m
//  GHCalendarPicker
//
//  Created by Hank on 16/3/12.
//  Copyright © 2016年 GH. All rights reserved.
//

#import "GHDateTools.h"

@implementation GHDateTools
+(NSString *)changeStringToDate:(NSString *)string {

    

    //带有T的时间格式，是前端没有处理包含时区的，强转后少了8个小时，date是又少了8个小时，所有要加16个小时。

    

    NSString *str =[string stringByReplacingOccurrencesOfString:@"T"withString:@" "];

    

    NSString *sss =[str substringToIndex:19];

    

    //    NSString *str1 =[str stringByReplacingOccurrencesOfString:@".000Z" withString:@""];

    

    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];

    

    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    

    [dateFromatter setTimeZone:timeZone];

    

    NSDate *date = [dateFromatter dateFromString:sss];

    

    NSDate *newdate = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:date];//

    

    NSDate *newdate1 = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:newdate];

    

    NSString *newstr =[[NSString stringWithFormat:@"%@",newdate1] substringToIndex:16];

    

    return newstr;
}
+ (NSString * _Nonnull)generateMD5StringFromString:(NSString * _Nonnull)string {
    
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+(NSDate *)initYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.year = year;
    dateComponent.month = month;
    dateComponent.day = day;
    return [NSDate dateWithTimeInterval:0 sinceDate:[calendar dateFromComponents:dateComponent]];
}
+(NSDate *)dateByAddingMonths:(NSDate *)startDate andMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.month = month;
    return [calendar dateByAddingComponents:dateComponent toDate:startDate options:NSCalendarMatchNextTime];
}
+(NSInteger)numberOfDaysInMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
   return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+(NSInteger)weekday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
}
+(NSInteger)hour:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitHour fromDate:date].hour;

}
+(NSInteger)second:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitSecond fromDate:date].second;

}
+(NSInteger)minute:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMinute fromDate:date].minute;

}
+(NSInteger)day:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitDay fromDate:date].day;

}
+(NSInteger)month:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMonth fromDate:date].month;

}
+(NSInteger)year:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitYear fromDate:date].year;

}
+(NSDate*)dateByAddingDays:(NSDate *)date day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.day = day;
    return  [calendar dateByAddingComponents:dateComponent toDate:date options:NSCalendarMatchNextTime];
}
+(BOOL)isDateSameDay:(NSDate *)date andTwoDate:(NSDate *)twoDate
{
    if ([GHDateTools day:twoDate]==[GHDateTools day:date]&&[GHDateTools month:twoDate]==[GHDateTools month:date]&&[GHDateTools year:twoDate]==[GHDateTools year:date]) {
        return YES;
    }
    return NO;
}

+(BOOL)isSaturday:(NSDate*)date{
    
    return ([GHDateTools getWeekday:date]==7);
}
+(BOOL)isFriday:(NSDate*)date{
    return ([GHDateTools getWeekday:date]==6);

}
+(BOOL)isThursday:(NSDate*)date{
    return ([GHDateTools getWeekday:date]==5);

}
+(BOOL)isWednesday:(NSDate*)date{
    return ([GHDateTools getWeekday:date]==4);

}
+(BOOL)isTuesday:(NSDate*)date;
{
    return ([GHDateTools getWeekday:date]==3);

}
+(BOOL)isMonday:(NSDate*)date{
    return ([GHDateTools getWeekday:date]==2);

}
+(BOOL)isSunday:(NSDate*)date{
    return ([GHDateTools getWeekday:date]==1);

}
+(BOOL)isToday:(NSDate*)date{
    
   return [GHDateTools isDateSameDay:date andTwoDate:[NSDate date]];

}

+(NSInteger)getWeekday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
}
+(NSString *)monthNameFull:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MMMM YYYY";
    return [dateFormatter stringFromDate:date];
}
@end
