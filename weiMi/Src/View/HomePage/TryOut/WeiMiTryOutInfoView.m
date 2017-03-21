//
//  WeiMiTryOutInfoView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryOutInfoView.h"
@interface WeiMiTryOutInfoView()

@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftMidLabel;
@property (nonatomic, strong) UILabel *leftBotLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBottomLabel;

@end

@implementation WeiMiTryOutInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        [self addSubview:self.lineView];
        
        [self addSubview:self.leftTopLabel];
        [self addSubview:self.leftMidLabel];
        [self addSubview:self.leftBotLabel];
        
        [self addSubview:self.rightTopLabel];
        [self addSubview:self.rightBottomLabel];

        //        _label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithPrice:(NSString *)price applyNum:(NSString *)applyNum goodNum:(NSString *)goodNum status:(NSString *)status
{
    _leftTopLabel.attributedText = [self attrStrWithKey:@"价值: " value:price];
    _leftMidLabel.attributedText = [self attrStrWithKey:@"数量: " value:goodNum];
    _rightTopLabel.text = applyNum;
    _leftBotLabel.attributedText = [self attrStrWithKey:@"状态: " value:status];
}

#pragma mark - Getter
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =  [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UILabel *)leftTopLabel
{
    if (!_leftTopLabel) {
        
        _leftTopLabel = [[UILabel alloc] init];
        _leftTopLabel.font = WeiMiSystemFontWithpx(22);
        _leftTopLabel.textAlignment = NSTextAlignmentLeft;
        _leftTopLabel.textColor = kRedColor;
        _leftTopLabel.numberOfLines = 1;
        _leftTopLabel.attributedText = [self attrStrWithKey:@"价值: " value:@"299.00"];
    }
    return _leftTopLabel;
}

- (UILabel *)leftMidLabel
{
    if (!_leftMidLabel) {
        
        _leftMidLabel = [[UILabel alloc] init];
        _leftMidLabel.font = WeiMiSystemFontWithpx(22);
        _leftMidLabel.textAlignment = NSTextAlignmentLeft;
        _leftMidLabel.textColor = kRedColor;
        _leftMidLabel.numberOfLines = 1;
        _leftMidLabel.attributedText = [self attrStrWithKey:@"数量: " value:@"3"];

    }
    return _leftMidLabel;
}

- (UILabel *)leftBotLabel
{
    if (!_leftBotLabel) {
        
        _leftBotLabel = [[UILabel alloc] init];
        _leftBotLabel.font = WeiMiSystemFontWithpx(22);
        _leftBotLabel.textAlignment = NSTextAlignmentLeft;
        _leftBotLabel.textColor = kRedColor;
        _leftBotLabel.numberOfLines = 1;
        _leftBotLabel.attributedText = [self attrStrWithKey:@"状态: " value:@"申请中"];

    }
    return _leftBotLabel;
}

- (UILabel *)rightTopLabel
{
    if (!_rightTopLabel) {
        
        _rightTopLabel = [[UILabel alloc] init];
        _rightTopLabel.font = WeiMiSystemFontWithpx(28);
        _rightTopLabel.textAlignment = NSTextAlignmentCenter;
        _rightTopLabel.textColor = kRedColor;
        _rightTopLabel.text = @"3014";
        _rightTopLabel.numberOfLines = 1;
    }
    return _rightTopLabel;
}

- (UILabel *)rightBottomLabel
{
    if (!_rightBottomLabel) {
        
        _rightBottomLabel = [[UILabel alloc] init];
        _rightBottomLabel.font = WeiMiSystemFontWithpx(22);
        _rightBottomLabel.textAlignment = NSTextAlignmentCenter;
        _rightBottomLabel.textColor = [UIColor lightGrayColor];
        _rightBottomLabel.numberOfLines = 1;
        _rightBottomLabel.text = @"人已申请";
    }
    return _rightBottomLabel;
}

#pragma mark - utils
- (NSMutableAttributedString *)attrStrWithKey:(NSString*)key value:(NSString *)value
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:key attributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(22),
        NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:value attributes:@{
                            NSFontAttributeName:WeiMiSystemFontWithpx(22),
                        NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    return attString;
}

#pragma mark - layout
- (void)updateConstraints
{
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [@[_leftTopLabel, _leftMidLabel, _leftBotLabel] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:22 tailSpacing:22];
    
    [@[_leftTopLabel, _leftMidLabel, _leftBotLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_lineView);
    }];
    
    [@[_rightTopLabel, _rightBottomLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_lineView);
        make.right.mas_equalTo(self);
    }];
    
    [_rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.mas_centerY).offset(-5);
    }];
    
    [_rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_centerY).offset(5);
    }];
    [super updateConstraints];
    
}

@end
