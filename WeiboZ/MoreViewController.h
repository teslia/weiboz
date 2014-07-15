//
//  MoreViewController.h
//  WeiboZ
//  更多控制器

//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController <UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
+(void)clearLocalCache;
@end
