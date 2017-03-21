//
//  WeiMiHomePageBannerDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageBannerDTO.h"

@implementation WeiMiHomePageBannerDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.bannerId = EncodeStringFromDic(dic, @"bannerId");
    self.bannerImgPath = EncodeStringFromDic(dic, @"bannerImgPath");
    self.bannerUrl = EncodeStringFromDic(dic, @"bannerUrl");
    self.isAble = EncodeNumberFromDic(dic, @"isAble").integerValue;
    self.bannerSort = EncodeNumberFromDic(dic, @"bannerSort").integerValue;

}

@end
