//
//  WeiMiHPBrandDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiHPBrandDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *brandId;//proTypeId
@property (nonatomic, strong) NSString *isAble;//显示位置
@property (nonatomic, strong) NSString *brandName;//分类名称
@property (nonatomic, strong) NSString *brandImgPath;//品牌图标

@end
