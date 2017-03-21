//
//  WeiMiLoginRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiLoginRequest : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId password:(NSString *)password;


@end
