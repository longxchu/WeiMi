//
//  WeiMiProductDetailResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiProductDetailResponse.h"

@implementation WeiMiProductDetailResponse
- (instancetype)init
{
    if (self = [super init]) {
        
        _imageFiles = [NSArray new];
        _property = [NSArray new];
    }
    return self;
}

- (void)parseResponse:(NSDictionary *)dic
{
    NSDictionary *di = EncodeDicFromDic(dic, @"result");
    _dto = [[WeiMiHPProductListDTO alloc] init];
    [_dto encodeFromDictionary:di];
    
    //imageFiles
    if (_dto.imgfiles) {
        _imageFiles = [_dto.imgfiles splitBy:@"|"];
    }
    
    //property
    if (_dto.property) {
        _property = [_dto.property splitBy:@"|"];
    }
}

@end
