//
//  AliPay.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/3.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "AliPay.h"
#import "Order.h"
#import "Order+Producer.h"

static const NSString *aliPaySchema = @"weMeeAliPay";

@implementation AliPay

- (void)doAliPayWithSubject:(NSString *)subject outTradeNo:(NSString *)outTradeNo
                totalAmount:(CGFloat)totalAmount body:(NSString *)body handler:(CompletionBlock) handler
{
    
    NSString *orderString = [Order creatOrderWithSubject:subject outTradeNo:outTradeNo totalAmount:totalAmount body:body];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:aliPaySchema callback:handler];

}

// 发起支付请求
- (void)doAliPayWithOrderStr:(NSString *)orderStr handler:(CompletionBlock) handler
{
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:aliPaySchema callback:handler];
}

@end
