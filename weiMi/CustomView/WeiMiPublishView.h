//
//  WeiMiPublishView.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiMiPublishViewDelegate <NSObject>

- (void)didSelectBtnWithBtnTag:(NSInteger)tag;

@end
@interface WeiMiPublishView : UIView

@property(weak,nonatomic) id<WeiMiPublishViewDelegate> delegate;

- (instancetype)initWithTitleImgDic:(NSDictionary *)dic frame:(CGRect)frame;

- (void)show;

@end
