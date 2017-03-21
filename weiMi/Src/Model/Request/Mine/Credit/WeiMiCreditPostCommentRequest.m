//
//  WeiMiCreditPostCommentRequest.m
//  weiMi
//  积分任务-发表评论/回复帖子
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditPostCommentRequest.h"

@implementation WeiMiCreditPostCommentRequest
{
    NSString *_memberId;
}

-(id)initWithMemberId:(NSString *)memberId{
    self = [super init];
    if (self) {
        _memberId = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/base_fbdiscuss.html";
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             };
}
@end
