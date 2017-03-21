//
//  WeiMiAddressDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddressDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "LPHPickerHeader.h"
#import "WeiMiRecAddDTO.h"

//----- request
#import "WeiMiAddNewAddressRequest.h"

#define DEFAULT_BGCOLOR    (0xEEEEEE)
@interface WeiMiAddressDetailVC()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, CityViewDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    WeiMiRecAddDTO *_dto;
    __block BOOL _save;
    WeiMiAddNewAddressRequestModel *_model;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *addAddressBtn;

@property (nonatomic, strong) UITextField *textFiledFAC;
@property (nonatomic, strong) UITextView *textViewFAC;

@property(nonatomic,strong)CityView * cityPickerView;

@end

@implementation WeiMiAddressDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[WeiMiAddNewAddressRequestModel alloc] init];
        _dto = [[WeiMiRecAddDTO alloc] init];
        _dataSource = @[
                        @"收货人姓名",
                        @"手机号码",
                        @"省,市,区",
//                        @"街道",
//                        @"邮政编码",
                        @"详细地址"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(DEFAULT_BGCOLOR);
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.addAddressBtn];
    
    [self.view setNeedsUpdateConstraints];

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)controllerWillPopHandler
{
    CallBackHandler block = self.callBackHandler;
    if (block && _save) {
        block(_dto);
    }
    return YES;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"新增收货地址";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        CallBackHandler block = strongSelf.callBackHandler;
        if (block && _save) {
            block(_dto);
        }
        [strongSelf BackToLastNavi];
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
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.borderStyle = UITextBorderStyleNone;
    textFiled.textAlignment = NSTextAlignmentLeft;
    textFiled.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    textFiled.delegate = self;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textFiled;
}

- (UITextView *)textViewFAC
{
    UITextView *textView = [[UITextView alloc] init];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    return textView;
}

- (UIButton *)addAddressBtn
{
    if (!_addAddressBtn) {
        
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_addAddressBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addAddressBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.scrollToHidenKeyBorad = YES;
        _tableView.backgroundColor = HEX_RGB(DEFAULT_BGCOLOR);
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

#pragma mark - Network
//---- 新增收货地址
- (void)addNewAddress:(WeiMiAddNewAddressRequestModel *)model
{
    WeiMiAddNewAddressRequest *request = [[WeiMiAddNewAddressRequest alloc] initWithModel:model];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {

            [self presentSheet:@"添加成功"];
            _save = YES;
        }else
        {
            [self presentSheet:@"添加失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    if (!_model.userName || !_model.userPhone || !_model.province || !_model.city
        || !_model.county || !_model.street) {
        
        [self presentSheet:@"请将信息填写完整"];
    }else
    {
        [self addNewAddress:_model];
    }
//    [self presentSheet:@"保存成功"];
//    _save = YES;
}


#pragma mark - CityViewDelegate
-(void)cityViewWithTitle:(NSString *)string{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    UITextField *field = [cell viewWithTag:8888 + 2];
    if (field) {
        field.text = string;
    }
}

- (void)cityviewWIthProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    _dto.province = province;
    _dto.city = city;
    _dto.county = district;
    
    _model.province = province;
    _model.city = city;
    _model.county = district;
}

#pragma mark - UitextDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 8888 + 0) {
        
        _dto.name = textField.text;
        _model.userName = textField.text;
    }else if (textField.tag == 8888 + 1)
    {
        _dto.tel = textField.text;
        _model.userPhone = textField.text;
    }else if (textField.tag == 8888 + 2)
    {
//        _dto.name = textField.text;
    }else if (textField.tag == 8888 + 3)
    {
        _dto.street = textField.text;
    }else if (textField.tag == 8888 + 4)
    {
        _dto.postalcode = textField.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _dto.street = textView.text;
    _model.street = textView.text;
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
    static NSString *cellID = @"recAddCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        /// 添加标题label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 7777 + indexPath.row;
        titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(cell);
        }];
        
//        if (indexPath.row != 2 && indexPath.row != 3) {
        if (indexPath.row != 2) {

            cell.textLabel.textColor = kGrayColor;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == _dataSource.count -1) {
            UITextView *textView = self.textViewFAC;
            textView.tag = 6666 + indexPath.row;
            [cell.contentView addSubview:textView];
            
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(5);
                make.bottom.mas_equalTo(-5);
                make.right.mas_equalTo(-15);
                make.left.mas_equalTo(titleLabel.mas_right).offset(15);
            }];
            
        }else
        {
            UITextField *textFiled = self.textFiledFAC;
            textFiled.tag = 8888 + indexPath.row;
            [cell.contentView addSubview:textFiled];
            
            if (indexPath.row == 1 || indexPath.row == 4) {
                textFiled.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(5);
                make.bottom.mas_equalTo(-5);
                make.right.mas_equalTo(-15);
                make.left.mas_equalTo(titleLabel.mas_right).offset(15);
            }];
            if (indexPath.row == 2 || indexPath.row == 3) {
                [textFiled setUserInteractionEnabled:NO];
            }
        }
        
    }
    
    UITextField *field = [cell viewWithTag:8888 + indexPath.row];
    if (field) {

    }
    
    UITextView *textView = [cell viewWithTag:6666 + indexPath.row];
    if (textView) {
        
    }
    
    UILabel *label = [cell viewWithTag:7777 + indexPath.row];
    if (label) {
        label.text = [_dataSource objectAtIndex:indexPath.row];
    }

  
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataSource.count - 1) {
        return 120;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if (cell) {
            for (UIView *view in cell.contentView.subviews) {
                [view resignFirstResponder];
            }
        }
    }];
    
    if (indexPath.row == 2) {
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
