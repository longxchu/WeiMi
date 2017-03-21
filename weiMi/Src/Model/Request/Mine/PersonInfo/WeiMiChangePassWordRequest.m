//
//  WeiMiChangePassWordRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangePassWordRequest.h"

@implementation WeiMiChangePassWordRequest
{
    NSString *_phone;
    NSString *_password;
    NSString *_code;
}

- (id)initWithMemberId:(NSString *)memberId password:(NSString *)password verifyCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _password = password;
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_changePwd.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"passWord": _password,
             @"checkCode": _code,
             };
}


@end
