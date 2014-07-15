//
//  Zmsky-FaceView.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-26.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "Zmsky-FaceView.h"

#define ITEM_WIDTH  42
#define ITEM_HEIGHT 45

@implementation Zmsky_FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.pageNumber = items.count;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * row:4
 * colum:7
 * size:30x30
 */

/*
 * Items = [
        ["表情1",“表情2”,...,“表情28”],
        ["表情1",“表情2”,...,“表情28”],
        ["表情1",“表情2”,...,“表情28”],
        ["表情1",“表情2”,...,“表情28”],
 ];
 */
-(void)initData{
    items = [[NSMutableArray alloc]init];
    //------------  整理表情，整理成为一个二维数组结构
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *items2D = nil;
    for(int i = 0 ; i < fileArray.count ; i++){
        NSDictionary *item = [fileArray objectAtIndex:i];
        if(i % 28 == 0){
            items2D = [[NSMutableArray alloc]initWithCapacity:28];
            [items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    //设置尺寸
    self.width = items.count * 320;
    self.height = 4 * ITEM_HEIGHT;
    
    magnifierView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
    magnifierView.hidden = YES;
    magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:magnifierView];
    
    UIImageView *faceItem = [[UIImageView alloc]initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)];
    faceItem.tag = 2014;
    faceItem.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:faceItem];
}

/*
 * Items = [
 ["表情1",“表情2”,...,“表情28”],
 ["表情1",“表情2”,...,“表情28”],
 ["表情1",“表情2”,...,“表情28”],
 ["表情1",“表情2”,...,“表情28”],
 ];
 */
- (void)drawRect:(CGRect)rect
{
    //定义列、行
    int row = 0,colum= 0;
    for(int i = 0 ; i< items.count;i++){
        NSArray *items2D = [items objectAtIndex:i];
        for (int j = 0; j< items2D.count; j++) {
            NSDictionary *item = [items2D objectAtIndex:j];
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            CGRect frame = CGRectMake(colum*ITEM_WIDTH+17
                                      ,row*ITEM_HEIGHT+15,30,30);
            
            //考虑页数
            float x=(i*320) + frame.origin.x;
            frame.origin.x = x;
            
            [image drawInRect:frame];
            
            //更新列与行
            colum++;
            if(colum % 7 == 0){
                row++;
                colum = 0;
            }
            if(row ==4){
                row = 0;
            }
        }
    }
    
}

-(void)touchFace:(CGPoint)point{
    int page = point.x / 320;
    float x = point.x - (page * 320)-10;
    float y = point.y-10;
    
    //计算列与行
    int colum = x / ITEM_WIDTH;
    int row = y / ITEM_HEIGHT;
    
    //防止越界
    if(colum > 6){
        colum = 6;
    }
    if(colum < 0){
        colum = 0;
    }
    if(row > 3){
        row = 3;
    }
    if(row < 0){
        row = 0;
    }
    
    //计算索引
    @try {
        int index = colum + (row*7);
        NSArray *item2D = [items objectAtIndex:page];
        NSDictionary *item = [item2D objectAtIndex:index];
        NSString *faceName = [item objectForKey:@"chs"];
        
        if(![self.selectFaceName isEqualToString:faceName] || self.selectFaceName == nil){
            self.selectFaceName = faceName;
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            magnifierView.left = (page*320)+colum*ITEM_WIDTH;
            magnifierView.bottom = row*ITEM_HEIGHT + 30;
            UIImageView *faceItem = (UIImageView *)[magnifierView viewWithTag:2014];
            faceItem.image = image;
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   }

//touch事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollview = (UIScrollView *)self.superview;
        scrollview.scrollEnabled = NO;
    }

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden =YES;
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollview = (UIScrollView *)self.superview;
        scrollview.scrollEnabled = YES;
    }
    
    if(self.block != nil){
        _block(_selectFaceName);
    }
   }
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden =YES;
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollview = (UIScrollView *)self.superview;
        scrollview.scrollEnabled = YES;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //magnifierView.hidden =YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}
@end
