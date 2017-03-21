//
//  WeiMiCircleFindInfoRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleFindInfoRequest.h"

@implementation WeiMiCircleFindInfoRequest
{
    NSString *_infoId;
}

-(id)initWithMemberId:(NSString *)infoId {
    self = [super init];
    if (self) {
        
        _infoId = infoId;
    }
    return self;
}

- (NSString *)requestUrl {
    if(_isFromMRtiyan){
        return @"/Infor_findInfor.html";
    }
    return @"/Ring_addShou.html";
}


- (id)requestArgument {
    
    return @{
             @"infoId":_infoId ? _infoId:@"",
             };
}
@end
