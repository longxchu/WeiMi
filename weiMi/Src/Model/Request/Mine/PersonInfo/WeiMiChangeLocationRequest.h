//
//  WeiMiChangeLocationRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiChangeLocationRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId location:(NSString *)location;

@end
