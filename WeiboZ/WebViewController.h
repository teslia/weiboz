//
//  WebViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-15.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) UIWebView *web;

-(id)initWithURL:(NSString *)url;
@end
