//
//  MoreViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "AboutViewController.h"
#import "HomeViewController.h"
#import "BrowModeViewController.h"

@interface MoreViewController ()

//@property(nonatomic,retain)NSArray *items;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.doNotHideTabBar = YES;
       // self.items = @[@"设置主题",@"登出帐号"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //获取每个分组里面有多少行
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MoreTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"主题切换";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"缩略图设置";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
        
    }else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"清空本地缓存";
                break;
            case 1:
                cell.textLabel.text = @"关于Lo";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }

    }else if(indexPath.section == 2){
        cell.textLabel.text = @"登出帐号";
        cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:30/255.0f blue:30/255.0f alpha:1];
        //cell.contentView.backgroundColor = [UIColor colorWithRed:255/255.0f green:0 blue:0 alpha:.5];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int selectedRow =indexPath.row;
    int section = indexPath.section;
    if(section == 0 ){
        ThemeViewController *themeCtrl = [[ThemeViewController alloc] init];
        BrowModeViewController *brow = [[BrowModeViewController alloc]init];
        switch (selectedRow) {
            case 0:
                [self.navigationController pushViewController:themeCtrl animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:brow animated:YES];
                break;
            default:
                break;
        }

     
    }else if(section == 2 && selectedRow == 0){
        //登出
        UIActionSheet *uiaction = [[UIActionSheet alloc]initWithTitle:@"您确定要登出当前帐号吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [uiaction showInView:self.view];
    }else if(section == 1){
        AboutViewController *about = [[AboutViewController alloc]init];
        UINavigationController *homeNav = [self.tabBarController.viewControllers objectAtIndex:0];
        HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
        switch (indexPath.row) {
            case 0:
                [ProgressHUD showSuccess:@"本地缓存清空完毕!"];
                [MoreViewController clearLocalCache];
                [homeCtrl refreshWeibo];
                break;
            case 1:
                [self.navigationController pushViewController:about animated:YES];
                break;
            default:
                break;
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //确定登出
        [self logouting];
    }
}

-(void)logouting{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView *clear = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 9999, 9999)];
    clear.backgroundColor = [UIColor clearColor];
    [myDelegate.window addSubview:clear];
    [ProgressHUD show:@"正在注销"];
    [self performSelector:@selector(logoutok) withObject:nil afterDelay:1];
}
-(void)logoutok{
    [ProgressHUD showSuccess:@"注销成功"];
    [MoreViewController clearLocalCache];
    [self performSelector:@selector(logoutok2) withObject:nil afterDelay:2
     ];
}
-(void)logoutok2{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wb_token delegate:myDelegate.mvc withTag:@"user1"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [myDelegate loginOut];
}

+(void)clearLocalCache{
    [[NSFileManager  defaultManager]removeItemAtPath:[UIUtils getDocumentsPath:@"WeiboArchData.loa"] error:nil]; //删除微博缓存
}

@end
