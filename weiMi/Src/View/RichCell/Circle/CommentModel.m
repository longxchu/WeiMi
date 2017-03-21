




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/


#import "CommentModel.h"

@implementation CommentModel

//@property (nonatomic,copy) NSString* from;//memberName
//@property (nonatomic,copy) NSString* to;//tomemberId
//@property (nonatomic,copy) NSString* content;//detContent
//@property (nonatomic,assign) NSInteger index;
//
//@property (nonatomic,strong) NSString* createTime;//createTime
//@property (nonatomic,strong) NSString* disId;//disId
//@property (nonatomic,strong) NSString* isAble;//isAble
//@property (nonatomic,strong) NSString* detId;//detId
- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.from = EncodeStringFromDic(dic,@"memberName");
    self.to = EncodeStringFromDic(dic,@"tomemberId");
    self.content = EncodeStringFromDic(dic,@"content");
    self.createTime = EncodeStringFromDic(dic,@"createTime");
    self.disId = EncodeStringFromDic(dic,@"disId");
    
    self.isAble = EncodeStringFromDic(dic,@"isAble");
    self.detId = EncodeStringFromDic(dic,@"detId");

}

@end
