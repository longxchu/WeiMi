//
//  WeiMiChangeLocationRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeLocationRequest.h"

@implementation WeiMiChangeLocationRequest
{
    NSString *_phone;
    NSString *_location;
}

- (id)initWithMemberId:(NSString *)memberId location:(NSString *)location
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _location = location;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_address.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"address": _location,
             };
}

@end
