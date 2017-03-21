//
//  WeiMiWannaTitleCell.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWannaTitleCell.h"

@interface WeiMiWannaTitleCell()
{
    NSString *_tId;
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation WeiMiWannaTitleCell

+ (CGFloat)getHeight
{
    return 42;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moreButton];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithTitle:(NSString *)title tId:(NSString *)tId
{
    _tId = tId;
    self.titleLabel.text = title;
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"娘子莫走";
    }
    return _titleLabel;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_black"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        //        [_moreButton sizeToFit];
    }
    return _moreButton;
}

#pragma mark - Actions
- (void)onButton:(id)sender
{
    WannaTitleCellMoreBtn block = self.wannaTitleCellMoreBtn;
    if (block) {
        block(_tId, self.titleLabel.text);
    }
}

- (void)updateConstraints
{
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [super updateConstraints];
}

@end
