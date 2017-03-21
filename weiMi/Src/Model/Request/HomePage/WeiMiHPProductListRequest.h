//
//  WeiMiHPProductListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiHPProductListRequestModel : NSObject
//NSString *_menuId;
//NSString *_brandId;
//NSString *_proTypeId;
//NSString *_strSort;
//NSString *_isAble;
//NSInteger _pageIndex;
//NSInteger _pageSize;

@property (nonatomic, strong)NSString *menuId;//导航id
@property (nonatomic, strong)NSString *brandId;//品牌Id
@property (nonatomic, strong)NSString *proTypeId;//类型Id
@property (nonatomic, strong)NSString *strSort;//排序字段	
@property (nonatomic, strong)NSString *isAble;//显示位置

@end

@interface WeiMiHPProductListRequest : WeiMiBaseRequest

-(id)initWithModel:(WeiMiHPProductListRequestModel *)model pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
