//
//  SendViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-18.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "AppDelegate.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发布新微博";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttons = [[NSMutableArray alloc]initWithCapacity:6];
    UIButton *button = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancelAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    UIButton *sendbutton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *send = [[UIBarButtonItem alloc]initWithCustomView:sendbutton];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = send;
    [self _initViews];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
}



-(void)_initViews{
    NSArray *imageNames = @[@"compose_locatebutton_background.png",@"compose_camerabutton_background.png",@"compose_trendbutton_background.png",@"compose_mentionbutton_background.png",@"compose_emoticonbutton_background.png",@"compose_keyboardbutton_background.png"];
    NSArray *imageHighted = @[@"compose_locatebutton_background_highlighted.png",@"compose_camerabutton_background_highlighted.png",@"compose_trendbutton_background_highlighted.png",@"compose_mentionbutton_background_highlighted.png",@"compose_emoticonbutton_background_highlighted.png",@"compose_keyboardbutton_background_highlighted.png"];
    for(int i = 0 ; i< imageNames.count;i++){
        NSString *imageName = [imageNames objectAtIndex:i];
        NSString *hightedName = [imageHighted objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:hightedName];
        //[button setImage:[UIImage imageNamed:hightedName] forState:UIControlStateHighlighted];
        button.tag = (10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+(64*i),25,23,19);
        [self.editorBar addSubview:button];
        [buttons addObject:button];
        
        if(i == 5){
            button.hidden = YES;
            button.left -= 64;
        }
    }
    
    UIImage *image = [self.placeBackgroundView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.placeBackgroundView.image = image;
    self.placeBackgroundView.width = 200;
    self.placeLabel.left = 33;
    self.placeLabel.width = 160;
}


-(void)doSendData{
    NSString *text = self.textView.text;
    if(text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"不能发送" message:@"不能发送一条没有内容的微博！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.navigationItem.rightBarButtonItem.Enabled = NO;
    self.navigationItem.leftBarButtonItem.Enabled = NO;
    self.textView.userInteractionEnabled = NO;
    self.editorBar.hidden = YES;
    self.textView.height = ScreenHeight;
    [self showStatusTip:YES title:@"发送中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.appDelegate.wb_token,@"access_token",text,@"status", nil];
    if(_longitude.length > 0){
        [param setObject:_longitude forKey:@"long"];
    }
    if(_latitude.length > 0 ){
        [param setObject:_latitude forKey:@"lat"];
    }
    
    NSString *apiURL = @"https://api.weibo.com/2/statuses/update.json";
    if(self.sendImage != nil){
        apiURL = @"https://api.weibo.com/2/statuses/upload.json";
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 0.3);
        [param setObject:data forKey:@"pic"];
    }
    
    [WBHttpRequest requestWithURL:apiURL httpMethod:@"POST" params:param delegate:self withTag:@"SendDataAction"];
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    [self showStatusTip:NO title:@"发送成功!"];

    [self performSelector:@selector(cancelAction) withObject:nil afterDelay:2];
}

-(void)keyboardShowNotification:(NSNotification *)notification{
    NSValue *keyboardValue = [notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frame = [keyboardValue CGRectValue];
    float height = frame.size.height;
    self.editorBar.bottom = ScreenHeight - height-20-44;
    self.textView.bottom = ScreenHeight - height-20-44-55;
    self.textView.top = 0;
}

-(void)location{
    NearbyViewController *near = [[NearbyViewController alloc]init];
    //BaseNavigationController *naviCtrl = [[BaseNavigationController alloc]initWithRootViewController:near];
    //[self presentViewController:naviCtrl animated:YES completion:NULL];
    [self.navigationController pushViewController:near animated:YES];
    near.selectBlock = ^(NSDictionary *result){
        self.latitude = [result objectForKey:@"lat"];
        self.longitude = [result objectForKey:@"lon"];
        
        NSString *title = [result objectForKey:@"title"];
        self.placeLabel.text = title;
        self.placeView.hidden = NO;
    };
}

-(void)selectImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择相册", nil];
    [actionSheet showInView:self.view];
}

-(void)buttonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 10:
            [self location];
            break;
        case 11:
            [self selectImage];
            break;
        case 12:
            [self addHuati];
            break;
        case 13:
            [self addAt];
            break;
        case 14:
            [self showFaceView];
            break;
        case 15:
            [self showKeyboard];
            break;
        default:
            break;
    }
}


-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)sendAction{
    [self doSendData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if(buttonIndex == 0){
        BOOL isCrmera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if(!isCrmera){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此设备没有摄像头！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1){
        //选择用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 2){
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.sendImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(self.sendImageButton == nil){
        self.sendImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendImageButton.layer.cornerRadius = 5;
        self.sendImageButton.layer.masksToBounds = YES;
        self.sendImageButton.frame = CGRectMake(5,20,25,25);
        [self.sendImageButton addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.sendImageButton setImage:self.sendImage forState:UIControlStateNormal];
    [self.editorBar addSubview:self.sendImageButton];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.textView becomeFirstResponder];
    
    UIButton *button1 = [buttons objectAtIndex:0];
    UIButton *button2 = [buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 5, 0);
    }];
}

-(void)imageAction:(UIButton *)sender{
    if(fullImageView == nil){
        fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        fullImageView.backgroundColor = [UIColor blackColor];
        fullImageView.userInteractionEnabled = YES;
        fullImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageAction:)];
        [fullImageView addGestureRecognizer:tapGesture];
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
        pinchRecognizer.delegate = self;
        [fullImageView addGestureRecognizer:pinchRecognizer];
        
        //trash.png
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [deleteButton setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(280, 0, 40, 52);
        deleteButton.tag = 100;
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [fullImageView addSubview:deleteButton];
    }
    if(![fullImageView superview]){
        fullImageView.image = self.sendImage;
        [self.view.window addSubview:fullImageView];
        [self.textView resignFirstResponder];
        fullImageView.frame = CGRectMake(5, ScreenHeight - 240, 20, 20);
        [UIView animateWithDuration:.4 animations:^{
            fullImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden = YES;
            [fullImageView viewWithTag:100].hidden = NO;
        }];
    }
}

-(void)deleteAction:(UIButton *)sender{
    [self scaleImageAction:nil];
    [self.sendImageButton removeFromSuperview];
    UIButton *button1 = [buttons objectAtIndex:0];
    UIButton *button2 = [buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
    }];
    self.sendImage = nil;
    
}

-(void)scaleImageAction:(UITapGestureRecognizer *)tap{
    [fullImageView viewWithTag:100].hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:.4 animations:^{
        fullImageView.frame = CGRectMake(5, ScreenHeight - 240, 0, 0);
    } completion:^(BOOL finished) {        
        [fullImageView removeFromSuperview];
        [self.textView becomeFirstResponder];
    }];
}

-(void)showFaceView{
    [self.textView resignFirstResponder];
    if(_faceView == nil){
        __block SendViewController *this = self;
        _faceView = [[Zmsky_ScrollView alloc]initWithBlock:^(NSString *faceName) {
            NSString *text = this.textView.text;
            text = [text stringByAppendingString:faceName];
            this.textView.text = text;
        }];
        _faceView.top = ScreenHeight - 20 - 44 - _faceView.height;
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0,ScreenHeight-44-20);
        [self.view  addSubview:_faceView];
    }
    
    UIButton *facebutton = [buttons objectAtIndex:4];
    UIButton *keyboard = [buttons objectAtIndex:5];
    facebutton.alpha = 1;
    keyboard.alpha = 0;
    keyboard.hidden = NO;
    [UIView animateWithDuration:0.3
    animations:^{
        _faceView.transform = CGAffineTransformIdentity;
        facebutton.alpha = 0;
        float height = _faceView.height;
        self.editorBar.bottom = ScreenHeight - height - 20 -40;
        self.textView.height = self.editorBar.top;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            keyboard.alpha = 1;
        }];
    }];
}

-(void)showKeyboard{
    //[self.textView becomeFirstResponder];
    
    UIButton *facebutton = [buttons objectAtIndex:4];
    UIButton *keyboard = [buttons objectAtIndex:5];
    facebutton.alpha = 0;
    keyboard.alpha = 1;
    keyboard.hidden = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0,ScreenHeight-44-20);
                         facebutton.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3 animations:^{
                             keyboard.alpha = 0;
                         }];
                     }];

}



-(void)addHuati{
    NSString *text = self.textView.text;
    text = [text stringByAppendingString:@"##"];
    self.textView.text = text;
    NSUInteger length = self.textView.text.length;
    self.textView.selectedRange = NSMakeRange(length-1,0);
}

-(void)addAt{
    NSString *text = self.textView.text;
    text = [text stringByAppendingString:@"@"];
    self.textView.text = text;
}

-(void)scaGesture:(id)sender {
    //[fullImageView bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    //当手指离开屏幕时,将lastscale设置为1.0
    //if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
    //    lastScale = 1.0;
    //    return;
    //}
    
    //CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    //CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    //CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    //[[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
    //lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self showKeyboard];
    return YES;
}
@end
