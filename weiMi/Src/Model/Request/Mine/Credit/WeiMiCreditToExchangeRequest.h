//
//  WeiMiCreditToExchangeRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCreditToExchangeRequest : WeiMiBaseRequest

-(id)initWithMemberId:(NSString *)memberId vouId:(NSString *)vouId;
@end
