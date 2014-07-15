//
//  UIUtils.m
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"    NSString *regex = @"(@[-_\\w]+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";


@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+(NSString *)parseLink:(NSString *)text{
    NSString *regex = @"(@[-_\\w]+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    for(NSString *linkString in matchArray){
        
        NSString *repels;
        NSString *fixARC = linkString;
        if([linkString hasPrefix:@"@"]){
            repels = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[fixARC URLEncodedString],linkString];
        }else if([linkString hasPrefix:@"http"]){
            repels = [NSString stringWithFormat:@"<a href='http://%@'>%@</a>",[fixARC URLEncodedString],linkString];
        }else if([linkString hasPrefix:@"#"]){
            repels = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[fixARC URLEncodedString],linkString];
        }
        if(repels != nil){
            text = [text stringByReplacingOccurrencesOfString:linkString withString: repels];
        }
    }
    return text;
}

@end
