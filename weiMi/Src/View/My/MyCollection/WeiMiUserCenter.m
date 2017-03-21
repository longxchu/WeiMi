//
//  WeiMiUserCenter.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUserCenter.h"
#import "WeiMiUserDefaultConfig.h"

@interface WeiMiUserCenter()

@end

@implementation WeiMiUserCenter

DEF_SINGLETON( WeiMiUserCenter );

- (id)init {
    
    self = [super init];
    
    if (self) {
        _userInfoDTO = [[WeiMiUserInfoDTO alloc] init];
        _userInfoDTO.token = [WeiMiUserDefaultConfig currentConfig].token;
        _userInfoDTO.userName = [WeiMiUserDefaultConfig currentConfig].userName;
        _userInfoDTO.avaterPath = [WeiMiUserDefaultConfig currentConfig].avaterPath;
        _userInfoDTO.password = [WeiMiUserDefaultConfig currentConfig].password;
        _userInfoDTO.gender = [WeiMiUserDefaultConfig currentConfig].gender;
        _userInfoDTO.tel = [WeiMiUserDefaultConfig currentConfig].tel;
        _userInfoDTO.age = [WeiMiUserDefaultConfig currentConfig].age;
        _userInfoDTO.marriageStats = [WeiMiUserDefaultConfig currentConfig].marriageStats;
        _userInfoDTO.location = [WeiMiUserDefaultConfig currentConfig].location;
    }
    return self;
}

//清除用户信息
- (void)clearUserInfo
{
    //    self.userInfoDTO = nil;##不移除此行 会出现退出登录后 再次登录，无法记录登录状态
    [WeiMiUserDefaultConfig currentConfig].token = nil;
    [WeiMiUserDefaultConfig currentConfig].userName = nil;
    [WeiMiUserDefaultConfig currentConfig].password = nil;
    
    [WeiMiUserDefaultConfig currentConfig].avaterPath = nil;
    [WeiMiUserDefaultConfig currentConfig].nickName = nil;
    [WeiMiUserDefaultConfig currentConfig].tel = nil;
    [WeiMiUserDefaultConfig currentConfig].gender = nil;
    [WeiMiUserDefaultConfig currentConfig].age = nil;
    [WeiMiUserDefaultConfig currentConfig].year = nil;
    
    [WeiMiUserDefaultConfig currentConfig].month = nil;
    [WeiMiUserDefaultConfig currentConfig].year = nil;
    [WeiMiUserDefaultConfig currentConfig].day = nil;
    
    [WeiMiUserDefaultConfig currentConfig].marriageStats = nil;
    [WeiMiUserDefaultConfig currentConfig].marriageStatsIdx_sec = 0;
    [WeiMiUserDefaultConfig currentConfig].marriageStatsIdx_row = 0;
    
    [WeiMiUserDefaultConfig currentConfig].location = nil;

}

//返回信息完整率
- (NSInteger)infoCompleteRate
{
    float idx = 0;
    idx += (![NSString isNullOrEmpty:_userInfoDTO.userName] ? 1:0);
    idx += (![NSString isNullOrEmpty:_userInfoDTO.avaterPath] ? 1:0);
    idx += (![NSString isNullOrEmpty:_userInfoDTO.userName] ? 1:0);
    idx += (![NSString isNullOrEmpty:_userInfoDTO.gender] ? 1:0);
    idx += (![NSString isNullOrEmpty:_userInfoDTO.tel] ? 1:0);
    idx += (![NSString isNullOrEmpty:_userInfoDTO.age] ? 1:0);

    return (NSInteger)(idx/6 * 100);
}

-(BOOL)isLogin
{
    if ([WeiMiUserDefaultConfig currentConfig].token) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
