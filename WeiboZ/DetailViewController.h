//
//  DetailViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-20.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"

@class WeiboModel;
@class WeiboView;
@interface DetailViewController : BaseViewController <WBHttpRequestDelegate,UITableViewEventDelegate>{
    WeiboView *_weiboView;
    UILabel *_comments_counts;
}

@property(nonatomic,retain)WeiboModel *weiboModel;
@property (weak, nonatomic) IBOutlet CommentTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *userBarView;

@property (retain, nonatomic)NSMutableArray *comments;

@end
