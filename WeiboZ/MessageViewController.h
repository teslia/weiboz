//
//  MessageViewController.h
//  WeiboZ
//  消息首页控制器

//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController <WBHttpRequestDelegate,UITableViewEventDelegate>{
    WeiboTableView *_weiboTable;
}

@end
