//
//  ViewController4.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/5.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "ViewController4.h"
#define space 10
#define topSpace 60
#define column 3
#define row 4

@interface ViewController4 (){
    
    NSMutableArray *imageURL;
    NSMutableArray *imageViews;
    UIScrollView *scrollView;
}

@end

@implementation ViewController4

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
            imageView.layer.borderColor = [UIColor redColor].CGColor;
            imageView.layer.borderWidth = 2.0;
            [scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
    }
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(frame.size.width/2-30, 10, 60, 30);
    [button1 setTitle:@"加载图片" forState:UIControlStateNormal];
    [scrollView addSubview:button1];
    
    scrollView.contentSize = CGSizeMake(frame.size.width,topSpace+row*(space+imageHeight)+imageHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}

- (void)loadImage
{
    for (int i=0; i<row*column; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [imageURL addObject:urlStr];
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group,globalQueue, ^{
        
        for (int i=0; i<6; i++) {
            [self loadImageAtIndex:i];
        }
        
    });
    
    dispatch_group_async(group,globalQueue, ^{
        for (int i=3; i<9; i++) {
            [self loadImageAtIndex:i];
        }
    });
    
    dispatch_group_notify(group,globalQueue, ^{
        
        for (int i=9; i<12; i++) {
            [self loadImageAtIndex:i];
        }
    });
}

- (void)loadImageAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURL objectAtIndex:index]]]];
    UIImageView *imageView = [imageViews objectAtIndex:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        imageView.image = image;
        
    });
    
}
@end












