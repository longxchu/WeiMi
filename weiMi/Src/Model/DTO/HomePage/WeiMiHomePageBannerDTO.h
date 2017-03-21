//
//  WeiMiHomePageBannerDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiHomePageBannerDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *bannerId;
@property (nonatomic, strong) NSString *bannerImgPath;
@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, assign) NSInteger bannerSort;
@property (nonatomic, assign) NSInteger isAble;

@end
