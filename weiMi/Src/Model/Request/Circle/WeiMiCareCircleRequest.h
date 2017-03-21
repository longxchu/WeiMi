//
//  WeiMiCareCircleRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCareCircleRequest : WeiMiBaseRequest


-(id)initWithMemberId:(NSString *)memberId ringId:(NSString *)ringId;
@end

@interface WeiMiCancelCircleRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId ringId:(NSString *)ringId;

@end