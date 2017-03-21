




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/






#import <Foundation/Foundation.h>

@interface CommentModel : WeiMiBaseDTO

@property (nonatomic,copy) NSString* from;//memberName
@property (nonatomic,copy) NSString* to;//tomemberId
@property (nonatomic,copy) NSString* content;//detContent
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSString* createTime;//createTime
@property (nonatomic,strong) NSString* disId;//disId
@property (nonatomic,strong) NSString* isAble;//isAble
@property (nonatomic,strong) NSString* detId;//detId

@end
