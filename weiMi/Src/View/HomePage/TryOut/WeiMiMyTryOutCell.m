//
//  WeiMiMyTryOutCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyTryOutCell.h"
#import <UIImageView+WebCache.h>
#import <OHAttributedStringAdditions.h>
#import "UIImage+WeiMiUIImage.h"
@interface WeiMiMyTryOutCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation WeiMiMyTryOutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiMyTryOutDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
    _detailLabel.text = dto.title;
     _subTitleLabel.attributedText = [self attrStrWithApplyNum:dto.applyNum date:dto.deadDate status:dto.status];
}


#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
         [_cellImageView sd_setImageWithURL:[NSURL URLWithString:@"www"] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
        
    }
    return _cellImageView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = WeiMiSystemFontWithpx(22);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _detailLabel.numberOfLines = 2;
        _detailLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.attributedText = [self attrStrWithApplyNum:2013 date:@"8月10日" status:@"申请成功"];
    }
    return _subTitleLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)attrStrWithApplyNum:(NSUInteger)applyNum date:(NSString *)date status:(NSString *)stat
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"申请人数: %ld\n预计将于%@公布名单\n状态: ", applyNum, date]];
    
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:stat attributes:@{
                                        NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    return attString;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(10);
        make.height.mas_equalTo(self).multipliedBy(0.64);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_detailLabel.mas_bottom);
        make.left.right.mas_equalTo(_detailLabel);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
}


@end
