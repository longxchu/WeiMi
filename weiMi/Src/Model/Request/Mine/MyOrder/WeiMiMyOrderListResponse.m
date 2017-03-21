//
//  WeiMiMyOrderListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyOrderListResponse.h"

@implementation WeiMiOrderProductModel
@end
@implementation WeiMiOrderModel
@end
@implementation WeiMiOrderResultModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.orderProducts = [NSMutableArray new];
    }
    return self;
}

@end

@implementation WeiMiMyOrderListResponse

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

-(void)parseResponse:(NSDictionary *)dic
{
    NSMutableArray *arr = EncodeArrayFromDic(dic, @"result");
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            WeiMiOrderResultModel *model = [[WeiMiOrderResultModel alloc] init];
            
            NSDictionary *oderDic = EncodeDicFromDic(obj, @"order");
            model.orderModel = [self parseOrder:oderDic];
            
            NSArray *orderProductArr = EncodeArrayFromDic(obj, @"orderproducts");
            model.orderProducts = [self parseOrderProduct:orderProductArr];
            
            WeiMiOrderDTO *dto = [[WeiMiOrderDTO alloc] init];
            WeiMiOrderModel *orderModel = model.orderModel;
            WeiMiOrderProductModel *productModel = safeObjectAtIndex(model.orderProducts, 0);
            if ([orderModel.payStatus isEqualToString:@"0"]) {//未支付
                dto.tradeStatus = 0;
            }else{//已支付
                if ([orderModel.orderStatus isEqualToString:@"3"]) {//已完成
                    dto.tradeStatus = 1;
                }else if ([orderModel.orderStatus isEqualToString:@"1"])//待发货
                {
                    dto.tradeStatus = 2;
                }else if ([orderModel.orderStatus isEqualToString:@"2"])//待收货
                {
                    dto.tradeStatus = 2;
                }
            }
            if (productModel.productImg) {
                dto.imgURL = WEIMI_IMAGEREMOTEURL(productModel.productImg);
            }
            dto.title = productModel.productName;
            dto.subTitle = productModel.property;
            dto.buyNum = productModel.number.integerValue;
            dto.price = productModel.price.floatValue / dto.buyNum;
            dto.totalPrice = productModel.price.floatValue;
            model.orderDTO = dto;
            //        WeiMiMyCreditDTO *dto = [[WeiMiMyCreditDTO alloc] init];
            //        [dto encodeFromDictionary:di];
            [_dataArr addObject:model];
        }
    }];
    return;

}

//- (WeiMiOrderDTO *)configDTO:(WeiMiOrderDTO *)dto
//{
//    WeiMiOrderProductModel *model = safeObjectAtIndex(sel, <#NSInteger index#>)
//    dto.imgURL =
//    return dto;
//}

- (WeiMiOrderModel *)parseOrder:(NSDictionary *)dic
{
    WeiMiOrderModel *_orderModel = [[WeiMiOrderModel alloc] init];
    _orderModel.createTime = EncodeStringFromDic(dic, @"createTime");
    _orderModel.phone = EncodeStringFromDic(dic, @"phone");
    _orderModel.person = EncodeStringFromDic(dic, @"person");
    _orderModel.address = EncodeStringFromDic(dic, @"address");
    _orderModel.payStatus = EncodeStringFromDic(dic, @"payStatus");
    _orderModel.isAble = EncodeStringFromDic(dic, @"isAble");
    _orderModel.memberId = EncodeStringFromDic(dic, @"memberId");
    _orderModel.orderStatus = EncodeStringFromDic(dic, @"orderStatus");
    _orderModel.totalMoney = EncodeStringFromDic(dic, @"totalMoney");
    _orderModel.orderId = EncodeStringFromDic(dic, @"orderId");
    return _orderModel;
}

- (NSMutableArray *)parseOrderProduct:(NSArray *)arr
{
    NSMutableArray *resultArr = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        WeiMiOrderProductModel *model = [[WeiMiOrderProductModel alloc] init];
        model.proId = EncodeStringFromDic(dic, @"proId");
        model.productBrand = EncodeStringFromDic(dic, @"productBrand");
        model.price = EncodeStringFromDic(dic, @"price");
        model.productImg = EncodeStringFromDic(dic, @"productImg");
        model.number = EncodeStringFromDic(dic, @"number");
        model.property = EncodeStringFromDic(dic, @"property");
        model.productName = EncodeStringFromDic(dic, @"productName");
        model.orderId = EncodeStringFromDic(dic, @"orderId");
        model.productType = EncodeStringFromDic(dic, @"productType");
        model.proId = EncodeStringFromDic(dic, @"productId");
        [resultArr addObject:model];
    }
    return resultArr;
}

@end
