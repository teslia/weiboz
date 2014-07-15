//
//  RectButton.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-13.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "RectButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

-(void)awakeFromNib{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ .6,.6,.6, 1 });
    
    [self.layer setBorderColor:colorref];//边框颜色

}

-(void)setTitle:(NSString *)title{
    [self setTitle:nil forState:UIControlStateNormal];
    if(_rectTitleLabel == nil){
                _rectTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 66, 30)];
        _rectTitleLabel.backgroundColor = [UIColor clearColor];
        _rectTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rectTitleLabel.text = title;
        [self addSubview:_rectTitleLabel];
    }
}

-(void)setSubtitle:(NSString *)subtitle{
    if(_subtitleLabel == nil){
        _subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 66, 30)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:16.0f];
        _subtitleLabel.textColor = [UIColor blackColor];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.text = subtitle;
        [self addSubview:_subtitleLabel];
    }
}


@end
