//
//  WeiMiPostLikeRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiPostLikeRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId disId:(NSString *)disId;

@end