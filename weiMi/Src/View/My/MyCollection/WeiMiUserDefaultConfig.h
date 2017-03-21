//
//  WeiMiUserDefaultConfig.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiUserDefaultConfig : NSObject

+(WeiMiUserDefaultConfig *)            currentConfig;

+ (void)addObserver:(id)observer selector:(SEL)sel forSetting:(NSString *)settingName;
+ (void)removeObserver:(id)observer forSetting:(NSString *)settingName;

@property (nonatomic,strong) NSString * token;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *avaterPath;
@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic,strong) NSString * sign;

@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;

@property (nonatomic, assign) NSString *marriageStats;
@property (nonatomic, assign) NSInteger marriageStatsIdx_sec;
@property (nonatomic, assign) NSInteger marriageStatsIdx_row;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *integrate;
@property (nonatomic, strong) NSString *email;
@end
