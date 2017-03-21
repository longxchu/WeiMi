//
//  WeiMiAddPostCommentRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddPostCommentRequest.h"

@implementation WeiMiAddPostCommentRequest

{
    NSString *_infoId;
    NSString *_memberId;
    NSString *_disContent;
}

- (id)initWithMemberId:(NSString *)memberId infoId:(NSString *)infoId disContent:(NSString *)disContent
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _infoId = infoId;
        _disContent = disContent;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Dis_add.html";
}


- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"infoId": _infoId,
             @"disContent":_disContent,
             };
}
@end
