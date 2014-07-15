//
//  DiscoverViewController.h
//  WeiboZ
//  广场控制器

//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WeiboTableView.h"

@interface DiscoverViewController : BaseViewController <CLLocationManagerDelegate,WBHttpRequestDelegate,UITableViewEventDelegate>{
    int page;
    NSString *tag;
}


@property(nonatomic,retain) NSArray *data;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;
@property(nonatomic,retain)NSMutableArray *weibos;
@property (nonatomic,copy) NSString *lastWeiboID;



@end
