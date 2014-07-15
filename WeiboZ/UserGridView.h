//
//  UserGridView.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserGridView : UIView

@property(nonatomic,copy) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
- (IBAction)userImageAction:(UIButton *)sender;

@end
