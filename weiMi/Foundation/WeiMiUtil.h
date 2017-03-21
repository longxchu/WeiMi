//
//  WeiMiUtil.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiUtil : NSObject

+ (NSString *)MD5String:(NSData *)data ;

/**
 *  判断是否开启通知
 */
+ (BOOL)isAllowedNotification;

@end
