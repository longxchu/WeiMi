//
//  WeiMiAddPurchaseChartRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/25.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddPurchaseChartRequest.h"
@implementation WeiMiAddPurchaseChartModel
@end
@implementation WeiMiAddPurchaseChartRequest
{
    
    WeiMiAddPurchaseChartModel *_model;
}

- (instancetype)initWithModel:(WeiMiAddPurchaseChartModel *)model
{
    if (self = [super init]) {
        
        _model = model;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Shop_addShop.html";
}

- (id)requestArgument
{
    return @{
             @"productName":_model.productName,
             @"productType":_model.productType,
             @"productBrand":_model.productBrand,
             @"productImg":_model.productImg,
             @"price":_model.price,
             @"number":_model.number,
             @"property":_model.property,
             @"memberId":_model.memberId,
             @"productId":_model.productId,
             @"isAble":_model.isAble,

             };
}
@end
