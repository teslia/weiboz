//
//  ProfileViewController.h
//  WeiboZ
//  个人中心

//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface ProfileViewController : BaseViewController<WBHttpRequestDelegate>

@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;
@property(copy,nonatomic) NSString *userName;
@property(copy,nonatomic) NSString *UID;
@property(retain,nonatomic) UserInfoView *userInfo;
@property(nonatomic) BOOL HideBack;

@end
