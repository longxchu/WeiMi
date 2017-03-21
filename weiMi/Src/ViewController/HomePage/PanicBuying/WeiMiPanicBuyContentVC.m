//
//  WeiMiPanicBuyContentVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPanicBuyContentVC.h"
#import "WeiMiPanicBuyVC.h"

static const CGFloat labelW = 320/5;
static CGFloat ktitleH = 60;
static const CGFloat radio = 1.1;
@interface WeiMiPanicBuyContentVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *selLabel;

@property (strong, nonatomic) UIScrollView *titleScrollView;
@property (strong, nonatomic) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *titleBottomLabels;

@end

@implementation WeiMiPanicBuyContentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _titleBottomLabels = [NSMutableArray new];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.contentScrollView];
    _titleScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, GetAdapterHeight(ktitleH));
    _contentScrollView.frame = CGRectMake(0, _titleScrollView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - GetAdapterHeight(ktitleH));
    
    // 添加所有子控制器
    [self setUpChildViewController];
    
    // 添加所有子控制器对应标题
    [self setUpTitleLabel];
    
    [self setUpScrollView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"抢购";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init];
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (NSMutableArray *)titleLabels
{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray *)titleBottomLabels
{
    if (!_titleBottomLabels) {
        _titleBottomLabels = [NSMutableArray array];
    }
    return _titleBottomLabels;
}

#pragma mark - util
// 初始化UIScrollView
- (void)setUpScrollView
{
    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.contentSize = CGSizeMake(count * labelW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动条
    self.contentScrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
    // 开启分页
    self.contentScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    self.contentScrollView.bounces = NO;
    // 隐藏水平滚动条
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.delegate = self;
}


/* 添加所有子控制器 */
- (void)setUpChildViewController
{
    // 头条
    WeiMiPanicBuyVC *topLine = [[WeiMiPanicBuyVC alloc] init];
    topLine.title = @"16:00";
    [self addChildViewController:topLine];
    
    // 热点
    WeiMiPanicBuyVC *hot = [[WeiMiPanicBuyVC alloc] init];
    hot.title = @"16:00";
    [self addChildViewController:hot];
    
    // 视频
    WeiMiPanicBuyVC *video = [[WeiMiPanicBuyVC alloc] init];
    video.title = @"16:00";
    [self addChildViewController:video];
    
    
    // 社会
    WeiMiPanicBuyVC *society = [[WeiMiPanicBuyVC alloc] init];
    society.title = @"16:00";
    [self addChildViewController:society];
    
    
    // 阅读
    WeiMiPanicBuyVC *reader = [[WeiMiPanicBuyVC alloc] init];
    reader.title = @"16:00";
    [self addChildViewController:reader];
    
    
    // 科技
    WeiMiPanicBuyVC *science = [[WeiMiPanicBuyVC alloc] init];
    science.title = @"16:00";
    [self addChildViewController:science];
}

-(void)setUpTitleLabel
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = GetAdapterHeight(ktitleH);
    
    
    for (int i = 0; i < count; i++) {
        // 获取对应子控制器
        UIViewController *vc = self.childViewControllers[i];
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        
        labelX = i * labelW;
        
        // 设置尺寸
        label.frame = CGRectMake(labelX, labelY, labelW, labelH*2/3);
        
        // 设置label文字
        label.text = vc.title;
        
        // 设置高亮文字颜色
        label.highlightedTextColor = [UIColor redColor];

        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFontSizeWithpx(28)];
        // 设置label的tag
        label.tag = i;
        
        // 设置显示两行
        label.numberOfLines = 1;
        
        // 设置用户的交互
        label.userInteractionEnabled = YES;
        
        // 文字居中
        label.textAlignment = NSTextAlignmentCenter;
        
        
        // 添加到titleLabels数组
        [self.titleLabels addObject:label];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        

        UILabel *bottomLable = [[UILabel alloc] init];
        
        bottomLable.frame = CGRectMake(labelX, labelH*2/3, labelW, labelH*1/3 - 5);
        bottomLable.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        bottomLable.text = @"抢购中";
        bottomLable.highlightedTextColor = kRedColor;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        [self.titleBottomLabels addObject:bottomLable];
        
        // 默认选中第0个label
        if (i == 0) {
            [self titleClick:tap];
        }
        
        // 添加label到标题滚动条上
        [self.titleScrollView addSubview:label];
        [self.titleScrollView addSubview:bottomLable];
        
    }
}
// 点击标题的时候就会调用
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    
    [self selectView:label];
    
    
    NSInteger index = tap.view.tag;
    
    //获取底层label
    
    CGFloat offsetX = index * SCREEN_WIDTH;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    [self showVc:index];
    
    [self setupTitleCenter:label];
}


-(void)showVc:(NSInteger)index
{
    CGFloat offsetX = index*SCREEN_WIDTH;
    
    UIViewController *vc = self.childViewControllers[index];
    
    
    if (vc.isViewLoaded) {
        return;
    }
    
    vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}


-(void)selectView:(UILabel *)label
{
    _selLabel.highlighted = NO;
    UILabel *bottomLabel = [_titleBottomLabels objectAtIndex:_selLabel.tag];
    if (bottomLabel) {
        bottomLabel.highlighted = NO;
    }
    
    // 取消形变
    _selLabel.transform = CGAffineTransformIdentity;
    label.highlighted = YES;
    bottomLabel = [_titleBottomLabels objectAtIndex:label                        .tag];
    if (bottomLabel) {
        bottomLabel.highlighted = YES;
    }
    
    // 高大
    label.transform = CGAffineTransformMakeScale(radio, radio);
    // 颜色恢复
    _selLabel.textColor = [UIColor blackColor];
    bottomLabel = [_titleBottomLabels objectAtIndex:_selLabel.tag];
    if (bottomLabel) {
        bottomLabel.textColor = [UIColor blackColor];
    }

    _selLabel = label;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 左边label角标
    NSInteger leftIndex = curPage;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    
    
    // 获取左边的label
    UILabel *leftLabel = self.titleLabels[leftIndex];
    UILabel *leftBottomLabel = self.titleBottomLabels[leftIndex];
    
    // 获取右边的label
    UILabel *rightLabel;
    UILabel *rightBottomLabel;
    if (rightIndex < self.titleLabels.count-1) {
        rightLabel = self.titleLabels[rightIndex];
        rightBottomLabel = self.titleBottomLabels[rightIndex];
    }
    
    CGFloat rightScale = curPage - leftIndex;
    CGFloat leftScale = 1- rightScale;
    
    // 左边缩放
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * (radio - 1) + 1, leftScale * (radio - 1) + 1);
    
    // 右边缩放
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * (radio - 1) + 1, rightScale * (radio - 1) + 1);
    
    
    // 设置文字颜色渐变
    /*
     R G B
     黑色 0 0 0
     红色 1 0 0
     */
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    leftBottomLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightBottomLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    
    [self showVc:index];
    
    UILabel *selLabel = self.titleLabels[index];
    
    [self selectView:selLabel];
    
    [self setupTitleCenter:selLabel];
    
}

-(void)setupTitleCenter:(UILabel *)label
{
    CGFloat offsetX = label.center.x - SCREEN_WIDTH * 0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SCREEN_WIDTH;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


@end
