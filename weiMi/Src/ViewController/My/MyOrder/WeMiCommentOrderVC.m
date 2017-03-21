//
//  WeMiCommentOrderVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeMiCommentOrderVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiCommentStarView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <OHActionSheet.h>
#import "PECropViewController.h"
#import "UIImage+Resize.h"
#import "UIButton+CenterImageAndTitle.h"


#define MAX_LIMIT_NUMS  140
@interface WeMiCommentOrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    
    UIImage *_processImage;

}

@property (nonatomic, strong) WeiMiCommentStarView *discribeStarView;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *addCommentBTN;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *wordNumLB;

@property (nonatomic, strong) UIView *grayBGView;
@property (nonatomic, strong) WeiMiCommentStarView *attituStarView;
@property (nonatomic, strong) WeiMiCommentStarView *speedStarView;

@property (nonatomic, strong) UIButton *anonymousCommentBTN;

@end

@implementation WeMiCommentOrderVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"row1",
                        @"row2",];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
//    _tableView.frame = self.contentFrame;
    [self.contentView addSubview:self.addCommentBTN];
    
    self.view.backgroundColor = _tableView.backgroundColor;
    [self.view setNeedsUpdateConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"评价订单";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (UIButton *)anonymousCommentBTN
{
    if (!_anonymousCommentBTN) {
        _anonymousCommentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _anonymousCommentBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_anonymousCommentBTN sizeToFit];
        _anonymousCommentBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_anonymousCommentBTN setTitle:@"匿名评论" forState:UIControlStateNormal];
        [_anonymousCommentBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_anonymousCommentBTN setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_anonymousCommentBTN setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        [_anonymousCommentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _anonymousCommentBTN;
}

- (WeiMiCommentStarView *)discribeStarView
{
    if (!_discribeStarView) {
        _discribeStarView = [[WeiMiCommentStarView alloc] initWithFrame:CGRectZero startNum:5];
    }
    return _discribeStarView;
}

- (WeiMiCommentStarView *)attituStarView
{
    if (!_attituStarView) {
        _attituStarView = [[WeiMiCommentStarView alloc] initWithFrame:CGRectZero startNum:5];
    }
    return _attituStarView;
}

- (WeiMiCommentStarView *)speedStarView
{
    if (!_speedStarView) {
        _speedStarView = [[WeiMiCommentStarView alloc] initWithFrame:CGRectZero startNum:5];
    }
    return _speedStarView;
}


- (UILabel *)wordNumLB
{
    if (!_wordNumLB) {
        
        _wordNumLB = [[UILabel alloc] init];
        _wordNumLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        [_wordNumLB sizeToFit];
        _wordNumLB.textAlignment = NSTextAlignmentRight;
        _wordNumLB.text = @"140";
        _wordNumLB.textColor = kGrayColor;
    }
    return _wordNumLB;
}

- (UILabel *)rightLabelFAC
{
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.textColor = kGrayColor;
    
    return detailLabel;
}

- (UIButton *)addCommentBTN
{
    if (!_addCommentBTN) {
        
        _addCommentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _addCommentBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_addCommentBTN setTitle:@"提交评论" forState:UIControlStateNormal];
        [_addCommentBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addCommentBTN setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addCommentBTN setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addCommentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCommentBTN;
}

- (UIView *)grayBGView
{
    if (!_grayBGView) {
        
        _grayBGView = [[UIView alloc] init];
        _grayBGView.backgroundColor = HEX_RGB(0xF5F5F5);
    }
    return _grayBGView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton sizeToFit];
//        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_addButton setTitleColor:kGrayColor forState:UIControlStateNormal];
//        [_addButton setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_addButton setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1.;
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.cornerRadius = 5;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = YES;
        _textView.placeholder = @"说说你和这几件小物的故事吧";
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    }
    return _textView;
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
    if (indexPath.row == 0) {
        static NSString *cellID = @"cell_0";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.textLabel.font = [UIFont systemFontOfSize:15];
            //        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        //        cell.detailTextLabel.textColor = kGrayColor;
            //        cell.imageView.image = [UIImage imageNamed:safeObjectAtIndex(_imgArr, indexPath.row)];
            //        cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row);
            UILabel *label = [self rightLabelFAC];
            [label sizeToFit];
            label.tag = 8888 + indexPath.row;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(cell.imageView).offset(5);
                make.left.mas_equalTo(cell.imageView.mas_right).offset(10);
            }];
            

            [cell.contentView addSubview:self.discribeStarView];
            [_discribeStarView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(label);
                make.width.mas_equalTo(165);
                make.height.mas_equalTo(40);
                make.top.mas_lessThanOrEqualTo(label.mas_bottom);
                make.bottom.mas_equalTo(cell.imageView.mas_bottom).offset(-5);
            }];
        }
        
        UILabel *LB = [cell viewWithTag:8888+indexPath.row];
        if (LB) {
            LB.text = @"描述相符";
        }
        cell.imageView.image = [UIImage imageNamed:@"followus_bg480x800"];
        //重绘image大小来 调整imageView大小
        CGSize itemSize = CGSizeMake(75, 75);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return cell;
    }
    
    static NSString *cellID = @"cell_1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.textView];
        [cell.contentView addSubview:self.addButton];
        [cell.contentView addSubview:self.wordNumLB];
        [cell.contentView addSubview:self.grayBGView];
        //服务态度
        UILabel *attLabel = [self rightLabelFAC];
        [attLabel sizeToFit];
        attLabel.tag = 8888 + indexPath.row;
        attLabel.text = @"服务态度";
        [self.grayBGView addSubview:attLabel];
        [attLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
        }];
        
        //发货速度
        UILabel *speedLB = [self rightLabelFAC];
        [speedLB sizeToFit];
        speedLB.tag = 9999 + indexPath.row;
        speedLB.text = @"发货速度";
        [self.grayBGView addSubview:speedLB];
        [speedLB mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(attLabel);
        }];
        
        [self.grayBGView addSubview:self.attituStarView];
        [_attituStarView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(attLabel);
            make.width.mas_equalTo(165);
            make.height.mas_equalTo(48);
        }];
        
        [self.grayBGView addSubview:self.speedStarView];
        [_speedStarView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(speedLB);
            make.width.mas_equalTo(165);
            make.height.mas_equalTo(48);
        }];
        
        [cell.contentView addSubview:self.anonymousCommentBTN];
        [_anonymousCommentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(110);
            make.top.mas_equalTo(_grayBGView.mas_bottom).offset(40);
        }];
        
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 400;
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

#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.wordNumLB.text = [NSString stringWithFormat:@"%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == self.anonymousCommentBTN) {
        sender.selected = !sender.selected;
        return;
    }
    
    if (sender == _addCommentBTN) {
        [self presentSheet:@"评论成功"];
        [self performSelector:@selector(BackToLastNavi) withObject:nil afterDelay:0.5];
        return;
    }
    
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
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = [_processImage resizedImage:CGSizeMake(100, 100)
                                  interpolationQuality:kCGInterpolationLow]; //要添加的图片
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [string appendAttributedString:textAttachmentString];//index为用户指定要插入图片的位置
    _textView.attributedText = string;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_anonymousCommentBTN horizontalCenterTitleAndImage:10];
}

- (void)updateViewConstraints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + NAV_HEIGHT);
        make.bottom.mas_equalTo(_addCommentBTN.mas_top);
    }];
    
    [_addCommentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12.5);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(_wordNumLB.mas_left).offset(-10);
        make.height.mas_equalTo(145);
    }];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_textView);
        make.top.mas_equalTo(_textView.mas_bottom).offset(14);
    }];
    
    [_wordNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_textView);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(30);
    }];
    
    [_grayBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addButton.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
