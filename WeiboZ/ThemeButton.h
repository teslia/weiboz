//
//  ThemeButton.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property(nonatomic,copy) NSString *imageName;
@property(nonatomic,copy) NSString *highlightImageName;

@property(nonatomic,copy) NSString *backgroundImageName;
@property(nonatomic,copy) NSString *backgroundHighlightImageName;

@property(nonatomic,assign) int leftCapWidth;
@property(nonatomic,assign) int topCapHeight;

-(id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightedImageName;
-(id)initWithBackground:(NSString *)backgroundImageName
            highlighted:(NSString *)backgroundHighlightImageName;


@end
