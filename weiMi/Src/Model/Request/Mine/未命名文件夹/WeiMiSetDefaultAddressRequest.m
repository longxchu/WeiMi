//
//  WeiMiSetDefaultAddressRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSetDefaultAddressRequest.h"

@implementation WeiMiSetDefaultAddressRequest
{
    NSString *_phone;
    NSString *_addressId;
}

-(id)initWithMemberId:(NSString *)memberId addressId:(NSString *)addressId{
    self = [super init];
    if (self) {
        _phone = memberId;
        _addressId = addressId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_setAddress.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"addressId":_addressId,
             };
}

@end
