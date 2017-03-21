//
//  WeiMiTagButton.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiMiTagButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tagLabel;

- (void)setImage:(NSString *)image title:(NSString *)title;

@end
