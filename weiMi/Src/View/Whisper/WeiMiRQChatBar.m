//
//  WeiMiRQChatBar.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQChatBar.h"

@interface WeiMiRQChatBar()

@property (nonatomic, strong) UIButton *sendBTN;

@end

@implementation WeiMiRQChatBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = HEX_RGB(0xF7F7F7);
        [self addSubview:self.inputTextView];
        [self addSubview:self.sendBTN];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)sendBTN
{
    if (!_sendBTN) {
        _sendBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBTN setTitle:@"发送" forState:UIControlStateNormal];
        _sendBTN.layer.cornerRadius = 5.0f;
        _sendBTN.layer.masksToBounds = YES;
        _sendBTN.titleLabel.font = WeiMiSystemFontWithpx(21);
        [_sendBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_sendBTN setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0x00A0E9)] forState:UIControlStateNormal];
        [_sendBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBTN sizeToFit];
    }
    return _sendBTN;
}

- (UITextView *)inputTextView
{
    if (!_inputTextView) {
        
        _inputTextView = [[UITextView alloc] init];
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

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _sendBTN) {
        
        OnSendBtnHandler block = self.onSendBtnHandler;
        if (block) {
            block();
        }
    }
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

- (void)updateConstraints
{
    
    [_sendBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.height.mas_equalTo(_inputTextView);
//        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.width.mas_equalTo(_sendBTN.mas_height).multipliedBy(1.5);
    }];
    
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_sendBTN.mas_left).offset(-10);
    }];
    
    [super updateConstraints];

}

@end
