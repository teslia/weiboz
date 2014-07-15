//
//  UIView+Additions.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-9.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)viewController{
    UIResponder *next = [self nextResponder];
    do{
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    }while (next != nil) ;
    return nil;
}

@end
