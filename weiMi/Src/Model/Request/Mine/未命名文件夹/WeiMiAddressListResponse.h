//
//  WeiMiAddressListResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiRecAddDTO.h"

@interface WeiMiAddressListResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
