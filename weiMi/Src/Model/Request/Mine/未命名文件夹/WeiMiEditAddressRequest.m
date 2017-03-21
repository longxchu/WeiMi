//
//  WeiMiEditAddressRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiEditAddressRequest.h"

@implementation WeiMiEditAddressRequest
{
    WeiMiAddNewAddressRequestModel *_model;
}

-(id)initWithModel:(WeiMiAddNewAddressRequestModel *)model{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_updateAddress.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"userName": _model.userName,
             @"userPhone": _model.userPhone,
             @"province": _model.province,
             @"city": _model.city,
             @"county": _model.county,
             @"street": _model.street,
             @"memberId": _model.memberId,
             @"addressId": _model.addressId,
             };
}

@end
