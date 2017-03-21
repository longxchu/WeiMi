//
//  WeiMiChangeAgeRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeAgeRequest.h"

@implementation WeiMiChangeAgeRequest
{
    NSString *_phone;
    NSString *_age;
}

- (id)initWithMemberId:(NSString *)memberId age:(NSString *)age
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _age = age;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_age.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"age": _age,
             };
}
@end
