//
//  FirendshipViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "FridenShipTableView.h"

@interface FirendshipViewController : BaseViewController <WBHttpRequestDelegate>

@property (copy,nonatomic) NSString *userID;
@property (nonatomic,retain) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet FridenShipTableView *tableView;

@end
