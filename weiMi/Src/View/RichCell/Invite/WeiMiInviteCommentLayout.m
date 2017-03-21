//
//  WeiMiInviteCommentLayout.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInviteCommentLayout.h"
#import "LWTextParser.h"
#import "CommentModel.h"
#import "Gallop.h"

@implementation WeiMiInviteCommentLayout

- (id)initWithStatusModel:(WeiMiCommentListDTO *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
        avatarStorage.placeholder = WEIMI_IMAGENAMED(@"face");
        avatarStorage.contents = [NSURL URLWithString:statusModel.model.headImgPath];
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.backgroundColor = [UIColor whiteColor];
        avatarStorage.frame = CGRectMake(10, 10, 40, 40);
        avatarStorage.tag = 9;
        avatarStorage.cornerBorderWidth = 1.0f;
        avatarStorage.cornerBorderColor = HEX_RGB(BASE_COLOR_HEX);
        
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = statusModel.model.memberName;
        nameTextStorage.font = [UIFont fontWithName:@"Arial" size:15.0f];
        nameTextStorage.frame = CGRectMake(avatarStorage.right + 10,
                                           10.0f,
                                           SCREEN_WIDTH - 80.0f,
                                           CGFLOAT_MAX);
        
//        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",statusModel.model.memberName]
//                                      range:NSMakeRange(0,statusModel.model.memberName.length)
//                                  linkColor:RGB(40, 40, 40, 1)
//                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        //标题模型 titleTextStorage
        LWTextStorage* titleTextStorage = [[LWTextStorage alloc] init];
//        titleTextStorage.text = [NSString stringWithFormat:@"%@ %@", statusModel.model.title, [dateFormatter stringFromDate:statusModel.date]];
        titleTextStorage.text = [NSString stringWithFormat:@"%@ %@", statusModel.model.title, statusModel.model.createTime];
        titleTextStorage.font = [UIFont fontWithName:@"Arial" size:13.0f];
        titleTextStorage.textColor = RGB(40, 40, 40, 1);
        titleTextStorage.frame = CGRectMake(nameTextStorage.left,
                                            nameTextStorage.bottom + 2,
                                            SCREEN_WIDTH - 20.0f,
                                            CGFLOAT_MAX);
        //标签模型 tagTextStorage
//        LWTextStorage* tagTextStorage = [[LWTextStorage alloc] init];
        NSMutableAttributedString *tagAttStr = [[NSMutableAttributedString alloc] initWithString:statusModel.model.level];
        [tagAttStr setFont:[UIFont fontWithName:@"Arial" size:15.0f] range:NSMakeRange(0, statusModel.model.level.length)];
        [tagAttStr setTextBackgroundColor:RGB(51, 206, 208, 1) range:NSMakeRange(0, statusModel.model.level.length)];
        [tagAttStr setTextColor:RGB(51, 206, 208, 1) range:NSMakeRange(0, statusModel.model.level.length)];
//        tagTextStorage.attributedText = tagAttStr;
//        tagTextStorage.font = [UIFont fontWithName:@"Arial" size:15.0f];
////        tagTextStorage.textColor = RGB(255, 255, 255, 1);
//        tagTextStorage.textColor = RGB(51, 206, 208, 1);
//        tagTextStorage.backgroundColor = RGB(51, 206, 208, 1);
//        tagTextStorage.frame = CGRectMake(nameTextStorage.right + 20,
//                                          nameTextStorage.top + 5,
//                                          25.0f,
//                                          CGFLOAT_MAX);
        LWTextStorage* tagTextStorage = [LWTextStorage lw_textStorageWithText:tagAttStr frame:CGRectMake(nameTextStorage.right + 20,
                       nameTextStorage.top+2,
                        25.0f,
                        CGFLOAT_MAX)];

        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.maxNumberOfLines = 4;//设置最大行数，超过则折叠
        contentTextStorage.text = statusModel.model.disContent;
        contentTextStorage.font = [UIFont fontWithName:@"Arial" size:15.0f];
        contentTextStorage.textColor = RGB(40, 40, 40, 1);
        contentTextStorage.frame = CGRectMake(10,
                                              titleTextStorage.bottom + 10.0f,
                                              SCREEN_WIDTH - 20.0f,
                                              CGFLOAT_MAX);
      
        //解析表情和主题
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
                                        linkColor:RGB(113, 129, 161, 1)
                                   highlightColor:RGB(0, 0, 0, 0.15)];
        
        //点击链接
        [contentTextStorage lw_addLinkForWholeTextStorageWithData:@"content"
                                                        linkColor:RGB(40, 40, 40, 1)
                                                   highLightColor:RGB(0, 0, 0, 0.15)];
        
        //生成评论背景Storage
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSArray* commentTextStorages = @[];
        CGRect commentBgPosition = CGRectZero;
        CGRect rect = CGRectMake(contentTextStorage.left,
                                 contentTextStorage.bottom + 5.0f,
                                 SCREEN_WIDTH - 20,
                                 20);
        
        CGFloat offsetY = 0.0f;
        
        if (statusModel.commentArr.count != 0 && statusModel.commentArr != nil) {
//            if (self.statusModel.likeList.count != 0) {
//                self.lineRect = CGRectMake(contentTextStorage.left,
//                                           offsetY + 2.5f,
//                                           SCREEN_WIDTH - 20,
//                                           0.1f);
//            }
            
            NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.commentArr.count];
            for (WeiMiCommentListReplayModel* commentModel in statusModel.commentArr) {
                NSString* to = commentModel.tomemberId;
                if (to.length != 0) {//某某回复某某形式
                    NSString* commentString = [NSString stringWithFormat:@"%@回复%@:%@",
                                               commentModel.memberName,
                                               commentModel.tomemberId,
                                               commentModel.detContent];
                    
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = [UIFont fontWithName:@"Arial" size:14.0f];
                    commentTextStorage.textColor = RGB(40, 40, 40, 1);
                    commentTextStorage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                          rect.origin.y + 10.0f + offsetY,
                                                          SCREEN_WIDTH - 35.0f,
                                                          CGFLOAT_MAX);
                    
                    CommentModel* commentModel1 = [[CommentModel alloc] init];
                    commentModel1.to = commentModel.memberName;
                    commentModel1.index = index;
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel
                                                                    linkColor:nil
                                                               highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [commentTextStorage lw_addLinkWithData:commentModel1
                                                     range:NSMakeRange(0,[(NSString *)commentModel.memberName length])
                                                 linkColor:RGB(113, 129, 161, 1)
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    CommentModel* commentModel2 = [[CommentModel alloc] init];
                    commentModel2.to = [NSString stringWithFormat:@"%@",commentModel.tomemberId];
                    commentModel2.index = index;
                    [commentTextStorage lw_addLinkWithData:commentModel2
                                                     range:NSMakeRange(commentModel.memberName.length + 2,
                                                                       commentModel.tomemberId.length)
                                                 linkColor:RGB(113, 129, 161, 1)
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:RGB(113, 129, 161, 1)
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height;
                } else {//回复某某形式
                    NSString* commentString = [NSString stringWithFormat:@"%@:%@",
                                               commentModel.memberName,
                                               commentModel.detContent];
                    
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = [UIFont fontWithName:@"Arial" size:14.0f];
                    commentTextStorage.textAlignment = NSTextAlignmentLeft;
                    commentTextStorage.linespacing = 2.0f;
                    commentTextStorage.textColor = RGB(40, 40, 40, 1);
                    commentTextStorage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                          rect.origin.y + 10.0f + offsetY,
                                                          SCREEN_WIDTH - 35.0f,
                                                          CGFLOAT_MAX);
                    
                    CommentModel* commentModel1 = [[CommentModel alloc] init];
                    commentModel1.to = commentModel.memberName;
                    commentModel1.index = index;
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel
                                                                    linkColor:nil
                                                               highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [commentTextStorage lw_addLinkWithData:commentModel
                                                     range:NSMakeRange(0,commentModel.memberName.length)
                                                 linkColor:RGB(113, 129, 161, 1)
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:RGB(113, 129, 161, 1)
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height;
                }
            }
            //如果有评论，设置评论背景Storage
            commentTextStorages = tmp;
            commentBgPosition = CGRectMake(10.0f,
                                           contentTextStorage.bottom + 5.0f,
                                           SCREEN_WIDTH - 20,
                                           offsetY + 15.0f);
            
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40
                                                  topCapHeight:15];
        }
        
        
        [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
        [self addStorage:tagTextStorage];
        [self addStorage:titleTextStorage];
        [self addStorage:contentTextStorage];
        [self addStorages:commentTextStorages];//通过一个数组来添加storage，使用这个方法
        [self addStorage:avatarStorage];
        [self addStorage:commentBgStorage];
        
//        self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
        //        self.menuPosition = menuPosition;//右下角菜单按钮的位置
//        self.commentBgPosition = commentBgPosition;//评论灰色背景位置
//        self.imagePostions = imagePositionArray;//保存图片位置的数组
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        self.tagRect = tagTextStorage.frame;
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
    }
    return self;
}


@end
