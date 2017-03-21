//
//  WeiMiMyHPItemsCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyHPItemsCell.h"
#import "UIColor+WeiMiUIColor.h"
#import <Masonry.h>
#import "UIButton+CenterImageAndTitle.h"

#define TEXT_COLOR          (0x302F2F)
#define LINE_COLOR          (0xB5B5B5)

@interface WeiMiMyHPItemsCell()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *midBUtton;
@property (nonatomic, strong) UIButton *rightBUtton;

@end

@implementation WeiMiMyHPItemsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.midBUtton];
        [self.contentView addSubview:self.rightBUtton];
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"我的等级" forState:UIControlStateNormal];
        [_leftButton setTitleColor:HEX_RGB(TEXT_COLOR) forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        [_leftButton setImage:[UIImage imageNamed:@"icon_huiyuan"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"icon_huiyuan"] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)midBUtton
{
    if (!_midBUtton) {
        _midBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_midBUtton setTitle:@"我的帖子" forState:UIControlStateNormal];
        [_midBUtton setTitleColor:HEX_RGB(TEXT_COLOR) forState:UIControlStateNormal];
        _midBUtton.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        [_midBUtton setImage:[UIImage imageNamed:@"icon_tiezi"] forState:UIControlStateNormal];
        [_midBUtton setImage:[UIImage imageNamed:@"icon_tiezi"] forState:UIControlStateHighlighted];
        [_midBUtton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _midBUtton;
}

- (UIButton *)rightBUtton
{
    if (!_rightBUtton) {
        _rightBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBUtton setTitle:@"我的积分" forState:UIControlStateNormal];
        [_rightBUtton setTitleColor:HEX_RGB(TEXT_COLOR) forState:UIControlStateNormal];
        _rightBUtton.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        [_rightBUtton setImage:[UIImage imageNamed:@"icon_jifen"] forState:UIControlStateNormal];
        [_rightBUtton setImage:[UIImage imageNamed:@"icon_jifen"] forState:UIControlStateHighlighted];
        [_rightBUtton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBUtton;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(cell:didSelectedAtIndex:)]) {
        WS(weakSelf);
        if (button == self.leftButton) {
            [self.delegate cell:weakSelf didSelectedAtIndex:0];
        }else if (button == self.midBUtton)
        {
            [self.delegate cell:weakSelf didSelectedAtIndex:1];
        }else if (button == self.rightBUtton)
        {
            [self.delegate cell:weakSelf didSelectedAtIndex:2];
        }
    }
}

#pragma mark - Util

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftButton verticalCenterImageAndTitle];
    [self.midBUtton verticalCenterImageAndTitle];
    [self.rightBUtton verticalCenterImageAndTitle];
}

- (void)updateConstraints
{
    [@[_leftButton, _midBUtton, _rightBUtton] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    //    [@[_leftButton, _midBUtton, _rightBUtton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:self.width/3 - 60 leadSpacing:30 tailSpacing:30];
    [@[_leftButton, _midBUtton, _rightBUtton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat LineHeight = 1.0f;
    CGFloat LineOffSet = 12.0f;
    CGPoint startLeft = CGPointMake(self.leftButton.right + (self.midBUtton.left - self.leftButton.right)/2, LineOffSet);
    CGPoint endLeft = CGPointMake(startLeft.x, self.height - LineOffSet);
    CGPoint startRight = CGPointMake(self.midBUtton.right + (self.rightBUtton.left - self.midBUtton.right)/2, LineOffSet);
    CGPoint endRight = CGPointMake(startRight.x, self.height - LineOffSet);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, startLeft.x, startLeft.y);
    CGContextAddLineToPoint(context, endLeft.x, endLeft.y);
    //设置颜色和线条宽度
    CGContextSetLineWidth(context, LineHeight);
    CGContextSetStrokeColorWithColor(context, HEX_RGB(LINE_COLOR).CGColor);
    //渲染
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    CGContextMoveToPoint(context, startRight.x, startRight.y);
    CGContextAddLineToPoint(context, endRight.x, endRight.y);
    //设置颜色和线条宽度
    CGContextSetLineWidth(context, LineHeight);
    CGContextSetStrokeColorWithColor(context, HEX_RGB(LINE_COLOR).CGColor);
    //渲染
    CGContextStrokePath(context);
}


@end
