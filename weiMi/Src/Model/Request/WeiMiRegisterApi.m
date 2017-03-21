//
//  WeiMiRegisterApi.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRegisterApi.h"

@implementation WeiMiRegisterApi
{
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/iphone/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"username": _username,
             @"password": _password
             };
}

- (id)jsonValidator {
    return @{
             @"userId": [NSNumber class],
             @"nick": [NSString class],
             @"level": [NSNumber class]
             };
}

@end
