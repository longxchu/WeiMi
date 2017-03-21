//
//  WeiMiOtherUsersVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOtherUsersVC.h"
#import "WeiMiBaseTableView.h"
#import <UIImageView+WebCache.h>
#import "UIImage+UIImageEffects.h"
#import "WeiMiSystemInfo.h"
#import "UIButton+CenterImageAndTitle.h"
#import <UIButton+WebCache.h>
#import "WeiMiSegmentView.h"
#import "WeiMiOtherPeopleInfoCell.h"
#import <OHActionSheet.h>
#import "UILabel+NotiLabel.h"

#pragma mark -
#import "LWImageBrowser.h"
#import "WeiMiOthersLayout.h"
#import "WeiMiOtherModel.h"
#import "WeiMiOthersInviteCell.h"
#import "LWAlertView.h"

typedef NS_ENUM(NSInteger, CELLTYPE)
{
    CELLTYPE_INFO,
    CELLTYPE_INVITATION,
};

@interface WeiMiOtherUsersVC ()<UITableViewDelegate, UITableViewDataSource,WeiMiSegmentViewDelegate>
{
    NSMutableArray *_dataSource;
    
    NSMutableArray *_infoDataSource;
    NSMutableArray *_invitationDataSource;
    
    CELLTYPE _cellType;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (strong,nonatomic) UIView *tableHeaderView;
@property  (strong,nonatomic)  UIImageView  *imageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIButton *headerBTN;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) WeiMiSegmentView *segView;

//--------------
@property (nonatomic,strong) NSArray* fakeDatasource;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;

@end

@implementation WeiMiOtherUsersVC

- (instancetype)init
{
    if (self = [super init]) {
        _dataSource = [NSMutableArray new];
        _infoDataSource = [NSMutableArray new];
        _invitationDataSource = [NSMutableArray new];
        _cellType = CELLTYPE_INFO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    _infoDataSource = [NSMutableArray arrayWithArray:@[@[@"基本信息",@""],
                                                       @[@"积分",@"32个"],
                                                        @[@"性别",@"男"],
                                                         @[@"年龄",@"22"],
                                                         @[@"星座",@"狮子座"],
                                                         @[@"婚恋状态",@"单身"],
                                                       ]];
    self.contentFrame = [self visibleBoundsShowNav:NO showTabBar:NO];
    CGRect frame = self.contentFrame;
    frame.origin.y = 0;
    frame.size.height += STATUS_BAR_HEIGHT;
    [self.contentView addSubview:self.tableView];
    _tableView.frame = frame;
    _tableView.backgroundColor = HEX_RGB(0xEAEAEA);

    [self.tableHeaderView addSubview:self.imageView];
    [self.tableHeaderView addSubview:self.headerBTN];
    [self.tableHeaderView addSubview:self.nameLB];
    [self.tableHeaderView addSubview:self.tagLB];
    [self.tableHeaderView addSubview:self.segView];
    
    if (IOS8_OR_LATER) {
        [self.imageView addSubview:self.effectView];
    }

    self.tableView.tableHeaderView=self.tableHeaderView;

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    _needRefresh = YES;
    [self fakeDownload];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavgationItem];
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    WS(weakSelf);

    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:nil normal:@"icon_more_black" selected:nil action:^{
        
        SS(strongSelf);
        [OHActionSheet showFromView:self.view title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"举报"] completion:^(OHActionSheet *sheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [strongSelf presentSheet:@"举报成功"];
            }
        }];

    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
//        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerFooterView"];
    }
    return _tableView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(278))];
        _imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.clipsToBounds=YES;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
        if (IOS8_OR_LATER) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        }else
        {
            WS(weakSelf);
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[[UIImage imageNamed:@"weimiQrCode"] blurImageWithRadius:10.0f] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                SS(strongSelf);
                if (image) {
                    strongSelf.imageView.image = [[UIImage imageNamed:@"weimiQrCode"] blurImageWithRadius:10.0f];
                }
            }];
        }

    }
    return _imageView;
}

- (UIButton *)headerBTN
{
    if (!_headerBTN) {
        _headerBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerBTN setTitle:@"一激动就乱射" forState:UIControlStateNormal];
        [_headerBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _headerBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        [_headerBTN sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        _headerBTN.layer.masksToBounds = YES;
        _headerBTN.layer.cornerRadius = _headerBTN.width/2;
//        [_headerBTN verticalCenterImageAndTitle:10];
    }
    return _headerBTN;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(23)];
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.text = @"一激动就乱she";
        [_nameLB sizeToFit];
    }
    return _nameLB;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.textColor = kWhiteColor;
        _tagLB.backgroundColor = HEX_RGB(0x53E2F9);
        _tagLB.text = @"3";
    }
    return _tagLB;
}

-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, GetAdapterHeight(278))];
    }
    return _tableHeaderView;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _effectView.alpha = 1.0f;
    }
    return _effectView;
}

- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"资料", @"帖子"];
        config.titleFont = WeiMiSystemFontWithpx(22);
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, self.tableHeaderView.height - 44, SCREEN_WIDTH, 44) config:config delegate:self];
        _segView.backgroundColor = HEX_RGB(0xF6F6F6);
    }
    return _segView;
}

#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        
        if (_cellType == CELLTYPE_INFO)
        {
            return;
        }else
        {
            _cellType = CELLTYPE_INFO;
            [_tableView reloadData];
        }
    }else if (index == 1)
    {
        if (_cellType == CELLTYPE_INVITATION)
        {
            return;
        }else
        {
            _cellType = CELLTYPE_INVITATION;
            [_tableView reloadData];
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect =self.tableHeaderView.frame;
        rect.origin.y = offset.y;
        rect.size.height =CGRectGetHeight(rect)-offset.y;
        self.imageView.frame = rect;
        self.tableHeaderView.clipsToBounds=NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_cellType == CELLTYPE_INFO) {
        return _infoDataSource.count;
    }
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == CELLTYPE_INFO) {
        static NSString *cellID = @"infoCell";
        WeiMiOtherPeopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiOtherPeopleInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
            
        }
        [cell setViewWith:safeObjectAtIndex(_infoDataSource[indexPath.row], 0) value:safeObjectAtIndex(_infoDataSource[indexPath.row], 1)];
        return cell;
    }
    
    static NSString *cellID = @"inviteCell";
    WeiMiOthersInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiOthersInviteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
    }
    [self confirgueCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITabelViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_cellType == CELLTYPE_INFO) {
        return [UIView new];
    }
    static NSString *headerViewId = @"headerFooterView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        headerView.backgroundColor = tableView.backgroundColor;
        UILabel *label = [UILabel footerNotiLabelWithTitle:@"3篇帖子" textAlignment:NSTextAlignmentLeft];
//        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(headerView).insets(UIEdgeInsetsMake(4, 0, 0, 0));
        }];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == CELLTYPE_INFO) {
        return 40;
    }
    if (self.dataSource.count >= indexPath.row) {
        WeiMiOthersLayout* layout = self.dataSource[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_cellType == CELLTYPE_INFO) {
        return 10.1;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (_cellType == CELLTYPE_INFO) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];

        }else
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _headerBTN.layer.cornerRadius = _headerBTN.width/2;
}

- (void)updateViewConstraints
{
    if (_effectView) {
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self.imageView);
        }];
    }

    
    [_headerBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.tableHeaderView);
        make.centerY.mas_equalTo(self.tableHeaderView).offset(-GetAdapterHeight(40));
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(78), GetAdapterHeight(78)));
    }];
    
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_headerBTN);
        make.top.mas_equalTo(_headerBTN.mas_bottom).offset(10);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_nameLB.mas_right).offset(10);
        make.centerY.mas_equalTo(_nameLB);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(_nameLB.mas_height).multipliedBy(1.1);
    }];
    
//    [_segView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.mas_equalTo(_tableHeaderView);
//    }];
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///-----------
- (void)confirgueCell:(WeiMiOthersInviteCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiOthersLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
//    [self callbackWithCell:cell];
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

#pragma mark - Data
- (WeiMiOthersLayout *)layoutWithStatusModel:(WeiMiOtherModel *)statusModel index:(NSInteger)index {
    WeiMiOthersLayout* layout = [[WeiMiOthersLayout alloc] initWithStatusModel:statusModel
                                                                                       index:index
                                                                               dateFormatter:self.dateFormatter];
    return layout;
}
//模拟下载数据
- (void)fakeDownload {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.needRefresh) {
            [self.dataSource removeAllObjects];
            NSMutableArray* fakes = [[NSMutableArray alloc] init];
            [fakes addObjectsFromArray:self.fakeDatasource];
            for (NSInteger i = 0; i < fakes.count; i ++) {
                LWLayout* layout = [self layoutWithStatusModel:
                                    [[WeiMiOtherModel alloc] initWithDict:fakes[i]]
                                                         index:i];
                [self.dataSource addObject:layout];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshComplete];
        });
    });
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableView reloadData];
    self.needRefresh = NO;
}

- (NSArray *)fakeDatasource {
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource =
    @[@{@"type":@"image",
        @"title":@"型格志style",
        @"tag":@"同城交友",
        @"date":@"1459668442",
        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jeloxwhnj30fu0g0ta5.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelpn9bdj30b40gkgmh.jpg",
                  @"http://ww1.sinaimg.cn/mw690/006gWxKPgw1f2jelriw1bj30fz0g175g.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelt1kh5j30b10gmt9o.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jeluxjcrj30fw0fz0tx.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelzxngwj30b20godgn.jpg",
                  @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jelwmsoej30fx0fywfq.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jem32ccrj30xm0sdwjt.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jelyhutwj30fz0fxwfr.jpg",],
        @"commentNum":@"5"},
      
      @{@"type":@"image",
        @"title":@"型格志style",
        @"tag":@"同城交友",
        @"date":@"1459668442",
        @"commentNum":@"4"}
      ];
    
    return _fakeDatasource;
}



@end
