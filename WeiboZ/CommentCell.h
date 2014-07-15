//
//  CommentCell.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-20.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

#import "Zmsky-ImageView.h"

@interface CommentCell : UITableViewCell <RTLabelDelegate>{
    Zmsky_ImageView *_userImage ;
    UILabel *_nickLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel;
}

@property (nonatomic,retain) CommentModel *commentModel;


//计算评论高度
+(float) getCommentHeight:(CommentModel *)commentModel;

@end
