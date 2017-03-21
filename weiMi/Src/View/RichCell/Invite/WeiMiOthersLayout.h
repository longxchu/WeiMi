//
//  WeiMiOthersLayout.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "LWLayout.h"
#import "WeiMiOtherModel.h"

@interface WeiMiOthersLayout : LWLayout

@property (nonatomic,strong) WeiMiOtherModel* statusModel;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) NSArray* imagePostions;
@property (nonatomic, assign) CGRect dateRect;
//@property (nonatomic,assign) CGRect lineRect;

- (id)initWithStatusModel:(WeiMiOtherModel *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;

@end
