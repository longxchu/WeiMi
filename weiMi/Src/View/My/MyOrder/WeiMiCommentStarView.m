//
//  WeiMiCommentStarView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentStarView.h"

@interface WeiMiCommentStarView()
{
    NSMutableArray *_starArr;
    NSUInteger _currentTag;
}

@property (nonatomic, strong) UIButton *starBTNFac;

@end

@implementation WeiMiCommentStarView

- (instancetype)initWithFrame:(CGRect)frame startNum:(NSUInteger)num starNormalImg:(NSString *)normal selected:(NSString *)select
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _starArr = [NSMutableArray new];
        for (int i = 0; i < num; i ++) {
            
            UIButton *BTN = self.starBTNFac;
            [BTN setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
            [BTN setImage:[UIImage imageNamed:select] forState:UIControlStateSelected];
            BTN.tag = i;
            [self addSubview:BTN];
            [_starArr addObject:BTN];
        }
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame startNum:(NSUInteger)num
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _starArr = [NSMutableArray new];
        for (int i = 0; i < num; i ++) {
            
            UIButton *BTN = self.starBTNFac;
            BTN.tag = i;
            [self addSubview:BTN];
            [_starArr addObject:BTN];
        }
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setLightNum:(NSUInteger)num
{
    for (int i = 0; i < num; i ++) {
        
        
        UIButton *BTN = safeObjectAtIndex(_starArr, i);
        if (BTN) {
            BTN.selected = YES;
        }
    }
}

#pragma mark - Getter
- (UIButton *)starBTNFac
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_gray_fivestar"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_purple_fivestar"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    _currentTag = sender.tag;
    
    [_starArr enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _currentTag+1)] options:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = (UIButton *)obj;
        if (btn) {
            btn.selected = YES;
        }
    }];
    
    [_starArr enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_currentTag + 1, _starArr.count - _currentTag -1)] options:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (btn) {
            btn.selected = NO;
        }
    }];
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_starArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:25 leadSpacing:10 tailSpacing:10];
    [_starArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self);
    }];
    [super updateConstraints];
}

@end
