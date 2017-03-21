//
//  WeiMiAddMaleFemalePostRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddMaleFemalePostModel : NSObject

@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *dzscription;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *memberId;

@end
@interface WeiMiAddMaleFemalePostRequest : WeiMiBaseRequest

- (id)initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:(BOOL)isMale;

@end
