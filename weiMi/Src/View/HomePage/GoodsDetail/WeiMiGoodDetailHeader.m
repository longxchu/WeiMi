//
//  WeiMiGoodDetailHeader.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodDetailHeader.h"
#import "WeiMiCommentStarView.h"

@interface WeiMiGoodDetailHeader()

@property (nonatomic, strong) UILabel *commentLB;
@property (nonatomic, strong) UILabel *creditLB;

@property (nonatomic, strong) WeiMiCommentStarView *starView;

@end

@implementation WeiMiGoodDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.starView];
        [self addSubview:self.commentLB];
        [self addSubview:self.creditLB];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}


#pragma mark - Getter
- (WeiMiCommentStarView *)starView
{
    if (!_starView) {
        _starView = [[WeiMiCommentStarView alloc] initWithFrame:CGRectZero startNum:5];
        [_starView setLightNum:5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (UILabel *)commentLB
{
    if (!_commentLB) {
        
        _commentLB = [[UILabel alloc] init];
        _commentLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        [_commentLB sizeToFit];
        _commentLB.textAlignment = NSTextAlignmentLeft;
        _commentLB.text = @"用户评价(54人)";
        _commentLB.textColor = kGrayColor;
    }
    return _commentLB;
}

- (UILabel *)creditLB
{
    if (!_creditLB) {
        
        _creditLB = [[UILabel alloc] init];
        _creditLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        [_creditLB sizeToFit];
        _creditLB.textAlignment = NSTextAlignmentLeft;
        _creditLB.text = @"综合评分：4.9";
        _creditLB.textColor = kGrayColor;
    }
    return _creditLB;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [@[_commentLB, _creditLB] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [@[_commentLB, _creditLB] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
    }];
    [super updateConstraints];
}

@end
