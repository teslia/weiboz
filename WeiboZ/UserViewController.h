//
//  UserViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-10.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : BaseViewController <WBHttpRequestDelegate>

@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;
@property(copy,nonatomic) NSString *userName;
@property(copy,nonatomic) NSString *UID;
@property(retain,nonatomic) UserInfoView *userInfo;
@property(nonatomic) BOOL HideBack;
@end
