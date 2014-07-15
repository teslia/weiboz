//
//  AboutViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-19.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)gotoLoWebsite{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate openWeb:@"http://xloli.net/?appref=loc-ios&actref=about&version=1.0.1"];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButton];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setButton{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"官方网站 " style:UIBarButtonItemStyleBordered target:self action:@selector(gotoLoWebsite)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
