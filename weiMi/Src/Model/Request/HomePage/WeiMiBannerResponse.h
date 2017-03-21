//
//  WeiMiBannerResponse.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiHomePageBannerDTO.h"

@interface WeiMiBannerResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;
- (void)parseResponse:(NSArray *)arr;
@end
