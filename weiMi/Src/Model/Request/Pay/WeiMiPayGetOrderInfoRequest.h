//
//  WeiMiPayGetOrderInfoRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2017/1/5.
//  Copyright © 2017年 madaoCN. All rights reserved.
//  支付接口

#import "WeiMiBaseRequest.h"

@interface WeiMiPayGetOrderInfoRequest : WeiMiBaseRequest

-(id)initWithBody:(NSString *)body subject:(NSString *)subject outTradeNo:(NSString *)outTradeNo totalAmount:(NSString *)totalAmount;

@end
