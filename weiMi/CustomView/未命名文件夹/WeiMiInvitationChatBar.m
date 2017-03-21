//
//  WeiMiInvitationChatBar.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInvitationChatBar.h"


@interface WeiMiInvitationChatBar()

//@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *rightBTN;
@property (nonatomic, strong) UIButton *midBTN;
@property (nonatomic, strong) UIButton *leftBTN;

@end

@implementation WeiMiInvitationChatBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = HEX_RGB(0xF7F7F7);
        [self addSubview:self.inputTextView];
        [self addSubview:self.rightBTN];
        [self addSubview:self.midBTN];
        [self addSubview:self.leftBTN];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


#pragma mark - Getter
- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_rightBTN setBackgroundImage:[UIImage imageNamed:@"icon_pinglun"] forState:UIControlStateNormal];
        [_rightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBTN sizeToFit];
    }
    return _rightBTN;
}

- (UIButton *)midBTN
{
    if (!_midBTN) {
        _midBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_midBTN setBackgroundImage:[UIImage imageNamed:@"icon_heart_bar"] forState:UIControlStateNormal];
        [_midBTN setBackgroundImage:[UIImage imageNamed:@"icon_shoucang_dian"] forState:UIControlStateSelected];
        [_midBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_midBTN sizeToFit];
    }
    return _midBTN;
}

- (UIButton *)leftBTN
{
    if (!_leftBTN) {
        _leftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _likeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_leftBTN setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        [_leftBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBTN sizeToFit];
    }
    return _leftBTN;
}

- (UITextView *)inputTextView
{
    if (!_inputTextView) {
        
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.placeholder = @"你想说些什么?";
        _inputTextView.font = WeiMiSystemFontWithpx(20);
        _inputTextView.delegate = self.delegate;
        _inputTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _inputTextView.layer.borderWidth = 0.5f;
        _inputTextView.layer.cornerRadius = 5.0f;
        _inputTextView.layoutManager.allowsNonContiguousLayout = NO;
        [_inputTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (void)dealloc
{
    [_inputTextView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    //Center vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    _delegate = delegate;
    _inputTextView.delegate = _delegate;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _leftBTN) {
        
        OnZanBtnHandler block = self.onZanBtnHandler;
        if (block) {
            block();
        }
    }else if (sender == _midBTN)
    {
        OnLoveBtnHandler block = self.onLoveHandler;
        if (block) {
            block(sender);
        }
    }else if(sender == _rightBTN)
    {
        OnCommentBtnHandler block = self.onCommentHandler;
        if (block) {
            block();
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)updateConstraints
{
    
    [_rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [_midBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_rightBTN.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(_rightBTN);
    }];
    
    [_leftBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_midBTN.mas_left).offset(-10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(_rightBTN);
    }];
    
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        

        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_leftBTN.mas_left).offset(-10);
    }];
    
    [super updateConstraints];
}



@end
