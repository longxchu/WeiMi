//
//  WeiMiCirclePostInvitationRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCirclePostInvitationRequest.h"

@implementation WeiMiCirclePostInvitationModel

@end

@implementation WeiMiCirclePostInvitationRequest
{
    WeiMiCirclePostInvitationModel *_model;
}


- (id)initWithModel:(WeiMiCirclePostInvitationModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Infor_add.html";
}


- (id)requestArgument {
    return @{
             @"infoTitle": _model.infoTitle ? _model.infoTitle : @"",
             @"description": _model.dzscription ? _model.dzscription : @"",
             @"imgPath":_model.imgPath ? _model.imgPath : @"",
             @"content":_model.content ? _model.content : @"",
             @"memberId":_model.memberId ? _model.memberId : @"",
             @"ringId":_model.ringId ? _model.ringId : @"",
             };
}

@end
