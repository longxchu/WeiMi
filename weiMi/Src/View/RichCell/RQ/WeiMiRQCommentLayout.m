//
//  WeiMiRQCommentLayout.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQCommentLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"

@implementation WeiMiRQCommentLayout

- (id)initWithStatusModel:(WeiMiRQCommentModel *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
        avatarStorage.placeholder = WEIMI_IMAGENAMED(@"face");
        avatarStorage.contents = [NSURL URLWithString:statusModel.headImgPath];
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.backgroundColor = [UIColor whiteColor];
        avatarStorage.frame = CGRectMake(10, 10, 40, 40);
        avatarStorage.tag = 9;
        avatarStorage.cornerBorderWidth = 1.0f;
        avatarStorage.cornerBorderColor = HEX_RGB(BASE_COLOR_HEX);
        
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = statusModel.memberName;
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
        titleTextStorage.text = [NSString stringWithFormat:@"%@ %@", statusModel.title, statusModel.createTime];
        titleTextStorage.text = [NSString stringWithFormat:@"%@", statusModel.createTime];
        titleTextStorage.font = [UIFont fontWithName:@"Arial" size:13.0f];
        titleTextStorage.textColor = RGB(40, 40, 40, 1);
        titleTextStorage.frame = CGRectMake(nameTextStorage.left,
                                            nameTextStorage.bottom + 2,
                                            SCREEN_WIDTH - 20.0f,
                                             CGFLOAT_MAX);
        
    
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.maxNumberOfLines = 4;//设置最大行数，超过则折叠
        contentTextStorage.text = statusModel.disContent;
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
        
        [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
        [self addStorage:titleTextStorage];
        [self addStorage:contentTextStorage];
        [self addStorage:avatarStorage];
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
    }
    return self;
}
                                            


@end
