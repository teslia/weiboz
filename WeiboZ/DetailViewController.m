//
//  DetailViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-20.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UserModel.h"
#import "CommentTableView.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "CommentModel.h"
#import "UserViewController.h"

@interface DetailViewController (){
    NSString *pubUserName;
}

@end

@implementation DetailViewController 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博正文";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.refreshHeader = YES;
    
    [self _initView];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_initView{

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.data = @[];
    NSString *userImageurl = _weiboModel.user.avatar_large;
    
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageurl]];
    
    self.nickLabel.text = _weiboModel.user.screen_name;
    pubUserName = _weiboModel.user.screen_name;
    [tableHeaderView addSubview:self.userBarView];
    tableHeaderView.height += 60;
    
    //======================== 微博视图开始 =========================
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc]initWithFrame:CGRectMake(10, _userBarView.bottom + 0, ScreenWidth - 20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+10);
    //======================== 微博结束开始 =========================
   
    NSNumber *comment_count = _weiboModel.comments_count;
    _comments_counts = [[UILabel alloc]initWithFrame:CGRectZero];
    _comments_counts.textColor = [UIColor colorWithRed:0 green:0 blue:100/255.0f alpha:1];
    _comments_counts.text = [NSString stringWithFormat:@"评论数(%@)",comment_count];
    _comments_counts.frame = CGRectMake(5, _weiboView.bottom+10 , 200, 20);
    _comments_counts.font = [UIFont systemFontOfSize:12.0f];
    tableHeaderView.height += 30;
    [tableHeaderView addSubview:_comments_counts];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.eventDelegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tableHeaderView.userInteractionEnabled = YES;
    [tableHeaderView addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    UserViewController *uvc = [[UserViewController alloc]init];
    uvc.userName = pubUserName;
    [self.navigationController pushViewController:uvc animated:YES];
}


-(void)loadData{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *wbid = [_weiboModel.weiboId stringValue];
    if(wbid.length == 0){
        return ;
    }
    NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"id":wbid};
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/comments/show.json" httpMethod:@"GET" params:param delegate:self withTag:nil];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSArray *array = [resultDict objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for(NSDictionary *dic in array){
        CommentModel *comment = [[CommentModel alloc]initWithDataDic:dic];
        [comments addObject:comment];
    }
    if([request.tag  isEqual: @"loadMoreComments"]){
        [comments removeObjectAtIndex:0];
        [_comments addObjectsFromArray:comments];
        self.tableView.data = _comments;
    }else{
        _comments = comments;
        self.tableView.data = comments;
    }
    if([comments count] == 0){
        self.tableView.isMore = NO;
    }

    [self.tableView reloadData];
}

#pragma mark - BaseTableView delegate
-(void)pullUp:(BaseTableView *)tableView{
    CommentModel *lastComment = [_comments lastObject];
    NSString *lastID = [lastComment.id stringValue];
    NSString *wbid = [_weiboModel.weiboId stringValue];
    if(lastID.length >0){
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"id":wbid,@"max_id":lastID};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/comments/show.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadMoreComments"];
    }else{
        
    }
    [self.tableView reloadData];
}
-(void)pullDown:(BaseTableView *)tableView{
    CommentModel *lastComment = [_comments lastObject];
    NSString *lastID = [lastComment.id stringValue];
    NSString *wbid = [_weiboModel.weiboId stringValue];
    if(lastID.length >0){
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"id":wbid,@"max_id":lastID};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/comments/show.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadMoreComments"];
    }else{
        
    }
    [self.tableView reloadData];
    [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

@end
