//
//  WeiMiChangePassWordRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//	madao

#import "WeiMiBaseRequest.h"

@interface WeiMiChangePassWordRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId password:(NSString *)password verifyCode:(NSString *)code;

@end
