//
//  WeiMiChangeMarriageRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeMarriageRequest.h"

@implementation WeiMiChangeMarriageRequest
{
    NSString *_phone;
    NSString *_marital;
}

- (id)initWithMemberId:(NSString *)memberId marital:(NSString *)marital
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _marital = marital;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_Marital.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"Marital": _marital,
             };
}

@end
