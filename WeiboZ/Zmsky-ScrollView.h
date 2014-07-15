//
//  Zmsky-ScrollView.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-26.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zmsky-FaceView.h"

@interface Zmsky_ScrollView : UIView <UIScrollViewDelegate>{
    UIScrollView        *scrollView;
    Zmsky_FaceView      *faceView;
    UIPageControl       *pageControl;
}

-(id)initWithBlock:(SelectBlock)block;

@end
