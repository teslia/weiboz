//
//  UserInfoView.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-10.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RectButton;
@class UserModel;
@interface UserInfoView : UIView

@property (nonatomic,retain) UserModel *user;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//Button
@property (weak, nonatomic) IBOutlet RectButton *attButton;
@property (weak, nonatomic) IBOutlet RectButton *fansButton;

- (IBAction)attAction:(id)sender;
- (IBAction)fansAction:(id)sender;

@end
