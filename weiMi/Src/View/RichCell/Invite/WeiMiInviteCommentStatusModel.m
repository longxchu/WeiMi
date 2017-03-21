//
//  WeiMiInviteCommentStatusModel.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInviteCommentStatusModel.h"

@implementation WeiMiInviteCommentStatusModel

//@property (nullable, nonatomic, copy) NSString* type;//评论类型
//@property (nullable, nonatomic, strong) NSURL* avatar;//头像 headImgPath
//@property (nullable, nonatomic, copy) NSString* name;//姓名 memberName
//@property (nullable, nonatomic, strong) NSString* floor;//楼层
//@property (nullable, nonatomic, strong) NSDate* date;//日期 createTime
//@property (nullable, nonatomic, strong) NSString* level;//等级
//@property (nullable, nonatomic, copy) NSString* content;//评论内容 disContent
//
//@property (nullable, nonatomic, copy) NSArray* likeNum;//点赞数 dianzan
//@property (nonatomic,assign) BOOL isLike;//是否点赞
//
//@property (nullable, nonatomic, copy) NSArray* commentList;//评论列表
//
//@property (nullable, nonatomic, strong) NSString* disId;
//@property (nullable, nonatomic, strong) NSString* isAble;
//@property (nullable, nonatomic, strong) NSString* memberId;
//@property (nullable, nonatomic, strong) NSString* infoId;
- (instancetype)init
{
    if (self = [super init]) {
        _commentList = [NSMutableArray new];
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    NSDictionary *discuss = EncodeDicFromDic(dic, @"discuss");
    self.avatar = EncodeStringFromDic(discuss,@"headImgPath");
    self.name = EncodeStringFromDic(discuss,@"memberName");
    self.date = EncodeStringFromDic(discuss,@"createTime");
    self.content = EncodeStringFromDic(discuss,@"disContent");
    self.likeNum = EncodeStringFromDic(discuss,@"dianzan");
    
    self.disId = EncodeStringFromDic(discuss,@"disId");
    self.isAble = EncodeStringFromDic(discuss,@"isAble");
    self.memberId = EncodeStringFromDic(discuss,@"memberId");
    self.infoId = EncodeStringFromDic(discuss,@"infoId");
    
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"detailList")) {
        CommentModel *model = [[CommentModel alloc] init];
        [model encodeFromDictionary:di];
        [_commentList addObject:model];
    }
    
}

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        self.avatar = [NSURL URLWithString:dict[@"avatar"]];
        self.name = dict[@"name"];
        
        self.floor = dict[@"floor"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] floatValue]];
        self.level = dict[@"level"];
        self.content = dict[@"content"];
//        self.detail = dict[@"detail"];
//        self.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] floatValue]];
//        self.imgs = dict[@"imgs"];

//        self.statusID = dict[@"statusID"];
        self.commentList = dict[@"commentList"];
        self.likeNum = dict[@"likeList"];
        self.isLike = [dict[@"isLike"] boolValue];
    }
    return self;
}


@end
