//
//  NearbyViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-19.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,WBHttpRequestDelegate>


@property(nonatomic,retain) NSArray *data;
@property(nonatomic,copy)SelectDoneBlock selectBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end
