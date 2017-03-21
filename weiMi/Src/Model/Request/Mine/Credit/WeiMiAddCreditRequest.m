//
//  WeiMiAddCreditRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddCreditRequest.h"

@implementation WeiMiAddCreditRequest
{
    NSString *_memberId;
    NSString *_baseId;
}

-(id)initWithMemberId:(NSString *)memberId baseId:(NSString *)baseId{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _baseId = baseId;
    }
    return self;
}
    
- (NSString *)requestUrl {
    return @"/base_addJF.html";
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"baseId": _baseId,
             };
}
@end
