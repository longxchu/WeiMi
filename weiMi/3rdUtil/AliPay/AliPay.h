//
//  AliPay.h
//  weiMi
//
//  Created by 梁宪松 on 2017/1/3.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AliPay : NSObject

// 本地签名发起支付请求
- (void)doAliPayWithSubject:(NSString *)subject outTradeNo:(NSString *)outTradeNo
                totalAmount:(CGFloat)totalAmount body:(NSString *)body handler:(CompletionBlock) handler;
// 发起支付请求
- (void)doAliPayWithOrderStr:(NSString *)orderStr handler:(CompletionBlock) handler;
@end
