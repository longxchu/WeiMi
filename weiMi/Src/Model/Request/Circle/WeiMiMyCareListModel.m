//
//  WeiMiMyCareListModel.m
//  weiMi
//
//  Created by zhaoke on 2016/12/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCareListModel.h"


@implementation WeiMiMyCareListReqeust {
    NSString *_memberId;
    NSString *_index;
    NSString *_size;
}

- (id)initWithMemberId:(NSString *)memberId pageIndex:(NSString *)index pageSize:(NSString *)size {
    self = [super init];
    if(self){
        _memberId = memberId;
        _index = index;
        _size = size;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/Ring_collectlist.html";
}
- (id)requestArgument {
    return @{@"memberId":_memberId,@"pageIndex":_index,@"pageSize":_size};
}
@end

@implementation WeiMiMyCareListResponse

- (instancetype)init {
    if(self = [super init]){
        _dataArr = [NSMutableArray new];
    }
    return self;
}
-(void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        WeiMiCircleCateListDTO *dto = [[WeiMiCircleCateListDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end

@implementation WeiMiMyCareListModel

- (void)encodeFromDictionary:(NSDictionary *)dic {
    self.ringId = EncodeStringFromDic(dic, @"ringId");
    self.ringTitle = EncodeStringFromDic(dic, @"ringTitle");
    self.ringIcon = EncodeStringFromDic(dic, @"ringIcon");
    self.myDescription = EncodeStringFromDic(dic, @"description");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.typeId = EncodeStringFromDic(dic, @"typeId");
}

@end
