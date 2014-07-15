//
//  BrowModeViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-9.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BrowModeViewController.h"

@interface BrowModeViewController ()
{
    int selectedIndex;
}
@end

@implementation BrowModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"缩略图设置";
        selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:kBrowMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentify = @"BrowModeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"小图模式";
            break;
        case 1:
            cell.textLabel.text = @"大图模式";
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.row == selectedIndex){
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"设置微博列表预览图大小";
    }
    return @"";
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"大图模式将消耗更多的数据流量，若您在GPRS/3G模式下，建议您选择小图模式。";
}

@end
