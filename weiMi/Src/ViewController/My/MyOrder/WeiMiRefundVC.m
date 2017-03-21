//
//  WeiMiRefundVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRefundVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiRefundCell.h"
#import "WeiMiOrderUploadCerView.h"
#import "WeiMiBaseView.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiSelecteRefundReason.h"
#import <OHActionSheet.h>
#import "PECropViewController.h"
#import "UIImage+Resize.h"
#import "NSMutableAttributedString+OHAdditions.h"

@interface WeiMiRefundVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,
UITextViewDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_titleSource;
    __block CGSize _lastCellSize;
    
    UIImage *_processImage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *addAddressBtn;
@property (nonatomic, strong) WeiMiBaseView *tableFooterView;
@property (nonatomic, strong) WeiMiOrderUploadCerView *uploadView;
@end

@implementation WeiMiRefundVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@[@"我要退款（无需退货）",@"我要退货"],
                        @[@"未收到货",@"已收到货"],
                        @[@"退款原因"],
                        @[@"退款金额"],
                        @[@"请输入退款说明"]];
        _titleSource = @[@"退款类型*",
                         @"收货状态*",
                         @"退款原因*不可修改",
                         @"退款金额*",
                         @"退款说明(可不填)"];
        _lastCellSize = CGSizeZero;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
//    _tableView.frame = self.contentFrame;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.contentView addSubview:self.addAddressBtn];
    self.view.backgroundColor = _tableView.backgroundColor;
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
    self.title = @"申请退款";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (WeiMiBaseView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[WeiMiBaseView alloc] init];
        _tableFooterView.backgroundColor = kClearColor;
        [_tableFooterView addSubview:self.uploadView];
        
//        WeiMiRefundCell *cell = [[WeiMiRefundCell alloc] initWithType:REFUNDCELLTYPE_TEXTVIEWONLY reuseIdentifier:@"WeiMiRefundCell"];
//        cell.textView.placeholder =

//        [_uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.centerY.mas_equalTo(_uploadView);
//            make.left.mas_equalTo(15);
//            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(_tableFooterView).multipliedBy(0.75);
//        }];
    }
    return _tableFooterView;
}

- (WeiMiOrderUploadCerView *)uploadView
{
    if (!_uploadView) {
        
        _uploadView = [[WeiMiOrderUploadCerView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, GetAdapterHeight(45))];
        [_uploadView addTarget:self action:@selector(onUploadBTN:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [_addAddressBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addAddressBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

#pragma mark - Actions
- (void)onUploadBTN:(WeiMiOrderUploadCerView *)button
{
    [OHActionSheet showFromView:self.view title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择",@"拍照"] completion:^(OHActionSheet *sheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 1:
            {
                [self openCamera];
            }
                break;
            case 0:
            {
                [self openPhoto];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)onButton:(UIButton *)button
{

    [self presentSheet:@"提交申请"];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //    ShouldChangeTextHandler block = self.shouldChangeTextHandler;
    //    if (block) {
    //        block(textView.contentSize);
    //    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (CGSizeEqualToSize(_lastCellSize, CGSizeZero)) {
        _lastCellSize = CGSizeMake(SCREEN_WIDTH, GetAdapterHeight(100));

    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    return YES;
}

#pragma mark - Util
- (NSMutableAttributedString *)attrWithPrefix:(NSString *)prefix suff:(NSString *)suff asterisk:(BOOL)enable
{
    NSString *str;
    NSRange range;
    if (enable) {
        str = [NSString stringWithFormat:@"%@*%@",prefix, suff == nil ? @"":suff];
        range = NSMakeRange(prefix.length + 1, suff.length);
    }else
    {
        str = [NSString stringWithFormat:@"%@%@",prefix, suff == nil ? @"":suff];
        range = NSMakeRange(prefix.length, suff.length);
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.firstLineHeadIndent = 15;
    paraStyle.headIndent = 15;//左缩进
    
    NSMutableAttributedString *prefixAtt = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                                                        NSFontAttributeName:WeiMiSystemFontWithpx(22),
                                                        NSForegroundColorAttributeName:kBlackColor,
                                                        NSParagraphStyleAttributeName:paraStyle}];
    [prefixAtt setTextColor:kRedColor range:NSMakeRange(prefix.length, 1)];
    if (enable) {
        [prefixAtt setFont:WeiMiSystemFontWithpx(20) range:NSMakeRange(prefix.length + 1, suff.length)];
    }else
    {
        [prefixAtt setFont:WeiMiSystemFontWithpx(20) range:range];
    }
    [prefixAtt setTextColor:kGrayColor range:range];
    
    return prefixAtt;
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
    if (indexPath.section == 0 || indexPath.section == 1) {
        static NSString *cellID = @"cell0|1";
        
        WeiMiRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiRefundCell alloc] initWithType:REFUNDCELLTYPE_LABELRIGHTBUTTON reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = kClearColor;
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
            cell.textLabel.text = safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row);
            
            cell.onCellHandler = ^{
                WeiMiRefundCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:-(indexPath.row - 1) inSection:indexPath.section]];
                if (cell) {
                    [cell cellOff];
                }
            };
        }
        return cell;
    }else if (indexPath.section == 2) {
        static NSString *cellID = @"cell2";
        
        WeiMiRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiRefundCell alloc] initWithType:REFUNDCELLTYPE_TEXTVIEWIGHTBUTTON reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = kClearColor;
            cell.textView.placeholder = safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row);
        }
        return cell;
    }else if (indexPath.section == 3 || indexPath.section == 4) {

        WeiMiRefundCell *cell;
        if (!cell) {
            if (indexPath.section == 3) {
                static NSString *cellID = @"cell3";
                
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                cell = [[WeiMiRefundCell alloc] initWithType:REFUNDCELLTYPE_TEXTVIEWONELINE reuseIdentifier:cellID];
                cell.textField.placeholder = safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row) ;
            }else
            {
                static NSString *cellID = @"cell4";
                
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                cell = [[WeiMiRefundCell alloc] initWithType:REFUNDCELLTYPE_TEXTVIEWONLY reuseIdentifier:cellID];
                cell.tag = 8888;
                cell.textView.placeholder = safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row);
                cell.delegate = self;
            }
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = kClearColor;

        }
        return cell;
    }
    
    static NSString *cellID = @"cell";
    
    WeiMiRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiRefundCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = kClearColor;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.textLabel.text = safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row);
        
    }
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return _titleSource[section];
//}

#pragma mark - UITabelViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"headerViewId";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        UILabel *footer = [UILabel footerNotiLabelWithTitle:_titleSource[section] textAlignment:NSTextAlignmentLeft];
        footer.font = WeiMiSystemFontWithpx(20);
        footer.textColor =kBlackColor;
        
        switch (section) {
            case 0:
                footer.attributedText = [self attrWithPrefix:@"退款类型" suff:nil asterisk:YES];
                break;
            case 1:
                footer.attributedText = [self attrWithPrefix:@"收货状态" suff:nil asterisk:YES];
                break;
            case 2:
                footer.attributedText = [self attrWithPrefix:@"退款原因" suff:@"不可修改" asterisk:YES];
                break;
            case 3:
                footer.attributedText = [self attrWithPrefix:@"退款金额" suff:nil asterisk:YES];
                break;
            case 4:
                footer.attributedText = [self attrWithPrefix:@"退款说明" suff:@"(可不填)" asterisk:NO];
                break;
            default:
                break;
        }

        [footer sizeToFit];
        [header addSubview:footer];
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(header).offset(5);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        if (_lastCellSize.height == 0) {
            return 45;
        }
        return _lastCellSize.height;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return self.tableFooterView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return GetAdapterHeight(80);
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        WeiMiSelecteRefundReason *selectReason = [WeiMiSelecteRefundReason shareInstance];
        [selectReason showWithTitles:@[@"退款原因",
                                      @"空包裹",
                                      @"快递/物流一直未送到",
                                       @"快递/物流无跟踪记录"]];
        __weak typeof(tableView) weakTB = tableView;
        selectReason.seletedIndex = ^(NSInteger idx, NSString *str)
        {
            __strong typeof(tableView) strongTB = weakTB;
            WeiMiRefundCell *cell = [strongTB cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.textView.text = str;
            }
        };
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

#pragma mark - 头像获取
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)openPhoto {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = _processImage;
    
    UIImage *image = _processImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - pickerImage Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _processImage = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  PECropViewControllerDelegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    _processImage = croppedImage;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)updateViewConstraints
{
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(NAV_HEIGHT + STATUS_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_addAddressBtn.mas_top);
    }];
    [super updateViewConstraints];
}


@end
