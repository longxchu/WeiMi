//
//  WeiMiPersonalCredit.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WMCreditModel : NSObject

@property (nonatomic, copy) NSString *personInfo, *pubInvi, *wbInvi, *goodInvi2, *commentInvi2, *pubInvi2, *wbInvi2, *evaGoods, *buyGoods;

- (id)shareModel;

@end

@interface WeiMiPersonalCreditRequest : WeiMiBaseRequest

-(id)initWithMemberId:(NSString *)memberId;

@end


