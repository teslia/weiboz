//
//  ThemeImageView.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-5.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property(nonatomic,copy) NSString *imageName;

@property(nonatomic,assign) int leftCapWidth;
@property(nonatomic,assign) int topCapHeight;

-(id)initWithImageName:(NSString *)imageName;

@end
