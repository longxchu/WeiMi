//
//  WeiMiMyLevelCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnLevelIntroBTNHandler) ();
@interface WeiMiMyLevelCell : UITableViewCell
@property (nonatomic, strong) UIButton *headerBTN;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, copy) OnLevelIntroBTNHandler onLevelIntroBTNHandler;

@end
