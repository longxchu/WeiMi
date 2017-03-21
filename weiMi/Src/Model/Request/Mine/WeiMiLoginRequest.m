//
//  WeiMiLoginRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLoginRequest.h"

@implementation WeiMiLoginRequest
{
    NSString *_phone;
    NSString *_password;
}

- (id)initWithMemberId:(NSString *)memberId password:(NSString *)password
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_login.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"passWord": _password,
             };
}

@end
