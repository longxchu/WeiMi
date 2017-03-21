//
//  WeiMiCommentStarView.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiCommentStarView : WeiMiBaseView

//自己社会星号图片
- (instancetype)initWithFrame:(CGRect)frame startNum:(NSUInteger)num starNormalImg:(NSString *)normal selected:(NSString *)select;
//设置默认星号
- (instancetype)initWithFrame:(CGRect)frame startNum:(NSUInteger)num;
/*设置点亮数目*/
- (void)setLightNum:(NSUInteger)num;
@end
