//
//  WeiMiCircleMouleCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiCircleCateListDTO.h"

typedef void (^OnCareBtnHandler) (UIButton *, NSString *);

@interface WeiMiCircleMouleCell : WeiMiBaseTableViewCell

- (void)setViewWithDTO:(WeiMiCircleCateListDTO *)dto;

@property (nonatomic, copy) OnCareBtnHandler onCareBtnHandler;


@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end


@interface WeiMiCircleInfoV : UIView

- (void)setViewWithDTO:(WeiMiCircleCateListDTO *)dto;

@property (nonatomic, copy) OnCareBtnHandler onCareBtnHandler;


@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end
