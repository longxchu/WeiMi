//
//  WeiMiLoveStatuVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLoveStatuVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiUserDefaultConfig.h"
#import "WeiMiUserCenter.h"

#import "WeiMiChangeMarriageRequest.h"
@interface WeiMiLoveStatuVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSIndexPath *_selectedPath;
    
    __block BOOL _save;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UISwitch * cellSwitch;

@end

@implementation WeiMiLoveStatuVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedPath = [NSIndexPath new];
        _dataSource = @[@[@"单身",
                          @"恋爱中",
                          @"已婚",
                          @"离异/丧偶"],
                        @[@"保密"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block NSInteger index = 0;
    [(NSArray *)(_dataSource[0]) enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:[WeiMiUserCenter sharedInstance].userInfoDTO.marriageStats]) {
            index = idx;
        }
    }];
    _selectedPath = [NSIndexPath indexPathForRow:index inSection:0];
//    _name = [self.params objectForKey:@"nameStr"];
    
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];

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
    self.title = @"婚恋状态";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"保存" normal:nil selected:nil action:^{
        SS(strongSelf);

        _save = YES;
        
        if (_selectedPath.row >= 0 && _selectedPath.row <= 3) {
//            [strongSelf presentSheet:@"保存成功"];
//            [WeiMiUserDefaultConfig currentConfig].marriageStatsIdx_sec = _selectedPath.section;
//            [WeiMiUserDefaultConfig currentConfig].marriageStatsIdx_row = _selectedPath.row;
//            [WeiMiUserDefaultConfig currentConfig].marriageStats = _dataSource[_selectedPath.section][_selectedPath.row];
            
            [self changeGenderWithPhone:[WeiMiUserCenter sharedInstance].userInfoDTO.tel marital:_dataSource[_selectedPath.section][_selectedPath.row]];
        }else
        {
            [strongSelf presentSheet:@"请先选择一个选项"];
        }
    }];
}

#pragma mark - Getter
- (UISwitch *)cellSwitch
{
    if (!_cellSwitch) {
        _cellSwitch = [UISwitch defaultSwitch];
        [_cellSwitch addTarget:self action:@selector(onSwitcher:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellSwitch;
}

- (UIButton *)selectButtonFAC
{
    UIButton *BTN = [UIButton buttonWithType:UIButtonTypeCustom];
    BTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    //    [BTN setTitle:@"设为默认地址" forState:UIControlStateNormal];
    //    [BTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
    [BTN setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
    [BTN setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
    //    [BTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    return BTN;
}

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

#pragma mark - NetWork
- (void)changeGenderWithPhone:(NSString *)phone marital:(NSString *)marital
{
    WeiMiChangeMarriageRequest *request = [[WeiMiChangeMarriageRequest alloc] initWithMemberId:phone marital:marital];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [WeiMiUserCenter sharedInstance].userInfoDTO.marriageStats = marital;
            [strongSelf presentSheet:@"修改成功" complete:^{
                [strongSelf BackToLastNavi];
            }];
            
        }else
        {
            [strongSelf presentSheet:@"修改失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}


#pragma mark - Actions
- (void)onSwitcher:(UISwitch *)switcher
{
    if (!switcher.on) {
        [self presentSheet:@"关闭保密"];
        return;
    }
    [self presentSheet:@"开启保密"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_dataSource[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
        
        if (indexPath.section == 1)
        {
            [cell.contentView addSubview:self.cellSwitch];
            [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }else
        {
            UIButton *BTN = self.selectButtonFAC;
            BTN.userInteractionEnabled = NO;
            BTN.tag = 8888 + indexPath.row;
            
            if (indexPath.row == 0) {
                BTN.selected = YES;
            }
            [cell.contentView addSubview:BTN];
            
            [BTN mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }
    }
    UIButton *BTN = [cell viewWithTag:8888 + indexPath.row];
    if (BTN) {
        if (indexPath == _selectedPath) {
            BTN.selected = YES;
        }else
        {
            BTN.selected = NO;
        }
    }
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 60;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [UILabel footerNotiLabelWithTitle:@"请选择您的婚恋状况" textAlignment:NSTextAlignmentCenter];
    }
    return [UILabel footerNotiLabelWithTitle:@"开启保密后，此项资料将不会出现在您的个人页\n面中" textAlignment:NSTextAlignmentCenter];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 1) {
        _selectedPath = indexPath;
    }

    [tableView reloadData];
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
