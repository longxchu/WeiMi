//
//  WeiMiChangeNickNameRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiChangeNickNameRequest : WeiMiBaseRequest

-(id)initWithMemberId:(NSString *)memberId userName:(NSString *)userName;

@end