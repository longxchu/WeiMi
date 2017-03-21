//
//  WeiMiRecAddDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiRecAddDTO : WeiMiBaseDTO

@property (nonatomic, assign) BOOL isDefault;//是否是默认地址 isAble
@property (nonatomic, strong) NSString *name;//userName
@property (nonatomic, strong) NSString *add;
@property (nonatomic, strong) NSString *tel;//userPhone
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *province;//province
@property (nonatomic, strong) NSString *city;//city
@property (nonatomic, strong) NSString *county;//county
@property (nonatomic, strong) NSString *addressId;//addressId
@property (nonatomic, strong) NSString *street;//street


@property (nonatomic, strong) NSString *district;

@property (nonatomic, strong) NSString *postalcode;
@property (nonatomic, strong) NSString *detailAdd;

@end
