//
//  ThemeManager.h
//  WeiboZ
//  主题管理类

//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotifcation @"kThemeDidChangeNotifcation"

@interface ThemeManager : NSObject

//当前使用的主题名称
@property(nonatomic,retain) NSString *themeName;
@property(nonatomic,retain) NSDictionary *themePlist;
@property(nonatomic,retain) NSDictionary *fontColorPlist;

+(ThemeManager *)shareInstance;

//返回当前主题下，对应图片
-(UIImage *)getThemeImage:(NSString *)imageName;
-(UIImage *)getThemeImage:(NSString *)imageName withThemeName:(NSString *)themeName;

- (UIColor *)getColorWithName:(NSString *)name;

@end
