//
//  ViewController5.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/28.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "ViewController5.h"
#define topSpace 40
#define space 10
#define column 3
#define row 4

@interface ViewController5 ()
{
    NSMutableArray *imageViews;
    NSMutableArray *imageURL;
    UIScrollView *scrollView;
}
- (void)loadImage;
@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)layoutUI
{
    imageViews = [NSMutableArray array];
    imageURL = [NSMutableArray array];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = YES;
    
    CGRect frame = self.view.frame;
    NSInteger width = frame.size.width;
    NSInteger imageWidth = (width-4*space)/3;
    NSInteger imageHeight = imageWidth;
    
    for (int i=0; i<row; i++) {
        for (int j=0; j<column; j++) {
            
            CGRect imageFrame = CGRectMake(space+j*(space+imageWidth),topSpace+i*(space+imageHeight), imageWidth, imageHeight);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            [scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(frame.size.width/2-30, 10, 60, 30);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [scrollView addSubview:button];
    
    scrollView.contentSize = CGSizeMake(frame.size.width,topSpace+row*(space+imageHeight)+imageHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}
- (void)loadImage{
    
    for (int i=0; i<row*column; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [imageURL addObject:urlStr];
    }
    
    dispatch_queue_t serialQueue = dispatch_queue_create("rust_33SerialQueue", DISPATCH_QUEUE_SERIAL);
    
    for (int i=0;i<row*column;i++) {
        
        /* dispatch_sync(serialQueue, ^{
            
            [self loadImageAtIndex:i];
            
        }); */
        
        dispatch_async(serialQueue, ^{
            
            [self loadImageAtIndex:i];
            
        }); 
        
    }
    
}

- (void)loadImageAtIndex:(NSInteger)index
{
    NSString *str = [imageURL objectAtIndex:index];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *image = [UIImage imageWithData:data];
    
    [self updateImage:image atIndex:index];
    
}

- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index
{
    UIImageView *imageView = [imageViews objectAtIndex:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        imageView.image = image;
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
