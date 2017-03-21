//
//  WeiMiOrderDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiOrderDTO : WeiMiBaseDTO

@property (nonatomic, assign) NSUInteger tradeStatus;// 0 未付款 1 交易成功 2 待收货
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double offPrice;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) double transportFee;
@property (nonatomic, assign) NSUInteger buyNum;


@end
