//
//  BaseTableView.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-15.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)awakeFromNib{
    [self _initView];
}



-(void)_initView{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    self.dataSource = self;
    self.delegate = self;
    //_refreshHeaderView.backgroundColor = [UIColor clearColor]
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 20, ScreenWidth, 40);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_moreButton setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    [_moreButton setTitle:@">> 继续滑动或点击这里加载更多 <<" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 10, 20, 20);
    activityView.tag = 2014;
    [activityView stopAnimating];
    [_moreButton addSubview:activityView];
    self.tableFooterView  = _moreButton;
    
    self.isMore = YES;
}

-(void)_startLoadMore{
    [_moreButton setTitle:@"  正在加载..." forState:UIControlStateNormal];
    _moreButton.enabled = NO;
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2014];
    [activityView startAnimating];
}

-(void)_stopLoadMore{
    if(self.data.count > 0){
        _moreButton.hidden = NO;
        [_moreButton setTitle:@">> 继续滑动或点击这里加载更多 <<" forState:UIControlStateNormal];
        _moreButton.enabled = YES;
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2014];
        [activityView stopAnimating];
        if(!self.isMore){
            _moreButton.enabled = NO;
            [_moreButton setTitle:@"已经没有更多了" forState:UIControlStateNormal];
            if(self.refreshHeader){
                [ProgressHUD showError:@"已经没有更多了"];
            }
        }
    }else{
        _moreButton.hidden = YES;
    }
}


-(void)loadMoreAction{
    if([self.eventDelegate respondsToSelector:@selector(pullUp:)]){
        [self.eventDelegate pullUp:self];
        [self _startLoadMore];
    }
}

-(void)setRefreshHeader:(BOOL)refreshHeader{
    _refreshHeader = refreshHeader;
    if(self.refreshHeader){
        [self addSubview:_refreshHeaderView];
    }else{
        //if([_refreshHeaderView superview]){
            [_refreshHeaderView removeFromSuperview];
        //}
    }
}

-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(_refreshHeader){
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if(self.isMore){
        float offset = scrollView.contentOffset.y;
        float contentHeight = scrollView.contentSize.height;
        float sub = contentHeight - offset;
        if(scrollView.height - sub >50){
            [_moreButton setTitle:@">> 松开手指加载更多 <<" forState:UIControlStateNormal];
        }else{
            [_moreButton setTitle:@">> 继续滑动或点击这里加载更多 <<" forState:UIControlStateNormal];
        }
    }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(_refreshHeader){
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if(self.isMore){
        float offset = scrollView.contentOffset.y;
        float contentHeight = scrollView.contentSize.height;
        float sub = contentHeight - offset;
        if(scrollView.height  - sub > 50){
            [self _startLoadMore];
            [self loadMoreAction];
            self.isMore = NO;
        }
    }
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    if([self.eventDelegate respondsToSelector:@selector(pullDown:)]){
        [self.eventDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

-(void)reloadData{
    [super reloadData];
    [self _stopLoadMore];
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)refreshData{
    [_refreshHeaderView initLoading:self];
}



@end
