//
//  DDConvertTimeStamp.m
//  DDPositionDetail
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 dingdang. All rights reserved.
//

#import "DDConvertTimeStamp.h"

@implementation DDConvertTimeStamp

+ (NSString *)convertTime:(NSString *)time
{
    if (!time || [@"" isEqualToString:time]) {
        return @"";
    }
    
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    long a =  [timeSp longLongValue] - time.longLongValue/1000;
    
    long day = a/(3600*24);
    
    if (day < 360 && day > 30) {
        return [NSString stringWithFormat:@"%ld个月前",day/30];
    }
    else if (day >360){
        return [NSString stringWithFormat:@"%ld年以前",day/360];
    }
    else if (day == 0)
    {
        long second = a/3600;
        if (second > 0 && second < 24) {
            return [NSString stringWithFormat:@"%ld小时前",second];
        }else{
            return [NSString stringWithFormat:@"%ld分钟前",a/60];
        }
        
    }
    else if (day > 1 && day < 6){
        return [NSString stringWithFormat:@"%ld天前",day];
    }else{
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:time.longLongValue/1000];
        NSString *dateStr = [dateFormatter stringFromDate:d];
        return dateStr;
    }
    return @"";
}

@end
