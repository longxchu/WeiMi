//
//  WeiMiCircleCommentVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCommentVC.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <CoreText/CoreText.h>
#import "PECropViewController.h"
#import "UIImage+Resize.h"
#import "WeiMiCommentInputView.h"
#import <OHAlertView.h>
#import "ImageTextAttachment.h"
//------ request
#import "YTKChainRequest.h"
//普通帖子
#import "WeiMiCirclePostInvitationRequest.h"
#import "WeiMiUpdateImgRequest.h"
//男生帖子 女生帖子
#import "WeiMiAddMaleFemalePostRequest.h"
//男生问答 女生问答
#import "WeiMiAddMaleFemaleRQRequest.h"


#import "WeiMiAddMaleFemalePostRequest.h"
@interface WeiMiCircleCommentVC ()<UITextFieldDelegate, UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,YTKChainRequestDelegate>
{
    BOOL _save;
    UIImage *_processImage;
    __block BOOL _isAnonymity;//是否匿名
}

@property (nonatomic, strong) UIScrollView *scrollBGView;

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) WeiMiCommentInputView *inputView;
@property (nonatomic,strong) NSMutableAttributedString * locationStr;

@end

@implementation WeiMiCircleCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = self.contentFrame;
    _scrollBGView.backgroundColor = kWhiteColor;
    
    [self.scrollBGView addSubview:self.titleField];
    [self.scrollBGView addSubview:self.lineView];
    [self.scrollBGView addSubview:self.contentTextView];
    
    _contentTextView.inputAccessoryView = self.inputView;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    
    [self AddRightBtn:@"提交" normal:nil selected:nil action:^{
        SS(strongSelf);
        if ([NSString isNullOrEmpty:_titleField.text]) {
            [strongSelf presentSheet:@"请填写标题"];
            return;
        }else if ([NSString isNullOrEmpty:_contentTextView.text])
        {
            [strongSelf presentSheet:@"请填写内容"];
            return;
        }
        //发布评论
        switch (_commentType) {
            case COMMENTTYPE_INVITATION://普通帖子
            {
                WeiMiCirclePostInvitationModel *model = [[WeiMiCirclePostInvitationModel alloc] init];
                model.infoTitle = _titleField.text;
                model.content = _contentTextView.text;
                model.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
                model.ringId = _sID;
                [self postInvitation:model image:_processImage];
            }
                break;
            case COMMENTTYPE_MALEINVITATION://男生帖子
            case COMMENTTYPE_FEMALEINVITATION://女生帖子
            {
                WeiMiAddMaleFemalePostModel *model = [[WeiMiAddMaleFemalePostModel alloc] init];
                model.infoTitle = _titleField.text;
                model.content = _contentTextView.text;
                model.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
                [self postInvitation:model image:_processImage];
            }
                break;
            case COMMENTTYPE_MALERQ:
            case COMMENTTYPE_FRMALERQ:
            {
                WeiMiAddMaleFemaleRQModel *model = [[WeiMiAddMaleFemaleRQModel alloc] init];
                model.niming = _isAnonymity == YES ? @"1" : @"2"; //1匿名 2实名
                model.qtTitle = _titleField.text;
                model.qtContent = _contentTextView.text;
                model.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
                [self addRQ:model];
            }
                break;
            default:
                break;
        }
        //点击提交自动返回
        [self performSelector:@selector(BackToLastNavi) withObject:nil afterDelay:1.0];
    }];
}

//自动返回方法实现
-(void)BackToLastNavi{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter
- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
        //        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    return _scrollBGView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, _titleField.bottom, SCREEN_WIDTH, 0.5);
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UITextField *)titleField
{
    if (!_titleField) {
        _titleField = [[UITextField alloc] init];
        _titleField.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, GetAdapterHeight(45));
        _titleField.placeholder = @"标题（选填，至少四个字）";
    }
    
    return _titleField;
}

- (WeiMiCommentInputView *)inputView
{
    if (!_inputView) {
        
        _inputView = [[WeiMiCommentInputView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
        WS(weakSelf);
        _inputView.onAddPicBtnHandler = ^{
            
            [OHAlertView showAlertWithTitle:nil message:@"上传图片" cancelButton:@"相机" otherButtons:@[@"图库"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                SS(strongSelf);
                if (buttonIndex == 0) {
                    [strongSelf openCamera];
                }else
                {
                    [strongSelf openPhoto];
                }
            }];
        };
        
        _inputView.onSwitchHandler = ^(UISwitch *switcher){
            _isAnonymity = switcher.on;
        };
    }
    return _inputView;
}
- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        _contentTextView.delegate = self;
        _contentTextView.font = WeiMiSystemFontWithpx(20);
        _contentTextView.placeholder = @"请不要发布违法的内容，否则会被删除或者禁言哦";
        _contentTextView.scrollEnabled = NO;
//        _contentTextView.font = [UIFont systemFontOfSize:15];
    }
    return _contentTextView;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    
//    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _leftBTN.bottom > SCREEN_HEIGHT ? _leftBTN.bottom +10 : SCREEN_HEIGHT + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.top.mas_equalTo(_lineView).offset(10);
        make.height.mas_equalTo(_scrollBGView.height);
    }];
    
    
    [super updateViewConstraints];
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
//    [self addAttachMent:[_processImage resizedImage:CGSizeMake(_processImage.scale * 100, 100)
//                               interpolationQuality:kCGInterpolationLow]];
    
    [self addAttachMent:[_processImage resizedImage:CGSizeMake(_processImage.scale * 100, 100) interpolationQuality:kCGInterpolationLow] withRange:self.contentTextView.selectedRange appenReturn:YES];

    [self.contentTextView becomeFirstResponder];
}

- (void)addAttachMent:(UIImage *)image withRange:(NSRange)range appenReturn:(BOOL)appen
{
    if (image == nil)
    {
        return;
    }
    NSTextAttachment *imageTextAttachment = [NSTextAttachment new];
    
    //Set tag and image
    imageTextAttachment.image =image;

    if (appen) {
        //Insert image image
        [_contentTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                              atIndex:range.location];
    }
    else
    {
        if (_contentTextView.textStorage.length>0) {
            
            //Insert image image
            [_contentTextView.textStorage replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]];
        }
        
    }
    
    //Move selection location
    _contentTextView.selectedRange = NSMakeRange(range.location + 1, range.length);
    
    //设置locationStr的设置
    [self setInitLocation];
//    if(appen)
//    {
//        [self appenReturn];
//    }
    
    _contentTextView.font = WeiMiSystemFontWithpx(21);

}

-(void)setInitLocation
{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.contentTextView.attributedText];
}

-(void)appenReturn
{
    NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:_contentTextView.attributedText];
    [att appendAttributedString:returnStr];
    
    _contentTextView.attributedText=att;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Network
//发送普通帖子
- (void)postInvitation:(NSObject *)model image:(UIImage *)image
{
    //如果没有图片，直接发送评论
    //发布帖子
    WeiMiBaseRequest *request;
    if (!image) {
        if ([model isKindOfClass:[WeiMiCirclePostInvitationModel class]]) {//普通帖子
            request = [[WeiMiCirclePostInvitationRequest alloc] initWithModel:(WeiMiCirclePostInvitationModel *)model];
        }else if ([model isKindOfClass:[WeiMiAddMaleFemalePostModel class]])
        {
            if (_commentType == COMMENTTYPE_MALEINVITATION) {// 男生撸啊撸帖子
                request = [[WeiMiAddMaleFemalePostRequest alloc] initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:YES];
            }else if (_commentType == COMMENTTYPE_FEMALEINVITATION)//女生悄悄话
            {
                request = [[WeiMiAddMaleFemalePostRequest alloc                                                     ] initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:NO];
            }
        }
        request.showHUD = YES;
        WS(weakSelf);
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SS(strongSelf);
            NSString *resultStr = EncodeStringFromDic(request.responseJSONObject, @"result");
            if ([resultStr isEqualToString:@"1"]) {
                [strongSelf presentSheet:@"发布帖子成功"];
                
            }else
            {
                [strongSelf presentSheet:@"发布帖子失败"];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        return;
    }
    
    WeiMiUpdateImgRequest *imagRequest = [[WeiMiUpdateImgRequest alloc] initWithImage:image];
    imagRequest.showHUD = YES;
    WS(weakSelf);
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    [chainRequest addRequest:imagRequest callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        SS(strongSelf);
        
        WeiMiUpdateImgRequest *result = (WeiMiUpdateImgRequest *)baseRequest;
        NSString *avaterPath = [result responseImagePath];
        
        if (avaterPath) {
            
            if ([model isKindOfClass:[WeiMiCirclePostInvitationModel class]]) {//普通帖子

                ((WeiMiCirclePostInvitationModel *)model).imgPath = avaterPath;
                //发布帖子
                WeiMiCirclePostInvitationRequest *request = [[WeiMiCirclePostInvitationRequest alloc] initWithModel:(WeiMiCirclePostInvitationModel *)model];
                [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                    WeiMiCirclePostInvitationRequest *result = (WeiMiCirclePostInvitationRequest *)baseRequest;
                    NSString *resultStr = EncodeStringFromDic(result.responseJSONObject, @"result");
                    if ([resultStr isEqualToString:@"1"]) {
                        [strongSelf presentSheet:@"发布帖子成功"];
                        
                    }else
                    {
                        [strongSelf presentSheet:@"发布帖子失败"];
                    }
                }];
            }else if ([model isKindOfClass:[WeiMiAddMaleFemalePostRequest class]])
            {
                ((WeiMiAddMaleFemalePostModel *)model).imgPath = avaterPath;
                //发布帖子
    
                if (_commentType == COMMENTTYPE_MALEINVITATION) {// 男生撸啊撸帖子

                    WeiMiAddMaleFemalePostRequest *request = [[WeiMiAddMaleFemalePostRequest alloc] initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:YES];
                    [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                        WeiMiCirclePostInvitationRequest *result = (WeiMiCirclePostInvitationRequest *)baseRequest;
                        NSString *resultStr = EncodeStringFromDic(result.responseJSONObject, @"result");
                        if ([resultStr isEqualToString:@"1"]) {
                            [strongSelf presentSheet:@"发布帖子成功"];
                        }else
                        {
                            [strongSelf presentSheet:@"发布帖子失败"];
                        }
                    }];
                    
                }else if (_commentType == COMMENTTYPE_FEMALEINVITATION)//女生悄悄话
                {
                    
                    WeiMiAddMaleFemalePostRequest *request = [[WeiMiAddMaleFemalePostRequest alloc] initWithModel:(WeiMiAddMaleFemalePostModel *)model isMale:NO];
                    [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                        WeiMiCirclePostInvitationRequest *result = (WeiMiCirclePostInvitationRequest *)baseRequest;
                        NSString *resultStr = EncodeStringFromDic(result.responseJSONObject, @"result");
                        if ([resultStr isEqualToString:@"1"]) {
                            [strongSelf presentSheet:@"发布帖子成功"];
                        }else
                        {
                            [strongSelf presentSheet:@"发布帖子失败"];
                        }
                    }];

                }
            }
        }else
        {
            [strongSelf presentSheet:@"发布帖子失败"];
        }
    }];
    
    chainRequest.delegate = self;
    // start to send request
    [chainRequest start];
}

//添加问答
- (void)addRQ:(WeiMiAddMaleFemaleRQModel *)model
{
    BOOL isMale = NO;
    if (_commentType == COMMENTTYPE_MALERQ) {
        isMale = YES;
    }else if (_commentType == COMMENTTYPE_FRMALERQ)
    {
        isMale = NO;
    }
    WeiMiAddMaleFemaleRQRequest *request = [[WeiMiAddMaleFemaleRQRequest alloc] initWithModel:model isMale:isMale];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *resultStr = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([resultStr isEqualToString:@"1"]) {
            [strongSelf presentSheet:@"发布帖子成功"];
            
        }else
        {
            [strongSelf presentSheet:@"发布帖子失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

@end
