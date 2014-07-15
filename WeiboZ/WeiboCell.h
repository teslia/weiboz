//
//  WeiboCell.h
//  WeiboZ
//  自定义微博cell
//  Created by Zmsky on 14-5-11.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;
@class Zmsky_ImageView;
@interface WeiboCell : UITableViewCell{
    Zmsky_ImageView         *_userImage;  //用户头像视图
    UILabel             *_nickLabel;    //昵称
    UILabel             *_repostCountLabel; //转发数
    UILabel             *_commentLabel;     //回复数
    UILabel             *_sourceLabel;      //发布来源
    UILabel             *_createLabel;      //发布时间
}

//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;
@property(nonatomic,retain)WeiboView *weiboView;

@end
