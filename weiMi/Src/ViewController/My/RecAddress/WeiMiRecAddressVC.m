//
//  WeiMiRecAddressVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRecAddressVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMIRecAddCell.h"
#import "WeiMiAddressDetailVC.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiAddressEditVC.h"

//----- request
#import "WeiMiAddressListRequest.h"
#import "WeiMiAddressListResponse.h"
#import "WeiMiSetDefaultAddressRequest.h"
#import "WeiMiDeleteAdressRequest.h"
@interface WeiMiRecAddressVC()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
//    NSMutableArray *_dataSource;
    __block NSInteger _defaultAdd;

}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *addAddressBtn;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@interface WeiMiRecAddressVC ()

@end

@implementation WeiMiRecAddressVC

- (instancetype)init
{
    self = [super init];
    if (self) {

        _defaultAdd = -1;

        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
    // ---- 呵呵接口没返回ID让我怎么回调，只能进页面就刷新咯无奈
    [self getAddressList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.addAddressBtn];
    
    [self.view setNeedsUpdateConstraints];
    
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    
//    [self getAddressList];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"收货地址管理";
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
        _notiView  = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_address" title:@"还没有收货地址哦~"];
    }
    return _notiView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
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

- (UIButton *)addAddressBtn
{
    if (!_addAddressBtn) {
        
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
//        _addAddressBtn.layer.masksToBounds = YES;
//
//        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addAddressBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

#pragma mark - Network
//---- 获取收货地址列表
- (void)getAddressList
{
    WeiMiAddressListRequest *request = [[WeiMiAddressListRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel];
    WeiMiAddressListResponse *response = [[WeiMiAddressListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [[self mutableArrayValueForKey:@"dataSource"] removeAllObjects];
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:response.dataArr];
            [strongSelf.tableView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//----- 设置默认收货地址
- (void)setDefaultAddress:(NSString *)addressId section:(NSInteger)section
{
    WeiMiSetDefaultAddressRequest *request = [[WeiMiSetDefaultAddressRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel addressId:addressId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);

        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        
        if ([result isEqualToString:@"1"]) {
            [strongSelf presentSheet:@"设置成功"];
            
            _defaultAdd = section;
            [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx == _defaultAdd) {
                    ((WeiMiRecAddDTO *)obj).isDefault = YES;
                }else{
                    ((WeiMiRecAddDTO *)obj).isDefault = NO;
                }
            }];
            
            [_tableView reloadData];
            
        }else
        {
            [strongSelf presentSheet:@"设置失败"];
        }
        
        [_tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//---- 删除收货地址
- (void)deleteAdress:(NSString *)addressId cell:(WeiMIRecAddCell *)cell
{
    WeiMiDeleteAdressRequest *request = [[WeiMiDeleteAdressRequest alloc] initWithAddressId:addressId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {

            NSIndexPath *path = [_tableView indexPathForCell:cell];
            [[self mutableArrayValueForKey:@"dataSource"] removeObjectAtIndex:path.section];
            [_tableView beginUpdates];
            [_tableView deleteSections:[[NSIndexSet alloc] initWithIndex:path.section] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
            [strongSelf presentSheet:@"删除成功"];
        }else
        {
            [strongSelf presentSheet:@"删除失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    WeiMiAddressDetailVC *vc = [[WeiMiAddressDetailVC alloc] init];
    WS(weakSelf);
//    vc.callBackHandler = ^(WeiMiRecAddDTO *dto){
//        SS(strongSelf);
//        [[strongSelf mutableArrayValueForKey:@"dataSource"] addObject:dto];
//        [strongSelf.tableView reloadData];
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id _oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id _newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (![_newValue isEqual:_oldValue])
    {
        if (_dataSource.count == 0) {
            
            [self.view addSubview:self.notiView];
            [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(self.view);
                make.width.mas_equalTo(self.view).multipliedBy(0.5);
                make.bottom.mas_equalTo(self.view.mas_centerY).offset(-20);
            }];
        }else
        {
            [_notiView removeFromSuperview];
        }

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"recAddressCell";
    
    WeiMIRecAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMIRecAddCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        WS(weakSelf);
        __weak typeof(cell) weakCell = cell;
        cell.onSetDefaultHandler = ^(UIButton *btn){//设置默认地址
            
            SS(strongSelf);
            [strongSelf setDefaultAddress:weakCell.dto.addressId section:indexPath.section];
        };
        
        cell.onEditHandler = ^{
            WeiMiAddressEditVC *vc = [[WeiMiAddressEditVC alloc] init];
            vc.dto = safeObjectAtIndex(_dataSource, indexPath.section);
            vc.dto.addressId = weakCell.dto.addressId;
            WS(weakSelf);
            
//            vc.callBackHandler = ^(WeiMiRecAddDTO *dto){
//                SS(strongSelf);
//                [[strongSelf mutableArrayValueForKey:@"dataSource"] replaceObjectAtIndex:indexPath.row withObject:dto];
//                [strongSelf.tableView reloadData];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.onDeleteHandler = ^{
            SS(strongSelf);
            
            [strongSelf deleteAdress:weakCell.dto.addressId cell:weakCell];
        };
    }
    
    
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.section)];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
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


#pragma mark - Layout
- (void)updateViewConstraints
{
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [super updateViewConstraints];
}


@end
