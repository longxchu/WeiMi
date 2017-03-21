//
//  WeiMiPersonalCredit.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPersonalCreditRequest.h"

@implementation WMCreditModel

- (id)shareModel {
    static dispatch_once_t onceToken;
    static WMCreditModel *model = nil;
    dispatch_once(&onceToken, ^{
        model = [[WMCreditModel alloc] init];
    });
    return model;
}

@end

@implementation WeiMiPersonalCreditRequest
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
    return @"/Integral_myIntegrate.html";
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
