//
//  WeiMiCommentListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentListResponse.h"

@implementation WeiMiCommentListDiscussModel

- (instancetype)init
{
    if (self = [super init]) {
        _level = @"";
        _title = @"";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.dianzan = EncodeStringFromDic(dic, @"dianzan");
    self.disId = EncodeStringFromDic(dic, @"disId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
     self.disContent = EncodeStringFromDic(dic, @"disContent");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.infoId = EncodeStringFromDic(dic, @"infoId");
    self.headImgPath = WEIMI_IMAGEREMOTEURL([self responseImagePath:EncodeStringFromDic(dic, @"headImgPath")]);
    
}

- (NSString *)responseImagePath:(NSString *)str {
    
    NSString *string = str;
    if (string) {
        
        NSString *str = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        return str;
    }
    return nil;
}

@end

@interface WeiMiCommentListReplayModel()<NSCopying, NSMutableCopying>
    
@end

@implementation WeiMiCommentListReplayModel
    
/// 实现copy协议
- (id)copyWithZone:(NSZone *)zone
{
    WeiMiCommentListReplayModel *object = [[[self class] allocWithZone:zone] init];
    object.tomemberId = _tomemberId;
    object.createTime = _createTime;
    object.disId = _disId;
    object.memberId = _memberId;
    object.detId = _detId;
    object.memberName = _memberName;
    object.detContent = _detContent;
    object.index = _index;
    return object;
}
    
- (id)mutableCopyWithZone:(NSZone *)zone
{
    WeiMiCommentListReplayModel *object = [WeiMiCommentListReplayModel allocWithZone:zone] ;
    object.tomemberId = _tomemberId;
    object.createTime = _createTime;
    object.disId = _disId;
    object.memberId = _memberId;
    object.detId = _detId;
    object.memberName = _memberName;
    object.detContent = _detContent;
    object.index = _index;
    return object;
}


- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.tomemberId = EncodeStringFromDic(dic, @"tomemberId");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.disId = EncodeStringFromDic(dic, @"disId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.detId = EncodeStringFromDic(dic, @"detId");
    self.detContent = EncodeStringFromDic(dic, @"detContent");
}
@end

@implementation WeiMiCommentListDTO

- (instancetype)init
{
    if (self = [super init]) {
        
        self.commentArr = [NSMutableArray new];
        _model = [[WeiMiCommentListDiscussModel alloc] init];
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    NSDictionary *discussDic = EncodeDicFromDic(dic, @"discuss");
    [_model encodeFromDictionary:discussDic];
    
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"detailList")) {
        WeiMiCommentListReplayModel *dto = [[WeiMiCommentListReplayModel alloc] init];
        [dto encodeFromDictionary:di];
        [_commentArr addObject:dto];
    }
}

@end

@implementation WeiMiCommentListResponse

- (instancetype)init
{
    if (self = [super init]) {
        
        self.dataArr = [NSMutableArray new];
    }
    return self;
}

- (void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result"))
    {
        WeiMiCommentListDTO *dto = [[WeiMiCommentListDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}



@end
