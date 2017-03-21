//
//  WeiMiCreditToExchangeRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditToExchangeRequest.h"

@implementation WeiMiCreditToExchangeRequest
{
    NSString *_memberId;
    NSString *_vouId;
}

-(id)initWithMemberId:(NSString *)memberId vouId:(NSString *)vouId{
    self = [super init];
    if (self) {
//        if([memberId hasSuffix:@"@"]){
//            _memberId = [[memberId mutableCopy] substringToIndex:10];
//        } else {
//        }
        _memberId = memberId;
        _vouId = vouId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_insertVou.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"vouId": _vouId,
             };
}


@end
