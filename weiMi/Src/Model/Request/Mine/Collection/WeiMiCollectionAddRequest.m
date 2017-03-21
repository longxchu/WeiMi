//
//  WeiMiCollectionAddRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCollectionAddRequest.h"

@implementation WeiMiCollectionAddRequest
{
    NSString *_memberId;
    NSString *_entityId;//产品id/帖子id
    NSString *_isAble;//1为产品/2为帖子
}

-(id)initWithMemberId:(NSString *)memberId entityId:(NSString *)entityId isAble:(NSString *)isAble

{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _isAble = isAble;
        _entityId = entityId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_addCollect.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"isAble": _isAble,
             @"entityId": _entityId,
             };
}
@end
