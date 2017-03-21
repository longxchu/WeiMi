//
//  WeiMiPassWorldRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPassWorldRequest.h"

@implementation WeiMiPassWorldRequest
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
    return @"/Member_phoneExist.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             };
}

@end
