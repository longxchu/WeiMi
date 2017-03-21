//
//  WeiMiAboutUSVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAboutUSVC.h"
#import "WeiMiNotifiEmptyView.h"

@interface WeiMiAboutUSVC ()
{
    /**数据源*/
    NSArray *_dataSource;
}

@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation WeiMiAboutUSVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    [self.contentView addSubview:self.notiView];
    [self.contentView addSubview:self.bottomLabel];
    
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
    self.popWithBaseNavColor = YES;
    self.title = @"关于我们";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"logo" title:@"唯蜜生活\n1.0"];
    }
    return _notiView;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
//        _bottomLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _bottomLabel.attributedText = [self getAttr:@"Copyright@唯蜜生活\n版权所有：北京狼牙信息技术有限公司"];
        [_bottomLabel sizeToFit];
        _bottomLabel.textColor = kGrayColor;
        _bottomLabel.numberOfLines = 2;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = [UIFont fontWithName:@"Arial" size:14];
    }
    return _bottomLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)getAttr:(NSString *)title
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    style.firstLineHeadIndent = 10;
    //    style.headIndent = 10;//左缩进
    //    style.tailIndent = -10;//右缩进
    style.lineSpacing = 5.0f;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,title.length)];
    return attrStr;
}

#pragma mark - Constraints
- (void)updateViewConstraints
{
    [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(NAV_HEIGHT + STATUS_BAR_HEIGHT + GetAdapterHeight(80));
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-GetAdapterHeight(40));
    }];
    [super updateViewConstraints];

}

@end
