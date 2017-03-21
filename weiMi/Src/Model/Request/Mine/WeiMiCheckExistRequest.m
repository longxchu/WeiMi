//
//  WeiMiCheckExistRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCheckExistRequest.h"

@implementation WeiMiCheckExistRequest
{
    NSString *_phone;
}

-(id)initWithMemberId:(NSString *)memberId{
    self = [super init];
    if (self) {
        _phone = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_existence.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             };
}

@end
