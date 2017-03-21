//
//  WeiMiCommentInputView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentInputView.h"
#import "UISwitch+CustomColor.h"

@interface WeiMiCommentInputView()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
}

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) UIButton *picBTN;
@property (nonatomic, strong) UIButton *faceBTN;

@end

@implementation WeiMiCommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topLineView];
        [self addSubview:self.lineView];
        [self addSubview:self.tagLB];
        [self addSubview:self.mySwitch];
        [self addSubview:self.picBTN];
        [self addSubview:self.faceBTN];

        _tagLB.frame = CGRectMake(10, 58/2 - 12, 50, 24);
        _lineView.frame = CGRectMake(0, CGRectGetHeight(frame)*0.6, SCREEN_WIDTH, 0.5);
        
        _picBTN.frame = CGRectMake(CGRectGetWidth(frame)/4, CGRectGetHeight(frame)*0.6 + (CGRectGetHeight(frame)*0.4)/2 - 10, 24, 22);
        
        _faceBTN.frame = CGRectMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)*0.6 + (CGRectGetHeight(frame)*0.4)/2 - 12, 24, 24);
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UISwitch *)mySwitch
{
    _mySwitch = [UISwitch defaultSwitch];
    [_mySwitch addTarget:self action:@selector(onSwitcher:) forControlEvents:UIControlEventTouchUpInside];
    
    return _mySwitch;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = WeiMiSystemFontWithpx(20);
        _tagLB.textAlignment = NSTextAlignmentLeft;
        _tagLB.text = @"匿名";
    }
    return _tagLB;
}

- (UIButton *)picBTN
{
    if (!_picBTN) {
        _picBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_picBTN setBackgroundImage:[UIImage imageNamed:@"circle_icon_picture"] forState:UIControlStateNormal];
        [_picBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_picBTN sizeToFit];
    }
    return _picBTN;
}

- (UIButton *)faceBTN
{
    if (!_faceBTN) {
        _faceBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_faceBTN setBackgroundImage:[UIImage imageNamed:@"circle_icon_smile"] forState:UIControlStateNormal];
        [_faceBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_faceBTN sizeToFit];
    }
    return _faceBTN;
}

#pragma mark - Actions
- (void)onSwitcher:(UISwitch *)switcher
{
//    if (!switcher.on) {
//
//    }
    OnSwitchHandler handler = self.onSwitchHandler;
    if (handler) {
        handler(switcher);
    }
}

- (void)onButton:(UIButton *)sender
{
    if (sender == _picBTN) {
        OnAddPicBtnHandler handler = self.onAddPicBtnHandler;
        if (handler) {
            handler();
        }
    }
}

- (void)updateConstraints
{
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_tagLB.mas_right).offset(10);
        make.centerY.mas_equalTo(_tagLB);
    }];
    
//    [_picBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.mas_equalTo(SCREEN_WIDTH/4);
//    }];
//    
//    [_faceBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.mas_equalTo(SCREEN_WIDTH/2);
//    }];
    [super updateConstraints];
}


@end
