//
//  WeiMiAddCreditRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddCreditRequest : WeiMiBaseRequest
    
-(id)initWithMemberId:(NSString *)memberId baseId:(NSString *)baseId;
@end
