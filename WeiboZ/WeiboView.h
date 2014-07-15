//
//  WeiboView.h
//  WeiboZ
//
//  Created by Zmsky on 14-5-11.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "ThemeImageView.h"

#define kWeibo_Width_List (320-60) //微博在列表中的宽度
#define kWeibo_Width_Detail 300    //微博在详情里面的宽度

@class WeiboModel;
@interface WeiboView : UIView <RTLabelDelegate>{
@private
    RTLabel             *_textLabel;  //微博内容
    UIImageView         *_image;      //微博图片
    ThemeImageView      *_repostBackgroundView; //转发的微博背景
    WeiboView           *_repostView;   //转发的微博视图
    NSMutableString     *_parseText;    
}

//微博模型对象
@property(nonatomic,retain) WeiboModel *weiboModel;

@property(nonatomic,assign) BOOL isRepost;  //是否是转发的微博视图

@property(nonatomic,assign) BOOL isDetail;  //是否显示在微博详情里面

+(float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;  //获取字体大小

+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                    isRepost:(BOOL)isRepost
                    isDetail:(BOOL)isDetail;

@end
