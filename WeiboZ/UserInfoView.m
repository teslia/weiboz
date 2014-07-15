
//  UserInfoView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-10.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UserInfoView.h"
#import "RectButton.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "FirendshipViewController.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        [self addSubview:view];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //用户头像图片
    NSString *userString = self.user.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:userString]];
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.masksToBounds = YES;
    //昵称
    self.nameLabel.text = self.user.screen_name;
    //性别
    NSString *gender = self.user.gender;
    NSString *sexName = @"未知";
    if([gender isEqualToString:@"m"]){
        sexName = @"男";
    }else if([gender isEqualToString:@"f"]){
        sexName = @"女";
    }
    //地址
    NSString *location = self.user.location;
    if(location == nil){
        location = @"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",sexName,location];
    //简介
    self.infoLabel.text = (self.user.description==nil)? @"该用户没有简介": self.user.description;
    
    //微博数
    NSString *count = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",count];
    //粉丝数
    long favL = [self.user.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",favL];
    if(favL >= 10000){
        favL /= 10000;
        fans = [NSString stringWithFormat:@"%ld万",favL];
    }
    self.fansButton.title = @"粉丝";
    self.fansButton.subtitle = fans;
    //关注数
    self.attButton.subtitle = [self.user.friends_count stringValue];
    self.attButton.title = @"关注";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//FirendshipViewController

- (IBAction)attAction:(id)sender {
    FirendshipViewController *friendCtrl = [[FirendshipViewController alloc]init];
    friendCtrl.userID = _user.idstr;
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
}

- (IBAction)fansAction:(id)sender {
    FirendshipViewController *friendCtrl = [[FirendshipViewController alloc]init];
    friendCtrl.userID = _user.idstr;
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
}
@end
