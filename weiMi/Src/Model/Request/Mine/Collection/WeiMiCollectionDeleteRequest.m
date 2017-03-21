//
//  WeiMiCollectionDeleteRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCollectionDeleteRequest.h"

@implementation WeiMiCollectionDeleteRequest
{
    NSString *_collectId;
}

-(id)initWithCollectId:(NSString *)collectId
{
    self = [super init];
    if (self) {
        _collectId = collectId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_delCollect.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"collectId": _collectId,
             };
}
@end
