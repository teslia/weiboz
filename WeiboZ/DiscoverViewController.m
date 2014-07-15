//
//  DiscoverViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "DiscoverViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboModel.h"
#import "DetailViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"广场";
    }
    return self;
}



#pragma mark - CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if(self.data == nil){
        [manager stopUpdatingLocation];
        NSString *currentPage;
        if(page == 0){
            currentPage = @"1";
            page = 1;
        }else{
            currentPage = [NSString stringWithFormat:@"%d",page];
        }
        CLLocation *newLocation = [locations lastObject];
        NSString *latitudeString = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        NSString *longitudeString = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"lat":latitudeString,@"long":longitudeString,@"count":@"50",@"page":currentPage};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/place/nearby_timeline.json" httpMethod:@"POST" params:param delegate:self withTag:tag];
        
    }
}


-(void)refreshUI{
    [self hideHUD];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.tableView doneLoadingTableViewData];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self showHUDError:@"无法获取您的位置!"];
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    tag = nil;
    if(request.tag != nil){
        NSString *tagl = [NSString stringWithFormat:@"%@:",request.tag];
        SEL selName = NSSelectorFromString(tagl);
        if([self respondsToSelector:selName]){
            [self performSelector:selName withObject:result];
        }
        return;
    }
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSArray *statues = [resultDict objectForKey:@"statuses"];
    _weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for(NSDictionary *statesDic in statues){
        WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statesDic];
        [_weibos addObject:weibo];
    }
    _tableView.data = _weibos;
    
    //刷新UI
    [self refreshUI];

}

-(void)pullUpDataFinish:(NSString *)result{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSArray *statues = [resultDict objectForKey:@"statuses"];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:statues.count];
    for(NSDictionary *statesDic in statues){
        WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statesDic];
        [arr addObject:weibo];
    }
    if(arr.count > 0){
        self.tableView.isMore = YES;
    }else{
        [ProgressHUD showError:@"没有更多的微博了!"];
        self.tableView.isMore = NO;
        [self.tableView reloadData];
        return;
    }
    [arr removeObjectAtIndex:0];
    [self.weibos addObjectsFromArray:arr];
    //刷新UI
    self.tableView.data = self.weibos;
    [self refreshUI];
}

# pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHUDMessage:@"正在获取您附近的微博..."];
    self.tableView.hidden = YES;
    self.tableView.eventDelegate = self;
    self.tableView.refreshHeader = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}

#pragma mark - Weibo TableView delegate
//下拉
-(void)pullDown:(BaseTableView *)tableView{
    page = 1;
    [self showHUDMessage:@"正在获取您附近的微博..."];
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}
//上拉
-(void)pullUp:(BaseTableView *)tableView{
    page++;
    tag = [NSString stringWithFormat:@"pullUpDataFinish"];
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}
//点击
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //WeiboModel *weibo = [_weibos objectAtIndex:indexPath.row];
    //DetailViewController *detail = [[DetailViewController alloc]init];
    //detail.weiboModel = weibo;
    //[self.navigationController pushViewController:detail animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_locationManager stopUpdatingLocation];
    [self hideHUD];
    [super viewWillDisappear:animated];
}


@end
