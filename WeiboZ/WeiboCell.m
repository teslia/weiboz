//
//  WeiboCell.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-11.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "Zmsky-ImageView.h"
#import "UserViewController.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    
    __block WeiboCell *this = self;
    _userImage.touchBlock = ^{
        NSString *nickName = this.weiboModel.user.screen_name;
        UserViewController *userCtrl = [[UserViewController alloc]init];
        userCtrl.userName = nickName;
        [this.viewController.navigationController pushViewController:userCtrl animated:YES];
        
    };
}

-(void)_initView{
    //用户头像//////////////////////////////////////////////////////////////
    _userImage = [[Zmsky_ImageView alloc]initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;  //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    //用户昵称//////////////////////////////////////////////////////////////
    _nickLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    //转发数//////////////////////////////////////////////////////////////
    _repostCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:10.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_repostCountLabel];
    //回复数//////////////////////////////////////////////////////////////
    //_commentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //_commentLabel.font = [UIFont systemFontOfSize:12.0];
    //_commentLabel.backgroundColor = [UIColor clearColor];
    //_commentLabel.textColor = [UIColor blackColor];
    //[self.contentView addSubview:_commentLabel];
    //来源 //////////////////////////////////////////////////////////////
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sourceLabel];
    //时间 //////////////////////////////////////////////////////////////
    _createLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor colorWithRed:0 green:0 blue:100/255.0 alpha:.8];
    [self.contentView addSubview:_createLabel];
    
    _weiboView = [[WeiboView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //用户头像
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.avatar_large;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    //昵称
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    //微博视图
    _weiboView.weiboModel = _weiboModel;
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom + 10, kWeibo_Width_List, h);
    //发布时间  E M d HH:mm:ss Z yyyy
    //01-23 14:05
    NSString *createDate = _weiboModel.createDate;
    NSString *datestring = [WeiboCell formatString:createDate];
    _createLabel.text = datestring;
    _createLabel.frame = CGRectMake(50,self.height - 18, 100, 18);
    [_createLabel sizeToFit];
    //转发数和回复数
    NSString *repStr = [NSString stringWithFormat:@"回复数:%@ 转发数:%@ ",_weiboModel.comments_count,_weiboModel.reposts_count];
    _repostCountLabel.text = repStr;
    //_commentLabel.text = comStr;
    _repostCountLabel.frame = CGRectMake(self.width - 210, 8 ,200, 15);
    _repostCountLabel.textAlignment = NSTextAlignmentRight;
    //微博来源
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    NSString *source = [NSString stringWithFormat:@"来自%@",[self parseSource:_weiboModel.source]];
    _sourceLabel.text = source;
    _sourceLabel.frame = CGRectMake(_createLabel.right+5, _createLabel.top, 100, 15);
    [_sourceLabel sizeToFit];
}

-(NSString *)parseSource:(NSString *)source{
    NSString *regex = @">.*<";
    NSArray *arr = [source componentsMatchedByRegex:regex];
    if(arr.count > 0){
        NSString *ret = [arr objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = ret.length - 2;
        NSString *resultString = [ret substringWithRange:range];
        return resultString;
    }
    return nil;
}

+(NSString *)formatString:(NSString *)datestring{
    NSDate *date = [UIUtils dateFromFomate:datestring formate:@"EEE MMM d HH:mm:ss Z yyyy"];
    NSString *datestring2 = [UIUtils stringFromFomate:date formate:@"MM-dd HH:mm"];
    return datestring2;
}
@end
