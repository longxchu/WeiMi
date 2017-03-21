//
//  WeiMiExchangeCouponRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiExchangeCouponRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId strCode:(NSString *)strCode;

@end
