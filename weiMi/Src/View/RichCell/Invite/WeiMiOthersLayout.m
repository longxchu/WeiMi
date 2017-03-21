//
//  WeiMiOthersLayout.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOthersLayout.h"
#import "LWTextParser.h"
#import "CommentModel.h"
#import "Gallop.h"


#define MESSAGE_TYPE_IMAGE @"image"

@implementation WeiMiOthersLayout

- (id)initWithStatusModel:(WeiMiOtherModel *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        
        //标题模型 titleTextStorage
        LWTextStorage* titleTextStorage = [[LWTextStorage alloc] init];
        titleTextStorage.text = statusModel.title;
        titleTextStorage.font = [UIFont fontWithName:@"Arial" size:17.0f];
        titleTextStorage.textColor = RGB(40, 40, 40, 1);
        titleTextStorage.frame = CGRectMake(10,
                                            10.0f,
                                            SCREEN_WIDTH - 20.0f,
                                            CGFLOAT_MAX);
    
        //发布的图片模型 imgsStorage
        CGFloat imageWidth = (SCREEN_WIDTH - 40.0f)/3.0f;
        NSInteger imageCount = [statusModel.imgs count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        
        //图片类型
        NSInteger row = 0;
        NSInteger column = 0;
        if (imageCount == 1) {
            CGRect imageRect = CGRectMake(titleTextStorage.left,
                                          titleTextStorage.bottom + 10.0f + (row * (imageWidth + 5.0f)),
                                          imageWidth*1.7,
                                          imageWidth*1.7);
            NSString* imagePositionString = NSStringFromCGRect(imageRect);
            [imagePositionArray addObject:imagePositionString];
            LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
            imageStorage.tag = 0;
            imageStorage.clipsToBounds = YES;
            imageStorage.frame = imageRect;
            imageStorage.backgroundColor = RGB(240, 240, 240, 1);
            NSString* URLString = [statusModel.imgs objectAtIndex:0];
            imageStorage.contents = [NSURL URLWithString:URLString];
            [imageStorageArray addObject:imageStorage];
        } else {
            for (NSInteger i = 0; i < imageCount; i ++) {
                CGRect imageRect = CGRectMake(titleTextStorage.left + (column * (imageWidth + 5.0f)),
                                              titleTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
                                              imageWidth,
                                              imageWidth);
                
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                imageStorage.clipsToBounds = YES;
                imageStorage.tag = i;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                NSString* URLString = [statusModel.imgs objectAtIndex:i];
                imageStorage.contents = [NSURL URLWithString:URLString];
                [imageStorageArray addObject:imageStorage];
                column = column + 1;
                if (column > 2) {
                    column = 0;
                    row = row + 1;
                }
            }
        }
        
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
        
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.attributedText = [self attrWithPrefixStr:[dateFormatter stringFromDate:statusModel.date] tag:statusModel.tag];
        dateTextStorage.font = [UIFont fontWithName:@"Arial" size:13.0f];
        dateTextStorage.textColor = [UIColor grayColor];
        
        //时间模型 dateTextStorage
        dateTextStorage.frame = CGRectMake(titleTextStorage.left,
                                               titleTextStorage.bottom + 10.0f,
                                               SCREEN_WIDTH - 100.0f,
                                               CGFLOAT_MAX);
        if (lastImageStorage) {
  
            dateTextStorage.frame = CGRectMake(titleTextStorage.left,
                                               lastImageStorage.bottom + 10.0f,
                                               SCREEN_WIDTH - 100.0f,
                                               CGFLOAT_MAX);
        }
        
        
        
        [self addStorage:titleTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorages:imageStorageArray];//通过一个数组来添加storage，使用这个方法

        self.dateRect = dateTextStorage.frame;
        self.imagePostions = imagePositionArray;//保存图片位置的数组
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
    }
    return self;
}

- (NSMutableAttributedString *)attrWithPrefixStr:(NSString *)prefix tag:(NSString *)str
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 来自", prefix]];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                NSForegroundColorAttributeName:RGB(244, 119, 72, 1)}];
    [attString appendAttributedString:sufStr];
    return attString;
}


@end
