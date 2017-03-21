//
//  WeiMiUserInfoDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUserInfoDTO.h"
#import "WeiMiUserDefaultConfig.h"
#import "WeiMiCalculateAgeTool.h"

@implementation WeiMiUserInfoDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.token = @"madaoCN";
//    self.token = EncodeStringFromDic(dic,@"sign");

    self.avaterPath = WEIMI_IMAGEREMOTEURL([self responseImagePath:EncodeStringFromDic(dic,@"headImgPath")]);
    self.tel = EncodeStringFromDic(dic,@"memberId");
    self.password = EncodeStringFromDic(dic,@"passWord");
    self.userName = EncodeStringFromDic(dic,@"memberName");
    self.gender = EncodeStringFromDic(dic,@"sex");
    self.marriageStats = EncodeStringFromDic(dic,@"sign");
//    self.birthday = EncodeStringFromDic(dic,@"birthday");
    self.email = EncodeStringFromDic(dic,@"email");
    self.location = EncodeStringFromDic(dic,@"address");
    self.integrate = EncodeStringFromDic(dic,@"integrate");

    //处理年龄
//    self.age = EncodeStringFromDic(dic,@"age");
    NSString *ageStr = EncodeStringFromDic(dic,@"age");
    if (ageStr) {
        self.age = [NSString stringWithFormat:@"%ld", (long)[WeiMiCalculateAgeTool ageWithDateStringOfBirth:ageStr]];
        //处理年，月，日
        NSArray *arr = [ageStr splitBy:@"-"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [WeiMiUserDefaultConfig currentConfig].year = (NSString *)obj;
            }else if (idx == 1)
            {
                [WeiMiUserDefaultConfig currentConfig].month = (NSString *)obj;
            }else if (idx == 2)
            {
                [WeiMiUserDefaultConfig currentConfig].day = (NSString *)obj;
            }
        }];
    }

}

#pragma mark - Util

- (NSString *)responseImagePath:(NSString *)string {
    
    if (string) {
        
        NSString *str = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        return str;
    }
    return nil;
}


#pragma mark - setter

- (void)setLocation:(NSString *)location
{
    _location = location;
    [WeiMiUserDefaultConfig currentConfig].location = location;
}

- (void)setMarriageStats:(NSString *)marriageStats
{
    _marriageStats = marriageStats;
    [WeiMiUserDefaultConfig currentConfig].marriageStats = marriageStats;
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [WeiMiUserDefaultConfig currentConfig].token = token;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [WeiMiUserDefaultConfig currentConfig].userName = userName;
}

- (void)setAvaterPath:(NSString *)avaterPath
{
    _avaterPath = avaterPath;
    [WeiMiUserDefaultConfig currentConfig].avaterPath = avaterPath;
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    [WeiMiUserDefaultConfig currentConfig].nickName = nickName;
}

- (void)setTel:(NSString *)tel
{
    _tel = tel;
    [WeiMiUserDefaultConfig currentConfig].tel = tel;

}

- (void)setGender:(NSString *)gender
{
    _gender = gender;
    [WeiMiUserDefaultConfig currentConfig].gender = gender;
}

- (void)setAge:(NSString *)age
{
    _age = age;
    [WeiMiUserDefaultConfig currentConfig].age = age;

}

- (void)setIntegrate:(NSString *)integrate
{
    _integrate = integrate;
    [WeiMiUserDefaultConfig currentConfig].integrate = integrate;
}

- (void)setEmail:(NSString *)email
{
    _email = email;
    [WeiMiUserDefaultConfig currentConfig].email = email;
}
//- (void)setGender:(NSString *)gender
//    _gender = gender;
//    [WeiMiUserDefaultConfig currentConfig].gender = gender;
//}

@end
