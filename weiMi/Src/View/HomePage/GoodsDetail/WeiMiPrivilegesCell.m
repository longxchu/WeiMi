//
//  WeiMiPrivilegesCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPrivilegesCell.h"

@interface WeiMiPrivilegesCell()

@property (nonatomic, strong) UILabel *topTagLB;//包邮Label
@property (nonatomic, strong) UILabel *bottomTagLB;//赠品Label

@property (nonatomic, strong) UILabel *topTitleLabel;
//@property (nonatomic, strong) UILabel *bottomTitleLabel;


@end

@implementation WeiMiPrivilegesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.topTagLB];
        [self addSubview:self.bottomTagLB];
        
        [self addSubview:self.topTitleLabel];
        [self addSubview:self.bottomTitleLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)topTagLB
{
    if (!_topTagLB) {
        
        _topTagLB = [[UILabel alloc] init];
        //        _tagLB.frame = CGRectMake(SCREEN_WIDTH - 13 -20, _segView.centerY, 25, 13);
        _topTagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _topTagLB.textAlignment = NSTextAlignmentCenter;
        _topTagLB.textColor = kWhiteColor;
        _topTagLB.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _topTagLB.text = @"包邮";
        [_topTagLB sizeToFit];
    }
    return _topTagLB;
}

- (UILabel *)bottomTagLB
{
    if (!_bottomTagLB) {
        
        _bottomTagLB = [[UILabel alloc] init];
        //        _tagLB.frame = CGRectMake(SCREEN_WIDTH - 13 -20, _segView.centerY, 25, 13);
        _bottomTagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _bottomTagLB.textAlignment = NSTextAlignmentCenter;
        _bottomTagLB.textColor = kWhiteColor;
        _bottomTagLB.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _bottomTagLB.text = @"赠品";
        [_bottomTagLB sizeToFit];

    }
    return _bottomTagLB;
}

- (UILabel *)topTitleLabel
{
    if (!_topTitleLabel) {
        
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _topTitleLabel.textAlignment = NSTextAlignmentLeft;
        _topTitleLabel.textColor = kGrayColor;
        _topTitleLabel.numberOfLines = 2;
        _topTitleLabel.text = @"单品包邮";
    }
    return _topTitleLabel;
}

- (UILabel *)bottomTitleLabel
{
    if (!_bottomTitleLabel) {
        
        _bottomTitleLabel = [[UILabel alloc] init];
        _bottomTitleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _bottomTitleLabel.textAlignment = NSTextAlignmentLeft;
        _bottomTitleLabel.textColor = kGrayColor;
        _bottomTitleLabel.numberOfLines = 1;
        _bottomTitleLabel.text = @"[买1送六][包邮]害得娜娜";
    }
    return _bottomTitleLabel;
}

- (void)updateConstraints
{
    [_topTagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(10);
        make.width.mas_equalTo(_topTagLB.mas_height).multipliedBy(2);

    }];
    
    [_bottomTagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(_bottomTagLB.mas_height).multipliedBy(2);
    }];
    
    [_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_topTagLB.mas_right).offset(10);
        make.top.mas_equalTo(_topTagLB);
        make.right.mas_equalTo(-10);
    }];
    
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bottomTagLB.mas_right).offset(10);
        make.top.mas_equalTo(_bottomTagLB);
        make.right.mas_equalTo(-10);
    }];
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
