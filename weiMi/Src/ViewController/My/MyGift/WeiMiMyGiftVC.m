//
//  WeiMiMyGiftVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyGiftVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiMyGiftDTO.h"
#import "WeiMiAppRecommendVC.h"
#import "WeiMiRefreshComponents.h"
#import <UIImageView+WebCache.h>
//---- request
#import "WeiMiAppRecommandRequest.h"
#import "WeiMiAppRecommandResponse.h"

@interface WeiMiMyGiftVC()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    __block NSInteger _currentPage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@end

@implementation WeiMiMyGiftVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
        _dataSource = [NSMutableArray new];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    [self.view setNeedsUpdateConstraints];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getAppListWithIdx:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        _currentPage = 1;
        [_dataSource removeAllObjects];
        [self getAppListWithIdx:_currentPage pageSize:10];
    }];
    
    [self getAppListWithIdx:_currentPage pageSize:10];
}

- (void)changeNavBar
{
    [self.navigationController.navigationBar setBarTintColor:HEX_RGB(SEC_COLOR_HEX)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor}];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"App推荐";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}


#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Network
//---- 最新活动列表
- (void)getAppListWithIdx:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiAppRecommandRequest *request = [[WeiMiAppRecommandRequest alloc] initWithPageIndex:index pageSize:pageSize];
    WeiMiAppRecommandResponse *response = [[WeiMiAppRecommandResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [_dataSource addObjectsFromArray:response.dataArr];
            [strongSelf.tableView reloadData];
            
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
        }else
        {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        [_tableView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - Actions
- (void)onHeadButton
{
    
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
    static NSString *cellID = @"giftCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
//        cell.detailTextLabel.textColor = kGrayColor;
        
//        /// 添加时间Label
//        UILabel *timeLabel = [[UILabel alloc] init];
//        timeLabel.tag = 8888 + indexPath.row;
//        timeLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
//        timeLabel.textAlignment = NSTextAlignmentRight;
//        timeLabel.textColor = kGrayColor;
//        [cell.contentView addSubview:timeLabel];
//        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.right.mas_equalTo(-10);
//            make.top.mas_equalTo(10);
//        }];
        
        /// 添加标题label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 7777 + indexPath.row;
        titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(cell.imageView.mas_right).offset(10);
            make.top.mas_equalTo(10);
        }];
        
        /// 添加详情label
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.tag = 9999 + indexPath.row;
        detailLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = kGrayColor;
        [cell.contentView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(titleLabel);
            make.bottom.mas_equalTo(-10);
        }];
    }
    WeiMiAppRecommandDTO *dto = safeObjectAtIndex(_dataSource, indexPath.row);
    //根据Tag获得timeLabel
//    UILabel *timeLabel = [cell.contentView viewWithTag:8888 + indexPath.row];
//    if (timeLabel) {
//    }
    
    UILabel *titleLabel = [cell.contentView viewWithTag:7777 + indexPath.row];
    if (titleLabel) {
        titleLabel.text = dto.appName;
    }
    
    UILabel *detailLabel = [cell.contentView viewWithTag:9999 + indexPath.row];
    if (detailLabel) {
        detailLabel.text = dto.appName;
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.appLogo)] placeholderImage:WEIMI_PLACEHOLDER_RECT completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //重绘image大小来 调整imageView大小
        CGSize itemSize = CGSizeMake(50, 50);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
    
    
    
//    cell.textLabel.text = ((WeiMiMyGiftDTO *)safeObjectAtIndex(_dataSource, indexPath.row)).titleStr;
//    cell.detailTextLabel.text = ((WeiMiMyGiftDTO *)safeObjectAtIndex(_dataSource, indexPath.row)).subTitleStr;
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
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
    
    WeiMiAppRecommandDTO *dto = safeObjectAtIndex(_dataSource, indexPath.row);

    if (dto.andriodUrl) {
        WeiMiAppRecommendVC *vc = [[WeiMiAppRecommendVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        vc.params = [[NSMutableDictionary alloc] init];
        [vc.params setValue:dto.andriodUrl forKey:@"url"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [[Routable sharedRouter] openExternal:dto.iosUrl];
//    [[Routable sharedRouter] openExternal:@"https://itunes.apple.com/cn/app/li-xin-shu-yuan/id1146725439?mt=8"];
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


@end
