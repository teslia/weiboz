//
//  ThemeLabel.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-6.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

-(id)init{
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotifcation object:nil];

    }
    return self;
}

-(id)initWithColorName:(NSString *)colorName{
    if(self = [self init]){
        self.colorName = colorName;
    }
    return self;
}

-(void)setColorName:(NSString *)colorName{
    _colorName = colorName;
    [self setColor];
}

-(void)themeNotification:(NSNotification *)notification{
    [self setColor];
}

-(void)setColor{
   UIColor *textColor = [[ThemeManager shareInstance]getColorWithName:_colorName];
    self.textColor = textColor;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
