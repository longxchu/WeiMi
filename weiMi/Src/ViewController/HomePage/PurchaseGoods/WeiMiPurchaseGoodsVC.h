//
//  WeiMiPurchaseGoodsVC.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"
#import "WeiMiProductDetailResponse.h"

@interface WeiMiPurchaseGoodsVC : WeiMiBaseViewController

@property (nonatomic, assign) BOOL isBuy;//是否是立即购买 否则是加入购物车
@property (nonatomic, strong) WeiMiProductDetailResponse *response;

@end
