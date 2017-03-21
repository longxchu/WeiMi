//
//  WeiMiNewestActListResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/25.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiNewestActDTO.h"

@interface WeiMiNewestActListResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
