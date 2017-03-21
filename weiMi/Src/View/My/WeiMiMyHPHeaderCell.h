//
//  WeiMiMyHPHeaderCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiUserInfoDTO.h"

typedef NS_ENUM(NSInteger, HEADERBUTTONTYPE) {
    HEADERBUTTONTYPE_LOGIN,
    HEADERBUTTONTYPE_REGISTER,
};

typedef void (^OnClickButtonHandler) (HEADERBUTTONTYPE);

@interface WeiMiMyHPHeaderCell : WeiMiBaseTableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexualLabel;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) OnClickButtonHandler onClickButtonHandler;

- (void)setViewWithDTO:(WeiMiUserInfoDTO *)dto;

@end
