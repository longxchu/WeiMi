//
//  WeiMiGoodsDetailTagCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDetailTagCell.h"
#import "WeiMiGoodsDetailTagItem.h"

@interface WeiMiGoodsDetailTagCell()
{
    NSMutableArray *_itemArr;
}

@end

@implementation WeiMiGoodsDetailTagCell

- (instancetype)initWithItemDic:(NSDictionary *)dic reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        WeiMiAssert(dic.count > 0);
        
        _itemArr = [NSMutableArray new];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            WeiMiGoodsDetailTagItem *item = [[WeiMiGoodsDetailTagItem alloc] init];
            [item setCellWithTitle:(NSString *)key image:(NSString *)obj];
            [self addSubview:item];
            [_itemArr addObject:item];
        }];
    
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter


- (void)updateConstraints
{
    [_itemArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [_itemArr mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
