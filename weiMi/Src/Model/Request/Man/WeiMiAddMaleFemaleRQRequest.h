//
//  WeiMAddiMaleFemaleRQRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddMaleFemaleRQModel : NSObject

@property (nonatomic, strong) NSString *qtTitle;
@property (nonatomic, strong) NSString *qtContent;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, assign) NSString *niming;

@end

@interface WeiMiAddMaleFemaleRQRequest : WeiMiBaseRequest

- (id)initWithModel:(WeiMiAddMaleFemaleRQModel *)model isMale:(BOOL)isMale;

@end
