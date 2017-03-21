//
//  WeiMiBirthVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBirthVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiUserDefaultConfig.h"
#import "dateView.h"
#import "WeiMiCalculateAgeTool.h"
#import "WeiMiUserCenter.h"

//---- request
#import "WeiMiChangeAgeRequest.h"
@interface WeiMiBirthVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, dateViewDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    
    NSMutableArray *_infoSource;
    
    __block BOOL _save;
    NSInteger _age;
    NSString *_ageStr;
    NSInteger _year;
    NSInteger _month;
    NSInteger _day;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UISwitch * cellSwitch;
@property(nonatomic,strong) dateView * datePickerView;
@property (nonatomic, strong) UIView *footerBGView;

@end

@implementation WeiMiBirthVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = @[@[@"年龄",
                          @"星座",],
                        @[@"保密"]];
        _infoSource = [NSMutableArray new];
        _age = [WeiMiUserCenter sharedInstance].userInfoDTO.age.integerValue;
        _year = [WeiMiUserDefaultConfig currentConfig].year.integerValue;
        _month = [WeiMiUserDefaultConfig currentConfig].month.integerValue;
        _day = [WeiMiUserDefaultConfig currentConfig].day.integerValue;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *age = [];
//    _infoSource = WeiMiUserDefaultConfig currentConfig].age;
    
    //    _name = [self.params objectForKey:@"nameStr"];
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
//    self.tableView.tableHeaderView = self.datePickerView;
    
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
    self.title = @"出生日期";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"保存" normal:nil selected:nil action:^{
        SS(strongSelf);
        
        _save = YES;
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell.detailTextLabel.text) {
            
            [self changeAge:_ageStr ageInt:cell.detailTextLabel.text];
        }else
        {
            [strongSelf presentSheet:@"请先选择出生日期"];
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

- (UIView *)footerBGView
{
    if (!_footerBGView) {
        _footerBGView = [[UIView alloc] init];
        _footerBGView.backgroundColor = kClearColor;
        
        UILabel *label = [UILabel footerNotiLabelWithTitle:@"开启保密后，此项资料将不会出现在您的个人页\n面中" textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        [_footerBGView addSubview:label];
        
        [_footerBGView addSubview:self.datePickerView];
    }
    return _footerBGView;
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

- (dateView *)datePickerView
{
    if (!_datePickerView) {
        _datePickerView = [[dateView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 150)];
        _datePickerView.delegate = self;
        if (_year != 0) {
            [_datePickerView selectYear:_year month:_month day:_day];
        }
    }
    return _datePickerView;
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

#pragma mark - NetWork
// -------- sex ? 男 ： 女
- (void)changeAge:(NSString *)age ageInt:(NSString *)ageInt
{
    WeiMiChangeAgeRequest *request = [[WeiMiChangeAgeRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel age:age];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [WeiMiUserCenter sharedInstance].userInfoDTO.age = ageInt;
            [WeiMiUserDefaultConfig currentConfig].year = [NSString stringWithFormat:@"%ld", _year];
            [WeiMiUserDefaultConfig currentConfig].month = [NSString stringWithFormat:@"%ld", _month];
            [WeiMiUserDefaultConfig currentConfig].day = [NSString stringWithFormat:@"%ld", _day];
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


#pragma mark - dateViewDelegate
-(void)dateViewWithTitle:(NSString * )string
{
    _ageStr = string;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        NSInteger age = (long)[WeiMiCalculateAgeTool ageWithDateStringOfBirth:string];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", age == 0 ? 1:age];
    }
}

- (void)dateViewWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    _year = year;
    _month = month;
    _day = day;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell) {
        cell.detailTextLabel.text = [WeiMiCalculateAgeTool getConstellationWithMonth:month day:day];
    }
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
        if (indexPath.section == 1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            [cell.contentView addSubview:self.cellSwitch];
            [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.detailTextLabel.textColor = kGrayColor;
            cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        }
        //        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
        
        
    }
    
//    if (indexPath.section != 1) {
//        cell.detailTextLabel.text = @"23";
//    }
    
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
        return 210;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [UILabel footerNotiLabelWithTitle:@"输入您的出生日期，系统会自动算出您的年龄和星座，您的个人主页中，自会显示年龄和星座，不会显示具体的出生日期。" textAlignment:NSTextAlignmentCenter];
    }
    return self.footerBGView;
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


@end
