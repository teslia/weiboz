//
//  BaseNavigationController.h
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController <UINavigationControllerDelegate>

+(void)lock;
+(void)unlock;
@end
