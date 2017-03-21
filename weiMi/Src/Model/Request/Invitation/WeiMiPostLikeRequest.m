//
//  WeiMiPostLikeRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPostLikeRequest.h"

@implementation WeiMiPostLikeRequest

{
    NSString *_disId;
    NSString *_memberId;
}

- (id)initWithMemberId:(NSString *)memberId disId:(NSString *)disId
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _disId = disId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Dis_addCollect.html";
}


- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"disId": _disId,
             };
}

@end
