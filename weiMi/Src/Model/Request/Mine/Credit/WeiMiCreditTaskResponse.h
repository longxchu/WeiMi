//
//  WeiMiCreditTaskResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiCreditTaskDTO.h"


@interface WeiMiCreditTaskResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *commonArr;
@property (nonatomic, strong) NSMutableArray *newbieArr;
@end
