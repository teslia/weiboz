//
//  RightViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"


@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)sendAction:(UIButton *)sender {
    SendViewController *sendCtrl = [[SendViewController alloc]init];
    BaseNavigationController *sendNav = [[BaseNavigationController alloc]initWithRootViewController:sendCtrl];
    switch (sender.tag) {
        case 100:
            [self.appDelegate.menu presentViewController:sendNav animated:YES completion:NULL];
            break;
        case 101:
             [self.appDelegate.menu presentViewController:sendNav animated:YES completion:NULL];
            break;
        case 102:
             [self.appDelegate.menu presentViewController:sendNav animated:YES completion:NULL];
            break;
        case 103:
             [self.appDelegate.menu presentViewController:sendNav animated:YES completion:NULL];
            break;
        default:
            break;
    }
}
@end
