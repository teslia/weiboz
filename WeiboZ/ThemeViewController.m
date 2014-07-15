//
//  ThemeViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-4.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()
{
    int selectedIndex;
    NSString *sysThemeName;
}
@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更改主题";
        themes = [[ThemeManager shareInstance].themePlist allKeys];
        selectedIndex = 9999;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    sysThemeName = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeSetKey"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //获取有多少个分组
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return themes.count;
    }
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"   请选择一个主题：";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identify = @"themeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            UILabel *textLabel = [UIFactory createLabel:kThemeListLabel];
            textLabel.frame = CGRectMake(55,6,200,30);
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            textLabel.tag = 2013;
            [cell.contentView addSubview:textLabel];
        }
        
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:2013];
        textLabel.text = themes[indexPath.row];
        
        //cell.textLabel.text = themes[indexPath.row];
        UIImage *image = [[ThemeManager shareInstance]getThemeImage:@"icon_30.png" withThemeName:themes[indexPath.row]];
        if(image == nil){
            image = [UIImage imageNamed:@"icon_30"];
        }
        if(indexPath.row == selectedIndex){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else if([sysThemeName isEqualToString:themes[indexPath.row]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = image;
        return cell;
    }else{
        static NSString *identify = @"themeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            UILabel *textLabel = [UIFactory createLabel:kThemeListLabel];
            textLabel.frame = CGRectMake(60,6,200,30);
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            textLabel.tag = 2013;
            textLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:textLabel];
        }
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:2013];
        textLabel.text = @"获取更多主题";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSString *themeName = themes[indexPath.row];
        [[ThemeManager shareInstance]setThemeName:themeName];
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeDidChangeNotifcation object:themeName];
        selectedIndex = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadData];
        [[NSUserDefaults standardUserDefaults]setObject:themeName forKey:@"ThemeSetKey"];
        sysThemeName = nil;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能暂不开放，敬请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
