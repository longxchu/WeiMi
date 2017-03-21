//
//  WeiMiSegmentView.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSegmentView.h"

@implementation WeiMiSegmentViewConfig

- (instancetype)init
{
    if (self = [super init]) {
        _titleFont = WeiMiSystemFontWithpx(18);
        _titleColor = kBlackColor;
        _scrollViewColor = _selectTitleColor = HEX_RGB(BASE_COLOR_HEX);
        _selectedIndex = 0;
    }
    return self;
}

@end

@interface WeiMiSegmentView()

@property (strong, nonatomic) UIButton *buttonOne;
@property (strong, nonatomic) UIButton *buttonTwo;
@property (strong, nonatomic) UILabel *labelOne;
@property (strong, nonatomic) UILabel *labelTwo;

@property (strong, nonatomic) UIView *selectedView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *btnArray;


//--------outerPro
//默认背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//默认字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//选中背景颜色
@property (nonatomic, strong) UIColor *selectBgColor;
//选中字体颜色
@property (nonatomic, strong) UIColor *selectTitleColor;
//滚动条颜色
@property (nonatomic, strong) UIColor *scrollViewColor;
//字体大小
@property (nonatomic, strong) UIFont *titleFont;

@end

@implementation WeiMiSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray defaultSelectIndex:(NSInteger)selectedIndex delegate:(id <WeiMiSegmentViewDelegate>) delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        NSAssert([titleArray count] <= 5, @"Parameters error");
        self.delegate = delegate;
        self.titleArray = titleArray;
        self.selectedIndex = selectedIndex;
        self.labelArray = [[NSMutableArray alloc] init];
        self.btnArray = [[NSMutableArray alloc] init];
        self.titleColor = kBlackColor;
        self.selectTitleColor = self.scrollViewColor = HEX_RGB(BASE_COLOR_HEX);
        self.titleFont = WeiMiSystemFontWithpx(18);

        [self initViews];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame config:(WeiMiSegmentViewConfig *)config delegate:(id <WeiMiSegmentViewDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        NSAssert([config.titleArray count] <= 5, @"Parameters error");
        self.delegate = delegate;
        self.titleArray = config.titleArray;
        self.selectedIndex = config.selectedIndex;
        self.labelArray = [[NSMutableArray alloc] init];
        self.btnArray = [[NSMutableArray alloc] init];
        
        self.titleColor = config.titleColor;
        self.selectTitleColor = config.selectTitleColor;
        self.scrollViewColor = config.scrollViewColor;
        self.titleFont = config.titleFont;
        
        [self initViews];
    }
    return  self;
}


- (void)selectedIndex:(NSInteger)selectIndex
{
    NSAssert(selectIndex >= 0 && selectIndex <= 5, @"Parameters error");
    
    [self selectIndex:selectIndex];
}

- (void)initViews
{
    WS(weakSelf);
    
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // button按钮
        UIButton *button = self.buttonOne;
        button.tag = (idx + 1) * 100;
        CGFloat itemWidth = self.width/_titleArray.count;
        button.frame = CGRectMake(idx * itemWidth, 0, itemWidth, self.height);
        
        //标签Label
        UILabel *label = self.labelOne;
//        label.frame = button.frame;
         if ([obj isKindOfClass:[NSString class]]) {
            label.text = (NSString *)obj;
        }

        [label sizeToFit];
        label.center = button.center;
        if (idx == _selectedIndex) {
            self.selectedView.frame = CGRectMake(label.left, label.bottom + 5, label.width, 1.0f);
        }
        SS(strongSelf);
        [strongSelf addSubview:button];
        [strongSelf addSubview:label];
        
        [strongSelf.labelArray addObject:label];
        [strongSelf.btnArray addObject:button];
    }];
    [self addSubview:self.selectedView];
    [self selectedIndex:self.selectedIndex];
}

#pragma mark - Getter
- (UILabel *)labelOne
{
    UILabel *label = [[UILabel alloc] init];
//    label.font = [UIFont systemFontOfSize:15];
    label.font = self.titleFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HEX_RGB(BASE_TEXT_COLOR);
    label.text = @"one";
    return label;
}

//- (UILabel *)labelTwo
//{
//    if (!_labelTwo) {
//        _labelTwo = [[UILabel alloc] init];
//        _labelTwo.font = [UIFont systemFontOfSize:14];
//        _labelTwo.textColor = HEX_RGB(BASE_TEXT_COLOR);
//        _labelTwo.text = @"two";
//    }
//    return _labelTwo;
//}

- (UIButton *)buttonOne
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = kClearColor;
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//        _buttonOne.tag = 111;
    return button;
}

//- (UIButton *)buttonTwo
//{
//    if (!_buttonTwo) {
//        _buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
//        _buttonTwo.backgroundColor = kClearColor;
//        [_buttonTwo addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//        _buttonTwo.tag = 222;
//    }
//    return _buttonTwo;
//}

- (UIView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
//        _selectedView.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _selectedView.backgroundColor = _scrollViewColor;
    }
    return _selectedView;
}
#pragma mark - Common
- (void)selectIndex:(NSInteger)selectIndex
{
    for (UILabel *label in self.labelArray) {
//        label.textColor = HEX_RGB(BASE_TEXT_COLOR);
        label.textColor = _titleColor;
    }
    
    UILabel *selectedLabel = (UILabel *)[self.labelArray objectAtIndex:selectIndex];
    self.selectedView.frame = CGRectMake(selectedLabel.left, selectedLabel.bottom + 5, selectedLabel.width, 1.0f);
//    selectedLabel.textColor = HEX_RGB(BASE_COLOR_HEX);
    selectedLabel.textColor = _selectTitleColor;

    WS(weakSelf);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        SS(strongSelf);
        strongSelf.selectedView.center = CGPointMake(selectedLabel.centerX, strongSelf.selectedView.center.y);

    } completion:nil];
}

- (void)select:(UIButton *)sender {
    
    NSUInteger index = sender.tag/100 - 1;
    [self selectIndex:index];
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
        [self.delegate didSelectedAtIndex:index];
    }
}

@end
