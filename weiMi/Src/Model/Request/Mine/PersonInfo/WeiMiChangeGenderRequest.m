//
//  WeiMiChangeGenderRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeGenderRequest.h"

@implementation WeiMiChangeGenderRequest
{
    NSString *_phone;
    NSString *_sex;
}

- (id)initWithMemberId:(NSString *)memberId sex:(NSString *)sex
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _sex = sex;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_sex.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"sex": _sex,
             };
}

@end
