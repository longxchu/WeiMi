//
//  WeiMiRQDetailRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailRequest.h"

@implementation WeiMiRQDetailRequest

{
    NSString *_qtId;

}

-(id)initWithQtId:(NSString *)qtId
{
    self = [super init];
    if (self) {
        _qtId = qtId;

    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Qt_findQt.html";
}


- (id)requestArgument {

    return @{
             @"qtId":_qtId,
             };
}

@end
