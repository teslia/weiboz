//
//  MainViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController <WBHttpRequestDelegate,UINavigationControllerDelegate>{
    UIView *_tabbarView;
    UIImageView *_badgeView;

}

-(void)showBadge:(BOOL)show;
-(void)showTabBar:(BOOL)show;

@end
