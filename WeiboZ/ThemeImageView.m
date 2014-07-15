//
//  ThemeImageView.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-5.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

-(void) awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotifcation object:nil];
}

-(id)initWithImageName:(NSString *)imageName{
    if(self = [self init]){
        self.imageName = imageName;
    }
    return self;
}

-(id)init{
    if(self == [super init]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotifcation object:nil];
    }
    return self;
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self loadThemeImage];
}

-(void)loadThemeImage{
    if(self.imageName == nil){
        return;
    }
    UIImage *image = [[ThemeManager shareInstance]getThemeImage:_imageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image = image;
}

#pragma mark - NSNotification actions
-(void)themeNotification:(NSNotification *)notification{
    [self loadThemeImage];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
