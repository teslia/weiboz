//
//  BaseTableView.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-15.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ProgressHUD.h"

@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>
@optional
//下拉
-(void)pullDown:(BaseTableView *)tableView;
//上拉
-(void)pullUp:(BaseTableView *)tableView;
//点击
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
}

@property (nonatomic,assign) BOOL refreshHeader;  //是否需要下拉
@property(retain,nonatomic) NSArray *data;
@property(assign,nonatomic) id<UITableViewEventDelegate> eventDelegate;

@property(nonatomic,assign)BOOL isMore;  //是否还有下一页

- (void)doneLoadingTableViewData;
- (void)refreshData;

@end
