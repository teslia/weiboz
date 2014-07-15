//
//  UserGridView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UserGridView.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *gridView = [[[NSBundle mainBundle]loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        self.size = gridView.size;
        gridView.backgroundColor = [UIColor clearColor];
        [self addSubview:gridView];
        
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroundView = [[UIImageView alloc]initWithImage:image];
        backgroundView.frame = self.bounds;
        [self insertSubview:backgroundView atIndex:0];
        }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.nickLabel.text = _userModel.screen_name;
    long favL = [_userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",favL];
    if(favL >= 10000){
        favL /= 10000;
        fans = [NSString stringWithFormat:@"%ld万",favL];
    }
    self.fansLabel.text = fans;
    
    NSString *urlString = _userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlString]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)userImageAction:(UIButton *)sender {
    UserViewController *userCtrl = [[UserViewController alloc]init];
    userCtrl.UID = self.userModel.idstr;
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
}
@end
