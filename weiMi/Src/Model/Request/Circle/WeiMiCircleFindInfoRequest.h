//
//  WeiMiCircleFindInfoRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/12/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCircleFindInfoRequest : WeiMiBaseRequest
@property (nonatomic, assign) BOOL isFromMRtiyan;

-(id)initWithMemberId:(NSString *)infoId;

@end
