//
//  HPWealListModel.m
//  weiMi
//
//  Created by zhaoke on 2016/12/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "HPWealListModel.h"

@implementation HPWealListModel

- (void)encodeFromDictionary:(NSDictionary *)dic {
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.aboutId = EncodeStringFromDic(dic, @"aboutId");
    self.aboutType = EncodeStringFromDic(dic, @"aboutType");
    self.aboutTitle = EncodeStringFromDic(dic, @"aboutTitle");
    self.aboutContext = EncodeStringFromDic(dic, @"aboutContext");
}

@end

@implementation HPMRtiyanModel

- (void)encodeFromDictionary:(NSDictionary *)dic {
    self.mrId = EncodeStringFromDic(dic, @"mrId");
    self.infoId = EncodeStringFromDic(dic, @"infoId");
    self.inforTitile = EncodeStringFromDic(dic, @"inforTitle");
    self.inforImg = EncodeStringFromDic(dic, @"inforImg");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
}

@end

@implementation HPWealListRequest

- (NSString *)requestUrl {
    return @"/about_fllist.html";
}

@end

@implementation HPMRtiyanRequest

- (NSString *)requestUrl {
    return @"/Infor_getMRtiyan.html";
}

@end

@implementation HPWealListResponse
- (instancetype)init {
    if(self = [super init]){
        _dataArr = [NSMutableArray new];
    }
    return self;
}
- (void)parseResponse:(NSDictionary *)dic {
    for (NSDictionary *temDic in EncodeArrayFromDic(dic, @"result")) {
        HPWealListModel *model = [[HPWealListModel alloc] init];
        [model encodeFromDictionary:temDic];
        [_dataArr addObject:model];
    }
}
@end

@implementation HPMRtiyanResponse

- (instancetype)init {
    if(self = [super init]){
        _dataArr = [NSMutableArray new];
    }
    return self;
}
- (void)parseResponse:(NSDictionary *)dic {
    for (NSDictionary *temDic in EncodeArrayFromDic(dic, @"result")) {
        HPMRtiyanModel *model = [[HPMRtiyanModel alloc] init];
        [model encodeFromDictionary:temDic];
        [_dataArr addObject:model];
    }
}

@end
