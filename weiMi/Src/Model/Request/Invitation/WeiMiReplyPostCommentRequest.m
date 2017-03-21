//
//  WeiMiReplyPostCommentRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiReplyPostCommentRequest.h"

@implementation WeiMiReplyPostCommentRequest
    {
        NSString *_tomemberId;//回复会员id
        NSString *_memberId;//会员id
        NSString *_disContent;//评论内容
        NSString *_disId;//评论ID
    }
    
- (id)initWithMemberId:(NSString *)memberId tomemberId:(NSString *)tomemberId disContent:(NSString *)disContent disId:(NSString *)disId
    {
        self = [super init];
        if (self) {
            _memberId = memberId;
            _tomemberId = tomemberId;
            _disContent = disContent;
            _disId = disId;
        }
        return self;
    }
    
- (NSString *)requestUrl {
    return @"/Dis_addDis.html";
}
    
    
- (id)requestArgument {

    return @{
             @"memberId": _memberId,
             @"tomemberId": _tomemberId ? _tomemberId :@"",
             @"detContent":_disContent,
             @"disId":_disId ? _disId : @"",
             };
}
@end
