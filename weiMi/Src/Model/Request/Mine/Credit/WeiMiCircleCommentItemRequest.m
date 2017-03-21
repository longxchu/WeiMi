//
//  WeiMiCircleCommentItemRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCommentItemRequest.h"

@implementation WeiMiCircleCommentItemRequest
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
    return @"/base_pjshangpin.html";
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             };
}
@end
