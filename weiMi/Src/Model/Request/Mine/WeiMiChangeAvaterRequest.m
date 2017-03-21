//
//  WeiMiChangeAvaterRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChangeAvaterRequest.h"

@implementation WeiMiChangeAvaterRequest
{
    NSString *_memberId;
    NSString *_headImg;
}

-(id)initWithMemberId:(NSString *)memberId headImg:(NSString *)headImg{
    self = [super init];
    if (self) {
        _headImg = headImg;
        _memberId = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_headImg.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{
             @"memberId": _memberId,
            @"headImg": _headImg,
             };
}

@end
