//
//  WeiMiAdviceVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAdviceVC.h"
#import <CoreText/CoreText.h>
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "UIButton+CenterImageAndTitle.h"
//----- third
#import <OHActionSheet.h>
#import "PECropViewController.h"
#import "UIImage+Resize.h"

@interface WeiMiAdviceVC()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    BOOL _save;
    UIImage *_processImage;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation WeiMiAdviceVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.contentFrame;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    [_scrollView addSubview:self.textView];
    [_scrollView addSubview:self.addButton];
    [self.contentView addSubview:_scrollView];
    
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
    self.popWithBaseNavColor = NO;
    self.title = @"意见反馈";
    
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"提交" normal:nil selected:nil action:^{
        SS(strongSelf);
        
        _save = YES;
        [strongSelf presentSheet:@"提交成功"];
    }];
}

#pragma mark - Getter
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton sizeToFit];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_addButton setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_addButton setImage:[UIImage imageNamed:@"icon_add_img"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.delegate = self;
        _textView.font = WeiMiSystemFontWithpx(20);
        _textView.placeholder = @"请填写反馈内容";
        _textView.scrollEnabled = NO;
//        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
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
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_addButton horizontalCenterTitleAndImageLeft:15];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _addButton.bottom + 10);
}

- (void)updateViewConstraints
{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.top.mas_equalTo(10);
        make.height.mas_greaterThanOrEqualTo(200);
    }];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(_textView.mas_bottom);
        make.height.mas_equalTo(70);
    }];
    
    [super updateViewConstraints];
    
}


@end
