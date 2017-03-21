//
//  WeiMiCircleLayout.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleLayout.h"
#import "Gallop.h"
#import "LWTextParser.h"
#define AVATAR_IDENTIFIER @"avatar"

@implementation WeiMiCircleLayout

- (id)initWithStatusModel:(WeiMiHotCommandDTO *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];

        avatarStorage.placeholder = WEIMI_IMAGENAMED(@"face");
        avatarStorage.contents = [NSURL URLWithString:WEIMI_IMAGEREMOTEURL(statusModel.headImgPath)];
        NSLog(@"____________%@",WEIMI_IMAGEREMOTEURL(statusModel.headImgPath));
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.backgroundColor = [UIColor whiteColor];
        avatarStorage.frame = CGRectMake(10, 10, 30, 30);
        avatarStorage.tag = 9;
        avatarStorage.cornerBorderWidth = 1.0f;
        avatarStorage.cornerBorderColor = [UIColor blackColor];
        
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = statusModel.memberName ? statusModel.memberName : @"用户";
        nameTextStorage.font = [UIFont fontWithName:@"Arial" size:15.0f];
        nameTextStorage.frame = CGRectMake(50.0f,
                                           20.0f,
                                           SCREEN_WIDTH - 80.0f,
                                           CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",statusModel.memberName]
                                      range:NSMakeRange(0,statusModel.memberName.length)
                                  linkColor:RGB(245, 45, 55, 1)
                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        //性别模型 sexTextStorage
        LWTextStorage* sexTextStorage = [[LWTextStorage alloc] init];
        sexTextStorage.text = statusModel.sex;
        sexTextStorage.font = [UIFont fontWithName:@"Arial" size:15.0f];
        sexTextStorage.frame = CGRectMake(nameTextStorage.right +10,
                                          20.0f,
                                          SCREEN_WIDTH - 80.0f,
                                          CGFLOAT_MAX);
        
        //标题模型 titleTextStorage
        LWTextStorage* titleTextStorage = [[LWTextStorage alloc] init];
        titleTextStorage.text = statusModel.infoTitle;
        titleTextStorage.font = [UIFont fontWithName:@"Arial" size:17.0f];
        titleTextStorage.textColor = RGB(40, 40, 40, 1);
        titleTextStorage.frame = CGRectMake(nameTextStorage.left,
                                            nameTextStorage.bottom + 10.0f,
                                            SCREEN_WIDTH - 50.0f,
                                            CGFLOAT_MAX);
        //标签模型 tagTextStorage
        LWTextStorage* tagTextStorage = [[LWTextStorage alloc] init];
        tagTextStorage.text = statusModel.isAble == 2 ? @"精" : @"";
        tagTextStorage.font = [UIFont fontWithName:@"Arial" size:17.0f];
        
        if (statusModel.isAble == 2) {//精华
            tagTextStorage.textColor = RGB(243, 175, 0, 1);
            //        tagTextStorage.cornerRadius = 3.0f;
        }else//普通帖子
        {
            tagTextStorage.textColor = RGB(117, 217, 162, 1);
        }
        tagTextStorage.frame = CGRectMake(avatarStorage.right - 15 - 10,
                                          titleTextStorage.top,
                                          20.0f,
                                          CGFLOAT_MAX);
        
        
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = safeObjectAtIndex([statusModel.createTime splitBy:@" "], 0) ;
//        dateTextStorage.text = [dateFormatter stringFromDate:statusModel.createTime];
        dateTextStorage.font = [UIFont fontWithName:@"Arial" size:13.0f];
        dateTextStorage.textColor = [UIColor grayColor];
        dateTextStorage.frame = CGRectMake(avatarStorage.left,
                                           titleTextStorage.bottom + 10.0f,
                                           SCREEN_WIDTH - 80.0f,
                                           CGFLOAT_MAX);
        
        
        [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
        [self addStorage:sexTextStorage];
        [self addStorage:tagTextStorage];
        [self addStorage:titleTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorage:avatarStorage];
        
        self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
        //        self.menuPosition = menuPosition;//右下角菜单按钮的位置
        self.dateRect = dateTextStorage.frame;//时间的位置
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
    }
    return self;
}


@end
