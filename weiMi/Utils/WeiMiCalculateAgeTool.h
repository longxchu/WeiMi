//
//  WeiMiCalculateAgeTool.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiCalculateAgeTool : NSObject

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;
+ (NSInteger)ageWithDateStringOfBirth:(NSString *)dateStr;
+ (NSString *)getConstellationWithMonth:(NSInteger)month day:(NSInteger)day;
@end
