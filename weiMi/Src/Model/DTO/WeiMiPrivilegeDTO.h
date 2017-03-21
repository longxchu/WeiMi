//
//  WeiMiPrivilegeDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiPrivilegeDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *voucherTimeStart;//兑换时间
@property (nonatomic, strong) NSString *voucherStart;//消费最低限额
@property (nonatomic, strong) NSString *voucherEnd;//抵扣金额
@property (nonatomic, strong) NSString *vouImg;//封面图片
@property (nonatomic, strong) NSString * vouType;//vouType
@property (nonatomic, strong) NSString * vouTitle;//标题
@property (nonatomic, strong) NSString * voucherTimeEnd;//过期时间
@property (nonatomic, strong) NSString * memberId;//会员id
@property (nonatomic, strong) NSString * isAble;//1正常 2已使用
@property (nonatomic, strong) NSString * vouPrice;//兑换积分
@property (nonatomic, strong) NSString * voucherId;//voucherId

@property (nonatomic, assign) BOOL timeOut;

@end
