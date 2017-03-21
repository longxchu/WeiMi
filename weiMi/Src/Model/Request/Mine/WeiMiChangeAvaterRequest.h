//
//  WeiMiChangeAvaterRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiChangeAvaterRequest : WeiMiBaseRequest

-(id)initWithMemberId:(NSString *)memberId headImg:(NSString *)headImg;

@end
