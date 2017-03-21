//
//  WeiMiReplyPostCommentRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiReplyPostCommentRequest : WeiMiBaseRequest
    
- (id)initWithMemberId:(NSString *)memberId tomemberId:(NSString *)tomemberId disContent:(NSString *)disContent disId:(NSString *)disId;
    
@end
