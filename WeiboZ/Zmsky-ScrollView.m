//
//  Zmsky-ScrollView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-26.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "Zmsky-ScrollView.h"

@implementation Zmsky_ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
-(id)initWithBlock:(SelectBlock)block{
    self = [self initWithFrame:CGRectZero];
    if(self != nil){
        faceView.block = block;
    }
    return self;
}

-(void)initViews{
    faceView = [[Zmsky_FaceView alloc]initWithFrame:CGRectZero];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 3, 320, faceView.height+5)];
    scrollView.contentSize = CGSizeMake(faceView.width, faceView.height-50);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = NO;
    scrollView.directionalLockEnabled = YES;
    [scrollView addSubview:faceView];
    [self addSubview:scrollView];
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(-20, scrollView.bottom+5, 40, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = faceView.pageNumber;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    
    self.height = scrollView.height + pageControl.height +11;
    self.width = scrollView.width;
   
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    int pageNumber = _scrollView.contentOffset.x / 320;
    pageControl.currentPage = pageNumber;
}


- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"emoticon_keyboard_background"] drawInRect:rect];
}


@end
