//
//  WeiMiSexualVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSexualVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiUserCenter.h"

#import "WeiMiChangeGenderRequest.h"
@interface WeiMiSexualVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    BOOL _male;
    __block BOOL _setSuccess;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UIButton *selectButtonFAC;

@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation WeiMiSexualVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _male = [[WeiMiUserCenter sharedInstance].userInfoDTO.gender isEqualToString:@"男"] ? YES:NO;
        _dataSource = @[@"男",
                        @"女"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"性别";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];

        [strongSelf BackToLastNavi];
    }];
    

    [self AddRightBtn:@"完成" normal:nil selected:nil action:^{
        SS(strongSelf);
//        [strongSelf presentSheet:@"保存成功"];
//        _setSuccess = YES;
        
        [self changeGenderWithPhone:[WeiMiUserCenter sharedInstance].userInfoDTO.tel sex:_male ? @"男":@"女"];
    }];
}

- (BOOL)controllerWillPopHandler
{
    if (_setSuccess) {
//        [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiSexualVC" params:@[_male ? @1:@0]];
//        [WeiMiUserCenter sharedInstance].userInfoDTO.gender = _male ? @"男":@"女";
    }

    return YES;
}

- (UILabel *)footerLabel
{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] init];
        _footerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _footerLabel.text = @"性别设置后不可更改";
        _footerLabel.textColor = kGrayColor;
        _footerLabel.numberOfLines = 2;
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.font = [UIFont fontWithName:@"Arial" size:14];
    }

    return _footerLabel;
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

#pragma mark -Actions
//- (void)onButton:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.tag == 8888) {
//        _male = sender.selected ? YES:NO;
//    }else
//    {
//       _male = sender.selected ? NO:YES;
//    }
//    [_tableView reloadData];
//}


#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.scrollToHidenKeyBorad = YES;
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


#pragma mark - Actions

#pragma mark - NetWork
// -------- sex ? 男 ： 女
- (void)changeGenderWithPhone:(NSString *)phone sex:(NSString *)sex
{
    WeiMiChangeGenderRequest *request = [[WeiMiChangeGenderRequest alloc] initWithMemberId:phone sex:sex];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [WeiMiUserCenter sharedInstance].userInfoDTO.gender = sex;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        cell.textLabel.textColor = kGrayColor;
        cell.textLabel.text = _dataSource[indexPath.row];
        
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
    
    UIButton *BTN = [cell viewWithTag:8888 + indexPath.row];
    if (BTN) {
        if (indexPath.row == 0) {
            BTN.selected = _male ? YES:NO;
        }else
        {
            BTN.selected = _male ? NO:YES;
        }
    }
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 47;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIButton *sender = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:8888 + indexPath.row];
    if (sender) {
        sender.selected = !sender.selected;
        if (sender.tag == 8888) {
            _male = sender.selected ? YES:NO;
        }else
        {
            _male = sender.selected ? NO:YES;
        }
        [_tableView reloadData];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerLabel;
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
