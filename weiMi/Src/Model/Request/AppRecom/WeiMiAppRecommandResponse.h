//
//  WeiMiAppRecommandResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"

@interface WeiMiAppRecommandDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *appName;//
@property (nonatomic, strong) NSString *andriodUrl;//
@property (nonatomic, strong) NSString *appId;//
@property (nonatomic, strong) NSString *isAble;//
@property (nonatomic, strong) NSString *appLogo;
@property (nonatomic, strong) NSString *iosUrl;

@end

@interface WeiMiAppRecommandResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
