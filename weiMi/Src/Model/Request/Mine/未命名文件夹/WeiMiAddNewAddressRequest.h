//
//  WeiMiAddNewAddressRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddNewAddressRequestModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *street;//详细地址
@property (nonatomic, strong) NSString *memberId;


@property (nonatomic, strong) NSString *addressId;
@end

@interface WeiMiAddNewAddressRequest : WeiMiBaseRequest

-(id)initWithModel:(WeiMiAddNewAddressRequestModel *)model;

@end
