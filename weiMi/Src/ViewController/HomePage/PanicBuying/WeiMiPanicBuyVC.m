//
//  WeiMiPanicBuyVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPanicBuyVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiPanicBuyCell.h"
#import "WeiMiDownTimeView.h"
#import "NSTimer+Add.h"

@interface WeiMiPanicBuyVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSUInteger _downTime;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiDownTimeView *downTimeView;
@property (nonatomic, strong) UILabel *notiLB;

/// 限时抢购定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WeiMiPanicBuyVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"在线客服",
                        @"系统通知",
                        @"我的消息"];
        _downTime = 59;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:NO showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    CGRect rect = self.contentFrame;
    rect.origin.y -= STATUS_BAR_HEIGHT;
    _tableView.frame = rect;
    
    UIView *headerBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerBG.backgroundColor = _tableView.backgroundColor;
    [headerBG addSubview:self.downTimeView];
    _downTimeView.frame = CGRectMake(SCREEN_WIDTH/2, 25 - 25/2, 120, 25);
    //添加提示LB
    [headerBG addSubview:self.notiLB];
    _notiLB.frame = CGRectMake(0, _downTimeView.origin.y, SCREEN_WIDTH/2, 25);
    _tableView.tableHeaderView = headerBG;
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_downTime != 0) {
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_downTime == 0) {
        [self.timer pauseTimer];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}
//
//- (void)initNavgationItem
//{
//    [super initNavgationItem];
//    self.title = @"抢购";
//    self.popWithBaseNavColor = YES;
//    WS(weakSelf);
//    
//    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
//        
//        SS(strongSelf);
//        [strongSelf BackToLastNavi];
//    }];
//}

#pragma mark - Getter
- (NSTimer *)timer
{
    if (!_timer) {
        
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimeDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (WeiMiDownTimeView *)downTimeView
{
    if (!_downTimeView) {
        _downTimeView = [[WeiMiDownTimeView alloc] init];
    }
    return _downTimeView;
}

- (UILabel *)notiLB
{
    if (!_notiLB) {
        _notiLB = [[UILabel alloc] init];
        _notiLB.text = @"距本场结束";
//        [_notiLB sizeToFit];
        _notiLB.textAlignment = NSTextAlignmentRight;
        _notiLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
    }
    return _notiLB;
}
#pragma mark - Actions
- (void)updateTimeDown
{
    if (_downTime != 0) {
        _downTime --;
        
        NSUInteger hour = 0;
        NSUInteger minute = 0;

        [_downTimeView setTimeLabel:[NSString stringWithFormat:@"0%lu", hour] minute:[NSString stringWithFormat:@"0%lu", minute] second:_downTime > 10 ? [NSString stringWithFormat:@"%lu", _downTime] :[NSString stringWithFormat:@"0%lu", _downTime]];
    }
    else
    {
        if (_timer.isValid) {
            [self.timer invalidate];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    WeiMiPanicBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiPanicBuyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)updateViewConstraints
{

    [super updateViewConstraints];
}

- (void)dealloc
{
    if (_timer.isValid) {
        [_timer invalidate];//销毁定时器
    }}


@end
