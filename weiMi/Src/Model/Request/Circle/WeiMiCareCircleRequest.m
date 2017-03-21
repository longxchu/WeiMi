//
//  WeiMiCareCircleRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCareCircleRequest.h"

@implementation WeiMiCareCircleRequest
{
    NSString *_ringId;
    NSString *_memberId;
}

-(id)initWithMemberId:(NSString *)memberId ringId:(NSString *)ringId
{
    self = [super init];
    if (self) {

        _ringId = ringId;
        _memberId = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Ring_addShou.html";
}


- (id)requestArgument {

    return @{
             @"ringId":_ringId ? _ringId:@"",
             @"memberId":_memberId ? _memberId:@"",
             };
}
@end

@implementation WeiMiCancelCircleRequest {
    NSString *_ringId;
    NSString *_memberId;
}

- (id)initWithMemberId:(NSString *)memberId ringId:(NSString *)ringId {
    self = [super init];
    if(self){
        _ringId = ringId;
        _memberId = memberId;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/Ring_cancleShou.html";
}
- (id)requestArgument {
    return @{@"ringId":_ringId,@"memberId":_memberId};
}

@end
