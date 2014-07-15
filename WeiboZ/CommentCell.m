//
//  CommentCell.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-20.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "UserViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NSString+URLEncoding.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    _userImage = (Zmsky_ImageView *)[self viewWithTag:102];
    _nickLabel = (UILabel *)[self viewWithTag:100];
    _timeLabel = (UILabel *)[self viewWithTag:101];
    
    _contentLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    _contentLabel.linkAttributes = @{@"color":@"#4595CB"};
    _contentLabel.selectedLinkAttributes = @{@"color":@"darkGray"};
    [self.contentView addSubview:_contentLabel];
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *commentText = self.commentModel.text;
    _contentLabel.frame = CGRectMake(_userImage.right +5, _nickLabel.bottom+4, 260, 21);
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.height = _contentLabel.optimumSize.height;
    _nickLabel.text = _commentModel.user.screen_name;
    NSString *userImg = _commentModel.user.avatar_large;
    [_userImage setImageWithURL:[NSURL URLWithString:userImg]];
    _userImage.width = 50;
    _userImage.height = 50;
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.masksToBounds = YES;
    NSString *userTime = _commentModel.created_at;
    _timeLabel.text = [UIUtils fomateString:userTime];
    _userImage.userInteractionEnabled = YES;
    __block CommentCell *this = self;
    __block CommentModel *model = self.commentModel;
    _userImage.touchBlock = ^{
        NSString *nickName = model.user.screen_name;
        UserViewController *userCtrl = [[UserViewController alloc]init];
        userCtrl.userName = nickName;
        [this.viewController.navigationController pushViewController:userCtrl animated:YES];
    };
    
}

//- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
//    NSString *urlstring = self.commentModel.user.profile_image_url;
//    [_userImage setImageWithURL:[NSURL URLWithString:urlstring]];
//    _nickLabel.text = self.commentModel.user.screen_name;
//    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
//}

+(float) getCommentHeight:(CommentModel *)commentModel{
    RTLabel *rt = [[RTLabel alloc]initWithFrame:CGRectMake(0,0, 240, 0)];
    rt.text = commentModel.text;
    rt.font = [UIFont systemFontOfSize:14.0f];
    return rt.optimumSize.height;
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
