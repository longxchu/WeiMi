//
//  WeiMiMyTryoutVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyTryoutVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiMyTryOutCell.h"
#import "WeiMiSegmentView.h"
#import "WeiMiMyTryOutDTO.h"

@interface WeiMiMyTryoutVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
WeiMiSegmentViewDelegate>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    NSMutableArray *_applyingArr;
    NSMutableArray *_applySuccessArr;
    NSMutableArray *_applyFailArr;

}
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiSegmentView *segView;
@end

@implementation WeiMiMyTryoutVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        WeiMiMyTryOutDTO *dto_0 = [[WeiMiMyTryOutDTO alloc] init];
        dto_0.status = @"申请中";
        WeiMiMyTryOutDTO *dto_1 = [[WeiMiMyTryOutDTO alloc] init];
        dto_1.status = @"申请成功";
        WeiMiMyTryOutDTO *dto_2 = [[WeiMiMyTryOutDTO alloc] init];
        dto_2.status = @"申请失败";

        _applyingArr = [NSMutableArray arrayWithArray:@[dto_0]];
        _applySuccessArr = [NSMutableArray arrayWithArray:@[dto_1]];
        _applyFailArr = [NSMutableArray arrayWithArray:@[dto_2]];

        _dataSource = [NSMutableArray arrayWithArray:@[dto_0,
                                                       dto_1,
                                                       dto_2]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.segView];
    [self.contentView addSubview:self.tableView];
    
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
    self.title = @"我的试用";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Getter
- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"全部试用", @"申请中", @"申请成功", @"申请失败"];
        config.bgColor = kWhiteColor;
        config.scrollViewColor = kClearColor;
        config.selectTitleColor = kBlackColor;
        config.titleColor = kGrayColor;
        config.titleFont = WeiMiSystemFontWithpx(22);

        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, self.contentFrame.origin.y, SCREEN_WIDTH, GetAdapterHeight(50)) config:config delegate:self];
    }
    return _segView;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)sendr
{
//    [[WeiMiPageSkipManager homeRT] open:@"WeiMiApplyDetailVC"];
    [[WeiMiPageSkipManager homeRT] open:@"WeiMiApplyContentVC"];

}

#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        
        _dataSource = [NSMutableArray arrayWithArray:_applyingArr];
        [_dataSource addObjectsFromArray:_applySuccessArr];
        [_dataSource addObjectsFromArray:_applyFailArr];

    }else if (index == 1)
    {
        _dataSource = [NSMutableArray arrayWithArray:_applyingArr];
    }else if (index == 2)
    {
        _dataSource = [NSMutableArray arrayWithArray:_applySuccessArr];

    }else if (index == 3)
    {
        _dataSource = [NSMutableArray arrayWithArray:_applyFailArr];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    if (indexPath.row == 0) {
        WeiMiMyTryOutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiMyTryOutCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
        }
        [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.section)];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        btn.tag = 8888*indexPath.section;
        [btn setTitle:@"查看申请" forState:UIControlStateNormal];
        [btn setTitleColor:kBlackColor forState:UIControlStateNormal];
        btn.titleLabel.font= WeiMiSystemFontWithpx(20);
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setTitleColor:HEX_RGB(0xFA601A) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(cell);
            make.width.mas_equalTo(btn.mas_height).multipliedBy(3.75);
        }];
    }
    return cell;

}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return GetAdapterHeight(135);
    }
    return GetAdapterHeight(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
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
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_segView.mas_bottom);
    }];
    [super updateViewConstraints];
}

@end
