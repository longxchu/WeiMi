//
//  WeiMiCommunityVC.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunityVC.h"
#import "CycleScrollView.h"
#import "WeiMiBaseTableView.h"
//----- category
#import <UIImageView+WebCache.h>
//----- cell
#import "WeiMiGraceCell.h"
#import "WeiMiHotMoudleCell.h"
#import "WeiMiHotRecommendCell.h"
#import "WeiMiCircleRecommendCell.h"
#import "WeiMiSignAreaCell.h"
#import "WeiMiWannaCell.h"
#import "WeiMiCareCircleCell.h"
//测试cell
#import "WeiMiWannaTitleCell.h"
#import "WeiMiCycircleCell.h"
#import "WeiMiWannaItemsCell.h"
//----- VC
//男生女生
#import "WeiMiWomenWhisperVC.h"
//帖子详情
#import "WeiMiInvitationVC.h"
//圈子详情
#import "WeiMiCircleDetailVC.h"
//----- DTO
#import "WeiMiCircleRecomDTO.h"
#import "WeiMiHomePageBannerDTO.h"
#import "WeiMiCircleCateListDTO.h"

#import "WeiMiMyCareListModel.h"

//----- request
#import "WeiMiRefreshComponents.h"
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
//圈子列表
#import "WeiMiCircleCateListRequest.h"
#import "WeiMiCircleCateListResponse.h"
//帖子列表
#import "WeiMiInvitationListRequest.h"
#import "WeiMiInvitationListResponse.h"
//圈子推荐
#import "WeiMiPostRecommandRequest.h"
#import "WeiMiPostRecommandResponse.h"
//热帖推荐
#import "WeiMiCircleRecommandRequest.h"
#import "WeiMiCircleRecommandResponse.h"
//关注圈子
#import "WeiMiCareCircleRequest.h"
//男生女生
#import "WeiMiMaleInvitationRequest.h"
#import "WeiMiFemaleInvitationRequest.h"
#import "WeiMiMaleInvitationResponse.h"

#include <math.h>

static const NSInteger kCircleCommandNum = 6;
static const NSInteger kHotCommandNum = 3;

@interface WeiMiCommunityVC()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_horizonMenuTitleArr;
    NSMutableArray *_horizonMenuImgArr;
    
    NSMutableArray *_newCareMenuTitleArr;
    NSMutableArray *_newCareMenuImgArr;
    /**热帖推荐*/
    NSMutableArray *_hotRecommendArr;
    NSMutableArray *_hotRecommendCacheArr;//热帖推荐缓存
    __block NSInteger _randomHotRecommendIdx;//热帖推荐随机ID
    /**圈子推荐*/
    NSMutableArray *_circleRecommendArr;
    NSMutableArray *_circleRecommendCacheArr;//圈子推荐缓存
    __block NSInteger _randomCircleIdx;//圈子随机ID
    NSMutableArray *_myCareListArr;
    /**男生女生帖子*/
    NSArray *_invitationTitleArr;
    NSArray *_invitationIdArr;
    NSMutableArray *_maleInvitationArr;
    NSMutableArray *_femaleInvitaionArr;
    /**男生女生banner*/
    NSMutableDictionary *_maleFemaleBannerDic;
    NSMutableArray *_maleImageInfos;
    NSMutableArray *_femaleImageInfos;
    BOOL _refresh;//是否刷新

}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;

//女生悄悄话
@property (nonatomic, strong)    WeiMiHPWannaDTO *femaleWannaDTO;
//男生撸啊撸
@property (nonatomic, strong)    WeiMiHPWannaDTO *maleWannaDTO;
@end

@implementation WeiMiCommunityVC

- (instancetype)init
{
    if (self = [super init]) {
        
        _randomCircleIdx = 1;
        _randomHotRecommendIdx = 1;
        _myCareListArr = [NSMutableArray new];
        _hotRecommendArr = [NSMutableArray new];
        _hotRecommendCacheArr = [NSMutableArray new];
        _circleRecommendArr = [NSMutableArray new];
        _circleRecommendCacheArr = [NSMutableArray new];
        _maleInvitationArr = [NSMutableArray new];
        _femaleInvitaionArr = [NSMutableArray new];
        _invitationTitleArr = @[@"女生悄悄话",@"男生撸啊撸"];
        _invitationIdArr = @[kFemaleTag, kMaleTag];
        _maleFemaleBannerDic = [NSMutableDictionary new];
        _maleImageInfos = [NSMutableArray new];
        _femaleImageInfos = [NSMutableArray new];
        
        _newCareMenuImgArr = [[NSMutableArray alloc] init];
        _newCareMenuTitleArr = [[NSMutableArray alloc] init];
        _horizonMenuTitleArr = [NSMutableArray new];
        _horizonMenuImgArr = [NSMutableArray new];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([WeiMiUserCenter sharedInstance].isLogin){
        [self getMyCircleCommandList];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    [self.view setNeedsUpdateConstraints];
    
    [self.contentView addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    [self getBanner];
    [self getCircleCommandList];
    [self getHotInvitationCommandList];
    [self getInvitationListIsMale:YES];
    [self getInvitationListIsMale:NO];
    [self getItemBannerWithNavID:kMaleTag];
    [self getItemBannerWithNavID:kFemaleTag];
    [self getItemBannerWithNavID:@"101"];
    [self getItemBannerWithNavID:@"102"];
    [self getItemBannerWithNavID:@"201"];
    [self getItemBannerWithNavID:@"202"];
    
    //上拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        [self getCircleCommandList];
        if([WeiMiUserCenter sharedInstance].isLogin){
            [self getMyCircleCommandList];
        }
        [_hotRecommendArr removeAllObjects];
        [_hotRecommendCacheArr removeAllObjects];
        [_circleRecommendArr removeAllObjects];
        [_circleRecommendCacheArr removeAllObjects];
        [_maleInvitationArr removeAllObjects];
        [_femaleInvitaionArr removeAllObjects];
        [_maleImageInfos removeAllObjects];
        [_femaleImageInfos removeAllObjects];
        _refresh = YES;
        [self getBanner];
        [self getHotInvitationCommandList];
        [self getInvitationListIsMale:YES];
        [self getInvitationListIsMale:NO];
        [self getItemBannerWithNavID:kMaleTag];
        [self getItemBannerWithNavID:kFemaleTag];
        [self getItemBannerWithNavID:@"101"];
        [self getItemBannerWithNavID:@"102"];
        [self getItemBannerWithNavID:@"201"];
        [self getItemBannerWithNavID:@"202"];
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"社区";
    [self AddLeftBtn:nil normal:@"icon_message" selected:@"icon_message'" action:^{
        
        [WeiMiPageSkipManager skipCommunityMessageSettingVC:self];
    }];
    
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(330/2)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}

- (WeiMiHPWannaDTO *)maleWannaDTO
{
    if (!_maleWannaDTO) {
        _maleWannaDTO = [[WeiMiHPWannaDTO alloc] init];
        _maleWannaDTO.navID = @"nans";
        _maleWannaDTO.title = @"男生撸啊撸";
    }
    return _maleWannaDTO;
}

- (WeiMiHPWannaDTO *)femaleWannaDTO
{
    if (!_femaleWannaDTO) {
        _femaleWannaDTO = [[WeiMiHPWannaDTO alloc] init];
        _femaleWannaDTO.navID = @"nvs";
        _femaleWannaDTO.title = @"女生悄悄话";
    }
    return _femaleWannaDTO;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > 2) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    if (indexPath.section == 0) {//我关注的
        static NSString *cellID = @"CareCircleCell";
        WeiMiCareCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            WS(weakSelf);
            
            cell = [[WeiMiCareCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            __weak WeiMiCareCircleCell *weakCell = cell;
            
            cell.onAddNewCareBlock = ^{
                
                UPRouterOptions *options = [UPRouterOptions routerOptions];
                options.hidesBottomBarWhenPushed = YES;
                [[WeiMiPageSkipManager communityRouter] intoVC:@"WeiMiAllCircleVC" options:options];
            };
        }
        if([WeiMiUserCenter sharedInstance].isLogin){
            cell.listArr = _myCareListArr;
        }
        return cell;
    }
    else if (indexPath.section == 1)//热帖推荐
    {
        static NSString *cellID = @"hotRecommendCell";
        WeiMiHotRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiHotRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            __weak typeof(cell) weakCell = cell;
            cell.onClickedChangeBtn = ^()//点击更多按钮
            {
                if (_hotRecommendCacheArr.count <= kHotCommandNum) {
                    [weakSelf presentSheet:@"没有更多数据啦"];
                    return;
                }
                [_hotRecommendArr removeAllObjects];

                NSInteger changeNum = _hotRecommendCacheArr.count/kHotCommandNum + ((_hotRecommendCacheArr.count % kHotCommandNum) == 0 ? 0 : 1);//总共可以转换的次数
                NSInteger currentNum = _randomHotRecommendIdx % changeNum + 1;//当前转换id
                _randomHotRecommendIdx ++;
                [_hotRecommendCacheArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx >= (currentNum -1)*kHotCommandNum && idx < currentNum * kHotCommandNum) {
                        [_hotRecommendArr addObject:obj];
                    }
                }];
                
                [weakCell setViewWithDTOs:_hotRecommendArr];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            };
            
            cell.onClickedItemBtn = ^()//点击item
            {
                WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.popWithBaseNavColor = YES;
                vc.dto = safeObjectAtIndex(_hotRecommendArr, indexPath.row);
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
        }
        
        [cell setViewWithDTOs:_hotRecommendArr];
        return cell;
    }
    else if (indexPath.section == 2)//圈子推荐
    {
        static NSString *cellID = @"circelCell";
        WeiMiCircleRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            __weak typeof(cell) weakCell = cell;
            cell = [[WeiMiCircleRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.hiddenBtn = YES;
            cell.onClickedChangeBtn = ^(){//换一换
                if (_circleRecommendCacheArr.count <= kCircleCommandNum) {
                    [weakSelf presentSheet:@"没有更多数据啦"];
                    return;
                }
                [_circleRecommendArr removeAllObjects];
                

                NSInteger changeNum = _circleRecommendCacheArr.count/kCircleCommandNum + ((_circleRecommendCacheArr.count % kCircleCommandNum) == 0 ? 0 : 1);//总共可以转换的次数
                NSInteger currentNum = _randomCircleIdx % changeNum + 1;//当前转换id
                _randomCircleIdx ++;

                [_circleRecommendCacheArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx >= (currentNum -1)*kCircleCommandNum && idx < currentNum * kCircleCommandNum) {
                        [_circleRecommendArr addObject:obj];
                    }
                }];
                [weakCell setViewWithDTOs:_circleRecommendArr];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            };
            
            cell.onItemHandler = ^(NSInteger index)//点击圈子
            {

                WeiMiCircleDetailVC *vc = [[WeiMiCircleDetailVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.dto  = safeObjectAtIndex(_circleRecommendArr, index);
                vc.popWithBaseNavColor = YES;
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            cell.onMoreCircleBtn = ^()//更多圈子
            {
                UPRouterOptions *options = [UPRouterOptions routerOptions];
                options.hidesBottomBarWhenPushed = YES;
                [[WeiMiPageSkipManager communityRouter] intoVC:@"WeiMiAllCircleVC" options:options];
            };
            
            cell.onCareBtnInCellHandler = ^ (UIButton *btn, NSString *ringId)
            {
                SS(strongSelf);
                btn.selected = !btn.selected;
                
                [strongSelf careCircleWithringId:ringId];
            };
        }
        [cell setViewWithDTOs:_circleRecommendArr];
        return cell;
    }
    
    //女生悄悄话 && 男生撸啊撸
    if (indexPath.row == 0) {
        static NSString *cellID = @"wannaCell_5_0";
        WeiMiWannaTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiWannaTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            WS(weakSelf);
            cell.wannaTitleCellMoreBtn = ^(NSString *cId, NSString *title){
                SS(strongSelf);
                [WeiMiPageSkipManager skipIntoMaleFemaleVC:strongSelf title:title navId:cId];
            };
        }
        [cell setViewWithTitle:safeObjectAtIndex(_invitationTitleArr, indexPath.section - 3) tId:safeObjectAtIndex(_invitationIdArr, indexPath.section - 3)];
        return cell;
    }else if (indexPath.row == 1)
    {
        static NSString *cellID = @"wannaCell_5_1";
        WeiMiCycircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiCycircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.onWannCellItem = ^(NSString *bannerId){
              
                if ([NSString isNullOrEmpty:bannerId]) {
                    return;
                }else
                {
                    [WeiMiPageSkipManager skipIntoPostDetailVC:self infoId:bannerId popWithBaseNavColor:YES];
                }
            };
        }
        [cell loadAdvert:EncodeArrayFromDic(_maleFemaleBannerDic, indexPath.section == 3 ? kFemaleTag : kMaleTag)];
        return cell;
    }else if (indexPath.row == 2)
    {
        static NSString *cellID = @"wannaCell_5_2";
        WeiMiWannaItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiWannaItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            WS(weakSelf);
            cell.onWannCellItemHandler = ^(WeiMiBaseDTO *dto){
                SS(strongSelf);
                if (dto && [dto isKindOfClass:[WeiMiHomePageBannerDTO class]]) {
                    WeiMiHomePageBannerDTO *tempDTO = (WeiMiHomePageBannerDTO *)dto;
                    if (!tempDTO.bannerId) {
                        return;
                    }
                    [WeiMiPageSkipManager skipIntoWebVC:strongSelf title:@"链接" url:tempDTO.bannerUrl                                                               popWithBaseNavColor:YES];
                }
            };
        }
        [cell setViewWithLeftDTO:safeObjectAtIndex(indexPath.section == 3 ? _femaleImageInfos : _maleImageInfos, 0) rightDTO:safeObjectAtIndex(indexPath.section == 3 ? _femaleImageInfos : _maleImageInfos, 1)];
        return cell;
    }
    
    return nil;
}
#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSInteger lastNum = (_myCareListArr.count + 1) % 3 == 0 ? 0 : 1;
            int count = ceil((_myCareListArr.count+1)/3.0);
            return myCareTitleHeight + myCareItemHeight * count;
        }
        case 1:
            return 39 + 80 * _hotRecommendArr.count;
        case 2:
            return 90 + 60* _circleRecommendArr.count;
        default:
        {
            if (indexPath.row == 0) {
                
                return [WeiMiWannaTitleCell getHeight];
            }else if (indexPath.row == 1)
            {
                return [WeiMiCycircleCell getHeight];
            }else if (indexPath.row == 2)
            {
                return [WeiMiWannaItemsCell getHeight];
            }
        };
            break;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 0.1f;
    }
    return 10;
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

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark - NetWork
- (void)getBanner
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] initWithIsAble:@"2"];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        [self loadAdvert:res.dataArr];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}
/*
 * 圈子推荐
 */
- (void)getCircleCommandList
{
    WeiMiCircleRecommandRequest *request = [[WeiMiCircleRecommandRequest alloc] initWithTypeId:nil pageIndex:nil pageSize:nil];
    WeiMiCircleRecommandResponse *response = [[WeiMiCircleRecommandResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            [response parseResponse:result];
            [_circleRecommendCacheArr addObjectsFromArray:response.dataArr];
            
            [_circleRecommendCacheArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < kCircleCommandNum) {
                    [_circleRecommendArr addObject:obj];
                    
                }
            }];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        [_tableView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView.mj_header endRefreshing];
    }];
}
// 我的关注列表
- (void)getMyCircleCommandList {
    if(_myCareListArr.count != 0){
        [_myCareListArr removeAllObjects];
    }
    WeiMiMyCareListReqeust *request = [[WeiMiMyCareListReqeust alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:@"1" pageSize:@"15"];
    WeiMiMyCareListResponse *response = [[WeiMiMyCareListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = request.responseJSONObject;
        [response parseResponse:result];
        _myCareListArr = [response.dataArr mutableCopy];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

/*
 * 热帖推荐
 */
- (void)getHotInvitationCommandList
{
    WeiMiPostRecommandRequest *request = [[WeiMiPostRecommandRequest alloc] initWithRingId:nil pageIndex:nil pageSize:nil];
    WeiMiPostRecommandResponse *response = [[WeiMiPostRecommandResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            [response parseResponse:result];
            
            [_hotRecommendCacheArr addObjectsFromArray:response.dataArr];
            
            [_hotRecommendCacheArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < kHotCommandNum) {
                    [_hotRecommendArr addObject:obj];
                }
            }];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [_tableView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView.mj_header endRefreshing];
        
    }];
}

//--- 关注圈子
- (void)careCircleWithringId:(NSString *)ringId
{
    WeiMiCareCircleRequest *request = [[WeiMiCareCircleRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel ringId:ringId];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         SS(strongSelf);
         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
         if ([result isEqualToString:@"1"]) {
             [strongSelf presentSheet:@"关注成功"];
         }else if([result isEqualToString:@"2"])
         {
             [strongSelf presentSheet:@"已经关注过了"];
         }else if ([result isEqualToString:@"0"])
         {
             [strongSelf presentSheet:@"关注失败"];
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
     }];
}


/**
 *  图片轮播
 */
-(void)loadAdvert:(NSArray *)bannerArr
{
    WS(weakSelf);
    
    self.cycleScrollView.fetchContentViewAtIndex=^UIView *(NSInteger pageIndex){
        
        NSString *imageUrl = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerImgPath;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, weakSelf.cycleScrollView.width, weakSelf.cycleScrollView.height)];
        //        imageview.image = [UIImage imageNamed:@"followus_bg480x800"];
        if (!imageUrl) {
            imageview.image = WEIMI_PLACEHOLDER_COMMON;
        }else
        {
            [imageview sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(imageUrl)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        }
        
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        
        if (!bannerArr.count) {
            return 1;
        }
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        SS(strongSelf);
        [WeiMiPageSkipManager skipIntoWebVC:strongSelf title:@"链接" url:((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerUrl                                                                popWithBaseNavColor:YES];
    };
}

//---- 帖子列表 （男生女生）
- (void)getInvitationListIsMale:(BOOL)isMale
{
    WeiMiBaseRequest *request;
    WeiMiMaleInvitationResponse *res = [[WeiMiMaleInvitationResponse alloc] init];
    ;
    if (isMale) {
        request = [[WeiMiMaleInvitationRequest alloc] initWithIsAble:nil pageIndex:1 pageSize:2];
    }else
    {
        request = [[WeiMiFemaleInvitationRequest alloc] initWithIsAble:nil pageIndex:1 pageSize:2];
    }
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];

        if (res.dataArr.count) {
            if (isMale) {//男生撸啊撸
                
                _maleInvitationArr = res.dataArr;
            }else{//女生悄悄话
                
                _femaleInvitaionArr = res.dataArr;
            }
        }
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:isMale?4:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//------ 男生女生栏目轮播加载
- (void)getItemBannerWithNavID:(NSString *)navID
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] initWithIsAble:navID];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        if ([navID isEqualToString:kMaleTag]) {//男生专区
            
            [_maleFemaleBannerDic setObject:res.dataArr forKey:kMaleTag];
        }else if ([navID isEqualToString:kFemaleTag])//女生专区
        {
            [_maleFemaleBannerDic setObject:res.dataArr forKey:kFemaleTag];
        }else if([navID isEqualToString:@"101"] || [navID isEqualToString:@"102"]){ // 男生小图1、2
            for (WeiMiHomePageBannerDTO *model in res.dataArr) {
                [_maleImageInfos addObject:model];
            }
        } else if([navID isEqualToString:@"201"] || [navID isEqualToString:@"202"]){ // 女生小图1、2
            for (WeiMiHomePageBannerDTO *model in res.dataArr) {
                [_femaleImageInfos addObject:model];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

@end
