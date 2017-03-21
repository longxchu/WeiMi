//
//  WeiMiGoodsDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiGoodsDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imageURL;//图像 faceImgPath
@property (nonatomic, strong) NSString *titleStr;//标题 productName
@property (nonatomic, strong) NSString *priceStr;//价格 price

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, copy) NSString *collectId;
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *proTypeId;
@property (nonatomic, strong) NSString *salesVolume;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *isAble;

@property (nonatomic, strong) NSString *isShow;
@property (nonatomic, strong) NSString *imgfiles;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *cishu;

@property (nonatomic, assign) BOOL isSelect;

@end
