//
//  WeiMIRecAddCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiRecAddDTO.h"

typedef void (^OnSetDefaultHandler) (UIButton *button);
typedef void (^OnEditHandler) ();
typedef void (^OnDeleteHandler) ();
@interface WeiMIRecAddCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnSetDefaultHandler onSetDefaultHandler;
@property (nonatomic, copy) OnEditHandler onEditHandler;
@property (nonatomic, copy) OnDeleteHandler onDeleteHandler;
@property (nonatomic, strong) WeiMiRecAddDTO *dto;

- (void)setViewWithDTO:(WeiMiRecAddDTO *)dto;
@end
