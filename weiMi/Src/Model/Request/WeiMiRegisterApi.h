//
//  WeiMiRegisterApi.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiRegisterApi : WeiMiBaseRequest

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
