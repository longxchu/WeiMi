//
//  WeiMiMyCreditDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiMyCreditDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;//头像地址
@property (nonatomic, strong) NSString *title;//vouName
@property (nonatomic, strong) NSString *voucherId;
@property (nonatomic, strong) NSString *vouPrice;
@property (nonatomic, strong) NSString *voucherTimeStart;

@property (nonatomic, strong) NSString *voucherStart;
@property (nonatomic, strong) NSString *vouType;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *voucherEnd;

@end
