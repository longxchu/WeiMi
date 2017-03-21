//
//  WeiMiNewestActDetailResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiNewestActDetailDTO.h"

@interface WeiMiNewestActDetailResponse : WeiMiBaseResponse

@property (nonatomic, strong) WeiMiNewestActDetailDTO *dto;
@end
