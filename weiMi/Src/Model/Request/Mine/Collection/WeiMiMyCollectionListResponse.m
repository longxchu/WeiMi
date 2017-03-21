//
//  WeiMiMyCollectionListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCollectionListResponse.h"

@implementation WeiMiMyCollectionListResponse

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

-(void)parseResponse:(NSDictionary *)dic isGoods:(BOOL)isGoods
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        
        if (isGoods) {
            WeiMiGoodsDTO *dto = [[WeiMiGoodsDTO alloc] init];
            [dto encodeFromDictionary:di];
            [_dataArr addObject:dto];
        }else
        {
            WeiMiMFInvitationListDTO *dto = [[WeiMiMFInvitationListDTO alloc] init];
            [dto encodeFromDictionary:di];
            [_dataArr addObject:dto];
        }
        
    }
}

@end
