//
//  FridenShipTableView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "FridenShipTableView.h"
#import "FriendshipCellTableViewCell.h"

@implementation FridenShipTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self != nil){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FriendShipsCell";
    FriendshipCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell ==nil){
        cell = [[FriendshipCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    cell.data = array;
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

@end
