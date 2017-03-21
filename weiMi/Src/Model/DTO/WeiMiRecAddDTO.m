//
//  WeiMiRecAddDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRecAddDTO.h"

@implementation WeiMiRecAddDTO

- (instancetype)init
{
    if (self = [super init]) {
//        self.name = @"madaoCN";
//        self.add = @"上海，上海市，上海市普陀区金沙江路";
//        self.tel = @"13055424951";
//        self.province = @"上海";
//        self.city = @"上海市";
//        self.district = @"普陀区";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.isDefault = [EncodeStringFromDic(dic, @"isAble") isEqualToString:@"2"]? YES:NO;
    self.name = EncodeStringFromDic(dic, @"userName");
    self.tel = EncodeStringFromDic(dic, @"userPhone");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.province = EncodeStringFromDic(dic, @"province");
    self.city = EncodeStringFromDic(dic, @"city");
    self.county = EncodeStringFromDic(dic, @"county");
    self.street = EncodeStringFromDic(dic, @"street");
    self.addressId = EncodeStringFromDic(dic, @"addressId");
}


//@property (nonatomic, assign) BOOL isDefault;//是否是默认地址 isAble
//@property (nonatomic, strong) NSString *name;//userName
//@property (nonatomic, strong) NSString *add;
//@property (nonatomic, strong) NSString *tel;//userPhone
//@property (nonatomic, strong) NSString *memberId;//memberId
//@property (nonatomic, strong) NSString *province;//province
//@property (nonatomic, strong) NSString *city;//city
//@property (nonatomic, strong) NSString *county;//county
//@property (nonatomic, strong) NSString *addressId;//addressId
//@property (nonatomic, strong) NSString *street;//street

@end
