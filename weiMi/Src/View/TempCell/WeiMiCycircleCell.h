//
//  WeiMiCycircleCell.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^OnWannCellItem)(NSString *);

@interface WeiMiCycircleCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnWannCellItem onWannCellItem;

+ (CGFloat)getHeight;

-(void)loadAdvert:(NSArray *)bannerArr;

@end
