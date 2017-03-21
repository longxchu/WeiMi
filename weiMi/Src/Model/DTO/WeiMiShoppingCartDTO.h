//
//  WeiMiShoppingCartDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiShoppingCartDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;//productImg
@property (nonatomic, strong) NSString *title;//productName
@property (nonatomic, strong) NSString *subTitle;//property
@property (nonatomic, assign) double price;//price
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSString *shopId;//shopId
@property (nonatomic, strong) NSString *productType;//productType
@property (nonatomic, strong) NSString *productBrand;//productBrand
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *productId;//productId
@property (nonatomic, strong) NSString *isAble;//isAble
@property (nonatomic, strong) NSString *createTime;//createTime

@end
