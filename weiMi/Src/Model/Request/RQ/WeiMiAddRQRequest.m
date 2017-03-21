//
//  WeiMiAddRQRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddRQRequest.h"

@implementation WeiMiAddRQRequest

-(id)initWithQId:(NSString *)qtId memberId:(NSString *)memberId content:(NSString *)content
{
    self = [super init];
    if (self) {
        _qtId = qtId;
        _memberId = memberId;
        _content = content;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Qt_addask.html";
}

- (id)requestArgument {
    
    return @{
             @"qtId":_qtId,
             @"memberId": _memberId,
             @"content": _content,
             };
}

@end
