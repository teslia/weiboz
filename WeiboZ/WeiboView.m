//
//  WeiboView.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-11.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "AppDelegate.h"
#import "UIUtils.h"
//#import "HomeViewController.h"
#import "UserViewController.h"

#define LIST_FONT               14.0f   //列表中的文本字体
#define LIST_REPORT_FONT        13.0f   //列表中的转发的文本字体
#define DETAIL_FONT             16.0f   //详情的文本字体
#define DETAIL_REPOST_FONT      14.0f   //详情种的转发文本

@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText = [[NSMutableString alloc]init];
    }
    return self;
}

//初始化子视图
-(void) _initView{
    //微博内容
    _textLabel = [[RTLabel alloc]init];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.linkAttributes = @{@"color":@"#4595CB"};
    _textLabel.selectedLinkAttributes = @{@"color":@"darkGray"};
    [self addSubview:_textLabel];
    //微博图片
    _image = [[UIImageView alloc]initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loadding.png"];
    [self addSubview:_image];
    
    _repostBackgroundView = [UIFactory createImageView:@"timeline_retweet_background.png"];
    UIImage *image = [_repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroundView.image = image;
    _repostBackgroundView.leftCapWidth = 25;
    _repostBackgroundView.topCapHeight = 10;
    _repostBackgroundView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackgroundView atIndex:0];
    
    //
}

//解析超链接
-(void)parseLink{
    [_parseText setString:@""];
    
    if(_isRepost){
        //将源微博作者拼接
        //源微博作者昵称
        NSString *nickName = _weiboModel.user.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [_parseText appendFormat:@"<a href='user://%@'>@%@</a>：",encodeName,nickName];
    }
    
    NSString *text = _weiboModel.text;
    text = [UIUtils parseLink:text];
    [_parseText appendString:text];
}

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    //创建转发的微博视图
    if(_repostView == nil){
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        _repostView.isDetail = self.isDetail;
        [self addSubview:_repostView];
    }
    [self parseLink];
}

-(void)_renderLabel{
        _textLabel.frame = CGRectMake(0,0,self.width,20);
    if(self.isRepost){
        _textLabel.frame = CGRectMake(10,10,self.width-15,0);
        
    }
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.text = _parseText;
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
}

-(void)_renderWeibo{
    WeiboModel *repostWeibo = _weiboModel.relWeibo;
    if(repostWeibo!=nil){
        _repostView.weiboModel = repostWeibo;
        float height = [WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
        _repostView.hidden = NO;
    }else{
        _repostView.hidden = YES;
    }
}

-(void)_renderImage{
    if(self.isDetail){
        NSString *bmiddleImage = _weiboModel.bmiddle_pic;
        if(bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
            _image.hidden = NO;
            _image.contentMode = UIViewContentModeScaleAspectFit;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 280, 200);
            [_image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        }else{
            _image.hidden = YES;
        }
    }else{
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        //缩略图
        if(mode == 0){
            NSString *thumbnailImage = _weiboModel.thumbnail_pic;
            if(thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]){
                _image.hidden = NO;
                _image.contentMode = UIViewContentModeScaleAspectFit;
                _image.frame = CGRectMake(10, _textLabel.bottom+4, 70, 80);
                [_image setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            }else{
                _image.hidden = YES;
            }
        }else if(mode == 1){
            NSString *bmiddleImage = _weiboModel.bmiddle_pic;
            if(bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
                _image.hidden = NO;
                _image.contentMode = UIViewContentModeScaleAspectFit;
                _image.frame = CGRectMake(10, _textLabel.bottom+4, self.width - 20, 180);
                [_image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
            }else{
                _image.hidden = YES;
            }
        }

    }

}

-(void)_renderBackground{
    if(self.isRepost){
        _repostBackgroundView.frame = self.bounds;
        _repostBackgroundView.hidden = NO;
    }else{
        _repostBackgroundView.hidden = YES;
    }
}

//展示数据 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.isRepost){
        self.clipsToBounds = YES;
    }
    //--------------微博内容------------
    [self _renderLabel];
    //------------转发的微博视图——textLabel子视图------------
    [self _renderWeibo];
    //---------------微博图片视图--------------
    [self _renderImage];
    //----------------转发的微博视图背景---------------------
    [self _renderBackground];
}

+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                    isRepost:(BOOL)isRepost
                    isDetail:(BOOL)isDetail{
    /**
     *  实现思路：计算每个视图的高度，然后相加。
     **/
    
    //------------------计算微博内容text的高度------------------------
    float height = 0;
    RTLabel *textLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
    float fontsize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontsize];
    if(isDetail){ //判断是否是详情
        textLabel.width = kWeibo_Width_Detail;
    }else{
        textLabel.width = kWeibo_Width_List;
    }
    textLabel.text = weiboModel.text;
    
    
    //------------------计算微博图片的高度------------------------
    if(isDetail){
        NSString *bmiddleImage = weiboModel.bmiddle_pic;
        if(bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
            height += 200;
        }
    }else{
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if(mode == 0){
            NSString *thumbnailImage = weiboModel.thumbnail_pic;
            if(thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]){
                height += 90;
            }
        }else{
            NSString *bmiddleImage = weiboModel.bmiddle_pic;
            if(bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
                height += 190;
            }
        }
    }
    
    
    //------------------计算转发微博图片的高度------------------------
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if(relWeibo != nil){
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += repostHeight;
    }
    
    if(isRepost){
        NSMutableString *parseText = [NSMutableString string];
        [parseText setString:weiboModel.text];
        NSString *nickName = weiboModel.user.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [parseText appendFormat:@"<a href='user://%@'>@%@</a>：",encodeName,nickName];
        textLabel.text = parseText;
        textLabel.width -= 35;
        height+=18;
    }
    height += textLabel.optimumSize.height;
    return height;
}

+(float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost{
    float fontSize = 14.0f;
    
    if(!isDetail && !isRepost){
        return LIST_FONT;
    }
    else if(!isDetail && isRepost){
        return LIST_REPORT_FONT;
    }
    else if(isDetail && !isRepost){
        return DETAIL_FONT;
    }
    else if(!isDetail && isRepost){
        return DETAIL_REPOST_FONT;
    }
    
    return fontSize;
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    NSString *urlString = [url host];
    urlString = [urlString URLDecodedString];
    if([urlString hasPrefix:@"@"]){
        
        UserViewController *vc = [[UserViewController alloc]init];
        urlString = [urlString substringFromIndex:1];
        vc.userName = urlString;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"用户：%@",urlString);
    }else if([urlString hasPrefix:@"http"]){
        //NSLog(@"连接：%@",urlString);
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [myDelegate openWeb:urlString];
    }else if([urlString hasPrefix:@"#"]){
        NSLog(@"话题：%@",urlString);
    }
}

@end
