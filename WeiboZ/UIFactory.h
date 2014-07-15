//
//  UIFactory.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-5.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

+(ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName;
+(ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName backgroundhighlighted:(NSString *)backgroundHighlightedName;

+ (UIButton *)createNavigationButton:(CGRect)frame
                              title:(NSString *)title
                              target:(id)target
                              action:(SEL)action;

+(ThemeImageView *)createImageView:(NSString *)imageName;

+(ThemeLabel *)createLabel:(NSString *)colorName;
@end
