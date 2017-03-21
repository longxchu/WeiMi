//
//  WeiMiInvitationZanRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInvitationZanRequest.h"

@implementation WeiMiInvitationZanRequest
{
    NSString *_phone;
    NSString *_infoId;
}

- (id)initWithMemberId:(NSString *)memberId infoId:(NSString *)infoId
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _infoId = infoId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Infor_addCollect.html";
}


- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"infoId": _infoId,
             };
}

@end
