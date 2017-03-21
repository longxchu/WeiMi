//
//  WeiMiCalculateAgeTool.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCalculateAgeTool.h"

@implementation WeiMiCalculateAgeTool

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];

    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];

    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }

    return iAge;
}


+ (NSInteger)ageWithDateStringOfBirth:(NSString *)dateStr
{
    //通过NSDateFormatter将NSString 转换成 NSDate 格式
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    // 通过NSDateComponents 从 date 中提取出 年月日
    
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    NSInteger year = [components1 year];
    
    NSInteger month = [components1 month];
    
    NSInteger day = [components1 day];
    
    NSInteger hour = [components1 hour];
    
    NSInteger minute = [components1 minute];
    
    NSInteger second = [components1 second];
    
    
    // 获取系统当前的年月日
    
    NSDate *currentDate = [NSDate date]; // 获得系统的时间
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:currentDate];
    
    NSInteger currentYear = [components2 year];
    
    NSInteger currentMonth = [components2 month];
    
    NSInteger currentDay = [components2 day];
    
    
    // 计算年龄
    
    NSInteger iAge = currentYear - year - 1;
    
    if ((currentMonth > month) || (currentMonth == month && currentDay >= day)) {
        
        iAge++;
    }
    return iAge;
}

+ (NSString *)getConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result;
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*3-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*3, 3)]];
    
    return result;
}
@end
