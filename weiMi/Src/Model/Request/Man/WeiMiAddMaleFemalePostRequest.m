//
//  WeiMiAddMaleFemalePostRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddMaleFemalePostRequest.h"

@implementation WeiMiAddMaleFemalePostModel
@end

@implementation WeiMiAddMaleFemalePostRequest
{
    WeiMiAddMaleFemalePostModel *_model;
    BOOL _isMale;
}


- (id)initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:(BOOL)isMale;
{
    self = [super init];
    if (self) {
        _model = model;
        _isMale = isMale;
    }
    return self;
}

- (NSString *)requestUrl {
    if (_isMale) {
        return @"/Infor_addnan.html";
    }
    return @"/Infor_addnv.html";
}


- (id)requestArgument {
    return @{
             @"infoTitle": _model.infoTitle ? _model.infoTitle : @"",
             @"description": _model.dzscription ? _model.dzscription : @"",
             @"imgPath":_model.imgPath ? _model.imgPath : @"",
             @"content":_model.content ? _model.content : @"",
             @"memberId":_model.memberId ? _model.memberId : @"",
             };
}
@end
