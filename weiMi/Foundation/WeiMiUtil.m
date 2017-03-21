//
//  WeiMiUtil.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUtil.h"
#import "CommonCrypto/CommonDigest.h"

@implementation WeiMiUtil

//MD5
+ (NSString *)MD5String:(NSData *)data {
    unsigned char digest[CC_MD5_DIGEST_LENGTH]={0};
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *s=[NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [s appendFormat:@"%02X",digest[i]];
    }
    return [s uppercaseString];
}

/**
 *  判断是否开启通知
 */
+ (BOOL)isAllowedNotification
{
    // ios8以后设备
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending) {
        
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != settings.types)
            return YES;
    }else{
        UIRemoteNotificationType *notiType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != notiType) {
            return YES;
        }
    }
    return NO;
}

@end
