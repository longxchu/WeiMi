//
//  WeiMiCreditExchangeDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiCreditExchangeDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;//头像地址
@property (nonatomic, strong) NSString *title;//vouName
@property (nonatomic, strong) NSString *subTitle;//vouRemark
@property (nonatomic, strong) NSString *vouPrice;
@property (nonatomic, strong) NSString *vouTime;

@property (nonatomic, strong) NSString *vouStart;
@property (nonatomic, strong) NSString *vouType;
@property (nonatomic, strong) NSString *vouId;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *vouEnd;

@property (nonatomic, assign) BOOL timeOut;


@end
