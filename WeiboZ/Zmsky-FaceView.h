//
//  Zmsky-FaceView.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-26.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *faceName);

@interface Zmsky_FaceView : UIView{
@private
    NSMutableArray *items;
    UIImageView *magnifierView;
}

@property(nonatomic,copy)NSString *selectFaceName;
@property(nonatomic,assign) NSInteger pageNumber;
@property(nonatomic,copy) SelectBlock block;

@end
