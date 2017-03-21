//
//  WeiMiPayDeleteOrderRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/5.
//  Copyright © 2017年 madaoCN. All rights reserved.
//  删除订单

#import "WeiMiPayDeleteOrderRequest.h"

@implementation WeiMiPayDeleteOrderRequest
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
    return @"/order_delOrder.html";
}


- (id)requestArgument {
    
    return @{
             @"orderId":_orderId,
             };
}
@end
