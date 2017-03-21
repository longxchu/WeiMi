//
//  WeiMiHomeMenuItem.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiMiHomeMenuItem : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image;

@end
