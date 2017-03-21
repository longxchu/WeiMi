//
//  WeiMiCountDownItem.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiCountDownItem : WeiMiBaseView

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *label;

- (void)setTitleWithCount:(NSString *)num;

@end
