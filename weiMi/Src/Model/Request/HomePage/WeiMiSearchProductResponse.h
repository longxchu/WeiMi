//
//  WeiMiSearchProductResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2017/1/8.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiHPProductListDTO.h"

@interface WeiMiSearchProductResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray<WeiMiHPProductListDTO *> *dataArr;

@end
