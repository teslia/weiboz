//
//  HomeViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboModel.h"
#import "ProgressHUD.h"
#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIUtils.h"
#import "DetailViewController.h"
#import "MoreViewController.h"
#import "DDMenuController.h"
#import "UserViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博";
        self.unreadCount = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self showStatusTip:YES title:@"TEST1"];
    //[self showStatusTip:NO title:@"TEST2"];
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(myDelegate.isLogin){
        _tableView = [[WeiboTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49) style:UITableViewStylePlain
                      ];
        _tableView.eventDelegate = self;
        self.tableView.hidden = YES;
        if(WXHLOSVersion() >= 7.0f){
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.tableView.top = 0;
        }
        [self.view addSubview:_tableView];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];
        //NSString *archPath = [UIUtils getDocumentsPath:@"WeiboArchData.loa"];
        _weibos = [NSKeyedUnarchiver unarchiveObjectWithFile:kWeiboLocalCacheFileName];
        if(_weibos.count > 0){
            if(self.tableView.hidden){
                self.tableView.hidden = NO;
            }
            _tableView.data = _weibos;
            [_tableView reloadData];
            WeiboModel *lastWeibo = [_weibos lastObject];
            self.lastWeiboID = [lastWeibo.weiboId  stringValue];
        }else{
            NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"count":@"50"};
            [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:nil];
            [ProgressHUD show:@"正在获取微博..."];
            
        }
    }else{
        [myDelegate loginOut];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate.menu setEnableGesture:YES];
    [super viewWillAppear:animated];
    //开启左滑动

}

-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate.menu setEnableGesture:NO];
    [super viewWillDisappear:animated];
    //关闭左滑动

}

-(void)refreshWeibo{
    [self.tableView refreshData];
    [self pullDownData];
}

#pragma mark - WBHttpRequest

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    if(self.tableView.hidden){
        self.tableView.hidden = NO;
    }
    [ProgressHUD dismiss];
    NSRange range = [result rangeOfString:@"invalid_access_token"];
    if(range.length >0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的登录信息已过期，请重新登录！" delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil];
        [alert show];
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [MoreViewController  clearLocalCache];
        [myDelegate loginOut];
    }
    if(request.tag != nil){
        NSString *tag = [NSString stringWithFormat:@"%@:",request.tag];
        SEL selName = NSSelectorFromString(tag);
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
    
    if(statues.count > 0){
        if(_unreadCount != 0){
            NSString *successInfo = [NSString stringWithFormat:@"已更新 %d 条微博",_unreadCount];
            _unreadCount = 0;
            [ProgressHUD showSuccess:successInfo];
            //////AUDIO///////
            NSString *fileurl = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
            NSURL *fileURL = [NSURL URLWithString:fileurl];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) fileURL, &soundID);
            AudioServicesPlaySystemSound(soundID);
            //////AUDIO///////
        }
        _tableView.data = _weibos;
        WeiboModel *lastWeibo = [_weibos lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
    }
    MainViewController *mvc =  (MainViewController *)self.tabBarController;
    [mvc showBadge:NO];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.tableView doneLoadingTableViewData];
    [self.tableView reloadData];
    //将数据写入本地保存一份缓存
    //NSString *archPath = [UIUtils getDocumentsPath:@"WeiboArchData.loa"];
    [NSKeyedArchiver archiveRootObject:_weibos toFile:kWeiboLocalCacheFileName];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    if(self.tableView.hidden){
        self.tableView.hidden = NO;
    }
    [ProgressHUD showError:@"数据加载失败"];
    [self.tableView doneLoadingTableViewData];
}

-(void) pullDownData{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"count":@"50",};
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:nil];
}

-(void) pullUpData{
    if(self.lastWeiboID.length == 0){
        NSLog(@"微博id为空 act:pullUpData next:ret");
        return;
    }
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"count":@"50",@"max_id":self.lastWeiboID};
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:@"pullUpDataFinish"];

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
        WeiboModel *lastWeibo = [arr lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
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
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:_weibos toFile:kWeiboLocalCacheFileName];
}

#pragma mark - Weibo TableView delegate
//下拉
-(void)pullDown:(BaseTableView *)tableView{
    [self pullDownData];
}
//上拉
-(void)pullUp:(BaseTableView *)tableView{
    [self pullUpData];
}
//点击
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *weibo = [_weibos objectAtIndex:indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.weiboModel = weibo;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
