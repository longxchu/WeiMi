//
//  WeiMiPayCancelOrderRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/5.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "WeiMiPayCancelOrderRequest.h"

@implementation WeiMiPayCancelOrderRequest
{
    NSString *_orderId;
}

-(id)initWithQtId:(NSString *)orderId
{
    self = [super init];
    if (self) {
        _orderId = orderId;
        
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/order_cancelOrder.html";
}


- (id)requestArgument {
    
    return @{
             @"orderId":_orderId,
             };
}

@end
