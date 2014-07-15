//
//  CommentModel.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-20.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];
    if(userDic != nil){
    UserModel *user = [[UserModel alloc]initWithDataDic:userDic];
    self.user = user;
    }
    if(statusDic != nil){
    WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statusDic];
        self.weibo = weibo;
    }
}

@end
