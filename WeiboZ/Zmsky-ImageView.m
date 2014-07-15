//
//  Zmsky-ImageView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-17.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "Zmsky-ImageView.h"

@implementation Zmsky_ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)awakeFromNib{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.touchBlock){
        _touchBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
