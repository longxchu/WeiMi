//
//  WeiMiDeleteAdressRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiDeleteAdressRequest.h"

@implementation WeiMiDeleteAdressRequest
{
    NSString *_addressId;
}

-(id)initWithAddressId:(NSString *)addressId{
    self = [super init];
    if (self) {
        _addressId = addressId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_delAdddress.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"addressId":_addressId,
             };
}

@end
