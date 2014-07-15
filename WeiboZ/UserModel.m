//
//  UserModel.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-7.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

/**
@property(nonatomic,copy)NSString *idstr;           //字符串型的用户UID
@property(nonatomic,copy)NSString *screen_name;     //用户昵称
@property(nonatomic,copy)NSString *name;            //友好显示名称
@property(nonatomic,copy)NSString *location;        //用户所在地
@property(nonatomic,copy)NSString *description;     //用户个人描述
@property(nonatomic,copy)NSString *url;             //用户博客地址
@property(nonatomic,copy)NSString * profile_image_url;  //用户头像地址，50×50像素
@property(nonatomic,copy)NSString * avatar_large;  //用户大头像地址
@property(nonatomic,copy)NSString * gender;             //性别，m：男、f：女、n：未知
@property(nonatomic,retain)NSNumber * followers_count;    //粉丝数
@property(nonatomic,retain)NSNumber * friends_count;   //关注数
@property(nonatomic,retain)NSNumber * statuses_count;   //微博数
@property(nonatomic,retain)NSNumber * favourites_count;   //收藏数
@property(nonatomic,retain)NSNumber * verified;   //是否是微博认证用户，即加V用户，true：是，false：否
**/

//对属性的编码，归档的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_idstr forKey:@"idstr"];
    [aCoder encodeObject:_screen_name forKey:@"screen_name"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_profile_image_url forKey:@"profile_image_url"];
    [aCoder encodeObject:_avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_followers_count forKey:@"followers_count"];
    [aCoder encodeObject:_friends_count forKey:@"friends_count"];
    [aCoder encodeObject:_statuses_count forKey:@"statuses_count"];
    [aCoder encodeObject:_favourites_count forKey:@"favourites_count"];
    [aCoder encodeObject:_verified forKey:@"verified"];
}
//对属性的解，解归档的时候调用
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _idstr = [aDecoder decodeObjectForKey:@"idstr"];
        _screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _url = [aDecoder decodeObjectForKey:@"url"];
        _profile_image_url = [aDecoder decodeObjectForKey:@"profile_image_url"];
        _avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _followers_count = [aDecoder decodeObjectForKey:@"followers_count"];
        _friends_count = [aDecoder decodeObjectForKey:@"friends_count"];
        _statuses_count = [aDecoder decodeObjectForKey:@"statuses_count"];
        _favourites_count = [aDecoder decodeObjectForKey:@"favourites_count"];
        _verified = [aDecoder decodeObjectForKey:@"verified"];
    }
    return self;
}

@end
