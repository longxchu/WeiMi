//
//  WeiMiCreditPostAnswerRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditPostAnswerRequest.h"

@implementation WeiMiCreditPostAnswerRequest
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
    return @"/base_fbquestion.html";
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             };
}
@end
