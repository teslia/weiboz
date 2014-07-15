//
//  HomeViewController.h
//  WeiboZ
//  首页控制器

//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface HomeViewController : BaseViewController <WBHttpRequestDelegate,UITableViewEventDelegate>

@property (retain, nonatomic) WeiboTableView *tableView;
//@property (nonatomic,copy) NSString *topWeiboID;
@property (nonatomic,copy) NSString *lastWeiboID;
@property (retain, nonatomic)  NSMutableArray *weibos;
@property (nonatomic) int unreadCount;
-(void)refreshWeibo;
@end
