//
//  ThemeManager.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "ThemeManager.h"


@implementation ThemeManager

static ThemeManager *singleton = nil;

+(ThemeManager *)shareInstance{
    @synchronized(self){
        if(singleton == nil){
            singleton = [[ThemeManager alloc]init];
        }
    }
    return singleton;
}


#pragma mark - 下面的方法为了确保只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone{
    if(singleton == nil){
        singleton = [super allocWithZone:zone];
    }
    return  singleton;
}

- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}

-(id)init{
    if(self = [super init]){
        NSString *themePath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        self.themePlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        self.themeName = nil;
    }
    return self;
}

-(void)setThemeName:(NSString *)themeName{
    _themeName = themeName;
    NSString *themeDir = [self getThemePath];
    NSString *filePath = [themeDir stringByAppendingPathComponent:@"fontColor.plist"];
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

-(NSString *)getThemePath{
    NSString *path = [[NSBundle mainBundle]resourcePath];
    if(self.themeName == nil){
        return path;
    }
    NSString *themePath = [self.themePlist objectForKey:_themeName];
    //程序包路径
    NSString *thPath = [path stringByAppendingPathComponent:themePath];
    return thPath;
}

-(NSString *)getThemePathWithThemeName:(NSString *)themeName{
    NSString *path = [[NSBundle mainBundle]resourcePath];
    if(themeName == nil){
        return path;
    }
    NSString *themePath = [self.themePlist objectForKey:themeName];
    if(themePath.length == 0){
        return path;
    }
    //程序包路径
    NSString *thPath = [path stringByAppendingPathComponent:themePath];
    return thPath;
}

//返回当前主题下，对应图片
-(UIImage *)getThemeImage:(NSString *)imageName{
    if(imageName.length == 0){
        return  nil;
    }
    NSString *themePath = [self getThemePath];
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

-(UIImage *)getThemeImage:(NSString *)imageName withThemeName:(NSString *)themeName{
    if(imageName.length == 0){
        return  nil;
    }
    NSString *themePath = [self getThemePathWithThemeName:themeName];
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (UIColor *)getColorWithName:(NSString *)name{
    if(name.length == 0){
        return nil;
    }
    
    //rgb eg:12,34,56
    NSString *rgb = [_fontColorPlist objectForKey:name];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if(rgbs.count == 3){
        float r =[rgbs[0] floatValue];
        float b =[rgbs[1] floatValue];
        float g =[rgbs[2] floatValue];
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        return  color;
    }
    return nil;
}


@end
