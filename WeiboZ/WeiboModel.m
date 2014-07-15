//
//  WeiboModel.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-7.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "WeiboModel.h"
//#import "UserModel.h"

@implementation WeiboModel

-(NSDictionary *)attributeMapDictionary{
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnail_pic":@"thumbnail_pic",
                             @"bmiddle_pic":@"bmiddle_pic",
                             @"original_pic":@"original_pic",
                             @"geo":@"geo",
                             //@"relWeibo":@"retweeted_status",
                             //@"user":@"user",
                             @"reposts_count":@"reposts_count",
                             @"comments_count":@"comments_count"
                             };
    return mapAtt;
}

-(void)setAttributes:(NSDictionary *)dataDic{
    //将字典数据根据关系填充到对象的属性上
    [super setAttributes:dataDic];
    
    NSDictionary *retweetDic = [dataDic objectForKey:@"retweeted_status"];
    if(retweetDic != nil){
    WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:retweetDic];
        self.relWeibo = weibo;
    }
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if(userDic != nil){
    UserModel *user = [[UserModel alloc]initWithDataDic:userDic];
        self.user = user;
    }
}

/**
 @property(nonatomic,copy) NSString          *createDate;    //微博创建时间
 @property(nonatomic,copy) NSNumber          *weiboId;       //微博ID
 @property(nonatomic,copy) NSString          *text;          //微博信息内容
 @property(nonatomic,copy) NSString          *source;        //微博来源
 @property(nonatomic,retain) NSNumber        *favorited;     //是否已收藏
 @property(nonatomic,copy) NSString          *thumbnail_pic; //微博图片缩略图
 @property(nonatomic,copy) NSString          *bmiddle_pic;   //中等尺寸图片
 @property(nonatomic,copy) NSString          *original_pic;  //原始图片地址
 @property(nonatomic,retain) NSDictionary    *geo;           //地理信息字段
 @property(nonatomic,retain) WeiboModel      *relWeibo;      //转发微博
 @property(nonatomic,retain) UserModel       *user;          //微博作者用户
 @property(nonatomic,retain) NSNumber        *reposts_count; //转发数
 @property(nonatomic,retain) NSNumber        *comments_count;//评论
 **/

//对属性的编码，归档的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_createDate forKey:@"CreateDate"];
    [aCoder encodeObject:_weiboId forKey:@"weiboId"];
    [aCoder encodeObject:_text forKey:@"text"];
    [aCoder encodeObject:_source forKey:@"source"];
    [aCoder encodeObject:_favorited forKey:@"favorited"];
    [aCoder encodeObject:_thumbnail_pic forKey:@"thumbnail_pic"];
    [aCoder encodeObject:_bmiddle_pic forKey:@"bmiddle_pic"];
    [aCoder encodeObject:_original_pic forKey:@"original_pic"];
    [aCoder encodeObject:_geo forKey:@"geo"];
    [aCoder encodeObject:_user forKey:@"user"];
    [aCoder encodeObject:_relWeibo forKey:@"relWeibo"];
    [aCoder encodeObject:_reposts_count forKey:@"reposts_count"];
    [aCoder encodeObject:_createDate forKey:@"createDate"];
    [aCoder encodeObject:_comments_count forKey:@"comments_count"];
}
//对属性的解，解归档的时候调用
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _createDate = [aDecoder decodeObjectForKey:@"CreateDate"];
        _weiboId = [aDecoder decodeObjectForKey:@"weiboId"];
        _text = [aDecoder decodeObjectForKey:@"text"];
        _source = [aDecoder decodeObjectForKey:@"source"];
        _favorited = [aDecoder decodeObjectForKey:@"text"];
        _thumbnail_pic = [aDecoder decodeObjectForKey:@"thumbnail_pic"];
        _bmiddle_pic = [aDecoder decodeObjectForKey:@"bmiddle_pic"];
        _original_pic = [aDecoder decodeObjectForKey:@"original_pic"];
        _geo = [aDecoder decodeObjectForKey:@"geo"];
        _user = [aDecoder decodeObjectForKey:@"user"];
        _relWeibo = [aDecoder decodeObjectForKey:@"relWeibo"];
        _reposts_count = [aDecoder decodeObjectForKey:@"reposts_count"];
        _createDate = [aDecoder decodeObjectForKey:@"createDate"];
        _comments_count = [aDecoder decodeObjectForKey:@"comments_count"];
    }
    return self;
}

@end
