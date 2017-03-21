//
//  WeiMiUserCenter.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiMiUserInfoDTO.h"

@interface WeiMiUserCenter : NSObject

AS_SINGLETON(WeiMiUserCenter);

@property (nonatomic, strong) WeiMiUserInfoDTO *userInfoDTO;

- (void)clearUserInfo;

-(BOOL)isLogin;

- (NSInteger)infoCompleteRate;
@end
