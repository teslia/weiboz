//
//  SendViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-6-18.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "Zmsky-ScrollView.h"

@interface SendViewController : BaseViewController <WBHttpRequestDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>{
    NSMutableArray *buttons;
    UIImageView *fullImageView;
    CGFloat lastScale;
    Zmsky_ScrollView *_faceView;
}

//send data
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property(nonatomic,retain) UIImage *sendImage;

@property (nonatomic,retain) UIButton *sendImageButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *editorBar;
@property (weak, nonatomic) IBOutlet UIView *placeView;
@property (weak, nonatomic) IBOutlet UIImageView *placeBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
