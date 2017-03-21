//
//  WeiMiCreditTaskResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditTaskResponse.h"

@implementation WeiMiCreditTaskResponse
    
- (instancetype)init
{
    if (self = [super init]) {
        _commonArr = [NSMutableArray new];
        _newbieArr = [NSMutableArray new];
    }
    return self;
}
    
-(void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        WeiMiCreditTaskDTO *dto = [[WeiMiCreditTaskDTO alloc] init];
        [dto encodeFromDictionary:di];
        if ([dto.baseType isEqualToString:@"1"]) {//新手任务
            [_newbieArr addObject:dto];
        }else if ([dto.baseType isEqualToString:@"2"])//日常任务
        {
            [_commonArr addObject:dto];
        }
    }
    
    [_newbieArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WeiMiCreditTaskDTO *dto_1 = obj1;
        WeiMiCreditTaskDTO *dto_2 = obj2;
        if (dto_1.baseId > dto_2.baseId) {
            return NSOrderedDescending;
        }else if (dto_1.baseId == dto_2.baseId) {
            return NSOrderedSame;
        }else if (dto_1.baseId < dto_2.baseId) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    [_commonArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WeiMiCreditTaskDTO *dto_1 = obj1;
        WeiMiCreditTaskDTO *dto_2 = obj2;
        if (dto_1.baseId > dto_2.baseId) {
            return NSOrderedDescending;
        }else if (dto_1.baseId == dto_2.baseId) {
            return NSOrderedSame;
        }else if (dto_1.baseId < dto_2.baseId) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
