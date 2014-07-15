//
//  Zmsky-ImageView.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-17.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface Zmsky_ImageView : UIImageView

@property(nonatomic,copy) ImageBlock touchBlock;

@end
