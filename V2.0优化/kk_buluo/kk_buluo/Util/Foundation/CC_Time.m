//
//  Time.m
//  TimeLabelTest
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "CC_Time.h"

#define WEEK_DAYS @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"]

@implementation CC_Time

+ (NSDateFormatter *)dateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone* GTMzone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:GTMzone];
    return dateFormatter;
}

+(NSString *)getTimeStringWithNowDate:(NSString *)nowDateStr OldDate:(NSString *)oldDateStr
{
    
    if (oldDateStr.length < 10) {
        return @" ";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
    NSDate *oldDate = [dateFormatter dateFromString:oldDateStr];
    
    NSString *cutOldDateStr = [oldDateStr substringWithRange:NSMakeRange(11, 5)];
    
    if (!nowDate) {
        nowDate = [NSDate date];
    }
    
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSTimeInterval old = [oldDate timeIntervalSince1970];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *nowComps ;
    nowComps = [calendar components:unitFlags fromDate:nowDate];
    NSDateComponents *oldComps ;
    oldComps = [calendar components:unitFlags fromDate:oldDate];
    
    NSString *returnStr ;
    
//    NSInteger count = [CC_Time yearCountWithNowDate:nowDate withBeforeDate:oldDate];
//    if (count > 1) {
//        returnStr = [oldDateStr substringWithRange:NSMakeRange(0, 10)];
//    }else if (count == 1){
//
//    }else{
//
//    }
    
    //不为同一个年
    if ( !(nowComps.year==oldComps.year) )
    {
        //相差一年
        if (nowComps.year == oldComps.year + 1)
        {
            if (nowComps.month == 1 && oldComps.month == 12)
            {
                if (nowComps.day == 1 && oldComps.day == 31)
                {
                   returnStr = [NSString stringWithFormat:@"昨天 %@",cutOldDateStr];
                }
                else {
                    //判断是否为同一个星期
                    if ([CC_Time isTheSameWeekFromTodayWithDate:nowDate withBefore:oldDate]) {
                        NSString *weakStr = [CC_Time dateWeekWithDateString:oldDateStr];
                        returnStr = [NSString stringWithFormat:@"%@ %@",weakStr,[oldDateStr substringWithRange:NSMakeRange(11, 5)]];
                    }else{
                        returnStr = [oldDateStr substringWithRange:NSMakeRange(5, 11)];
                    }
                }
            }
            else
            {
                returnStr = [oldDateStr substringWithRange:NSMakeRange(0, 10)];//xxxx-xx-xx
            }
        }
        //相差一年以上
        else
        {
            returnStr = [oldDateStr substringWithRange:NSMakeRange(0, 10)];//xxxx-xx-xx
        }
    }
    //不为同一个月
    else if (nowComps.month != oldComps.month)
    {
        //上一个月
        if (nowComps.month == oldComps.month + 1)
        {
            //昨天
            if (nowComps.day == oldComps.day + 1){
                returnStr = [NSString stringWithFormat:@"昨天 %@",cutOldDateStr];
            }
            else{
                    //判断是否为同一个星期
                    if ([CC_Time isTheSameWeekFromTodayWithDate:nowDate withBefore:oldDate]) {
                        NSString *weakStr = [CC_Time dateWeekWithDateString:oldDateStr];
                        returnStr = [NSString stringWithFormat:@"%@ %@",weakStr,[oldDateStr substringWithRange:NSMakeRange(11, 5)]];
                    }else{
                        returnStr = [oldDateStr substringWithRange:NSMakeRange(5, 11)];
                    }
                }
        }
        //相差一个月以上
        else
        {
            returnStr = [oldDateStr substringWithRange:NSMakeRange(5, 11)];
        }
    }
    //不为同一个天
    else if (nowComps.day != oldComps.day)
    {
        //昨天
        if (nowComps.day == oldComps.day + 1)
        {
            
            returnStr = [NSString stringWithFormat:@"昨天 %@",cutOldDateStr];
        }
        //昨天之前
        else
        {
            //判断是否为同一个星期
            if ([CC_Time isTheSameWeekFromTodayWithDate:nowDate withBefore:oldDate]) {
                NSString *weakStr = [CC_Time dateWeekWithDateString:oldDateStr];
                returnStr = [NSString stringWithFormat:@"%@ %@",weakStr,[oldDateStr substringWithRange:NSMakeRange(11, 5)]];
            }else{
                returnStr = [oldDateStr substringWithRange:NSMakeRange(5, 11)];
            }
        }
    }
    else if ( now - old>= 60*60) {
        returnStr = [CC_Time outOneHour:(int)(now - old)/(60*60)];
    }
    else if ( now - old >= 60){
        return [CC_Time outOneMinute:(int)(now - old)/60];
    }
    else if (now -old >= 0){
        returnStr = [CC_Time inOneMinute];
    }
    else{
        returnStr = [CC_Time inOneMinute];
    }

    return returnStr;
}

/**
 获取两个日期相差的年数

 @param nowDate 当前日期
 @param before 之前的日期
 @return 两个日期的年份差距
 */
+ (NSInteger)yearCountWithNowDate:(NSDate *)nowDate withBeforeDate:(NSDate *)before{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierISO8601];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:nowDate];
    NSInteger beforYear = [calendar component:NSCalendarUnitYear fromDate:before];
    
    NSInteger count = nowYear - beforYear;
    
    return count;
}
/**
 返回描述字符串
 @return 一分钟之内
 */
+ (NSString *)inOneMinute{
    return @"刚刚";
}
/**
 返回描述字符串
 @return 一小时之内
 */
+ (NSString *)outOneMinute:(int)minutes{
    return [NSString stringWithFormat:@"%d分钟前",minutes];//xx分钟前
}
/**
 返回描述字符串
 @return 一天之内
 */
+ (NSString *)outOneHour:(int)hour{
    return [NSString stringWithFormat:@"%d小时前",hour];//xx分钟前
}

/** 判断两个日期是否为同一个星期 */
+ (BOOL)isTheSameWeekFromTodayWithDate:(NSDate *)nowDate withBefore:(NSDate *)beforeDate {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierISO8601];
    
    NSInteger nowInteger = [calendar component:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    
    NSInteger nowWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
//    NSInteger beforeInteger = -1;
    
    NSInteger beforeInteger = 0;
    NSInteger beforeWeekDay = 0;
    if (beforeDate) {
        beforeWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:beforeDate];
        
        beforeInteger = [calendar component:NSCalendarUnitWeekOfYear fromDate:beforeDate];
    }
    if (nowDate) {
        nowWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:nowDate];
        nowInteger = [calendar component:NSCalendarUnitWeekOfYear fromDate:nowDate];
    }
    
    if (nowInteger == beforeInteger) {
        // 在一周
        return YES;
    } else if (nowInteger - beforeInteger == 1 && beforeWeekDay == 1) {
        // 西方一周的第一天从周日开始，所以需要判断当前是否为一周的第一天，如果是，则为同周
        return YES;
    } else {
        
        return NO;
    }
}
/** 将日期信息转化为星期几输出 */
+ (NSString *)dateWeekWithDateString:(NSString *)dateString
{
    static NSDateFormatter* dateFormat = nil;
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//hh:12小时制, HH:24小时制
    }
    NSDate *date = [dateFormat dateFromString:dateString];
    
    NSCalendar* calendar = NSCalendar.currentCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday
                                               fromDate:date];
    NSInteger weekday = components.weekday - 1;
    static NSArray *weekdays = nil;
    if(!weekdays){
        weekdays =@[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    }
    return  weekdays[weekday];
    
    
//    NSTimeInterval time=[dateString doubleValue];
//    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *weekdayComponents =
//    [gregorian components:NSCalendarUnitWeekday fromDate:date];
//    NSInteger _weekday = [weekdayComponents weekday];
//    NSString *weekStr;
//    if (_weekday == 1) {
//        weekStr = @"星期一";
//    }else if (_weekday == 2){
//        weekStr = @"星期二";
//    }else if (_weekday == 3){
//        weekStr = @"星期三";
//    }else if (_weekday == 4){
//        weekStr = @"星期四";
//    }else if (_weekday == 5){
//         weekStr = @"星期五";
//    }else if (_weekday == 6){
//        weekStr = @"星期六";
//    }else if (_weekday == 7){
//        weekStr = @"星期日";
//    }
//    return weekStr;
}



+(NSString *)formatRecentContactDate:(NSString *)nowDateStr OldDate:(NSString *)oldDateStr;
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
    NSDate *oldDate = [dateFormatter dateFromString:oldDateStr];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                         NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday
                                                    fromDate:nowDate];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday
                                                   fromDate:oldDate];
    
    static NSDateFormatter *formatter = nil;
    NSString *dateString = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    
    if (todayComponents.day == dateComponents.day) {
        formatter.dateFormat = @"MM-dd";
        dateString = [formatter stringFromDate:oldDate];
    }
    else if (todayComponents.day - 1 == dateComponents.day) {
        formatter.dateFormat = @"MM-dd";
        dateString =@"昨天";//[NSString stringWithFormat:@"昨天%@",[formatter stringFromDate:oldDate]];
    }
    else if (todayComponents.day - dateComponents.day <= 7) {
        if (WEEK_DAYS.count > dateComponents.weekday-1) {
            formatter.dateFormat = @"HH:mm";
            dateString = [NSString stringWithFormat:@"%@",WEEK_DAYS[dateComponents.weekday-1]];
        }
    }
    else {
        formatter.dateFormat = @"MM-dd";
        dateString = [formatter stringFromDate:oldDate];
    }
    
    return dateString;
}


@end



#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay  |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)


@implementation NSDate (Category)

+ (NSDate *)dp_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [CC_Time dateFormatter];
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}


- (int)dp_day
{
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return (int)components.day;
}

- (int)dp_month
{
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return (int)components.month;
}

-(int)dp_year
{
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return (int)components.year;
}

-(int)dp_year_week
{
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return (int)components.weekOfYear;
}

+(NSString *)getWeekStringWithNowDate:(NSString *)string withFormat:(NSString *)format andDayInterval:(int)dayInterval
{
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
//    if (dayInterval==0) {
//        return @"今天";
//    }
    
    NSDate *nowdate = [NSDate dp_dateFromString:string withFormat:format];
    if (!nowdate) {
        nowdate = [NSDate date];
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:dayInterval];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:nowdate options:0];
    
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:mDate];
    int week = (int)components.weekday;
    
    NSString *weekDayStr = @"周";
    switch (week) {
        case 1:
            weekDayStr = @"周日";
            break;
        case 2:
            weekDayStr = @"周一";
            break;
        case 3:
            weekDayStr = @"周二";
            break;
        case 4:
            weekDayStr = @"周三";
            break;
        case 5:
            weekDayStr = @"周四";
            break;
        case 6:
            weekDayStr = @"周五";
            break;
        case 7:
            weekDayStr = @"周六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}


+(NSString *)getMonthDayStringWithNowDate:(NSString *)string withFormat:(NSString *)format andDayInterval:(int)dayInterval
{
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    
//    if (dayInterval==0) {
//        return @"今";
//    }
    NSDate *nowdate = [NSDate dp_dateFromString:string withFormat:format];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:dayInterval];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:nowdate options:0];
    
    NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:mDate];
    int month = (int)components.month;
    int day = (int)components.day;
//    NSString *weekDayStr = [NSString stringWithFormat:@"%d/%d",month,day];
    NSString *weekDayStr = [NSString stringWithFormat:@"%d月%d日",month,day];

    return weekDayStr;

}
+(NSString *)getHourMinuteStringWithNowDate:(NSString *)string withFormat:(NSString *)format
{
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }

    //    if (dayInterval==0) {
    //        return @"今";
    //    }
    NSDate *nowdate = [NSDate dp_dateFromString:string withFormat:format];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器

    dateFormatter.dateFormat=@"hh:mm";//指定转date得日期格式化形式

    NSString *timeStr = [dateFormatter stringFromDate:nowdate];//2015-11-20 08:24:04

    return timeStr;

}

+ (NSString *)getTimeStringWithNowDate:(NSString *)string withFormat:(NSString *)format andDayInterval:(int)dayInterval
{
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *nowdate = [NSDate dp_dateFromString:string withFormat:format];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:dayInterval];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:nowdate options:0];
    
    NSDateFormatter *formatter = [CC_Time dateFormatter];
    NSString *timeStr = [formatter stringFromDate:mDate];
    return timeStr;
}
@end
