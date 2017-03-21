//
//  WeiMiOthersInviteCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOthersInviteCell.h"
#import "GallopUtils.h"
#import "LWImageStorage.h"
#import "LWAlertView.h"

@interface WeiMiOthersInviteCell ()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic, strong) UIButton *commentBTN;//评论
@property (nonatomic,strong) UIView* line;

@end
@implementation WeiMiOthersInviteCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
        //        [self.contentView addSubview:self.menuButton];
        //        [self.contentView addSubview:self.menu];
        
        [self.contentView addSubview:self.commentBTN];
    }
    return self;
}

#pragma mark - LWAsyncDisplayViewDelegate

//额外的绘制
- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled {
    if (!isCancelled()) {
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.2f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
    }
}

//点击LWImageStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
    NSInteger tag = imageStorage.tag;
    //tag 0~8 是图片，9是头像
//    switch (tag) {
//        case 0:
//        case 1:
//        case 2:
//        case 3:
//        case 4:
//        case 5:
//        case 6:
//        case 7:
//        case 8:{
//            if (self.clickedImageCallback) {
//                self.clickedImageCallback(self,tag);
//            }
//        }break;
//        case 9: {
//            if (self.clickedAvatarCallback) {
//                self.clickedAvatarCallback(self);
//            }
//        }break;
//    }
}

//点击LWTextStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
    didCilickedTextStorage:(LWTextStorage *)textStorage
                  linkdata:(id)data {
//    //回复评论
//    if ([data isKindOfClass:[CommentModel class]]) {
//        if (self.clickedReCommentCallback) {
//            self.clickedReCommentCallback(self,data);
//        }
//    }
//    else if ([data isKindOfClass:[NSString class]]) {
//        //折叠Cell
//        if ([data isEqualToString:@"close"]) {
//            if (self.clickedCloseCellCallback) {
//                self.clickedCloseCellCallback(self);
//            }
//        }
//        //展开Cell
//        else if ([data isEqualToString:@"open"]) {
//            if (self.clickedOpenCellCallback) {
//                self.clickedOpenCellCallback(self);
//            }
//        }
//        //其他
//        else {
//            [LWAlertView shoWithMessage:data];
//        }
//    }
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    //    self.menuButton.frame = self.cellLayout.menuPosition;
    //    self.menu.frame = CGRectMake(self.cellLayout.menuPosition.origin.x - 5.0f,
    //                                 self.cellLayout.menuPosition.origin.y - 9.0f + 14.5f,0.0f,34.0f);
    
    self.commentBTN.frame = CGRectMake( SCREEN_WIDTH - 40, CGRectGetMinY(self.cellLayout.dateRect), 45, 24);
    [self.commentBTN sizeToFit];

//    self.line.frame = self.cellLayout.lineRect;
}

- (void)setCellLayout:(WeiMiOthersLayout *)cellLayout {
    if (_cellLayout != cellLayout) {
        _cellLayout = cellLayout;
        self.asyncDisplayView.layout = self.cellLayout;
//        self.menu.statusModel = self.cellLayout.statusModel;
    }
}

- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBTN setTitle:@"20" forState:UIControlStateNormal];
        [_commentBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _commentBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commentBTN setImage:[UIImage imageNamed:@"icon_pinglun"] forState:UIControlStateNormal];
        [_commentBTN setImage:[UIImage imageNamed:@"icon_pinglun"] forState:UIControlStateHighlighted];
    }
    return _commentBTN;
}


- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = RGB(220.0f, 220.0f, 220.0f, 1.0f);
    return _line;
}


@end
