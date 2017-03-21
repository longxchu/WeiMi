//
//  WeiMiPayGetOrderInfoRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/5.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "WeiMiPayGetOrderInfoRequest.h"

@implementation WeiMiPayGetOrderInfoRequest
{
    NSString *_body;
    NSString *_subject;
    NSString *_outTradeNo;
    NSString *_totalAmount;
    
    
}

-(id)initWithBody:(NSString *)body subject:(NSString *)subject outTradeNo:(NSString *)outTradeNo totalAmount:(NSString *)totalAmount
{
    self = [super init];
    if (self) {
        _body = body;
        _subject = subject;
        _outTradeNo = outTradeNo;
        _totalAmount = totalAmount;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Pay_getOrderInfo.html";
}


- (id)requestArgument {
    
    return @{
             @"body":_body,
             @"subject":_subject,
             @"outTradeNo":_outTradeNo,
             @"totalAmount":_totalAmount,

             };
}
@end
