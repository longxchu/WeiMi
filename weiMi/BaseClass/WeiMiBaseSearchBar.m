//
//  WeiMiBaseSearchBar.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseSearchBar.h"

@implementation WeiMiBaseSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
        
        self.layer.cornerRadius = 3.0f;
        self.layer.borderColor = HEX_RGB(0xDCDCDC).CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initSubView
{
    self.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
    self.barTintColor = [UIColor whiteColor];
    
//    UITextField *searchField = [self valueForKey:@"searchField"];
//    if (searchField) {
//        searchField.layer.cornerRadius = 5.0f;
//        searchField.layer.borderColor = HEX_RGB(0xDCDCDC).CGColor;
//        searchField.layer.borderWidth = 1;
//        searchField.layer.masksToBounds = YES;
//    }
    
    UIButton *cancelButton = [self valueForKey:@"cancelButton"];
    if (cancelButton) {
        [cancelButton setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        [cancelButton setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateSelected];
    }
}

@end
