//
//  UIFactory.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-5.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UIFactory.h"


@implementation UIFactory

+(ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName{
    ThemeButton *button = [[ThemeButton alloc]initWithImage:imageName highlighted:highlightedName];
    return button;
}
+(ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName backgroundhighlighted:(NSString *)backgroundHighlightedName{
    ThemeButton *button = [[ThemeButton alloc]initWithBackground:backgroundImageName highlighted:backgroundHighlightedName];
    return button;
}

+ (UIButton *)createNavigationButton:(CGRect)frame
                               title:(NSString *)title
                              target:(id)target
                              action:(SEL)action{
    ThemeButton *button = [self createButtonWithBackground:@"navigationbar_button_background.png" backgroundhighlighted:@"navigationbar_button_delete_background.png"];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    button.leftCapWidth = 3;
    
    
    return button;
}

+(ThemeImageView *)createImageView:(NSString *)imageName{
    ThemeImageView *themeImage = [[ThemeImageView alloc]initWithImageName:imageName];
    return themeImage;
}

+(ThemeLabel *)createLabel:(NSString *)colorName{
    ThemeLabel *themeLabel = [[ThemeLabel alloc]initWithColorName:colorName];
    return themeLabel;
}

@end
