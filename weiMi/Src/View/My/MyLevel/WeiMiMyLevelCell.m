//
//  WeiMiMyLevelCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyLevelCell.h"
#import <UIButton+WebCache.h>

@interface WeiMiMyLevelCell()

@property (nonatomic, strong) UIView *bgView;

//@property (nonatomic, strong) UIButton *headerBTN;
//@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) UIButton *rightTopButton;


@end

@implementation WeiMiMyLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.headerBTN];
        [self.bgView addSubview:self.nameLB];
        [self.bgView addSubview:self.tagLB];
        [self.bgView addSubview:self.rightTopButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UIButton *)headerBTN
{
    if (!_headerBTN) {
        _headerBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_headerBTN setTitle:@"一激动就乱射" forState:UIControlStateNormal];
        [_headerBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _headerBTN.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_headerBTN sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        _headerBTN.layer.masksToBounds = YES;
        _headerBTN.layer.cornerRadius = _headerBTN.width/2;
        //        [_headerBTN verticalCenterImageAndTitle:10];
    }
    return _headerBTN;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(23)];
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.textColor = HEX_RGB(0x53E2F9);
        _nameLB.text = @"一激动就乱she";
        [_nameLB sizeToFit];
    }
    return _nameLB;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.textColor = kGrayColor;
//        _tagLB.backgroundColor = HEX_RGB(0x53E2F9);
        _tagLB.text = @"距离下一等级还差20经验";
    }
    return _tagLB;
}

- (UIButton *)rightTopButton
{
    if (!_rightTopButton) {
        _rightTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightTopButton sizeToFit];
        _rightTopButton.titleLabel.font = WeiMiSystemFontWithpx(19);
//        [_rightTopButton setTitle:@"等级说明" forState:UIControlStateNormal];
        [_rightTopButton setTitleColor:HEX_RGB(0x53E2F9) forState:UIControlStateNormal];
        [_rightTopButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopButton;
}


#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    OnLevelIntroBTNHandler block = self.onLevelIntroBTNHandler;
    if (block) {
        block();
    }
}

#pragma mark - Constraints
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerBTN.layer.cornerRadius = _headerBTN.width/2;
}

- (void)updateConstraints
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [_headerBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bgView);
        make.centerY.mas_equalTo(self.bgView).multipliedBy(0.5);
        make.height.mas_equalTo(self.bgView).multipliedBy(0.35);
        make.width.mas_equalTo(_headerBTN.mas_height);
    }];
    
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_headerBTN);
        make.top.mas_equalTo(_headerBTN.mas_bottom).offset(15);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_headerBTN);
        make.top.mas_equalTo(_nameLB.mas_bottom).offset(15);
    }];
    
    [_rightTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-5);
    }];
    [super updateConstraints];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
