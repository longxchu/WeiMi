//
//  WeiMiWannaTitleCell.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/20.
//  Copyright © 2016年 . All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^WannaTitleCellMoreBtn)(NSString *, NSString *);

@interface WeiMiWannaTitleCell : WeiMiBaseTableViewCell
@property (nonatomic, copy) WannaTitleCellMoreBtn wannaTitleCellMoreBtn;

- (void)setViewWithTitle:(NSString *)title tId:(NSString *)tId;

+ (CGFloat)getHeight;

@end
