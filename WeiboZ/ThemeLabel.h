//
//  ThemeLabel.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-6.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel

@property(nonatomic,copy) NSString *colorName;

-(id)initWithColorName:(NSString *)colorName;

@end
