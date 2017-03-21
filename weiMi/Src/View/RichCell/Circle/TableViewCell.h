
#import <UIKit/UIKit.h>
#import "CellLayout.h"
#import "Gallop.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong) CellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,copy) void(^clickedImageCallback)(TableViewCell* cell,NSInteger imageIndex);
@property (nonatomic,copy) void(^clickedLikeButtonCallback)(TableViewCell* cell,BOOL isLike);
@property (nonatomic,copy) void(^clickedAvatarCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedReCommentCallback)(TableViewCell* cell,CommentModel* model);
@property (nonatomic,copy) void(^clickedCommentButtonCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedOpenCellCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedCloseCellCallback)(TableViewCell* cell);

@end


