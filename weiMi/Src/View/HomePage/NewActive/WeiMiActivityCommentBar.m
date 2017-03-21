//
//  WeiMiActivityCommentBar.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiActivityCommentBar.h"
#import <UITextView+Placeholder.h>
#import "WeiMiTagButton.h"

@interface WeiMiActivityCommentBar()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTextView;
@property (nonatomic, strong) WeiMiTagButton *commentBTN;
@property (nonatomic, strong) WeiMiTagButton *zanBTN;
@property (nonatomic, strong) UIButton *likeBTN;
@property (nonatomic, strong) UIButton *editBTN;

@end

@implementation WeiMiActivityCommentBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HEX_RGB(0xF7F7F7);
        [self addSubview:self.inputView];
        [self addSubview:self.commentBTN];
        [self addSubview:self.zanBTN];
        [self addSubview:self.likeBTN];
        [self addSubview:self.editBTN];

        [self setNeedsUpdateConstraints];
    }
    return self;
}


#pragma mark - Getter
- (UIView *)inputView
{
    if (!_inputTextView) {
        
        _inputTextView = [[UITextField alloc] init];
        _inputTextView.placeholder = @"你有什么想说的?";
        _inputTextView.font = WeiMiSystemFontWithpx(22);
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (WeiMiTagButton *)commentBTN
{
    if (!_commentBTN) {
        _commentBTN = [[WeiMiTagButton alloc] init];
        [_commentBTN setImage:@"icon_pinglun" title:@"11"];
        [_commentBTN sizeToFit];
    }
    return _commentBTN;
}

- (WeiMiTagButton *)zanBTN
{
    if (!_zanBTN) {
        _zanBTN = [[WeiMiTagButton alloc] init];
        [_zanBTN sizeToFit];
    }
    return _zanBTN;
}

- (UIButton *)likeBTN
{
    if (!_likeBTN) {
        _likeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_likeBTN setBackgroundImage:[UIImage imageNamed:@"icon_heart_bar"] forState:UIControlStateNormal];
        [_likeBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBTN sizeToFit];
    }
    return _likeBTN;
}

- (UIButton *)editBTN
{
    if (!_editBTN) {
        _editBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_editBTN setBackgroundImage:[UIImage imageNamed:@"icon_note"] forState:UIControlStateNormal];
        [_editBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_editBTN sizeToFit];
    }
    return _editBTN;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)updateConstraints
{

    [_likeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [_zanBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_likeBTN.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.height);
        make.width.mas_equalTo(_commentBTN.mas_height).multipliedBy(0.5);
    }];
    
    [_commentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_zanBTN.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.height);
        make.width.mas_equalTo(_commentBTN.mas_height).multipliedBy(0.5);
    }];
    
    
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(_editBTN.mas_right).offset(3);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.height);
        make.right.mas_equalTo(_commentBTN.mas_left).offset(-10);
    }];
    
    [_editBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(_likeBTN);
    }];
    [super updateConstraints];
}

@end
