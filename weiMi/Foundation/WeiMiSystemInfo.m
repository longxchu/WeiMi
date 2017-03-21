//
//  WeiMiSystemInfo.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSystemInfo.h"
#import <UIKit/UIDevice.h>
#import "KeychainItemWrapper.h"

@implementation WeiMiSystemInfo

+ (NSString *)simplePlatform
{
    if (IS_IPAD) {
        return @"IPAD";
    }
    else
    {
        return @"IPHONE";
    }
    
}

+ (NSString *)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//获取系统当前时间
+ (NSString *)systemTimeInfo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateString;
}

+ (NSString *)appVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@", version];
}

#pragma mark -
#pragma mark jailbreaker

static const char * __jb_app = NULL;

+ (BOOL)isJailBroken
{
    static const char * __jb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    __jb_app = NULL;
    
    // method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") )
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)jailBreaker
{
    if ( __jb_app )
    {
        return [NSString stringWithUTF8String:__jb_app];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)getUUID {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
    NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrService)];
    if (uuid) {
        return uuid;
    } else {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
        [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrService)];
        return uuid;
    }
}


@end
