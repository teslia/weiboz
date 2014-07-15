//
//  RectButton.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-13.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton{
    UILabel *_rectTitleLabel;
    UILabel *_subtitleLabel;
}

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;

@end
