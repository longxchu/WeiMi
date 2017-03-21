//
//  WeiMiNewestActDetailRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActDetailRequest.h"

@implementation WeiMiNewestActDetailRequest
{
    NSString *_atId;
}

-(id)initWithActId:(NSString *)atId
{
    self = [super init];
    if (self) {
        _atId = atId;

    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Act_findAct.html";
}

- (id)requestArgument {
    return @{
             @"atId":_atId,
             };
}
@end
