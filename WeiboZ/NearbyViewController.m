//
//  NearbyViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-19.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "NearbyViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"



@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我在这里";
    }
    return self;
}


#pragma mark - CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    if(self.data == nil){
        [manager stopUpdatingLocation];
        CLLocation *newLocation = [locations lastObject];
        NSString *latitudeString = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        NSString *longitudeString = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"lat":latitudeString,@"long":longitudeString,@"count":@"50"};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/place/nearby/pois.json" httpMethod:@"POST" params:param delegate:self withTag:@"LocationAction"];
        
    }
}


-(void)refreshUI{
    [self hideHUD];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self showHUDError:@"无法获取您的位置!"];
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSArray *pois = [resultDict objectForKey:@"pois"];
    self.data = pois;
    [self refreshUI];
}

# pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *subtitle = [dic objectForKey:@"address"];
    //NSString *icon = [dic objectForKey:@"icon"];
    
    cell.textLabel.text = title;
    if(![subtitle isKindOfClass:[NSNull class]]){
    cell.detailTextLabel.text = subtitle;
    }
    //[cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectBlock != nil){
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        _selectBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHUDMessage:@"正在获取您的位置..."];
    self.tableView.hidden = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}



-(void)viewWillDisappear:(BOOL)animated{
    [_locationManager stopUpdatingLocation];
    [self hideHUD];
    [super viewWillDisappear:animated];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
