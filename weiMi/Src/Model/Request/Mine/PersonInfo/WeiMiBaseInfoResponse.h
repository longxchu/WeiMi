//
//  WeiMiBaseInfoResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"


@interface WeiMiBaseInfoResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSString *aboutContext;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *aboutTitle;
@property (nonatomic, strong) NSString *aboutId;
@property (nonatomic, strong) NSString *aboutType;

@end
