//
//  WeiMiInviteCommentStatusModel.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

@interface WeiMiInviteCommentStatusModel : WeiMiBaseDTO


@property (nullable, nonatomic, strong) NSString* type;//评论类型
@property (nullable, nonatomic, strong) NSString* avatar;//头像 headImgPath
@property (nullable, nonatomic, strong) NSString* name;//姓名 memberName
@property (nullable, nonatomic, strong) NSString* floor;//楼层
//@property (nullable, nonatomic, strong) NSDate* date;//日期 createTime
@property (nullable, nonatomic, strong) NSString* date;//日期 createTime

@property (nullable, nonatomic, strong) NSString* level;//等级
@property (nullable, nonatomic, copy) NSString* content;//评论内容 disContent

@property (nullable, nonatomic, strong) NSString* likeNum;//点赞数 dianzan
@property (nonatomic,assign) BOOL isLike;//是否点赞

@property (nullable, nonatomic, strong) NSMutableArray* commentList;//评论列表

@property (nullable, nonatomic, strong) NSString* disId;
@property (nullable, nonatomic, strong) NSString* isAble;
@property (nullable, nonatomic, strong) NSString* memberId;
@property (nullable, nonatomic, strong) NSString* infoId;



- (WeiMiInviteCommentStatusModel *)initWithDict:(NSDictionary *)dict;

@end
