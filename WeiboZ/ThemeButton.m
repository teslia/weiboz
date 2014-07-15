//
//  ThemeButton.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

-(id)init{
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotifcation object:nil];
    }
    return self;
}


-(id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightedImageName{
    if(self = [self init]){
        self.imageName = imageName;
        self.highlightImageName = highlightedImageName;
    }
    return self;
}

-(id)initWithBackground:(NSString *)backgroundImageName
            highlighted:(NSString *)backgroundHighlightImageName{
    if(self = [self init]){
        self.backgroundImageName = backgroundImageName;
        self.backgroundHighlightImageName = backgroundHighlightImageName;
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)themeNotification:(NSNotification *)notification{
    [self loadThemeImage];
}

-(void)loadThemeImage{
    ThemeManager *themeManager = [ThemeManager shareInstance];
    UIImage *image = [themeManager getThemeImage:_imageName];
    image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    UIImage *highlightImage = [themeManager getThemeImage:_highlightImageName];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    [self setImage:highlightImage forState:UIControlStateSelected];
    
    UIImage *backImage = [themeManager getThemeImage:_backgroundImageName];
    UIImage *backHighlightImage = [themeManager getThemeImage:_backgroundHighlightImageName];
    backImage = [backImage stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    backHighlightImage = [backHighlightImage stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self setBackgroundImage:backHighlightImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:backHighlightImage forState:UIControlStateSelected];
}

#pragma mark - setter

-(void)setLeftCapWidth:(int)leftCapWidth{
    _leftCapWidth = leftCapWidth;
    [self loadThemeImage];
}

-(void)setTopCapHeight:(int)topCapHeight{
    _topCapHeight = topCapHeight;
    [self loadThemeImage];
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self loadThemeImage];
}

-(void)setHighlightImageName:(NSString *)highlightImageName{
    _highlightImageName = highlightImageName;
    [self loadThemeImage];
}

-(void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    [self loadThemeImage];
}

-(void)setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName{
    _backgroundHighlightImageName = backgroundHighlightImageName;
    [self loadThemeImage];
}

@end
