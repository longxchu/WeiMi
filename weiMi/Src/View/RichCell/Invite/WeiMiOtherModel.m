//
//  WeiMiOtherModel.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOtherModel.h"

@implementation WeiMiOtherModel

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        self.title = dict[@"title"];
        self.tag = dict[@"tag"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] floatValue]];
        self.imgs = dict[@"imgs"];
        self.commentNum = dict[@"commentNum"];
    }
    return self;
}

@end
