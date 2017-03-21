//
//  WeiMiHomePageChoiceTagCollectView.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@protocol WeiMiHomePageChoiceTagCollectViewDelegate <NSObject>

@optional

- (void)didSelectedItemAtIndex:(NSIndexPath *)indexPath;

@end

@interface WeiMiHomePageChoiceTagCollectView : UICollectionReusableView

@property (nonatomic, weak) id <WeiMiHomePageChoiceTagCollectViewDelegate> delegate;

- (void)addObjects:(NSArray *)titles;

@end
