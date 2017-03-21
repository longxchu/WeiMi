//
//  DDConvertTimeStamp.h
//  DDPositionDetail
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 dingdang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDConvertTimeStamp : NSObject

+ (NSString *)convertTime:(NSString *)time;

+ (NSString *)timeFormat:(NSDate *)date;

@end
