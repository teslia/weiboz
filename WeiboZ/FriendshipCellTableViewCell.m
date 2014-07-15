//
//  FriendshipCellTableViewCell.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "FriendshipCellTableViewCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendshipCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

-(void)initViews{
    for (int i =0; i<3; i++) {
        UserGridView *gridView = [[UserGridView alloc]initWithFrame:CGRectZero];
        gridView.tag = 2014 + i;
        [self.contentView addSubview:gridView];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for(int i =0;i<self.data.count;i++){
        UserModel *user = [self.data objectAtIndex:i];
        int tag = 2014 + i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.frame = CGRectMake(100*i+12, 10, 96, 96);
        gridView.userModel = user;
    }
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

@end
