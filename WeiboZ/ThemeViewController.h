//
//  ThemeViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *themes;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
