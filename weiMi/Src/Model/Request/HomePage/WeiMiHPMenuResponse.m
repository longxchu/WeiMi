//
//  WeiMiHPMenuResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPMenuResponse.h"

@implementation WeiMiHPMenuResponse

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

-(void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        WeiMiHPMenuDTO *dto = [[WeiMiHPMenuDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
    
    [_dataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WeiMiHPMenuDTO *dto_1 = obj1;
        WeiMiHPMenuDTO *dto_2 = obj2;
        if (dto_1.menuSort > dto_2.menuSort) {
            return NSOrderedDescending;
        }else if (dto_1.menuSort == dto_2.menuSort) {
            return NSOrderedSame;
        }else if (dto_1.menuSort < dto_2.menuSort) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
