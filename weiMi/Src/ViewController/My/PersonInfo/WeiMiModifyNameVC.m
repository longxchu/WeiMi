//
//  WeiMiModifyNameVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/28.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiModifyNameVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiUserCenter.h"

//------- request
#import "WeiMiChangeNickNameRequest.h"

@interface WeiMiModifyNameVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    __block NSString *_name;
    __block BOOL _saveName;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UITextField *textFiledFAC;

@end

@implementation WeiMiModifyNameVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _name = [WeiMiUserCenter sharedInstance].userInfoDTO.userName;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    notiLabel.text = @"昵称一周内只能修改一次";
    notiLabel.textColor = kGrayColor;
    notiLabel.textAlignment = NSTextAlignmentCenter;
    notiLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.tableView.tableFooterView = notiLabel;
    
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
    self.title = @"更改昵称";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
//        [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"保存" normal:nil selected:nil action:^{
        SS(strongSelf);
        _name = strongSelf.textFiledFAC.text;
        if (_name) {
            _saveName = YES;
//            [strongSelf presentSheet:@"保存成功"];
            
            [self changeUserNameWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel userName:_name];
        }else
        {
            [strongSelf presentSheet:@"请输入用户名"];
        }

    }];
}

- (BOOL)controllerWillPopHandler
{
    if (_saveName) {
        [WeiMiUserCenter sharedInstance].userInfoDTO.userName = _name;
//        [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVCCB" params:@[_name]];
    }
    return YES;
}

#pragma mark - Getter
- (UITextField *)textFiledFAC
{
    if (!_textFiledFAC) {
        _textFiledFAC = [[UITextField alloc] init];
        _textFiledFAC.borderStyle = UITextBorderStyleNone;
        _textFiledFAC.textAlignment = NSTextAlignmentLeft;
        _textFiledFAC.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _textFiledFAC.delegate = self;
        _textFiledFAC.clearButtonMode = UITextFieldViewModeWhileEditing;
    }

    return _textFiledFAC;
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

#pragma mark - Actions

#pragma mark - NetWork
- (void)changeUserNameWithMemberId:(NSString *)memberId userName:(NSString *)userName
{
    WeiMiChangeNickNameRequest *request = [[WeiMiChangeNickNameRequest alloc] initWithMemberId:memberId userName:userName];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [WeiMiUserCenter sharedInstance].userInfoDTO.userName = userName;
            [strongSelf presentSheet:@"保存成功" complete:^{
                [strongSelf BackToLastNavi];
            }];
        }else
        {
            [strongSelf presentSheet:@"保存失败"];
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
    static NSString *cellID = @"giftCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
        UITextField *textFiled = self.textFiledFAC;
        textFiled.placeholder = @"请输入昵称";
        textFiled.tag = 8888 + indexPath.row;
        [cell.contentView addSubview:textFiled];
        
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
        }];
    }
    //根据Tag获得timeLabel
    UITextField *nameField = [cell.contentView viewWithTag:8888 + indexPath.row];
    if (nameField) {
        nameField.text = _name;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textFiledFAC resignFirstResponder];
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

@end
