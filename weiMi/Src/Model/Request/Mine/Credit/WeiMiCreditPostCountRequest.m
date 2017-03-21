//
//  WeiMiCreditPostCountRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditPostCountRequest.h"

@implementation WeiMiCreditPostCountRequest
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
    return @"/base_fbtiezi.html";
}
    
- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             };
}
@end
