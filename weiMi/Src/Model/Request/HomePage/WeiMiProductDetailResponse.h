//
//  WeiMiProductDetailResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiHPProductListDTO.h"

@interface WeiMiProductDetailResponse : WeiMiBaseResponse

@property (nonatomic, strong) WeiMiHPProductListDTO *dto;
@property (nonatomic, strong) NSArray *imageFiles;
@property (nonatomic, strong) NSArray *property;
@end
