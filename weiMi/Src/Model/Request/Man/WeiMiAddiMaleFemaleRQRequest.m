//
//  WeiMAddiMaleFemaleRQRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddMaleFemaleRQRequest.h"
@implementation WeiMiAddMaleFemaleRQModel
@end


@implementation WeiMiAddMaleFemaleRQRequest
{
    WeiMiAddMaleFemaleRQModel *_model;
    BOOL _isMale;
}


- (id)initWithModel:(WeiMiAddMaleFemaleRQModel *)model isMale:(BOOL)isMale;
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
        return @"/Qt_addnan.html";
    }
    return @"/Qt_addnv.html";
}


- (id)requestArgument {
    return @{
             @"qtTitle": _model.qtTitle ? _model.qtTitle : @"",
             @"qtContent": _model.qtContent ? _model.qtContent : @"",
             @"memberId":_model.memberId ? _model.memberId : @"",
             @"niming":_model.niming ? _model.niming : @"",
             };
}

@end