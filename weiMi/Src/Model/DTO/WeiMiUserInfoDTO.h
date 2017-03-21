//
//  WeiMiUserInfoDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiUserInfoDTO : WeiMiBaseDTO

@property (nonatomic,strong) NSString * token;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *avaterPath;
@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *marriageStats;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *integrate;
@property (nonatomic, strong) NSString *email;
@end
