//
//  WeiMiMyOrderListResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiOrderDTO.h"

@interface WeiMiOrderModel : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *person;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *orderId;

@end

@interface WeiMiOrderProductModel : NSObject

@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *productBrand;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *productImg;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSString *productId;

@end

@interface WeiMiOrderResultModel : NSObject

@property (nonatomic, strong) WeiMiOrderModel *orderModel;//原始数据
@property (nonatomic, strong) NSMutableArray *orderProducts;//原始数据

@property (nonatomic, strong) WeiMiOrderDTO *orderDTO;//表示层
@end

@interface WeiMiMyOrderListResponse : WeiMiBaseResponse


@property (nonatomic, strong) NSMutableArray *dataArr;

@end
