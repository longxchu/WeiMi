//
//  Order+Producer.h
//  weiMi
//
//  Created by 梁宪松 on 2017/1/3.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "Order.h"

@interface Order (Producer)

// subject NOTE: 商品的标题/交易标题/订单标题/订单关键字等。
// out_trade_no 订单ID（由商家自行制定）
// total_amount //商品价格
// body NOTE: (非必填项)商品描述
+ (NSString *)creatOrderWithSubject:(NSString *)subject outTradeNo:(NSString *)outTradeNo
                        totalAmount:(CGFloat)totalAmount body:(NSString *)body;
@end
