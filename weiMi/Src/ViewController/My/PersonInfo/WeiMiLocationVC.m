//
//  WeiMiLocationVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLocationVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiUserCenter.h"
//#import "WeiMiUserDefaultConfig.h"
#import "CityView.h"

#import "WeiMiChangeLocationRequest.h"
@interface WeiMiLocationVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CityViewDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    
    __block BOOL _save;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UISwitch * cellSwitch;
@property(nonatomic,strong) CityView * cityPickerView;
@property (nonatomic, strong) UITextField *textFiledFAC;

@end

@implementation WeiMiLocationVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = @[@[@"单身"],
                        @[@"保密"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.title = @"所在地";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"保存" normal:nil selected:nil action:^{
        SS(strongSelf);
        
        _save = YES;
        
        if (_textFiledFAC.text) {
//            [strongSelf presentSheet:@"保存成功"];
//            [WeiMiUserDefaultConfig currentConfig].location = _textFiledFAC.text;
            [self changeLocationWithPhone:[WeiMiUserCenter sharedInstance].userInfoDTO.tel location:_textFiledFAC.text];
        }else
        {
            [strongSelf presentSheet:@"请先选择所在地"];
        }
    }];
}

#pragma mark - Getter
-(CityView *)cityPickerView{
    if (!_cityPickerView) {
        _cityPickerView = [[CityView alloc]initWithFrame:self.view.bounds];
        _cityPickerView.delegate = self;
    }
    return _cityPickerView;
}


- (UITextField *)textFiledFAC
{
    if (!_textFiledFAC) {
        _textFiledFAC = [[UITextField alloc] init];
        _textFiledFAC.placeholder = @"请选择所在地";
        _textFiledFAC.borderStyle = UITextBorderStyleNone;
        _textFiledFAC.textAlignment = NSTextAlignmentLeft;
        _textFiledFAC.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _textFiledFAC.delegate = self;
        _textFiledFAC.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _textFiledFAC;
}

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
    BTN.titleLabel.font = [UIFont systemFontOfSize:16];
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
- (void)changeLocationWithPhone:(NSString *)phone location:(NSString *)location
{
    WeiMiChangeLocationRequest *request = [[WeiMiChangeLocationRequest alloc] initWithMemberId:phone location:location];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [WeiMiUserCenter sharedInstance].userInfoDTO.location = location;
            [strongSelf presentSheet:@"保存成功" complete:^{
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

#pragma mark - CityViewDelegate
-(void)cityViewWithTitle:(NSString *)string{
    
    _textFiledFAC.text = string;
}

- (void)cityviewWIthProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
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

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
//        cell.textLabel.textColor = kGrayColor;
        
        if (indexPath.section == 1)
        {
             cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.cellSwitch];
            [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }else
        {
            [cell.contentView addSubview:self.textFiledFAC];
            self.textFiledFAC.userInteractionEnabled = NO;
            [_textFiledFAC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell);
                make.left.mas_equalTo(20);
            }];
        }
    }
    
    if ([WeiMiUserCenter sharedInstance].userInfoDTO.location) {
        _textFiledFAC.text = [WeiMiUserCenter sharedInstance].userInfoDTO.location;
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
        return [UILabel footerNotiLabelWithTitle:@"请选择您的所在地" textAlignment:NSTextAlignmentCenter];
    }
    return [UILabel footerNotiLabelWithTitle:@"开启保密后，此项资料将不会出现在您的个人页\n面中" textAlignment:NSTextAlignmentCenter];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.view addSubview:self.cityPickerView];
    }
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
