//
//  WeiMiChangeGenderRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiChangeGenderRequest : WeiMiBaseRequest


- (id)initWithMemberId:(NSString *)memberId sex:(NSString *)sex;

@end
