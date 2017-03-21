//
//  WeiMiCirclePostInvitationRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCirclePostInvitationModel : NSObject

@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *dzscription;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *ringId;

@end

@interface WeiMiCirclePostInvitationRequest : WeiMiBaseRequest

- (id)initWithModel:(WeiMiCirclePostInvitationModel *)model;

@end
