//
//  WeiMiPersonInfoVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPersonInfoVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiUserCenter.h"
#import "WeiMiModifyNameVC.h"
//----- category
#import "UINavigationController+StatuBarStyle.h"
#import "WeiMiUserDefaultConfig.h"
//----- third
#import <OHActionSheet.h>
#import "PECropViewController.h"
#import "UIButton+WebCache.h"

//----- request
#import "WeiMiUpdateImgRequest.h"
#import "YTKChainRequest.h"
#import "WeiMiChangeAvaterRequest.h"
//个人资料完成度
#import "WeiMiCreditInfoCompleteRateRequest.h"

@interface WeiMiPersonInfoVC()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate, YTKChainRequestDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_titleArr;
    UIImage *_processImage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UILabel *completenessLabel;
@property (nonatomic, strong) UIButton *headBtn;

@end

@implementation WeiMiPersonInfoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleArr = @[
                      @[@"头像", @"昵称"],
                      @[@"账号与安全"],
                      @[@"性别",@"年龄",@"婚恋情况",@"所在地"],
                      ];
        _dataSource = @[
                        @[@"头像", @"用户名"],
                        @[@"存在风险"],
                        @[@"待完善",@"待完善",@"待完善",@"待完善"],
                        ];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self getInfoCompleteRate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)refreshTableData {
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];


    [self.contentView addSubview:self.tableView];
//    [self.contentView addSubview:self.completenessLabel];
    

    
    [self.view setNeedsUpdateConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:@"changePwd" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"个人资料";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UILabel *)completenessLabel
{
    if (!_completenessLabel) {
        _completenessLabel = [[UILabel alloc] init];
        _completenessLabel.frame = CGRectMake(0, NAV_HEIGHT+STATUS_BAR_HEIGHT, SCREEN_WIDTH, 30);
        _completenessLabel.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _completenessLabel.textAlignment = NSTextAlignmentCenter;
        _completenessLabel.textColor = kWhiteColor;
        _completenessLabel.font = [UIFont systemFontOfSize:16];
//        _completenessLabel.text = [NSString stringWithFormat:@"资料完善率%ld%%",(long)[[WeiMiUserCenter sharedInstance] infoCompleteRate]];
    }
    return _completenessLabel;
}

- (UIButton *)headBtn
{
    if (!_headBtn) {
    
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.layer.masksToBounds = YES;
//        [_headBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
//        [_headBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateHighlighted];
        
        NSLog(@"%@", [WeiMiUserDefaultConfig currentConfig].avaterPath);
        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[WeiMiUserDefaultConfig currentConfig].avaterPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face"]];
        [_headBtn addTarget:self action:@selector(onHeadButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        [_tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
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
- (void)onHeadButton
{
    
}

#pragma mark - NetWork 
- (void)uploadImg:(UIImage *)image
{
    WeiMiUpdateImgRequest *request = [[WeiMiUpdateImgRequest alloc] initWithImage:image];
    request.showHUD = YES;
    
    WS(weakSelf);
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        SS(strongSelf);
        WeiMiUpdateImgRequest *result = (WeiMiUpdateImgRequest *)baseRequest;
        NSString *avaterPath = [result responseImagePath];
        if (avaterPath) {
            
            //上传头像
            WeiMiChangeAvaterRequest *request = [[WeiMiChangeAvaterRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel headImg:result.responseString];
            [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                WeiMiChangeAvaterRequest *result = (WeiMiChangeAvaterRequest *)baseRequest;
                NSString *resultStr = EncodeStringFromDic(result.responseJSONObject, @"result");
                if ([resultStr isEqualToString:@"1"]) {
                    [strongSelf presentSheet:@"修改成功！"];
                    
                    [WeiMiUserCenter sharedInstance].userInfoDTO.avaterPath = WEIMI_IMAGEREMOTEURL(avaterPath);
                }else
                {
                    [strongSelf presentSheet:@"修改头像失败"];
                }
            }];
        }else
        {
            [strongSelf presentSheet:@"修改头像失败"];
        }
    }];
    
    chainRequest.delegate = self;
    // start to send request
    [chainRequest start];
    
    return;
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        WeiMiUpdateImgRequest *result = (WeiMiUpdateImgRequest *)(request);
        NSString *avaterPath = [result responseImagePath];
        [WeiMiUserCenter sharedInstance].userInfoDTO.avaterPath = WEIMI_IMAGEREMOTEURL(avaterPath);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

//---- 获取资料完成度
- (void)getInfoCompleteRate
{
    if (_completenessLabel) {
        return;
    }
    WeiMiCreditInfoCompleteRateRequest *request = [[WeiMiCreditInfoCompleteRateRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel];
//    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        CGFloat rate = EncodeNumberFromDic(request.responseJSONObject, @"result").floatValue;
        if (rate) {
            
            [strongSelf.contentView addSubview:self.completenessLabel];
            strongSelf.completenessLabel.text = [NSString stringWithFormat:@"资料完善率%.1lf%%", rate*100];
            [UIView animateWithDuration:0.5f    delay:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [_completenessLabel setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_HEIGHT - 30, SCREEN_WIDTH, 30)];
            } completion:^(BOOL finished) {
                
            }];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

#pragma mark - YTKChainRequest Delegate
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_titleArr[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"personInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        
        cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            [cell.contentView addSubview:self.headBtn];
            [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-10);
                make.width.mas_equalTo(_headBtn.mas_height);
                //            make.height.mas_equalTo(cell).multipliedBy(2/3);
                make.height.mas_equalTo(60);
            }];
        }else
        {
            UILabel *rightTitleLB = [[UILabel alloc] init];
            rightTitleLB.tag = 10*indexPath.section + indexPath.row;
            rightTitleLB.textAlignment = NSTextAlignmentLeft;
            rightTitleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            rightTitleLB.textColor = kRedColor;
            if(indexPath.section == 1){
                if([WeiMiUserCenter sharedInstance].userInfoDTO.password){
                    rightTitleLB.text = @"安全";
                    rightTitleLB.textColor = [UIColor blackColor];
                } else {
                    rightTitleLB.text = _dataSource[indexPath.section][indexPath.row];
                }
            } else {
                rightTitleLB.text = _dataSource[indexPath.section][indexPath.row];
            }

            [cell.contentView addSubview:rightTitleLB];
            
            
            [rightTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(cell);
            }];
        }
    }
    
//    [self.headBtn setImage:[UIImage imageWithData:[WeiMiUserCenter sharedInstance].userInfoDTO.headImage] forState:UIControlStateNormal];
    
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[WeiMiUserCenter sharedInstance].userInfoDTO.avaterPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face"]];
    UILabel *LB = [cell viewWithTag:10*indexPath.section + indexPath.row];
    if (LB) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            NSString *userName = [WeiMiUserCenter sharedInstance].userInfoDTO.userName;
            if (userName) {
                LB.text = userName;
                LB.textColor = HEX_RGB(BASE_TEXT_COLOR);

            }
        }else if (indexPath.section == 2 && indexPath.row == 0)
        {
//            NSString *data = [[WeiMiUserCenter sharedInstance].userInfoDTO.gender isEqualToString:@"male"]? @"男":@"女";
            NSString *data = [WeiMiUserCenter sharedInstance].userInfoDTO.gender;
            if (data) {
                LB.text = data;
                LB.textColor = HEX_RGB(BASE_TEXT_COLOR);
            }
        }else if (indexPath.section == 2 && indexPath.row == 1)
        {
            NSString *data = [WeiMiUserDefaultConfig currentConfig].age;
            if (![NSString isNullOrEmpty:data]) {
                LB.text = data;
                LB.textColor = HEX_RGB(BASE_TEXT_COLOR);
            }
        }
        else if (indexPath.section == 2 && indexPath.row == 2)
        {
            NSString *data = [WeiMiUserDefaultConfig currentConfig].marriageStats;
            if (data) {
                LB.text = data;
                LB.textColor = HEX_RGB(BASE_TEXT_COLOR);
            }
        }else if (indexPath.section == 2 && indexPath.row == 3)
        {
            NSString *data = [WeiMiUserDefaultConfig currentConfig].location;
            if (data) {
                LB.text = data;
                LB.textColor = HEX_RGB(BASE_TEXT_COLOR);
            }
        }
    }
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
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
    else if (indexPath.section == 0 && indexPath.row == 1)
    {

        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiModifyNameVC"];
        
    }else if (indexPath.section == 1)
    {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiAccountSafeVC"];
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiSexualVC"];
    }
    else if (indexPath.section == 2 && indexPath.row == 1)
    {
        [[WeiMiPageSkipManager mineRT] open:@"WeiMiBirthVC"];
    }else if (indexPath.section == 2 && indexPath.row == 2)
    {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiLoveStatuVC"];

    }else if (indexPath.section == 2 && indexPath.row == 3)
    {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiLocationVC"];
        
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
    _headBtn.layer.cornerRadius = _headBtn.width/2;
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
//    NSData * imageData = UIImageJPEGRepresentation(croppedImage, 0.9);
    //    NSString * imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
//    [_headBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:_processImage];
    

    
    [_headBtn setImage:_processImage forState:UIControlStateNormal];
    //上传头像
    [self uploadImg:_processImage];
    
//    [WeiMiUserCenter sharedInstance].userInfoDTO.headImage = imageData;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//-(void)viewDidLayoutSubviews
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}


@end
