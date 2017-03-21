//
//  WeiMiAddPurchaseChartRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/25.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddPurchaseChartModel : NSObject

@property (nonatomic, strong) NSString *productName;//产品名称
@property (nonatomic, strong) NSString *productType;//分类名称
@property (nonatomic, strong) NSString *productBrand;//	品牌
@property (nonatomic, strong) NSString *productImg;//	产品显示封面
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *isAble;//1为购物产品/2为体验产品
@end

@interface WeiMiAddPurchaseChartRequest : WeiMiBaseRequest

- (instancetype)initWithModel:(WeiMiAddPurchaseChartModel *)model;
@end
