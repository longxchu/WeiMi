//
//  WeiMiRegisterRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRegisterRequest.h"

@implementation WeiMiRegisterRequest
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
    return @"/Member_register.html";
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
//- (NSInteger)cacheTimeInSeconds {
//    // 3banner缓存三天
//    return 60 * 60 *  24 * 3;
//}

@end
