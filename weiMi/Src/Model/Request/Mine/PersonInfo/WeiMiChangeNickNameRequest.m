//
//  WeiMiChangeNickNameRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeNickNameRequest.h"

@implementation WeiMiChangeNickNameRequest
{
    NSString *_memberId;
    NSString *_userName;
}

-(id)initWithMemberId:(NSString *)memberId userName:(NSString *)userName{
    self = [super init];
    if (self) {
        _userName = userName;
        _memberId = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_userName.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"userName": _userName,
             };
}
@end
