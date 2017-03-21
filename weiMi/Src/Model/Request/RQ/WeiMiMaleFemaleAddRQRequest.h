//
//  WeiMiMaleFemaleAddRQRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"
#import "WeiMiMaleFemaleAddRQModel.h"

@interface WeiMiMaleFemaleAddRQRequest : WeiMiBaseRequest

- (id)initWithModel:(WeiMiMaleFemaleAddRQModel *)model isMale:(BOOL)isMale;


@end
